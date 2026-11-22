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

## 2. Inventory and classification
A = Polymer as-is · B = needs Polymer patch · C = creative workaround · D = cut from v1

| Area | Item | Class | Status |
|---|---|---|---|
| Dimension | `aether:the_aether`, islands via noise, holystone/grass/dirt | A | ✔ generates (≈12% solid in y0-95) |
| Dimension | Sky, fog, clouds | **A** (was C) | ✔ 26.3 `dimension_type.attributes` set sky/fog/cloud colour+height in vanilla data; colours are approximations ✘ (no client look) |
| Portal | Glowstone frame + water bucket | A/C | ✔ frame detection, lighting, teleport + destination build (pig test); ✘ real bucket click, ✘ return trip; visuals = vanilla purple nether portal |
| Worldgen | Ores (ambrosium/zanite/gravitite), skyroot trees | A | ✔ natural gen verified (counts in report) |
| Worldgen | Other biomes, golden oak, crystal islands, lakes, 4 dungeon structures, flowers | D | cut |
| Blocks | 28 full-cube/log/leaf blocks | A | ✔ registered, models in pack |
| Blocks | Stairs/slabs/walls/doors/signs/beds, saplings, flowers, bushes, aerclouds (bounce), quicksoil physics, floating gravitite, altars/freezer/incubator, dungeon doors/traps | D/C | cut for v1 |
| Items | 20 tools (4 tiers) + 4 materials | A | ✔ with recipes; tool stats approximated |
| Items | Armor, accessories, darts, lightning knife, hammer, shields, parachute, buckets | D | cut |
| Mobs | Phyg, Flying Cow, Aerbunny (passive), Blue Swet (hostile) | C | ✔ summon + attributes; **vanilla look** (pig/cow/rabbit/slime) |
| Mobs | Moa, Sheepuff, Aerwhale, Zephyr, Cockatrice, Aechor Plant, whirlwinds | D | cut |
| Bosses | Slider, Valkyrie Queen, Sun Spirit + dungeons | D | cut |
| GUIs | Altar, freezer, incubator, accessories | D | cut (planned: thin `AetherGui` interface → sgui, later heads GUI) |
| Client-only | Shaders, HUD, cosmetics, music manager, config UI, JEI | D | cut |
| B (Polymer patch) | — | — | **None needed so far.** Only a vanilla access widener (`SpawnPlacements.register`) |

## 3. Key findings that changed the plan (26.3 vs upstream 1.21.1 data)
1. **Upstream data JSON is not loadable as-is.** Loot tables, recipes, density functions, noise settings, surface rules, block-state objects, features and dimension types all changed schema (e.g. `conditions`→`condition`, `argument1`→`left`, `surface_rule`→registry `material_rule`, `{"Name"}`→`{"id"}`, `effects`→`attributes`). Old loot JSON was *silently half-ignored* (WARN "unreachable entry"). → `tools/gen_data.py` regenerates/converts into 26.3 format. **Any re-port to a newer MC must re-run/adjust it.**
2. **26.x drives behavior from block tags.** Custom blocks must join `blocks_motion_no_leaves`, `leaves`, `logs`, `mineable/*`, `animals_spawnable_on`, `dirt` … Without the heightmap tag, `OCEAN_FLOOR*`/`MOTION_BLOCKING` heightmaps were 0 and **vanilla ores/trees placement silently produced nothing**.
3. Terrain density needed calibration (`AETHER_NOISE_BIAS=0.15`): converted noise gave ~1.7% solid, now ≈12%.
4. Registries moved: `EntityType.PIG`→`EntityTypes.PIG`, `Slime`→`monster.cubemob`, `SpawnPlacements.register` is private (access widener).

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
