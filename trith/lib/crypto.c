/* Trith standard library: crypto (SHA-256, HMAC-SHA-256, AES-256-CBC, random bytes).
 * Ported from the UNHINGED v1 runtime (unhinged/runtime/rt.c), with the same algorithms and
 * formats. Bind it with ⎔ and build with --link trith/lib/crypto.c (trith/lib/README.md).
 * Strings come back in a buffer the next call reuses (the FFI glue copies them at
 * once); NULL is a failure, which a ◌ʃ binding sees as ◌. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static char *crypto_buf;
static size_t crypto_cap;

static char *crypto_out(size_t n) {
    if (n + 1 > crypto_cap) {
        crypto_cap = (n + 1) * 2;
        crypto_buf = realloc(crypto_buf, crypto_cap);
        if (!crypto_buf) abort();
    }
    return crypto_buf;
}

static const char *hex_of(const uint8_t *data, size_t len) {
    char *out = crypto_out(len * 2);
    for (size_t i = 0; i < len; i++) snprintf(out + i * 2, 3, "%02x", data[i]);
    out[len * 2] = '\0';
    return out;
}

/* ---- SHA-256 */

typedef struct {
    uint32_t state[8];
    uint64_t bitlen;
    uint8_t data[64];
    size_t datalen;
} Sha256;

static uint32_t rotr(uint32_t x, uint32_t n) {
    return (x >> n) | (x << (32 - n));
}

static void sha256_transform(Sha256 *ctx, const uint8_t data[64]) {
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
        uint32_t s0 = rotr(m[i - 15], 7) ^ rotr(m[i - 15], 18) ^ (m[i - 15] >> 3);
        uint32_t s1 = rotr(m[i - 2], 17) ^ rotr(m[i - 2], 19) ^ (m[i - 2] >> 10);
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
        uint32_t S1 = rotr(e, 6) ^ rotr(e, 11) ^ rotr(e, 25);
        uint32_t ch = (e & f) ^ (~e & g);
        uint32_t temp1 = h + S1 + ch + k[i] + m[i];
        uint32_t S0 = rotr(a, 2) ^ rotr(a, 13) ^ rotr(a, 22);
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

static void sha256_init(Sha256 *ctx) {
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

static void sha256_update(Sha256 *ctx, const uint8_t *data, size_t len) {
    for (size_t i = 0; i < len; i++) {
        ctx->data[ctx->datalen++] = data[i];
        if (ctx->datalen == 64) {
            sha256_transform(ctx, ctx->data);
            ctx->bitlen += 512;
            ctx->datalen = 0;
        }
    }
}

static void sha256_final(Sha256 *ctx, uint8_t hash[32]) {
    size_t i = ctx->datalen;
    if (ctx->datalen < 56) {
        ctx->data[i++] = 0x80;
        while (i < 56) ctx->data[i++] = 0x00;
    } else {
        ctx->data[i++] = 0x80;
        while (i < 64) ctx->data[i++] = 0x00;
        sha256_transform(ctx, ctx->data);
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
    sha256_transform(ctx, ctx->data);
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

static void sha256_of(const uint8_t *data, size_t len, uint8_t hash[32]) {
    Sha256 ctx;
    sha256_init(&ctx);
    sha256_update(&ctx, data, len);
    sha256_final(&ctx, hash);
}

/* the SHA-256 of s, as 64 hex digits */
const char *trith_sha256(const char *s) {
    uint8_t hash[32];
    sha256_of((const uint8_t *)s, strlen(s), hash);
    return hex_of(hash, 32);
}

/* HMAC-SHA-256 of msg under key, as 64 hex digits */
const char *trith_hmac_sha256(const char *msg, const char *key) {
    uint8_t key_block[64];
    memset(key_block, 0, sizeof key_block);
    size_t klen = strlen(key);
    if (klen > 64) {
        sha256_of((const uint8_t *)key, klen, key_block);
    } else {
        memcpy(key_block, key, klen);
    }
    uint8_t o_key[64], i_key[64];
    for (int i = 0; i < 64; i++) {
        o_key[i] = key_block[i] ^ 0x5c;
        i_key[i] = key_block[i] ^ 0x36;
    }
    Sha256 ictx;
    uint8_t ihash[32];
    sha256_init(&ictx);
    sha256_update(&ictx, i_key, 64);
    sha256_update(&ictx, (const uint8_t *)msg, strlen(msg));
    sha256_final(&ictx, ihash);
    Sha256 octx;
    uint8_t ohash[32];
    sha256_init(&octx);
    sha256_update(&octx, o_key, 64);
    sha256_update(&octx, ihash, 32);
    sha256_final(&octx, ohash);
    return hex_of(ohash, 32);
}

/* n random bytes from /dev/urandom, as 2n hex digits (NULL if n is not positive) */
const char *trith_random_hex(int64_t n) {
    if (n <= 0) return NULL;
    uint8_t *buf = malloc((size_t)n);
    if (!buf) abort();
    FILE *f = fopen("/dev/urandom", "rb");
    size_t got = 0;
    if (f) {
        got = fread(buf, 1, (size_t)n, f);
        fclose(f);
    }
    for (size_t i = got; i < (size_t)n; i++) buf[i] = (uint8_t)(rand() & 0xff);
    const char *out = hex_of(buf, (size_t)n);
    free(buf);
    return out;
}

/* ---- AES-256-CBC with PKCS#7 padding; the key is the string's bytes, zero-padded to 32 */

typedef struct {
    uint8_t RoundKey[240];
    uint8_t Iv[16];
} AesCtx;

static const uint8_t aes_sbox[256] = {
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

static const uint8_t aes_rsbox[256] = {
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

static const uint8_t aes_rcon[11] = {
    0x00,0x01,0x02,0x04,0x08,0x10,0x20,0x40,0x80,0x1b,0x36
};

static uint8_t aes_xtime(uint8_t x) {
    return (uint8_t)((x << 1) ^ (((x >> 7) & 1) * 0x1b));
}

static void aes_key_expansion(AesCtx *ctx, const uint8_t *key) {
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
            tmp[0] = aes_sbox[tmp[0]];
            tmp[1] = aes_sbox[tmp[1]];
            tmp[2] = aes_sbox[tmp[2]];
            tmp[3] = aes_sbox[tmp[3]];
            tmp[0] ^= aes_rcon[i / 8];
        } else if (i % 8 == 4) {
            tmp[0] = aes_sbox[tmp[0]];
            tmp[1] = aes_sbox[tmp[1]];
            tmp[2] = aes_sbox[tmp[2]];
            tmp[3] = aes_sbox[tmp[3]];
        }
        rk[i * 4 + 0] = rk[(i - 8) * 4 + 0] ^ tmp[0];
        rk[i * 4 + 1] = rk[(i - 8) * 4 + 1] ^ tmp[1];
        rk[i * 4 + 2] = rk[(i - 8) * 4 + 2] ^ tmp[2];
        rk[i * 4 + 3] = rk[(i - 8) * 4 + 3] ^ tmp[3];
        i++;
    }
}

static void aes_add_round_key(uint8_t round, uint8_t *state, const uint8_t *rk) {
    for (int i = 0; i < 16; i++) {
        state[i] ^= rk[round * 16 + i];
    }
}

static void aes_sub_bytes(uint8_t *state) {
    for (int i = 0; i < 16; i++) {
        state[i] = aes_sbox[state[i]];
    }
}

static void aes_inv_sub_bytes(uint8_t *state) {
    for (int i = 0; i < 16; i++) {
        state[i] = aes_rsbox[state[i]];
    }
}

static void aes_shift_rows(uint8_t *state) {
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

static void aes_inv_shift_rows(uint8_t *state) {
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

static void aes_mix_columns(uint8_t *state) {
    for (int i = 0; i < 4; i++) {
        uint8_t *c = state + i * 4;
        uint8_t t = c[0] ^ c[1] ^ c[2] ^ c[3];
        uint8_t tmp = c[0];
        c[0] ^= t ^ aes_xtime(c[0] ^ c[1]);
        c[1] ^= t ^ aes_xtime(c[1] ^ c[2]);
        c[2] ^= t ^ aes_xtime(c[2] ^ c[3]);
        c[3] ^= t ^ aes_xtime(c[3] ^ tmp);
    }
}

static void aes_inv_mix_columns(uint8_t *state) {
    for (int i = 0; i < 4; i++) {
        uint8_t *c = state + i * 4;
        uint8_t a = c[0];
        uint8_t b = c[1];
        uint8_t d = c[2];
        uint8_t e = c[3];
        uint8_t a2 = aes_xtime(a);
        uint8_t b2 = aes_xtime(b);
        uint8_t d2 = aes_xtime(d);
        uint8_t e2 = aes_xtime(e);
        uint8_t a4 = aes_xtime(a2);
        uint8_t b4 = aes_xtime(b2);
        uint8_t d4 = aes_xtime(d2);
        uint8_t e4 = aes_xtime(e2);
        uint8_t a8 = aes_xtime(a4);
        uint8_t b8 = aes_xtime(b4);
        uint8_t d8 = aes_xtime(d4);
        uint8_t e8 = aes_xtime(e4);
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

static void aes_encrypt_block(AesCtx *ctx, uint8_t *state) {
    aes_add_round_key(0, state, ctx->RoundKey);
    for (uint8_t round = 1; round < 14; round++) {
        aes_sub_bytes(state);
        aes_shift_rows(state);
        aes_mix_columns(state);
        aes_add_round_key(round, state, ctx->RoundKey);
    }
    aes_sub_bytes(state);
    aes_shift_rows(state);
    aes_add_round_key(14, state, ctx->RoundKey);
}

static void aes_decrypt_block(AesCtx *ctx, uint8_t *state) {
    aes_add_round_key(14, state, ctx->RoundKey);
    for (uint8_t round = 13; round > 0; round--) {
        aes_inv_shift_rows(state);
        aes_inv_sub_bytes(state);
        aes_add_round_key(round, state, ctx->RoundKey);
        aes_inv_mix_columns(state);
    }
    aes_inv_shift_rows(state);
    aes_inv_sub_bytes(state);
    aes_add_round_key(0, state, ctx->RoundKey);
}

static void aes_init_ctx_iv(AesCtx *ctx, const uint8_t *key, const uint8_t *iv) {
    aes_key_expansion(ctx, key);
    memcpy(ctx->Iv, iv, 16);
}

static void aes_cbc_encrypt_buffer(AesCtx *ctx, uint8_t *buf, size_t len) {
    uint8_t *iv = ctx->Iv;
    for (size_t i = 0; i < len; i += 16) {
        for (int j = 0; j < 16; j++) buf[i + j] ^= iv[j];
        aes_encrypt_block(ctx, buf + i);
        iv = buf + i;
    }
    memcpy(ctx->Iv, iv, 16);
}

static void aes_cbc_decrypt_buffer(AesCtx *ctx, uint8_t *buf, size_t len) {
    uint8_t store_next_iv[16];
    for (size_t i = 0; i < len; i += 16) {
        memcpy(store_next_iv, buf + i, 16);
        aes_decrypt_block(ctx, buf + i);
        for (int j = 0; j < 16; j++) buf[i + j] ^= ctx->Iv[j];
        memcpy(ctx->Iv, store_next_iv, 16);
    }
}

static void key_from_str(const char *k, uint8_t out[32]) {
    memset(out, 0, 32);
    if (!k) return;
    size_t len = strlen(k);
    if (len > 32) len = 32;
    memcpy(out, k, len);
}

static void random_iv(uint8_t out[16]) {
    FILE *f = fopen("/dev/urandom", "rb");
    if (f) {
        size_t n = fread(out, 1, 16, f);
        fclose(f);
        if (n == 16) return;
    }
    for (int i = 0; i < 16; i++) out[i] = (uint8_t)(rand() & 0xff);
}

/* text encrypted under key: hex of a random IV followed by the ciphertext */
const char *trith_aes_encrypt(const char *text, const char *key) {
    size_t tlen = strlen(text);
    size_t pad = 16 - (tlen % 16);
    size_t blen = tlen + pad;
    uint8_t *buf = malloc(16 + blen);
    if (!buf) abort();
    memcpy(buf + 16, text, tlen);
    for (size_t i = tlen; i < blen; i++) buf[16 + i] = (uint8_t)pad;
    uint8_t keybuf[32];
    key_from_str(key, keybuf);
    random_iv(buf);
    AesCtx ctx;
    aes_init_ctx_iv(&ctx, keybuf, buf);
    aes_cbc_encrypt_buffer(&ctx, buf + 16, blen);
    const char *out = hex_of(buf, 16 + blen);
    free(buf);
    return out;
}

static int hexval(char c) {
    if (c >= '0' && c <= '9') return c - '0';
    if (c >= 'a' && c <= 'f') return c - 'a' + 10;
    if (c >= 'A' && c <= 'F') return c - 'A' + 10;
    return -1;
}

/* the text trith_aes_encrypt made, or NULL when hex is not such a text for this key */
const char *trith_aes_decrypt(const char *hex, const char *key) {
    size_t hlen = strlen(hex);
    if (hlen % 2 != 0) return NULL;
    size_t blen = hlen / 2;
    if (blen < 32 || (blen - 16) % 16 != 0) return NULL;
    uint8_t *bytes = malloc(blen);
    if (!bytes) abort();
    for (size_t i = 0; i < blen; i++) {
        int a = hexval(hex[2 * i]), b = hexval(hex[2 * i + 1]);
        if (a < 0 || b < 0) {
            free(bytes);
            return NULL;
        }
        bytes[i] = (uint8_t)(a * 16 + b);
    }
    size_t clen = blen - 16;
    uint8_t keybuf[32];
    key_from_str(key, keybuf);
    AesCtx ctx;
    aes_init_ctx_iv(&ctx, keybuf, bytes);
    aes_cbc_decrypt_buffer(&ctx, bytes + 16, clen);
    uint8_t pad = bytes[16 + clen - 1];
    int ok = pad >= 1 && pad <= 16;
    for (size_t i = 0; ok && i < pad; i++) ok = bytes[16 + clen - 1 - i] == pad;
    const char *out = NULL;
    if (ok) {
        char *o = crypto_out(clen - pad);
        memcpy(o, bytes + 16, clen - pad);
        o[clen - pad] = '\0';
        out = o;
    }
    free(bytes);
    return out;
}
