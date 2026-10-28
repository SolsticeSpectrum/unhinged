/* Trith standard library: JSON. Trith has no dynamic values, so a document stays
 * text and is read by path: "database.port", "users.1.name" (object keys and array
 * indexes from 0, separated by dots; "" is the whole document). Every call parses
 * the text it is given. Bind with ⎔ and build with --include trith/lib/json.h
 * --link trith/lib/json.c (trith/lib/README.md). Strings come back in a buffer the
 * next call reuses (the FFI glue copies them at once); NULL is a failure, which a
 * ◌ʃ binding sees as ◌. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum { J_NULL = 1, J_BOOL, J_NUMBER, J_STRING, J_ARRAY, J_OBJECT };

typedef struct JNode {
    int type;
    char *text;            /* number: as written; string: decoded; bool: "true"/"false" */
    char **keys;           /* object members */
    struct JNode **items;  /* array elements or object values */
    size_t n, cap;
} JNode;

typedef struct {
    const char *s;
    size_t i;
    int bad;
} JParser;

static char *jbuf;

typedef struct {
    char *s;
    size_t n, cap;
} JOut;

static void out_ch(JOut *o, char c) {
    if (o->n + 2 > o->cap) {
        o->cap = o->cap ? o->cap * 2 : 64;
        o->s = realloc(o->s, o->cap);
        if (!o->s) abort();
    }
    o->s[o->n++] = c;
    o->s[o->n] = '\0';
}

static void out_str(JOut *o, const char *s) {
    while (*s) out_ch(o, *s++);
}

/* hand the text to the caller in the shared buffer */
static const char *result(JOut *o) {
    if (!o->s) out_str(o, "");
    free(jbuf);
    jbuf = o->s;
    return jbuf;
}

static JNode *node(int type) {
    JNode *n = calloc(1, sizeof *n);
    if (!n) abort();
    n->type = type;
    return n;
}

static void add(JNode *parent, char *key, JNode *child) {
    if (parent->n == parent->cap) {
        parent->cap = parent->cap ? parent->cap * 2 : 4;
        parent->items = realloc(parent->items, parent->cap * sizeof *parent->items);
        parent->keys = realloc(parent->keys, parent->cap * sizeof *parent->keys);
        if (!parent->items || !parent->keys) abort();
    }
    parent->keys[parent->n] = key;
    parent->items[parent->n++] = child;
}

static void release(JNode *n) {
    if (!n) return;
    for (size_t i = 0; i < n->n; i++) {
        free(n->keys[i]);
        release(n->items[i]);
    }
    free(n->keys);
    free(n->items);
    free(n->text);
    free(n);
}

static void skip_ws(JParser *p) {
    while (p->s[p->i] == ' ' || p->s[p->i] == '\t' || p->s[p->i] == '\n' || p->s[p->i] == '\r') p->i++;
}

static int hex4(const char *s, unsigned *v) {
    *v = 0;
    for (int k = 0; k < 4; k++) {
        char c = s[k];
        int d = c >= '0' && c <= '9' ? c - '0' : c >= 'a' && c <= 'f' ? c - 'a' + 10 : c >= 'A' && c <= 'F' ? c - 'A' + 10 : -1;
        if (d < 0) return 0;
        *v = *v * 16 + (unsigned)d;
    }
    return 1;
}

static void out_utf8(JOut *o, unsigned cp) {
    if (cp < 0x80) {
        out_ch(o, (char)cp);
    } else if (cp < 0x800) {
        out_ch(o, (char)(0xC0 | (cp >> 6)));
        out_ch(o, (char)(0x80 | (cp & 0x3F)));
    } else if (cp < 0x10000) {
        out_ch(o, (char)(0xE0 | (cp >> 12)));
        out_ch(o, (char)(0x80 | ((cp >> 6) & 0x3F)));
        out_ch(o, (char)(0x80 | (cp & 0x3F)));
    } else {
        out_ch(o, (char)(0xF0 | (cp >> 18)));
        out_ch(o, (char)(0x80 | ((cp >> 12) & 0x3F)));
        out_ch(o, (char)(0x80 | ((cp >> 6) & 0x3F)));
        out_ch(o, (char)(0x80 | (cp & 0x3F)));
    }
}

static char *parse_string(JParser *p) {
    JOut o = {0};
    out_str(&o, "");
    p->i++; /* the opening quote */
    for (;;) {
        char c = p->s[p->i];
        if (c == '\0' || (unsigned char)c < 0x20) {
            p->bad = 1;
            break;
        }
        p->i++;
        if (c == '"') break;
        if (c != '\\') {
            out_ch(&o, c);
            continue;
        }
        char e = p->s[p->i++];
        switch (e) {
        case '"': out_ch(&o, '"'); break;
        case '\\': out_ch(&o, '\\'); break;
        case '/': out_ch(&o, '/'); break;
        case 'b': out_ch(&o, '\b'); break;
        case 'f': out_ch(&o, '\f'); break;
        case 'n': out_ch(&o, '\n'); break;
        case 'r': out_ch(&o, '\r'); break;
        case 't': out_ch(&o, '\t'); break;
        case 'u': {
            unsigned cp, lo;
            if (!hex4(p->s + p->i, &cp)) {
                p->bad = 1;
                return o.s;
            }
            p->i += 4;
            if (cp >= 0xD800 && cp < 0xDC00 && p->s[p->i] == '\\' && p->s[p->i + 1] == 'u' &&
                hex4(p->s + p->i + 2, &lo) && lo >= 0xDC00 && lo < 0xE000) {
                cp = 0x10000 + ((cp - 0xD800) << 10) + (lo - 0xDC00);
                p->i += 6;
            }
            out_utf8(&o, cp);
            break;
        }
        default:
            p->bad = 1;
            return o.s;
        }
    }
    return o.s;
}

static JNode *parse_value(JParser *p, int depth);

static JNode *parse_number(JParser *p) {
    size_t start = p->i;
    if (p->s[p->i] == '-') p->i++;
    if (p->s[p->i] < '0' || p->s[p->i] > '9') {
        p->bad = 1;
        return NULL;
    }
    while (p->s[p->i] >= '0' && p->s[p->i] <= '9') p->i++;
    if (p->s[p->i] == '.') {
        p->i++;
        if (p->s[p->i] < '0' || p->s[p->i] > '9') p->bad = 1;
        while (p->s[p->i] >= '0' && p->s[p->i] <= '9') p->i++;
    }
    if (p->s[p->i] == 'e' || p->s[p->i] == 'E') {
        p->i++;
        if (p->s[p->i] == '+' || p->s[p->i] == '-') p->i++;
        if (p->s[p->i] < '0' || p->s[p->i] > '9') p->bad = 1;
        while (p->s[p->i] >= '0' && p->s[p->i] <= '9') p->i++;
    }
    JNode *n = node(J_NUMBER);
    n->text = strndup(p->s + start, p->i - start);
    return n;
}

static JNode *parse_word(JParser *p, const char *w, int type) {
    size_t len = strlen(w);
    if (strncmp(p->s + p->i, w, len) != 0) {
        p->bad = 1;
        return NULL;
    }
    p->i += len;
    JNode *n = node(type);
    if (type == J_BOOL) n->text = strdup(w);
    return n;
}

static JNode *parse_value(JParser *p, int depth) {
    skip_ws(p);
    if (depth > 500) {
        p->bad = 1;
        return NULL;
    }
    char c = p->s[p->i];
    if (c == '{' || c == '[') {
        JNode *n = node(c == '{' ? J_OBJECT : J_ARRAY);
        char close = c == '{' ? '}' : ']';
        p->i++;
        skip_ws(p);
        if (p->s[p->i] == close) {
            p->i++;
            return n;
        }
        for (;;) {
            char *key = NULL;
            if (n->type == J_OBJECT) {
                skip_ws(p);
                if (p->s[p->i] != '"') {
                    p->bad = 1;
                    return n;
                }
                key = parse_string(p);
                skip_ws(p);
                if (p->bad || p->s[p->i] != ':') {
                    p->bad = 1;
                    free(key);
                    return n;
                }
                p->i++;
            }
            JNode *v = parse_value(p, depth + 1);
            add(n, key, v);
            if (p->bad) return n;
            skip_ws(p);
            if (p->s[p->i] == ',') {
                p->i++;
                continue;
            }
            if (p->s[p->i] == close) {
                p->i++;
                return n;
            }
            p->bad = 1;
            return n;
        }
    }
    if (c == '"') {
        JNode *n = node(J_STRING);
        n->text = parse_string(p);
        return n;
    }
    if (c == 't') return parse_word(p, "true", J_BOOL);
    if (c == 'f') return parse_word(p, "false", J_BOOL);
    if (c == 'n') return parse_word(p, "null", J_NULL);
    return parse_number(p);
}

/* the whole document, or NULL if it is not one JSON value */
static JNode *parse_doc(const char *s) {
    JParser p = {s, 0, 0};
    JNode *n = parse_value(&p, 0);
    skip_ws(&p);
    if (p.bad || p.s[p.i] != '\0') {
        release(n);
        return NULL;
    }
    return n;
}

/* the member of n that the next path segment names; *rest is set past it */
static JNode **step(JNode *n, const char *path, const char **rest) {
    const char *dot = strchr(path, '.');
    size_t len = dot ? (size_t)(dot - path) : strlen(path);
    *rest = dot ? dot + 1 : path + len;
    if (n->type == J_OBJECT) {
        for (size_t i = n->n; i-- > 0;) {
            if (strlen(n->keys[i]) == len && strncmp(n->keys[i], path, len) == 0) return &n->items[i];
        }
        return NULL;
    }
    if (n->type == J_ARRAY && len > 0) {
        size_t idx = 0;
        for (size_t k = 0; k < len; k++) {
            if (path[k] < '0' || path[k] > '9') return NULL;
            idx = idx * 10 + (size_t)(path[k] - '0');
        }
        return idx < n->n ? &n->items[idx] : NULL;
    }
    return NULL;
}

static JNode *find(JNode *root, const char *path) {
    JNode *n = root;
    while (n && *path) {
        JNode **slot = step(n, path, &path);
        n = slot ? *slot : NULL;
    }
    return n;
}

static void write_quoted(JOut *o, const char *s) {
    out_ch(o, '"');
    for (; *s; s++) {
        unsigned char c = (unsigned char)*s;
        if (c == '"') out_str(o, "\\\"");
        else if (c == '\\') out_str(o, "\\\\");
        else if (c == '\n') out_str(o, "\\n");
        else if (c == '\r') out_str(o, "\\r");
        else if (c == '\t') out_str(o, "\\t");
        else if (c == '\b') out_str(o, "\\b");
        else if (c == '\f') out_str(o, "\\f");
        else if (c < 0x20) {
            char u[8];
            snprintf(u, sizeof u, "\\u%04x", c);
            out_str(o, u);
        } else out_ch(o, (char)c);
    }
    out_ch(o, '"');
}

/* compact JSON for n */
static void write_node(JOut *o, JNode *n) {
    switch (n->type) {
    case J_NULL: out_str(o, "null"); break;
    case J_BOOL:
    case J_NUMBER: out_str(o, n->text); break;
    case J_STRING: write_quoted(o, n->text); break;
    default:
        out_ch(o, n->type == J_OBJECT ? '{' : '[');
        for (size_t i = 0; i < n->n; i++) {
            if (i) out_ch(o, ',');
            if (n->type == J_OBJECT) {
                write_quoted(o, n->keys[i]);
                out_ch(o, ':');
            }
            write_node(o, n->items[i]);
        }
        out_ch(o, n->type == J_OBJECT ? '}' : ']');
    }
}

/* the value at path: a string's text, a number, true, false or null as written, an array
 * or object as compact JSON; NULL if json is not JSON or nothing is at path */
const char *trith_json_get(const char *json, const char *path) {
    JNode *root = parse_doc(json);
    JNode *n = root ? find(root, path) : NULL;
    if (!n) {
        release(root);
        return NULL;
    }
    JOut o = {0};
    if (n->type == J_STRING) out_str(&o, n->text);
    else write_node(&o, n);
    release(root);
    return result(&o);
}

/* what is at path: 0 nothing, 1 null, 2 a boolean, 3 a number, 4 a string, 5 an array,
 * 6 an object; −1 if json is not JSON */
int64_t trith_json_type(const char *json, const char *path) {
    JNode *root = parse_doc(json);
    if (!root) return -1;
    JNode *n = find(root, path);
    int64_t t = n ? n->type : 0;
    release(root);
    return t;
}

/* the number of elements of the array (or members of the object) at path; −1 if there is none */
int64_t trith_json_len(const char *json, const char *path) {
    JNode *root = parse_doc(json);
    JNode *n = root ? find(root, path) : NULL;
    int64_t len = n && (n->type == J_ARRAY || n->type == J_OBJECT) ? (int64_t)n->n : -1;
    release(root);
    return len;
}

/* the key of member i of the object at path; NULL if there is none */
const char *trith_json_key(const char *json, const char *path, int64_t i) {
    JNode *root = parse_doc(json);
    JNode *n = root ? find(root, path) : NULL;
    if (!n || n->type != J_OBJECT || i < 0 || (size_t)i >= n->n) {
        release(root);
        return NULL;
    }
    JOut o = {0};
    out_str(&o, n->keys[i]);
    release(root);
    return result(&o);
}

/* json, compact, with the value at path replaced by the JSON text value (a missing last
 * object key is added, an index one past the end of an array appends); NULL if json or
 * value is not JSON or the path does not lead there */
const char *trith_json_set(const char *json, const char *path, const char *value) {
    JNode *root = parse_doc(json);
    JNode *v = parse_doc(value);
    if (!root || !v) {
        release(root);
        release(v);
        return NULL;
    }
    JNode **slot = &root;
    const char *p = path;
    while (*p) {
        const char *rest;
        JNode *n = *slot;
        JNode **next = step(n, p, &rest);
        if (!next && *rest == '\0') {
            const char *dot = strchr(p, '.');
            size_t len = dot ? (size_t)(dot - p) : strlen(p);
            if (n->type == J_OBJECT) {
                add(n, strndup(p, len), NULL);
                next = &n->items[n->n - 1];
            } else if (n->type == J_ARRAY && len > 0 && strspn(p, "0123456789") == len &&
                       (size_t)strtoul(p, NULL, 10) == n->n) {
                add(n, NULL, NULL);
                next = &n->items[n->n - 1];
            }
        }
        if (!next) {
            release(root);
            release(v);
            return NULL;
        }
        slot = next;
        p = rest;
    }
    release(*slot);
    *slot = v;
    JOut o = {0};
    write_node(&o, root);
    release(root);
    return result(&o);
}

/* s as a JSON string literal, quotes included */
const char *trith_json_quote(const char *s) {
    JOut o = {0};
    write_quoted(&o, s);
    return result(&o);
}

/* json, compact; NULL if it is not JSON */
const char *trith_json_compact(const char *json) {
    JNode *root = parse_doc(json);
    if (!root) return NULL;
    JOut o = {0};
    write_node(&o, root);
    release(root);
    return result(&o);
}

/* element i of the array (or the value of member i of the object) at path, as compact JSON;
 * NULL if there is none */
const char *trith_json_at(const char *json, const char *path, int64_t i) {
    JNode *root = parse_doc(json);
    JNode *n = root ? find(root, path) : NULL;
    if (!n || (n->type != J_ARRAY && n->type != J_OBJECT) || i < 0 || (size_t)i >= n->n) {
        release(root);
        return NULL;
    }
    JOut o = {0};
    write_node(&o, n->items[i]);
    release(root);
    return result(&o);
}

/* the boolean at path: 1 true, 0 false, −1 if it is not a boolean */
int64_t trith_json_bool(const char *json, const char *path) {
    JNode *root = parse_doc(json);
    JNode *n = root ? find(root, path) : NULL;
    int64_t b = n && n->type == J_BOOL ? n->text[0] == 't' : -1;
    release(root);
    return b;
}
