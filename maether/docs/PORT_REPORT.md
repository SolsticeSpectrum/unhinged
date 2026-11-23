# mAether port report (phone version)

## TL;DR
Server-side Fabric + Polymer port of The Aether for vanilla **26.3** clients. Builds, boots clean (no mod ERROR/WARN), and a raw 26.3-protocol client joins, downloads the pack, changes dimension through the portal both ways and falls back out of the sky. **Not seen by a real rendering client**, so visuals are unverified.

**Repo:** `Codename-Kestrel/mAether` still doesn't exist (I can't create it). Code is in `/home/user/mAether` (`feat/polymer-port`) and a code-only copy (no Aether assets) is on `claude/aether-polymer-port-hl2v2d` of `unhinged` under `maether/`. **No PR opened.**

## What's in (all log/console verified unless noted)
| Area | Status |
|---|---|
| Dimension `aether:the_aether` | 4 temperature-banded biomes, floating islands (~12% solid), sky/fog/cloud colours via dimension_type attributes, aerclouds (cold/blue/golden) as floating puffs |
| Worldgen | ores (ambrosium/zanite/gravitite/icestone/quicksoil), skyroot / golden oak / crystal trees, flowers, berry bushes, tall grass, **3 dungeons** (bronze/silver/gold, upstream room templates + carved connectors) |
| Portal | glowstone frame + water bucket, destination auto-built, **round trip verified with a ticking raw client**, falling below y=-16 returns you to the overworld sky (verified) |
| Blocks | **115 / 131** upstream: cubes, logs/wood, leaves, clouds (bounce), glass, pillars, dungeon blocks, 32 stairs/slabs/walls/fences/gates/buttons/plates/doors/trapdoors (hitbox block + display model), saplings (grow into trees), flowers, berry bush, ambrosium torch, treasure chest, altar/freezer/incubator, rising gravitite |
| Items | **147 / 165** upstream: 4 tool tiers + valkyrie set, special weapons (flaming, lightning, holy, vampire, pig slayer, hammer, lightning knife), 6 armor sets + sentry boots with set bonuses, foods, healing items, parachutes, darts + shooters, phoenix bow, skyroot buckets (water/milk), keys/medals, 21 accessories, spawn eggs |
| Mobs | **all 20** upstream mobs (phyg, flying cow, aerbunny, sheepuff, moa (rideable horse base), aerwhale, zephyr, swets, cockatrice, aechor plant, whirlwinds, sentry, fire minion, valkyrie, mimic) + **3 bosses** (Slider, Valkyrie Queen, Sun Spirit: boss bars, attacks, open doorways + drop keys on death) |
| Progression | 14 advancements, dungeon keys -> treasure chest tiers, altar/freezer/incubator recipes converted from upstream, swet-ball / ambrosium block conversions |
| GUIs | sgui behind plain classes: `/accessories` (8 slots), altar / freezer / incubator screens |

## Verified vs not
**Verified (server log / raw protocol client):** clean boot; 1,564-file pack hosted by Polymer autohost and downloaded; registry sync + play for a vanilla-protocol client (no kick); portal both directions; void return; ore/tree/flower/cloud/dungeon counts; all mobs/bosses summon; loot, recipes, tags, advancements load.
**NOT verified (be sceptical):** anything a real client renders (display-entity models, armor/equipment assets, spawn egg tints, sky colours, tool/weapon item models); GUI clicking; machine processing; boss fights; accessory/armor effects; bucket/dart/bow behaviour; dungeon layouts (rooms are placed at guessed offsets and joined by carved tunnels, may look wrong); client decoding of our `dimension_type`/`biome` JSON.

## Not ported
Signs/hanging signs, beds, potted plants, present, quicksoil glass pane, aerogel stairs/wall (no upstream blockstates), skyroot boats, music discs (+ all custom sounds/music), 7 extra bucket types, portal-frame item, cloud/nature staff behaviours, life shard (item only), floating-block / crystal / minion / projectile helper entities, custom mob models (all mobs look like their vanilla base), shaders/HUD, Accessories cape rendering.

## Decisions I made without you
1. Rewrote the server core instead of porting NeoForge code; **upstream data is converted, not copied** (`tools/gen_data.py`) because 26.3 changed loot/recipe/worldgen/blockstate JSON.
2. Aether assets are used under the verbal non-commercial permission (`docs/PERMISSION.md`); never push assets to a public repo (snapshot script excludes them).
3. Block families follow `mPolymerPatchBundle` (vanilla hitbox + factorytools display models, 0.08 expansion done at import time).
4. Mobs use vanilla bases (Polymer entities); bosses: Slider is an invisible slime + cube display; others vanilla bases.
5. Dungeons: custom structure type placing upstream templates at fixed offsets (their own assembly code isn't portable).
6. Pack is `markAsRequired()`. Polymer 0.18.7 / Fabric API 0.166.2 (match `kestrel-pack-upload`).
7. Created personal env "Kestrel mods" (hosts: fabricmc, nucleoid, mojang libs); installed JDK 25 via apt.
8. `/maether` dev commands exist only in a dev environment.

## Open questions
- Written permission from the Aether devs? Remember: never sell Aether access, no Aether-specific monetized cosmetics.
- Create `mAether` yourself or let me? Keep the pack required?
- Want custom mob models (display-entity rigs) or are vanilla look-alikes OK for now?
- Music discs / sounds: worth the pack size?

## Suggested next steps
1. Create repo, push `feat/polymer-port`, open draft PR.
2. Join with a **real** client on a dev server: check skies, models, armor, GUIs, dungeon layouts; fix.
3. Then boats, signs, music, mob models.

## Reproduce / test
`./gradlew build` · `tools/import_aether_assets.py ...` · `tools/gen_data.py <upstream> <minecraft-merged.jar>` · `tools/vanilla_join_test.sh <server.log> <client.log>` (raw 26.3 client scenario) · `tools/mc_console.sh` for console probes · `tools/snapshot.sh` (code-only backup push).
