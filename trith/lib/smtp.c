/* Trith standard library: sending mail over SMTP (plain sockets, no TLS or STARTTLS:
 * meant for a local relay or a submission port that accepts plain text).
 * trith_smtp_send speaks the whole conversation: EHLO, AUTH PLAIN when a user is given,
 * MAIL FROM, one RCPT TO per address, DATA with the headers and the dot-stuffed body,
 * QUIT. On failure trith_smtp_error has the step and the server's reply.
 * Bind with ⎔ and build with --include trith/lib/smtp.h --link trith/lib/smtp.c
 * (trith/lib/README.md). −1 is failure, which a ◌ℤ binding sees as ◌. */
#include <errno.h>
#include <netdb.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <time.h>
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

static char errbuf[1024];

/* the last failure, in words ("" if none) */
const char *trith_smtp_error(void) {
    return errbuf;
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

/* read one reply (all its lines) into line (its last line); its code, or −1 */
static int reply(int fd, char *line, size_t cap) {
    for (;;) {
        size_t n = 0;
        char c;
        for (;;) {
            ssize_t k = recv(fd, &c, 1, 0);
            if (k < 0 && errno == EINTR) continue;
            if (k <= 0) return -1;
            if (c == '\n') break;
            if (c != '\r' && n + 1 < cap) line[n++] = c;
        }
        line[n] = '\0';
        if (n < 3) return -1;
        if (n == 3 || line[3] == ' ') return atoi(line);
    }
}

/* send cmd (unless NULL) and expect a reply code starting with digit want */
static int step(int fd, const char *cmd, char want, const char *what) {
    char line[512];
    if (cmd && send_all(fd, cmd, strlen(cmd)) < 0) {
        snprintf(errbuf, sizeof errbuf, "%s: cannot send", what);
        return -1;
    }
    int code = reply(fd, line, sizeof line);
    if (code < 0) {
        snprintf(errbuf, sizeof errbuf, "%s: no reply", what);
        return -1;
    }
    if (line[0] != want) {
        snprintf(errbuf, sizeof errbuf, "%s: %s", what, line);
        return -1;
    }
    return 0;
}

static void base64(const unsigned char *data, size_t len, Buf *out) {
    static const char tbl[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    for (size_t i = 0; i < len; i += 3) {
        unsigned v = (unsigned)data[i] << 16;
        if (i + 1 < len) v |= (unsigned)data[i + 1] << 8;
        if (i + 2 < len) v |= data[i + 2];
        char q[4] = {tbl[(v >> 18) & 63], tbl[(v >> 12) & 63], i + 1 < len ? tbl[(v >> 6) & 63] : '=',
                     i + 2 < len ? tbl[v & 63] : '='};
        buf_add(out, q, 4);
    }
}

/* the address inside "Name <addr>", or the whole of it, trimmed */
static void bare_address(const char *s, size_t n, char *out, size_t cap) {
    const char *lt = memchr(s, '<', n);
    if (lt) {
        const char *gt = memchr(lt, '>', n - (size_t)(lt - s));
        if (gt) {
            s = lt + 1;
            n = (size_t)(gt - s);
        }
    }
    while (n > 0 && (*s == ' ' || *s == '\t')) s++, n--;
    while (n > 0 && (s[n - 1] == ' ' || s[n - 1] == '\t')) n--;
    if (n >= cap) n = cap - 1;
    memcpy(out, s, n);
    out[n] = '\0';
}

static int conversation(int fd, const char *user, const char *pass, const char *from, const char *to,
                        const char *subject, const char *body) {
    char cmd[1024], addr[512], host[256];
    if (step(fd, NULL, '2', "greeting") < 0) return -1;
    if (gethostname(host, sizeof host) != 0 || !host[0]) snprintf(host, sizeof host, "localhost");
    host[sizeof host - 1] = '\0';
    snprintf(cmd, sizeof cmd, "EHLO %s\r\n", host);
    if (step(fd, cmd, '2', "EHLO") < 0) return -1;
    if (*user) {
        Buf creds = {0}, b64 = {0};
        buf_add(&creds, "", 1);
        buf_str(&creds, user);
        buf_add(&creds, "", 1);
        buf_str(&creds, pass);
        buf_str(&b64, "AUTH PLAIN ");
        base64((const unsigned char *)creds.s, creds.n, &b64);
        buf_str(&b64, "\r\n");
        int r = step(fd, b64.s, '2', "AUTH");
        free(creds.s);
        free(b64.s);
        if (r < 0) return -1;
    }
    bare_address(from, strlen(from), addr, sizeof addr);
    snprintf(cmd, sizeof cmd, "MAIL FROM:<%s>\r\n", addr);
    if (step(fd, cmd, '2', "MAIL FROM") < 0) return -1;
    for (const char *p = to; *p;) {
        const char *comma = strchr(p, ',');
        size_t n = comma ? (size_t)(comma - p) : strlen(p);
        bare_address(p, n, addr, sizeof addr);
        if (*addr) {
            snprintf(cmd, sizeof cmd, "RCPT TO:<%s>\r\n", addr);
            if (step(fd, cmd, '2', "RCPT TO") < 0) return -1;
        }
        p = comma ? comma + 1 : p + n;
    }
    if (step(fd, "DATA\r\n", '3', "DATA") < 0) return -1;
    Buf msg = {0};
    char date[64];
    time_t now = time(NULL);
    strftime(date, sizeof date, "%a, %d %b %Y %H:%M:%S +0000", gmtime(&now));
    buf_str(&msg, "From: ");
    buf_str(&msg, from);
    buf_str(&msg, "\r\nTo: ");
    buf_str(&msg, to);
    buf_str(&msg, "\r\nSubject: ");
    buf_str(&msg, subject);
    buf_str(&msg, "\r\nDate: ");
    buf_str(&msg, date);
    buf_str(&msg, "\r\nMIME-Version: 1.0\r\nContent-Type: text/plain; charset=utf-8\r\n\r\n");
    /* lines end in CRLF, and a line that starts with a dot gets another */
    int start = 1;
    for (const char *p = body; *p; p++) {
        if (start && *p == '.') buf_add(&msg, ".", 1);
        start = 0;
        if (*p == '\n') {
            buf_str(&msg, "\r\n");
            start = 1;
        } else if (*p != '\r') {
            buf_add(&msg, p, 1);
        }
    }
    if (!start) buf_str(&msg, "\r\n");
    buf_str(&msg, ".\r\n");
    int r = step(fd, msg.s, '2', "message");
    free(msg.s);
    if (r < 0) return -1;
    step(fd, "QUIT\r\n", '2', "QUIT");
    errbuf[0] = '\0';
    return 0;
}

/* send a plain-text mail: 0, or −1. to is a comma-separated list of addresses; an empty
 * user skips authentication */
int64_t trith_smtp_send(const char *host, int64_t port, const char *user, const char *pass, const char *from,
                        const char *to, const char *subject, const char *body) {
    char portstr[16];
    snprintf(portstr, sizeof portstr, "%lld", (long long)port);
    struct addrinfo hints, *res = NULL;
    memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;
    if (getaddrinfo(host, portstr, &hints, &res) != 0) {
        snprintf(errbuf, sizeof errbuf, "cannot resolve the host");
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
        snprintf(errbuf, sizeof errbuf, "cannot connect");
        return -1;
    }
    errbuf[0] = '\0';
    int r = conversation(fd, user, pass, from, to, subject, body);
    if (r < 0) send_all(fd, "QUIT\r\n", 6);
    close(fd);
    return r;
}
