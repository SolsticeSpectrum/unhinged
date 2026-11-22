#!/usr/bin/env python3
"""Generate 26.3-format data for mAether into src/main/resources/data/aether.
Upstream Aether data is 1.21.1 format (worldgen/loot schema changed in 26.x), so it is converted/regenerated, not copied.
Usage: gen_data.py <the-aether checkout> <minecraft-merged.jar>"""
import json, sys, zipfile, pathlib, copy
up = pathlib.Path(sys.argv[1]) / "src/generated/resources/data/aether"
jar = zipfile.ZipFile(sys.argv[2])
root = pathlib.Path(__file__).resolve().parent.parent
out = root / "src/main/resources/data/aether"

def w(rel, obj):
    p = out / rel; p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(json.dumps(obj, indent=2) + "\n")

def vanilla(rel): return json.loads(jar.read("data/minecraft/" + rel))

def strip_props(o):
    """26.3 block-state format: "ns:id" string, or {"id","properties"}. Also drops upstream-only properties we do not implement."""
    if isinstance(o, dict):
        if "Name" in o:
            name = o["Name"]
            props = dict(o.get("Properties", {}))
            props.pop("double_drops", None)
            if name == "aether:aether_grass_block": props.pop("snowy", None)
            return {"id": name, "properties": props} if props else name
        return {k: strip_props(v) for k, v in o.items()}
    if isinstance(o, list): return [strip_props(x) for x in o]
    return o

BIN = {"minecraft:add", "minecraft:mul", "minecraft:min", "minecraft:max"}
def conv_df(o):
    if isinstance(o, list): return [conv_df(x) for x in o]
    if not isinstance(o, dict): return o
    o = {k: conv_df(v) for k, v in o.items()}
    t = o.get("type")
    if t in BIN:
        o["left"] = o.pop("argument1"); o["right"] = o.pop("argument2")
    elif "argument" in o:
        o["input"] = o.pop("argument")
    if t == "minecraft:interpolated":
        o["cell_size_xz"] = 8; o["cell_size_y"] = 4
    if t == "minecraft:y_clamped_gradient":
        o = {"type": "minecraft:gradient", "axis": "y", "from_coordinate": o["from_y"], "to_coordinate": o["to_y"],
             "from_value": o["from_value"], "to_value": o["to_value"]}
    return o

# --- terrain: noise settings + material rule
ns = json.load(open(up / "worldgen/noise_settings/skylands.json"))
router = ns["noise_router"]
NOISE_BIAS = float(__import__("os").environ.get("AETHER_NOISE_BIAS", "0.15"))  # calibrates island density on 26.3
final = conv_df(strip_props(router["final_density"]))
def bias(o):
    if isinstance(o, dict): return {k: bias(v) for k, v in o.items()}
    if isinstance(o, list): return [bias(x) for x in o]
    return o + NOISE_BIAS if o == -0.13 else o
final = bias(final)
w("worldgen/density_function/base_3d_noise_aether.json", json.load(open(up / "worldgen/density_function/base_3d_noise_aether.json")))
w("worldgen/material_rule/the_aether.json", strip_props(ns["surface_rule"]))
w("worldgen/noise_settings/skylands.json", {
    "default_block": strip_props(ns["default_block"]),
    "default_fluid": "minecraft:air",
    "disable_mob_generation": False, "legacy_random_source": False,
    "material_rule": "aether:the_aether",
    "noise": {"height": ns["noise"]["height"], "min_y": ns["noise"]["min_y"]},
    "noise_router": {"chunk_surface_level": 0.0, "continents": 0.0, "depth": 0.0, "erosion": 0.0,
                     "final_density": final, "ridges": 0.0, "temperature": 0.0, "vegetation": 0.0},
    "sea_level": ns["sea_level"], "spawn_target": []})

# --- dimension type: vanilla overworld shape + Aether sky (attributes replace the old client "effects")
dt = vanilla("dimension_type/overworld.json")
dt.update({"min_y": 0, "height": 256, "logical_height": 256, "has_ceiling": False, "has_skylight": True})
a = dt["attributes"]
a["minecraft:visual/sky_color"] = "#a8c8ff"
a["minecraft:visual/fog_color"] = "#dbe9ff"
a["minecraft:visual/cloud_color"] = "#ccffffff"
a["minecraft:visual/cloud_height"] = 40.0
a["minecraft:gameplay/respawn_anchor_works"] = False
a["minecraft:gameplay/nether_portal_spawns_piglin"] = False
w("dimension_type/the_aether.json", dt)

# --- biome: vanilla plains skeleton, no carvers/features yet, only passive vanilla fallbacks (custom mobs come later)
b = vanilla("worldgen/biome/plains.json")
b["carvers"] = []
b["features"] = [[] for _ in b["features"]]
w("tags/block/ore_replaceables.json", {"values": ["aether:holystone", "aether:mossy_holystone"]})
def ore(name, block, size, count, ymax, target=None):
    w(f"worldgen/feature/{name}.json", {"type": "minecraft:ore", "discard_chance_on_air_exposure": 0.0, "size": size,
        "targets": [{"state": block, "target": target or {"predicate_type": "minecraft:block_match", "block": "aether:holystone"}}]})
    w(f"worldgen/placed_feature/{name}.json", {"feature": f"aether:{name}", "placement": [
        {"type": "minecraft:count", "count": count}, {"type": "minecraft:in_square"},
        {"type": "minecraft:height_range", "height": {"type": "minecraft:uniform", "min_inclusive": {"absolute": 0}, "max_inclusive": {"absolute": ymax}}},
        {"type": "minecraft:biome"}]})
ore("ore_ambrosium", "aether:ambrosium_ore", 16, 20, 127, None)
ore("ore_zanite", "aether:zanite_ore", 8, 15, 127, None)
ore("ore_gravitite", "aether:gravitite_ore", 6, 8, 127)
w("worldgen/feature/skyroot_tree.json", {"type": "minecraft:tree",
    "below_trunk_provider": {"id": "aether:aether_dirt"},
    "decorators": [], "ignore_vines": True,
    "foliage_placer": {"type": "minecraft:blob_foliage_placer", "height": 3, "offset": 0, "radius": 2},
    "foliage_provider": {"id": "aether:skyroot_leaves"},
    "trunk_placer": {"type": "minecraft:straight_trunk_placer", "base_height": 4, "height_rand_a": 2, "height_rand_b": 0},
    "trunk_provider": {"id": "aether:skyroot_log", "properties": {"axis": "y"}},
    "minimum_size": {"type": "minecraft:two_layers_feature_size"}})
w("worldgen/placed_feature/skyroot_trees.json", {"feature": "aether:skyroot_tree", "placement": [
    {"type": "minecraft:count", "count": 2}, {"type": "minecraft:in_square"},
    {"type": "minecraft:heightmap", "heightmap": "WORLD_SURFACE_WG"},
    {"type": "minecraft:block_predicate_filter", "predicate": {"type": "minecraft:matching_blocks", "blocks": "aether:aether_grass_block", "offset": [0, -1, 0]}},
    {"type": "minecraft:biome"}]})
b["features"][6] = ["aether:ore_ambrosium", "aether:ore_zanite", "aether:ore_gravitite"]
b["features"][9] = ["aether:skyroot_trees"]
spawns = b["attributes"]["minecraft:gameplay/natural_mob_spawns"]["argument"]["spawns_by_category"]
spawns.clear()
spawns["creature"] = [{"type": "aether:phyg", "count": 4, "weight": 10}, {"type": "aether:flying_cow", "count": 4, "weight": 10},
                      {"type": "aether:aerbunny", "count": 3, "weight": 10}, {"type": "aether:sheepuff", "count": 4, "weight": 10},
                      {"type": "aether:moa", "count": 3, "weight": 10}, {"type": "aether:whirlwind", "count": 1, "weight": 2}]
spawns["monster"] = [{"type": "aether:blue_swet", "count": 4, "weight": 20}, {"type": "aether:golden_swet", "count": 2, "weight": 5},
                     {"type": "aether:cockatrice", "count": 2, "weight": 10}, {"type": "aether:aechor_plant", "count": 2, "weight": 12},
                     {"type": "aether:zephyr", "count": 1, "weight": 3}, {"type": "aether:evil_whirlwind", "count": 1, "weight": 3}]
spawns["ambient"] = [{"type": "aether:aerwhale", "count": 1, "weight": 4}]
w("worldgen/biome/skyroot_meadow.json", b)

w("dimension/the_aether.json", {
    "type": "aether:the_aether",
    "generator": {"type": "minecraft:noise", "settings": "aether:skylands",
                  "biome_source": {"type": "minecraft:fixed", "biome": "aether:skyroot_meadow"}}})

# --- block tags: 26.x drives heightmaps / tool mining / spawning from tags, so our blocks must join the vanilla tags
blocks = [l.split() for l in open(root / "tools/blocks.txt") if l.strip() and not l.startswith("#")]
unbreakable = {l[0] for l in blocks if "unbreakable" in l}
cubes = [f"aether:{b[0]}" for b in blocks if b[1] != "leaves"]
leaves = [f"aether:{b[0]}" for b in blocks if b[1] == "leaves"]
logs = [f"aether:{n[0]}" for n in blocks if n[0].endswith(("_log", "_wood"))]
def tag(name, values): w_tag = out.parent / "minecraft/tags/block" / f"{name}.json"; w_tag.parent.mkdir(parents=True, exist_ok=True); w_tag.write_text(json.dumps({"values": values}, indent=2) + "\n")
tag("blocks_motion_no_leaves", cubes)          # heightmaps (OCEAN_FLOOR/MOTION_BLOCKING) and ore/tree placement
tag("leaves", leaves)
tag("logs", logs); tag("logs_that_burn", logs)
stone = [f"aether:{b[0]}" for b in blocks if b[2] == "stone" and b[0] not in unbreakable]
tag("mineable/pickaxe", stone)
tag("mineable/axe", logs + ["aether:skyroot_planks", "aether:skyroot_bookshelf"])
tag("mineable/shovel", ["aether:aether_dirt", "aether:aether_grass_block", "aether:enchanted_aether_grass_block", "aether:quicksoil"])
tag("mineable/hoe", leaves)
tag("needs_stone_tool", ["aether:zanite_ore", "aether:zanite_block"])
tag("needs_iron_tool", ["aether:gravitite_ore", "aether:enchanted_gravitite"])
tag("dirt", ["aether:aether_dirt", "aether:aether_grass_block", "aether:enchanted_aether_grass_block"])
tag("animals_spawnable_on", ["aether:aether_grass_block", "aether:enchanted_aether_grass_block"])
tag("replaceable_by_trees", leaves)

# --- item tags + recipes (26.3 schema)
def itag(name, values):
    f = out / "tags/item" / f"{name}.json"; f.parent.mkdir(parents=True, exist_ok=True); f.write_text(json.dumps({"values": values}, indent=2) + "\n")
TIERS = {"skyroot": "aether:skyroot_planks", "holystone": "aether:holystone", "zanite": "aether:zanite_gemstone", "gravitite": "aether:enchanted_gravitite"}
for t, mat in TIERS.items(): itag(f"{t}_tool_materials", [mat])
STICK = "aether:skyroot_stick"
SHAPES = {"pickaxe": ["XXX", " # ", " # "], "axe": ["XX", "X#", " #"], "shovel": ["X", "#", "#"], "sword": ["X", "X", "#"], "hoe": ["XX", " #", " #"]}
for t, mat in TIERS.items():
    for kind, pat in SHAPES.items():
        w(f"recipe/{t}_{kind}.json", {"type": "minecraft:crafting_shaped", "category": "equipment",
            "key": {"#": STICK, "X": f"#aether:{t}_tool_materials"}, "pattern": pat, "result": {"id": f"aether:{t}_{kind}"}})
w("recipe/skyroot_planks.json", {"type": "minecraft:crafting_shapeless", "category": "building", "group": "planks",
    "ingredients": ["aether:skyroot_log"], "result": {"id": "aether:skyroot_planks", "count": 4}})
w("recipe/skyroot_stick.json", {"type": "minecraft:crafting_shaped", "group": "sticks",
    "key": {"#": "aether:skyroot_planks"}, "pattern": ["#", "#"], "result": {"id": STICK, "count": 4}})
for blk, gem in (("zanite_block", "zanite_gemstone"), ("ambrosium_block", "ambrosium_shard")):
    w(f"recipe/{blk}.json", {"type": "minecraft:crafting_shaped", "category": "building", "key": {"#": f"aether:{gem}"},
        "pattern": ["###", "###", "###"], "result": {"id": f"aether:{blk}"}})
    w(f"recipe/{gem}_from_{blk}.json", {"type": "minecraft:crafting_shapeless", "category": "misc",
        "ingredients": [f"aether:{blk}"], "result": {"id": f"aether:{gem}", "count": 9}})

# --- block families: tags, loot, recipes
fams = [l.split() for l in open(root / "tools/families.txt") if l.strip() and not l.startswith("#")]
KIND_TAG = {"stairs": "stairs", "slab": "slabs", "wall": "walls", "fence": "fences", "gate": "fence_gates", "button": "buttons",
            "plate": "pressure_plates", "door": "doors", "trapdoor": "trapdoors"}
by_tag = {}
for name, kind, mat, hard, base in fams:
    by_tag.setdefault(KIND_TAG[kind], []).append(f"aether:{name}")
    if mat == "wood": by_tag.setdefault("wooden_" + KIND_TAG[kind], []).append(f"aether:{name}")
for t, v in by_tag.items(): tag(t, v)
tag("mineable/pickaxe", stone + [f"aether:{n}" for n, k, m, h, b in fams if m != "wood" and k not in ("button",)] )
tag("mineable/axe", logs + ["aether:skyroot_planks"] + [f"aether:{n}" for n, k, m, h, b in fams if m == "wood"])
tag("blocks_motion_no_leaves", cubes + [f"aether:{n}" for n, k, m, h, b in fams if k not in ("button", "plate")])
for name, kind, mat, hard, base in fams:
    item = {"type": "minecraft:item", "name": f"aether:{name}"}
    surv = {"type": "minecraft:survives_explosion"}
    if kind == "slab":
        item["modifier"] = [{"type": "minecraft:set_count", "count": 2, "condition": {"type": "minecraft:match_block", "blocks": f"aether:{name}", "state": {"type": "double"}}}, {"type": "minecraft:explosion_decay"}]
        pool = {"rolls": 1, "entries": [item]}
    elif kind == "door":
        item["condition"] = {"type": "minecraft:match_block", "blocks": f"aether:{name}", "state": {"half": "lower"}}
        pool = {"rolls": 1, "condition": surv, "entries": [item]}
    else:
        pool = {"rolls": 1, "condition": surv, "entries": [item]}
    w(f"loot_table/blocks/{name}.json", {"type": "minecraft:block", "random_sequence": f"aether:blocks/{name}", "pools": [pool]})
    ing = f"aether:{base}"; res = {"id": f"aether:{name}"}
    stick = "aether:skyroot_stick"
    rec = {"stairs": (["#  ", "## ", "###"], 4), "slab": (["###"], 6), "wall": (["###", "###"], 6), "plate": (["##"], 1),
           "door": (["##", "##", "##"], 3), "trapdoor": (["###", "###"], 2)}
    if kind in rec:
        pat, n = rec[kind]; res["count"] = n
        w(f"recipe/{name}.json", {"type": "minecraft:crafting_shaped", "category": "building", "key": {"#": ing}, "pattern": pat, "result": res})
    elif kind == "fence":
        w(f"recipe/{name}.json", {"type": "minecraft:crafting_shaped", "category": "misc", "key": {"#": stick, "W": ing}, "pattern": ["W#W", "W#W"], "result": {**res, "count": 3}})
    elif kind == "gate":
        w(f"recipe/{name}.json", {"type": "minecraft:crafting_shaped", "category": "redstone", "key": {"#": stick, "W": ing}, "pattern": ["#W#", "#W#"], "result": res})
    elif kind == "button":
        w(f"recipe/{name}.json", {"type": "minecraft:crafting_shapeless", "category": "redstone", "ingredients": [ing], "result": res})

# --- entity loot (26.3 schema)
def drop(entity, item, lo, hi):
    w(f"loot_table/entities/{entity}.json", {"type": "minecraft:entity", "random_sequence": f"aether:entities/{entity}",
        "pools": [{"rolls": 1, "entries": [{"type": "minecraft:item", "name": item,
                   "modifier": [{"type": "minecraft:set_count", "count": {"type": "minecraft:uniform", "min": lo, "max": hi}},
                                {"type": "minecraft:enchanted_count_increase", "enchantment": "minecraft:looting", "count": {"type": "minecraft:uniform", "min": 0.0, "max": 1.0}}]}]}]})
drop("phyg", "minecraft:porkchop", 1, 3); drop("flying_cow", "minecraft:beef", 1, 3)
drop("aerbunny", "minecraft:rabbit_hide", 0, 1); drop("blue_swet", "aether:swet_ball", 0, 2)
drop("sheepuff", "minecraft:white_wool", 1, 2); drop("moa", "minecraft:feather", 0, 2); drop("golden_swet", "aether:golden_amber", 0, 2)
drop("aechor_plant", "aether:aechor_petal", 1, 2); drop("cockatrice", "minecraft:feather", 0, 2); drop("fire_minion", "minecraft:blaze_powder", 0, 1)
drop("zephyr", "minecraft:snowball", 1, 4); drop("sentry", "aether:carved_stone", 0, 1)

# --- loot tables (26.3 schema), driven by tools/blocks.txt
def self_drop(name):
    return {"type": "minecraft:block", "random_sequence": f"aether:blocks/{name}",
            "pools": [{"rolls": 1, "condition": {"type": "minecraft:survives_explosion"},
                       "entries": [{"type": "minecraft:item", "name": f"aether:{name}"}]}]}
def ore_drop(name, item):
    return {"type": "minecraft:block", "random_sequence": f"aether:blocks/{name}",
            "pools": [{"rolls": 1, "entries": [{"type": "minecraft:alternatives", "children": [
                {"type": "minecraft:item", "condition": "minecraft:tool/can_silk_touch", "name": f"aether:{name}"},
                {"type": "minecraft:item", "name": f"aether:{item}",
                 "modifier": [{"type": "minecraft:apply_bonus", "enchantment": "minecraft:fortune", "formula": "minecraft:ore_drops"},
                              {"type": "minecraft:explosion_decay"}]}]}]}]}
def leaves_drop(name):
    keep = {"type": "minecraft:any_of", "terms": ["minecraft:tool/can_shear", "minecraft:tool/can_silk_touch"]}
    return {"type": "minecraft:block", "random_sequence": f"aether:blocks/{name}",
            "pools": [{"rolls": 1, "entries": [{"type": "minecraft:item", "condition": keep, "name": f"aether:{name}"}]},
                      {"rolls": 1, "condition": {"type": "minecraft:inverted", "term": keep},
                       "entries": [{"type": "minecraft:item", "name": "aether:skyroot_stick",
                                    "condition": {"type": "minecraft:table_bonus", "enchantment": "minecraft:fortune", "chances": [0.02, 0.022222223, 0.025, 0.033333335, 0.1]},
                                    "modifier": [{"type": "minecraft:set_count", "count": {"type": "minecraft:uniform", "min": 1, "max": 2}}]}]}]}
ORE = {"ambrosium_ore": "ambrosium_shard", "zanite_ore": "zanite_gemstone"}
for line in open(root / "tools/blocks.txt"):
    line = line.strip()
    if not line or line.startswith("#"): continue
    name, kind = line.split()[:2]
    if name in unbreakable: continue
    if name in ORE: w(f"loot_table/blocks/{name}.json", ore_drop(name, ORE[name]))
    elif kind == "leaves": w(f"loot_table/blocks/{name}.json", leaves_drop(name))
    elif name in ("aether_grass_block", "enchanted_aether_grass_block"): o = self_drop("aether_dirt"); w(f"loot_table/blocks/{name}.json", o)
    elif name == "gravitite_ore": w(f"loot_table/blocks/{name}.json", self_drop(name))  # needs zanite-tier tool; still drops itself
    else: w(f"loot_table/blocks/{name}.json", self_drop(name))
print("ok")
