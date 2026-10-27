#!/usr/bin/env bash
# Run every program in trith/tests/run under valgrind: no invalid accesses and
# no leaks. Linearity (§8.1) means every string and array is freed exactly once.
set -uo pipefail
TRITHC=${TRITHC:-build/trithc}
OUT=output/memcheck
mkdir -p "$OUT"
status=0
for src in trith/tests/run/*.trh; do
    name=$(basename "$src" .trh)
    # tests that are meant to be rejected at compile time have nothing to run
    if grep -q ': error: ' "trith/tests/run/$name.out" 2>/dev/null; then
        continue
    fi
    rm -f "$OUT/$name"
    "$TRITHC" "$src" -o "$OUT/$name" > "$OUT/$name.compile" 2>&1
    if [ ! -x "$OUT/$name" ]; then
        echo "FAIL $name: does not compile"
        status=1
        continue
    fi
    if valgrind --leak-check=full --errors-for-leak-kinds=definite,indirect \
        --error-exitcode=99 -q "$OUT/$name" > /dev/null 2> "$OUT/$name.valgrind"; then
        echo "ok   $name"
    else
        code=$?
        if [ "$code" = 99 ]; then
            echo "FAIL $name: see $OUT/$name.valgrind"
            status=1
        else
            echo "ok   $name (exit $code)"
        fi
    fi
done
exit $status
