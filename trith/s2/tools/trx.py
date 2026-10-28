#!/usr/bin/env python3
"""trx: authoring preprocessor for Trith sources written in logical order.

  #n#          balanced-ternary literal of decimal n
  $text$       string literal whose logical value is text (\\n allowed)
  @any(a,b)@   ⧗⁰ a ᛖ ⧗⁰ b ᛖ ⋏ …   (is ⧗⁰ one of the code points)
  ⧖:a          bind a moment named a          ⧖:a,b,c  bind [a b c] (c is on top)
  ⧗:a          read moment a as ⧗ⁿ            ⧗:a,b,c  push a, b, c
  ‹word›       a function name, mapped to a unique Runic name

Names follow Trith's own scope rules: each ⦃ starts an empty strand, a ⥀
exports every moment of its body, and the faces of ⋔ (3) and ⁇ (2) export
their common prefix.  A name that is not visible is an error.
"""
import re, sys

LINEAR = {'C'}  # names that hold owned arrays: reading one moves it out
SUP = str.maketrans('0123456789', '⁰¹²³⁴⁵⁶⁷⁸⁹')

def bt(n):
    d = []
    while n != 0:
        r = n % 3
        if r == 0: d.append('○'); n //= 3
        elif r == 1: d.append('△'); n = (n - 1) // 3
        else: d.append('▽'); n = (n + 1) // 3
    return ''.join(d) or '○'

class Scope:
    def __init__(self, kind):
        self.kind = kind      # 'fn', 'loop', 'face'
        self.names = []       # oldest first; None for anonymous moments
        self.group = None     # for faces: the group being filled

class Group:
    def __init__(self, n):
        self.n = n
        self.faces = []       # lists of names

FILES = []  # (path, first line, line count)

def fail(lineno, msg):
    for path, first, n in FILES:
        if first <= lineno < first + n:
            sys.exit(f'{path}:{lineno - first + 1}: {msg}')
    sys.exit(f'trx:{lineno}: {msg}')

def process(src):
    out_lines = []
    stack = []          # scopes
    pending = []        # stack of (scope, group) awaiting faces
    prev = None
    tok_re = re.compile(r'\$[^$\n]*\$|»[^«\n]*«\S*|\S+|\s+')

    def finish_face(scope_of_group, group, names):
        group.faces.append(names)
        if len(group.faces) == group.n:
            pending.pop()
            m = min(len(f) for f in group.faces)
            for i in range(m):
                ns = {f[i] for f in group.faces}
                scope_of_group.names.append(group.faces[0][i] if len(ns) == 1 else None)

    for lineno, line in enumerate(src.split('\n'), 1):
        out = []
        for t in tok_re.findall(line):
            if t.isspace():
                out.append(t); continue
            if t == '⍝':
                idx = line.index('⍝', sum(len(x) for x in out))
                out.append(line[idx:]); break
            r = t
            awaiting = pending and pending[-1][0] is (stack[-1] if stack else None)
            if t == '⦃':
                if not stack:
                    stack.append(Scope('fn'))
                elif prev == '⥀':
                    stack.append(Scope('loop'))
                elif awaiting:
                    s = Scope('face'); s.group = pending[-1]; stack.append(s)
                else:
                    fail(lineno, 'block in an unknown context')
            elif t == '⦄':
                s = stack.pop()
                if s.kind == 'loop':
                    stack[-1].names.extend(s.names)
                elif s.kind == 'face':
                    finish_face(s.group[0], s.group[1], s.names)
            elif t in ('⁼', '∅') and awaiting:
                sc, g = pending[-1]
                if t == '⁼':
                    if not g.faces: fail(lineno, 'first face cannot be ⁼')
                    finish_face(sc, g, list(g.faces[-1]))
                else:
                    finish_face(sc, g, [])
            elif t.startswith('⋔') and stack:
                pending.append((stack[-1], Group(3)))
            elif t.startswith('⁇') and stack:
                pending.append((stack[-1], Group(2)))
            elif t == '⧖':
                stack[-1].names.append(None)
            elif t.startswith('⧖:'):
                names = t[2:].split(',')
                stack[-1].names.extend(reversed(names))
                r = ' '.join(['⧖'] * len(names))
            elif t.startswith('⧗:'):
                rs = []
                for nm in t[2:].split(','):
                    ns = stack[-1].names
                    for i in range(len(ns) - 1, -1, -1):
                        if ns[i] == nm:
                            rs.append('⧗' + str(len(ns) - 1 - i).translate(SUP))
                            if nm in LINEAR:
                                ns[i] = '(moved ' + nm + ')'
                            break
                        if ns[i] == '(moved ' + nm + ')':
                            fail(lineno, f'moment {nm} was already moved out (it holds an owned array)')
                    else:
                        fail(lineno, f'moment {nm} is not visible here')
                r = ' '.join(rs)
            elif t in ('⸫',) and stack:
                fail(lineno, 'unclosed block')
            out.append(r)
            prev = t
        out_lines.append(''.join(out))
    return '\n'.join(out_lines)

def literals(src):
    def anyof(m):
        xs = [int(x) for x in m.group(1).split(',')]
        parts = [f'⧗⁰ {bt(xs[0])} ᛖ'] + [f'⧗⁰ {bt(x)} ᛖ ⋏' for x in xs[1:]]
        return ' '.join(parts)
    src = re.sub(r'@any\(([-\d,]+)\)@', anyof, src)
    def strlit(m):
        t = m.group(1).replace('\\n', '↵')
        # reverse by cluster: a combining mark stays after its base
        return '»' + ''.join(re.findall(r'.[\u0300-\u036f]*', t)[::-1]) + '«'
    src = re.sub(r'\$([^$\n]*)\$', strlit, src)
    src = re.sub(r'#(-?\d+)#', lambda m: bt(int(m.group(1))), src)
    return re.sub(r'‹([^›\s]+)›', runic, src)

PREFIXES = list('ᚡᚣᚤᚥᚧ')  # never used as names on their own
PREFIXES += [a + b for a in 'ᚡᚣᚤᚥᚧ' for b in 'ᚡᚣᚤᚥᚧ']
RUNES = [chr(c) for c in range(0x16A0, 0x16EB) if c not in (0x16A1, 0x16A3)]
NAMES = {}
def runic(m):
    nm = m.group(1)
    if nm not in NAMES:
        i = len(NAMES)
        NAMES[nm] = PREFIXES[i // len(RUNES)] + RUNES[i % len(RUNES)]
    return NAMES[nm]

if __name__ == '__main__':
    parts = []
    line = 1
    for p in sys.argv[1:]:
        text = open(p).read() + '\n'
        FILES.append((p, line, text.count('\n')))
        line += text.count('\n')
        parts.append(text)
    src = ''.join(parts)
    sys.stdout.write(literals(process(src)))
