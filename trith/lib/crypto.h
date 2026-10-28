/* Trith standard library: crypto. See crypto.c and trith/lib/README.md. */
#include <stdint.h>
const char *trith_sha256(const char *s);
const char *trith_hmac_sha256(const char *msg, const char *key);
const char *trith_random_hex(int64_t n);
const char *trith_aes_encrypt(const char *text, const char *key);
const char *trith_aes_decrypt(const char *hex, const char *key);
