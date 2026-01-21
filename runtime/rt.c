#include "rt.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <ctype.h>
#include <stdint.h>
#include <regex.h>
#include <time.h>
#include <pthread.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <sys/stat.h>
#include <unistd.h>
#include <curl/curl.h>
#include <sqlite3.h>

static char *uh_strdup(const char *s) {
    if (s == NULL) {
        return NULL;
    }
    size_t len = strlen(s);
    char *out = (char *)malloc(len + 1);
    if (out == NULL) {
        return NULL;
    }
    memcpy(out, s, len + 1);
    return out;
}

static size_t utf8_advance(const char *s, size_t i) {
    unsigned char c = (unsigned char)s[i];
    if (c < 0x80) return 1;
    if ((c & 0xE0) == 0xC0) return 2;
    if ((c & 0xF0) == 0xE0) return 3;
    if ((c & 0xF8) == 0xF0) return 4;
    return 1;
}

static size_t utf8_len(const char *s) {
    size_t count = 0;
    for (size_t i = 0; s[i] != '\0';) {
        i += utf8_advance(s, i);
        count++;
    }
    return count;
}

static size_t utf8_index_to_byte(const char *s, long idx) {
    if (idx < 0) {
        size_t len = utf8_len(s);
        idx = (long)len + idx;
    }
    if (idx < 0) return (size_t)-1;
    size_t pos = 0;
    long cur = 0;
    while (s[pos] != '\0') {
        if (cur == idx) return pos;
        pos += utf8_advance(s, pos);
        cur++;
    }
    if (cur == idx) return pos;
    return (size_t)-1;
}

void uh_env_init(UhEnv *env, UhEnv *parent) {
    env->parent = parent;
    env->vars = NULL;
}

static UhVar *uh_env_find(UhEnv *env, const char *name) {
    for (UhVar *cur = env->vars; cur != NULL; cur = cur->next) {
        if (strcmp(cur->name, name) == 0) {
            return cur;
        }
    }
    return NULL;
}

UhValue uh_env_get(UhEnv *env, const char *name) {
    for (UhEnv *cur = env; cur != NULL; cur = cur->parent) {
        UhVar *var = uh_env_find(cur, name);
        if (var != NULL) {
            return var->val;
        }
    }
    return uh_num(0);
}

void uh_env_set(UhEnv *env, const char *name, UhValue val) {
    UhVar *var = uh_env_find(env, name);
    if (var != NULL) {
        var->val = val;
        return;
    }
    UhVar *node = (UhVar *)malloc(sizeof(UhVar));
    node->name = uh_strdup(name);
    node->val = val;
    node->next = env->vars;
    env->vars = node;
}

void uh_stack_init(UhStack *st) {
    st->items = NULL;
    st->len = 0;
    st->cap = 0;
}

void uh_stack_push(UhStack *st, UhValue val) {
    if (st->len == st->cap) {
        size_t new_cap = st->cap ? st->cap * 2 : 16;
        st->items = (UhValue *)realloc(st->items, new_cap * sizeof(UhValue));
        st->cap = new_cap;
    }
    st->items[st->len++] = val;
}

UhValue uh_stack_pop(UhStack *st) {
    if (st->len == 0) {
        return uh_num(0);
    }
    return st->items[--st->len];
}

void uh_stack_clear(UhStack *st) {
    st->len = 0;
}

UhValue uh_num(double n) {
    UhValue v;
    v.tag = UH_NUM;
    v.num = n;
    v.str = NULL;
    v.arr = NULL;
    v.dict = NULL;
    return v;
}

UhValue uh_str(const char *s) {
    UhValue v;
    v.tag = UH_STR;
    v.num = 0;
    v.str = uh_strdup(s);
    v.arr = NULL;
    v.dict = NULL;
    return v;
}

UhValue uh_null(void) {
    UhValue v;
    v.tag = UH_NULL;
    v.num = 0;
    v.str = NULL;
    v.arr = NULL;
    v.dict = NULL;
    return v;
}

UhValue uh_arr_new(void) {
    UhValue v;
    v.tag = UH_ARR;
    v.num = 0;
    v.str = NULL;
    v.arr = (UhArray *)malloc(sizeof(UhArray));
    v.dict = NULL;
    if (v.arr) {
        v.arr->items = NULL;
        v.arr->len = 0;
        v.arr->cap = 0;
    }
    return v;
}

void uh_arr_push(UhValue *arr, UhValue val) {
    if (arr == NULL || arr->tag != UH_ARR || arr->arr == NULL) {
        return;
    }
    UhArray *a = arr->arr;
    if (a->len == a->cap) {
        size_t new_cap = a->cap ? a->cap * 2 : 8;
        a->items = (UhValue *)realloc(a->items, new_cap * sizeof(UhValue));
        a->cap = new_cap;
    }
    a->items[a->len++] = val;
}

UhValue uh_arr_get(UhValue arr, long idx) {
    if (arr.tag != UH_ARR || arr.arr == NULL) {
        return uh_null();
    }
    if (idx < 0) {
        idx = (long)arr.arr->len + idx;
    }
    if (idx < 0 || (size_t)idx >= arr.arr->len) {
        return uh_null();
    }
    return arr.arr->items[idx];
}

size_t uh_arr_len(UhValue arr) {
    if (arr.tag != UH_ARR || arr.arr == NULL) {
        return 0;
    }
    return arr.arr->len;
}

UhValue uh_dict_new(void) {
    UhValue v;
    v.tag = UH_DICT;
    v.num = 0;
    v.str = NULL;
    v.arr = NULL;
    v.dict = (UhDict *)malloc(sizeof(UhDict));
    if (v.dict) {
        v.dict->items = NULL;
        v.dict->len = 0;
        v.dict->cap = 0;
    }
    return v;
}

static UhDictEntry *uh_dict_find(UhDict *dict, const char *key) {
    if (dict == NULL || key == NULL) {
        return NULL;
    }
    for (size_t i = 0; i < dict->len; i++) {
        if (strcmp(dict->items[i].key, key) == 0) {
            return &dict->items[i];
        }
    }
    return NULL;
}

static char *uh_key_string(UhValue key) {
    if (key.tag == UH_STR) {
        return uh_strdup(key.str ? key.str : "");
    }
    return NULL;
}

UhValue uh_dict_get(UhValue dict, UhValue key) {
    if (dict.tag != UH_DICT || dict.dict == NULL) {
        return uh_null();
    }
    char *k = uh_key_string(key);
    if (k == NULL) {
        return uh_null();
    }
    UhDictEntry *entry = uh_dict_find(dict.dict, k);
    free(k);
    if (entry == NULL) {
        return uh_null();
    }
    return entry->val;
}

static UhValue uh_dict_get_key(UhValue dict, const char *key) {
    if (dict.tag != UH_DICT || dict.dict == NULL || key == NULL) {
        return uh_null();
    }
    UhDictEntry *entry = uh_dict_find(dict.dict, key);
    if (!entry) {
        return uh_null();
    }
    return entry->val;
}

static const char *uh_dict_get_str(UhValue dict, const char *key) {
    UhValue v = uh_dict_get_key(dict, key);
    if (v.tag == UH_STR && v.str) {
        return v.str;
    }
    return NULL;
}

void uh_dict_set(UhValue *dict, UhValue key, UhValue val) {
    if (dict == NULL || dict->tag != UH_DICT || dict->dict == NULL) {
        return;
    }
    char *k = uh_key_string(key);
    if (k == NULL) {
        return;
    }
    UhDictEntry *entry = uh_dict_find(dict->dict, k);
    if (entry != NULL) {
        entry->val = val;
        free(k);
        return;
    }
    UhDict *d = dict->dict;
    if (d->len == d->cap) {
        size_t new_cap = d->cap ? d->cap * 2 : 8;
        d->items = (UhDictEntry *)realloc(d->items, new_cap * sizeof(UhDictEntry));
        d->cap = new_cap;
    }
    d->items[d->len].key = k;
    d->items[d->len].val = val;
    d->len++;
}

static void uh_buf_append(char **buf, size_t *len, size_t *cap, const char *s) {
    size_t slen = strlen(s);
    size_t need = *len + slen + 1;
    if (need > *cap) {
        size_t new_cap = *cap ? *cap * 2 : 64;
        while (new_cap < need) {
            new_cap *= 2;
        }
        *buf = (char *)realloc(*buf, new_cap);
        *cap = new_cap;
    }
    memcpy(*buf + *len, s, slen + 1);
    *len += slen;
}

static void uh_buf_appendn(char **buf, size_t *len, size_t *cap, const char *s, size_t n) {
    size_t need = *len + n + 1;
    if (need > *cap) {
        size_t new_cap = *cap ? *cap * 2 : 64;
        while (new_cap < need) {
            new_cap *= 2;
        }
        *buf = (char *)realloc(*buf, new_cap);
        *cap = new_cap;
    }
    memcpy(*buf + *len, s, n);
    *len += n;
    (*buf)[*len] = '\0';
}

static char *uh_value_to_cstr(UhValue v) {
    char tmp[64];
    if (v.tag == UH_STR) {
        return uh_strdup(v.str ? v.str : "");
    }
    if (v.tag == UH_NUM) {
        snprintf(tmp, sizeof(tmp), "%g", v.num);
        return uh_strdup(tmp);
    }
    if (v.tag == UH_ARR && v.arr) {
        char *buf = NULL;
        size_t len = 0;
        size_t cap = 0;
        uh_buf_append(&buf, &len, &cap, "[");
        for (size_t i = 0; i < v.arr->len; i++) {
            char *elem = uh_value_to_cstr(v.arr->items[i]);
            uh_buf_append(&buf, &len, &cap, elem ? elem : "");
            free(elem);
            if (i + 1 < v.arr->len) {
                uh_buf_append(&buf, &len, &cap, " ");
            }
        }
        uh_buf_append(&buf, &len, &cap, "]");
        return buf;
    }
    if (v.tag == UH_DICT && v.dict) {
        char *buf = NULL;
        size_t len = 0;
        size_t cap = 0;
        uh_buf_append(&buf, &len, &cap, "{");
        for (size_t i = 0; i < v.dict->len; i++) {
            uh_buf_append(&buf, &len, &cap, v.dict->items[i].key);
            uh_buf_append(&buf, &len, &cap, ":");
            char *elem = uh_value_to_cstr(v.dict->items[i].val);
            uh_buf_append(&buf, &len, &cap, elem ? elem : "");
            free(elem);
            if (i + 1 < v.dict->len) {
                uh_buf_append(&buf, &len, &cap, ",");
            }
        }
        uh_buf_append(&buf, &len, &cap, "}");
        return buf;
    }
    return uh_strdup("");
}

UhValue uh_len(UhValue v) {
    if (v.tag == UH_STR && v.str) {
        return uh_num((double)utf8_len(v.str));
    }
    if (v.tag == UH_ARR && v.arr) {
        return uh_num((double)v.arr->len);
    }
    if (v.tag == UH_DICT && v.dict) {
        return uh_num((double)v.dict->len);
    }
    return uh_num(0);
}

UhValue uh_append(UhValue arr, UhValue val) {
    if (arr.tag != UH_ARR || arr.arr == NULL) {
        return arr;
    }
    uh_arr_push(&arr, val);
    return arr;
}

UhValue uh_split(UhValue str, UhValue delim) {
    UhValue out = uh_arr_new();
    if (str.tag != UH_STR || str.str == NULL || out.arr == NULL) {
        return out;
    }
    const char *d = (delim.tag == UH_STR && delim.str) ? delim.str : "";
    if (d[0] == '\0') {
        for (const char *p = str.str; *p; p++) {
            char tmp[2] = { *p, '\0' };
            uh_arr_push(&out, uh_str(tmp));
        }
        return out;
    }
    const char *start = str.str;
    const char *pos = NULL;
    size_t dlen = strlen(d);
    while ((pos = strstr(start, d)) != NULL) {
        size_t len = (size_t)(pos - start);
        char *piece = (char *)malloc(len + 1);
        if (piece) {
            memcpy(piece, start, len);
            piece[len] = '\0';
            uh_arr_push(&out, uh_str(piece));
            free(piece);
        }
        start = pos + dlen;
    }
    uh_arr_push(&out, uh_str(start));
    return out;
}

UhValue uh_join(UhValue arr, UhValue delim) {
    if (arr.tag != UH_ARR || arr.arr == NULL) {
        return uh_str("");
    }
    const char *d = (delim.tag == UH_STR && delim.str) ? delim.str : "";
    char *buf = NULL;
    size_t len = 0;
    size_t cap = 0;
    for (size_t i = 0; i < arr.arr->len; i++) {
        char *elem = uh_value_to_cstr(arr.arr->items[i]);
        uh_buf_append(&buf, &len, &cap, elem ? elem : "");
        free(elem);
        if (i + 1 < arr.arr->len) {
            uh_buf_append(&buf, &len, &cap, d);
        }
    }
    if (buf == NULL) {
        return uh_str("");
    }
    UhValue v;
    v.tag = UH_STR;
    v.num = 0;
    v.str = buf;
    v.arr = NULL;
    v.dict = NULL;
    return v;
}

UhValue uh_substr(UhValue str, UhValue start, UhValue len_val) {
    if (str.tag != UH_STR || str.str == NULL) {
        return uh_str("");
    }
    long start_idx = (long)start.num;
    long length = (long)len_val.num;
    size_t slen = utf8_len(str.str);
    if (start_idx < 0) {
        start_idx = (long)slen + start_idx;
    }
    if (start_idx < 0) {
        start_idx = 0;
    }
    if ((size_t)start_idx > slen) {
        return uh_str("");
    }
    if (length < 0 || (size_t)(start_idx + length) > slen) {
        length = (long)(slen - (size_t)start_idx);
    }
    size_t bstart = utf8_index_to_byte(str.str, start_idx);
    size_t bend = utf8_index_to_byte(str.str, start_idx + length);
    if (bstart == (size_t)-1 || bend == (size_t)-1 || bend < bstart) {
        return uh_str("");
    }
    size_t blen = bend - bstart;
    char *buf = (char *)malloc(blen + 1);
    if (buf == NULL) {
        return uh_str("");
    }
    memcpy(buf, str.str + bstart, blen);
    buf[blen] = '\0';
    UhValue v;
    v.tag = UH_STR;
    v.num = 0;
    v.str = buf;
    v.arr = NULL;
    v.dict = NULL;
    return v;
}

UhValue uh_char_at(UhValue str, UhValue idx) {
    if (str.tag != UH_STR || str.str == NULL) {
        return uh_str("");
    }
    long i = (long)idx.num;
    size_t slen = utf8_len(str.str);
    if (i < 0) {
        i = (long)slen + i;
    }
    if (i < 0 || (size_t)i >= slen) {
        return uh_str("");
    }
    size_t bstart = utf8_index_to_byte(str.str, i);
    if (bstart == (size_t)-1) {
        return uh_str("");
    }
    size_t adv = utf8_advance(str.str, bstart);
    char buf[5];
    if (adv > 4) adv = 1;
    memcpy(buf, str.str + bstart, adv);
    buf[adv] = '\0';
    return uh_str(buf);
}

UhValue uh_read_file(UhValue path) {
    if (path.tag != UH_STR || path.str == NULL) {
        return uh_str("");
    }
    FILE *f = fopen(path.str, "rb");
    if (!f) {
        return uh_str("");
    }
    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    fseek(f, 0, SEEK_SET);
    if (size < 0) {
        fclose(f);
        return uh_str("");
    }
    char *buf = (char *)malloc((size_t)size + 1);
    if (!buf) {
        fclose(f);
        return uh_str("");
    }
    size_t read = fread(buf, 1, (size_t)size, f);
    buf[read] = '\0';
    fclose(f);
    UhValue v;
    v.tag = UH_STR;
    v.num = 0;
    v.str = buf;
    v.arr = NULL;
    v.dict = NULL;
    return v;
}

UhValue uh_write_file(UhValue path, UhValue content) {
    if (path.tag != UH_STR || path.str == NULL) {
        return uh_num(0);
    }
    const char *data = NULL;
    char *tmp = NULL;
    if (content.tag == UH_STR && content.str) {
        data = content.str;
    } else {
        tmp = uh_value_to_cstr(content);
        data = tmp ? tmp : "";
    }
    FILE *f = fopen(path.str, "wb");
    if (!f) {
        free(tmp);
        return uh_num(0);
    }
    fwrite(data, 1, strlen(data), f);
    fclose(f);
    free(tmp);
    return uh_num(1);
}

static const char *uh_file_path(UhValue file) {
    if (file.tag == UH_DICT && file.dict) {
        UhValue key = uh_str("path");
        UhValue val = uh_dict_get(file, key);
        if (val.tag == UH_STR && val.str) {
            return val.str;
        }
    }
    if (file.tag == UH_STR && file.str) {
        return file.str;
    }
    return NULL;
}

static const char *uh_file_mode(UhValue file) {
    if (file.tag == UH_DICT && file.dict) {
        UhValue key = uh_str("mode");
        UhValue val = uh_dict_get(file, key);
        if (val.tag == UH_STR && val.str) {
            return val.str;
        }
    }
    return NULL;
}

UhValue uh_file_open(UhValue path, UhValue mode) {
    if (path.tag != UH_STR || path.str == NULL) {
        return uh_null();
    }
    UhValue out = uh_dict_new();
    if (out.tag != UH_DICT) {
        return out;
    }
    uh_dict_set(&out, uh_str("path"), path);
    if (mode.tag == UH_STR && mode.str) {
        uh_dict_set(&out, uh_str("mode"), mode);
    }
    return out;
}

UhValue uh_file_read(UhValue file) {
    const char *path = uh_file_path(file);
    if (!path) {
        return uh_str("");
    }
    return uh_read_file(uh_str(path));
}

UhValue uh_file_readall(UhValue file) {
    return uh_file_read(file);
}

UhValue uh_file_readlines(UhValue file) {
    UhValue content = uh_file_read(file);
    return uh_split(content, uh_str("\n"));
}

UhValue uh_file_write(UhValue file, UhValue content) {
    const char *path = uh_file_path(file);
    if (!path) {
        return uh_num(0);
    }
    const char *mode = uh_file_mode(file);
    if (mode && mode[0] == 'a') {
        const char *data = NULL;
        char *tmp = NULL;
        if (content.tag == UH_STR && content.str) {
            data = content.str;
        } else {
            tmp = uh_value_to_cstr(content);
            data = tmp ? tmp : "";
        }
        FILE *f = fopen(path, "ab");
        if (!f) {
            free(tmp);
            return uh_num(0);
        }
        fwrite(data, 1, strlen(data), f);
        fclose(f);
        free(tmp);
        return uh_num(1);
    }
    return uh_write_file(uh_str(path), content);
}

UhValue uh_file_close(UhValue file) {
    (void)file;
    return uh_null();
}

UhValue uh_syscall(UhValue cmd) {
    if (cmd.tag != UH_STR || cmd.str == NULL) {
        return uh_str("");
    }
    if (strcmp(cmd.str, "net/http") == 0 ||
        strcmp(cmd.str, "websocket") == 0 ||
        strcmp(cmd.str, "crypto") == 0 ||
        strcmp(cmd.str, "smtp") == 0) {
        return uh_null();
    }
    FILE *p = popen(cmd.str, "r");
    if (!p) {
        return uh_str("");
    }
    char *buf = NULL;
    size_t len = 0;
    size_t cap = 0;
    char chunk[256];
    while (fgets(chunk, sizeof(chunk), p)) {
        uh_buf_append(&buf, &len, &cap, chunk);
    }
    pclose(p);
    if (buf == NULL) {
        return uh_str("");
    }
    UhValue v;
    v.tag = UH_STR;
    v.num = 0;
    v.str = buf;
    v.arr = NULL;
    v.dict = NULL;
    return v;
}

UhValue uh_concat(UhValue a, UhValue b) {
    if (a.tag == UH_ARR && b.tag == UH_ARR && a.arr && b.arr) {
        UhValue out = uh_arr_new();
        if (out.arr == NULL) {
            return out;
        }
        for (size_t i = 0; i < a.arr->len; i++) {
            uh_arr_push(&out, a.arr->items[i]);
        }
        for (size_t i = 0; i < b.arr->len; i++) {
            uh_arr_push(&out, b.arr->items[i]);
        }
        return out;
    }

    char *sa = uh_value_to_cstr(a);
    char *sb = uh_value_to_cstr(b);
    size_t lena = sa ? strlen(sa) : 0;
    size_t lenb = sb ? strlen(sb) : 0;
    char *buf = (char *)malloc(lena + lenb + 1);
    if (buf == NULL) {
        free(sa);
        free(sb);
        return uh_str("");
    }
    if (sa) memcpy(buf, sa, lena);
    if (sb) memcpy(buf + lena, sb, lenb);
    buf[lena + lenb] = '\0';
    free(sa);
    free(sb);
    UhValue v;
    v.tag = UH_STR;
    v.num = 0;
    v.str = buf;
    v.arr = NULL;
    v.dict = NULL;
    return v;
}

static UhValue uh_arr_binop(UhValue a, UhValue b, char op) {
    UhValue out = uh_arr_new();
    if (out.tag != UH_ARR || out.arr == NULL) {
        return out;
    }
    if (a.tag == UH_ARR && b.tag == UH_ARR && a.arr && b.arr) {
        size_t n = a.arr->len < b.arr->len ? a.arr->len : b.arr->len;
        for (size_t i = 0; i < n; i++) {
            UhValue av = a.arr->items[i];
            UhValue bv = b.arr->items[i];
            double x = av.num;
            double y = bv.num;
            double r = 0;
            if (op == '+') r = x + y;
            else if (op == '-') r = x - y;
            else if (op == '*') r = x * y;
            else if (op == '/') r = y == 0 ? 0 : x / y;
            uh_arr_push(&out, uh_num(r));
        }
        return out;
    }
    if (a.tag == UH_ARR && a.arr && b.tag == UH_NUM) {
        for (size_t i = 0; i < a.arr->len; i++) {
            double x = a.arr->items[i].num;
            double y = b.num;
            double r = 0;
            if (op == '+') r = x + y;
            else if (op == '-') r = x - y;
            else if (op == '*') r = x * y;
            else if (op == '/') r = y == 0 ? 0 : x / y;
            uh_arr_push(&out, uh_num(r));
        }
        return out;
    }
    if (a.tag == UH_NUM && b.tag == UH_ARR && b.arr) {
        for (size_t i = 0; i < b.arr->len; i++) {
            double x = a.num;
            double y = b.arr->items[i].num;
            double r = 0;
            if (op == '+') r = x + y;
            else if (op == '-') r = x - y;
            else if (op == '*') r = x * y;
            else if (op == '/') r = y == 0 ? 0 : x / y;
            uh_arr_push(&out, uh_num(r));
        }
        return out;
    }
    return out;
}

UhValue uh_add(UhValue a, UhValue b) {
    if (a.tag == UH_NUM && b.tag == UH_NUM) {
        return uh_num(a.num + b.num);
    }
    if (a.tag == UH_ARR || b.tag == UH_ARR) {
        return uh_arr_binop(a, b, '+');
    }
    return uh_num(0);
}

UhValue uh_sub(UhValue a, UhValue b) {
    if (a.tag == UH_NUM && b.tag == UH_NUM) {
        return uh_num(a.num - b.num);
    }
    if (a.tag == UH_ARR || b.tag == UH_ARR) {
        return uh_arr_binop(a, b, '-');
    }
    return uh_num(0);
}

UhValue uh_mul(UhValue a, UhValue b) {
    if (a.tag == UH_NUM && b.tag == UH_NUM) {
        return uh_num(a.num * b.num);
    }
    if (a.tag == UH_ARR || b.tag == UH_ARR) {
        return uh_arr_binop(a, b, '*');
    }
    return uh_num(0);
}

UhValue uh_div(UhValue a, UhValue b) {
    if (a.tag == UH_NUM && b.tag == UH_NUM) {
        return uh_num(b.num == 0 ? 0 : a.num / b.num);
    }
    if (a.tag == UH_ARR || b.tag == UH_ARR) {
        return uh_arr_binop(a, b, '/');
    }
    return uh_num(0);
}

UhValue uh_stringify(UhValue v) {
    char *s = uh_value_to_cstr(v);
    UhValue out;
    out.tag = UH_STR;
    out.num = 0;
    out.str = s;
    out.arr = NULL;
    out.dict = NULL;
    return out;
}

UhValue uh_type(UhValue v) {
    if (v.tag == UH_NULL) {
        return uh_str("null");
    }
    if (v.tag == UH_NUM) {
        double n = v.num;
        double i = floor(n);
        if (fabs(n - i) < 1e-9) {
            return uh_str("int");
        }
        return uh_str("float");
    }
    if (v.tag == UH_STR) {
        return uh_str("str");
    }
    if (v.tag == UH_ARR) {
        return uh_str("array");
    }
    if (v.tag == UH_DICT) {
        return uh_str("dict");
    }
    return uh_str("unknown");
}

UhValue uh_int(UhValue v) {
    if (v.tag == UH_NUM) {
        return uh_num((double)(long)v.num);
    }
    if (v.tag == UH_STR && v.str) {
        char *end = NULL;
        long n = strtol(v.str, &end, 10);
        return uh_num((double)n);
    }
    return uh_num(0);
}

UhValue uh_float(UhValue v) {
    if (v.tag == UH_NUM) {
        return v;
    }
    if (v.tag == UH_STR && v.str) {
        char *end = NULL;
        double n = strtod(v.str, &end);
        return uh_num(n);
    }
    return uh_num(0);
}

UhValue uh_upper(UhValue v) {
    if (v.tag != UH_STR || v.str == NULL) {
        return uh_str("");
    }
    size_t len = strlen(v.str);
    char *buf = (char *)malloc(len + 1);
    if (!buf) return uh_str("");
    for (size_t i = 0; i < len; i++) {
        buf[i] = (char)toupper((unsigned char)v.str[i]);
    }
    buf[len] = '\0';
    UhValue out = uh_str(buf);
    free(buf);
    return out;
}

UhValue uh_lower(UhValue v) {
    if (v.tag != UH_STR || v.str == NULL) {
        return uh_str("");
    }
    size_t len = strlen(v.str);
    char *buf = (char *)malloc(len + 1);
    if (!buf) return uh_str("");
    for (size_t i = 0; i < len; i++) {
        buf[i] = (char)tolower((unsigned char)v.str[i]);
    }
    buf[len] = '\0';
    UhValue out = uh_str(buf);
    free(buf);
    return out;
}

UhValue uh_index_of(UhValue str, UhValue needle) {
    if (str.tag != UH_STR || needle.tag != UH_STR || str.str == NULL || needle.str == NULL) {
        return uh_num(-1);
    }
    char *pos = strstr(str.str, needle.str);
    if (!pos) return uh_num(-1);
    return uh_num((double)(pos - str.str));
}

UhValue uh_starts_with(UhValue str, UhValue prefix) {
    if (str.tag != UH_STR || prefix.tag != UH_STR || str.str == NULL || prefix.str == NULL) {
        return uh_num(0);
    }
    size_t plen = strlen(prefix.str);
    if (strncmp(str.str, prefix.str, plen) == 0) {
        return uh_num(1);
    }
    return uh_num(0);
}

UhValue uh_match(UhValue str, UhValue pattern) {
    if (str.tag != UH_STR || pattern.tag != UH_STR || str.str == NULL || pattern.str == NULL) {
        return uh_num(0);
    }
    regex_t regex;
    int rc = regcomp(&regex, pattern.str, REG_EXTENDED | REG_NOSUB);
    if (rc != 0) {
        return uh_num(0);
    }
    rc = regexec(&regex, str.str, 0, NULL, 0);
    regfree(&regex);
    return uh_num(rc == 0 ? 1 : 0);
}

UhValue uh_chunk(UhValue arr, UhValue size) {
    if (arr.tag != UH_ARR || size.tag != UH_NUM || arr.arr == NULL) {
        return uh_arr_new();
    }
    long n = (long)size.num;
    if (n <= 0) return uh_arr_new();
    UhValue out = uh_arr_new();
    UhValue cur = uh_arr_new();
    for (size_t i = 0; i < arr.arr->len; i++) {
        uh_arr_push(&cur, arr.arr->items[i]);
        if ((long)cur.arr->len >= n) {
            uh_arr_push(&out, cur);
            cur = uh_arr_new();
        }
    }
    if (cur.arr && cur.arr->len > 0) {
        uh_arr_push(&out, cur);
    }
    return out;
}

UhValue uh_format(UhValue v) {
    return uh_stringify(v);
}

UhValue uh_hex(UhValue v) {
    if (v.tag != UH_STR || v.str == NULL) {
        return uh_str("");
    }
    size_t len = strlen(v.str);
    char *buf = (char *)malloc(len * 2 + 1);
    if (!buf) return uh_str("");
    for (size_t i = 0; i < len; i++) {
        unsigned char c = (unsigned char)v.str[i];
        snprintf(buf + i * 2, 3, "%02x", c);
    }
    buf[len * 2] = '\0';
    UhValue out = uh_str(buf);
    free(buf);
    return out;
}

UhValue uh_time_now(void) {
    time_t now = time(NULL);
    struct tm tmv;
    localtime_r(&now, &tmv);
    char buf[32];
    strftime(buf, sizeof(buf), "%Y-%m-%d %H:%M:%S", &tmv);
    return uh_str(buf);
}

UhValue uh_pow(UhValue a, UhValue b) {
    if (a.tag == UH_NUM && b.tag == UH_NUM) {
        return uh_num(pow(a.num, b.num));
    }
    return uh_num(0);
}

static long clamp_long(long v, long lo, long hi) {
    if (v < lo) return lo;
    if (v > hi) return hi;
    return v;
}

UhValue uh_take(UhValue v, UhValue n) {
    if (n.tag != UH_NUM) {
        return uh_null();
    }
    long count = (long)n.num;
    if (v.tag == UH_STR) {
        long len = (long)utf8_len(v.str ? v.str : "");
        if (count >= 0) {
            return uh_substr(v, uh_num(0), uh_num((double)clamp_long(count, 0, len)));
        }
        long take_last = -count;
        long start = len - take_last;
        if (start < 0) start = 0;
        return uh_substr(v, uh_num((double)start), uh_num((double)clamp_long(take_last, 0, len)));
    }
    if (v.tag != UH_ARR) {
        return uh_null();
    }
    long len = (long)v.arr->len;
    UhValue out = uh_arr_new();
    if (count >= 0) {
        long end = clamp_long(count, 0, len);
        for (long i = 0; i < end; i++) {
            uh_arr_push(&out, v.arr->items[i]);
        }
    } else {
        long take_last = -count;
        long start = len - take_last;
        if (start < 0) start = 0;
        for (long i = start; i < len; i++) {
            uh_arr_push(&out, v.arr->items[i]);
        }
    }
    return out;
}

UhValue uh_drop(UhValue v, UhValue n) {
    if (n.tag != UH_NUM) {
        return uh_null();
    }
    long count = (long)n.num;
    if (v.tag == UH_STR) {
        long len = (long)utf8_len(v.str ? v.str : "");
        if (count >= 0) {
            long start = clamp_long(count, 0, len);
            return uh_substr(v, uh_num((double)start), uh_num((double)(len - start)));
        }
        long drop_last = -count;
        long end = len - drop_last;
        if (end < 0) end = 0;
        return uh_substr(v, uh_num(0), uh_num((double)end));
    }
    if (v.tag != UH_ARR) {
        return uh_null();
    }
    long len = (long)v.arr->len;
    UhValue out = uh_arr_new();
    if (count >= 0) {
        long start = clamp_long(count, 0, len);
        for (long i = start; i < len; i++) {
            uh_arr_push(&out, v.arr->items[i]);
        }
    } else {
        long drop_last = -count;
        long end = len - drop_last;
        if (end < 0) end = 0;
        for (long i = 0; i < end; i++) {
            uh_arr_push(&out, v.arr->items[i]);
        }
    }
    return out;
}

UhValue uh_reverse(UhValue v) {
    if (v.tag == UH_ARR) {
        UhValue out = uh_arr_new();
        for (long i = (long)v.arr->len - 1; i >= 0; i--) {
            uh_arr_push(&out, v.arr->items[i]);
        }
        return out;
    }
    if (v.tag == UH_STR) {
        const char *s = v.str ? v.str : "";
        size_t len = utf8_len(s);
        size_t bytes = strlen(s);
        char *buf = (char *)malloc(bytes + 1);
        if (!buf) {
            return uh_str("");
        }
        size_t out = 0;
        for (long i = (long)len - 1; i >= 0; i--) {
            size_t start = utf8_index_to_byte(s, i);
            size_t end = utf8_index_to_byte(s, i + 1);
            if (start == (size_t)-1) {
                break;
            }
            size_t nbytes = (end == (size_t)-1) ? (bytes - start) : (end - start);
            memcpy(buf + out, s + start, nbytes);
            out += nbytes;
        }
        buf[out] = '\0';
        UhValue outv = uh_str(buf);
        free(buf);
        return outv;
    }
    return uh_null();
}

UhValue uh_rotate(UhValue v, UhValue n) {
    if (n.tag != UH_NUM) {
        return uh_null();
    }
    long shift = (long)n.num;
    if (v.tag == UH_STR) {
        long len = (long)utf8_len(v.str ? v.str : "");
        if (len == 0) return uh_str("");
        shift %= len;
        if (shift < 0) shift += len;
        UhValue a = uh_substr(v, uh_num((double)shift), uh_num((double)(len - shift)));
        UhValue b = uh_substr(v, uh_num(0), uh_num((double)shift));
        UhValue out = uh_concat(a, b);
        return out;
    }
    if (v.tag != UH_ARR) {
        return uh_null();
    }
    long len = (long)v.arr->len;
    if (len == 0) return v;
    shift %= len;
    if (shift < 0) shift += len;
    UhValue out = uh_arr_new();
    for (long i = shift; i < len; i++) {
        uh_arr_push(&out, v.arr->items[i]);
    }
    for (long i = 0; i < shift; i++) {
        uh_arr_push(&out, v.arr->items[i]);
    }
    return out;
}

UhValue uh_reshape(UhValue v, UhValue rows, UhValue cols) {
    if (v.tag != UH_ARR || rows.tag != UH_NUM || cols.tag != UH_NUM) {
        return uh_null();
    }
    long r = (long)rows.num;
    long c = (long)cols.num;
    if (r <= 0 || c <= 0) {
        return uh_arr_new();
    }
    UhValue out = uh_arr_new();
    long idx = 0;
    for (long i = 0; i < r; i++) {
        UhValue row = uh_arr_new();
        for (long j = 0; j < c; j++) {
            if (idx < (long)v.arr->len) {
                uh_arr_push(&row, v.arr->items[idx]);
            } else {
                uh_arr_push(&row, uh_null());
            }
            idx++;
        }
        uh_arr_push(&out, row);
    }
    return out;
}

UhValue uh_transpose(UhValue v) {
    if (v.tag != UH_ARR) {
        return uh_null();
    }
    long rows = (long)v.arr->len;
    if (rows == 0) return uh_arr_new();
    long cols = 0;
    for (long i = 0; i < rows; i++) {
        UhValue row = v.arr->items[i];
        if (row.tag == UH_ARR && (long)row.arr->len > cols) {
            cols = (long)row.arr->len;
        }
    }
    UhValue out = uh_arr_new();
    for (long c = 0; c < cols; c++) {
        UhValue row = uh_arr_new();
        for (long r = 0; r < rows; r++) {
            UhValue src = v.arr->items[r];
            if (src.tag == UH_ARR && c < (long)src.arr->len) {
                uh_arr_push(&row, src.arr->items[c]);
            } else {
                uh_arr_push(&row, uh_null());
            }
        }
        uh_arr_push(&out, row);
    }
    return out;
}

int uh_subset(UhValue a, UhValue b, int proper) {
    if (a.tag == UH_ARR && b.tag == UH_ARR) {
        for (size_t i = 0; i < a.arr->len; i++) {
            int found = 0;
            for (size_t j = 0; j < b.arr->len; j++) {
                if (uh_value_eq(a.arr->items[i], b.arr->items[j])) {
                    found = 1;
                    break;
                }
            }
            if (!found) return 0;
        }
        if (proper) {
            return a.arr->len < b.arr->len;
        }
        return 1;
    }
    if (a.tag == UH_DICT && b.tag == UH_DICT) {
        for (size_t i = 0; i < a.dict->len; i++) {
            UhDictEntry *entry = uh_dict_find(b.dict, a.dict->items[i].key);
            if (!entry) return 0;
        }
        if (proper) {
            return a.dict->len < b.dict->len;
        }
        return 1;
    }
    return 0;
}

int uh_contains(UhValue collection, UhValue item) {
    if (collection.tag == UH_STR) {
        char *needle = uh_value_to_cstr(item);
        int found = 0;
        if (collection.str && needle) {
            found = strstr(collection.str, needle) != NULL;
        }
        free(needle);
        return found;
    }
    if (collection.tag == UH_ARR && collection.arr) {
        for (size_t i = 0; i < collection.arr->len; i++) {
            if (uh_value_eq(collection.arr->items[i], item)) {
                return 1;
            }
        }
        return 0;
    }
    if (collection.tag == UH_DICT && collection.dict) {
        char *k = uh_key_string(item);
        if (k == NULL) {
            return 0;
        }
        UhDictEntry *entry = uh_dict_find(collection.dict, k);
        free(k);
        return entry != NULL;
    }
    return 0;
}

UhValue uh_index(UhValue collection, UhValue key) {
    if (collection.tag == UH_ARR) {
        return uh_arr_get(collection, (long)key.num);
    }
    if (collection.tag == UH_DICT) {
        return uh_dict_get(collection, key);
    }
    if (collection.tag == UH_STR) {
        return uh_char_at(collection, key);
    }
    return uh_null();
}

void uh_store_index(UhValue *collection, UhValue key, UhValue val) {
    if (collection == NULL) {
        return;
    }
    if (collection->tag == UH_ARR) {
        long idx = (long)key.num;
        if (collection->arr == NULL) {
            return;
        }
        if (idx < 0) {
            idx = (long)collection->arr->len + idx;
        }
        if (idx < 0 || (size_t)idx >= collection->arr->len) {
            return;
        }
        collection->arr->items[idx] = val;
        return;
    }
    if (collection->tag == UH_DICT) {
        uh_dict_set(collection, key, val);
    }
}

int uh_is_true(UhValue v) {
    if (v.tag == UH_NULL) {
        return 0;
    }
    if (v.tag == UH_STR) {
        return v.str != NULL && v.str[0] != '\0';
    }
    if (v.tag == UH_ARR && v.arr) {
        return v.arr->len > 0;
    }
    if (v.tag == UH_DICT && v.dict) {
        return v.dict->len > 0;
    }
    return v.num != 0;
}

void uh_print(UhValue v) {
    if (v.tag == UH_STR) {
        if (v.str) {
            fputs(v.str, stdout);
        }
    } else if (v.tag == UH_ARR || v.tag == UH_DICT) {
        char *s = uh_value_to_cstr(v);
        if (s) {
            fputs(s, stdout);
            free(s);
        }
    } else if (v.tag == UH_NULL) {
        fputs("null", stdout);
    } else {
        printf("%g", v.num);
    }
    fputc('\n', stdout);
}

int uh_value_eq(UhValue a, UhValue b) {
    if (a.tag != b.tag) {
        return 0;
    }
    if (a.tag == UH_NULL) {
        return 1;
    }
    if (a.tag == UH_STR) {
        if (a.str == NULL || b.str == NULL) {
            return a.str == b.str;
        }
        return strcmp(a.str, b.str) == 0;
    }
    if (a.tag == UH_ARR) {
        if (a.arr == NULL || b.arr == NULL) {
            return a.arr == b.arr;
        }
        if (a.arr->len != b.arr->len) {
            return 0;
        }
        for (size_t i = 0; i < a.arr->len; i++) {
            if (!uh_value_eq(a.arr->items[i], b.arr->items[i])) {
                return 0;
            }
        }
        return 1;
    }
    if (a.tag == UH_DICT) {
        if (a.dict == NULL || b.dict == NULL) {
            return a.dict == b.dict;
        }
        if (a.dict->len != b.dict->len) {
            return 0;
        }
        for (size_t i = 0; i < a.dict->len; i++) {
            UhDictEntry *entry = uh_dict_find(b.dict, a.dict->items[i].key);
            if (entry == NULL) {
                return 0;
            }
            if (!uh_value_eq(a.dict->items[i].val, entry->val)) {
                return 0;
            }
        }
        return 1;
    }
    return a.num == b.num;
}

int uh_cmp(UhValue a, UhValue b) {
    if (a.tag == UH_NUM && b.tag == UH_NUM) {
        if (a.num < b.num) return -1;
        if (a.num > b.num) return 1;
        return 0;
    }
    char *sa = uh_value_to_cstr(a);
    char *sb = uh_value_to_cstr(b);
    if (sa == NULL && sb == NULL) return 0;
    if (sa == NULL) {
        free(sb);
        return -1;
    }
    if (sb == NULL) {
        free(sa);
        return 1;
    }
    int cmp = strcmp(sa, sb);
    free(sa);
    free(sb);
    if (cmp < 0) return -1;
    if (cmp > 0) return 1;
    return 0;
}

static UhValue g_args;
static UhEnv *g_env;

void uh_set_args(int argc, char **argv) {
    g_args = uh_arr_new();
    if (g_args.tag != UH_ARR || g_args.arr == NULL) {
        return;
    }
    for (int i = 0; i < argc; i++) {
        uh_arr_push(&g_args, uh_str(argv[i]));
    }
}

UhValue uh_args(void) {
    return g_args;
}

void uh_set_global_env(UhEnv *env) {
    g_env = env;
}

static UhEnv *uh_get_global_env(void) {
    return g_env;
}

UhValue uh_sysobj(void) {
    UhValue obj = uh_dict_new();
    if (obj.tag != UH_DICT) {
        return obj;
    }
    uh_dict_set(&obj, uh_str("args"), uh_args());
    UhValue envdict = uh_dict_new();
    extern char **environ;
    if (environ) {
        for (char **p = environ; *p; p++) {
            char *eq = strchr(*p, '=');
            if (!eq) continue;
            size_t klen = (size_t)(eq - *p);
            char *k = (char *)malloc(klen + 1);
            if (!k) continue;
            memcpy(k, *p, klen);
            k[klen] = '\0';
            UhValue key = uh_str(k);
            free(k);
            UhValue val = uh_str(eq + 1);
            uh_dict_set(&envdict, key, val);
        }
    }
    uh_dict_set(&obj, uh_str("env"), envdict);
    return obj;
}

UhValue uh_import(UhValue path) {
    if (path.tag != UH_STR || !path.str) return uh_str("");
    struct stat st;
    if (stat(path.str, &st) == 0 && S_ISREG(st.st_mode)) {
        return uh_read_file(path);
    }
    size_t len = strlen(path.str);
    char *p1 = (char *)malloc(len + 4 + 1);
    if (p1) {
        memcpy(p1, path.str, len);
        memcpy(p1 + len, ".uh", 4);
        p1[len + 3] = '\0';
        if (stat(p1, &st) == 0 && S_ISREG(st.st_mode)) {
            UhValue out = uh_read_file(uh_str(p1));
            free(p1);
            return out;
        }
        free(p1);
    }
    const char *suffix = "/src/main.uh";
    size_t slen = strlen(suffix);
    char *p2 = (char *)malloc(len + slen + 1);
    if (p2) {
        memcpy(p2, path.str, len);
        memcpy(p2 + len, suffix, slen);
        p2[len + slen] = '\0';
        if (stat(p2, &st) == 0 && S_ISREG(st.st_mode)) {
            UhValue out = uh_read_file(uh_str(p2));
            free(p2);
            return out;
        }
        free(p2);
    }
    return uh_str("");
}

typedef struct {
    char *path;
    char *handler;
} UhRoute;

static UhRoute *g_routes;
static size_t g_route_len;
static size_t g_route_cap;

static void uh_route_add(const char *path, const char *handler) {
    if (!path || !handler) return;
    if (g_route_len == g_route_cap) {
        size_t new_cap = g_route_cap ? g_route_cap * 2 : 8;
        UhRoute *tmp = (UhRoute *)realloc(g_routes, new_cap * sizeof(UhRoute));
        if (!tmp) return;
        g_routes = tmp;
        g_route_cap = new_cap;
    }
    g_routes[g_route_len].path = uh_strdup(path);
    g_routes[g_route_len].handler = uh_strdup(handler);
    g_route_len++;
}

static const char *uh_route_find(const char *path) {
    if (!path) return NULL;
    for (size_t i = 0; i < g_route_len; i++) {
        if (g_routes[i].path && strcmp(g_routes[i].path, path) == 0) {
            return g_routes[i].handler;
        }
    }
    return NULL;
}

typedef struct {
    char *buf;
    size_t len;
    size_t cap;
} UhCurlBuf;

static size_t uh_curl_write(void *ptr, size_t size, size_t nmemb, void *userdata) {
    size_t n = size * nmemb;
    UhCurlBuf *buf = (UhCurlBuf *)userdata;
    uh_buf_appendn(&buf->buf, &buf->len, &buf->cap, (const char *)ptr, n);
    return n;
}

static void uh_curl_init_once(void) {
    static int inited = 0;
    if (!inited) {
        curl_global_init(CURL_GLOBAL_ALL);
        inited = 1;
    }
}

UhValue uh_http_request(UhValue cfg) {
    uh_curl_init_once();
    const char *url = NULL;
    const char *method = "GET";
    UhValue headers = uh_null();
    UhValue body = uh_null();
    if (cfg.tag == UH_STR && cfg.str) {
        url = cfg.str;
    } else if (cfg.tag == UH_DICT) {
        url = uh_dict_get_str(cfg, "url");
        const char *m = uh_dict_get_str(cfg, "method");
        if (m) method = m;
        headers = uh_dict_get_key(cfg, "headers");
        body = uh_dict_get_key(cfg, "body");
    }
    if (!url) {
        return uh_dict_new();
    }

    CURL *curl = curl_easy_init();
    if (!curl) {
        return uh_dict_new();
    }
    UhCurlBuf buf = {0};
    curl_easy_setopt(curl, CURLOPT_URL, url);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, uh_curl_write);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &buf);
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);

    struct curl_slist *hdrs = NULL;
    if (headers.tag == UH_DICT && headers.dict) {
        for (size_t i = 0; i < headers.dict->len; i++) {
            const char *key = headers.dict->items[i].key;
            char *val = uh_value_to_cstr(headers.dict->items[i].val);
            if (key && val) {
                size_t need = strlen(key) + strlen(val) + 3;
                char *line = (char *)malloc(need);
                if (line) {
                    snprintf(line, need, "%s: %s", key, val);
                    hdrs = curl_slist_append(hdrs, line);
                    free(line);
                }
            }
            free(val);
        }
    }
    if (hdrs) {
        curl_easy_setopt(curl, CURLOPT_HTTPHEADER, hdrs);
    }

    char *body_str = NULL;
    if (body.tag != UH_NULL) {
        body_str = uh_value_to_cstr(body);
        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, body_str ? body_str : "");
    }
    if (method && strcmp(method, "GET") != 0) {
        curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, method);
    }

    CURLcode rc = curl_easy_perform(curl);
    long status = 0;
    curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &status);
    if (hdrs) curl_slist_free_all(hdrs);
    curl_easy_cleanup(curl);
    free(body_str);

    UhValue out = uh_dict_new();
    if (rc != CURLE_OK) {
        uh_dict_set(&out, uh_str("status"), uh_num(0));
        uh_dict_set(&out, uh_str("body"), uh_str(""));
        free(buf.buf);
        return out;
    }
    UhValue body_val = uh_str(buf.buf ? buf.buf : "");
    uh_dict_set(&out, uh_str("status"), uh_num((double)status));
    uh_dict_set(&out, uh_str("body"), body_val);
    free(buf.buf);
    return out;
}

UhValue uh_http_get(UhValue cfg) {
    if (cfg.tag == UH_DICT) {
        UhValue out = uh_http_request(cfg);
        return out;
    }
    return uh_http_request(cfg);
}

UhValue uh_http_handle(UhValue path, UhValue handler) {
    if (path.tag == UH_STR && handler.tag == UH_STR && path.str && handler.str) {
        uh_route_add(path.str, handler.str);
    }
    return uh_null();
}

static int uh_parse_port(const char *s) {
    if (!s) return 0;
    if (*s == ':') s++;
    int port = 0;
    while (*s && *s >= '0' && *s <= '9') {
        port = port * 10 + (*s - '0');
        s++;
    }
    return port;
}

static UhValue uh_http_build_req(const char *method, const char *path, const char *body) {
    UhValue req = uh_dict_new();
    uh_dict_set(&req, uh_str("method"), uh_str(method ? method : ""));
    uh_dict_set(&req, uh_str("path"), uh_str(path ? path : ""));
    uh_dict_set(&req, uh_str("body"), uh_str(body ? body : ""));
    return req;
}

static UhValue uh_http_build_res(void) {
    UhValue res = uh_dict_new();
    uh_dict_set(&res, uh_str("status"), uh_num(200));
    uh_dict_set(&res, uh_str("body"), uh_str(""));
    UhValue headers = uh_dict_new();
    uh_dict_set(&headers, uh_str("Content-Type"), uh_str("application/json"));
    uh_dict_set(&res, uh_str("headers"), headers);
    return res;
}

UhValue uh_http_listen(UhValue addr) {
    const char *addr_str = (addr.tag == UH_STR && addr.str) ? addr.str : ":8080";
    int port = uh_parse_port(addr_str);
    if (port <= 0) return uh_num(0);

    int fd = socket(AF_INET, SOCK_STREAM, 0);
    if (fd < 0) return uh_num(0);
    int opt = 1;
    setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));

    struct sockaddr_in sa;
    memset(&sa, 0, sizeof(sa));
    sa.sin_family = AF_INET;
    sa.sin_addr.s_addr = htonl(INADDR_ANY);
    sa.sin_port = htons((uint16_t)port);
    if (bind(fd, (struct sockaddr *)&sa, sizeof(sa)) != 0) {
        close(fd);
        return uh_num(0);
    }
    if (listen(fd, 16) != 0) {
        close(fd);
        return uh_num(0);
    }

    for (;;) {
        int cfd = accept(fd, NULL, NULL);
        if (cfd < 0) continue;
        char buf[8192];
        ssize_t n = recv(cfd, buf, sizeof(buf) - 1, 0);
        if (n <= 0) {
            close(cfd);
            continue;
        }
        buf[n] = '\0';
        char *header_end = strstr(buf, "\r\n\r\n");
        if (!header_end) {
            close(cfd);
            continue;
        }
        size_t header_len = (size_t)(header_end - buf);
        size_t body_len = (size_t)(n - (header_len + 4));
        char *body = header_end + 4;

        char *line = strtok(buf, "\r\n");
        if (!line) {
            close(cfd);
            continue;
        }
        char *method = strtok(line, " ");
        char *path = strtok(NULL, " ");
        const char *handler = uh_route_find(path);

        UhValue req = uh_http_build_req(method, path, body);
        UhValue res = uh_http_build_res();
        if (handler) {
            UhEnv *env = uh_get_global_env();
            UhValue args[2] = {req, res};
            if (env) {
                uh_call_named(env, handler, 2, args);
            }
        } else {
            uh_dict_set(&res, uh_str("status"), uh_num(404));
            uh_dict_set(&res, uh_str("body"), uh_str("Not found"));
        }

        UhValue status_v = uh_dict_get_key(res, "status");
        UhValue body_v = uh_dict_get_key(res, "body");
        UhValue headers_v = uh_dict_get_key(res, "headers");
        const char *content_type = "application/json";
        if (headers_v.tag == UH_DICT) {
            UhValue ct = uh_dict_get_key(headers_v, "Content-Type");
            if (ct.tag == UH_STR && ct.str) {
                content_type = ct.str;
            }
        }
        long status = (status_v.tag == UH_NUM) ? (long)status_v.num : 200;
        char *body_str = uh_value_to_cstr(body_v);
        size_t resp_len = body_str ? strlen(body_str) : 0;
        char header[256];
        int hlen = snprintf(header, sizeof(header),
                            "HTTP/1.1 %ld OK\r\nContent-Type: %s\r\nContent-Length: %zu\r\nConnection: close\r\n\r\n",
                            status, content_type, resp_len);
        send(cfd, header, (size_t)hlen, 0);
        if (resp_len > 0 && body_str) {
            send(cfd, body_str, resp_len, 0);
        }
        free(body_str);
        close(cfd);
        (void)header_len;
        (void)body_len;
    }
    close(fd);
    return uh_num(1);
}

UhValue uh_http_method(UhValue req) {
    const char *m = uh_dict_get_str(req, "method");
    return uh_str(m ? m : "");
}

UhValue uh_http_json(UhValue payload, UhValue target) {
    if (target.tag == UH_DICT) {
        UhValue body = uh_dict_get_key(target, "body");
        if ((payload.tag == UH_NUM && payload.num == 0) || payload.tag == UH_NULL) {
            if (body.tag == UH_STR && body.str) {
                return uh_json_parse(body);
            }
            return uh_null();
        }
        if (payload.tag == UH_DICT) {
            UhValue status = uh_dict_get_key(payload, "status");
            if (status.tag == UH_NUM) {
                uh_dict_set(&target, uh_str("status"), status);
            }
        }
        UhValue json = uh_json_stringify(payload);
        uh_dict_set(&target, uh_str("body"), json);
    }
    return uh_null();
}

typedef struct {
    sqlite3 *db;
    char *path;
} UhDbConn;

static UhDbConn *g_db;
static size_t g_db_len;

static sqlite3 *uh_db_get(UhValue conn) {
    UhValue idv = uh_dict_get_key(conn, "__db_id");
    if (idv.tag != UH_NUM) return NULL;
    long id = (long)idv.num;
    if (id <= 0 || (size_t)id > g_db_len) return NULL;
    return g_db[id - 1].db;
}

UhValue uh_db_connect(UhValue cfg) {
    const char *path = NULL;
    if (cfg.tag == UH_DICT) {
        path = uh_dict_get_str(cfg, "database");
        if (!path) path = uh_dict_get_str(cfg, "path");
    }
    if (!path) path = ":memory:";
    sqlite3 *db = NULL;
    if (sqlite3_open(path, &db) != SQLITE_OK) {
        if (db) sqlite3_close(db);
        return uh_null();
    }
    UhDbConn conn = {0};
    conn.db = db;
    conn.path = uh_strdup(path);
    UhDbConn *tmp = (UhDbConn *)realloc(g_db, (g_db_len + 1) * sizeof(UhDbConn));
    if (!tmp) {
        sqlite3_close(db);
        return uh_null();
    }
    g_db = tmp;
    g_db[g_db_len] = conn;
    g_db_len++;
    UhValue out = uh_dict_new();
    uh_dict_set(&out, uh_str("__db_id"), uh_num((double)g_db_len));
    return out;
}

UhValue uh_db_exec(UhValue sql, UhValue conn) {
    sqlite3 *db = uh_db_get(conn);
    if (!db) return uh_num(0);
    char *q = uh_value_to_cstr(sql);
    if (!q) return uh_num(0);
    char *err = NULL;
    int rc = sqlite3_exec(db, q, NULL, NULL, &err);
    if (err) sqlite3_free(err);
    free(q);
    return uh_num(rc == SQLITE_OK ? 1 : 0);
}

UhValue uh_db_query(UhValue sql, UhValue conn) {
    sqlite3 *db = uh_db_get(conn);
    if (!db) return uh_arr_new();
    char *q = uh_value_to_cstr(sql);
    if (!q) return uh_arr_new();
    sqlite3_stmt *stmt = NULL;
    if (sqlite3_prepare_v2(db, q, -1, &stmt, NULL) != SQLITE_OK) {
        free(q);
        return uh_arr_new();
    }
    free(q);
    UhValue rows = uh_arr_new();
    int cols = sqlite3_column_count(stmt);
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        UhValue row = uh_dict_new();
        for (int i = 0; i < cols; i++) {
            const char *name = sqlite3_column_name(stmt, i);
            int type = sqlite3_column_type(stmt, i);
            UhValue val = uh_null();
            if (type == SQLITE_INTEGER) {
                val = uh_num((double)sqlite3_column_int64(stmt, i));
            } else if (type == SQLITE_FLOAT) {
                val = uh_num(sqlite3_column_double(stmt, i));
            } else if (type == SQLITE_TEXT) {
                const unsigned char *txt = sqlite3_column_text(stmt, i);
                val = uh_str(txt ? (const char *)txt : "");
            } else {
                val = uh_null();
            }
            if (name) {
                uh_dict_set(&row, uh_str(name), val);
            }
        }
        uh_arr_push(&rows, row);
    }
    sqlite3_finalize(stmt);
    return rows;
}

UhValue uh_db_begin(UhValue conn) {
    return uh_db_exec(uh_str("BEGIN"), conn);
}

UhValue uh_db_commit(UhValue conn) {
    return uh_db_exec(uh_str("COMMIT"), conn);
}

typedef struct {
    pthread_t th;
    char *fn;
    UhValue arg;
} UhThread;

static UhThread **g_threads;
static size_t g_thread_len;

static void *uh_thread_entry(void *ptr) {
    UhThread *t = (UhThread *)ptr;
    UhEnv *env = uh_get_global_env();
    if (env && t && t->fn) {
        UhValue args[1] = {t->arg};
        uh_call_named(env, t->fn, 1, args);
    }
    return NULL;
}

UhValue uh_thread_start(UhValue arg, UhValue fn) {
    if (fn.tag != UH_STR || fn.str == NULL) {
        return uh_null();
    }
    UhThread *t = (UhThread *)malloc(sizeof(UhThread));
    if (!t) return uh_null();
    t->fn = uh_strdup(fn.str);
    t->arg = arg;
    UhThread **tmp = (UhThread **)realloc(g_threads, (g_thread_len + 1) * sizeof(UhThread *));
    if (!tmp) {
        free(t->fn);
        free(t);
        return uh_null();
    }
    g_threads = tmp;
    g_threads[g_thread_len] = t;
    size_t id = g_thread_len + 1;
    if (pthread_create(&t->th, NULL, uh_thread_entry, t) != 0) {
        free(t->fn);
        free(t);
        return uh_null();
    }
    g_thread_len++;
    UhValue out = uh_dict_new();
    uh_dict_set(&out, uh_str("__thread_id"), uh_num((double)id));
    return out;
}

UhValue uh_thread_join(UhValue thr) {
    UhValue idv = uh_dict_get_key(thr, "__thread_id");
    if (idv.tag != UH_NUM) return uh_null();
    long id = (long)idv.num;
    if (id <= 0 || (size_t)id > g_thread_len) return uh_null();
    UhThread *t = g_threads[id - 1];
    if (t) {
        pthread_join(t->th, NULL);
        free(t->fn);
        free(t);
        g_threads[id - 1] = NULL;
    }
    return uh_null();
}

typedef struct {
    UhDict *dict;
    pthread_mutex_t m;
} UhMutex;

static UhMutex *g_mutexes;
static size_t g_mutex_len;

static pthread_mutex_t *uh_mutex_for(UhValue m) {
    if (m.tag != UH_DICT || m.dict == NULL) return NULL;
    for (size_t i = 0; i < g_mutex_len; i++) {
        if (g_mutexes[i].dict == m.dict) {
            return &g_mutexes[i].m;
        }
    }
    UhMutex *tmp = (UhMutex *)realloc(g_mutexes, (g_mutex_len + 1) * sizeof(UhMutex));
    if (!tmp) return NULL;
    g_mutexes = tmp;
    g_mutexes[g_mutex_len].dict = m.dict;
    pthread_mutex_init(&g_mutexes[g_mutex_len].m, NULL);
    g_mutex_len++;
    return &g_mutexes[g_mutex_len - 1].m;
}

UhValue uh_mutex_lock(UhValue m) {
    pthread_mutex_t *mtx = uh_mutex_for(m);
    if (!mtx) return uh_null();
    pthread_mutex_lock(mtx);
    return uh_null();
}

UhValue uh_mutex_unlock(UhValue m) {
    pthread_mutex_t *mtx = uh_mutex_for(m);
    if (!mtx) return uh_null();
    pthread_mutex_unlock(mtx);
    return uh_null();
}

static char *uh_base64_encode(const unsigned char *data, size_t len) {
    static const char tbl[] =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    size_t out_len = ((len + 2) / 3) * 4;
    char *out = (char *)malloc(out_len + 1);
    if (!out) return NULL;
    size_t j = 0;
    for (size_t i = 0; i < len; i += 3) {
        unsigned int v = (unsigned int)data[i] << 16;
        if (i + 1 < len) v |= (unsigned int)data[i + 1] << 8;
        if (i + 2 < len) v |= (unsigned int)data[i + 2];
        out[j++] = tbl[(v >> 18) & 0x3f];
        out[j++] = tbl[(v >> 12) & 0x3f];
        out[j++] = (i + 1 < len) ? tbl[(v >> 6) & 0x3f] : '=';
        out[j++] = (i + 2 < len) ? tbl[v & 0x3f] : '=';
    }
    out[j] = '\0';
    return out;
}

typedef struct {
    uint32_t state[5];
    uint64_t bitlen;
    uint8_t data[64];
    size_t datalen;
} UhSha1;

static uint32_t uh_sha1_rotl(uint32_t x, uint32_t n) {
    return (x << n) | (x >> (32 - n));
}

static void uh_sha1_transform(UhSha1 *ctx, const uint8_t data[64]) {
    uint32_t w[80];
    for (int i = 0; i < 16; i++) {
        w[i] = (uint32_t)data[i * 4] << 24 |
               (uint32_t)data[i * 4 + 1] << 16 |
               (uint32_t)data[i * 4 + 2] << 8 |
               (uint32_t)data[i * 4 + 3];
    }
    for (int i = 16; i < 80; i++) {
        w[i] = uh_sha1_rotl(w[i - 3] ^ w[i - 8] ^ w[i - 14] ^ w[i - 16], 1);
    }
    uint32_t a = ctx->state[0];
    uint32_t b = ctx->state[1];
    uint32_t c = ctx->state[2];
    uint32_t d = ctx->state[3];
    uint32_t e = ctx->state[4];
    for (int i = 0; i < 80; i++) {
        uint32_t f, k;
        if (i < 20) {
            f = (b & c) | ((~b) & d);
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
        uint32_t temp = uh_sha1_rotl(a, 5) + f + e + k + w[i];
        e = d;
        d = c;
        c = uh_sha1_rotl(b, 30);
        b = a;
        a = temp;
    }
    ctx->state[0] += a;
    ctx->state[1] += b;
    ctx->state[2] += c;
    ctx->state[3] += d;
    ctx->state[4] += e;
}

static void uh_sha1_init(UhSha1 *ctx) {
    ctx->datalen = 0;
    ctx->bitlen = 0;
    ctx->state[0] = 0x67452301;
    ctx->state[1] = 0xefcdab89;
    ctx->state[2] = 0x98badcfe;
    ctx->state[3] = 0x10325476;
    ctx->state[4] = 0xc3d2e1f0;
}

static void uh_sha1_update(UhSha1 *ctx, const uint8_t *data, size_t len) {
    for (size_t i = 0; i < len; i++) {
        ctx->data[ctx->datalen++] = data[i];
        if (ctx->datalen == 64) {
            uh_sha1_transform(ctx, ctx->data);
            ctx->bitlen += 512;
            ctx->datalen = 0;
        }
    }
}

static void uh_sha1_final(UhSha1 *ctx, uint8_t hash[20]) {
    size_t i = ctx->datalen;
    ctx->data[i++] = 0x80;
    if (i > 56) {
        while (i < 64) ctx->data[i++] = 0x00;
        uh_sha1_transform(ctx, ctx->data);
        i = 0;
    }
    while (i < 56) ctx->data[i++] = 0x00;
    ctx->bitlen += ctx->datalen * 8;
    ctx->data[56] = (uint8_t)(ctx->bitlen >> 56);
    ctx->data[57] = (uint8_t)(ctx->bitlen >> 48);
    ctx->data[58] = (uint8_t)(ctx->bitlen >> 40);
    ctx->data[59] = (uint8_t)(ctx->bitlen >> 32);
    ctx->data[60] = (uint8_t)(ctx->bitlen >> 24);
    ctx->data[61] = (uint8_t)(ctx->bitlen >> 16);
    ctx->data[62] = (uint8_t)(ctx->bitlen >> 8);
    ctx->data[63] = (uint8_t)(ctx->bitlen);
    uh_sha1_transform(ctx, ctx->data);
    for (int j = 0; j < 5; j++) {
        hash[j * 4] = (uint8_t)(ctx->state[j] >> 24);
        hash[j * 4 + 1] = (uint8_t)(ctx->state[j] >> 16);
        hash[j * 4 + 2] = (uint8_t)(ctx->state[j] >> 8);
        hash[j * 4 + 3] = (uint8_t)(ctx->state[j]);
    }
}

static int uh_ws_fd(UhValue conn) {
    UhValue fdv = uh_dict_get_key(conn, "__ws_fd");
    if (fdv.tag != UH_NUM) return -1;
    return (int)fdv.num;
}

static UhValue uh_ws_conn(int fd);

static int uh_ws_parse_url(const char *url, char **host, int *port, char **path, int *secure) {
    if (!url) return 0;
    const char *p = NULL;
    if (strncmp(url, "ws://", 5) == 0) {
        p = url + 5;
        if (secure) *secure = 0;
    } else if (strncmp(url, "wss://", 6) == 0) {
        p = url + 6;
        if (secure) *secure = 1;
    } else {
        return 0;
    }
    const char *slash = strchr(p, '/');
    const char *host_end = slash ? slash : p + strlen(p);
    const char *colon = memchr(p, ':', (size_t)(host_end - p));
    int use_port = secure && *secure ? 443 : 80;
    size_t hlen = colon ? (size_t)(colon - p) : (size_t)(host_end - p);
    if (hlen == 0) return 0;
    char *h = (char *)malloc(hlen + 1);
    if (!h) return 0;
    memcpy(h, p, hlen);
    h[hlen] = '\0';
    if (colon) {
        use_port = atoi(colon + 1);
    }
    const char *path_start = slash ? slash : "/";
    char *pp = uh_strdup(path_start);
    if (!pp) {
        free(h);
        return 0;
    }
    *host = h;
    *port = use_port;
    *path = pp;
    return 1;
}

static void uh_ws_random_bytes(uint8_t *out, size_t len) {
    FILE *f = fopen("/dev/urandom", "rb");
    if (f) {
        size_t n = fread(out, 1, len, f);
        fclose(f);
        if (n == len) return;
    }
    for (size_t i = 0; i < len; i++) out[i] = (uint8_t)(rand() & 0xff);
}

static int uh_ws_validate_accept(const char *key, const char *accept) {
    const char *guid = "258EAFA5-E914-47DA-95CA-C5AB0DC85B11";
    char combo[256];
    snprintf(combo, sizeof(combo), "%s%s", key, guid);
    UhSha1 sha;
    uint8_t digest[20];
    uh_sha1_init(&sha);
    uh_sha1_update(&sha, (const uint8_t *)combo, strlen(combo));
    uh_sha1_final(&sha, digest);
    char *expect = uh_base64_encode(digest, sizeof(digest));
    if (!expect) return 0;
    int ok = (strcmp(expect, accept) == 0);
    free(expect);
    return ok;
}

static int uh_ws_handshake_client(int fd, const char *host, int port, const char *path) {
    uint8_t key_bytes[16];
    uh_ws_random_bytes(key_bytes, sizeof(key_bytes));
    char *key = uh_base64_encode(key_bytes, sizeof(key_bytes));
    if (!key) return 0;
    char req[1024];
    snprintf(req, sizeof(req),
             "GET %s HTTP/1.1\r\n"
             "Host: %s:%d\r\n"
             "Upgrade: websocket\r\n"
             "Connection: Upgrade\r\n"
             "Sec-WebSocket-Key: %s\r\n"
             "Sec-WebSocket-Version: 13\r\n\r\n",
             path, host, port, key);
    if (send(fd, req, strlen(req), 0) < 0) {
        free(key);
        return 0;
    }
    char buf[4096];
    size_t len = 0;
    while (len < sizeof(buf) - 1) {
        ssize_t n = recv(fd, buf + len, sizeof(buf) - 1 - len, 0);
        if (n <= 0) break;
        len += (size_t)n;
        buf[len] = '\0';
        if (strstr(buf, "\r\n\r\n")) break;
    }
    if (len == 0 || strstr(buf, " 101 ") == NULL) {
        free(key);
        return 0;
    }
    const char *acc_hdr = "Sec-WebSocket-Accept:";
    char *acc_pos = strstr(buf, acc_hdr);
    if (!acc_pos) {
        free(key);
        return 0;
    }
    acc_pos += strlen(acc_hdr);
    while (*acc_pos == ' ' || *acc_pos == '\t') acc_pos++;
    char accept[128];
    size_t alen = 0;
    while (*acc_pos && *acc_pos != '\r' && *acc_pos != '\n' && alen < sizeof(accept) - 1) {
        accept[alen++] = *acc_pos++;
    }
    accept[alen] = '\0';
    int ok = uh_ws_validate_accept(key, accept);
    free(key);
    return ok;
}

UhValue uh_ws_connect(UhValue cfg) {
    const char *url = NULL;
    const char *host = NULL;
    const char *path = "/";
    int port = 0;
    int secure = 0;
    if (cfg.tag == UH_STR && cfg.str) {
        url = cfg.str;
    } else if (cfg.tag == UH_DICT && cfg.dict) {
        UhValue uv = uh_dict_get_key(cfg, "url");
        if (uv.tag == UH_STR && uv.str) {
            url = uv.str;
        } else {
            host = uh_dict_get_str(cfg, "host");
            UhValue pv = uh_dict_get_key(cfg, "port");
            UhValue pathv = uh_dict_get_key(cfg, "path");
            if (pv.tag == UH_NUM) port = (int)pv.num;
            if (pathv.tag == UH_STR && pathv.str) path = pathv.str;
        }
    }
    char *h = NULL;
    char *p = NULL;
    if (url) {
        if (!uh_ws_parse_url(url, &h, &port, &p, &secure)) {
            return uh_null();
        }
        host = h;
        path = p;
    }
    if (!host || port <= 0) {
        free(h);
        free(p);
        return uh_null();
    }
    if (secure) {
        free(h);
        free(p);
        return uh_null();
    }
    struct addrinfo hints;
    memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;
    char portbuf[16];
    snprintf(portbuf, sizeof(portbuf), "%d", port);
    struct addrinfo *res = NULL;
    if (getaddrinfo(host, portbuf, &hints, &res) != 0 || !res) {
        free(h);
        free(p);
        return uh_null();
    }
    int fd = -1;
    for (struct addrinfo *rp = res; rp; rp = rp->ai_next) {
        fd = socket(rp->ai_family, rp->ai_socktype, rp->ai_protocol);
        if (fd < 0) continue;
        if (connect(fd, rp->ai_addr, rp->ai_addrlen) == 0) break;
        close(fd);
        fd = -1;
    }
    freeaddrinfo(res);
    if (fd < 0) {
        free(h);
        free(p);
        return uh_null();
    }
    if (!uh_ws_handshake_client(fd, host, port, path)) {
        close(fd);
        free(h);
        free(p);
        return uh_null();
    }
    UhValue conn = uh_ws_conn(fd);
    free(h);
    free(p);
    return conn;
}

static int uh_ws_handshake(int fd) {
    char buf[4096];
    size_t len = 0;
    while (len < sizeof(buf) - 1) {
        ssize_t n = recv(fd, buf + len, sizeof(buf) - 1 - len, 0);
        if (n <= 0) break;
        len += (size_t)n;
        buf[len] = '\0';
        if (strstr(buf, "\r\n\r\n")) break;
    }
    if (len == 0) return 0;
    const char *key_hdr = "Sec-WebSocket-Key:";
    char *key_pos = strstr(buf, key_hdr);
    if (!key_pos) return 0;
    key_pos += strlen(key_hdr);
    while (*key_pos == ' ' || *key_pos == '\t') key_pos++;
    char key[128];
    size_t klen = 0;
    while (*key_pos && *key_pos != '\r' && *key_pos != '\n' && klen < sizeof(key) - 1) {
        key[klen++] = *key_pos++;
    }
    key[klen] = '\0';
    if (klen == 0) return 0;
    const char *guid = "258EAFA5-E914-47DA-95CA-C5AB0DC85B11";
    char combo[256];
    snprintf(combo, sizeof(combo), "%s%s", key, guid);
    UhSha1 sha;
    uint8_t digest[20];
    uh_sha1_init(&sha);
    uh_sha1_update(&sha, (const uint8_t *)combo, strlen(combo));
    uh_sha1_final(&sha, digest);
    char *accept = uh_base64_encode(digest, sizeof(digest));
    if (!accept) return 0;
    char resp[512];
    snprintf(resp, sizeof(resp),
             "HTTP/1.1 101 Switching Protocols\r\n"
             "Upgrade: websocket\r\n"
             "Connection: Upgrade\r\n"
             "Sec-WebSocket-Accept: %s\r\n\r\n",
             accept);
    free(accept);
    send(fd, resp, strlen(resp), 0);
    return 1;
}

static int uh_ws_send_frame(int fd, uint8_t opcode, const char *msg, size_t len) {
    unsigned char hdr[10];
    size_t hlen = 0;
    hdr[0] = (unsigned char)(0x80 | (opcode & 0x0f));
    if (len <= 125) {
        hdr[1] = (unsigned char)len;
        hlen = 2;
    } else if (len <= 65535) {
        hdr[1] = 126;
        hdr[2] = (unsigned char)((len >> 8) & 0xff);
        hdr[3] = (unsigned char)(len & 0xff);
        hlen = 4;
    } else {
        hdr[1] = 127;
        for (int i = 0; i < 8; i++) {
            hdr[2 + i] = (unsigned char)((len >> (56 - i * 8)) & 0xff);
        }
        hlen = 10;
    }
    if (send(fd, hdr, hlen, 0) != (ssize_t)hlen) return 0;
    if (len > 0 && send(fd, msg, len, 0) != (ssize_t)len) return 0;
    return 1;
}

static int uh_ws_send_text(int fd, const char *msg, size_t len) {
    return uh_ws_send_frame(fd, 0x1, msg, len);
}

UhValue uh_ws_receive(UhValue conn) {
    int fd = uh_ws_fd(conn);
    if (fd < 0) return uh_null();
    for (;;) {
        unsigned char hdr[2];
        ssize_t n = recv(fd, hdr, 2, MSG_WAITALL);
        if (n <= 0) return uh_null();
        unsigned char opcode = hdr[0] & 0x0f;
        unsigned char masked = hdr[1] & 0x80;
        uint64_t len = hdr[1] & 0x7f;
        if (len == 126) {
            unsigned char ext[2];
            if (recv(fd, ext, 2, MSG_WAITALL) != 2) return uh_null();
            len = ((uint64_t)ext[0] << 8) | (uint64_t)ext[1];
        } else if (len == 127) {
            unsigned char ext[8];
            if (recv(fd, ext, 8, MSG_WAITALL) != 8) return uh_null();
            len = 0;
            for (int i = 0; i < 8; i++) len = (len << 8) | ext[i];
        }
        unsigned char mask[4] = {0, 0, 0, 0};
        if (masked) {
            if (recv(fd, mask, 4, MSG_WAITALL) != 4) return uh_null();
        }
        if (len > (1024 * 1024)) return uh_null();
        char *payload = (char *)malloc((size_t)len + 1);
        if (!payload) return uh_null();
        if (len > 0 && recv(fd, payload, (size_t)len, MSG_WAITALL) != (ssize_t)len) {
            free(payload);
            return uh_null();
        }
        if (masked) {
            for (uint64_t i = 0; i < len; i++) {
                payload[i] = (char)(payload[i] ^ mask[i % 4]);
            }
        }
        payload[len] = '\0';
        if (opcode == 0x8) {
            free(payload);
            return uh_null();
        }
        if (opcode == 0x9) {
            uh_ws_send_frame(fd, 0xA, payload, (size_t)len);
            free(payload);
            continue;
        }
        if (opcode != 0x1) {
            free(payload);
            continue;
        }
        UhValue out = uh_str(payload);
        free(payload);
        return out;
    }
}

static UhValue uh_ws_conn(int fd) {
    UhValue conn = uh_dict_new();
    uh_dict_set(&conn, uh_str("__ws_fd"), uh_num((double)fd));
    return conn;
}

UhValue uh_ws_serve(UhValue cfg) {
    int port = 0;
    const char *handler = NULL;
    if (cfg.tag == UH_DICT) {
        UhValue pv = uh_dict_get_key(cfg, "port");
        if (pv.tag == UH_NUM) port = (int)pv.num;
        handler = uh_dict_get_str(cfg, "handler");
    }
    if (port <= 0 || !handler) return uh_num(0);
    int fd = socket(AF_INET, SOCK_STREAM, 0);
    if (fd < 0) return uh_num(0);
    int opt = 1;
    setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));
    struct sockaddr_in sa;
    memset(&sa, 0, sizeof(sa));
    sa.sin_family = AF_INET;
    sa.sin_addr.s_addr = htonl(INADDR_ANY);
    sa.sin_port = htons((uint16_t)port);
    if (bind(fd, (struct sockaddr *)&sa, sizeof(sa)) != 0) {
        close(fd);
        return uh_num(0);
    }
    if (listen(fd, 16) != 0) {
        close(fd);
        return uh_num(0);
    }
    for (;;) {
        int cfd = accept(fd, NULL, NULL);
        if (cfd < 0) continue;
        if (!uh_ws_handshake(cfd)) {
            close(cfd);
            continue;
        }
        UhEnv *env = uh_get_global_env();
        if (env) {
            UhValue conn = uh_ws_conn(cfd);
            UhValue args[1] = {conn};
            uh_call_named(env, handler, 1, args);
        }
        close(cfd);
    }
    close(fd);
    return uh_num(1);
}

typedef struct {
    const char *data;
    size_t len;
    size_t pos;
} UhUpload;

static size_t uh_smtp_read_cb(char *ptr, size_t size, size_t nmemb, void *userdata) {
    UhUpload *u = (UhUpload *)userdata;
    size_t max = size * nmemb;
    size_t remain = (u->pos < u->len) ? (u->len - u->pos) : 0;
    size_t n = remain < max ? remain : max;
    if (n > 0) {
        memcpy(ptr, u->data + u->pos, n);
        u->pos += n;
    }
    return n;
}

static UhValue uh_smtp_send(UhValue msg, UhValue client) {
    const char *host = uh_dict_get_str(client, "host");
    const char *user = uh_dict_get_str(client, "username");
    const char *pass = uh_dict_get_str(client, "password");
    UhValue pv = uh_dict_get_key(client, "port");
    UhValue tlsv = uh_dict_get_key(client, "tls");
    UhValue stlsv = uh_dict_get_key(client, "starttls");
    UhValue inv = uh_dict_get_key(client, "insecure");
    int port = (pv.tag == UH_NUM) ? (int)pv.num : 25;
    int use_tls = (tlsv.tag == UH_NUM && tlsv.num != 0);
    int use_starttls = (stlsv.tag == UH_NUM && stlsv.num != 0);
    int insecure = (inv.tag == UH_NUM && inv.num != 0);

    const char *from = uh_dict_get_str(msg, "from");
    const char *subject = uh_dict_get_str(msg, "subject");
    const char *body = uh_dict_get_str(msg, "body");
    const char *html = uh_dict_get_str(msg, "html");
    UhValue to = uh_dict_get_key(msg, "to");
    UhValue cc = uh_dict_get_key(msg, "cc");
    if (!host || !from || (!body && !html)) return uh_num(0);

    char url[256];
    const char *scheme = use_tls ? "smtps" : "smtp";
    snprintf(url, sizeof(url), "%s://%s:%d", scheme, host, port);

    char *content = NULL;
    size_t clen = 0, ccap = 0;
    uh_buf_append(&content, &clen, &ccap, "From: ");
    uh_buf_append(&content, &clen, &ccap, from);
    uh_buf_append(&content, &clen, &ccap, "\r\n");
    if (to.tag == UH_ARR && to.arr && to.arr->len > 0) {
        uh_buf_append(&content, &clen, &ccap, "To: ");
        for (size_t i = 0; i < to.arr->len; i++) {
            char *addr = uh_value_to_cstr(to.arr->items[i]);
            if (addr) {
                if (i > 0) uh_buf_append(&content, &clen, &ccap, ", ");
                uh_buf_append(&content, &clen, &ccap, addr);
            }
            free(addr);
        }
        uh_buf_append(&content, &clen, &ccap, "\r\n");
    }
    if (cc.tag == UH_ARR && cc.arr && cc.arr->len > 0) {
        uh_buf_append(&content, &clen, &ccap, "Cc: ");
        for (size_t i = 0; i < cc.arr->len; i++) {
            char *addr = uh_value_to_cstr(cc.arr->items[i]);
            if (addr) {
                if (i > 0) uh_buf_append(&content, &clen, &ccap, ", ");
                uh_buf_append(&content, &clen, &ccap, addr);
            }
            free(addr);
        }
        uh_buf_append(&content, &clen, &ccap, "\r\n");
    }
    if (subject) {
        uh_buf_append(&content, &clen, &ccap, "Subject: ");
        uh_buf_append(&content, &clen, &ccap, subject);
        uh_buf_append(&content, &clen, &ccap, "\r\n");
    }
    if (html && body) {
        const char *boundary = "uh-boundary-42";
        uh_buf_append(&content, &clen, &ccap, "MIME-Version: 1.0\r\n");
        uh_buf_append(&content, &clen, &ccap, "Content-Type: multipart/alternative; boundary=\"");
        uh_buf_append(&content, &clen, &ccap, boundary);
        uh_buf_append(&content, &clen, &ccap, "\"\r\n\r\n");
        uh_buf_append(&content, &clen, &ccap, "--");
        uh_buf_append(&content, &clen, &ccap, boundary);
        uh_buf_append(&content, &clen, &ccap, "\r\nContent-Type: text/plain; charset=utf-8\r\n\r\n");
        uh_buf_append(&content, &clen, &ccap, body);
        uh_buf_append(&content, &clen, &ccap, "\r\n--");
        uh_buf_append(&content, &clen, &ccap, boundary);
        uh_buf_append(&content, &clen, &ccap, "\r\nContent-Type: text/html; charset=utf-8\r\n\r\n");
        uh_buf_append(&content, &clen, &ccap, html);
        uh_buf_append(&content, &clen, &ccap, "\r\n--");
        uh_buf_append(&content, &clen, &ccap, boundary);
        uh_buf_append(&content, &clen, &ccap, "--\r\n");
    } else if (html) {
        uh_buf_append(&content, &clen, &ccap, "MIME-Version: 1.0\r\n");
        uh_buf_append(&content, &clen, &ccap, "Content-Type: text/html; charset=utf-8\r\n\r\n");
        uh_buf_append(&content, &clen, &ccap, html);
    } else {
        uh_buf_append(&content, &clen, &ccap, "\r\n");
        uh_buf_append(&content, &clen, &ccap, body ? body : "");
    }

    struct curl_slist *recipients = NULL;
    if (to.tag == UH_ARR && to.arr) {
        for (size_t i = 0; i < to.arr->len; i++) {
            char *addr = uh_value_to_cstr(to.arr->items[i]);
            if (addr) {
                recipients = curl_slist_append(recipients, addr);
            }
            free(addr);
        }
    }
    if (cc.tag == UH_ARR && cc.arr) {
        for (size_t i = 0; i < cc.arr->len; i++) {
            char *addr = uh_value_to_cstr(cc.arr->items[i]);
            if (addr) {
                recipients = curl_slist_append(recipients, addr);
            }
            free(addr);
        }
    }

    UhUpload upload = {content ? content : "", content ? strlen(content) : 0, 0};

    uh_curl_init_once();
    CURL *curl = curl_easy_init();
    if (!curl) {
        free(content);
        if (recipients) curl_slist_free_all(recipients);
        return uh_num(0);
    }
    curl_easy_setopt(curl, CURLOPT_URL, url);
    curl_easy_setopt(curl, CURLOPT_USERNAME, user ? user : "");
    curl_easy_setopt(curl, CURLOPT_PASSWORD, pass ? pass : "");
    curl_easy_setopt(curl, CURLOPT_MAIL_FROM, from);
    curl_easy_setopt(curl, CURLOPT_MAIL_RCPT, recipients);
    curl_easy_setopt(curl, CURLOPT_READFUNCTION, uh_smtp_read_cb);
    curl_easy_setopt(curl, CURLOPT_READDATA, &upload);
    curl_easy_setopt(curl, CURLOPT_UPLOAD, 1L);
    if (use_starttls) {
        curl_easy_setopt(curl, CURLOPT_USE_SSL, (long)CURLUSESSL_ALL);
    }
    if (insecure) {
        curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 0L);
        curl_easy_setopt(curl, CURLOPT_SSL_VERIFYHOST, 0L);
    }
    CURLcode rc = curl_easy_perform(curl);
    curl_easy_cleanup(curl);
    if (recipients) curl_slist_free_all(recipients);
    free(content);
    return uh_num(rc == CURLE_OK ? 1 : 0);
}

UhValue uh_smtp_connect(UhValue cfg) {
    UhValue client = uh_dict_new();
    uh_dict_set(&client, uh_str("__smtp"), uh_num(1));
    if (cfg.tag == UH_DICT && cfg.dict) {
        for (size_t i = 0; i < cfg.dict->len; i++) {
            UhValue key = uh_str(cfg.dict->items[i].key);
            uh_dict_set(&client, key, cfg.dict->items[i].val);
        }
    }
    return client;
}

UhValue uh_smtp_disconnect(UhValue client) {
    (void)client;
    return uh_null();
}

UhValue uh_send(UhValue payload, UhValue target) {
    if (target.tag == UH_DICT) {
        UhValue wfd = uh_dict_get_key(target, "__ws_fd");
        if (wfd.tag == UH_NUM) {
            int fd = (int)wfd.num;
            UhValue sendv = payload;
            if (payload.tag == UH_DICT || payload.tag == UH_ARR) {
                sendv = uh_json_stringify(payload);
            }
            char *msg = uh_value_to_cstr(sendv);
            if (msg) {
                uh_ws_send_text(fd, msg, strlen(msg));
            }
            free(msg);
            return uh_null();
        }
        UhValue smtp = uh_dict_get_key(target, "__smtp");
        if (smtp.tag == UH_NUM && smtp.num != 0) {
            return uh_smtp_send(payload, target);
        }
    }
    return uh_null();
}

typedef struct {
    uint32_t state[8];
    uint64_t bitlen;
    uint8_t data[64];
    size_t datalen;
} UhSha256;

static uint32_t uh_rotr(uint32_t x, uint32_t n) {
    return (x >> n) | (x << (32 - n));
}

static void uh_sha256_transform(UhSha256 *ctx, const uint8_t data[64]) {
    static const uint32_t k[64] = {
        0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
        0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
        0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
        0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
        0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
        0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
        0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
        0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2
    };
    uint32_t m[64];
    for (int i = 0; i < 16; i++) {
        m[i] = (uint32_t)data[i * 4] << 24 |
               (uint32_t)data[i * 4 + 1] << 16 |
               (uint32_t)data[i * 4 + 2] << 8 |
               (uint32_t)data[i * 4 + 3];
    }
    for (int i = 16; i < 64; i++) {
        uint32_t s0 = uh_rotr(m[i - 15], 7) ^ uh_rotr(m[i - 15], 18) ^ (m[i - 15] >> 3);
        uint32_t s1 = uh_rotr(m[i - 2], 17) ^ uh_rotr(m[i - 2], 19) ^ (m[i - 2] >> 10);
        m[i] = m[i - 16] + s0 + m[i - 7] + s1;
    }
    uint32_t a = ctx->state[0];
    uint32_t b = ctx->state[1];
    uint32_t c = ctx->state[2];
    uint32_t d = ctx->state[3];
    uint32_t e = ctx->state[4];
    uint32_t f = ctx->state[5];
    uint32_t g = ctx->state[6];
    uint32_t h = ctx->state[7];
    for (int i = 0; i < 64; i++) {
        uint32_t S1 = uh_rotr(e, 6) ^ uh_rotr(e, 11) ^ uh_rotr(e, 25);
        uint32_t ch = (e & f) ^ (~e & g);
        uint32_t temp1 = h + S1 + ch + k[i] + m[i];
        uint32_t S0 = uh_rotr(a, 2) ^ uh_rotr(a, 13) ^ uh_rotr(a, 22);
        uint32_t maj = (a & b) ^ (a & c) ^ (b & c);
        uint32_t temp2 = S0 + maj;
        h = g;
        g = f;
        f = e;
        e = d + temp1;
        d = c;
        c = b;
        b = a;
        a = temp1 + temp2;
    }
    ctx->state[0] += a;
    ctx->state[1] += b;
    ctx->state[2] += c;
    ctx->state[3] += d;
    ctx->state[4] += e;
    ctx->state[5] += f;
    ctx->state[6] += g;
    ctx->state[7] += h;
}

static void uh_sha256_init(UhSha256 *ctx) {
    ctx->datalen = 0;
    ctx->bitlen = 0;
    ctx->state[0] = 0x6a09e667;
    ctx->state[1] = 0xbb67ae85;
    ctx->state[2] = 0x3c6ef372;
    ctx->state[3] = 0xa54ff53a;
    ctx->state[4] = 0x510e527f;
    ctx->state[5] = 0x9b05688c;
    ctx->state[6] = 0x1f83d9ab;
    ctx->state[7] = 0x5be0cd19;
}

static void uh_sha256_update(UhSha256 *ctx, const uint8_t *data, size_t len) {
    for (size_t i = 0; i < len; i++) {
        ctx->data[ctx->datalen++] = data[i];
        if (ctx->datalen == 64) {
            uh_sha256_transform(ctx, ctx->data);
            ctx->bitlen += 512;
            ctx->datalen = 0;
        }
    }
}

static void uh_sha256_final(UhSha256 *ctx, uint8_t hash[32]) {
    size_t i = ctx->datalen;
    if (ctx->datalen < 56) {
        ctx->data[i++] = 0x80;
        while (i < 56) ctx->data[i++] = 0x00;
    } else {
        ctx->data[i++] = 0x80;
        while (i < 64) ctx->data[i++] = 0x00;
        uh_sha256_transform(ctx, ctx->data);
        memset(ctx->data, 0, 56);
    }
    ctx->bitlen += ctx->datalen * 8;
    ctx->data[63] = (uint8_t)(ctx->bitlen);
    ctx->data[62] = (uint8_t)(ctx->bitlen >> 8);
    ctx->data[61] = (uint8_t)(ctx->bitlen >> 16);
    ctx->data[60] = (uint8_t)(ctx->bitlen >> 24);
    ctx->data[59] = (uint8_t)(ctx->bitlen >> 32);
    ctx->data[58] = (uint8_t)(ctx->bitlen >> 40);
    ctx->data[57] = (uint8_t)(ctx->bitlen >> 48);
    ctx->data[56] = (uint8_t)(ctx->bitlen >> 56);
    uh_sha256_transform(ctx, ctx->data);
    for (i = 0; i < 4; i++) {
        hash[i]      = (uint8_t)(ctx->state[0] >> (24 - i * 8));
        hash[i + 4]  = (uint8_t)(ctx->state[1] >> (24 - i * 8));
        hash[i + 8]  = (uint8_t)(ctx->state[2] >> (24 - i * 8));
        hash[i + 12] = (uint8_t)(ctx->state[3] >> (24 - i * 8));
        hash[i + 16] = (uint8_t)(ctx->state[4] >> (24 - i * 8));
        hash[i + 20] = (uint8_t)(ctx->state[5] >> (24 - i * 8));
        hash[i + 24] = (uint8_t)(ctx->state[6] >> (24 - i * 8));
        hash[i + 28] = (uint8_t)(ctx->state[7] >> (24 - i * 8));
    }
}

static UhValue uh_sha256_hex(const uint8_t hash[32]) {
    char buf[65];
    for (int i = 0; i < 32; i++) {
        snprintf(buf + i * 2, 3, "%02x", hash[i]);
    }
    buf[64] = '\0';
    return uh_str(buf);
}

UhValue uh_crypto_sha256(UhValue v) {
    char *s = uh_value_to_cstr(v);
    if (!s) return uh_str("");
    UhSha256 ctx;
    uint8_t hash[32];
    uh_sha256_init(&ctx);
    uh_sha256_update(&ctx, (const uint8_t *)s, strlen(s));
    uh_sha256_final(&ctx, hash);
    free(s);
    return uh_sha256_hex(hash);
}

UhValue uh_crypto_hmac_sha256(UhValue msg, UhValue key) {
    char *m = uh_value_to_cstr(msg);
    char *k = uh_value_to_cstr(key);
    if (!m || !k) {
        free(m);
        free(k);
        return uh_str("");
    }
    uint8_t key_block[64];
    memset(key_block, 0, sizeof(key_block));
    size_t klen = strlen(k);
    if (klen > 64) {
        UhSha256 kctx;
        uint8_t khash[32];
        uh_sha256_init(&kctx);
        uh_sha256_update(&kctx, (const uint8_t *)k, klen);
        uh_sha256_final(&kctx, khash);
        memcpy(key_block, khash, 32);
    } else {
        memcpy(key_block, k, klen);
    }
    uint8_t o_key[64], i_key[64];
    for (int i = 0; i < 64; i++) {
        o_key[i] = key_block[i] ^ 0x5c;
        i_key[i] = key_block[i] ^ 0x36;
    }
    UhSha256 ictx;
    uint8_t ihash[32];
    uh_sha256_init(&ictx);
    uh_sha256_update(&ictx, i_key, 64);
    uh_sha256_update(&ictx, (const uint8_t *)m, strlen(m));
    uh_sha256_final(&ictx, ihash);

    UhSha256 octx;
    uint8_t ohash[32];
    uh_sha256_init(&octx);
    uh_sha256_update(&octx, o_key, 64);
    uh_sha256_update(&octx, ihash, 32);
    uh_sha256_final(&octx, ohash);

    free(m);
    free(k);
    return uh_sha256_hex(ohash);
}

UhValue uh_crypto_random_bytes(UhValue n) {
    if (n.tag != UH_NUM || n.num <= 0) return uh_str("");
    size_t len = (size_t)n.num;
    char *buf = (char *)malloc(len + 1);
    if (!buf) return uh_str("");
    FILE *f = fopen("/dev/urandom", "rb");
    if (f) {
        fread(buf, 1, len, f);
        fclose(f);
    } else {
        for (size_t i = 0; i < len; i++) {
            buf[i] = (char)(rand() & 0xff);
        }
    }
    for (size_t i = 0; i < len; i++) {
        if (buf[i] == '\0') buf[i] = 1;
    }
    buf[len] = '\0';
    UhValue out = uh_str(buf);
    free(buf);
    return out;
}

static char *uh_hex_encode_bytes(const unsigned char *data, size_t len) {
    char *out = (char *)malloc(len * 2 + 1);
    if (!out) return NULL;
    for (size_t i = 0; i < len; i++) {
        snprintf(out + i * 2, 3, "%02x", data[i]);
    }
    out[len * 2] = '\0';
    return out;
}

static unsigned char *uh_hex_decode_bytes(const char *hex, size_t *out_len) {
    size_t len = strlen(hex);
    if (len % 2 != 0) return NULL;
    size_t blen = len / 2;
    unsigned char *out = (unsigned char *)malloc(blen);
    if (!out) return NULL;
    for (size_t i = 0; i < blen; i++) {
        unsigned int v;
        if (sscanf(hex + i * 2, "%2x", &v) != 1) {
            free(out);
            return NULL;
        }
        out[i] = (unsigned char)v;
    }
    if (out_len) *out_len = blen;
    return out;
}

typedef struct {
    uint8_t RoundKey[240];
    uint8_t Iv[16];
} UhAesCtx;

static const uint8_t uh_aes_sbox[256] = {
    0x63,0x7c,0x77,0x7b,0xf2,0x6b,0x6f,0xc5,0x30,0x01,0x67,0x2b,0xfe,0xd7,0xab,0x76,
    0xca,0x82,0xc9,0x7d,0xfa,0x59,0x47,0xf0,0xad,0xd4,0xa2,0xaf,0x9c,0xa4,0x72,0xc0,
    0xb7,0xfd,0x93,0x26,0x36,0x3f,0xf7,0xcc,0x34,0xa5,0xe5,0xf1,0x71,0xd8,0x31,0x15,
    0x04,0xc7,0x23,0xc3,0x18,0x96,0x05,0x9a,0x07,0x12,0x80,0xe2,0xeb,0x27,0xb2,0x75,
    0x09,0x83,0x2c,0x1a,0x1b,0x6e,0x5a,0xa0,0x52,0x3b,0xd6,0xb3,0x29,0xe3,0x2f,0x84,
    0x53,0xd1,0x00,0xed,0x20,0xfc,0xb1,0x5b,0x6a,0xcb,0xbe,0x39,0x4a,0x4c,0x58,0xcf,
    0xd0,0xef,0xaa,0xfb,0x43,0x4d,0x33,0x85,0x45,0xf9,0x02,0x7f,0x50,0x3c,0x9f,0xa8,
    0x51,0xa3,0x40,0x8f,0x92,0x9d,0x38,0xf5,0xbc,0xb6,0xda,0x21,0x10,0xff,0xf3,0xd2,
    0xcd,0x0c,0x13,0xec,0x5f,0x97,0x44,0x17,0xc4,0xa7,0x7e,0x3d,0x64,0x5d,0x19,0x73,
    0x60,0x81,0x4f,0xdc,0x22,0x2a,0x90,0x88,0x46,0xee,0xb8,0x14,0xde,0x5e,0x0b,0xdb,
    0xe0,0x32,0x3a,0x0a,0x49,0x06,0x24,0x5c,0xc2,0xd3,0xac,0x62,0x91,0x95,0xe4,0x79,
    0xe7,0xc8,0x37,0x6d,0x8d,0xd5,0x4e,0xa9,0x6c,0x56,0xf4,0xea,0x65,0x7a,0xae,0x08,
    0xba,0x78,0x25,0x2e,0x1c,0xa6,0xb4,0xc6,0xe8,0xdd,0x74,0x1f,0x4b,0xbd,0x8b,0x8a,
    0x70,0x3e,0xb5,0x66,0x48,0x03,0xf6,0x0e,0x61,0x35,0x57,0xb9,0x86,0xc1,0x1d,0x9e,
    0xe1,0xf8,0x98,0x11,0x69,0xd9,0x8e,0x94,0x9b,0x1e,0x87,0xe9,0xce,0x55,0x28,0xdf,
    0x8c,0xa1,0x89,0x0d,0xbf,0xe6,0x42,0x68,0x41,0x99,0x2d,0x0f,0xb0,0x54,0xbb,0x16
};

static const uint8_t uh_aes_rsbox[256] = {
    0x52,0x09,0x6a,0xd5,0x30,0x36,0xa5,0x38,0xbf,0x40,0xa3,0x9e,0x81,0xf3,0xd7,0xfb,
    0x7c,0xe3,0x39,0x82,0x9b,0x2f,0xff,0x87,0x34,0x8e,0x43,0x44,0xc4,0xde,0xe9,0xcb,
    0x54,0x7b,0x94,0x32,0xa6,0xc2,0x23,0x3d,0xee,0x4c,0x95,0x0b,0x42,0xfa,0xc3,0x4e,
    0x08,0x2e,0xa1,0x66,0x28,0xd9,0x24,0xb2,0x76,0x5b,0xa2,0x49,0x6d,0x8b,0xd1,0x25,
    0x72,0xf8,0xf6,0x64,0x86,0x68,0x98,0x16,0xd4,0xa4,0x5c,0xcc,0x5d,0x65,0xb6,0x92,
    0x6c,0x70,0x48,0x50,0xfd,0xed,0xb9,0xda,0x5e,0x15,0x46,0x57,0xa7,0x8d,0x9d,0x84,
    0x90,0xd8,0xab,0x00,0x8c,0xbc,0xd3,0x0a,0xf7,0xe4,0x58,0x05,0xb8,0xb3,0x45,0x06,
    0xd0,0x2c,0x1e,0x8f,0xca,0x3f,0x0f,0x02,0xc1,0xaf,0xbd,0x03,0x01,0x13,0x8a,0x6b,
    0x3a,0x91,0x11,0x41,0x4f,0x67,0xdc,0xea,0x97,0xf2,0xcf,0xce,0xf0,0xb4,0xe6,0x73,
    0x96,0xac,0x74,0x22,0xe7,0xad,0x35,0x85,0xe2,0xf9,0x37,0xe8,0x1c,0x75,0xdf,0x6e,
    0x47,0xf1,0x1a,0x71,0x1d,0x29,0xc5,0x89,0x6f,0xb7,0x62,0x0e,0xaa,0x18,0xbe,0x1b,
    0xfc,0x56,0x3e,0x4b,0xc6,0xd2,0x79,0x20,0x9a,0xdb,0xc0,0xfe,0x78,0xcd,0x5a,0xf4,
    0x1f,0xdd,0xa8,0x33,0x88,0x07,0xc7,0x31,0xb1,0x12,0x10,0x59,0x27,0x80,0xec,0x5f,
    0x60,0x51,0x7f,0xa9,0x19,0xb5,0x4a,0x0d,0x2d,0xe5,0x7a,0x9f,0x93,0xc9,0x9c,0xef,
    0xa0,0xe0,0x3b,0x4d,0xae,0x2a,0xf5,0xb0,0xc8,0xeb,0xbb,0x3c,0x83,0x53,0x99,0x61,
    0x17,0x2b,0x04,0x7e,0xba,0x77,0xd6,0x26,0xe1,0x69,0x14,0x63,0x55,0x21,0x0c,0x7d
};

static const uint8_t uh_aes_rcon[11] = {
    0x00,0x01,0x02,0x04,0x08,0x10,0x20,0x40,0x80,0x1b,0x36
};

static uint8_t uh_aes_xtime(uint8_t x) {
    return (uint8_t)((x << 1) ^ (((x >> 7) & 1) * 0x1b));
}

static void uh_aes_key_expansion(UhAesCtx *ctx, const uint8_t *key) {
    uint8_t *rk = ctx->RoundKey;
    memcpy(rk, key, 32);
    int i = 8;
    uint8_t tmp[4];
    while (i < 60) {
        tmp[0] = rk[(i - 1) * 4 + 0];
        tmp[1] = rk[(i - 1) * 4 + 1];
        tmp[2] = rk[(i - 1) * 4 + 2];
        tmp[3] = rk[(i - 1) * 4 + 3];
        if (i % 8 == 0) {
            uint8_t t = tmp[0];
            tmp[0] = tmp[1];
            tmp[1] = tmp[2];
            tmp[2] = tmp[3];
            tmp[3] = t;
            tmp[0] = uh_aes_sbox[tmp[0]];
            tmp[1] = uh_aes_sbox[tmp[1]];
            tmp[2] = uh_aes_sbox[tmp[2]];
            tmp[3] = uh_aes_sbox[tmp[3]];
            tmp[0] ^= uh_aes_rcon[i / 8];
        } else if (i % 8 == 4) {
            tmp[0] = uh_aes_sbox[tmp[0]];
            tmp[1] = uh_aes_sbox[tmp[1]];
            tmp[2] = uh_aes_sbox[tmp[2]];
            tmp[3] = uh_aes_sbox[tmp[3]];
        }
        rk[i * 4 + 0] = rk[(i - 8) * 4 + 0] ^ tmp[0];
        rk[i * 4 + 1] = rk[(i - 8) * 4 + 1] ^ tmp[1];
        rk[i * 4 + 2] = rk[(i - 8) * 4 + 2] ^ tmp[2];
        rk[i * 4 + 3] = rk[(i - 8) * 4 + 3] ^ tmp[3];
        i++;
    }
}

static void uh_aes_add_round_key(uint8_t round, uint8_t *state, const uint8_t *rk) {
    for (int i = 0; i < 16; i++) {
        state[i] ^= rk[round * 16 + i];
    }
}

static void uh_aes_sub_bytes(uint8_t *state) {
    for (int i = 0; i < 16; i++) {
        state[i] = uh_aes_sbox[state[i]];
    }
}

static void uh_aes_inv_sub_bytes(uint8_t *state) {
    for (int i = 0; i < 16; i++) {
        state[i] = uh_aes_rsbox[state[i]];
    }
}

static void uh_aes_shift_rows(uint8_t *state) {
    uint8_t temp;
    temp = state[1];
    state[1] = state[5];
    state[5] = state[9];
    state[9] = state[13];
    state[13] = temp;
    temp = state[2];
    state[2] = state[10];
    state[10] = temp;
    temp = state[6];
    state[6] = state[14];
    state[14] = temp;
    temp = state[3];
    state[3] = state[15];
    state[15] = state[11];
    state[11] = state[7];
    state[7] = temp;
}

static void uh_aes_inv_shift_rows(uint8_t *state) {
    uint8_t temp;
    temp = state[13];
    state[13] = state[9];
    state[9] = state[5];
    state[5] = state[1];
    state[1] = temp;
    temp = state[2];
    state[2] = state[10];
    state[10] = temp;
    temp = state[6];
    state[6] = state[14];
    state[14] = temp;
    temp = state[3];
    state[3] = state[7];
    state[7] = state[11];
    state[11] = state[15];
    state[15] = temp;
}

static void uh_aes_mix_columns(uint8_t *state) {
    for (int i = 0; i < 4; i++) {
        uint8_t *c = state + i * 4;
        uint8_t t = c[0] ^ c[1] ^ c[2] ^ c[3];
        uint8_t tmp = c[0];
        c[0] ^= t ^ uh_aes_xtime(c[0] ^ c[1]);
        c[1] ^= t ^ uh_aes_xtime(c[1] ^ c[2]);
        c[2] ^= t ^ uh_aes_xtime(c[2] ^ c[3]);
        c[3] ^= t ^ uh_aes_xtime(c[3] ^ tmp);
    }
}

static void uh_aes_inv_mix_columns(uint8_t *state) {
    for (int i = 0; i < 4; i++) {
        uint8_t *c = state + i * 4;
        uint8_t a = c[0];
        uint8_t b = c[1];
        uint8_t d = c[2];
        uint8_t e = c[3];
        uint8_t a2 = uh_aes_xtime(a);
        uint8_t b2 = uh_aes_xtime(b);
        uint8_t d2 = uh_aes_xtime(d);
        uint8_t e2 = uh_aes_xtime(e);
        uint8_t a4 = uh_aes_xtime(a2);
        uint8_t b4 = uh_aes_xtime(b2);
        uint8_t d4 = uh_aes_xtime(d2);
        uint8_t e4 = uh_aes_xtime(e2);
        uint8_t a8 = uh_aes_xtime(a4);
        uint8_t b8 = uh_aes_xtime(b4);
        uint8_t d8 = uh_aes_xtime(d4);
        uint8_t e8 = uh_aes_xtime(e4);
        uint8_t a14 = a8 ^ a4 ^ a2;
        uint8_t b14 = b8 ^ b4 ^ b2;
        uint8_t d14 = d8 ^ d4 ^ d2;
        uint8_t e14 = e8 ^ e4 ^ e2;
        uint8_t a11 = a8 ^ a2 ^ a;
        uint8_t b11 = b8 ^ b2 ^ b;
        uint8_t d11 = d8 ^ d2 ^ d;
        uint8_t e11 = e8 ^ e2 ^ e;
        uint8_t a13 = a8 ^ a4 ^ a;
        uint8_t b13 = b8 ^ b4 ^ b;
        uint8_t d13 = d8 ^ d4 ^ d;
        uint8_t e13 = e8 ^ e4 ^ e;
        uint8_t a9 = a8 ^ a;
        uint8_t b9 = b8 ^ b;
        uint8_t d9 = d8 ^ d;
        uint8_t e9 = e8 ^ e;
        c[0] = a14 ^ b11 ^ d13 ^ e9;
        c[1] = a9 ^ b14 ^ d11 ^ e13;
        c[2] = a13 ^ b9 ^ d14 ^ e11;
        c[3] = a11 ^ b13 ^ d9 ^ e14;
    }
}

static void uh_aes_encrypt_block(UhAesCtx *ctx, uint8_t *state) {
    uh_aes_add_round_key(0, state, ctx->RoundKey);
    for (uint8_t round = 1; round < 14; round++) {
        uh_aes_sub_bytes(state);
        uh_aes_shift_rows(state);
        uh_aes_mix_columns(state);
        uh_aes_add_round_key(round, state, ctx->RoundKey);
    }
    uh_aes_sub_bytes(state);
    uh_aes_shift_rows(state);
    uh_aes_add_round_key(14, state, ctx->RoundKey);
}

static void uh_aes_decrypt_block(UhAesCtx *ctx, uint8_t *state) {
    uh_aes_add_round_key(14, state, ctx->RoundKey);
    for (uint8_t round = 13; round > 0; round--) {
        uh_aes_inv_shift_rows(state);
        uh_aes_inv_sub_bytes(state);
        uh_aes_add_round_key(round, state, ctx->RoundKey);
        uh_aes_inv_mix_columns(state);
    }
    uh_aes_inv_shift_rows(state);
    uh_aes_inv_sub_bytes(state);
    uh_aes_add_round_key(0, state, ctx->RoundKey);
}

static void uh_aes_init_ctx_iv(UhAesCtx *ctx, const uint8_t *key, const uint8_t *iv) {
    uh_aes_key_expansion(ctx, key);
    memcpy(ctx->Iv, iv, 16);
}

static void uh_aes_cbc_encrypt_buffer(UhAesCtx *ctx, uint8_t *buf, size_t len) {
    uint8_t *iv = ctx->Iv;
    for (size_t i = 0; i < len; i += 16) {
        for (int j = 0; j < 16; j++) buf[i + j] ^= iv[j];
        uh_aes_encrypt_block(ctx, buf + i);
        iv = buf + i;
    }
    memcpy(ctx->Iv, iv, 16);
}

static void uh_aes_cbc_decrypt_buffer(UhAesCtx *ctx, uint8_t *buf, size_t len) {
    uint8_t store_next_iv[16];
    for (size_t i = 0; i < len; i += 16) {
        memcpy(store_next_iv, buf + i, 16);
        uh_aes_decrypt_block(ctx, buf + i);
        for (int j = 0; j < 16; j++) buf[i + j] ^= ctx->Iv[j];
        memcpy(ctx->Iv, store_next_iv, 16);
    }
}

static void uh_key_from_str(const char *k, uint8_t out[32]) {
    memset(out, 0, 32);
    if (!k) return;
    size_t len = strlen(k);
    if (len > 32) len = 32;
    memcpy(out, k, len);
}

static void uh_random_iv(uint8_t out[16]) {
    FILE *f = fopen("/dev/urandom", "rb");
    if (f) {
        size_t n = fread(out, 1, 16, f);
        fclose(f);
        if (n == 16) return;
    }
    for (int i = 0; i < 16; i++) out[i] = (uint8_t)(rand() & 0xff);
}

UhValue uh_crypto_encrypt_aes(UhValue plaintext, UhValue key) {
    char *t = uh_value_to_cstr(plaintext);
    char *k = uh_value_to_cstr(key);
    if (!t || !k) {
        free(t);
        free(k);
        return uh_str("");
    }
    size_t tlen = strlen(t);
    size_t pad = 16 - (tlen % 16);
    size_t blen = tlen + pad;
    uint8_t *buf = (uint8_t *)malloc(blen);
    if (!buf) {
        free(t);
        free(k);
        return uh_str("");
    }
    memcpy(buf, t, tlen);
    for (size_t i = tlen; i < blen; i++) buf[i] = (uint8_t)pad;
    uint8_t keybuf[32];
    uint8_t iv[16];
    uh_key_from_str(k, keybuf);
    uh_random_iv(iv);
    UhAesCtx ctx;
    uh_aes_init_ctx_iv(&ctx, keybuf, iv);
    uh_aes_cbc_encrypt_buffer(&ctx, buf, blen);
    size_t out_len = 16 + blen;
    unsigned char *out = (unsigned char *)malloc(out_len);
    if (!out) {
        free(buf);
        free(t);
        free(k);
        return uh_str("");
    }
    memcpy(out, iv, 16);
    memcpy(out + 16, buf, blen);
    char *hex = uh_hex_encode_bytes(out, out_len);
    free(out);
    free(buf);
    free(t);
    free(k);
    UhValue outv = uh_str(hex ? hex : "");
    free(hex);
    return outv;
}

UhValue uh_crypto_decrypt_aes(UhValue ciphertext, UhValue key) {
    char *hex = uh_value_to_cstr(ciphertext);
    char *k = uh_value_to_cstr(key);
    if (!hex || !k) {
        free(hex);
        free(k);
        return uh_str("");
    }
    size_t blen = 0;
    unsigned char *bytes = uh_hex_decode_bytes(hex, &blen);
    if (!bytes || blen < 16 || (blen - 16) % 16 != 0) {
        free(hex);
        free(k);
        free(bytes);
        return uh_str("");
    }
    size_t clen = blen - 16;
    uint8_t keybuf[32];
    uint8_t iv[16];
    uh_key_from_str(k, keybuf);
    memcpy(iv, bytes, 16);
    uint8_t *buf = (uint8_t *)malloc(clen);
    if (!buf) {
        free(hex);
        free(k);
        free(bytes);
        return uh_str("");
    }
    memcpy(buf, bytes + 16, clen);
    UhAesCtx ctx;
    uh_aes_init_ctx_iv(&ctx, keybuf, iv);
    uh_aes_cbc_decrypt_buffer(&ctx, buf, clen);
    size_t pad = buf[clen - 1];
    if (pad == 0 || pad > 16) pad = 0;
    size_t outlen = (pad > 0 && pad <= clen) ? (clen - pad) : clen;
    char *outbuf = (char *)malloc(outlen + 1);
    if (!outbuf) {
        free(buf);
        free(hex);
        free(k);
        free(bytes);
        return uh_str("");
    }
    memcpy(outbuf, buf, outlen);
    outbuf[outlen] = '\0';
    free(buf);
    free(hex);
    free(k);
    free(bytes);
    UhValue outv = uh_str(outbuf);
    free(outbuf);
    return outv;
}

static const char *uh_json_skip_ws(const char *s) {
    while (*s == ' ' || *s == '\t' || *s == '\n' || *s == '\r') {
        s++;
    }
    return s;
}

static UhValue uh_json_parse_value(const char **sp);

static UhValue uh_json_parse_string(const char **sp) {
    const char *s = *sp;
    if (*s != '"') {
        return uh_null();
    }
    s++;
    char *buf = NULL;
    size_t len = 0;
    size_t cap = 0;
    while (*s && *s != '"') {
        char ch = *s++;
        if (ch == '\\') {
            char esc = *s++;
            if (esc == 'n') ch = '\n';
            else if (esc == 'r') ch = '\r';
            else if (esc == 't') ch = '\t';
            else if (esc == '"') ch = '"';
            else if (esc == '\\') ch = '\\';
            else ch = esc;
        }
        char tmp[2] = { ch, '\0' };
        uh_buf_append(&buf, &len, &cap, tmp);
    }
    if (*s == '"') {
        s++;
    }
    *sp = s;
    UhValue v;
    v.tag = UH_STR;
    v.num = 0;
    v.str = buf ? buf : uh_strdup("");
    v.arr = NULL;
    v.dict = NULL;
    return v;
}

static UhValue uh_json_parse_array(const char **sp) {
    const char *s = *sp;
    if (*s != '[') {
        return uh_null();
    }
    s++;
    UhValue arr = uh_arr_new();
    s = uh_json_skip_ws(s);
    if (*s == ']') {
        s++;
        *sp = s;
        return arr;
    }
    while (*s) {
        UhValue v = uh_json_parse_value(&s);
        uh_arr_push(&arr, v);
        s = uh_json_skip_ws(s);
        if (*s == ',') {
            s++;
            s = uh_json_skip_ws(s);
            continue;
        }
        if (*s == ']') {
            s++;
            break;
        }
        break;
    }
    *sp = s;
    return arr;
}

static UhValue uh_json_parse_object(const char **sp) {
    const char *s = *sp;
    if (*s != '{') {
        return uh_null();
    }
    s++;
    UhValue obj = uh_dict_new();
    s = uh_json_skip_ws(s);
    if (*s == '}') {
        s++;
        *sp = s;
        return obj;
    }
    while (*s) {
        UhValue key = uh_json_parse_string(&s);
        s = uh_json_skip_ws(s);
        if (*s == ':') {
            s++;
        }
        s = uh_json_skip_ws(s);
        UhValue val = uh_json_parse_value(&s);
        uh_dict_set(&obj, key, val);
        s = uh_json_skip_ws(s);
        if (*s == ',') {
            s++;
            s = uh_json_skip_ws(s);
            continue;
        }
        if (*s == '}') {
            s++;
            break;
        }
        break;
    }
    *sp = s;
    return obj;
}

static UhValue uh_json_parse_value(const char **sp) {
    const char *s = uh_json_skip_ws(*sp);
    if (*s == '"') {
        UhValue v = uh_json_parse_string(&s);
        *sp = s;
        return v;
    }
    if (*s == '{') {
        UhValue v = uh_json_parse_object(&s);
        *sp = s;
        return v;
    }
    if (*s == '[') {
        UhValue v = uh_json_parse_array(&s);
        *sp = s;
        return v;
    }
    if (strncmp(s, "true", 4) == 0) {
        *sp = s + 4;
        return uh_num(1);
    }
    if (strncmp(s, "false", 5) == 0) {
        *sp = s + 5;
        return uh_num(0);
    }
    if (strncmp(s, "null", 4) == 0) {
        *sp = s + 4;
        return uh_null();
    }
    if ((*s >= '0' && *s <= '9') || *s == '-') {
        char *end = NULL;
        double v = strtod(s, &end);
        if (end != s) {
            *sp = end;
            return uh_num(v);
        }
    }
    *sp = s;
    return uh_null();
}

UhValue uh_json_parse(UhValue str) {
    if (str.tag != UH_STR || str.str == NULL) {
        return uh_null();
    }
    const char *s = str.str;
    UhValue v = uh_json_parse_value(&s);
    return v;
}

static void uh_json_escape(char **buf, size_t *len, size_t *cap, const char *s) {
    uh_buf_append(buf, len, cap, "\"");
    for (const char *p = s; *p; p++) {
        char ch = *p;
        if (ch == '\\') uh_buf_append(buf, len, cap, "\\\\");
        else if (ch == '"') uh_buf_append(buf, len, cap, "\\\"");
        else if (ch == '\n') uh_buf_append(buf, len, cap, "\\n");
        else if (ch == '\r') uh_buf_append(buf, len, cap, "\\r");
        else if (ch == '\t') uh_buf_append(buf, len, cap, "\\t");
        else {
            char tmp[2] = { ch, '\0' };
            uh_buf_append(buf, len, cap, tmp);
        }
    }
    uh_buf_append(buf, len, cap, "\"");
}

static void uh_json_stringify_value(char **buf, size_t *len, size_t *cap, UhValue v) {
    char tmp[64];
    if (v.tag == UH_NULL) {
        uh_buf_append(buf, len, cap, "null");
        return;
    }
    if (v.tag == UH_NUM) {
        snprintf(tmp, sizeof(tmp), "%g", v.num);
        uh_buf_append(buf, len, cap, tmp);
        return;
    }
    if (v.tag == UH_STR) {
        uh_json_escape(buf, len, cap, v.str ? v.str : "");
        return;
    }
    if (v.tag == UH_ARR && v.arr) {
        uh_buf_append(buf, len, cap, "[");
        for (size_t i = 0; i < v.arr->len; i++) {
            uh_json_stringify_value(buf, len, cap, v.arr->items[i]);
            if (i + 1 < v.arr->len) {
                uh_buf_append(buf, len, cap, ",");
            }
        }
        uh_buf_append(buf, len, cap, "]");
        return;
    }
    if (v.tag == UH_DICT && v.dict) {
        uh_buf_append(buf, len, cap, "{");
        for (size_t i = 0; i < v.dict->len; i++) {
            uh_json_escape(buf, len, cap, v.dict->items[i].key);
            uh_buf_append(buf, len, cap, ":");
            uh_json_stringify_value(buf, len, cap, v.dict->items[i].val);
            if (i + 1 < v.dict->len) {
                uh_buf_append(buf, len, cap, ",");
            }
        }
        uh_buf_append(buf, len, cap, "}");
        return;
    }
    uh_buf_append(buf, len, cap, "null");
}

UhValue uh_json_stringify(UhValue v) {
    char *buf = NULL;
    size_t len = 0;
    size_t cap = 0;
    uh_json_stringify_value(&buf, &len, &cap, v);
    if (buf == NULL) {
        return uh_str("");
    }
    UhValue out;
    out.tag = UH_STR;
    out.num = 0;
    out.str = buf;
    out.arr = NULL;
    out.dict = NULL;
    return out;
}
