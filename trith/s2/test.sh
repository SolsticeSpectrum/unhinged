#!/bin/sh
# s2 tests: s2c must print exactly what s1 prints for --tokens and --ast,
# for every Trith file in the repository (errors included), its own source
# among them. Run from the repo root after `make s2`.
TRITHC=${TRITHC:-build/trithc}
S2C=${S2C:-build/s2c}
mkdir -p output
pass=0
fail=0
for f in $(find trith -name '*.trh' | sort); do
    for mode in --tokens --ast; do
        "$S2C" "$f" $mode > output/s2.out 2>&1
        "$TRITHC" "$f" $mode > output/s1.out 2>&1
        if cmp -s output/s2.out output/s1.out; then
            pass=$((pass + 1))
        else
            fail=$((fail + 1))
            echo "FAIL $f $mode"
            diff output/s2.out output/s1.out | head -5
        fi
    done
done
echo "s2: $pass dumps agree with s1, $fail differ"
[ "$fail" -eq 0 ]
