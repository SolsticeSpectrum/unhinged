# Trith

Trith is a postfix language with no variable names. Values flow on a stack, and time is a strand of moments you read by how long ago they were bound. Truth has three values. Values carry evidence and units, and quantum values are linear. Function bodies can be scattered across a file, and every other line of a source file runs right to left. Underneath, it is boring: everything strange is resolved at compile time, and the generated code runs at the speed of C (§0, the Zero-Cost Law).

```
⦃ »↵dlrow ,olleh« ⎙̵ ⦄ ⟨⊸⟩ ᛟ ⸫
```

- The language: [`docs/TRITH.md`](docs/TRITH.md). Two proposed extensions, not implemented yet: [Addendum A](docs/TRITH-ADDENDUM-A.md) (planes, the tesseract, dreams, curses and blessings) and [Addendum B](docs/TRITH-ADDENDUM-B.md) (heat and voltage).
- The standard library: [`trith/lib/README.md`](trith/lib/README.md). It covers SHA-256, HMAC and AES; JSON; an HTTP client and server; WebSocket; and SMTP, with TLS for all three network modules.
- Trith replaced UNHINGED, the language this repository started with. UNHINGED now exists only to bootstrap the first Trith compiler; see [`unhinged/README.md`](unhinged/README.md).

## Build and test

You need clang and LLVM (`llvm-link`), Rust (cargo), Python 3, and OpenSSL's headers (libssl-dev) for the network library. Run everything from the repository root.

```bash
make            # builds build/s2c, the Trith compiler written in Trith (and everything it needs)
make test       # every test below; must pass before a commit
```

```bash
./build/s2c main.trh -o main         # compile to a native binary
./build/s2c main.trh --emit-llvm     # print the generated LLVM IR
./build/s2c file.trh --tokens        # token stream after the Boustrophedon Rule
./build/s2c file.trh --ast           # parsed and tangled item tree
./build/s2c file.trh --check         # type-check, printing the virtual stack after every operation
./build/s2c main.trh --include trith/lib/json.h --link trith/lib/json.c -o main   # with a library module

./build/trithc draft.trh --plough    # logical order (every line left to right) → on-disk order, padded with breaths
./build/trithc file.trh --unplough   # on-disk order → logical order, for reading
```

Writing on-disk Trith by hand is error-prone: even lines run right to left, and the token count must be divisible by 3. Write in logical order and run `--plough`.

## The compilers

The compiler exists twice, and the two must agree byte for byte.

| Stage | Source | Binary | Written in |
|---|---|---|---|
| s1 | `trith/src/*.uh` | `build/trithc` | UNHINGED, compiled by `build/unhingedc` |
| s2 | `trith/s2/src/*.trhx` → `trith/s2/s2c.trh` | `build/s2c` | Trith, compiled by s1 |
| s3 | `trith/s2/s2c.trh` | `build/s3c` | Trith, compiled by s2 |

For every Trith file in the repository, s2 prints exactly what s1 prints for `--tokens`, `--ast`, `--check` and `--emit-llvm`, traces and error messages included, and compiles programs the same way. s3 emits the same IR as s2 and is the same executable: that is the fixpoint (§17). s2 is the faster of the two. It compiles its own 8,000-line source in about 0.35 s, where s1 takes 11 s, and it exits with status 1 after an error. --plough and --unplough exist only in s1.

The s2 sources are Trith in logical order with a few authoring shorthands, which `trith/s2/tools/trx.py` expands:

- Named moments `⧖:x` / `⧗:x` become `⧖` / `⧗ⁿ`, with the index counted by Trith's own scope rules. A read carries the agreement mark written after its name: `⧗:C̵` moves the heap `C`, and `⧗:m̱` reads a shadow.
- `‹name›` gets a unique Runic function name.
- `#42#` becomes a balanced-ternary literal, and `$text$` a string literal.

The generated, ploughed `trith/s2/s2c.trh` is committed, so building s2 needs no Python.

```bash
make trith          # s1: build/trithc
make s2             # s2: build/s2c, from the committed trith/s2/s2c.trh
make s2-regen       # regenerate trith/s2/s2c.trh from trith/s2/src (after editing s2)
make s3             # s3: build/s3c
```

## Tests

| Target | What it checks |
|---|---|
| `make trith-test` | golden tests: each `trith/tests/<suite>/<name>.trh` against `<name>.out` |
| `make s2-test` | s2 and s1 agree on every dump of every `.trh` file, and on every compiled test program |
| `make s2-fixpoint` | s3 emits exactly what s2 emits, is the same executable, and passes s2-test |
| `make lib-test` | each library module's test, built with s1 and with s2, run against its `.out` |
| `make unhinged-test` | the UNHINGED bootstrap compiler's own tests |
| `make s2-fuzz` | random lexer inputs, random programs, and mutated tests: s2 against s1 (not part of `make test`) |
| `make trith-bench` | each benchmark within 1.5× of the same program in C at `clang -O2` |
| `make trith-memcheck` | valgrind over every test program: no invalid accesses, no leaks |

To regenerate the golden `.out` files after an intended change, run `BLESS=1 TRITHC=build/trithc build/trith-tests` and review the diff. `make lib-regen` and `make bench-regen` regenerate the `.trh` files that are written as `.trhx`.

Generated code runs within about 0.9–1.06× of `clang -O2` on fib, Collatz, n-body and Game of Life. SHA-256 of 100 MiB runs at about 1.2×, because its 32-bit words live in 64-bit integers with masks.

## What is implemented

The whole of `docs/TRITH.md`, in both compilers:

- the Boustrophedon Rule and the Ternary Balance Law;
- the strand of moments, with region-scoped borrows;
- case marks and agreement;
- three-valued truth with `⋔` and `⥀`;
- failure;
- the quantum layer: ownership, borrows, superposition with phase and interference, retrocausal post-selection, particles and antiparticles;
- functions: call by shape, the past and future tenses, scattered bodies;
- generics, with type variables and quotations over row-polymorphic effects;
- reversible functions with generated inverses;
- centre-indexed arrays and strings;
- prayers;
- FFI through generated C glue.

The order in which this was built, and the decisions taken on the spec's open questions, are in §16 and §17 of the spec.

## Layout

- `docs/` holds the language specification and the proposed addenda.
- `trith/src/` is s1, the first compiler, written in UNHINGED.
- `trith/s2/` is s2, the compiler written in Trith: sources, the generated `s2c.trh`, the authoring tools, and the agreement test.
- `trith/runtime/` is the C runtime linked into every Trith program.
- `trith/lib/` is the standard library: C modules bound with `⎔`.
- `trith/tests/` holds the golden tests: lexer, parser, checker, check errors, programs that run, and emitted IR.
- `trith/bench/` holds the benchmarks, each next to the same program in C.
- `unhinged/` is the UNHINGED compiler (Rust bootstrap and self-hosted compiler), its runtime, tests and examples. It is kept to build s1.
- `build/` and `output/` hold build products and test output; neither is committed.
