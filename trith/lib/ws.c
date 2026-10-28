/* Trith standard library: WebSocket (RFC 6455), plain (ws://) or over TLS (wss://, tls.inc).
 * A connection is a handle (its socket). Server: trith_ws_listen, then trith_ws_accept
 * waits for a client and completes the opening handshake (trith_ws_listen_tls serves wss
 * with a certificate and key). Client: trith_ws_connect.
 * Both sides then trith_ws_send and trith_ws_receive text messages and trith_ws_close.
 * trith_ws_receive answers pings, joins fragmented messages and returns NULL when the
 * peer closes. Frames a client sends are masked, as the protocol requires.
 * Bind with ⎔ and build with --include trith/lib/ws.h --link trith/lib/ws.c
 * --link -lssl --link -lcrypto (trith/lib/README.md). Strings come back in a buffer that the next call reuses (the
 * FFI glue copies them at once); NULL and −1 are failures, which ◌ bindings see as ◌. */
#include <arpa/inet.h>
#include <errno.h>
#include <netdb.h>
#include <netinet/in.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <sys/socket.h>
#include <unistd.h>

#include "tls.inc"

static char *errbuf;

static void set_error(const char *what) {
    free(errbuf);
    errbuf = strdup(what);
}

/* the last failure, in words ("" if none) */
const char *trith_ws_error(void) {
    return errbuf ? errbuf : "";
}

/* ---- SHA-1 and base64, for the handshake */

typedef struct {
    uint32_t state[5];
    uint64_t bitlen;
    uint8_t data[64];
    size_t datalen;
} Sha1;

static uint32_t rotl(uint32_t x, uint32_t n) {
    return (x << n) | (x >> (32 - n));
}

static void sha1_transform(Sha1 *ctx, const uint8_t data[64]) {
    uint32_t w[80];
    for (int i = 0; i < 16; i++)
        w[i] = (uint32_t)data[i * 4] << 24 | (uint32_t)data[i * 4 + 1] << 16 |
               (uint32_t)data[i * 4 + 2] << 8 | (uint32_t)data[i * 4 + 3];
    for (int i = 16; i < 80; i++) w[i] = rotl(w[i - 3] ^ w[i - 8] ^ w[i - 14] ^ w[i - 16], 1);
    uint32_t a = ctx->state[0], b = ctx->state[1], c = ctx->state[2], d = ctx->state[3], e = ctx->state[4];
    for (int i = 0; i < 80; i++) {
        uint32_t f, k;
        if (i < 20) {
            f = (b & c) | (~b & d);
            k = 0x5a827999;
        } else if (i < 40) {
            f = b ^ c ^ d;
            k = 0x6ed9eba1;
        } else if (i < 60) {
            f = (b & c) | (b & d) | (c & d);
            k = 0x8f1bbcdc;
        } else {
            f = b ^ c ^ d;
            k = 0xca62c1d6;
        }
        uint32_t t = rotl(a, 5) + f + e + k + w[i];
        e = d;
        d = c;
        c = rotl(b, 30);
        b = a;
        a = t;
    }
    ctx->state[0] += a;
    ctx->state[1] += b;
    ctx->state[2] += c;
    ctx->state[3] += d;
    ctx->state[4] += e;
}

static void sha1(const char *s, uint8_t hash[20]) {
    Sha1 ctx = {{0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476, 0xc3d2e1f0}, 0, {0}, 0};
    size_t len = strlen(s);
    for (size_t i = 0; i < len; i++) {
        ctx.data[ctx.datalen++] = (uint8_t)s[i];
        if (ctx.datalen == 64) {
            sha1_transform(&ctx, ctx.data);
            ctx.bitlen += 512;
            ctx.datalen = 0;
        }
    }
    size_t i = ctx.datalen;
    ctx.data[i++] = 0x80;
    if (i > 56) {
        while (i < 64) ctx.data[i++] = 0;
        sha1_transform(&ctx, ctx.data);
        i = 0;
    }
    while (i < 56) ctx.data[i++] = 0;
    ctx.bitlen += ctx.datalen * 8;
    for (int j = 0; j < 8; j++) ctx.data[56 + j] = (uint8_t)(ctx.bitlen >> (56 - 8 * j));
    sha1_transform(&ctx, ctx.data);
    for (int j = 0; j < 20; j++) hash[j] = (uint8_t)(ctx.state[j / 4] >> (24 - 8 * (j % 4)));
}

static void base64(const uint8_t *data, size_t len, char *out) {
    static const char tbl[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    size_t j = 0;
    for (size_t i = 0; i < len; i += 3) {
        unsigned v = (unsigned)data[i] << 16;
        if (i + 1 < len) v |= (unsigned)data[i + 1] << 8;
        if (i + 2 < len) v |= data[i + 2];
        out[j++] = tbl[(v >> 18) & 63];
        out[j++] = tbl[(v >> 12) & 63];
        out[j++] = i + 1 < len ? tbl[(v >> 6) & 63] : '=';
        out[j++] = i + 2 < len ? tbl[v & 63] : '=';
    }
    out[j] = '\0';
}

/* the Sec-WebSocket-Accept answer to key */
static void accept_for(const char *key, char out[29]) {
    char combo[256];
    uint8_t digest[20];
    snprintf(combo, sizeof combo, "%s258EAFA5-E914-47DA-95CA-C5AB0DC85B11", key);
    sha1(combo, digest);
    base64(digest, 20, out);
}

static void random_bytes(uint8_t *out, size_t n) {
    FILE *f = fopen("/dev/urandom", "rb");
    size_t got = f ? fread(out, 1, n, f) : 0;
    if (f) fclose(f);
    for (size_t i = got; i < n; i++) out[i] = (uint8_t)rand();
}

/* ---- sockets */

/* which handles are client ends (their frames are masked) */
static unsigned char *is_client;
static size_t nclient;

static void set_client(int fd, int v) {
    if ((size_t)fd >= nclient) {
        size_t n = (size_t)fd * 2 + 16;
        is_client = realloc(is_client, n);
        if (!is_client) abort();
        memset(is_client + nclient, 0, n - nclient);
        nclient = n;
    }
    is_client[fd] = (unsigned char)v;
}

static int send_all(int fd, const void *p, size_t n) {
    const char *s = p;
    while (n > 0) {
        ssize_t k = net_send(fd, s, n);
        if (k <= 0) return -1;
        s += k;
        n -= (size_t)k;
    }
    return 0;
}

static int recv_all(int fd, void *p, size_t n) {
    char *s = p;
    while (n > 0) {
        ssize_t k = net_recv(fd, s, n);
        if (k <= 0) return -1;
        s += k;
        n -= (size_t)k;
    }
    return 0;
}

/* read an HTTP head byte by byte, so no frame bytes are taken with it */
static int read_head(int fd, char *buf, size_t cap) {
    size_t n = 0;
    while (n + 1 < cap) {
        if (recv_all(fd, buf + n, 1) < 0) return -1;
        n++;
        buf[n] = '\0';
        if (n >= 4 && memcmp(buf + n - 4, "\r\n\r\n", 4) == 0) return 0;
    }
    return -1;
}

/* the value of header name in head, copied into out (0), or −1 if absent */
static int header_in(const char *head, const char *name, char *out, size_t cap) {
    size_t nlen = strlen(name);
    for (const char *line = strstr(head, "\r\n"); line; line = strstr(line, "\r\n")) {
        line += 2;
        if (strncasecmp(line, name, nlen) == 0 && line[nlen] == ':') {
            const char *v = line + nlen + 1;
            while (*v == ' ' || *v == '\t') v++;
            const char *end = strstr(v, "\r\n");
            while (end > v && (end[-1] == ' ' || end[-1] == '\t')) end--;
            size_t len = (size_t)(end - v);
            if (len >= cap) return -1;
            memcpy(out, v, len);
            out[len] = '\0';
            return 0;
        }
    }
    return -1;
}

/* ---- server */

/* listen on port (all interfaces); the server's handle, or −1 */
int64_t trith_ws_listen(int64_t port) {
    int fd = socket(AF_INET, SOCK_STREAM, 0);
    if (fd < 0) {
        set_error("cannot make a socket");
        return -1;
    }
    int one = 1;
    setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &one, sizeof one);
    struct sockaddr_in addr;
    memset(&addr, 0, sizeof addr);
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = htonl(INADDR_ANY);
    addr.sin_port = htons((uint16_t)port);
    if (bind(fd, (struct sockaddr *)&addr, sizeof addr) < 0 || listen(fd, 16) < 0) {
        close(fd);
        set_error("cannot listen on the port");
        return -1;
    }
    return fd;
}

/* listen on port and serve wss with the certificate chain and private key in the PEM
 * files cert and key; the server's handle, or −1 */
int64_t trith_ws_listen_tls(int64_t port, const char *cert, const char *key) {
    int64_t fd = trith_ws_listen(port);
    if (fd < 0) return -1;
    if (net_tls_listen((int)fd, cert, key) < 0) {
        net_close((int)fd);
        set_error(net_err);
        return -1;
    }
    return fd;
}

/* wait for a client and complete its handshake; the connection's handle, or −1 */
int64_t trith_ws_accept(int64_t server) {
    for (;;) {
        int fd = accept((int)server, NULL, NULL);
        if (fd < 0) {
            if (errno == EINTR) continue;
            set_error("cannot accept");
            return -1;
        }
        if (net_tls_accept((int)server, fd) < 0) {
            close(fd);
            continue;
        }
        char head[8192], key[128], answer[29], resp[256];
        if (read_head(fd, head, sizeof head) < 0 || header_in(head, "Sec-WebSocket-Key", key, sizeof key) < 0) {
            const char *bad = "HTTP/1.1 400 Bad Request\r\nContent-Length: 0\r\nConnection: close\r\n\r\n";
            send_all(fd, bad, strlen(bad));
            net_close(fd);
            continue;
        }
        accept_for(key, answer);
        snprintf(resp, sizeof resp,
                 "HTTP/1.1 101 Switching Protocols\r\nUpgrade: websocket\r\nConnection: Upgrade\r\n"
                 "Sec-WebSocket-Accept: %s\r\n\r\n",
                 answer);
        if (send_all(fd, resp, strlen(resp)) < 0) {
            net_close(fd);
            continue;
        }
        set_client(fd, 0);
        return fd;
    }
}

/* ---- client */

/* connect to ws[s]://host[:port][/path] and complete the handshake; the handle, or −1 */
int64_t trith_ws_connect(const char *url) {
    int tls = strncmp(url, "wss://", 6) == 0;
    if (!tls && strncmp(url, "ws://", 5) != 0) {
        set_error("the URL must start with ws:// or wss://");
        return -1;
    }
    const char *h = url + (tls ? 6 : 5);
    const char *slash = strchr(h, '/');
    const char *path = slash ? slash : "/";
    size_t hlen = slash ? (size_t)(slash - h) : strlen(h);
    const char *colon = memchr(h, ':', hlen);
    size_t namelen = colon ? (size_t)(colon - h) : hlen;
    char host[256], port[16];
    if (namelen == 0 || namelen >= sizeof host || (colon && hlen - namelen - 1 >= sizeof port)) {
        set_error("bad host in the URL");
        return -1;
    }
    memcpy(host, h, namelen);
    host[namelen] = '\0';
    if (colon) {
        memcpy(port, colon + 1, hlen - namelen - 1);
        port[hlen - namelen - 1] = '\0';
    } else {
        snprintf(port, sizeof port, tls ? "443" : "80");
    }
    struct addrinfo hints, *res = NULL;
    memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;
    if (getaddrinfo(host, port, &hints, &res) != 0) {
        set_error("cannot resolve the host");
        return -1;
    }
    int fd = -1;
    for (struct addrinfo *a = res; a; a = a->ai_next) {
        fd = socket(a->ai_family, a->ai_socktype, a->ai_protocol);
        if (fd < 0) continue;
        if (connect(fd, a->ai_addr, a->ai_addrlen) == 0) break;
        close(fd);
        fd = -1;
    }
    freeaddrinfo(res);
    if (fd < 0) {
        set_error("cannot connect");
        return -1;
    }
    if (tls && net_tls_connect(fd, host) < 0) {
        close(fd);
        set_error(net_err);
        return -1;
    }
    uint8_t raw[16];
    char key[25], want[29], got[64], req[1024], head[8192];
    random_bytes(raw, sizeof raw);
    base64(raw, sizeof raw, key);
    snprintf(req, sizeof req,
             "GET %s HTTP/1.1\r\nHost: %s:%s\r\nUpgrade: websocket\r\nConnection: Upgrade\r\n"
             "Sec-WebSocket-Key: %s\r\nSec-WebSocket-Version: 13\r\n\r\n",
             path, host, port, key);
    accept_for(key, want);
    if (send_all(fd, req, strlen(req)) < 0 || read_head(fd, head, sizeof head) < 0 ||
        strncmp(head, "HTTP/1.1 101", 12) != 0 || header_in(head, "Sec-WebSocket-Accept", got, sizeof got) < 0 ||
        strcmp(got, want) != 0) {
        net_close(fd);
        set_error("the handshake failed");
        return -1;
    }
    set_client(fd, 1);
    return fd;
}

/* ---- frames */

static int send_frame(int fd, unsigned opcode, const char *msg, size_t len) {
    unsigned char hdr[14];
    size_t hlen = 2;
    int masked = (size_t)fd < nclient && is_client[fd];
    hdr[0] = (unsigned char)(0x80 | opcode);
    hdr[1] = masked ? 0x80 : 0;
    if (len <= 125) {
        hdr[1] |= (unsigned char)len;
    } else if (len <= 65535) {
        hdr[1] |= 126;
        hdr[2] = (unsigned char)(len >> 8);
        hdr[3] = (unsigned char)len;
        hlen = 4;
    } else {
        hdr[1] |= 127;
        for (int i = 0; i < 8; i++) hdr[2 + i] = (unsigned char)((uint64_t)len >> (56 - 8 * i));
        hlen = 10;
    }
    char *body = (char *)msg;
    if (masked) {
        uint8_t mask[4];
        random_bytes(mask, 4);
        memcpy(hdr + hlen, mask, 4);
        hlen += 4;
        body = malloc(len + 1);
        if (!body) abort();
        for (size_t i = 0; i < len; i++) body[i] = (char)(msg[i] ^ mask[i % 4]);
    }
    int r = send_all(fd, hdr, hlen) == 0 && (len == 0 || send_all(fd, body, len) == 0) ? 0 : -1;
    if (masked) free(body);
    return r;
}

/* send a text message: 0, or −1 */
int64_t trith_ws_send(int64_t conn, const char *text) {
    if (send_frame((int)conn, 0x1, text, strlen(text)) < 0) {
        set_error("cannot send");
        return -1;
    }
    return 0;
}

#define MAX_MESSAGE (16u << 20)

/* the next message (text or binary); NULL when the peer closes or on failure */
const char *trith_ws_receive(int64_t conn) {
    static char *msg;
    static size_t cap;
    size_t n = 0;
    int fd = (int)conn;
    for (;;) {
        unsigned char hdr[2];
        if (recv_all(fd, hdr, 2) < 0) {
            set_error("the connection was lost");
            return NULL;
        }
        unsigned fin = hdr[0] & 0x80, opcode = hdr[0] & 0x0f;
        uint64_t len = hdr[1] & 0x7f;
        if (len >= 126) {
            unsigned char ext[8];
            size_t k = len == 126 ? 2 : 8;
            if (recv_all(fd, ext, k) < 0) {
                set_error("the connection was lost");
                return NULL;
            }
            len = 0;
            for (size_t i = 0; i < k; i++) len = len << 8 | ext[i];
        }
        uint8_t mask[4] = {0, 0, 0, 0};
        if ((hdr[1] & 0x80) && recv_all(fd, mask, 4) < 0) {
            set_error("the connection was lost");
            return NULL;
        }
        if (len > MAX_MESSAGE || n + len > MAX_MESSAGE) {
            set_error("the message is too long");
            return NULL;
        }
        char *payload = malloc((size_t)len + 1);
        if (!payload) abort();
        if (len > 0 && recv_all(fd, payload, (size_t)len) < 0) {
            free(payload);
            set_error("the connection was lost");
            return NULL;
        }
        for (uint64_t i = 0; i < len; i++) payload[i] ^= (char)mask[i % 4];
        if (opcode == 0x8) {
            send_frame(fd, 0x8, payload, len >= 2 ? 2 : 0);
            free(payload);
            set_error("closed");
            return NULL;
        }
        if (opcode == 0x9) send_frame(fd, 0xA, payload, (size_t)len);
        if (opcode == 0x0 || opcode == 0x1 || opcode == 0x2) {
            if (n + len + 1 > cap) {
                cap = (n + len + 1) * 2;
                msg = realloc(msg, cap);
                if (!msg) abort();
            }
            memcpy(msg + n, payload, (size_t)len);
            n += (size_t)len;
            msg[n] = '\0';
            if (fin) {
                free(payload);
                set_error("");
                return msg;
            }
        }
        free(payload);
    }
}

/* send a close frame and close the connection (or a server's listening socket) */
int64_t trith_ws_close(int64_t conn) {
    int fd = (int)conn;
    send_frame(fd, 0x8, "\x03\xe8", 2);
    if ((size_t)fd < nclient) is_client[fd] = 0;
    return net_close(fd) == 0 ? 0 : -1;
}
