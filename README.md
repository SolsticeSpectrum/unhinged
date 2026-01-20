# UNHINGED

UNHINGED is a postfix, symbol-driven language with a self-hosted compiler.

## Build Pipeline

Three-stage build:

1) Build the Rust bootstrap compiler.
2) Use the bootstrap to compile the UNHINGED compiler (stage1).
3) Use stage1 to compile the final compiler (stage2).

The final binary is `build/unhingedc`.
Stage1 is `build/stage1`.

Why stage2:

- Stage1 is already self-hosted.
- Stage2 is a sanity check that the compiler can rebuild itself without relying on the bootstrap and that the output stabilizes.

## Build

```bash
make build
```

## Test

```bash
make test
```

Optional service tests:

- `RUN_NET=1` enables HTTP + WebSocket tests.
- `RUN_SMTP=1` enables SMTP (MailHog setup below).

Notes:

- `tests/tests.uh` embeds all test sources and compiles/runs them using `UNHINGEDC`.
- Net and SMTP tests are skipped unless enabled via env flags.

### SMTP (MailHog)

Start MailHog:

```bash
python tests/servers/mailhog_start.py
```

Run SMTP tests:

```bash
RUN_SMTP=1 SMTP_HOST=127.0.0.1 SMTP_PORT=1025 SMTP_TLS=0 SMTP_STARTTLS=0 make test
```

View captured email:

- http://127.0.0.1:8025

Stop MailHog:

```bash
python tests/servers/mailhog_stop.py
```

## Layout

- `bootstrap/` Rust bootstrap compiler.
- `compiler/` UNHINGED compiler source.
- `runtime/` C runtime.
- `tests/` Embedded test runner and helpers.
