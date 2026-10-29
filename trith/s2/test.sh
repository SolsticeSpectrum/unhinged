#!/bin/sh
# s2 tests: s2c must print exactly what s1 prints for --tokens, --ast,
# --check and --emit-llvm, for every Trith file in the repository (errors
# included), its own source among them, except the s2-only golden tests in
# trith/s2/tests (golden.sh). Every program in trith/tests/run is
# also compiled by both and run: the outputs and exit statuses must agree (a
# compile error must print the same message). Run from the repo root after
# `make s2`; S2C=build/s3c tests the compiler s2 built. s1 knows no blessings, so the
# attributes s2 gives blessed functions (Addendum A.5.3) are left out of the comparison.
TRITHC=${TRITHC:-build/trithc}
S2C=${S2C:-build/s2c}
mkdir -p output/s2-test
pass=0
fail=0
for f in $(find trith -name '*.trh' -not -path 'trith/s2/tests/*' | sort); do
    for mode in --tokens --ast --check --emit-llvm; do
        "$S2C" "$f" $mode 2>&1 | sed -E 's/^(define internal .*\)) nounwind willreturn mustprogress( memory\([^)]*\))? \{$/\1 {/' > output/s2.out
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
for f in trith/tests/run/*.trh; do
    rm -f output/s2-test/p1 output/s2-test/p2
    "$TRITHC" "$f" -o output/s2-test/p1 > output/s1.out 2>&1
    "$S2C" "$f" -o output/s2-test/p2 > output/s2.out 2>&1
    if [ -x output/s2-test/p1 ]; then
        output/s2-test/p1 >> output/s1.out 2>&1; echo "exit=$?" >> output/s1.out
    fi
    if [ -x output/s2-test/p2 ]; then
        output/s2-test/p2 >> output/s2.out 2>&1; echo "exit=$?" >> output/s2.out
    fi
    if cmp -s output/s2.out output/s1.out; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
        echo "FAIL $f (compiled and run)"
        diff output/s2.out output/s1.out | head -5
    fi
done
echo "s2: $pass results agree with s1, $fail differ"
[ "$fail" -eq 0 ]
