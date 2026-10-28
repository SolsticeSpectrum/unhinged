/* Trith standard library: SMTP. See smtp.c and trith/lib/README.md. */
#include <stdint.h>
const char *trith_smtp_error(void);
int64_t trith_smtp_send(const char *host, int64_t port, const char *user, const char *pass, const char *from,
                        const char *to, const char *subject, const char *body);
