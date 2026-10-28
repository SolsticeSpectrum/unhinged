/* Trith standard library: HTTP/1.1 over plain sockets (no TLS: http:// only).
 * Client: trith_http_request sends one request and reads the whole response; its
 * status comes back, and the body and headers stay readable until the next request.
 * Server: Trith has no callbacks, so a server is a loop: trith_http_accept waits for
 * the next request and gives a handle, the trith_http_req_* functions read it, and
 * trith_http_respond answers it and closes the connection.
 * Bind with ⎔ and build with --include trith/lib/http.h --link trith/lib/http.c
 * (trith/lib/README.md). Strings come back in buffers that the next call of the same
 * kind reuses (the FFI glue copies them at once); NULL and −1 are failures, which ◌
 * bindings see as ◌. */
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

typedef struct {
    char *s;
    size_t n, cap;
} Buf;

static void buf_add(Buf *b, const char *s, size_t n) {
    if (b->n + n + 1 > b->cap) {
        b->cap = (b->n + n + 1) * 2;
        b->s = realloc(b->s, b->cap);
        if (!b->s) abort();
    }
    memcpy(b->s + b->n, s, n);
    b->n += n;
    b->s[b->n] = '\0';
}

static void buf_str(Buf *b, const char *s) {
    buf_add(b, s, strlen(s));
}

static char *errbuf;

static void set_error(const char *what) {
    free(errbuf);
    errbuf = strdup(what);
}

/* the last failure, in words ("" if none) */
const char *trith_http_error(void) {
    return errbuf ? errbuf : "";
}

static int send_all(int fd, const char *s, size_t n) {
    while (n > 0) {
        ssize_t k = send(fd, s, n, MSG_NOSIGNAL);
        if (k <= 0) {
            if (k < 0 && errno == EINTR) continue;
            return -1;
        }
        s += k;
        n -= (size_t)k;
    }
    return 0;
}

/* the value of header name in a block of "Name: value" lines (NULL if absent) */
static char *header_in(const char *head, const char *name) {
    size_t nlen = strlen(name);
    const char *line = strstr(head, "\r\n");
    while (line) {
        line += 2;
        if (strncasecmp(line, name, nlen) == 0 && line[nlen] == ':') {
            const char *v = line + nlen + 1;
            while (*v == ' ' || *v == '\t') v++;
            const char *end = strstr(v, "\r\n");
            if (!end) end = v + strlen(v);
            while (end > v && (end[-1] == ' ' || end[-1] == '\t')) end--;
            return strndup(v, (size_t)(end - v));
        }
        line = strstr(line, "\r\n");
    }
    return NULL;
}

/* the body after the head: chunked transfer coding decoded, else as it came */
static void decode_body(const char *head, const char *data, size_t n, Buf *body) {
    char *te = header_in(head, "Transfer-Encoding");
    int chunked = te && strcasestr(te, "chunked");
    free(te);
    if (!chunked) {
        buf_add(body, data, n);
        return;
    }
    size_t i = 0;
    while (i < n) {
        char *end;
        unsigned long len = strtoul(data + i, &end, 16);
        const char *crlf = strstr(data + i, "\r\n");
        if (!crlf || end == data + i) break;
        i = (size_t)(crlf - data) + 2;
        if (len == 0 || i + len > n) break;
        buf_add(body, data + i, len);
        i += len + 2;
    }
}

/* ---- client */

static int last_status;
static char *last_head;
static Buf last_body;

/* connect to host:port; −1 on failure (the error says why) */
static int dial(const char *host, const char *port) {
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
    if (fd < 0) set_error("cannot connect");
    return fd;
}

/* split http://host[:port][/path] */
static int split_url(const char *url, char *host, size_t hcap, char *port, size_t pcap, const char **path) {
    if (strncmp(url, "https://", 8) == 0) {
        set_error("https is not supported (no TLS)");
        return -1;
    }
    if (strncmp(url, "http://", 7) != 0) {
        set_error("the URL must start with http://");
        return -1;
    }
    const char *h = url + 7;
    const char *slash = strchr(h, '/');
    *path = slash ? slash : "/";
    size_t hlen = slash ? (size_t)(slash - h) : strlen(h);
    const char *colon = memchr(h, ':', hlen);
    size_t namelen = colon ? (size_t)(colon - h) : hlen;
    if (namelen == 0 || namelen >= hcap) {
        set_error("bad host in the URL");
        return -1;
    }
    memcpy(host, h, namelen);
    host[namelen] = '\0';
    if (colon) {
        size_t plen = hlen - namelen - 1;
        if (plen == 0 || plen >= pcap) {
            set_error("bad port in the URL");
            return -1;
        }
        memcpy(port, colon + 1, plen);
        port[plen] = '\0';
    } else {
        snprintf(port, pcap, "80");
    }
    return 0;
}

/* send a request and read the whole response; its status, or −1 on failure. headers are
 * extra "Name: value" lines separated by newlines ("" for none) */
int64_t trith_http_request(const char *method, const char *url, const char *headers, const char *body) {
    char host[256], port[16];
    const char *path;
    last_status = -1;
    free(last_head);
    last_head = NULL;
    last_body.n = 0;
    if (split_url(url, host, sizeof host, port, sizeof port, &path) < 0) return -1;
    int fd = dial(host, port);
    if (fd < 0) return -1;
    Buf req = {0};
    char line[512];
    snprintf(line, sizeof line, "%s %s HTTP/1.1\r\nHost: %s\r\nConnection: close\r\nContent-Length: %zu\r\n",
             method, path, host, strlen(body));
    buf_str(&req, line);
    for (const char *h = headers; *h;) {
        const char *nl = strchr(h, '\n');
        size_t len = nl ? (size_t)(nl - h) : strlen(h);
        if (len > 0 && h[len - 1] == '\r') len--;
        if (len > 0) {
            buf_add(&req, h, len);
            buf_str(&req, "\r\n");
        }
        h = nl ? nl + 1 : h + strlen(h);
    }
    buf_str(&req, "\r\n");
    buf_str(&req, body);
    if (send_all(fd, req.s, req.n) < 0) {
        free(req.s);
        close(fd);
        set_error("cannot send the request");
        return -1;
    }
    free(req.s);
    Buf resp = {0};
    char chunk[4096];
    ssize_t k;
    while ((k = recv(fd, chunk, sizeof chunk, 0)) > 0) buf_add(&resp, chunk, (size_t)k);
    close(fd);
    char *sep = resp.s ? strstr(resp.s, "\r\n\r\n") : NULL;
    if (!sep || strncmp(resp.s, "HTTP/", 5) != 0) {
        free(resp.s);
        set_error("no HTTP response");
        return -1;
    }
    const char *sp = strchr(resp.s, ' ');
    last_status = sp ? atoi(sp + 1) : -1;
    last_head = strndup(resp.s, (size_t)(sep - resp.s) + 2);
    decode_body(last_head, sep + 4, resp.n - (size_t)(sep + 4 - resp.s), &last_body);
    free(resp.s);
    set_error("");
    return last_status;
}

/* the body of the last response ("" before any) */
const char *trith_http_response_body(void) {
    return last_body.s ? last_body.s : "";
}

/* header name of the last response; NULL if it has none */
const char *trith_http_response_header(const char *name) {
    static char *v;
    free(v);
    v = last_head ? header_in(last_head, name) : NULL;
    return v;
}

/* GET url: the body when the status is 2xx; NULL otherwise */
const char *trith_http_get(const char *url) {
    int64_t st = trith_http_request("GET", url, "", "");
    return st >= 200 && st < 300 ? trith_http_response_body() : NULL;
}

/* ---- server */

typedef struct {
    int fd;
    char *method, *path, *head;
    Buf body;
} Req;

static Req *reqs;
static size_t nreqs;

/* listen on port (all interfaces); the server's handle, or −1 */
int64_t trith_http_listen(int64_t port) {
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

static void req_free(Req *r) {
    free(r->method);
    free(r->path);
    free(r->head);
    free(r->body.s);
    memset(r, 0, sizeof *r);
    r->fd = -1;
}

/* wait for the next request on server; its handle, or −1 */
int64_t trith_http_accept(int64_t server) {
    for (;;) {
        int fd = accept((int)server, NULL, NULL);
        if (fd < 0) {
            if (errno == EINTR) continue;
            set_error("cannot accept");
            return -1;
        }
        Buf in = {0};
        char chunk[4096];
        char *sep = NULL;
        ssize_t k;
        while (!sep && (k = recv(fd, chunk, sizeof chunk, 0)) > 0) {
            buf_add(&in, chunk, (size_t)k);
            sep = strstr(in.s, "\r\n\r\n");
        }
        if (!sep) {
            free(in.s);
            close(fd);
            continue;
        }
        size_t headlen = (size_t)(sep - in.s) + 2;
        char *head = strndup(in.s, headlen);
        char *cl = header_in(head, "Content-Length");
        size_t want = cl ? strtoul(cl, NULL, 10) : 0;
        free(cl);
        size_t have = in.n - headlen - 2;
        while (have < want && (k = recv(fd, chunk, sizeof chunk, 0)) > 0) {
            buf_add(&in, chunk, (size_t)k);
            have += (size_t)k;
        }
        size_t slot = 0;
        while (slot < nreqs && reqs[slot].fd >= 0) slot++;
        if (slot == nreqs) {
            reqs = realloc(reqs, ++nreqs * sizeof *reqs);
            if (!reqs) abort();
        }
        Req *r = &reqs[slot];
        memset(r, 0, sizeof *r);
        r->fd = fd;
        r->head = head;
        const char *sp1 = strchr(head, ' ');
        const char *sp2 = sp1 ? strchr(sp1 + 1, ' ') : NULL;
        r->method = sp1 ? strndup(head, (size_t)(sp1 - head)) : strdup("");
        r->path = sp2 ? strndup(sp1 + 1, (size_t)(sp2 - sp1 - 1)) : strdup("/");
        decode_body(head, in.s + headlen + 2, have < want ? have : want, &r->body);
        free(in.s);
        return (int64_t)slot;
    }
}

static Req *req_at(int64_t h) {
    return h >= 0 && (size_t)h < nreqs && reqs[h].fd >= 0 ? &reqs[h] : NULL;
}

/* the request's method (GET, POST, …); NULL for a bad handle */
const char *trith_http_req_method(int64_t req) {
    Req *r = req_at(req);
    return r ? r->method : NULL;
}

/* the request's path, query included */
const char *trith_http_req_path(int64_t req) {
    Req *r = req_at(req);
    return r ? r->path : NULL;
}

/* the request's body ("" if none) */
const char *trith_http_req_body(int64_t req) {
    Req *r = req_at(req);
    return r ? (r->body.s ? r->body.s : "") : NULL;
}

/* header name of the request; NULL if it has none */
const char *trith_http_req_header(int64_t req, const char *name) {
    static char *v;
    Req *r = req_at(req);
    free(v);
    v = r ? header_in(r->head, name) : NULL;
    return v;
}

static const char *reason(int64_t status) {
    switch (status) {
    case 200: return "OK";
    case 201: return "Created";
    case 204: return "No Content";
    case 301: return "Moved Permanently";
    case 302: return "Found";
    case 400: return "Bad Request";
    case 401: return "Unauthorized";
    case 403: return "Forbidden";
    case 404: return "Not Found";
    case 405: return "Method Not Allowed";
    case 500: return "Internal Server Error";
    default: return "Status";
    }
}

/* answer the request and close it: 0, or −1 if it could not be sent */
int64_t trith_http_respond(int64_t req, int64_t status, const char *content_type, const char *body) {
    Req *r = req_at(req);
    if (!r) {
        set_error("bad request handle");
        return -1;
    }
    char head[512];
    snprintf(head, sizeof head,
             "HTTP/1.1 %lld %s\r\nContent-Type: %s\r\nContent-Length: %zu\r\nConnection: close\r\n\r\n",
             (long long)status, reason(status), content_type, strlen(body));
    int ok = send_all(r->fd, head, strlen(head)) == 0 && send_all(r->fd, body, strlen(body)) == 0;
    close(r->fd);
    req_free(r);
    if (!ok) set_error("cannot send the response");
    return ok ? 0 : -1;
}

/* stop listening */
int64_t trith_http_close(int64_t server) {
    return close((int)server) == 0 ? 0 : -1;
}
