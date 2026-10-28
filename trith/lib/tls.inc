/* Trith standard library: the TLS layer of http.c, ws.c and smtp.c (OpenSSL 1.1.1 or 3).
 * Each of them #includes this file, so every function here is static. A connection stays
 * a socket descriptor: a table maps the descriptor to its TLS session, if it has one,
 * and a listening socket to the certificate it serves. net_send, net_recv and net_close
 * work on either kind, so the protocol code above them is the same for both.
 * A client verifies the server against the system's trusted certificates (OpenSSL's
 * default paths; SSL_CERT_FILE or SSL_CERT_DIR choose others) and the host name, or the
 * IP address, it dialled. TLS 1.2 is the oldest version accepted.
 * A program that links one of these modules also links OpenSSL:
 * --link -lssl --link -lcrypto (trith/lib/README.md). */
#include <errno.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <openssl/err.h>
#include <openssl/ssl.h>
#include <openssl/x509v3.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

/* why the last TLS step failed */
static char net_err[512];

static SSL **net_ssl;     /* by descriptor: its TLS session, or NULL */
static SSL_CTX **net_srv; /* by descriptor: a TLS server's context, or NULL */
static size_t net_cap;

static int net_slot(int fd) {
    if (fd < 0) return -1;
    if ((size_t)fd >= net_cap) {
        size_t n = (size_t)fd * 2 + 16;
        SSL **a = realloc(net_ssl, n * sizeof *a);
        if (!a) return -1;
        net_ssl = a;
        SSL_CTX **b = realloc(net_srv, n * sizeof *b);
        if (!b) return -1;
        net_srv = b;
        memset(net_ssl + net_cap, 0, (n - net_cap) * sizeof *a);
        memset(net_srv + net_cap, 0, (n - net_cap) * sizeof *b);
        net_cap = n;
    }
    return 0;
}

static SSL *net_tls_of(int fd) {
    return fd >= 0 && (size_t)fd < net_cap ? net_ssl[fd] : NULL;
}

/* the reason OpenSSL gives for the last failure, after what */
static void net_fail(const char *what) {
    unsigned long e = ERR_get_error();
    if (e) {
        char r[256];
        ERR_error_string_n(e, r, sizeof r);
        snprintf(net_err, sizeof net_err, "%s: %s", what, r);
    } else {
        snprintf(net_err, sizeof net_err, "%s", what);
    }
    ERR_clear_error();
}

/* writing to a peer that has gone raises SIGPIPE, which would kill the program; send()
 * avoids it with MSG_NOSIGNAL, but OpenSSL writes with write(), so ignore the signal
 * unless the program has a handler of its own */
static void net_nopipe(void) {
    struct sigaction sa;
    if (sigaction(SIGPIPE, NULL, &sa) == 0 && sa.sa_handler == SIG_DFL) signal(SIGPIPE, SIG_IGN);
}

static SSL_CTX *net_client_ctx;

/* start TLS as a client on a connected socket: 0, or −1 (net_err says why). host is what
 * was dialled; the certificate must be for it */
static int net_tls_connect(int fd, const char *host) {
    net_nopipe();
    if (net_slot(fd) < 0) {
        snprintf(net_err, sizeof net_err, "out of memory");
        return -1;
    }
    if (!net_client_ctx) {
        SSL_CTX *ctx = SSL_CTX_new(TLS_client_method());
        if (!ctx) {
            net_fail("TLS is unavailable");
            return -1;
        }
        SSL_CTX_set_min_proto_version(ctx, TLS1_2_VERSION);
        SSL_CTX_set_verify(ctx, SSL_VERIFY_PEER, NULL);
        SSL_CTX_set_default_verify_paths(ctx);
        net_client_ctx = ctx;
    }
    SSL *ssl = SSL_new(net_client_ctx);
    if (!ssl) {
        net_fail("TLS is unavailable");
        return -1;
    }
    unsigned char ip[16];
    int is_ip = inet_pton(AF_INET, host, ip) == 1 || inet_pton(AF_INET6, host, ip) == 1;
    if (is_ip) {
        X509_VERIFY_PARAM_set1_ip_asc(SSL_get0_param(ssl), host);
    } else {
        SSL_set_tlsext_host_name(ssl, host);
        SSL_set1_host(ssl, host);
    }
    SSL_set_fd(ssl, fd);
    int r;
    while ((r = SSL_connect(ssl)) <= 0 && SSL_get_error(ssl, r) == SSL_ERROR_SYSCALL && errno == EINTR) {
    }
    if (r <= 0) {
        long v = SSL_get_verify_result(ssl);
        if (v != X509_V_OK) {
            snprintf(net_err, sizeof net_err, "TLS: the server's certificate is not trusted (%s)",
                     X509_verify_cert_error_string(v));
            ERR_clear_error();
        } else {
            net_fail("TLS handshake failed");
        }
        SSL_free(ssl);
        return -1;
    }
    net_ssl[fd] = ssl;
    return 0;
}

/* make a listening socket a TLS server with a certificate chain and key (PEM files):
 * 0, or −1 */
static int net_tls_listen(int fd, const char *cert, const char *key) {
    net_nopipe();
    if (net_slot(fd) < 0) {
        snprintf(net_err, sizeof net_err, "out of memory");
        return -1;
    }
    SSL_CTX *ctx = SSL_CTX_new(TLS_server_method());
    if (!ctx) {
        net_fail("TLS is unavailable");
        return -1;
    }
    SSL_CTX_set_min_proto_version(ctx, TLS1_2_VERSION);
    if (SSL_CTX_use_certificate_chain_file(ctx, cert) != 1) {
        net_fail("cannot load the certificate");
        SSL_CTX_free(ctx);
        return -1;
    }
    if (SSL_CTX_use_PrivateKey_file(ctx, key, SSL_FILETYPE_PEM) != 1 || SSL_CTX_check_private_key(ctx) != 1) {
        net_fail("cannot load the private key");
        SSL_CTX_free(ctx);
        return -1;
    }
    net_srv[fd] = ctx;
    return 0;
}

/* after accept(): if the server is a TLS one, the handshake on fd: 0, or −1 */
static int net_tls_accept(int server, int fd) {
    SSL_CTX *ctx = server >= 0 && (size_t)server < net_cap ? net_srv[server] : NULL;
    if (!ctx) return 0;
    if (net_slot(fd) < 0) {
        snprintf(net_err, sizeof net_err, "out of memory");
        return -1;
    }
    SSL *ssl = SSL_new(ctx);
    if (!ssl) {
        net_fail("TLS is unavailable");
        return -1;
    }
    SSL_set_fd(ssl, fd);
    int r;
    while ((r = SSL_accept(ssl)) <= 0 && SSL_get_error(ssl, r) == SSL_ERROR_SYSCALL && errno == EINTR) {
    }
    if (r <= 0) {
        net_fail("TLS handshake failed");
        SSL_free(ssl);
        return -1;
    }
    net_ssl[fd] = ssl;
    return 0;
}

/* like recv(fd, p, n, 0): the bytes read, 0 when the peer has closed, −1 on failure */
static ssize_t net_recv(int fd, void *p, size_t n) {
    SSL *ssl = net_tls_of(fd);
    for (;;) {
        if (!ssl) {
            ssize_t k = recv(fd, p, n, 0);
            if (k < 0 && errno == EINTR) continue;
            return k;
        }
        int k = SSL_read(ssl, p, n > 0x40000000 ? 0x40000000 : (int)n);
        if (k > 0) return k;
        int e = SSL_get_error(ssl, k);
        if (e == SSL_ERROR_ZERO_RETURN) return 0;
        if (e == SSL_ERROR_SYSCALL && errno == EINTR) continue;
        /* a peer that closes without a close_notify still ends the stream; HTTP with
         * Connection: close and SMTP know where their messages end */
        if (e == SSL_ERROR_SYSCALL && ERR_peek_error() == 0) return 0;
        ERR_clear_error();
        return -1;
    }
}

/* like send(fd, p, n, MSG_NOSIGNAL): the bytes written, or −1 */
static ssize_t net_send(int fd, const void *p, size_t n) {
    SSL *ssl = net_tls_of(fd);
    for (;;) {
        if (!ssl) {
            ssize_t k = send(fd, p, n, MSG_NOSIGNAL);
            if (k < 0 && errno == EINTR) continue;
            return k;
        }
        if (n == 0) return 0;
        int k = SSL_write(ssl, p, n > 0x40000000 ? 0x40000000 : (int)n);
        if (k > 0) return k;
        if (SSL_get_error(ssl, k) == SSL_ERROR_SYSCALL && errno == EINTR) continue;
        ERR_clear_error();
        return -1;
    }
}

/* end the TLS session, if any (and a server's certificate), then close the socket */
static int net_close(int fd) {
    SSL *ssl = net_tls_of(fd);
    if (ssl) {
        SSL_shutdown(ssl);
        SSL_free(ssl);
        net_ssl[fd] = NULL;
        ERR_clear_error();
    }
    if (fd >= 0 && (size_t)fd < net_cap && net_srv[fd]) {
        SSL_CTX_free(net_srv[fd]);
        net_srv[fd] = NULL;
    }
    return close(fd);
}
