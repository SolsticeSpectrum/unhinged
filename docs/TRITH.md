# Trith — Language Specification (draft 1)

> Successor to UNHINGED (v1). Compiler: `trithc`. Source files: `.trh` (alias: `.ŧ`).

> A language from a species that thinks in data flow, time, evidence and possibility — not in names, sequence and truth.
> Alien on the surface, boring underneath: everything strange is resolved by the compiler.

---

## 0. The Zero-Cost Law

Every feature in this document MUST satisfy one of:

1. **Erased at compile time** (lexer, parser, resolver or type checker only), or
2. **Lowered to a fixed, small number of machine instructions** that a C compiler would also emit for the equivalent C code.

Forbidden in the generated code, ever:

- runtime environments / name lookup (v1 `uh_env_*`)
- a runtime value stack (v1 `uh_stack_*`)
- tagged dynamic values (v1 `UhValue`)
- garbage collection or reference counting
- an interpreter, VM or JIT

If a proposed feature cannot satisfy the law, it is cut, not "optimised later".

Performance target: generated code within **1.5× of `clang -O2`** on the benchmark set (§17).

Every section below ends with a **Cost** line saying where the feature lives.

---

## 1. Source Text

- Files use the extension `.trh`. The compiler also accepts `.ŧ` as an alias. Usage: `trithc main.trh -o main`.

- UTF-8, normalised to **NFC** by the lexer before anything else.
- **ASCII letters are illegal outside string literals.** ASCII digits are illegal everywhere.
- Whitespace separates tokens. The bracket glyphs `⦃ ⦄ ⟨ ⟩ ⟦ ⟧` are self-delimiting and need no whitespace around them.

### 1.1 The Boustrophedon Rule

Lines are read the way an ox ploughs a field: in alternating directions.

- Physical lines are numbered from 1. Blank lines count.
- **Odd lines** are read left to right.
- **Even lines** are read right to left. After the line is tokenised, its token list is reversed and every mirrored pair is swapped: `⦃↔⦄`, `⟨↔⟩`, `⟦↔⟧`, `»↔«`.
- A token is never reversed internally, so a numeral or a string stays intact.
- On an even line, a comment `⍝` covers everything **to its left**.

**Cost:** lexer, one pass per line.

### 1.2 The Ternary Balance Law

The number of tokens in every source file must be divisible by 3.

- Comments do not count.
- The **breath** glyph `⸱` counts as a token and is then discarded.
- An unbalanced file is rejected with the error **imbalance**.

**Cost:** one counter in the lexer.

### 1.3 Comments

A comment runs from `⍝` to the end of the line on odd lines, and from `⍝` to the start of the line on even lines.

---

## 2. Tokens

| Class | Form | Notes |
|---|---|---|
| Function name | run of **Runic** letters (U+16A0–16F8) | |
| Type name | run of **Ogham** letters (U+1681–169A) | user particle types (§8.6) |
| Integer | run of `▽` `○` `△` | balanced ternary, **least-significant trit first** |
| Real | integer part, `⁝`, fraction trits | fraction trits are 3⁻¹, 3⁻², … in order |
| Trit | `⊖` `⦶` `⊕` | minus, zero (unknown), plus |
| String | `»…«` | content stored **reversed**; `↵` inside means newline |
| Index | superscript digits `⁰¹²³⁴⁵⁶⁷⁸⁹` | on `⧗`, `⍿`, `⍤`, `⊙` |
| Charge | superscript `ᵘ ᵈ ˢ ᶜ ᵇ ᵗ` with optional `⁻` and digits | inside `⁽ ⁾` after a type (§3.2) |
| Glyph | any operator in §18 | |
| Breath | `⸱` | counts toward §1.2, then discarded |
| Mark | combining character on a token | registry in §2.1 |

Numeral examples:

- `△` = 1
- `▽△` = 2 (−1 + 3)
- `○△` = 3
- `▽○△` = 8 (−1 + 0 + 9)
- `○△○△` = 30

`»↵dlrow ,olleh«` is the string `"hello, world\n"`.

The grammar is LL(1) over token classes. It has no operator precedence (everything is postfix), no context-sensitive lexing, and no optional separators.

### 2.1 Combining-mark registry

Marks attach to the token's **last base character**. Several marks may stack on one token, in any order, because NFC sorts them.

| Mark | Code point | Attaches to | Meaning | Section |
|---|---|---|---|---|
| ◌́ acute | U+0301 | value token | case role α | §6 |
| ◌̀ grave | U+0300 | value token | case role β | §6 |
| ◌̂ circumflex | U+0302 | value token | case role γ | §6 |
| ◌̈ diaeresis | U+0308 | call | **past tense** | §9.2 |
| ◌̃ tilde | U+0303 | call | **future tense** | §9.2 |
| ◌̵ short stroke | U+0335 | operator | agreement: quantum | §6.1 |
| ◌̰ tilde below | U+0330 | operator | agreement: superposed | §6.1 |
| ◌̱ macron below | U+0331 | operator | agreement: borrowed | §6.1 |

---

## 3. Types

Types are never written inside code bodies. They appear only in signatures (§9), FFI bindings (§14) and particle declarations (§8.6).

| Glyph | Meaning | Lowering | Class |
|---|---|---|---|
| `ŧ` | trit | `i8` ∈ {−1, 0, 1} | classical |
| `ℤ` | integer | `i64` | classical |
| `ℝ` | real | `double` | classical |
| `𝔹` | byte | `i8` | classical |
| `ʃ` | string | `{ptr,len,cap}` | **quantum** |
| `⟦T⟧` | array | `{ptr,len,cap}` | **quantum** |
| Ogham name | particle type (§8.6) | its representation | **quantum** |
| `ψₙT` | superposition of at most n alternatives | `{iN mask, iN phase, T vals[n]}` | superposed |
| `◌T` | possibly-failed T | `{T, i8}` or niche | class of T |
| `⟗T` | shadow (shared borrow) | `ptr`, or by value if small | borrowed |
| `⟖T` | exclusive borrow | `ptr` | borrowed, linear |

- **Classical** values can be copied freely.
- **Quantum** values obey the No-Cloning Rule (§8.1).

Integer arithmetic is binary two's-complement `i64` underneath. Balanced ternary exists only in the lexer and the constant folder. Integer division **rounds to nearest**, which is natural rounding in balanced ternary; it lowers to `sdiv` plus a correction.

### 3.1 Evidentiality

Every value has an **evidential**, which records how the program knows it. This is grammatical evidentiality, as in Quechua or Turkish.

| Evidential | Written | Origin |
|---|---|---|
| witnessed | (unmarked) | computed by this program from witnessed values |
| hearsay | `⸮T` | FFI results declared `⸮`, input, network, files |
| inferred | `⁖T` | the result of collapsing a superposition (`⊙`) |

The rules:

1. **Hearsay is contagious.** Any operation with a hearsay operand produces hearsay.
2. Inferred is contagious in the same way, but it is weaker: inferred combined with hearsay gives hearsay.
3. A parameter declared without a mark accepts **only witnessed** values. Code must declare `⸮` or `⁖` on a parameter to accept those evidentials.
4. **Attestation.** `x ⦃pred⦄ ⊨` runs the predicate on a shadow of x. A result of `⊕` yields x as witnessed `◌T`; anything else fails.
5. Inferred values cannot enter reversible functions (§10), because a collapse cannot be undone.

This is taint tracking: untrusted input cannot reach a syscall or a format string without being attested first.

**Cost:** type-check only. The predicate in `⊨` is the check you would write in C anyway.

### 3.2 Quark charges (units of measure)

Numeric types can carry a **charge**: a product of the six quark flavours u, d, s, c, b and t with integer exponents. For example, `ℤ⁽ᵘ⁾` is an integer of flavour u, and `ℝ⁽ᵘᵈ⁻¹⁾` is a real of flavour u per d. A program can alias a flavour to a real unit by convention (for instance u = metres, d = seconds).

Conservation laws:

- `⊞`, `⊟`, `≶`, `⋏` and `⋎` require **equal** charge. Breaking this is the error **charge violation**.
- `⊠` adds charges. `⊘` and `⊜` subtract charges.
- **Literals are gluons.** A literal has no charge of its own and takes its charge from the expression it is combined with.
- The **neutraliser** `⚇` strips the charge from a value. It is the only explicit escape.

**Cost:** type-check only, as with F# units of measure.

---

## 4. The Stack (compile-time only)

A program is a sequence of operations on a **virtual stack**. The virtual stack exists only inside the compiler (§12). At runtime there is no stack, only SSA registers.

Every block has a **stack effect** `⟨inputs ⊸ outputs⟩`. Effects are inferred for inner blocks and declared for functions. A program whose effects do not agree at a join is rejected, in the same way WebAssembly validation rejects mismatched stacks. This one rule removes the v1 syntax edge cases.

Stack glyphs:

- `⍿ⁿ` picks the n-th entry, where 0 is the top. It copies a classical value and **moves** a quantum one out of the stack.
- `⌁` annihilates the top entry (§8.6).

There is deliberately no `dup`, `swap` or `rot`; use `⍿ⁿ`.

**Cost:** zero.

---

## 5. The Strand: values without names

There are no variables. Instead, each block has a **strand**, an append-only timeline of moments.

- `⧖` pops the top of the stack and binds it as a new moment.
- `⧗ⁿ` is the value bound n moments ago; `⧗⁰` is the most recent.
  - For a classical value, this copies it.
  - For a quantum value, this moves it, and the moment becomes **void**. A void moment still counts for indexing. Reading it is a compile error.

### 5.1 Inside-Out Scope

Scope is inverted compared with ordinary languages:

1. An inner block **cannot see** the moments of the blocks that enclose it. Data enters a block **only through the stack**.
2. Moments bound inside a block **remain visible after** the block, to the code that follows it in the enclosing block. They are appended to the enclosing strand in the order they were bound.
3. For a `⋔`, only the moments bound by **every live face** are exported. Specifically, the export is the longest common prefix of the faces' moment-type sequences, and those moments become `phi` nodes. Everything after that prefix **evaporates**.
4. For a `⥀`, the moments of the **final iteration** are exported after the loop exits. Each iteration starts with an empty view of the previous iterations.

**Cost:** zero. Moments are SSA values, `⧗ⁿ` is a compile-time renaming, and exports are either phis or plain dominance. See de Bruijn indices.

---

## 6. Case Marks: free word order

A value token may carry a mark that names its **role** in the operation that consumes it (marks are listed in §2.1).

When an operation of arity k consumes the top k virtual-stack entries:

1. Each marked entry is assigned to its role.
2. Unmarked entries fill the remaining roles in positional order, with the deepest entry taking the first free role.

A duplicate role or an impossible role is a compile error.

`▽△ △ ⊟` is 2 − 1. `△̀ ▽△́ ⊟` is also 2 − 1.

**Cost:** zero. The compiler permutes the SSA operands.

### 6.1 Agreement (noun classes)

Operators must **agree with the class** of their operands, the way verbs agree with noun classes in Bantu languages.

- The operator token must carry exactly the union of the agreement marks of its operands' classes:
  - `◌̵` if any operand is quantum
  - `◌̰` if any operand is superposed
  - `◌̱` if any operand is borrowed
- Classical operands need no mark.
- A missing or extra mark is a compile error, **disagreement**.

For example, `⎙` applied to a string is written `⎙̵`.

**Cost:** type-check only.

---

## 7. Truth Is Three-Valued

There is no boolean. Comparison is three-way:

- `a b ≶` produces a `ŧ`:
  - `⊖` if a < b
  - `⦶` if a = b
  - `⊕` if a > b
- `⋏` and `⋎` are Kleene AND and OR, which are min and max on trits.
- `⊝` negates. On a trit it is Kleene NOT.

### 7.1 Three-faced selection `⋔`

```
cond ⋔ F⦶ F⊕ F⊖
```

- `⋔` pops a trit and runs one of three faces. The faces are listed **centre-out**: zero, then plus, then minus.
- Writing `⁼` as a face means "the same as the previous face".
- Writing `∅` as a face is allowed only when that face's effect would be the identity.
- All faces must have identical stack effects. Moment export follows §5.1.

**Cost:** one `switch i8` or a select chain, the same as C.

### 7.2 Fixpoint loop `⥀`

```
⥀ ⦃ body ⦄
```

- The body's effect must be `⟨S ⊸ S ŧ⟩`, where S is the loop-carried stack.
- After each iteration the trit is popped:
  - `⊕` repeats the loop.
  - `⦶` exits normally.
  - `⊖` exits **by failure** (§7.3).
- Loop-carried values live on the stack, so they map one-to-one onto `phi` nodes.

**Cost:** an ordinary loop.

### 7.3 Failure `◌`

Failure is a value, inspired by Verse. The following return `◌T`:

- `⊘` and `⊜` with a zero divisor
- an out-of-bounds `⌖`
- `⊙⁰` on a non-singular superposition
- `⊨` when the predicate does not hold
- FFI functions declared with `◌`

Using a `◌T` where a `T` is expected **propagates automatically**: the enclosing function returns failure. This is only legal when that function's declared output is `◌`.

- `↯` fails explicitly.
- `⁇ ⦃ok⦄ ⦃fail⦄` handles a failure. It consumes the `◌T`; the ok face receives the `T`, and the fail face receives nothing.
- If the entry point `ᛟ` fails, the program exits with status 27.

**Cost:** one tag test and a branch, the same as Rust's `?`. The test is elided when success can be proven.

---

## 8. Quantum Layer

### 8.1 No-Cloning Rule (ownership)

A quantum value must be consumed **exactly once**, in one of these ways:

- moved into a call
- observed with `⊙`
- annihilated with `⌁`
- returned

If a quantum value is allowed to fall out of scope instead, the compiler reports a **decoherence leak**.

This is linear typing. Memory is freed at the point of annihilation, with no garbage collector and no reference counting.

**Cost:** zero.

### 8.2 Entanglement (borrowing)

- `⟗` (entangle) pushes a shadow `⟗T` of the top value. A shadow is shared, read-only, classical and copyable.
- `⟖` (exclusive entangle) pushes a `⟖T`, which is read-write and linear.
- While a shadow is alive, the original value cannot be moved, observed or mutated.
- A shadow cannot escape the block that created it. Regions are **lexical blocks**, so no non-lexical lifetime analysis is needed.

**Cost:** a pointer.

### 8.3 Superposition `ψ`

- `a b ⫴` superposes two values of the same type into a `ψ₂T`. Superposing a `ψₙ` with a `ψₘ` gives a `ψₙ₊ₘ`.
- **Lifting.** An operation on superpositions applies to every alternative: `ψₙ ⊞ ψₘ` gives a `ψₙ·ₘ`. A classical operand is broadcast to every alternative.
- **Branching.** `⋔` on a `ψ ŧ` runs **every face whose trit is live**. The face outputs are collected into a superposition.
- **Decoherence cap.** n must be at most 27 (3³), and exceeding it is a compile error. This bounds code size and runtime cost statically.
- **Collapse.** Collapsing a value makes it inferred (§3.1):
  - `⊙⁻` takes the minimum alternative.
  - `⊙⁺` takes the maximum.
  - `⊙⁰` (or bare `⊙`) requires exactly one live alternative and yields `◌⁖T`.
  - Collapsing a quantum ψ annihilates the alternatives that lost.

**Cost:** an N-bit mask plus an N-slot array. Lifted operations become N-wide loops, which LLVM unrolls or vectorises. **When the mask constant-folds to a single state, the ψ is erased** and the code is identical to classical code.

### 8.4 Phase and destructive interference

Every alternative has a **phase**, `+` or `−`.

- `⫴` creates alternatives with phase `+`. `⊛` flips the phase of every alternative in a ψ.
- When two ψ are superposed, **equal values with opposite phase annihilate**, and equal values with the same phase merge into one.
- Lifting multiplies phases (xor of the phase bits).
- Collapse ignores phase. If interference has annihilated every alternative, the ψ is empty and `⊙` fails.

Example: `△ ⧖ ⧗⁰ ⧗⁰ ⫴ ⧗⁰ ⧗⁰ ⫴ ⊛ ⫴` yields an empty ψ.

**Cost:** an N-bit phase mask, and an N×M equality pass at a merge. That pass is constant-folded when the values are known, and it is bounded by the cap at runtime.

### 8.5 Retrocausal post-selection `⟜`

```
ψvalue ⟜ ⦃ predicate ⦄
```

`⟜` keeps only the alternatives for which the predicate yields `⊕`.

**Retrocausality.** When the operand is a strand reference `⧗ⁿ` to a ψ moment, the filter applies to **the moment itself**. Every read of that moment sees the filtered value, *including reads that appear earlier in the source*. The future constrains the past, much like INTERCAL's `COME FROM`.

**Cost:** one mask AND at the definition point. The compiler hoists the filter there. The predicate may depend only on values that are available at that point; anything else is a **causality violation**.

### 8.6 Particles and antiparticles (destructors)

A program declares its own quantum types as **particles**:

```
⚛ ℤ ᚋᚐ ⸫
```

This declares the quantum type ᚋᚐ, represented as an `ℤ` (for example, a file descriptor).

Every particle must have an **antiparticle**: a function named `⌁` followed by the type name.

```
⦃ … ⦄ ⟨ᚋᚐ ⊸⟩ ⌁ᚋᚐ ⸫
```

- `⌁` on a ᚋᚐ calls its antiparticle. For `ʃ` and `⟦T⟧` the antiparticle is built in and frees their storage.
- **Pair annihilation.** If a value created by a **pure** constructor is annihilated without ever being observed, the compiler removes both the creation and the annihilation.

**Cost:** an ordinary call, the same as RAII drop. Pair annihilation is dead-code elimination.

---

## 9. Functions

```
⦃ body ⦄ ⟨inputs ⊸ outputs⟩ ᚠᚢ ⸫
```

- The body comes first, then the signature, then the name, then the terminator `⸫`.
- Signatures use `⊸`, linear implication.
- A call is written as just the function's name.
- In a signature, inputs are listed from the deepest entry to the top of the stack.
- The entry point is `ᛟ`, with signature `⟨⊸⟩` or `⟨⊸ ◌⟩`.
- Recursion is allowed. Calls in tail position are emitted as `musttail`.

**Cost:** an ordinary C-ABI function. Multiple outputs are returned as a struct or through an sret pointer.

### 9.1 Call by shape

A signature written in call position calls **the unique function that has that signature**. For example, `⟨ℤ ℤ ⊸ ℤ⟩` as a call is a call to whichever function has that signature.

If two functions share the shape, the error is **shape collision**. Adding a function can therefore break call sites anywhere in the program. That is intended.

**Cost:** resolver only.

### 9.2 Tense

Calls are conjugated with marks from §2.1:

| Tense | Mark | Meaning |
|---|---|---|
| present | none | an ordinary call |
| past | ◌̈ (`ᚠ̈`) | **already happened**: evaluated at compile time and replaced by its result |
| future | ◌̃ (`ᚠ̃`) | **will happen**: moved to the end of the enclosing block, with arguments captured at the call point |

Rules for the past tense:

- The callee must be pure.
- Every argument must be known at compile time. Otherwise the error is **"the past cannot depend on the present"**.

Rules for the future tense:

- The callee's effect must have no outputs.
- Future calls run in reverse order of appearance, last in first out, like Go's `defer`.

**Cost:** a compile-time evaluator for pure code, which the constant folder needs anyway. Future calls are a code move.

### 9.3 Scattered bodies

A function may be written as **fragments** spread anywhere in the module, in any order:

```
⦃ part ⦄ [signature] ᚠ ⸾ ordinal ⸫
```

- The ordinal is a balanced-ternary integer, so it can be negative, which places a fragment before fragment ○.
- The fragments are concatenated in ordinal order to form the body. Each fragment is a balanced block, but the stack effect flows across fragments.
- **Exactly one** fragment carries the signature, and it can be any of them.
- A function written as a single, unfragmented definition is simply the case with only fragment ○.

**Cost:** resolver only. This is the "tangle" step of literate programming.

---

## 10. Reversible Functions `⇋`

Inspired by Janus.

```
⇋ ⦃ body ⦄ ⟨S ⊸ S⟩ ᚱ ⸫
```

The body may contain only invertible operations:

- `⊞` and `⊟` by a value that is not itself being updated
- `⩡`
- `⊝`
- moves with `⍿ⁿ`
- calls to other `⇋` functions
- `⋔⇋`, a selection whose faces are reversible and which ends with an exit-assertion block

Inferred values (§3.1) are rejected.

`⇜ᚱ` calls the **inverse** of ᚱ.

**Cost:** the compiler generates the inverse function at compile time.

---

## 11. Arrays and Strings: centre-indexed

- `⟦ a b c ⟧` is an array literal; the elements form a block.
- **Index 0 is the centre**, at position ⌊len/2⌋. Negative indices go left and positive indices go right.
- `arr⟗ i ⌖̱` reads an element and yields `◌T`. The mark is required by agreement, because the array operand is borrowed.
- `arr⟖ i v ⍈̱` writes an element and yields `◌`.
- `⍴̱` returns the length as an `ℤ`.
- `arr v ⍆̵` appends: it consumes the array and returns it.
- `ʃ` is `⟦𝔹⟧` holding UTF-8 bytes, and it is indexed the same way.

**Cost:** `base + len/2 + i`, so one more add than C. The bounds check is elided whenever it can be proven safe.

---

## 12. Prayers `⍤`

```
⍤ⁿ ⦃ pred ⦄
```

A prayer passes copies or shadows of the top n stack entries to the predicate. The predicate must yield `ŧ`.

| What the compiler finds | Result |
|---|---|
| proves `⊕` | the prayer is erased |
| proves `⊖` | compile error: **blasphemy** |
| proves `⦶` | compile error: **doubt** |
| cannot decide | debug builds trap at runtime; release builds emit `llvm.assume`, as C++23 `[[assume]]` does |

**Cost:** nothing in release builds, where the prayer only gives the optimiser more facts.

---

## 13. Compiler Pipeline

```
lex       NFC → per-line tokenise → balance law → Boustrophedon reversal → token stream
parse     LL(1) → item tree (blocks, signatures, names, fragments, particles)
resolve   tangle fragments; strand ⧗ⁿ → moment ids with inside-out export rules;
          case marks → operand permutations; names and shapes → functions
check     stack-effect inference (WebAssembly-style validation); class and linearity;
          agreement marks; evidentials; charges; regions for ⟗/⟖; ψ cap;
          causality for ⟜; reversibility; tense legality
eval      evaluate past-tense calls (pure compile-time interpreter over checked IR)
lower     ψ → mask + phase + slots; ◌ → tag + branch; ⇋ → generate inverses;
          ⋔ → switch; future calls → block exits; prayers → assume/trap
ssa       abstract interpretation of the virtual stack: each push is an SSA value,
          each operation an instruction, each join a phi (Braun et al. on-the-fly SSA)
emit      typed LLVM IR text (i8/i64/double/ptr) → `clang -O2` with the runtime → native binary
```

Note: the `eval` stage is the only interpreter in the toolchain. It runs at compile time, never in the output.

### 13.1 Stack-to-SSA (the core speed fix)

1. Walk each block with a compile-time stack of SSA names, not values.
2. `a b ⊞` pushes `%1`, pushes `%2`, pops both, emits `%3 = add i64 %1, %2`, and pushes `%3`.
3. At a `⋔` or `⥀` join, the stack depth is guaranteed to match by the check stage. Each slot whose names differ between predecessors becomes a `phi`. Exported moments are handled the same way.
4. The result is the IR that Clang emits for the equivalent C. LLVM sees no trace of the language.

### 13.2 Backend

- **Primary: LLVM IR**, already proven in v1. Always use `-O2`; v1 used `llc -O0` for user code.
- **Optional: QBE**, which is small and vendorable and keeps the toolchain self-contained.

---

## 14. Runtime and FFI

The runtime is a tiny C file, targeted at under 500 lines:

- `_start` / `main` glue and the exit status on failure
- `uh_alloc` / `uh_free` (malloc or an arena)
- syscall-level I/O used by `⎙`

It has no environment, no value stack and no tagged values.

FFI binding:

```
⎔ »stup« ⟨⟗ʃ ⊸ ℤ⟩ ᛈ ⸫
⎔ »daer« ⟨ℤ ⟖ʃ ⊸ ⸮◌ℤ⟩ ᛞ ⸫
```

- The first line binds the C function `puts` as ᛈ.
- The second binds `read` as ᛞ. Its result is declared hearsay and possibly failed.
- FFI results that come from the outside world must be declared `⸮`.

The v1 standard library (HTTP, SMTP, WebSocket, SHA-256, AES, JSON) is ported as FFI-bound modules.

---

## 15. Examples

### 15.1 Hello, world

This is a complete, balanced file of 9 tokens.

```
⦃ »↵dlrow ,olleh« ⎙̵ ⦄ ⟨⊸⟩ ᛟ ⸫
```

`⎙` carries the quantum agreement mark because the string is quantum.

### 15.2 Fibonacci: logical order

This is how the program reads before the Boustrophedon Rule is applied.

```
⦃
  ⍿⁰ ▽△ ≶ ⋔
    ⦃ ⧖ ⧗⁰ △ ⊟ ᚠ ⧗⁰ ▽△ ⊟ ᚠ ⊞ ⦄
    ⁼
    ∅
⦄ ⟨ℤ ⊸ ℤ⟩ ᚠ ⸫

⦃ ▽○△ ᚠ ⎙ ⦄ ⟨⊸⟩ ᛟ ⸫ ⸱ ⸱
```

How it runs:

1. n arrives on the stack. `⍿⁰` copies n, and `▽△ ≶` compares the copy with 2.
2. Because of inside-out scope, a face cannot see outer moments. The zero face therefore binds n itself with `⧖`, then computes fib(n−1) + fib(n−2).
3. The plus face is `⁼`, the same as the zero face.
4. The minus face is `∅`, the identity, so it leaves n on the stack.
5. No moment is common to all three faces, so nothing is exported.
6. The entry point prints fib(8) = 21. The file has 37 tokens, so two breaths bring it to 39.

### 15.3 Fibonacci: as it is actually written on disk

```
⦃
⋔ ≶ ▽△ ⍿⁰
    ⦃ ⧖ ⧗⁰ △ ⊟ ᚠ ⧗⁰ ▽△ ⊟ ᚠ ⊞ ⦄
⁼
    ∅
⸫ ᚠ ⟨ℤ ⊸ ℤ⟩ ⦃

⸱ ⸱ ⸫ ᛟ ⟨⊸⟩ ⦃ ⎙ ᚠ ▽○△ ⦄
```

Yes, on disk the function *ends* with `⦃` and the entry point *starts* with breaths.

It compiles to the same LLVM IR as:

```c
int64_t fib(int64_t n){ return n<2 ? n : fib(n-1)+fib(n-2); }
```

### 15.4 Past tense: fib computed at compile time

```
⦃ ▽○△ ᚠ̈ ⎙ ⦄ ⟨⊸⟩ ᛟ ⸫ ⸱ ⸱
```

The binary contains only `print(21)`. The line has 10 tokens, so two breaths bring it to 12. (This snippet assumes ᚠ from §15.2 is in the same module.)

### 15.5 Superposition, interference and retrocausality

This is a complete, balanced file of 27 tokens.

```
⦃ ⊕ ⊖ ⫴ ⧖ ⧗⁰ ⟜̰ ⦃ ⦶ ≶ ⦄ ⧗⁰ ⊙̰⁰ ⁇ ⦃ ⎙ ⦄ ⦃ ⦄ ⦄ ⟨⊸⟩ ᛟ ⸫ ⸱ ⸱
```

1. It superposes {+, −} and binds the result.
2. It post-selects the alternatives greater than 0, leaving {+}. Because the operand is a strand reference, this is retrocausal: the moment itself is filtered.
3. It collapses the result, which becomes inferred, and prints 1.
4. The mask constant-folds to a single state, so the ψ is erased and there is no runtime cost.

### 15.6 Everything at once (a fragment of a file)

```
⍝ fragment +1, written first in the file: divides distance by time
⦃ ⧗⁰ ⧗¹ ⊘ ⦄ ⟨ℤ⁽ᵘ⁾ ℤ⁽ᵈ⁾ ⊸ ◌ℤ⁽ᵘᵈ⁻¹⁾⟩ ᚹ ⸾ △ ⸫

⍝ entry point: call by shape, a prayer, a deferred goodbye
⦃
  ○△○△ ○△ ⍤¹ ⦃ ○ ≶ ⦄
  ⟨ℤ⁽ᵘ⁾ ℤ⁽ᵈ⁾ ⊸ ◌ℤ⁽ᵘᵈ⁻¹⁾⟩ ⁇ ⦃ ⎙ ⦄ ⦃ ⦄
  ᛒ̃
⦄ ⟨⊸⟩ ᛟ ⸫

⍝ fragment −1, written last in the file: binds time, then distance
⦃ ⧖ ⧖ ⦄ ᚹ ⸾ ▽ ⸫
```

How it works:

- The fragments tangle into the body of ᚹ: bind time, bind distance, then divide distance by time. The charges ᵘ and ᵈ (metres and seconds, say) are checked.
- In the entry point, the literals 30 and 3 are gluons, so they adopt their charges from the signature.
- The prayer says "time > 0". The compiler proves it, so the prayer is erased.
- The shape of the signature calls ᚹ, because ᚹ is the only function with that shape.
- The result is printed: 10.
- `ᛒ̃` is a future-tense call to some goodbye function, which runs at the end of the block.
- This listing is in **logical order**. Written to disk as is, line 4 (an even line) would be read right to left, so its comment would hide the code after `⍝`. `trithc --plough` produces the real file and adds the one breath it needs (50 tokens → 51); see `trith/tests/plough/everything.out`.

---

## 16. Open Questions

### 16.1 Decisions taken by the s1 lexer and parser (milestone 1)

These were ambiguous in draft 1. The s1 compiler implements them as follows; change them here first if they are wrong.

- **What a token is.** A token is a whitespace-delimited chunk. The brackets `⦃ ⦄ ⟨ ⟩ ⟦ ⟧` and string literals are self-delimiting. Everything else written without spaces is one token, so `⸮◌ℤ`, `ℤ⁽ᵘᵈ⁻¹⁾`, `⧗⁰`, `⊙̰⁰`, `⌁ᚋᚐ` and `⋔⇋` are one token each. A type prefix written alone (`◌` before `⟦`, or a bare `◌` output) is its own token.
- **Strings on even lines.** §1.1 mirrors `»↔«`, so on an even line a string is written `«…»`. In reading order the opener is always `»`. The content is never reversed by the line rule; it is only stored reversed (§2). Reversal is by grapheme cluster, so a combining mark stays on its base character.
- **Comments on even lines** cover everything to the left of the `⍝`, so a full-line comment on an even line is written `text ⍝`.
- **Marks** may appear anywhere after the first base character of a token and apply to the whole token. Marks written directly after a string's last delimiter belong to the string. Case marks attach to literals, `⧗ⁿ` and `⍿ⁿ`; tense marks attach to calls; agreement marks attach to operator glyphs. A token takes at most one case mark and one tense mark. Unknown combining marks are an error.
- **NFC.** s1 canonicalises marks by sorting them per token, which is all NFC changes for code tokens. Full NFC composition inside strings is not applied yet.
- **Superscript indices** are decimal (open question below still stands). `⊙⁻` and `⊙⁺` take `⁻`/`⁺` as their index.
- **Fragments.** A definition without `⸾` is fragment `○`. It may omit the signature when another fragment of the same function carries it. Two definitions without `⸾` for the same name are "defined twice".
- **Numerals** are exact up to 2⁵³ in s1, because s1 runs on UNHINGED doubles.
- **Check pass (milestone 2).** These are also choices the spec left open:
  - Agreement applies to operator glyphs that consume operands, including `⌁`, `⊨` and `⟜`. It does not apply to the stack glyphs `⧖ ⧗ ⍿ ⟗ ⟖`, to `↯`, or to the control forms `⋔ ⥀ ⁇ ⍤`. This matches every example in §15.
  - Case roles (§6) apply to glyph operators and to calls.
  - A shadow is alive while it is on the stack or bound in a moment of the current strand. Consuming a shadow (for example with `⍴`, `⌖` or `⍈`) releases the original. Shadows cannot leave the block that created them, cannot be exported as moments, and cannot be returned.
  - `⍿ⁿ` on a quantum value moves it to the top. `⧗ⁿ` on a quantum moment moves it out and leaves the moment void.
  - A `⥀` body may not leave a quantum moment unconsumed, because every earlier iteration would leak it.
  - Exported moments (§5.1 rule 3) must have the same void status in every live face.
  - A face or arm that ends in `↯` is dead and does not take part in the join. Nothing may follow `↯` in its block.
  - A function may fail when its single output is `◌T` or a bare `◌`. A value of type T then satisfies an output of `◌T`.
  - The `⊨` predicate, prayers and the `⋔⇋` exit assertion see copies of classical values and `⟗` shadows of quantum ones, and must leave exactly `[ŧ]`.
  - Inside its own antiparticle `⌁T`, a particle of type T is its representation type. Particles are created by FFI functions that return T. There is no other constructor yet (open question).
  - Indexing an array of quantum values, and storing over a quantum element, are rejected until the spec says how they avoid cloning or dropping.
  - Evidentials and charges are parsed but not yet checked (milestone 4). `⫴ ⊛ ⊙ ⟜` and `⋔` on a ψ are rejected as "not implemented yet" (milestone 5). Past-tense calls are typed like present ones until the evaluator exists.
- **Tooling.** `trithc --plough` turns a file written in logical order (every line left to right) into on-disk order and pads it with breaths. `trithc --unplough` does the reverse, for reading.

- Mutable arrays inside `⥀`: keep threading a `⟖` through the loop stack, or allow region-scoped exclusive moments?
- Should the ψ cap be lower than 27 for quantum alternatives, to bound the drop logic?
- Generics: monomorphised, stack-polymorphic signatures (Kitten-style row variables), or none in Trith 1.0?
- Should superscript indices be balanced ternary for consistency (`⧗▽△` instead of `⧗²`)?
- Does agreement apply to `⧗ⁿ` reads, or only to operators?
- Should call-by-shape also consider evidentials and charges when matching signatures? This document assumes yes.
- Should scattered fragments be allowed across files within a module?

---

## 17. Bootstrap and Milestones

| Stage | Written in | Compiled by | Output |
|---|---|---|---|
| s0 | Rust (the v1 bootstrap, frozen) | cargo | v1 compiler |
| s1 | **UNHINGED** (v1) | s0 | `trithc` (runs) |
| s2 | **Trith** | s1 | `trithc`, self-hosted |
| s3 | Trith | s2 | must be byte-identical to s2's output (fixpoint) |

Milestones:

1. Lexer and parser for Trith, written in UNHINGED. Golden tests cover the Boustrophedon Rule, the Balance Law, the mark registry, and fragments. **Done:** `trith/src/`, tests in `trith/tests/`, `make trith-test`.
2. Check pass: effects, linearity, agreement. **Done:** `trith/src/check.uh`, `trithc --check`, tests in `trith/tests/check*/`.
3. Stack-to-SSA and LLVM emission for ℤ, ŧ, `⋔`, `⥀`, functions and inside-out scope. **Benchmark gate here.**
4. ◌, arrays, strings, FFI, particles, evidentials, charges.
5. ψ with phases, `⟜`, `⇋`, tense, prayers, call by shape.
6. Rewrite the compiler in Trith (s2), then pass the fixpoint (s3).
7. Port the standard library modules.

Benchmarks, each of which must run within 1.5× of `clang -O2`:

- fib(35), recursive
- n-body, 1M steps
- Game of Life, 512² grid, 1000 generations
- SHA-256 of 100 MB
- the compile time of the compiler itself

---

## 18. Glyph Table

| Glyph | Effect | Meaning |
|---|---|---|
| `⦃ ⦄` | — | block |
| `⟨ ⊸ ⟩` | — | signature, or a call by shape in call position |
| `⸫` | — | item terminator |
| `⸾` | — | fragment ordinal |
| `⸱` | — | breath (balance padding) |
| `⍝` | — | comment |
| `⧖` | `⟨T ⊸⟩` | bind a moment |
| `⧗ⁿ` | `⟨⊸ T⟩` | read the moment n ago |
| `⍿ⁿ` | `⟨… ⊸ … T⟩` | pick or move from depth n |
| `⌁` | `⟨T ⊸⟩` | annihilate (runs the antiparticle) |
| `⊞ ⊟ ⊠` | `⟨ℤ ℤ ⊸ ℤ⟩` | add, subtract, multiply |
| `⊘ ⊜` | `⟨ℤ ℤ ⊸ ◌ℤ⟩` | divide (rounds to nearest), modulo |
| `⊝` | `⟨T ⊸ T⟩` | negate, or Kleene NOT |
| `≶` | `⟨T T ⊸ ŧ⟩` | three-way compare |
| `⋏ ⋎` | `⟨ŧ ŧ ⊸ ŧ⟩` | Kleene AND, OR |
| `⋒ ⋓ ⩡` | `⟨ℤ ℤ ⊸ ℤ⟩` | bitwise AND, OR, XOR |
| `≪ ≫` | `⟨ℤ ℤ ⊸ ℤ⟩` | shift left, shift right |
| `⚇` | `⟨T⁽q⁾ ⊸ T⟩` | neutralise a charge |
| `⋔` | `⟨S ŧ ⊸ S'⟩` | three-faced select |
| `⁼` | — | repeat the previous face |
| `∅` | — | identity face |
| `⥀` | `⟨S ⊸ S⟩` | fixpoint loop |
| `↯` | — | fail |
| `⁇` | `⟨◌T ⊸ …⟩` | handle a failure |
| `⊨` | `⟨T ⊸ ◌T⟩` | attest (makes a value witnessed) |
| `⫴` | `⟨T T ⊸ ψ₂T⟩` | superpose |
| `⊛` | `⟨ψT ⊸ ψT⟩` | flip phase |
| `⊙⁻ ⊙⁺ ⊙⁰` | `⟨ψT ⊸ ⁖T / ◌⁖T⟩` | collapse |
| `⟜` | `⟨ψT ⊸ ψT⟩` | post-select (retrocausal) |
| `⟗ ⟖` | `⟨T ⊸ T ⟗T⟩` | entangle (shared / exclusive borrow) |
| `⟦ ⟧` | — | array literal |
| `⌖` | `⟨⟗⟦T⟧ ℤ ⊸ ◌T⟩` | index (centre-based) |
| `⍈` | `⟨⟖⟦T⟧ ℤ T ⊸ ◌⟩` | store |
| `⍴` | `⟨⟗⟦T⟧ ⊸ ℤ⟩` | length |
| `⍆` | `⟨⟦T⟧ T ⊸ ⟦T⟧⟩` | append |
| `⇋` | — | define a reversible function |
| `⇜` | — | call the inverse |
| `⚛` | — | declare a particle type |
| `⍤ⁿ` | — | prayer (assert or assume) |
| `⎔` | — | FFI binding |
| `⎙` | `⟨ʃ ⊸⟩` / `⟨ℤ ⊸⟩` | print |

---

## 19. Precedent and Study Links

Read the links for a section before implementing it.

**Stack-to-SSA and typed stacks (§4, §13)**

- https://github.com/playXE/stack2ssa
- https://webassembly.github.io/spec/core/appendix/algorithm.html — the validation algorithm, which is the model for stack-effect checking
- https://concatenative.org/wiki/edit/Factor/Optimization
- https://factorcode.org
- https://kittenlang.org
- https://dev.to/viz-x/kitten-a-typed-concatenative-language-inspired-by-joy-and-rust-fdg
- "Simple and Efficient Construction of Static Single Assignment Form", Braun et al., CC 2013 (search for the title)
- https://discourse.llvm.org/t/rfc-new-stack-dialect/78722
- https://arxiv.org/pdf/2609.23759 (RPyForth)

**Backends (§13.2)**

- https://llvm.org/docs/LangRef.html
- https://c9x.me/compile/ (QBE)
- https://briancallahan.net/blog/20210829.html

**Ternary logic (§3, §7)**

- https://en.wikipedia.org/wiki/Balanced_ternary
- https://en.wikipedia.org/wiki/Three-valued_logic
- https://en.wikipedia.org/wiki/Setun
- https://wiki.xxiivv.com/site/ternary_computing.html
- https://www.rosettacode.org/wiki/Ternary_logic
- https://metacpan.org/pod/Math::Logic::Ternary
- https://esolangs.org/wiki/Malbolge — an anti-example: alien because it is broken

**Failure as a value, nondeterminism (§7.3, §8.3)**

- "The Verse Calculus: a Core Calculus for Deterministic Functional Logic Programming", ICFP 2023 (search for the title)
- https://en.wikipedia.org/wiki/Icon_(programming_language)
- https://www.curry-lang.org

**Quantum, linearity, ownership (§8)**

- https://silq.ethz.ch
- https://pldi20.sigplan.org/details/pldi-2020-papers/47/Silq-A-High-Level-Quantum-Language-with-Safe-Uncomputation-and-Intuitive-Semantics
- https://arxiv.org/html/2409.10231v2
- https://en.wikipedia.org/wiki/Uniqueness_type (Clean, Mercury)
- https://doc.rust-lang.org/nomicon/ownership.html
- https://en.wikipedia.org/wiki/Double-slit_experiment (interference, §8.4)
- https://en.cppreference.com/w/cpp/language/raii (antiparticles, §8.6)

**Reversibility (§10)**

- https://en.wikipedia.org/wiki/Janus_(time-reversible_computing_programming_language)
- https://researchprofiles.ku.dk/da/publications/principles-of-a-reversible-programming-language/
- https://vikraman.org/files/reversible-languages.pdf

**Grammar borrowed from natural languages (§3.1, §6.1, §9.2)**

- https://en.wikipedia.org/wiki/Evidentiality
- https://en.wikipedia.org/wiki/Noun_class
- https://en.wikipedia.org/wiki/Grammatical_tense
- https://en.wikipedia.org/wiki/Taint_checking

**Units, tense lowering, assertions (§3.2, §9.2, §12)**

- https://learn.microsoft.com/en-us/dotnet/fsharp/language-reference/units-of-measure
- https://en.cppreference.com/w/cpp/language/constexpr
- https://go.dev/ref/spec#Defer_statements
- https://en.cppreference.com/w/cpp/language/attributes/assume

**Names, reading order, retrocausality, scattering (§1, §5, §8.5, §9.3)**

- https://en.wikipedia.org/wiki/De_Bruijn_index
- https://en.wikipedia.org/wiki/Boustrophedon
- https://en.wikipedia.org/wiki/COMEFROM
- https://en.wikipedia.org/wiki/INTERCAL
- https://en.wikipedia.org/wiki/Literate_programming (tangle, §9.3)

**Verified precedents for the draft-1 ideas (searched 2026-10-27)**

- Evidentiality (§3.1): Sigil has a lattice-ordered evidence system with Known `!`, Uncertain `?`, Reported `~` and Paradox `‽`. Network results are Reported; values are promoted with `validate`/`verify`; public functions that return non-Known data must be annotated. This is the closest prior art; study the type checker.
  - https://sigil-lang.com
  - https://github.com/Daemoniorum-LLC/sigil-lang
  - https://docs.rs/sigil-parser/0.3.0/src/sigil_parser/typeck.rs.html
  - Linguistic background: https://www.sas.rochester.edu/lin/sites/asudeh/pdf/lfg2017-asudeh-toivonen.pdf
- Agreement and morphology as semantics (§6.1): Inflexión (2026). Singular/plural article–noun agreement selects scalar vs. collection behaviour, and mood, aspect and clitic order change meaning.
  - https://esolangs.org/wiki/Inflexión
- Tense (§9.2): Past Tense, a joke esolang with no interpreter, because running a program would bring it back into the present. It is precedent for the concept only; the compile-time evaluation semantics in this spec are new.
  - https://esolangs.org/wiki/Past_Tense
  - "Multiple tense computer programming" (search for the title)
- Call by shape (§9.1): Unison's type-directed name resolution. Unison picks the unique definition whose type matches and errors on zero or several matches; this spec drops the name entirely. See also the Haskell TDNR proposal and TypeSearch.
  - https://www.unison-lang.org/docs/language-reference/_type-directed-name-resolution
  - https://mail.haskell.org/pipermail/haskell-cafe/2012-January/098964.html
  - https://eprints.ost.ch/id/eprint/1196/
- Interference (§8.4): "Quantum Programming Without the Quantum Physics" (Jun Inoue) presents quantum programs as probabilistic programs with negative weights. Worlds that converge on the same state add their amplitudes, opposite signs cancel, reversibility is forced by unitarity, and measurement or discarding destroys interference. This is the closest model for phase in §8.4.
  - https://arxiv.org/pdf/2408.16234
  - Bounded classical simulation: https://pldi24.sigplan.org/details/wqs-2024-papers/14/Classical-Simulation-of-Quantum-Circuits-with-Partial-Interference-Effects
- Structural source-code laws (§1.2): Betrothed requires an even number of lines read in pairs whose lengths must be betrothed numbers or twin primes. It is much harsher than the Balance Law.
  - https://github.com/ConorOBrien-Foxx/Betrothed
- Boustrophedon (§1.1): no esolang with alternating-direction lines was found; this appears original. Related: the `boust` text filter and Eric Lippert's essay.
  - https://www.openbsdhandbook.com/packages/current/textproc/boust/
  - https://docs.microsoft.com/en-us/archive/blogs/ericlippert/five-dollar-words-for-programmers-part-four-boustrophedonic
- Inside-out scope (§5.1): no direct precedent was found. The nearest relative is dynamic scoping, which is a different design; the closest code-generation analogue is SSA dominance.
  - https://courses.cs.washington.edu/courses/cse341/18sp/general-concepts/scoping.html

**Context**

- https://ar5iv.labs.arxiv.org/html/2505.15327 (Let's Take Esoteric Programming Languages Seriously)
- https://en.wikipedia.org/wiki/Esoteric_programming_language
