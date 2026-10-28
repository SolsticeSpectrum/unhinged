/* Trith standard library: WebSocket, plain or over TLS. See ws.c and trith/lib/README.md. */
#include <stdint.h>
const char *trith_ws_error(void);
int64_t trith_ws_listen(int64_t port);
int64_t trith_ws_accept(int64_t server);
int64_t trith_ws_connect(const char *url);
int64_t trith_ws_send(int64_t conn, const char *text);
const char *trith_ws_receive(int64_t conn);
int64_t trith_ws_close(int64_t conn);
int64_t trith_ws_listen_tls(int64_t port, const char *cert, const char *key);
