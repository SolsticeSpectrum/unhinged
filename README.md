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

Done so far:

- Milestone 1: lexer and parser.
- Milestone 2: the check pass (stack effects, linearity, borrows, failure, case roles, agreement).
- Milestone 3: native code through LLVM for integers, trits, reals, bytes, string literals, `⋔`, `⥀`, failure handling, prayers and future calls.
- Milestone 4: arrays and strings, borrows at run time, particles, FFI through generated C glue, and checked evidentials and charges.
- Milestone 5: superposition with phase and interference, retrocausal post-selection, reversible functions with generated inverses, past-tense calls evaluated at compile time, and prayer verdicts.

Generated code runs at C speed (within about 0.9–1.06× of `clang -O2`) on all four benchmarks: fib, Collatz, n-body and Game of Life.

Milestone 6, rewriting the compiler in Trith itself (stage s2), is under way. The lexer is done (`trith/s2/`). It is compiled by s1, and it prints exactly what `trithc --tokens` prints, error messages included, for every Trith file in the repository. Unlike s1, it exits with status 1 after an error.

```bash
make trith          # builds build/trithc
make trith-test     # golden tests in trith/tests/ (also run by make test)
make trith-bench    # benchmark gate: each program within 1.5× of clang -O2 C
make trith-memcheck # valgrind over every test program: no invalid accesses, no leaks

./build/trithc main.trh -o main      # compile (run from the repo root; needs clang)
./build/trithc main.trh --emit-llvm  # print the generated LLVM IR

./build/trithc file.trh --tokens     # token stream after the Boustrophedon Rule
./build/trithc file.trh --ast        # parsed and tangled item tree
./build/trithc file.trh --check      # type-check, printing the virtual stack after every operation
./build/trithc draft.trh --plough    # logical order (all lines left to right) → on-disk order, padded with breaths
./build/trithc file.trh --unplough   # on-disk order → logical order, for reading
```

Writing on-disk Trith by hand is error-prone (even lines run right to left, and the token count must divide by 3). Write the logical order and run `--plough`.

The s2 sources (`trith/s2/src/*.trhx`) are logical-order Trith with a few authoring shorthands, expanded by `trith/s2/tools/trx.py`. Named moments `⧖:x` / `⧗:x` become `⧖` / `⧗ⁿ` with the index counted for you, following Trith's own scope rules. `‹name›` gets a unique Runic function name, `#42#` becomes a balanced-ternary literal, and `$text$` becomes a string literal. The generated, ploughed `trith/s2/s2lex.trh` is committed, so building s2 needs no Python.

```bash
make s2             # builds build/s2lex from trith/s2/s2lex.trh with s1
make s2-test        # s2 and s1 token dumps must agree on every .trh file (also run by make test)
make s2-fuzz        # 1000 random lexer inputs, s2 against s1
make s2-regen       # regenerate trith/s2/s2lex.trh from trith/s2/src (needs python3)

./build/s2lex file.trh               # same output as trithc file.trh --tokens
```

Golden tests: `trith/tests/<suite>/<name>.trh` is compared with `<name>.out`. To regenerate the `.out` files after an intended change, run `BLESS=1 TRITHC=build/trithc build/trith-tests` and review the diff.

## Layout

- `bootstrap/` Rust bootstrap compiler.
- `compiler/` UNHINGED compiler source.
- `runtime/` LLVM IR runtime.
- `tests/` Embedded test runner and helpers.
- `examples/` Example programs (compile outputs into `output/`).
- `docs/TRITH.md` Trith (v2) language spec.
- `trith/` Trith compiler (s1 in `trith/src/`, written in UNHINGED), its golden tests and benchmarks, and the self-hosted compiler in progress (`trith/s2/`, written in Trith).

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
