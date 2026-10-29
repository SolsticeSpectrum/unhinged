#!/bin/sh
# Golden tests for what only s2 implements (the addenda: docs/TRITH-ADDENDUM-A.md and -B.md).
# s1 is frozen, so these are not compared with it; each output must equal the .out file.
#
# trith/s2/tests/<suite>/<name>.trh is one test; a directory <suite>/<name>/ is one module
# made of every .trh file in it, passed in name order (planes, Addendum A.1). The suite
# chooses the flags; <name>.flags, if present, replaces them. The run suite compiles the
# module and runs it, recording its exit status (a .flags of "RUN --debug" adds flags to the
# compile).
# BLESS=1 rewrites the .out files instead. Run from the repo root after `make s2`.
S2C=${S2C:-build/s2c}
mkdir -p output/s2-golden
pass=0
fail=0
for suite in check check_errors emit run tools; do
    case $suite in
    check | check_errors) flags=--check ;;
    emit) flags=--emit-llvm ;;
    run) flags=RUN ;;
    tools) flags= ;;
    esac
    for t in trith/s2/tests/$suite/*; do
        case $t in
        *.trh) name=${t%.trh}; files=$t ;;
        *.out | *.flags | *'*') continue ;;
        *) [ -d "$t" ] || continue; name=$t; files=$(ls "$t"/*.trh | sort) ;;
        esac
        f=$flags
        [ -f "$name.flags" ] && f=$(cat "$name.flags")
        out=output/s2-golden/actual.out
        if [ "${f%% *}" = RUN ]; then
            extra=${f#RUN}
            rm -f output/s2-golden/prog
            # shellcheck disable=SC2086
            if "$S2C" $files $extra -o output/s2-golden/prog > "$out" 2>&1; then
                output/s2-golden/prog >> "$out" 2>&1
                echo "exit=$?" >> "$out"
            fi
        else
            # shellcheck disable=SC2086
            "$S2C" $files $f > "$out" 2>&1
        fi
        if [ -n "$BLESS" ]; then
            cp "$out" "$name.out"
            echo "BLESS $name"
        elif cmp -s "$out" "$name.out"; then
            pass=$((pass + 1))
        else
            fail=$((fail + 1))
            echo "FAIL $name"
            diff -u "$name.out" "$out" | head -20
        fi
    done
done
echo "s2 golden: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
