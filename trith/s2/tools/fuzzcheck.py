#!/usr/bin/env python3
"""Differential fuzzing of the s2 checker against s1 (trithc --check).

usage: fuzzcheck.py S2C TRITHC WORKDIR [SEED] [COUNT]

Takes the Trith files under trith/tests and mutates them at the token level
(drop, duplicate, swap neighbours, or replace a token with one from the same
file), rebalances the breaths and mostly keeps mutants that still parse, and
compares the two --check outputs, traces and errors included. Most mutants
fail to check, each at a different point, so every rule gets both its
passing and its failing paths exercised. Exits 1 if any case differs.
"""
import glob
import os
import random
import subprocess
import sys

s2c, trithc, work = sys.argv[1:4]
R = random.Random(int(sys.argv[4]) if len(sys.argv) > 4 else 1)
N = int(sys.argv[5]) if len(sys.argv) > 5 else 300

SEEDS = []
for p in sorted(glob.glob('trith/tests/**/*.trh', recursive=True)):
    with open(p) as f:
        src = f.read()
    if len(src) < 4000:
        SEEDS.append(src)


def mutate(src):
    lines = src.split('\n')
    toks = [(i, j) for i, ln in enumerate(lines)
            if not ln.lstrip().startswith('⍝')
            for j, _ in enumerate(ln.split(' '))]
    if not toks:
        return src
    rows = [ln.split(' ') for ln in lines]
    for _ in range(R.choice([1, 1, 1, 2, 3])):
        i, j = R.choice(toks)
        if j >= len(rows[i]) or not rows[i][j]:
            continue
        op = R.randrange(4)
        if op == 0:
            del rows[i][j]
        elif op == 1:
            rows[i].insert(j, rows[i][j])
        elif op == 2 and j + 1 < len(rows[i]):
            rows[i][j], rows[i][j + 1] = rows[i][j + 1], rows[i][j]
        else:
            a, b = R.choice(toks)
            if b < len(rows[a]) and rows[a][b] and '»' not in rows[a][b]:
                rows[i][j] = rows[a][b]
    return '\n'.join(' '.join(r) for r in rows)


def run(cmd):
    try:
        return subprocess.run(cmd, capture_output=True, timeout=20).stdout
    except subprocess.TimeoutExpired:
        return b'(timeout)'


def balance(p, src):
    out = run([trithc, p, '--tokens']).decode(errors='replace')
    if 'imbalance' in out:
        r = int(out.split('tokens, ')[1].split(' ')[0])
        src = src.rstrip('\n') + '\n' + ' ⸱' * (3 - r) + '\n'
        with open(p, 'w') as f:
            f.write(src)


os.makedirs(work, exist_ok=True)
bad = 0
for k in range(N):
    p = os.path.join(work, f'c{k}.trh')
    for _ in range(12):
        src = mutate(R.choice(SEEDS))
        with open(p, 'w') as f:
            f.write(src)
        balance(p, src)
        # keep mostly mutants that parse, so the checker itself is exercised
        if b'error' not in run([trithc, p, '--ast']) or R.random() < 0.1:
            break
    a, b = run([s2c, p, '--check']), run([trithc, p, '--check'])
    if a != b:
        bad += 1
        if bad <= 5:
            print('DIFF', p)
            print('  s2:', a.decode(errors='replace')[-300:])
            print('  s1:', b.decode(errors='replace')[-300:])
print(f'{N} cases, {bad} differ')
sys.exit(1 if bad else 0)
