#!/bin/sh
# s2 tests: the s2 lexer must print exactly what s1 prints for --tokens,
# for every Trith file in the repository (errors included) and for its own
# source. Run from the repo root after `make s2`.
TRITHC=${TRITHC:-build/trithc}
S2LEX=${S2LEX:-build/s2lex}
mkdir -p output
pass=0
fail=0
for f in $(find trith -name '*.trh' | sort); do
    "$S2LEX" "$f" > output/s2.out 2>&1
    "$TRITHC" "$f" --tokens > output/s1.out 2>&1
    if cmp -s output/s2.out output/s1.out; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
        echo "FAIL $f"
        diff output/s2.out output/s1.out | head -5
    fi
done
echo "s2 lexer: $pass files agree with s1, $fail differ"
[ "$fail" -eq 0 ]
