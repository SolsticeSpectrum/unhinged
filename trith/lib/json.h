/* Trith standard library: JSON. See json.c and trith/lib/README.md. */
#include <stdint.h>
const char *trith_json_get(const char *json, const char *path);
int64_t trith_json_type(const char *json, const char *path);
int64_t trith_json_len(const char *json, const char *path);
const char *trith_json_key(const char *json, const char *path, int64_t i);
const char *trith_json_set(const char *json, const char *path, const char *value);
const char *trith_json_quote(const char *s);
const char *trith_json_compact(const char *json);
const char *trith_json_at(const char *json, const char *path, int64_t i);
int64_t trith_json_bool(const char *json, const char *path);
