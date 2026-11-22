#!/usr/bin/env python3
"""Copy Aether assets/data (LGPL code-generated data + All-Rights-Reserved assets,
used with permission, non-commercial only: see docs/PERMISSION.md) into src/main/resources.
Usage: import_aether_assets.py <the-aether checkout> <block names file>"""
import json, re, shutil, sys, os, pathlib
src = pathlib.Path(sys.argv[1]) / "src"
names = [l.strip() for l in open(sys.argv[2]) if l.strip() and not l.startswith("#")]
items = [l.strip() for l in open(sys.argv[3]) if l.strip() and not l.startswith("#")] if len(sys.argv) > 3 else []
known = {n.split()[0] for n in names} | set(items)
out = pathlib.Path(__file__).resolve().parent.parent / "src/main/resources"
gen_a, main_a = src/"generated/resources/assets/aether", src/"main/resources/assets/aether"
dst_a = out/"assets/aether"
# textures: block + item textures wholesale (small), keep upstream layout
for sub in ("block", "item"):
    shutil.copytree(main_a/"textures"/sub, dst_a/"textures"/sub, dirs_exist_ok=True)
# models
for sub in ("block", "item"):
    shutil.copytree(gen_a/"models"/sub, dst_a/"models"/sub, dirs_exist_ok=True)
# lang (names reach vanilla clients through the pack); add keys for our own item tags
(dst_a/"lang").mkdir(parents=True, exist_ok=True)
lang = json.loads((gen_a/"lang/en_us.json").read_text())
for t in ("skyroot", "holystone", "zanite", "gravitite"):
    lang[f"tag.item.aether.{t}_tool_materials"] = f"{t.capitalize()} Tool Materials"
(dst_a/"lang/en_us.json").write_text(json.dumps(lang, indent=2, ensure_ascii=False))
# item definitions (26.x client item format) for every registered block item
(dst_a/"items").mkdir(parents=True, exist_ok=True)
for n in names + items:
    base = n.split()[0]
    (dst_a/"items"/f"{base}.json").write_text(json.dumps(
        {"model": {"type": "minecraft:model", "model": f"aether:item/{base}"}}))
