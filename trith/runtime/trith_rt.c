/* Trith runtime (spec §14): I/O, strings and process exit. No environments,
 * no value stack, no tagged values: generated code calls these directly. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char *ptr;
    int64_t len;
    int64_t cap;
} TrithStr;

TrithStr *trith_str_new(const char *bytes, int64_t len) {
    TrithStr *s = malloc(sizeof *s);
    if (s == NULL) {
        abort();
    }
    s->ptr = malloc(len > 0 ? (size_t)len : 1);
    if (s->ptr == NULL) {
        abort();
    }
    memcpy(s->ptr, bytes, (size_t)len);
    s->len = len;
    s->cap = len;
    return s;
}

void trith_str_free(TrithStr *s) {
    if (s != NULL) {
        free(s->ptr);
        free(s);
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

/* ⥀ exited with ⊖ in a function that cannot fail (§7.2, §7.3) */
void trith_loop_failed(void) {
    fflush(stdout);
    fputs("trith: ⥀ exited by failure\n", stderr);
    exit(27);
}

/* the entry point ᛟ failed (§7.3) */
void trith_entry_failed(void) {
    fflush(stdout);
    exit(27);
}
