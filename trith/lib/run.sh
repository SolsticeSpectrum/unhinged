#!/bin/sh
# Standard library tests: each trith/lib/tests/X.trh is built against trith/lib/X.c
# by $TRITHC (s1 by default; TRITHC=build/s2c tests s2) and run, and its output must
# be exactly trith/lib/tests/X.out. The smtp test mails a fake server
# (smtp_server.py), and what that server received is part of its output. The TLS
# servers use a self-signed certificate made here, which the clients are told to trust.
# UPDATE=1 rewrites the .out files instead. Run from the repo root.
TRITHC=${TRITHC:-build/trithc}
mkdir -p output/lib-test
cert=output/lib-test/cert.pem
key=output/lib-test/key.pem
if [ ! -s "$cert" ] || [ ! -s "$key" ]; then
    openssl req -x509 -newkey ec -pkeyopt ec_paramgen_curve:prime256v1 -nodes -days 3650 \
        -subj /CN=localhost -addext "subjectAltName=DNS:localhost,IP:127.0.0.1" \
        -keyout "$key" -out "$cert" 2>/dev/null || { echo "lib: cannot make a certificate (openssl)"; exit 1; }
fi
export SSL_CERT_FILE=$cert
pass=0
fail=0
for f in trith/lib/tests/*.trh; do
    n=$(basename "$f" .trh)
    out=output/lib-test/$n.out
    rm -f output/lib-test/$n output/lib-test/$n.server
    libs=
    if grep -q '"tls.inc"' "trith/lib/$n.c"; then libs="--link -lssl --link -lcrypto"; fi
    if ! "$TRITHC" "$f" --include "trith/lib/$n.h" --link "trith/lib/$n.c" $libs -o "output/lib-test/$n" > "$out" 2>&1; then
        :
    elif [ "$n" = smtp ]; then
        python3 trith/lib/tests/smtp_server.py 8475 3 "output/lib-test/$n.server" "$cert" "$key" &
        while [ ! -e "output/lib-test/$n.server" ]; do sleep 0.05; done
        timeout 30 "output/lib-test/$n" >> "$out" 2>&1
        echo "exit=$?" >> "$out"
        wait
        cat "output/lib-test/$n.server" >> "$out"
    else
        timeout 30 "output/lib-test/$n" >> "$out" 2>&1
        echo "exit=$?" >> "$out"
    fi
    if [ -n "$UPDATE" ]; then
        cp "$out" "trith/lib/tests/$n.out"
    fi
    if cmp -s "$out" "trith/lib/tests/$n.out"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
        echo "FAIL $f"
        diff "$out" "trith/lib/tests/$n.out" | head -10
    fi
done
echo "lib: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
