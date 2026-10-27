#include <stdint.h>
#include <stdio.h>

static int64_t steps(int64_t n) {
    int64_t c = 0;
    do {
        n = (n & 1) == 0 ? n >> 1 : 3 * n + 1;
        c++;
    } while (n > 1);
    return c;
}

int main(void) {
    int64_t total = 0;
    int64_t n = 2;
    do {
        total += steps(n);
        n++;
    } while (1000000 > n);
    printf("%lld\n", (long long)total);
    return 0;
}
