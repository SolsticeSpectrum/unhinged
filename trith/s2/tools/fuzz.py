#!/usr/bin/env python3
"""Differential fuzzing of the s2 lexer against s1 (trithc --tokens).

usage: fuzz.py S2C TRITHC WORKDIR [SEED] [COUNT]

Writes random small .trh files to WORKDIR (numerals, names, types with
charges, indexed glyphs, strings, marks, comments, both line directions,
some deliberately malformed) and compares the two token dumps. Files that
only break the Balance Law get breaths appended, so most cases lex fully.
BADP and MARKP in the environment set how often malformed atoms and marks
appear. Exits 1 if any case differs.
"""
import os
import random
import subprocess
import sys

s2c, trithc, work = sys.argv[1:4]
R = random.Random(int(sys.argv[4]) if len(sys.argv) > 4 else 1)
N = int(sys.argv[5]) if len(sys.argv) > 5 else 300
BADP = float(os.environ.get('BADP', '0.03'))
MARKP = float(os.environ.get('MARKP', '0.08'))

GOOD = ['△', '▽', '○', '▽△', '○△○', '△⁝△', '▽△⁝○▽', '⊕', '⊖', '⦶', 'ᚠ', 'ᚢᛟ', 'ᚋᚐ', 'ᚋ',
        '⌁ᚋᚐ', '⌁', '⇜ᚱ', '⇜', '⋔⇋', '⋔', '⧗⁰', '⧗¹²', '⧗', '⍿³', '⊙⁻', '⊙⁺', '⊙', '⍤¹',
        'ℤ', 'ℝ⁽ᵘᵈ⁻¹⁾', '⁖ℝ⁽ᵗ²ˢ⁻³⁾', 'ℤ⁽ᵘ¹⁰ᵈ⁾', 'ψ₂ŧ', 'ψ₂₇ℤ', 'ψ₂', '◌', '⟗ʃ', '⸮◌ℤ', '◌ᚋᚐ',
        '⊞', '⊟', '⎙', '⸫', '⸱', '⊸', '⦃', '⦄', '⟨', '⟩', '⟦', '⟧',
        '»a«', '»ab c«', '»\\"«', '»↵x«', '»áb«', '»«', '»́a«', '«b»']
BAD = ['○⁝', '⁝△', '△⁝△⁝△', 'ℤ⁽⁾', 'ℤ⁽ᵘᵘ⁾', 'ℤ⁽ᵘ⁰⁾', 'ℤ⁽x⁾', 'ℤ⁽ᵘ', 'ℤᵘ⁾', '⁽ᵘ⁾', '◌⁽ᵘ⁾',
       'ψŧ', 'ψ₀ℤ', 'ψ₂₈ℤ', '◌x', '◌ℤℤ', 'ᚋℤ', '☃', 'x', '42', 'ab3', '»unterminated',
       '⧗ᚠ', '⍿⁻', '⌁ᚠ', '⇜ᚋ', 'ℤ⁽ᵘ⁻⁾']
MARKS = ['́', '̀', '̂', '̈', '̃', '̵', '̰', '̱', '̇']
SPACES = [' ', ' ', ' ', '\t', ' ']


def tok():
    t = R.choice(BAD if R.random() < BADP else GOOD)
    if R.random() < MARKP:
        ms = ''.join(R.choice(MARKS) for _ in range(R.choice([1, 1, 2])))
        if t.startswith('»') and t.endswith('«') and R.random() < 0.5:
            t = t + ms
        else:
            k = R.randrange(1, len(t) + 1) if R.random() < 0.7 else len(t)
            t = t[:k] + ms + t[k:]
    return t


def line():
    s = ''
    for _ in range(R.randrange(0, 6)):
        s += tok() + (R.choice(SPACES) if R.random() < 0.9 else '')
    if R.random() < 0.2:
        s += '⍝ △'
    if R.random() < 0.1:
        s = '⍝ ' + s
    if R.random() < 0.05:
        s += '\r'
    return s


def dump(cmd):
    return subprocess.run(cmd, capture_output=True).stdout


os.makedirs(work, exist_ok=True)
bad = 0
for i in range(N):
    src = '\n'.join(line() for _ in range(R.randrange(1, 4)))
    if R.random() < 0.5:
        src += '\n'
    if not src.strip():
        src = '△ ⸱ ⸱'
    p = os.path.join(work, f'f{i}.trh')
    with open(p, 'w') as f:
        f.write(src)
    b = dump([trithc, p, '--tokens']).decode()
    if 'imbalance' in b:
        r = int(b.split('tokens, ')[1].split(' ')[0])
        src = src.rstrip('\n') + '\n' + ' ⸱' * (3 - r)
        with open(p, 'w') as f:
            f.write(src)
    a, b = dump([s2c, p, '--tokens']), dump([trithc, p, '--tokens'])
    if a != b:
        bad += 1
        if bad <= 5:
            print('DIFF', p, repr(src))
            print('  s2:', a.decode()[-300:])
            print('  s1:', b.decode()[-300:])
print(f'{N} cases, {bad} differ')
sys.exit(1 if bad else 0)
