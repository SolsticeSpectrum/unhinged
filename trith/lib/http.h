/* Trith standard library: HTTP/1.1 client and server, plain or over TLS.
   See http.c and trith/lib/README.md. */
#include <stdint.h>
const char *trith_http_error(void);
int64_t trith_http_request(const char *method, const char *url, const char *headers, const char *body);
const char *trith_http_response_body(void);
const char *trith_http_response_header(const char *name);
const char *trith_http_get(const char *url);
int64_t trith_http_listen(int64_t port);
int64_t trith_http_accept(int64_t server);
const char *trith_http_req_method(int64_t req);
const char *trith_http_req_path(int64_t req);
const char *trith_http_req_body(int64_t req);
const char *trith_http_req_header(int64_t req, const char *name);
int64_t trith_http_respond(int64_t req, int64_t status, const char *content_type, const char *body);
int64_t trith_http_close(int64_t server);
int64_t trith_http_listen_tls(int64_t port, const char *cert, const char *key);
