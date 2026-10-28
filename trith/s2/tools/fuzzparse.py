#!/usr/bin/env python3
"""Differential fuzzing of the s2 parser against s1 (trithc --ast).

usage: fuzzparse.py S2C TRITHC WORKDIR [SEED] [COUNT]

Builds random programs from items (functions, reversible functions,
fragments, particles, FFI bindings) with random bodies (selects, loops,
handlers, prayers, quotes, arrays, shape calls), mutates some of them
(dropping, duplicating or swapping tokens) and writes them in logical
order; trithc --plough turns each into on-disk order. Both parsers must
print the same tree or the same error. Exits 1 if any case differs.
"""
import os
import random
import subprocess
import sys

s2c, trithc, work = sys.argv[1:4]
R = random.Random(int(sys.argv[4]) if len(sys.argv) > 4 else 1)
N = int(sys.argv[5]) if len(sys.argv) > 5 else 200

NAMES = ['ᚠ', 'ᚢ', 'ᚱ', 'ᚠᚢ', 'ᛟ']
TNAMES = ['ᚋᚐ', 'ᚁ']
TYPES = ['ℤ', 'ŧ', 'ℝ⁽ᵘ⁾', 'ʃ', '⟗ʃ', '⟗⟦ℤ⟧', '⟦𝔹⟧', '◌ℤ', '⸮◌ℤ', 'ψ₂ŧ', 'ᚋᚐ', '◌ ⟦ ℤ ⟧', '⟖ ⟦ ℤ ⟧', '◌⁽ᵘ⁾ℤ']
LEAVES = ['△', '▽△', '○⁝△', '⊕', '»a«', 'ᚠ', 'ᚢ̈', '⌁ᚋᚐ', '⇜ᚱ', '⊞', '⊟', '≶', '⎙̵', '⧖', '⧗⁰', '⍿¹',
          '⊙⁰', '⊙', '⫴', '⌖̱', '⟗', '↯', '⊨']
BAD = ['⸫', '⸾', '⊸', '⁼', '∅', '⇋', '⚛', '⎔', '⧗', '⍿', '⍤', 'ℤ', 'ᚋᚐ', '⟩', '⟧', '⦄', '⦃', '⟨', '⟦']


def sig(depth=0):
    ins = [R.choice(TYPES) for _ in range(R.randrange(0, 3))]
    outs = [R.choice(TYPES) for _ in range(R.randrange(0, 3))]
    if R.random() < 0.15:
        outs = ['◌']
    return '⟨ ' + ' '.join(ins + ['⊸'] + outs) + ' ⟩'


def face(d):
    r = R.random()
    if r < 0.2:
        return '⁼'
    if r < 0.35:
        return '∅'
    return block(d + 1)


def op(d):
    r = R.random()
    if d > 3 or r < 0.55:
        return R.choice(LEAVES)
    if r < 0.65:
        return '⋔ ' + block(d + 1) + ' ' + face(d) + ' ' + face(d)
    if r < 0.7:
        return '⋔⇋ ' + block(d + 1) + ' ' + face(d) + ' ' + face(d) + ' ' + block(d + 1)
    if r < 0.76:
        return '⥀ ' + block(d + 1)
    if r < 0.8:
        return '⧗⁰ ⟜ ' + block(d + 1)
    if r < 0.85:
        return '⁇ ' + block(d + 1) + ' ' + block(d + 1)
    if r < 0.89:
        return '⍤¹ ' + block(d + 1)
    if r < 0.93:
        return block(d + 1) + ' ⊨'
    if r < 0.97:
        return '⟦ ' + ' '.join(R.choice(['△', '▽', '○']) for _ in range(R.randrange(1, 4))) + ' ⟧'
    return sig()


def block(d=0):
    return '⦃ ' + ' '.join(op(d) for _ in range(R.randrange(0, 4))) + ' ⦄'


def item():
    r = R.random()
    if r < 0.1:
        return '⚛ ' + R.choice(TYPES) + ' ' + R.choice(TNAMES) + ' ⸫'
    if r < 0.18:
        return '⎔ »tixe« ' + sig() + ' ' + R.choice(NAMES) + ' ⸫'
    s = block() + ' '
    if R.random() < 0.85:
        s += sig() + ' '
    s += R.choice(NAMES + ['⌁' + R.choice(TNAMES)])
    if R.random() < 0.25:
        s += ' ⸾ ' + R.choice(['△', '▽', '○', '▽△'])
    s += ' ⸫'
    if R.random() < 0.1:
        s = '⇋ ' + s
    return s


def program():
    toks = ' '.join(item() for _ in range(R.randrange(1, 5))).split()
    if R.random() < 0.4:
        for _ in range(R.randrange(1, 3)):
            k = R.randrange(len(toks))
            m = R.random()
            if m < 0.3:
                del toks[k]
            elif m < 0.6:
                toks.insert(k, R.choice(BAD))
            elif m < 0.8 and len(toks) > 1:
                j = R.randrange(len(toks))
                toks[k], toks[j] = toks[j], toks[k]
            else:
                toks = toks[:k]
            if not toks:
                toks = ['△']
    lines, cur = [], []
    for t in toks:
        cur.append(t)
        if R.random() < 0.2:
            lines.append(' '.join(cur))
            cur = []
    lines.append(' '.join(cur))
    return '\n'.join(lines) + '\n'


def out(cmd):
    return subprocess.run(cmd, capture_output=True).stdout


os.makedirs(work, exist_ok=True)
bad = 0
for i in range(N):
    logical = os.path.join(work, f'p{i}.logical.trh')
    disk = os.path.join(work, f'p{i}.trh')
    with open(logical, 'w') as f:
        f.write(program())
    ploughed = out([trithc, logical, '--plough'])
    if b'error' in ploughed:
        continue
    with open(disk, 'wb') as f:
        f.write(ploughed)
    a, b = out([s2c, disk, '--ast']), out([trithc, disk, '--ast'])
    if a != b:
        bad += 1
        if bad <= 5:
            print('DIFF', disk)
            print('  s2:', a.decode()[-400:])
            print('  s1:', b.decode()[-400:])
print(f'{N} programs, {bad} differ')
sys.exit(1 if bad else 0)
