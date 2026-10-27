/* Trith runtime (spec §14): I/O, strings and process exit. No environments,
 * no value stack, no tagged values: generated code calls these directly. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Strings (ʃ) and arrays (⟦T⟧) share one layout; generated code reads the
 * fields directly. Strings keep one spare byte so they can be NUL-terminated
 * for C. */
typedef struct {
    char *ptr;
    int64_t len;
    int64_t cap;
} TrithStr;

typedef TrithStr TrithArr;

static void *trith_xalloc(size_t n) {
    void *p = malloc(n > 0 ? n : 1);
    if (p == NULL) {
        abort();
    }
    return p;
}

TrithArr *trith_arr_new(int64_t elem_size, int64_t count) {
    TrithArr *a = trith_xalloc(sizeof *a);
    a->ptr = trith_xalloc((size_t)(elem_size * count + 1));
    a->len = count;
    a->cap = count;
    return a;
}

/* ⍆: make room for one more element; returns its slot */
void *trith_arr_push(TrithArr *a, int64_t elem_size) {
    if (a->len >= a->cap) {
        int64_t cap = a->cap < 4 ? 8 : a->cap * 2;
        char *p = realloc(a->ptr, (size_t)(elem_size * cap + 1));
        if (p == NULL) {
            abort();
        }
        a->ptr = p;
        a->cap = cap;
    }
    void *slot = a->ptr + elem_size * a->len;
    a->len++;
    return slot;
}

/* ⌁ on a string or array; levels = nesting depth of quantum elements */
void trith_arr_free(TrithArr *a, int64_t levels) {
    if (a == NULL) {
        return;
    }
    if (levels > 0) {
        TrithArr **items = (TrithArr **)a->ptr;
        for (int64_t i = 0; i < a->len; i++) {
            trith_arr_free(items[i], levels - 1);
        }
    }
    free(a->ptr);
    free(a);
}

TrithStr *trith_str_new(const char *bytes, int64_t len) {
    TrithStr *s = trith_arr_new(1, len);
    memcpy(s->ptr, bytes, (size_t)len);
    return s;
}

void trith_str_free(TrithStr *s) {
    trith_arr_free(s, 0);
}

/* for FFI: the string as a NUL-terminated C string (it stays owned by s) */
const char *trith_str_cstr(TrithStr *s) {
    /* every buffer has one spare byte past cap */
    s->ptr[s->len] = '\0';
    return s->ptr;
}

/* for FFI: copy a C string into a new Trith string (NULL gives NULL) */
TrithStr *trith_str_from_cstr(const char *c) {
    if (c == NULL) {
        return NULL;
    }
    return trith_str_new(c, (int64_t)strlen(c));
}

/* ⎙ on a shadow ⟗ʃ: print without consuming */
void trith_print_str_ref(TrithStr *s) {
    if (s != NULL) {
        fwrite(s->ptr, 1, (size_t)s->len, stdout);
    }
}

/* ⎙ consumes a string: print it, then free it */
void trith_print_str(TrithStr *s) {
    if (s != NULL) {
        fwrite(s->ptr, 1, (size_t)s->len, stdout);
    }
    trith_str_free(s);
}

void trith_print_i64(int64_t v) {
    printf("%lld\n", (long long)v);
}

void trith_print_f64(double v) {
    printf("%.15g\n", v);
}

/* ---- the outside world, for FFI bindings (§14) ---- */

static int trith_argc_value;
static char **trith_argv_value;

void trith_set_args(int argc, char **argv) {
    trith_argc_value = argc;
    trith_argv_value = argv;
}

int64_t trith_argc(void) {
    return trith_argc_value;
}

/* argument i (0 is the program), or NULL */
const char *trith_arg(int64_t i) {
    if (i < 0 || i >= trith_argc_value) {
        return NULL;
    }
    return trith_argv_value[i];
}

/* the whole file as a C string, or NULL; the buffer is cached and reused */
const char *trith_read_file(const char *path) {
    static char *last;
    FILE *f = fopen(path, "rb");
    if (f == NULL) {
        return NULL;
    }
    size_t cap = 4096, len = 0;
    char *buf = trith_xalloc(cap);
    size_t n;
    while ((n = fread(buf + len, 1, cap - len - 1, f)) > 0) {
        len += n;
        if (len + 1 >= cap) {
            cap *= 2;
            char *p = realloc(buf, cap);
            if (p == NULL) {
                abort();
            }
            buf = p;
        }
    }
    fclose(f);
    buf[len] = '\0';
    free(last);
    last = buf;
    return buf;
}

/* write data to path; 0 on success, -1 on failure */
int64_t trith_write_file(const char *path, const char *data) {
    FILE *f = fopen(path, "wb");
    if (f == NULL) {
        return -1;
    }
    size_t n = strlen(data);
    int ok = fwrite(data, 1, n, f) == n;
    return fclose(f) == 0 && ok ? 0 : -1;
}

/* ⥀ exited with ⊖ in a function that cannot fail (§7.2, §7.3) */
void trith_loop_failed(void) {
    fflush(stdout);
    fputs("trith: ⥀ exited by failure\n", stderr);
    exit(27);
}

/* a ⋔⇋ exit assertion disagreed with the face taken (§10) */
void trith_reversal_failed(void) {
    fflush(stdout);
    fputs("trith: ⋔⇋ exit assertion does not match the face taken\n", stderr);
    exit(27);
}

/* ⊙⁻ or ⊙⁺ on a superposition with no live alternative (§8.3) */
void trith_collapse_empty(void) {
    fflush(stdout);
    fputs("trith: collapse of an empty superposition\n", stderr);
    exit(27);
}

/* the entry point ᛟ failed (§7.3) */
void trith_entry_failed(void) {
    fflush(stdout);
    exit(27);
}
