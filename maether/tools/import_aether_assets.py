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


# ---- block families (stairs/slab/...): blockstates + pre-expanded models (display models must cover the hitbox block underneath)
import zipfile
if len(sys.argv) > 5:
    fams = [l.split() for l in open(sys.argv[4]) if l.strip() and not l.startswith("#")]
    vjar = zipfile.ZipFile(sys.argv[5])
    E = 0.08
    (dst_a/"blockstates").mkdir(parents=True, exist_ok=True)
    done = set()
    def expand_els(m):
        for el in m.get("elements", []):
            el["from"] = [v - E for v in el["from"]]; el["to"] = [v + E for v in el["to"]]
        return m
    def tpl(ref):
        """vanilla parent -> expanded copy under aether:block/_t/..."""
        name = ref.split(":")[-1]
        if name.startswith("builtin/"): return ref
        out = dst_a/"models"/f"{name.replace('block/', 'block/_t/', 1)}.json"
        if out not in done:
            done.add(out)
            m = json.loads(vjar.read(f"assets/minecraft/models/{name}.json"))
            if "parent" in m: m["parent"] = tpl(m["parent"])
            out.parent.mkdir(parents=True, exist_ok=True); out.write_text(json.dumps(expand_els(m)))
        return "aether:" + name.replace("block/", "block/_t/", 1)
    def fix(modelid):
        path = dst_a/"models"/(modelid.split(":")[-1] + ".json")
        if path in done: return
        done.add(path)
        m = json.loads(path.read_text())
        par = m.get("parent", "")
        if par.startswith("minecraft:") or (par and ":" not in par): m["parent"] = tpl(par if ":" in par else "minecraft:" + par)
        elif par.startswith("aether:"): fix(par)
        path.write_text(json.dumps(expand_els(m)))
    for name, *_ in fams:
        bs = json.loads((gen_a/"blockstates"/f"{name}.json").read_text())
        (dst_a/"blockstates"/f"{name}.json").write_text(json.dumps(bs))
        refs = []
        for v in bs.get("variants", {}).values(): refs += v if isinstance(v, list) else [v]
        for part in bs.get("multipart", []):
            a = part["apply"]; refs += a if isinstance(a, list) else [a]
        for r in refs: fix(r["model"])
        (dst_a/"items"/f"{name}.json").write_text(json.dumps({"model": {"type": "minecraft:model", "model": f"aether:item/{name}"}}))
    for n in names:
        b = n.split()[0]
        (dst_a/"blockstates"/f"{b}.json").write_text((gen_a/"blockstates"/f"{b}.json").read_text())
    print("families", len(fams))


# ---- armor: 1.21.1 layer textures -> 26.x equipment assets
arm = src/"main/resources/assets/aether/textures/models/armor"
for sets in ("zanite", "gravitite", "valkyrie", "neptune", "phoenix", "obsidian", "sentry"):
    l1, l2 = arm/f"{sets}_layer_1.png", arm/f"{sets}_layer_2.png"
    layers = {}
    if l1.exists():
        d = dst_a/"textures/entity/equipment/humanoid"; d.mkdir(parents=True, exist_ok=True); shutil.copy(l1, d/f"{sets}.png")
        layers["humanoid"] = [{"texture": f"aether:{sets}"}]
    if l2.exists():
        d = dst_a/"textures/entity/equipment/humanoid_leggings"; d.mkdir(parents=True, exist_ok=True); shutil.copy(l2, d/f"{sets}.png")
        layers["humanoid_leggings"] = [{"texture": f"aether:{sets}"}]
    (dst_a/"equipment").mkdir(exist_ok=True)
    (dst_a/"equipment"/f"{sets}.json").write_text(json.dumps({"layers": layers}))
print("armor sets done")


# ---- spawn egg tints (colors are hard-coded in upstream Java)
java = (src/"main/java/com/aetherteam/aether/item/AetherItems.java").read_text()
for name, c1, c2 in re.findall(r'register\("(\w+_spawn_egg)",\s*\(\) -> new DeferredSpawnEggItem\(\w+\.\w+, (0x\w+), (0x\w+)', java):
    (dst_a/"items"/f"{name}.json").write_text(json.dumps({"model": {"type": "minecraft:model", "model": f"aether:item/{name}",
        "tints": [{"type": "minecraft:constant", "value": int(c1, 16)}, {"type": "minecraft:constant", "value": int(c2, 16)}]}}))


# ---- plant/torch blockstates (display-model blocks need their blockstate in the pack)
for n in ("purple_flower", "white_flower", "skyroot_sapling", "golden_oak_sapling", "berry_bush", "berry_bush_stem", "ambrosium_torch", "ambrosium_wall_torch"):
    (dst_a/"blockstates"/f"{n}.json").write_text((gen_a/"blockstates"/f"{n}.json").read_text())
    (dst_a/"items"/f"{n}.json").write_text(json.dumps({"model": {"type": "minecraft:model", "model": f"aether:item/{n}"}}))
