# UNHINGED (v1)

UNHINGED is the postfix, symbol-driven language this repository started with. It has been replaced by [Trith](../README.md). It is kept for one reason: `trithc`, the first Trith compiler (stage s1, `trith/src/`), is written in UNHINGED. The bootstrap chain is therefore Rust → UNHINGED → Trith (s1) → Trith (s2).

Nothing new is written in UNHINGED. Fixes go in only when s1 needs them.

## Build pipeline

The build has three stages:

1. Build the Rust bootstrap compiler (`bootstrap/`).
2. Use it to compile the UNHINGED compiler (`compiler/`) into stage1, `build/stage1`.
3. Use stage1 to compile the compiler again into stage2, `build/unhingedc`.

Stage1 is already self-hosted. Stage2 checks that the compiler can rebuild itself without the bootstrap.

Run these from the repository root:

```bash
make unhinged          # build/unhingedc
make unhinged-test     # the compiler's own tests (also part of make test)
```

- `runtime/rt.c` is the C runtime that every UNHINGED program links. At start it raises the stack limit, so deep recursion in programs such as `trithc` does not overflow.
- `tests/tests.uh` embeds all test sources and compiles and runs them with `UNHINGEDC`.
- The network and SMTP tests are skipped unless enabled: `RUN_NET=1` enables the HTTP and WebSocket tests, and `RUN_SMTP=1` enables SMTP.

### SMTP (MailHog)

```bash
python unhinged/tests/servers/mailhog_start.py
RUN_SMTP=1 SMTP_HOST=127.0.0.1 SMTP_PORT=1025 SMTP_TLS=0 SMTP_STARTTLS=0 make unhinged-test
python unhinged/tests/servers/mailhog_stop.py
```

Captured mail is at http://127.0.0.1:8025.

## Examples

```bash
./build/unhingedc unhinged/examples/life.uh output/life && ./output/life
./build/unhingedc unhinged/examples/website.uh output/website && ./output/website
```

Trith ports of the standard library these examples use are in `trith/lib/`.
