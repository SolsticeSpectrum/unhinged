#ifndef UNHINGED_RT_H
#define UNHINGED_RT_H

#include <stddef.h>

typedef enum {
    UH_NUM,
    UH_STR,
    UH_ARR,
    UH_DICT,
    UH_NULL
} UhTag;

struct UhValue;
typedef struct UhValue UhValue;
typedef struct UhDict UhDict;

typedef struct UhArray {
    UhValue *items;
    size_t len;
    size_t cap;
} UhArray;

struct UhValue {
    UhTag tag;
    double num;
    char *str;
    UhArray *arr;
    UhDict *dict;
};

typedef struct UhDictEntry {
    char *key;
    UhValue val;
} UhDictEntry;

typedef struct UhDict {
    UhDictEntry *items;
    size_t len;
    size_t cap;
} UhDict;

typedef struct UhVar {
    char *name;
    UhValue val;
    struct UhVar *next;
} UhVar;

typedef struct UhEnv {
    struct UhEnv *parent;
    UhVar *vars;
} UhEnv;

typedef struct {
    UhValue *items;
    size_t len;
    size_t cap;
} UhStack;

void uh_env_init(UhEnv *env, UhEnv *parent);
UhValue uh_env_get(UhEnv *env, const char *name);
void uh_env_set(UhEnv *env, const char *name, UhValue val);

void uh_stack_init(UhStack *st);
void uh_stack_push(UhStack *st, UhValue val);
UhValue uh_stack_pop(UhStack *st);
void uh_stack_clear(UhStack *st);

UhValue uh_num(double n);
UhValue uh_str(const char *s);
UhValue uh_null(void);
UhValue uh_arr_new(void);
void uh_arr_push(UhValue *arr, UhValue val);
UhValue uh_arr_get(UhValue arr, long idx);
size_t uh_arr_len(UhValue arr);
UhValue uh_dict_new(void);
UhValue uh_dict_get(UhValue dict, UhValue key);
void uh_dict_set(UhValue *dict, UhValue key, UhValue val);
int uh_contains(UhValue collection, UhValue item);
UhValue uh_index(UhValue collection, UhValue key);
void uh_store_index(UhValue *collection, UhValue key, UhValue val);
UhValue uh_len(UhValue v);
UhValue uh_append(UhValue arr, UhValue val);
UhValue uh_split(UhValue str, UhValue delim);
UhValue uh_join(UhValue arr, UhValue delim);
UhValue uh_substr(UhValue str, UhValue start, UhValue len);
UhValue uh_char_at(UhValue str, UhValue idx);
UhValue uh_read_file(UhValue path);
UhValue uh_write_file(UhValue path, UhValue content);
UhValue uh_file_open(UhValue path, UhValue mode);
UhValue uh_file_read(UhValue file);
UhValue uh_file_readall(UhValue file);
UhValue uh_file_readlines(UhValue file);
UhValue uh_file_write(UhValue file, UhValue content);
UhValue uh_file_close(UhValue file);
UhValue uh_syscall(UhValue cmd);
UhValue uh_concat(UhValue a, UhValue b);
UhValue uh_add(UhValue a, UhValue b);
UhValue uh_sub(UhValue a, UhValue b);
UhValue uh_mul(UhValue a, UhValue b);
UhValue uh_div(UhValue a, UhValue b);
UhValue uh_stringify(UhValue v);
UhValue uh_type(UhValue v);
UhValue uh_int(UhValue v);
UhValue uh_float(UhValue v);
UhValue uh_upper(UhValue v);
UhValue uh_lower(UhValue v);
UhValue uh_index_of(UhValue str, UhValue needle);
UhValue uh_starts_with(UhValue str, UhValue prefix);
UhValue uh_match(UhValue str, UhValue pattern);
UhValue uh_chunk(UhValue arr, UhValue size);
UhValue uh_format(UhValue v);
UhValue uh_hex(UhValue v);
UhValue uh_time_now(void);
UhValue uh_pow(UhValue a, UhValue b);
UhValue uh_take(UhValue v, UhValue n);
UhValue uh_drop(UhValue v, UhValue n);
UhValue uh_reverse(UhValue v);
UhValue uh_rotate(UhValue v, UhValue n);
UhValue uh_reshape(UhValue v, UhValue rows, UhValue cols);
UhValue uh_transpose(UhValue v);
int uh_subset(UhValue a, UhValue b, int proper);

int uh_is_true(UhValue v);
void uh_print(UhValue v);
int uh_value_eq(UhValue a, UhValue b);
int uh_cmp(UhValue a, UhValue b);

void uh_set_args(int argc, char **argv);
void uh_set_global_env(UhEnv *env);
UhValue uh_args(void);
UhValue uh_import(UhValue path);
UhValue uh_sysobj(void);
UhValue uh_call_named(UhEnv *env, const char *name, int argc, UhValue *args);
UhValue uh_json_parse(UhValue str);
UhValue uh_json_stringify(UhValue v);

UhValue uh_http_get(UhValue cfg);
UhValue uh_http_request(UhValue cfg);
UhValue uh_http_handle(UhValue path, UhValue handler);
UhValue uh_http_listen(UhValue addr);
UhValue uh_http_method(UhValue req);
UhValue uh_http_json(UhValue payload, UhValue target);

UhValue uh_db_connect(UhValue cfg);
UhValue uh_db_exec(UhValue sql, UhValue conn);
UhValue uh_db_query(UhValue sql, UhValue conn);
UhValue uh_db_begin(UhValue conn);
UhValue uh_db_commit(UhValue conn);

UhValue uh_thread_start(UhValue arg, UhValue fn);
UhValue uh_thread_join(UhValue thr);
UhValue uh_mutex_lock(UhValue m);
UhValue uh_mutex_unlock(UhValue m);

UhValue uh_ws_serve(UhValue cfg);
UhValue uh_ws_connect(UhValue cfg);
UhValue uh_ws_receive(UhValue conn);
UhValue uh_send(UhValue payload, UhValue target);

UhValue uh_smtp_connect(UhValue cfg);
UhValue uh_smtp_disconnect(UhValue client);

UhValue uh_crypto_sha256(UhValue v);
UhValue uh_crypto_random_bytes(UhValue n);
UhValue uh_crypto_hmac_sha256(UhValue msg, UhValue key);
UhValue uh_crypto_encrypt_aes(UhValue plaintext, UhValue key);
UhValue uh_crypto_decrypt_aes(UhValue ciphertext, UhValue key);

#endif
