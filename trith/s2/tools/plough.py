#!/usr/bin/env python3
"""plough.py FILE: logical order (every line left to right) to on-disk order, like
`trithc --plough`, for files that use what only s2 reads (the addenda's tokens, plane
headers). s1's lexer rejects those, so it cannot plough them.

Even lines are written right to left (§1.1): their tokens are reversed, brackets and a
string's delimiters mirrored, and a comment is written to the left of its ⍝. A plane header ⧉ z ⁿ
starts its plane's lines at 1 again (Addendum A.1.1). Breaths ⸱ are added at the end so
that the module's token count divides by 3 (§1.2); a file with several planes is padded
in its last plane, which is the same as padding the folded module.
"""
import sys

MIRROR = {'⦃': '⦄', '⦄': '⦃', '⟨': '⟩', '⟩': '⟨', '⟦': '⟧', '⟧': '⟦'}
MARKS = range(0x300, 0x370)


def tokens(code):
    """Split a line's code into tokens: whitespace separates them, brackets and strings
    delimit themselves, and marks right after a string's « stay with it."""
    out, cur, i = [], '', 0
    while i < len(code):
        c = code[i]
        if c == '»':
            if cur:
                out.append(cur)
                cur = ''
            j = code.index('«', i + 1)
            k = j + 1
            while k < len(code) and ord(code[k]) in MARKS:
                k += 1
            out.append(code[i:k])
            i = k
            continue
        if c in MIRROR:
            if cur:
                out.append(cur)
                cur = ''
            out.append(c)
        elif c.isspace():
            if cur:
                out.append(cur)
                cur = ''
        else:
            cur += c
        i += 1
    if cur:
        out.append(cur)
    return out


def comment_at(line):
    """Where the line's comment starts (a ⍝ outside strings), or −1."""
    instr = False
    for i, c in enumerate(line):
        if c == '»':
            instr = True
        elif c == '«':
            instr = False
        elif c == '⍝' and not instr:
            return i
    return -1


def physical(tok):
    if tok in MIRROR:
        return MIRROR[tok]
    if tok.startswith('»'):
        j = tok.index('«')
        return '«' + tok[1:j] + '»' + tok[j + 1:]
    return tok


def plough(text):
    lines, count, y = [], 0, 0
    for line in text.rstrip('\n').split('\n'):
        if line.lstrip().startswith('⧉'):
            lines.append(line.strip())
            y = 0
            continue
        y += 1
        code, comment = line, None
        k = comment_at(line)
        if k >= 0:
            code, comment = line[:k], line[k + 1:].strip()
        toks = tokens(code)
        count += len(toks)
        if y % 2 == 0:
            toks = [physical(t) for t in reversed(toks)]
        body = ' '.join(toks)
        if comment is not None:
            if y % 2 == 0:
                body = (comment + ' ⍝ ' + body).strip()
            else:
                body = (body + ' ' if body else '') + '⍝ ' + comment
        lines.append(body)
    pad = (-count) % 3
    if pad:
        breaths = ' '.join(['⸱'] * pad)
        last = lines[-1] if lines else ''
        if not lines or '⍝' in last or last.startswith('⧉'):
            lines.append(breaths)
        elif y % 2 == 0:
            # the end of an even line in reading order is its left
            lines[-1] = (breaths + ' ' + last).strip()
        else:
            lines[-1] = (last + ' ' + breaths).strip()
    return '\n'.join(lines) + '\n'


if __name__ == '__main__':
    sys.stdout.write(plough(open(sys.argv[1]).read()))
