# mAether — Phase 1 scoping (Polymer port of The Aether)

Status: written first from desk research, then **updated with what the implementation proved** (marked ✔ verified / ✘ not verified).
Target: Minecraft **26.3**, Fabric loader 0.19.5, Polymer 0.18.7+26.3, Java 25 (same as `kestrel-pack-upload`).

## 1. Source and license
| Candidate | Loader / MC | Code | Assets | Verdict |
|---|---|---|---|---|
| The-Aether-Team/The-Aether (official) | NeoForge 1.21.1, v1.5.10 | LGPL-3.0 | All Rights Reserved | **Chosen** (only complete implementation) |
| Fabric ports of the Aether | — | — | — | **Not surveyed** (web search was interrupted). Open question |

- Code: LGPL-3.0 allows fork/port/run. We keep LICENSE, add NOTICE with our changes.
- Assets: All Rights Reserved. **Permission from the Aether devs (relayed by the project owner, verbal): allowed if never monetized.** Binding rules: never sell access to the Aether; no Aether-specific monetized cosmetics; no Aether branding. See `docs/PERMISSION.md`; **get it in writing**.
- Cost of NeoForge → Fabric: not a port, a rewrite. Upstream is ~800 Java files on NeoForge APIs (+Accessories dep). We rewrote only the server-side core against Fabric+Polymer and **converted data** instead of copying it (see §3).

## 2. Inventory and classification (final)
A = Polymer as-is · B = needs Polymer patch · C = creative workaround · D = cut

| Area | Item | Class | Result |
|---|---|---|---|
| Dimension | islands, biomes, sky | A | done (sky/fog/cloud via dimension_type attributes) |
| Portal | glowstone frame + water bucket | A/C | done, round trip verified; shown as vanilla nether portal |
| Worldgen | ores, trees, flowers, clouds, berries | A | done |
| Worldgen | dungeons (3 tiers) | C | done with guessed connectors (upstream assembly code not portable) |
| Blocks | cubes, logs, leaves, clouds, glass, dungeon blocks | A | done |
| Blocks | stairs/slabs/walls/fences/doors/... | C | hitbox block + factorytools display models (Kestrel convention) |
| Blocks | plants, torch | C | empty polymer plant state / vanilla torch hitbox + display model |
| Blocks | machines (altar/freezer/incubator) | A + GUI | block entities + sgui |
| Blocks | signs, beds, potted plants, present, panes | D | not done |
| Items | tools/weapons/armor/food/accessories/darts/buckets | A/C | done (armor uses 26.x equipment assets) |
| Items | boats, music discs, other buckets | D | not done |
| Mobs | 20 mobs + 3 bosses | C | vanilla-base Polymer entities |
| Client-only | shaders, HUD, cape rendering, custom models | D | cut |
| B (Polymer patch) | none needed; one vanilla access widener (SpawnPlacements) |

## 3. Key findings that changed the plan (26.3 vs upstream 1.21.1 data)
1. **Upstream data JSON is not loadable as-is.** Loot tables, recipes, density functions, noise settings, surface rules, block-state objects, features and dimension types all changed schema (e.g. `conditions`→`condition`, `argument1`→`left`, `surface_rule`→registry `material_rule`, `{"Name"}`→`{"id"}`, `effects`→`attributes`). Old loot JSON was *silently half-ignored* (WARN "unreachable entry"). → `tools/gen_data.py` regenerates/converts into 26.3 format. **Any re-port to a newer MC must re-run/adjust it.**
2. **26.x drives behavior from block tags.** Custom blocks must join `blocks_motion_no_leaves`, `leaves`, `logs`, `mineable/*`, `animals_spawnable_on`, `dirt` … Without the heightmap tag, `OCEAN_FLOOR*`/`MOTION_BLOCKING` heightmaps were 0 and **vanilla ores/trees placement silently produced nothing**.
3. Terrain density needed calibration (`AETHER_NOISE_BIAS=0.15`): converted noise gave ~1.7% solid, now ≈12%.
4. **Every custom `EntityType` must be registered with `PolymerEntityUtils.registerType`** or Fabric registry sync kicks vanilla clients (caught by the join test). Blocks/items are covered by implementing `PolymerBlock`/`PolymerItem`.
5. Registries moved: `EntityType.PIG`→`EntityTypes.PIG`, `Slime`→`monster.cubemob`, `SpawnPlacements.register` is private (access widener).

6. **Polymer block-state budgets (from Polymer docs `polymer-blocks/basics.md`; verify against 0.18.7):** FULL_BLOCK ≈1149, leaf-type ≈52, top/bottom slab 5 each, plants 7, trapdoors 20/orientation. Current use is tiny (≈31 full-block states, 3 leaf states) but Aether has ~15 slab/stair/wall families → **slabs/stairs/walls/doors can't all use pooled states**; use the `factorytools` `BlockStateModelManager` / display-element approach that `mPolymerPatchBundle` uses for these.

## 4. Approach for (C) items
- Sky/clouds → dimension_type attributes. Portal → subclass of `NetherPortalBlock`, shown as nether portal. Mobs → vanilla-subclass + `PolymerEntity` (v1: vanilla model). Accessories/GUIs → later behind an interface.

## 5. Effort (one dev, remaining)
| Milestone | Estimate |
|---|---|
| Real-client verification (join, portal, break/place), fixes | 2–4 days |
| Block families (stairs/slabs/doors…), saplings, aerclouds, leaves decay | 1–1.5 weeks |
| Remaining mobs w/ custom models (display-entity models), Moa mount | 1–2 weeks |
| Armor, accessories (slot container), GUIs via sgui | 1–1.5 weeks |
| Dungeons + 3 bosses | 3–4 weeks |
