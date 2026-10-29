# Trith Addendum A: Planes, the Tesseract, Dreams, Curses and Blessings (draft 1)

> Extends `docs/TRITH.md`. Section numbers here are prefixed with `A.`; a bare section number (such as §9.3) refers to TRITH.md.
> The Zero-Cost Law (§0) applies to every feature in this addendum without exception. Every section ends with **Cost**, **Problems** and **Precedent**.
> Status: the features are implemented in s2 (`build/s2c`) as milestones A1–A6 land; s1 stays frozen (A.8). Each implemented section ends with **As built**, which records what the draft left open and what s2 does.

Summary:

| Feature | One line | Lives in |
|---|---|---|
| A.1 Planes | A program is a 3-D lattice; each file is one slice of it | lexer |
| A.2 Tesseract | Functions live at vertices of a 3ⁿ hypercube; called by coordinate or by neighbour | resolver, plus a jump table for runtime coordinates |
| A.3 Dreams | Compile-time functions rewrite the token stream; replaces `trx.py` | compile-time evaluator |
| A.4 Curses | Effects, inferred and contagious; lifted only by handling or exorcism | type checker |
| A.5 Blessings | Pure and provably terminating; unlocks LLVM attributes | type checker and emitter |
| A.6 Cursed particles | Linear values that can never be dropped, only ended by a rite | type checker |

---

## A.1 Planes: the file is a shadow

A **module** is a three-dimensional lattice of token cells (x, y, z):

- **x** is the token's position in its logical line, after the Boustrophedon Rule has been applied to that line.
- **y** is the line number within the plane, starting at 1.
- **z** is the plane ordinal, a balanced-ternary integer.

A `.trh` file holds one or more planes. Reading a single file shows only a shadow of the program.

### A.1.1 Plane headers

- A plane starts with a **header line** that contains only `⧉ z ⁿ`. Here z is the plane's ordinal, and the superscript n is the total number of planes in the module.
- Line numbering (y) restarts at 1 after every header. The header is not a line of the plane and does not count toward any rule.
- A file may contain several headers, and therefore several planes. This works like the form feed in Trefunge.
- A file with no header is plane ○ of a one-plane module, so every existing `.trh` file keeps its meaning.
- All the files passed to one `trithc` invocation form one module. The compiler never collects sibling files on its own, so the build stays deterministic.

### A.1.2 Folding

The compiler reconstructs the logical token stream by **folding**:

```
for y in 1, 2, 3, …:
    zs = all plane ordinals, ascending  if y is odd
                             descending if y is even    (the plough also turns in depth)
    for x in 0, 1, 2, …:
        for z in zs:
            emit cell (x, y, z) if it exists
```

- A line may be shorter in one plane than in another. Cells that are missing are simply skipped.
- A breath `⸱` can hold a cell's place explicitly. It counts toward the Balance Law and is then discarded (§1.2).
- Comments are removed from each plane before folding, and they occupy no cells.
- A string literal occupies one cell.
- The **Balance Law** (§1.2) applies to the folded module, not to individual files. A single plane may be unbalanced.
- Errors are reported with the cell's file, line and column, plus its lattice coordinates: `main.trh:3:7 (x=2, y=3, z=▽)`.

The rules for planes:

- The n in every header must equal the number of distinct plane ordinals found in the module. Otherwise the error is **missing dimension** or **phantom dimension**.
- Two headers with the same z are an error, **collapsed dimension**.

### A.1.3 Example: hello, world across three planes

The logical tokens are `⦃ »↵dlrow ,olleh« ⎙̵ ⦄ ⟨ ⊸ ⟩ ᛟ ⸫`, all on line 1 (an odd line, so z ascends).

`hello.▽.trh`:
```
⧉ ▽ ³
⦃ ⦄ ⟩
```

`hello.○.trh`:
```
⧉ ○ ³
»↵dlrow ,olleh« ⟨ ᛟ
```

`hello.△.trh`:
```
⧉ △ ³
⎙̵ ⊸ ⸫
```

Build it with `trithc hello.▽.trh hello.○.trh hello.△.trh -o hello`. On its own, each file looks like broken code.

### A.1.4 Tooling

These are the only sane ways to read or edit a multi-plane module.

- `trithc --fold a.trh b.trh …` prints the folded module as a single-plane logical-order file.
- `trithc --unfold n file.trh` spreads a single-plane logical file over n planes, dealing cells to planes in turn (round-robin). The output is deterministic.
- `--fold`/`--unfold` compose with `--plough`/`--unplough`.

**Cost.** Lexer only. Folding is one merge pass over the cells of each line.

**Problems.**

- **An edit to one plane reorders the rest of the line in every other plane's reading.** Inserting a token in plane ▽ shifts plane ▽'s later cells to higher x, and so changes their interleaving with planes ○ and △. Hand-editing a multi-plane module is close to impossible; editing means fold, change, unfold. This is the point of the feature.
- Per-file diffs are meaningless, and code review has to work on folded output.
- Error positions need four coordinates.
- Missing files are only detectable because of the plane count in the header.

**As built (milestone A1).**

- `s2c a.trh b.trh … -o prog` compiles the module made of all its files, in command-line order (which only matters for the file index in error messages). A module of one file without a header takes exactly the old path, token for token, so s1 and s2 still agree on every such file.
- A plane's lines are numbered from 1 after its header, and the Boustrophedon Rule uses that y. A file that has headers must start with one; a token before the first header is an error.
- A breath inside a plane holds its cell, so it can push the plane's later cells to a higher x; it is dropped after folding.
- Errors in a plane cell print `file:line:col (x=…, y=…, z=…)`, with the file's own line and column; lexer errors, which come before folding, print `(y=…, z=…)`.
- A quotation (§9.5) in a module of planes is named by its lattice coordinates, `⦃x,y,z⦄`, since line and column no longer identify a cell across files.
- `--fold` prints logical order, as specified. s2 cannot read logical order (only s1's `--plough` can), so `--unfold n file.trh` takes an on-disk single-plane file and prints the n planes on disk, in one file: header, then lines, with a final line of breaths if the module needs them. The planes are `z = −h … n−1−h` with `h = ⌊(n−1)/2⌋`, and the cells of each line are dealt in turn, ascending z on odd lines and descending on even ones, so folding gives the tokens back in order: `--fold` of what `--unfold` printed is `trithc --unplough` of the original, without its comments.
- Gate: every program in `trith/tests/run`, unfolded over 2, 3 and 5 planes, compiles and prints what it prints in one plane; folding the unfolded file gives the original token stream back. The tests are in `trith/s2/tests/*/planes_*` and `plane_*`.

**Precedent.** Trefunge (Funge-98), where a form feed starts the next z-plane. 4DL, whose programs are shown as stacked and side-by-side slices. Mu's layers, which a tangle tool merges into one source. Literate programming's tangle step.

---

## A.2 The Tesseract

A module may place its functions at the vertices of a **hypercube of dimension n**, where 1 ≤ n ≤ 9. That gives at most 3⁹ = 19,683 vertices.

### A.2.1 Vertices

- A **coordinate** is written `⌗` followed by n trit glyphs, for example `⌗⊕⊖⦶`. The first trit is axis 1.
- Coordinates are elements of Z₃ⁿ, with digits −, 0 and +. Every coordinate in a module must have the same length n.
- A definition places a function at a vertex by writing the coordinate after the name: `⦃…⦄ ⟨ℤ ⊸ ℤ⟩ ᚠ ⌗⊕⊖⦶ ⸫`.
- The coordinate may also replace the name, giving an anonymous function that can only be called by coordinate: `⦃…⦄ ⟨ℤ ⊸ ℤ⟩ ⌗⊕⊖⦶ ⸫`.
- Every function has a name, a vertex, or both. Two functions at one vertex are an error, **occupied vertex**.

### A.2.2 Calls

| Form | Meaning | Lowering |
|---|---|---|
| `⌗⊕⊖⦶` in call position | call the function at that vertex | direct call |
| `⟰ⁿ` | call the neighbour one step **up** axis n from the current function's vertex | direct call |
| `⟱ⁿ` | call the neighbour one step **down** axis n | direct call |
| `⍥ ⟨S ⊸ S'⟩` | **summon**: pop n trits (the last axis on top), then call the vertex they name, which must have shape `⟨S ⊸ S'⟩` | `switch` over the vertex index, or a jump table |

Further rules:

- **The cube is a torus.** Stepping up from ⊕ wraps to ⊖, and stepping down from ⊖ wraps to ⊕; this is addition mod 3 in balanced form. Calling an empty vertex is a compile error, **void in the hypercube**.
- `⟰`/`⟱` are legal only inside a function that has a vertex.
- **Summon** produces `◌S'`. Vertices that are empty, or whose shape is different, fail. When the trits are known at compile time, the summon becomes a direct call. The vertex index is Σ (tᵢ + 1)·3ⁱ⁻¹, and LLVM chooses between a table and a branch tree.

### A.2.3 Rotation

`⟲ⁱʲ ⦃ block ⦄` swaps axes i and j for every neighbour call (`⟰ ⟱`) and every summon inside the block. Rotations nest and compose, so a block can rotate the whole cube underneath its calls. Absolute coordinates are not affected.

**Cost.** Coordinates, neighbour calls and rotations are resolved by the resolver, so they cost nothing. A summon costs one index computation and one indirect branch, the same as a C function-pointer table or a `switch`.

**Problems.**

- A function has two identities (its name and its vertex), so tools have to show both.
- A typo in a coordinate silently calls a different function. That is alien by design, and prayers (§12) can guard against it.
- The table for a summon in a dense 9-cube is 157 KB of pointers. Summons are therefore limited to n ≤ 6 (729 vertices). Larger cubes allow only static calls.
- The curse set of a summon (A.4) is the union of the curses of every vertex with that shape. This is conservative.
- Call by shape (§9.1) and summons both select functions by shape. Call by shape searches the whole module, and a summon searches only the cube.

**Precedent.** The Tesseract esolang (2024), which runs code on a 2-D representation of a 4-D hypercube. The Hypercube esolang, which keeps its memory as bits on an infinite-dimensional hypercube. 4DL. Jump tables and vtables.

---

## A.3 Dreams: the program dreams itself

A **dream** is a compile-time function that takes tokens and returns tokens. Dreams are Trith's only self-modifying code, and they finish before parsing begins. Runtime self-modification is forbidden (§0), because it breaks W^X, defeats LLVM and needs a JIT.

### A.3.1 Dream matter

- `ϟ` is the **token** type. It holds the token class, its text, its marks, and its **origin** (file, line, column and lattice z).
- `ϟ` exists only in the compile-time evaluator. A function whose signature mentions `ϟ` cannot be called at runtime; doing so is the error **dream matter in the waking world**.
- `⟪ … ⟫` is a **quote**, a literal of type `⟦ϟ⟧`. Its contents are lexed but not parsed. Quotes nest, and brackets inside a quote balance only on `⟪⟫`. The quote brackets are self-delimiting.

### A.3.2 Dream definitions and sites

- A dream is defined with the `☾` prefix: `☾ ⦃ … ⦄ ⟨⟦ϟ⟧ ⊸ ◌⟦ϟ⟧⟩ ᛞ ⸫`. Classical configuration inputs may come before the array.
- **Local site.** `⟪ tokens ⟫ ☾ᛞ` runs ᛞ on the quoted tokens and replaces the whole site with the result.
- **File dream.** If the first logical line of a module (after folding) is `☾ᛞ` and nothing else, the rest of the module is passed through ᛞ.
- **Re-dreaming.** Dream output is scanned again for dream sites, up to a depth of 27 (3³). Going deeper is the error **limbo**.

### A.3.3 Where dreams come from (stratification)

- Dreams are defined in **dream modules**, passed with `--dream FILE` (and repeatable). Each dream module is compiled in command-line order before the main module.
- A dream module may only use dreams from dream modules that appear earlier on the command line.
- A module can never dream with a dream it defines itself. This rules out cycles and keeps the build deterministic.

### A.3.4 The evaluator

- Today the evaluator refuses containers, so it must be extended to handle `ʃ`, `⟦T⟧` and `ϟ`.
- A dream's callee set must be **pure**, meaning it carries no ⁱ or ᵘ curse (A.4).
- **Fuel:** 3¹⁸ ≈ 3.9·10⁸ steps per module, against today's 10⁷ for past tense. Running out is the error **nightmare**.
- **Memory:** 2³⁰ bytes per module. Exceeding it is the error **fever dream**.
- Dreams have no I/O, no clock and no randomness. Their output depends only on their input tokens, so the s3 fixpoint is safe.

### A.3.5 Hygiene in a language without names

There are no names to capture, so classic macro hygiene does not apply. The hazard is the **strand** instead: tokens spliced into a function shift every `⧗ⁿ` that follows them. This addendum sets two rules:

1. A local site's output is spliced in as it is, with no implicit block. Its stack and strand effects are visible, and that is intended. A transformation that has to see the whole function, such as expanding named moments, must therefore be a **file dream**.
2. Every output token keeps the origin of an input token, or failing that the origin of the site. All later errors point back to source the programmer wrote. `--dream-trace` prints each dream's input and output.

### A.3.6 Retiring `trx.py`

The s2 sources are currently `.trhx` files expanded by Python. Dreams make the toolchain pure Trith.

1. Port `trith/s2/tools/trx.py` to a dream module, `trith/s2/dreams/trx.trh`, covering every feature it handles:
   - `#n#` numerals
   - `$text$` strings
   - `⧖:x` / `⧗:x` named moments, with the §5.1 scope simulation, agreement marks and the linearity tracking of `C`
   - `‹name›` names, in the same deterministic assignment order
   - `%%…%%` string builders
   - `@any(…)@`
2. **Acceptance test.** The dream's output must be **token-identical** to trx.py's output for every s2 source.
3. Rename the s2 sources from `.trhx` to `.trh`, each starting with a file-dream line.
4. `s2c --dream-only` prints the dreamed, ploughed source. This regenerates the committed `trith/s2/s2c.trh`, so s1 can still bootstrap s2.
5. Delete `trx.py`. `make s2-regen` no longer needs Python.
6. Gate: `make s2-fixpoint` passes, and compiling the s2 sources through the dream takes at most 2× the current s2 compile time.

s1 never gains dreams. It only ever builds s2 from the committed `s2c.trh`.

**Cost.** Compile time only, with zero runtime cost. The evaluator is the only interpreter in the toolchain, and it never reaches the output binary.

**Problems.**

- The evaluator grows into a real interpreter over containers, which is code to maintain and test.
- Compile time grows. The fuel and memory caps bound it, and A.3.6 sets a gate.
- Errors in dream-generated code are confusing, which origins and `--dream-trace` mitigate.
- Code written through dreams is unreadable without the dream. That is intended.
- A dream that edits strand indices incorrectly produces code that type-checks but is wrong. The trx port's acceptance test exists to guard against this.

**Precedent.**

- Rust procedural macros (token streams in, token streams out).
- Zig `comptime` with its eval branch quota, which plays the same role as fuel.
- Nim macros, which run in a compile-time VM.
- Scheme `syntax-rules` (hygiene).
- MetaOCaml and Scala's unification of multi-stage programming and macros.
- Template Haskell's stage restriction, which plays the same role as stratification (from memory, not searched).

---

## A.4 Curses (effects)

Every function has a **curse set**. The compiler infers it from the curses of the operations the body performs and the functions it calls, minus the curses lifted inside it.

| Curse | Name | Acquired by |
|---|---|---|
| `⸸ᶠ` | fallible | the function may fail (its output is `◌`), derived from the signature |
| `⸸ⁱ` | worldly | `⎙`, runtime I/O, and FFI bindings (worldly by default) |
| `⸸ᵘ` | forbidden | FFI bindings declared `⎔⸸ᵘ` (raw memory; can corrupt state) |
| `⸸ᵈ` | restless | a `⥀`, or recursion, not covered by a proven vow (A.5) |
| `⸸ᵃ` | hungry | array and string literals, `⍆`, and FFI results of type `ʃ` or `⟦T⟧` |

### A.4.1 Declaration

- A signature may name its curses after `⟩`, for example `⟨ℤ ⊸ ℤ⟩⸸ⁱᵃ`.
- If curses are declared, the inferred set must **equal** the declared set. A curse that is inferred but not declared is the error **unspoken curse**; a curse that is declared but not inferred is **false accusation**.
- If no curses are declared, the inferred set is used silently, so the 10,000-line compiler stays writable.
- `--confess` makes declarations mandatory for every function, and `--confessions` lists every exorcism in the module.

### A.4.2 Lifting curses

| Curse | Lifted by |
|---|---|
| ᶠ | handling the failure with `⁇` (as today) |
| ᵈ | a vow (A.5) |
| ⁱ ᵘ ᵃ | an **exorcism** block, `⛨ˣ ⦃ … ⦄`, where x lists the lifted curses (e.g. `⛨ⁱ`) |

- An exorcism is the programmer's promise that the effect does not leak observably. It is the same idea as wrapping unsafe code in a safe API with Rust's `unsafe {}`.
- `ᛟ` may carry any curses.

### A.4.3 Shapes

Curses are **not** part of a function's shape for call by shape (§9.1) or for summons. Inferred curses change as code changes, and shapes must stay stable.

**Cost.** Type checker only.

**Problems.**

- Function colouring: a single ⁱ deep in a helper curses every caller. Inference reduces the friction, but `--confess` mode would be heavy.
- Exorcisms can be abused. Making them greppable and listing them with `--confessions` is the only defence.
- Trith has no first-class functions, so it needs no effect polymorphism yet; summons take the conservative union. If generics arrive (an open question in §16), curses will need Koka-style effect rows.

**Precedent.** Koka's row-polymorphic effect types and handlers. Bob Nystrom's "What Color is Your Function?". Rust `unsafe` blocks. Haskell's `IO` and Java's checked exceptions (from memory).

**As built (milestone A2).**

- Inference is a fixpoint over the call graph. A function's set is its own curses, plus each callee's set less what the exorcisms around that call lift; ᶠ comes from the signature alone (an output `◌`). A past-tense call (`ᚠ̈`) runs at compile time, so it is no call of the function's.
- What acquires a curse: `⎙` and `⎙̵` are ⁱ, and so are `⋔⇋` (a failed exit assertion stops the program) and `⊙⁻`/`⊙⁺`. A ⥀ that may leave with ⊖ in a function that cannot fail stops the program, so it is ⁱ too, unless the vow prover shows the ⥀ never leaves with ⊖. String and array literals and `⍆` are ᵃ. An FFI binding is ⁱ, ᵘ when declared `⎔⸸ᵘ`, and ᵃ when it returns a string or an array. `⌁` on a particle calls its antiparticle, so it takes on that function's curses.
- ᵈ comes from a ⥀ without a vow, from a function that calls itself without a vow, and from any function in a cycle of calls with others, whatever it vows (the prover only follows a function calling itself).
- A declared set must equal the inferred one: **unspoken curse** or **false accusation** otherwise. `--confess` makes every function declare one (**unconfessed**). An exorcism names the curses it lifts; a bare `⛨ ⦃ ⦄` is an error (a bare ⛨ prefixes a rite, A.6), and so is `⛨ᶠ` or `⛨ᵈ`.
- `--curses` prints every function's set, its blessing and its count of hopeful vows. `--confessions` prints every exorcism, `file:line:col ⛨ˣ`, once even when its block is checked more than once.
- The emitter emits an exorcism's block in place. **An exorcism is also a promise about attributes**: an exorcised function can be blessed (A.5.2), and then LLVM may move, merge or delete its calls. `⛨ⁱ ⦃ ⎙ ⦄` in a pure function can therefore print fewer times than it is called, or not at all, in a release build. Use it only for effects that must not show.
- Tests: `trith/s2/tests/check/curses`, `check/confessions` and `check_errors/{unspoken,false_accusation,unconfessed,exorcise_restless}`.

---

## A.5 Blessings (purity and totality)

### A.5.1 Vows

A **vow** is a prayer about termination:

- `⍤⥀ ⦃ measure ⦄` is written directly before a `⥀`. The measure receives copies (or shadows) of the loop-carried stack and leaves one `ℤ`.
- `⍤ᚠ ⦃ measure ⦄` is written at the start of a recursive function ᚠ. The measure receives the function's inputs.

The measure must be at least 0 on entry and must **strictly decrease** on every iteration or recursive call.

- A vow the compiler **proves** lifts ᵈ. The prover reuses the prayer machinery (§12) and handles linear measures with literal steps, guarded by the faces of an enclosing `⋔` on the same moment.
- A vow the compiler **cannot prove** is **hopeful**. In debug builds it traps when the measure fails to decrease. In release builds it lifts ᵈ only for curse bookkeeping, **never** for attributes (A.5.3).
- A vow proven false is the error **perjury**.

### A.5.2 Blessed functions

A function is **blessed** (`✧`) when its curse set contains none of ⁱ, ᵘ and ᵈ. Failure and allocation are allowed, because both are values and both are pure.

A function is **doubly blessed** (`✧✧`) when its curse set is empty.

- Writing `✧` or `✧✧` before a definition is an assertion. If it does not hold, the error is **fallen**.
- Blessedness is always inferred, whether or not it is declared.

### A.5.3 What blessing buys

| Level | LLVM attributes emitted |
|---|---|
| `✧`, with every vow proven | `nounwind willreturn mustprogress` |
| `✧✧`, with every vow proven | the above, plus `memory(none)` (or `memory(argmem: read)` when it takes shadows) |

With these attributes LLVM can hoist, deduplicate, speculate and delete calls to blessed functions. **This is the one feature in this addendum that can make generated code faster.**

**Past tense and dreams require only purity** (no ⁱ or ᵘ). They do not require totality, because the evaluator's fuel already bounds them. So §15.4 (`ᚠ̈`, with no vow) keeps compiling.

**Cost.** Type checker only, plus attributes. Code can get faster, never slower.

**Problems.**

- **Soundness.** A wrong `willreturn` or `memory(none)` is undefined behaviour. The attributes therefore depend on curse inference being correct and on vows being *proven*; hopeful vows never contribute. `trith-memcheck` and the fuzzers must cover attributed code.
- Termination is undecidable, so the prover is deliberately weak. Most loops will stay restless unless they carry a simple vow.
- Exorcised functions count as blessed, so an exorcism is also a promise that the function is safe to give these attributes. The documentation for `⛨` has to say this plainly.

**Precedent.** Agda's and Idris's totality and termination checkers. LLVM function attributes (`memory`, `willreturn`, `nounwind`). GCC `__attribute__((pure))` and `__attribute__((const))` (from memory). C++ `constexpr`, and D's `pure` (from memory).

**As built (milestone A2).**

- Placement: `⍤⥀` must come directly before its ⥀, and `⍤ᚠ` must be the first op of ᚠ's body and name ᚠ (an instance of a generic function counts as its function). The measure sees copies of classical values and shadows of the rest, and must leave exactly `[ℤ]`.
- The prover runs the loop's body (or the function's body) over symbols: one for each ℤ the loop carries (or each ℤ input). A value is affine in the symbols, the sign trit of one (from `≶`), or unknown. It follows literals, moments, `⍿`, `⊞ ⊟ ⊝`, `⊠` by a constant, `≶`, exorcisms and `⋔`. At a `⋔` on a known or linear trit the run splits, and each face carries what it implies: g = 0, g ≥ 1 or g ≤ −1. Anything else leaves as many unknowns as the checker counted. A quotation (`⊨`, `⍎`) stops the prover, and so do more than 64 paths.
- A path round the loop that can continue (its trit can be ⊕, which for a linear g adds the fact g ≥ 1) must leave the measure **at least 0 and at least 1 lower**. For a function, so must every call of itself, measured on the call's inputs. A fact f ≥ 0 proves a ≥ 0 when a − λ·f is a constant ≥ 0 for some whole λ ≥ 1. A call of the function inside something the prover does not follow leaves the vow hopeful.
- **Perjury** needs certainty: the measure rises or stays the same by a constant, on a path whose facts can hold together, that went through nothing the prover does not follow (no unknown branch, call or unfollowed op). Anything less is hopeful, never perjury.
- Hopeful vows are allowed (A.9). They lift ᵈ for curses. With `--debug` each one traps (`llvm.trap`) unless its measure is at least 0 and below the last one: at the head of every iteration (the first is compared with the largest ℤ), and on every call of the function, against the measure on entry. A release build erases every vow.
- Attributes: release builds only. A blessed function (no ⁱ, ᵘ or ᵈ) with no hopeful vows is `nounwind willreturn mustprogress`. A doubly blessed one also gets `memory(none)` when it takes only values, `memory(argmem: read)` with ⟗ shadows, and `memory(argmem: readwrite)` with ⟖ shadows. It gets no `memory` attribute when it takes an owned array or string, which it frees. FFI bindings and generated inverses get none.
- s1 knows none of this, so `make s2-test` drops these attributes from s2's IR before comparing. The fixpoint is now that s3 (s2 compiled by s2) rebuilds itself byte for byte, since s2's own blessed functions get attributes from s2 and not from s1.
- Benchmark gate (§17): every program is still within 1.5× of C. s2 gives attributes to 3 of 5 functions in life, 2 of 4 in nbody and 8 of 14 in sha256, none in collatz or fib. The run-to-run noise on the test machine (about ±15%) was larger than any difference between s1's and s2's executables, so there is **no measurable speedup** yet.
- Tests: `trith/s2/tests/check_errors/{fallen,vow_misplaced,vow_not_first,vow_measure,perjury_loop,perjury_recursion}`, `emit/blessed` and `run/{vows,vow_trap,vow_hopeful,exorcism}`.

---

## A.6 Cursed particles (hot potatoes)

`⚛⸸ ℤ ᚋᚐ ⸫` declares a **cursed particle**. It is a particle (§8.6) with no antiparticle:

- `⌁` on a cursed particle is forbidden everywhere. The error is **you cannot destroy what is cursed**.
- The only way to end one is a **rite**: a function declared `⛨ ⦃…⦄ ⟨ᚋᚐ … ⊸ …⟩ ᚱᚢ ⸫`. A rite receives the particle's representation. A type may have several rites; for example, a transaction can only end in commit or rollback.
- A rite may require a second particle as **holy water**. This is just an ordinary parameter, so no extra feature is needed. Example: a lock that can only be released with the guard token it issued.
- The decoherence-leak rule (§8.1) already forces cursed particles to be consumed. The curse removes the implicit drop path at block exit, and it removes `⌁`.
- **The failure path.** A function holding a cursed particle may not propagate a failure (`◌`) past it. The failure must be caught with `⁇`, and both faces must perform a rite. Otherwise the error is **cursed on the road**.

**Cost.** Type checker only.

**Problems.**

- Combining cursed particles with automatic failure propagation is the classic clash between linear types and exceptions. The "cursed on the road" rule keeps it sound, at the cost of verbosity.
- Arrays of cursed particles are rejected, just as arrays of quantum elements are rejected today (§16.1).

**Precedent.** Austral, whose linear types cannot be implicitly dropped and must be consumed exactly once. Rust's `#[must_use]`, and Vale's "higher RAII" (from memory).

---

## A.7 Pipeline (changes to §13)

```
lex        per plane: NFC → tokenise → Boustrophedon reversal (§1.1)
fold       plane headers → 3-D lattice → folded stream (A.1)            NEW
balance    Ternary Balance Law over the folded module (§1.2)            moved
dream      local sites and file dreams, up to depth 27 (A.3)            NEW
parse      LL(1) → item tree, including vertices and rites
resolve    tangle fragments (across planes); names, vertices, ⟰⟱, rotations; shapes
check      effects, linearity, agreement, evidentials, charges, regions, ψ, causality,
           reversibility, tense; curses, vows, blessings, cursed particles  NEW
eval       past tense (pure callees); dreams were run earlier, by the same evaluator
lower      ψ, ◌, ⇋, ⋔, future calls, prayers; summons → switch/jump table   NEW
ssa        unchanged (§13.1)
emit       LLVM IR, plus function attributes for blessed functions          NEW
```

Two interactions follow from this:

- Fragments (§9.3) can now live in different planes, and therefore in different files. That answers the §16 open question "should scattered fragments be allowed across files within a module?" with yes.
- The Balance Law moves from per-file to per-module, which is the same thing for a one-plane module.

---

## A.8 Milestones

s1 is frozen as the bootstrap for `s2c.trh`. **Every feature in this addendum is implemented in s2 only.** `make s2-test` keeps comparing s2 with s1 on the subset s1 understands, and the new features get golden tests that run on s2 alone.

| # | Milestone | Gate |
|---|---|---|
| A1 | Planes: fold, headers, plane errors, `--fold`/`--unfold` | golden tests; folding a one-plane file is the identity on every existing test. **Done.** |
| A2 | Curses, vows, blessings, attributes, `--confess`/`--confessions` | benchmark gate (§17) with no regression; report any speedup from attributes; memcheck and fuzz clean. **Done**; no measurable speedup (A.5, As built). |
| A3 | Evaluator containers and dreams (`⟪⟫`, `☾`, `--dream`, fuel, `--dream-trace`) | golden tests for nightmare, limbo, fever dream and stratification |
| A4 | Retire `trx.py` (A.3.6) | dream output token-identical to trx.py; s2 sources are `.trh`; fixpoint holds; compile time at most 2× |
| A5 | Tesseract: vertices, `⟰⟱`, `⟲`, summons | summon benchmark: a dispatch loop within 1.5× of a C function-pointer table |
| A6 | Cursed particles and rites | golden tests, including "cursed on the road" |
| A7 | *Optional:* the compiler leaves the plane. The s2 sources are committed as three planes | s2 builds from its own unfolded sources; fixpoint holds |

---

## A.9 Open Questions

- Should a function's plane constrain its vertex (for example, plane z requires first coordinate z)? This would tie A.1 and A.2 together, but it is restrictive.
- Should curses be part of call-by-shape keys when they are *declared*? This draft says no.
- Should a summon's shape be inferred from the stack instead of written after `⍥`?
- Should file dreams be allowed per plane, or only per folded module (as this draft says)?
- ~~Should hopeful vows be allowed at all, or should an unproven vow be an error?~~ Allowed; they trap under `--debug` (A.5, As built).
- Should exorcism also be allowed to lift ᵈ? This draft says no: only a vow lifts ᵈ.

---

## A.10 Glyph Additions

| Glyph | Effect | Meaning |
|---|---|---|
| `⧉ z ⁿ` | — | plane header: ordinal z, n planes in the module |
| `⌗…` | — | hypercube coordinate (n trit glyphs) |
| `⟰ⁿ ⟱ⁿ` | as the callee | call the neighbour up or down axis n |
| `⟲ⁱʲ` | — | rotate axes i and j for the block |
| `⍥ ⟨S ⊸ S'⟩` | `⟨S ŧ… ⊸ ◌S'⟩` | summon by runtime coordinate |
| `⟪ ⟫` | `⟨⊸ ⟦ϟ⟧⟩` | quote (compile time only) |
| `☾` | — | dream definition prefix; `☾ᛞ` is a dream site |
| `ϟ` | — | token type (compile time only) |
| `⸸ᶠ ⸸ⁱ ⸸ᵘ ⸸ᵈ ⸸ᵃ` | — | curses in a signature |
| `⛨ˣ ⦃ ⦄` | — | exorcism block |
| `⛨` (prefix) | — | rite definition (ends a cursed particle) |
| `✧` `✧✧` | — | blessed / doubly blessed definition prefix |
| `⍤⥀` `⍤ᚠ` | — | vow (termination measure) |
| `⚛⸸` | — | cursed particle declaration |
| `⎔⸸ᵘ` | — | FFI binding declared forbidden |

None of these glyphs is used in TRITH.md. `⟪⟫` appears in the s1 sources only as UNHINGED v1 call syntax, which is unrelated.

---

## A.11 Precedent and Study Links

Links marked (searched) were found and checked on 2026-10-28. The others are well-known pages listed from memory.

**Planes (A.1)**

- https://catseye.tc/view/funge-98/doc/funge98.markdown (searched): "In Trefunge-98, the Form Feed (12) character increments the z coordinate and resets the x and y coordinates to zero."
- https://esolangs.org/wiki/Funge-98 (searched)
- https://cliffle.com/esoterica/4dl/ (searched): a 4-D grid shown as 2-D slices.
- https://git.tilde.institute/akkartik/mu/plain/linux/bootstrap/000organization.cc?h=hlt (searched): Mu layers, and tangling with `:(before)`/`:(after)` directives.
- https://en.wikipedia.org/wiki/Literate_programming

**Tesseract (A.2)**

- https://esolangs.org/wiki/Tesseract (searched): runs code on a 2-D representation of a 4-D hypercube (2024).
- https://esolangs.org/wiki/User:Maharba/Hypercube (searched): memory as bits on an infinite-dimensional hypercube.
- https://esolangs.org/wiki/Hcbf (searched)
- https://en.wikipedia.org/wiki/Branch_table

**Dreams (A.3)**

- https://ziggit.dev/t/what-is-the-eval-branch-quota/7852 (searched): Zig's compile-time fuel.
- https://www.scattered-thoughts.net/writing/a-rough-survey-of-compilation-recompilation-and-compile-time-evaluation (searched)
- https://doc.rust-lang.org/reference/procedural-macros.html (token streams in and out)
- https://nim-lang.org/docs/macros.html
- https://infoscience.epfl.ch/record/257176/files/A%20Practical%20Unification%20of%20Multi-stage%20Programming%20and%20Macros.pdf?version=1 (searched)
- https://www.philipzucker.com/notes/Programming/macros-partial-eval/ (searched)
- https://legacy.cs.indiana.edu/~dyb/pubs/tr356-abstract.html (searched): syntactic abstraction in Scheme.
- https://en.wikipedia.org/wiki/Hygienic_macro
- https://downloads.haskell.org/ghc/latest/docs/users_guide/exts/template_haskell.html (stage restriction)

**Curses (A.4)**

- https://arxiv.org/pdf/1406.2061 (searched): Koka, programming with row-polymorphic effect types.
- https://www.microsoft.com/en-us/research/wp-content/uploads/2016/08/algeff-tr-2016-1.pdf (searched): algebraic effects in Koka.
- https://journal.stuffwithstuff.com/2015/02/01/what-color-is-your-function/ (the original essay)
- https://www.tedinski.com/2018/11/13/function-coloring.html (searched)
- https://jerf.org/iri/post/2026/func_args_are_not_colors/ (searched)
- https://doc.rust-lang.org/book/ch20-01-unsafe-rust.html

**Blessings (A.5)**

- https://agda.readthedocs.io/en/v2.6.4/language/termination-checking.html (searched)
- https://lists.chalmers.se/pipermail/agda/2019/010774.html (searched): totality checking in Agda.
- https://arxiv.org/pdf/2407.05715 (searched)
- https://llvm.org/docs/LangRef.html#function-attributes (`memory`, `willreturn`, `nounwind`, `mustprogress`)
- https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html (`pure`, `const`)

**Cursed particles (A.6)**

- https://austral.github.io/tutorial/linear-types (searched)
- https://animaomnium.github.io/what-austral-proves (searched)
- https://tamnd.github.io/brain/research/memory-management/ownership/05_austral_linear/ (searched)
- https://doc.rust-lang.org/reference/attributes/diagnostics.html#the-must_use-attribute
- https://verdagon.dev/blog/higher-raii-7drl (Vale's higher RAII)

**Anti-precedent: why runtime self-modification is out**

- https://esolangs.org/wiki/Malbolge: code that encrypts itself as it runs. Alien because it is broken.
- https://en.wikipedia.org/wiki/W%5EX
