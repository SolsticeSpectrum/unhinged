# Trith Addendum B: Heat and Voltage (draft 0)

> This addendum extends `docs/TRITH.md` and `docs/TRITH-ADDENDUM-A.md`. Its sections are numbered B.n.
> The Zero-Cost Law (§0) applies. Every section ends with **Cost**, **Problems** and **Precedent**.
> As with Addendum A, these features are implemented in s2 only; s1 stays frozen.

| Feature | In one line | Where it is implemented |
|---|---|---|
| B.1 Heat | Erasing information produces heat. A function with zero heat is cold, and every cold function can be inverted. | type checker |
| B.2 Voltage | Secrets carry potential. Data flows downhill only, and a transformer is required to step it down. | type checker |
| B.3 High voltage | For the most secret values, branches become constant-time selects. | type checker and code generation |

---

## B.1 Heat (Landauer's principle)

Landauer: erasing one bit of information dissipates at least kT ln 2 of energy. It is the deletion that costs, not the computation. In Trith, every operation that loses information produces one **quantum of heat**, written `♨`.

### B.1.1 One rule

**Heat equals the number of operations that are not in the invertible unit set.** The invertible unit set is exactly the set the `⇋` checker accepts today (§16.1, "Reversible functions"):

- `x ⊞`, `x ⊟` and `x ⩡`, where x is a literal or `⍿ⁿ` with n ≥ 1
- `⊝`
- moves with `⍿ⁿ`
- calls to cold functions, and `⇜` calls
- `⍿⁰ x ≶ ⋔⇋ F₀ F₊ F₋ ⦃A⦄`, where the faces are cold and A is an exit assertion

Because the rule is defined by that set, heat and reversibility can never disagree. Some consequences:

| Operation | Heat | Why |
|---|---|---|
| `⊠`, `⊘`, `⊜`, `≶` that consumes its operands, bitwise and/or, shifts | 1 each | information is lost |
| `⌁`, or a classical moment that leaves scope unread | 1 per value | erasure |
| A plain `⋔` join | 1 | which face ran is forgotten; Janus's exit assertion exists to prevent exactly this |
| `⋔⇋` with an exit assertion | 0 | the path can be recovered |
| `⊙` on a `ψₙ` | n − 1 | the discarded alternatives |
| Copying a classical value (`⧗ⁿ`, `⍿ⁿ`) | 0 | copying is not erasure |
| A call | the callee's heat | |
| `⥀` with a cold body | 0 | |
| `⥀` with a warm body | body heat × the vow bound (A.5) if the vow is proven; otherwise unbounded (**runaway**) | |
| FFI calls, `⎙` | unbounded | the outside world is a heat sink |

### B.1.2 Cold functions

- A function whose heat is 0 is **cold**.
- **Every cold function is invertible.** `⇜ᚠ` works on any cold ᚠ, so it no longer has to be declared `⇋`. The compiler generates the inverse on demand, using the existing inverter.
- `⇋` stays valid, and now means "assert that this function is cold". If the function is not cold, the error is **not cold**, and it names the first warm operation.
- **Shape rule.** Inversion is only defined for functions with signature `⟨S ⊸ S⟩`. A cold function with any other shape is cold but cannot be inverted, and calling `⇜` on it is an error.

### B.1.3 Heat declarations and reports

- A signature may declare a heat limit, for example `⟨ℤ ⊸ ℤ⟩♨³`. If the function's heat exceeds the limit, the error is **meltdown**. `♨⁰` is the same as `⇋`.
- `--thermal` prints each function's heat and its hottest operation.
- Heat never affects code generation. It is accounting only, with one consequence: cold functions get their inverses for free.

**Cost.** Type checker only. The inverter already exists.

**Problems.**

- Auto-inversion is exactly as sound as the existing `⇋` checker, no more. Generalising heat beyond that unit set (for example, treating `⊠` by an odd literal as invertible modulo 2⁶⁴) must extend the inverter first.
- Real code is warm almost everywhere. Heat is mostly a report and a party trick, except where reversibility actually matters.
- Charging heat for unread classical moments penalises writing a value and then ignoring it. That is intended, but it makes `--thermal` output noisy.

**Precedent.**

- Landauer's principle, and Bennett's compute-copy-uncompute method for removing garbage.
- Janus, whose exit assertions keep joins reversible.
- Axelsen's garbage-free compilation from Janus to PISA.
- Silq's safe uncomputation (Addendum A and TRITH.md §19).
- Automatic program inversion with injectivity checking (Hu and D'Antoni, PLDI 2017).

---

## B.2 Voltage (confidentiality)

Evidentials (§3.1) track **integrity**: can this value be trusted? Voltage tracks **confidentiality**: can this value leak? The two are independent axes, and every value carries both.

### B.2.1 Potentials

There are three potentials, ordered ground < live < high:

| Potential | Written | Meaning |
|---|---|---|
| ground | (unmarked) | public |
| live | `⚡T` | confidential: must never reach a public sink |
| high | `⚡⚡T` | secret: also must not leak through timing (B.3) |

Potentials are written in signatures, FFI bindings and particle declarations, just like evidentials.

### B.2.2 Flow rules

1. **Contagion.** A result's potential is the maximum of its operands' potentials.
2. **Ground sinks.** Ground sinks accept only ground values. Writing a higher-potential value to one is the error **short circuit**. The ground sinks are:
   - `⎙`
   - parameters of worldly FFI bindings (the default)
   - function outputs declared ground
   - `⍈` into a ground array
   - the exit status of `ᛟ`
3. **Implicit flows.** Inside a `⋔` face, a `⁇` face, or a `⥀` body whose condition is live, the **program-counter potential** is live. Inside such a context:
   - Every sink is checked at the potential of the program counter. In particular, `⎙` and worldly calls are forbidden there.
   - Moments exported from the faces (§5.1) become live.
   - A failure produced there is live, and propagating it out of a function whose output is ground is a short circuit.
4. **Termination.** Live values may control loops, so termination can leak about one bit. This is the standard termination-insensitive guarantee that Jif also makes. High-voltage values close this channel (B.3).

### B.2.3 Transformers

- `⏚` pops a value and pushes it back at ground potential. This is declassification.
- A transformer is a promise, like an exorcism (A.4). `--confessions` lists every transformer.
- `⏚` is the **only** way to lower a potential. Nothing lowers potential implicitly: not attestation (`⊨`), not collapse, not exorcism.

### B.2.4 Interaction with the other features

| Feature | Effect |
|---|---|
| Call by shape and summons | potentials are part of the shape, as evidentials and charges are (§16.1) |
| Superposition | a ψ of live values is live, and collapse keeps the potential |
| Dreams (A.3) | potentials do not exist at compile time; `ϟ` values are ground |
| Blessings | potentials do not affect purity, so a blessed function may compute on live values |

**Cost.** Type checker only.

**Problems.**

- **Label creep.** One live value contaminates everything it touches. In practice code fills up with transformers, so listing them is essential.
- Implicit flows make printing inside secret-dependent branches impossible, including debug printing. `--debug` does not relax this.
- With only two non-ground levels, Trith cannot express "secret to Alice but not to Bob". That is a deliberate simplification of Jif's decentralised label model.

**Precedent.**

- Jif / JFlow (Myers): security labels, implicit flows through the program-counter label, and declassification.
- Flow Caml, and the Volpano–Smith–Irvine type system for noninterference.
- Sabelfeld and Myers, "Language-Based Information-Flow Security" (from memory).

---

## B.3 High voltage: constant-time branches

A `⚡⚡` value must not leak through **timing** or **memory access patterns**. FaCT handles this by transforming secret branches into constant-time code rather than rejecting them, and Trith does the same.

### B.3.1 Rules

1. **Branches are transformed, not rejected.** When a `⋔` takes a `⚡⚡` trit, **every face runs**, and the results are merged with constant-time selects. This is exactly the lowering of `⋔` on a ψ (§8.3), where every live face runs and the results are merged under a mask, so that code generation is reused.
2. **Faces under high voltage** may only:
   - use operations with no curses
   - call doubly blessed (`✧✧`) functions

   That rules out I/O, allocation, failure and restless loops inside a secret branch. Violating it is the error **arc flash**. This is a simplification of FaCT's extra-predicate calling convention: with no side effects, computing both sides and selecting is always correct.
3. **Rejected outright** (the error **arc flash**):
   - `⚡⚡` array indices (`⌖ ⍈` with a high index)
   - `⚡⚡` loop conditions (a `⥀` whose trit is high)
   - a `⚡⚡` summon coordinate (A.2)
   - `⊘` and `⊜` with a high divisor, because division takes variable time on most CPUs
4. **`⁇` on a high failure is rejected.** Failure is a branch.

### B.3.2 Lowering

- Selects are emitted as **masked arithmetic** (`mask = 0 − cond`, `r = (a ⋒ mask) ⋓ (b ⋒ ¬mask)`), not as LLVM `select`. LLVM may legally turn a `select` back into a branch.
- A **value barrier** (an empty inline-asm statement that takes the mask as a register operand) keeps the optimiser from proving the mask constant and reintroducing the branch.
- `make trith-ct` checks the generated assembly of every high-voltage test for conditional branches that depend on secret values.

**Cost.** A high branch costs every face plus the selects. That is exactly what hand-written constant-time C costs, and it is opt-in, so the law holds: the generated code is what C would produce for equivalent *constant-time* C.

**Problems.**

- **Compilers break constant-time code.** Even with masked arithmetic and value barriers, LLVM, or a future version of it, may find a way back to a branch. `trith-ct` has to stay in CI.
- Running every face can be slow when one face is expensive. That is the price of constant time.
- Hardware variable-time instructions beyond division (some multipliers, floating-point subnormals) are not modelled. `ℝ` arithmetic on high values should probably be rejected as well (open question).

**Precedent.**

- FaCT: A DSL for Timing-Sensitive Computation (Cauligi et al., PLDI 2019). Its type system turns secret branches into constant-time selects, and it rejects secret-dependent array indices and secret loop bounds.
- The constant-time analysis lecture notes (IRISA).
- Value barriers in BearSSL and BoringSSL (from memory).

---

## B.4 Milestones

| # | Milestone | Gate |
|---|---|---|
| B1 | Heat: accounting, cold detection, auto-`⇜`, `♨ⁿ` limits, `--thermal` | `⇋` and `♨⁰` agree on every existing reversible test; golden tests for meltdown and not-cold |
| B2 | Voltage: potentials, flow rules, program-counter potential, `⏚`, transformers in `--confessions` | golden tests for every short-circuit case, including implicit flows and live failure |
| B3 | High voltage: transformed branches, the arc-flash rules, masked lowering, value barriers, `make trith-ct` | a constant-time compare benchmark within 1.5× of the equivalent constant-time C; `trith-ct` clean |

B1 depends only on the existing inverter. B3 depends on blessings (Addendum A, milestone A2).

---

## B.5 Open Questions

- Should `ℝ` arithmetic on `⚡⚡` values be rejected? Subnormals make it variable-time.
- Should there be a heat-free `⌁` for particles whose antiparticle is cold?
- Should heat count bits (for example, 64 for an `ℤ`) instead of operations? This draft counts operations, to keep it a single rule.
- Should potentials be ternary-valued trits (− = ground, 0 = live, + = high), so they can be computed with `⋏`/`⋎`? Max is `⋎`, so this works.

---

## B.6 Glyph Additions

| Glyph | Meaning |
|---|---|
| `♨ⁿ` | heat limit in a signature (`♨⁰` means cold) |
| `⚡T` | live (confidential) type |
| `⚡⚡T` | high-voltage (secret, constant-time) type |
| `⏚` | transformer: declassify to ground |

None of these appears in TRITH.md, in Addendum A, or in the s1 sources.

---

## B.7 Precedent and Study Links

Links marked (searched) were found and checked on 2026-10-28. The others are well-known references from memory.

**Heat (B.1)**

- https://arxiv.org/pdf/2309.11832 (searched): Thomsen, "Design of Reversible Computing Systems". Covers Landauer's limit (kT ln 2 per erased bit), garbage, Bennett's method, Janus, and Axelsen's Janus-to-PISA compiler.
- https://en.wikipedia.org/wiki/Landauer%27s_principle
- https://arxiv.org/pdf/physics/0210005 (searched)
- https://www.nature.com/articles/430971a.pdf (searched)
- https://arxiv.org/pdf/2011.14989 (searched): the ℵ calculus.
- https://arxiv.org/pdf/2105.09929 (searched): join inverse rig categories for reversible functional programming.
- https://pldi17.sigplan.org/details/pldi-2017-papers/51/Automatic-Program-Inversion-using-Symbolic-Transducers (searched): Hu and D'Antoni. An injectivity check, followed by inversion.
- https://en.wikipedia.org/wiki/Program_Inversion,_Interpretation,_and_Injectivization (searched)
- https://researchprofiles.ku.dk/en/publications/reversible-computing-from-a-programming-language-perspective/ (searched)
- https://arxiv.org/pdf/1707.07845 (searched): a reversible object-oriented language.

**Voltage (B.2)**

- https://cs.brown.edu/courses/csci2390/2023/readings/jif.pdf (searched): Jif.
- https://www.cs.cornell.edu/andru/cs711/2003fa/presentations/jflow-cs711fa03.pdf (searched): JFlow.
- https://www.cs.cornell.edu/courses/cs513/2006fa/lectures/lec24.html (searched): static information flow, implicit flows.
- https://www.cs.uoregon.edu/research/summerschool/summer19/lecture_notes/myers1.pdf (searched): Myers, OPLSS lecture notes.
- https://cs.pomona.edu/~ebirrell/classes/cs181s/2024sp/lectures/20-iflow2/iflow2.pdf (searched): program-counter label.
- https://arxiv.org/pdf/1805.00120 (searched): types for information flow control, labeling granularity.
- https://secgroup.dais.unive.it/wp-content/uploads/2020/04/ifc.pdf (searched)
- https://www.cs.cornell.edu/andru/papers/jsac/sm-jsac03.pdf (Sabelfeld and Myers, from memory)

**High voltage (B.3)**

- https://cseweb.ucsd.edu/%7Edstefan/pubs/cauligi:2019:fact.pdf (searched): FaCT. Secret branches become constant-time selections; secret indices and loop bounds are rejected.
- https://pldi19.sigplan.org/details/pldi-2019-papers/47/FaCT-A-DSL-for-Timing-Sensitive-Computation (searched)
- https://crocs-muni.github.io/ct-tools/tools/fact (searched): a list of constant-time tools.
- https://www.irisa.fr/celtique/teaching/SOS/2021/ConstantTimeAnalysis.pdf (searched)
- https://www.bearssl.org/constanttime.html (from memory)
