#!/usr/bin/env python3
"""Download Polymania's server-side mods (packwiz .pw.toml files) into run/mods for a combined-pack test.
usage: polymania_fetch.py <mpolymania checkout>/pack <out dir>   (needs cdn.modrinth.com)"""
import tomllib, glob, os, hashlib, urllib.request, sys, concurrent.futures as cf
pack, out = sys.argv[1], sys.argv[2]; os.makedirs(out, exist_ok=True)
jobs = []
for f in sorted(glob.glob(os.path.join(pack, "mods/*.pw.toml"))):
    d = tomllib.load(open(f, "rb"))
    if d.get("side") == "client": continue
    dl = d["download"]; jobs.append((d["filename"], dl["url"], dl["hash-format"], dl["hash"]))
def get(j):
    fn, url, hf, h = j
    for _ in range(3):
        try:
            data = urllib.request.urlopen(url, timeout=90).read()
            assert hashlib.new(hf, data).hexdigest() == h
            open(os.path.join(out, fn), "wb").write(data); return True
        except Exception: pass
    return False
with cf.ThreadPoolExecutor(6) as ex: ok = list(ex.map(get, jobs))
print(sum(ok), "/", len(jobs), "downloaded")
