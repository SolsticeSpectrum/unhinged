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

## Trith (v2, in progress)

Trith is the successor language; the spec is [`docs/TRITH.md`](docs/TRITH.md).
Its first compiler, `trithc` (stage s1), is written in UNHINGED and built by `build/unhingedc`.

Milestone 1 (lexer and parser) is done. Code generation is not implemented yet.

```bash
make trith          # builds build/trithc
make trith-test     # golden tests in trith/tests/ (also run by make test)

./build/trithc file.trh --tokens     # token stream after the Boustrophedon Rule
./build/trithc file.trh --ast        # parsed and tangled item tree
./build/trithc draft.trh --plough    # logical order (all lines left to right) → on-disk order, padded with breaths
./build/trithc file.trh --unplough   # on-disk order → logical order, for reading
```

Writing on-disk Trith by hand is error-prone (even lines run right to left, and the token count must divide by 3). Write the logical order and run `--plough`.

Golden tests: `trith/tests/<suite>/<name>.trh` is compared with `<name>.out`. To regenerate the `.out` files after an intended change, run `BLESS=1 TRITHC=build/trithc build/trith-tests` and review the diff.

## Layout

- `bootstrap/` Rust bootstrap compiler.
- `compiler/` UNHINGED compiler source.
- `runtime/` LLVM IR runtime.
- `tests/` Embedded test runner and helpers.
- `examples/` Example programs (compile outputs into `output/`).
- `docs/TRITH.md` Trith (v2) language spec.
- `trith/` Trith compiler (s1, written in UNHINGED) and its golden tests.

## Examples

Keep generated binaries and artifacts in `output/` to avoid cluttering the repo.

Game of Life:

```bash
./build/unhingedc examples/life.uh output/life
./output/life
```

HTTP demo site:

```bash
./build/unhingedc examples/website.uh output/website
./output/website
```
