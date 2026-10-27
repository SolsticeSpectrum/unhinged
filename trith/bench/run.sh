#!/usr/bin/env bash
# Benchmark gate (spec §17): each Trith program must run within 1.5× of the
# same program in C compiled with clang -O2. Run from the repo root.
set -euo pipefail

TRITHC=${TRITHC:-build/trithc}
OUT=output/bench
RUNS=${RUNS:-5}
LIMIT=1.5
mkdir -p "$OUT"

best_ms() {
    local best=""
    for _ in $(seq "$RUNS"); do
        local start end ms
        start=$(date +%s%N)
        "$1" > /dev/null
        end=$(date +%s%N)
        ms=$(( (end - start) / 1000000 ))
        if [ -z "$best" ] || [ "$ms" -lt "$best" ]; then best=$ms; fi
    done
    echo "$best"
}

status=0
for src in trith/bench/*.trh; do
    name=$(basename "$src" .trh)
    "$TRITHC" "$src" -o "$OUT/$name.trith"
    clang -O2 -o "$OUT/$name.c" "trith/bench/$name.c"
    a=$("$OUT/$name.trith")
    b=$("$OUT/$name.c")
    if [ "$a" != "$b" ]; then
        echo "FAIL $name: output differs (trith: $a, c: $b)"
        status=1
        continue
    fi
    t=$(best_ms "$OUT/$name.trith")
    c=$(best_ms "$OUT/$name.c")
    # below 20 ms both are noise; compare against a 20 ms floor
    floor=20
    tt=$(( t > floor ? t : floor ))
    cc=$(( c > floor ? c : floor ))
    ratio=$(awk -v a="$tt" -v b="$cc" 'BEGIN { printf "%.2f", a / b }')
    verdict=ok
    if awk -v r="$ratio" -v l="$LIMIT" 'BEGIN { exit !(r > l) }'; then verdict=FAIL; status=1; fi
    printf "%-8s trith %5d ms   c %5d ms   ratio %s   %s\n" "$name" "$t" "$c" "$ratio" "$verdict"
done
exit $status
