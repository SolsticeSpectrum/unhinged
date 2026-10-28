# Trith — Language Specification (draft 1)

> The language of this repository. It succeeds UNHINGED (v1), which survives only to bootstrap the first compiler (`unhinged/`). Compilers: `trithc` (s1, in UNHINGED) and `s2c` (s2, in Trith). Source files: `.trh` (alias: `.ŧ`).

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
| ◌̵ short stroke | U+0335 | operator, `⧗ⁿ` | agreement: quantum | §6.1 |
| ◌̰ tilde below | U+0330 | operator, `⧗ⁿ` | agreement: superposed | §6.1 |
| ◌̱ macron below | U+0331 | operator, `⧗ⁿ` | agreement: borrowed | §6.1 |

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
   - The exception is **borrowed moments** (region-scoped borrows). A `⧗ⁿ` whose n runs past the block's own moments counts on through the strands of the enclosing blocks, innermost first. If it lands on a `⟗` or `⟖` moment, it reads it, marked `⧗̱ⁿ` (§6.1). Any other value is an error.
   - A `⟗` read this way is copied. A `⟖` is **lent**: the read gives a fresh `⟖` that must be used up inside the reading block, and the moment stays bound. Only one `⟖` of a value may be live at a time.
   - So a loop can write into an array without carrying the array through its stack:

     ```
     ⟖ ⧖  ○ ⥀ ⦃ ⧖ ⧗̱¹ ⧗⁰ ⧗⁰ ⍈̱ ⁇ ⦃ ⦄ ⦃ ⦄  ⧗⁰ △ ⊞ ○△ ⍿¹ ≶ ⦄
     ```

     Here `⧗̱¹` inside the body reaches past the body's one moment to the `⟖` bound before the loop.
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
- A moment read `⧗ⁿ` agrees in the same way with the class of the value it reads. Reading a string moves it, so it is written `⧗̵ⁿ`; a shadow is read `⧗̱ⁿ`, a ψ `⧗̰ⁿ`, and an ℤ plain `⧗ⁿ`. A read then shows whether it moves, borrows or copies without looking back at the binding. `⍿ⁿ` takes no mark.

For example, `⎙` applied to a string is written `⎙̵`, and `»ih« ⧖ ⧗̵⁰ ⎙̵` prints a string read back from a moment.

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
- A shadow bound as a moment is visible to the blocks nested inside its region (§5.1). An inner block borrows a `⟖` moment for itself, and that borrow cannot leave the inner block.
- Annihilating a `⟖` (`⌁̱`) ends the borrow; the value it shadows stays alive.

**Cost:** a pointer.

### 8.3 Superposition `ψ`

- `a b ⫴` superposes two values of the same type into a `ψ₂T`. Superposing a `ψₙ` with a `ψₘ` gives a `ψₙ₊ₘ`.
- **Lifting.** An operation on superpositions applies to every alternative: `ψₙ ⊞ ψₘ` gives a `ψₙ·ₘ`. A classical operand is broadcast to every alternative.
- **Branching.** `⋔` on a `ψ ŧ` runs **every face whose trit is live**. The face outputs are collected into a superposition.
- **Decoherence cap.** n must be at most 27 (3³), and exceeding it is a compile error. A superposition of quantum values (strings, arrays, particles) holds at most 9 (3²), because every alternative needs its own drop path. This bounds code size and runtime cost statically.
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

### 9.4 Type variables

A signature may use the type variables `α β γ δ ε ζ η θ`, each standing for one classical type: `ℤ`, `ℝ`, `ŧ` or `𝔹`.

```
⦃ ⧖ ⧖ ⧗⁰ ⧗¹ ⦄ ⟨α β ⊸ β α⟩ ᚢ ⸫
⦃ ⌖̱ ⦄ ⟨⟗⟦α⟧ ℤ ⊸ ◌α⟩ ᚣ ⸫
```

- A call fixes each variable from the types of its arguments: `△ ⊕ ᚢ` calls `ᚢ[ℤ ŧ]`, and an array of ℝ gives `ᚣ[ℝ]`. One variable stands for one type throughout the signature, and charges stay with it (`α⁽ᵘ⁾`).
- Every variable must appear in an input, so a call can fix it. A variable that cannot be fixed (a string where `α` stands) is an error at the call.
- A generic function is checked and compiled **once per instance**, as the calls make them, like a template. Its body is checked for each instance, so an error found there names the instance and where it was first called. A generic function that is never called is not checked at all.
- Variables range over classical types only, so agreement marks (§6.1) mean the same in every instance.
- FFI bindings and reversible functions cannot be generic.

**Cost:** zero. Each instance is an ordinary function, named `ᚢ[ℤ ŧ]` in traces and in the IR.

### 9.5 Quotations

A block `⦃ … ⦄` inside a body that is not the predicate of a `⊨` is a **quotation**: a value that stands for its code. `⍎` applies the quotation on top of the stack to the stack below it.

```
▽△ ○△ ⦃ ⊠ ⦄ ⍎ ⎙                                 ⍝ 6
⦃ ⍎ ⧗⁰ ⍎ ⧗⁰ ⧖ ⦄ ⟨ρ ⟨ρ ⊸ ρ⟩ ⊸ ρ⟩ ᚡᚠ ⸫             ⍝ apply f two times
⦃ … ⦄ ⟨⟗⟦α⟧ α ⟨α α ⊸ α⟩ ⊸ α⟩ ᚡᚤ ⸫               ⍝ a fold
```

- A quotation is classical, so it can be copied, bound as a moment, read more than once and passed to a function. Its type names its block (`⦃21:7⦄`, the position of the `⦃` on disk), so two different blocks never have the same type. A function cannot return one, and one left on the stack at the end of a body is an error.
- The body of a quotation sees **no moments** from outside it, not even borrowed ones (§5.1). It gets everything it uses from the stack, where `⍎` finds it.
- A quotation's type is its **effect**, inferred from its body: `⦃ ⊠ ⦄` is `⟨ℤ ℤ ⊸ ℤ⟩`. The effect counts only what the body touches; what lies under that passes through untouched.
- A function takes a quotation through a nested signature, `⟨ℤ ⊸ ⟨ℤ ⊸ ℤ⟩ ℤ⟩`. A quotation fits a parameter when its effect, widened by values that pass through, is the parameter's effect: `⦃ ⊞ ⦄` fits `⟨ℤ ℤ ⊸ ℤ⟩` and also `⟨ℤ ℤ ℤ ⊸ ℤ ℤ⟩`. Otherwise the error is **"the quotation has effect H, but ᚠ wants W"**.
- **Row variables** `ρ` and `σ` stand for any run of stack entries, so `⟨ρ ⊸ ρ⟩` is "whatever the quotation does to the stack". A row variable comes first in an effect, at most one per side. A call fixes it from the quotation passed and the entries under the arguments, and binds type variables (§9.4) inside a nested signature too, so `ᚡᚤ` over `⟦ℝ⟧` with `⦃ ⊠ ⦄` is `ᚡᚤ[ℝ]`.
- A quotation is a compile-time value. A function that takes one is checked and compiled **once per call site that passes a different quotation**, with the quotation's body inlined at each `⍎`. Its instances are named `ᚡᚠ[(ℤ ℤ) ⦃12:7⦄]`, after the row types and the line and column of each quotation's `⦃`.

**Cost:** zero. A quotation has no run-time representation; every `⍎` is the quotation's code, inlined.

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

The v1 standard library (HTTP, SMTP, WebSocket, SHA-256, AES, JSON) is ported as FFI-bound modules: `trith/lib/X.c` with its prototypes in `X.h`, which a program binds with `⎔` and builds with `--include trith/lib/X.h --link trith/lib/X.c`. `--link -lNAME` links a library; the network modules use OpenSSL for TLS (`https://`, `wss://`, SMTP STARTTLS), so they add `--link -lssl --link -lcrypto`. `trith/lib/README.md` lists the functions and their bindings.

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
⦃ ⊕ ⊖ ⫴ ⧖ ⧗̰⁰ ⟜̰ ⦃ ⦶ ≶ ⦄ ⧗̰⁰ ⊙̰⁰ ⁇ ⦃ ⎙ ⦄ ⦃ ⦄ ⦄ ⟨⊸⟩ ᛟ ⸫ ⸱ ⸱
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
- **Superscript indices** are decimal. They stay decimal (decided after milestone 7): they count positions on the compiler's stack and strand, not values, and decimal superscripts are what fonts provide. `⊙⁻` and `⊙⁺` take `⁻`/`⁺` as their index.
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
- **Code generation (milestone 3).**
  - The virtual stack holds SSA names. Joins of `⋔`, `⁇` and `⥀` become `phi` nodes. A `⁼` face reuses the earlier face's block, and an `∅` face branches straight to the join. When `≶` feeds `⋔` or a `⥀` exit directly, the branch uses the comparison itself (`icmp eq`, `icmp sgt`) instead of materialising the trit. That is what brought the loop benchmark to C speed.
  - Integer `⊘` rounds to nearest; exact halves round toward zero. `⊜` is the matching remainder `a − b·(a ⊘ b)`, so `▽○△ ○△ ⊜` (8 mod 3) is −1.
  - `⎙` prints numbers and trits followed by a newline (trits as −1, 0, 1, as in §15.5), reals with `%.15g`, and strings exactly as written.
  - A `⥀` that exits with `⊖` propagates failure when the function may fail. Otherwise the program stops with status 27.
  - Future calls also run when their block is left by failure, innermost block first.
  - Not yet: quantum values held by a function are not freed on a failure path; past-tense calls run at run time until the evaluator exists (milestone 5).
  - `trithc --debug` builds with `-O0` and makes prayers trap. Release builds turn them into `llvm.assume`.
- **Evidentials and charges (milestone 4).**
  - Every value carries an evidential and a charge. Operators propagate the strongest evidential (hearsay > inferred > witnessed). Calls and returns check them, `⊨` makes a value witnessed, and `⥀` re-checks its body until the carried annotations stop changing.
  - Storing a hearsay value into a witnessed array with `⍈` is rejected, because it would launder the value.
  - A literal is a gluon: in `⊞ ⊟ ≶` it takes the other operand's charge, and in `⊠ ⊘` it counts as neutral. Joins and loops must agree on charges.
  - Call-by-shape keys include evidentials and charges (open question below, answered yes).
- **Arrays, strings, particles and FFI (milestone 4).**
  - `ʃ` and `⟦T⟧` share the layout `{ptr data, i64 len, i64 cap}`. A shadow is the same pointer, or the value itself for classical values.
  - No array is ever empty (there is no empty literal and nothing removes elements), and every buffer has one spare byte. So `⌖` loads from a clamped position and selects the result without branching. Element accesses carry alias metadata so that LLVM knows they never overwrite array headers.
  - `⌁` frees nested strings and arrays. Arrays whose elements are particles cannot be freed yet.
  - There are no byte literals. An integer literal used next to a 𝔹 operand, or pushed into an `ʃ` with `⍆`, is read as a byte; values above 127 wrap to the signed range. `⌖` indices and the `⍈` index stay ℤ (milestone 6).
  - `⚇` widens a 𝔹 to ℤ, and `⍆` on an `ʃ` also takes an ℤ, keeping its low byte (milestone 6).
  - Particles are made by FFI functions that return the particle type. The antiparticle receives the representation.
  - Each `⎔` binding becomes a small C wrapper in a generated `.ffi.c` file, so the C compiler checks the call against the real prototype from the system headers (`--include` adds headers, `--link` adds C files). Type mapping:
    - ℤ is `int64_t`, ℝ is `double`, ŧ is `int8_t`, 𝔹 is `uint8_t`.
    - `⟗ʃ` and `⟖ʃ` are passed as NUL-terminated `char *`. An owned `ʃ` is passed the same way and freed after the call. `⟗⟦T⟧` is passed as a pointer to the elements.
    - An `ʃ` result is copied from a `char *`.
    - A `◌` result fails when it is negative (integers), NULL (strings) or NaN (reals).
  - The runtime offers `trith_argc`, `trith_arg(i)`, `trith_read_file(path)` and `trith_write_file(path, data)` to `⎔` bindings, for the self-hosted compiler (milestone 6). `trith_arg` and `trith_read_file` return NULL on failure, so they bind as `◌ʃ`; `trith_write_file` returns 0 or −1, so it binds as `◌ℤ`. `trith/tests/run/io_bytes.trh` uses them.
  - The runtime and FFI glue are compiled to LLVM IR and linked into one module before optimising, so calls into them can inline.
  - The glue and every `--link` file are compiled with `-I .`, so a quoted `--include` path is found from the repository root. s2 takes the same `--include` and `--link` flags (milestone 7).
- **Compile-time evaluation (milestone 5).**
  - The evaluator runs pure code over ℤ, ŧ and their `◌` forms. It refuses I/O, FFI, containers and future calls. Integers must stay within 2⁵³, and it gives up after 10⁷ steps or 200 nested calls.
  - A past-tense call needs a pure callee and arguments known at compile time; literals and operators on them are folded. §15.4 compiles to a single `print(21)`.
  - A prayer whose inputs are known is decided: true prayers are erased, false ones are "blasphemy", and `⦶` ones are "doubt". Other prayers become `llvm.assume` (or a trap with `--debug`).
- **Reversible functions (milestone 5).**
  - The s1 inverter accepts these units: `x ⊞`, `x ⊟`, `x ⩡` (x a literal or `⍿ⁿ` with n ≥ 1), `⊝`, calls to `⇋` functions and `⇜` calls, and `⍿⁰ x ≶ ⋔⇋ F₀ F₊ F₋ ⦃A⦄`.
  - The exit assertion A is a predicate on the top value. A forward run checks that it agrees with the face taken, as in Janus, and stops with status 27 if it doesn't.
  - The generated inverse reverses the units and inverts each one. For `⋔⇋`, the condition and the assertion swap roles.
- **Superposition (milestone 5).**
  - Alternatives are classical numbers or trits. A ψ of them can be copied. Each alternative is its own SSA value with i1 `live` and `neg` (phase) flags. When everything is known, LLVM folds the flags and the ψ is erased: §15.5 compiles to `print(1)`.
  - `⫴` interferes in order: for each later alternative j and earlier i, equal values with the same phase merge (j dies), and with opposite phases both die.
  - Lifting applies `⊞ ⊟ ⊠ ⊝ ≶ ⋏ ⋎` and the bitwise operators to every combination of alternatives. `⊘` and `⊜` do not lift in s1.
  - `⊙⁻`/`⊙⁺` on an empty ψ stop the program with status 27; `⊙⁰` yields `◌⁖T`. All collapses are inferred.
  - `⧗ⁿ ⟜ ⦃P⦄` filters the moment itself and leaves nothing on the stack. §15.5 only balances under this reading.
  - The compiler applies the filter where the moment was bound, so earlier reads see it too (`trith/tests/run/retrocausal.trh`). If a `⋔`, `⁇` or `⥀` comes between the bind and the filter, s1 filters from the `⟜` onwards instead.
  - Not in s1: `⋔` on a ψ, and a ψ crossing a join, a loop or a function boundary.
- **s2 (milestone 6).**
  - s2 is authored as logical-order Trith with named moments: `⧖:x` binds and `⧗:x` reads. `trith/s2/tools/trx.py` turns them into `⧗ⁿ`, following §5.1: every block starts an empty strand, a `⥀` exports its body's moments, and `⋔`/`⁇` faces export their common prefix. A name that is not visible is an error, which catches the most common stack mistake: reading an outer moment inside a face. `‹name›` stands for a generated Runic function name.
  - The lexer keeps the whole token stream in one `⟦ℤ⟧`. Its first slots hold the scanner's registers, and variable-length records follow (kind, line, column, marks, index, two values, then the text's code points). So every lexing function takes and returns one array, and an error is a `◌` that propagates. Only functions with a single output may fail (§7.3), and a loop or a join does not unwrap a `◌` by itself, so the lexer passes `◌⟦ℤ⟧` results through an identity function where needed.
  - The parser's state is also one `⟦ℤ⟧`: registers, then the item tree in preorder. Each node is kind, token, size and fields, followed by its children, so a node's next sibling is at its slot plus its size. Tangling appends the functions after the parsed items, with each function's fragment bodies concatenated in ordinal order.
  - Shadows cannot be returned, so helpers that loop over a borrowed array do their work inside the loop's faces rather than in a called function.
  - The check pass keeps everything in one owned `⟦ℤ⟧` heap, `C`, threaded through every function. Its first 40 slots are registers (the trace flag, the token buffer's and the tree's bases, the function, particle and shape tables, and the common types), and an arena follows that is never freed. Types, names and charges are interned strings `[next n cps…]`, so equal strings have the same slot and compare as integers; lists are `[n elements…]`; a value on the virtual stack is a record (type, identity, token, region, origin, role or void flag, evidential, charge). The token buffer and the tree are copied in once, so the checker reads them with plain `‹rd›`.
  - Because `C` is linear, reading it moves it out. `trx.py` tracks this for the moment `C`: a second read without rebinding it is an error at the line where it happens, which catches the commonest mistake in heap-threading code before s1 sees it.
  - Strings and lists are built contiguously at the arena's end, so a helper that needs another string must build it before starting its own.
  - Strings are interned through 1024 hash buckets (register 3); with a linear chain, checking the 5,000-line s2 of the time took 3.7 s; with the buckets it took 0.12 s. IR lines are not interned: they live in queues (a header and linked nodes) that can grow while other things are allocated, and a loop's placeholder phi lines are patched in place once the latch is known.
  - Code generation runs on the heap the check pass leaves, so it reads the same tree and function table. Entries of the virtual stack are records [type, v, ok, role, known value, literal mark, superposition slots, live and phase flags, the comparison behind a fresh `≶`]; SSA names and constants are interned, so a phi is needed exactly where the names of an entry differ between predecessors.
  - The generated inverse of a `⇋` function is new tree nodes appended to the heap: the units of the body reversed, each one inverted. The faces of a `⋔⇋` are inverted first, so each new node's children stay contiguous. Kind 18 is an op whose `⊞` and `⊟` swap places, so inverting an update needs no new token.
  - The compile-time evaluator is a direct port of s1's, including its limit of 2⁵³ on integers; 2⁵³ itself is computed with a shift, since s1's lexer reads that literal through a double and would round it.
  - `trx.py`'s `%%text {x} {#n}%%` builds a heap string from the `C` on the stack, which keeps the IR templates close to s1's text.
- **Decided after milestone 7.**
  - Agreement applies to `⧗ⁿ` reads too (§6.1). `trx.py` writes the mark after a name: `⧗:C̵` reads the heap `C` by moving it.
  - Call by shape matches evidentials and charges as well (§9.1).
  - Generics: type variables `α … θ` over classical types, monomorphised per call (§9.4). Step 2 is quotations with row-polymorphic effects, specialised per call site (§9.5).
  - The ψ cap is 9 for quantum alternatives and stays 27 for classical ones (§8.3).
  - Scattered fragments may live in different files of one module: all the files given to one compiler run are the planes of one module (Addendum A.1).
  - Arrays inside `⥀`: borrowed moments are region-scoped (§5.1), so a loop body reads and writes an array through a `⟗`/`⟖` moment of an enclosing block instead of carrying it through the loop stack. Codegen is free: the shadow is a loop-invariant pointer. `trx.py` resolves `⧗:x̱` through the enclosing blocks.
- **Tooling.** `trithc --plough` turns a file written in logical order (every line left to right) into on-disk order and pads it with breaths. `trithc --unplough` does the reverse, for reading.

No question of draft 1 is open any more. The addenda keep their own (A.9, B.5).

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
3. Stack-to-SSA and LLVM emission for ℤ, ŧ, `⋔`, `⥀`, functions and inside-out scope. **Benchmark gate here.** **Done:** `trith/src/emit.uh`, `trith/runtime/trith_rt.c`; also ℝ, 𝔹, string literals with `⎙`, `◌`/`⁇`/`↯`, `⊨`, prayers, future calls and call by shape. `make trith-bench` passes: fib(35) 0.97× and Collatz to 10⁶ 1.03× of `clang -O2`.
4. ◌, arrays, strings, FFI, particles, evidentials, charges. **Done.** Benchmarks: n-body 1.06× and Game of Life 0.95× of `clang -O2`. Life's grid-size prayer (§12) lets the optimiser remove every bounds check.
5. ψ with phases, `⟜`, `⇋`, tense, prayers, call by shape. **Done** within the s1 limits recorded in §16.1.
6. Rewrite the compiler in Trith (s2), then pass the fixpoint (s3). **Done:** `trith/s2/`, built as `build/s2c` by s1. s2 agrees with s1's `--tokens`, `--ast`, `--check` and `--emit-llvm` on every file in the repository, on random inputs and on mutated tests, and compiled programs behave identically (`make s2-test`, `make s2-fuzz`). s3, s2 compiled by s2, emits exactly the IR s2 emits for its own source and is the same executable (`make s2-fixpoint`). s2 is about 30× faster than s1: it checks its own 8,000-line source in 0.24 s and compiles it to IR in 0.35 s (s1: 7.5 s and 11 s).
7. Port the standard library modules. **Done:** `trith/lib/`: crypto (SHA-256, HMAC-SHA-256, AES-256-CBC, random bytes), json, http (client and server), ws (WebSocket client and server) and smtp, in C with Trith-shaped signatures (−1 and NULL for failure, so results bind as `◌`). Network results are bound as hearsay `⸮`. `make lib-test` builds and runs a test of each module with s1 and with s2; the network tests fork into a server and a client, and the SMTP test talks to a fake server. There is no TLS. SHA-256 is also written in Trith itself, as the last benchmark (`trith/bench/sha256.trhx`): it hashes 100 MiB at about 1.2× the time of `clang -O2`, and prayers on the table lengths remove every bounds check. The remaining gap is 32-bit arithmetic done in 64-bit ℤ with masks, since Trith has no 32-bit integer type.

Benchmarks, each of which must run within 1.5× of `clang -O2`:

- fib(35), recursive
- n-body, 1M steps
- Game of Life, 512² grid, 1000 generations
- SHA-256 of 100 MiB
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
| `α … θ` | — | type variable in a signature (§9.4) |
| `⦃ ⦄` in a body | `⟨⊸ ⦃E⦄⟩` | quotation (§9.5) |
| `⍎` | `⟨S ⦃S ⊸ S'⦄ ⊸ S'⟩` | apply a quotation |
| `ρ σ` | — | row variable in an effect (§9.5) |
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
