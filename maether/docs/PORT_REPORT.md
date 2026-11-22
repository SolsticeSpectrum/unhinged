# mAether port report (phone version)

## TL;DR
Server boots on **26.3**, `./gradlew build` ✔, Aether dimension generates with ores+trees, portal works server-side, 28 blocks / 24 items / 4 mobs registered with Aether models in the Polymer pack. **Vanilla-protocol join test now done with a raw 26.3 client (see below); a real rendering client was still not possible.**

Repo: `Codename-Kestrel/mAether` **did not exist** and I didn't create it. Code is in `/home/user/mAether` (branch `feat/polymer-port`, 6 commits) and a code-only copy (no Aether assets) is on branch `claude/aether-polymer-port-hl2v2d` of `unhinged` under `maether/`. **No PR opened** (no repo). Create the repo, push the branch, open the draft PR.

## What works (✔ verified by log/console)
- Build + boot, no mod ERROR/WARN in log (only offline-mode WARN from my test config; Mojang service lookups fail in sandbox).
- Polymer pack generated: 0.79 MB, contains Aether textures/models/lang/items.
- Dimension `aether:the_aether`: islands ≈12% solid (160k holystone in 128×128×96), aether grass/dirt, **ores: 2037 ambrosium, 409 zanite, 191 gravitite**, skyroot trees (318 logs, 3355 leaves) in the sampled area.
- Portal: glowstone frame detected, lit (dev command `/maether light`, same code as the bucket handler), pig teleported, Aether-side platform+frame+portal auto-built.
- Tools (skyroot/holystone/zanite/gravitite × 5) + recipes, block loot tables, tags, entity loot; summon of all 4 mobs OK.

## Partial
- Sky/fog/cloud colours are guesses; portal looks like a purple nether portal; mobs look like vanilla pig/cow/rabbit/slime.
- Leaves don't decay; grass has no snowy state; tool stats approximated; mining tiers use vanilla `incorrect_for_*` tags.
- Natural mob spawning configured but only confirmed via `/summon`.

## Join test (added after you suggested mineflayer)
mineflayer/minecraft-protocol only support up to 26.1 (26.3 = protocol 777), so I wrote a minimal raw client (`tools/raw_client.js`, driver `tools/vanilla_join_test.sh`). ✔ **Found and fixed a real release blocker:** Fabric registry sync kicked vanilla clients ("requires Fabric Loader and Fabric API… namespace `aether`") because the 4 entity types were not registered with `PolymerEntityUtils.registerType`. After the fix the client: logs in, answers config pings, requests registries with *no known packs* (full registry data incl. our dimension type/biome, 32 packets), downloads the pack from Polymer autohost (825 KB, HTTP 200), reaches play, receives ~2.5-3.7k play packets, survives teleports `overworld ↔ aether:the_aether`, server-side block edits, and is never disconnected by the server (only by my client's own timer).
Caveats: ids found empirically (26.3 config ids differ from 26.1); the client does **not decode** registry NBT or render, so it cannot prove a real client accepts our `dimension_type`/`biome` JSON; no keep-alive replies (scenario < 30 s); no movement packets, so a **player walking into the portal is still untested** (the check only runs when a player moves; a pig did go through).

## NOT tested (be sceptical)
- ✘ A real (decoding/rendering) 26.3 client: client-side decoding of our `dimension_type`/`biome`, how blocks/items/mobs actually look, resource pack apply. Next: a real client on a dev server, or extend the raw client with Minecraft's own codecs.
- ✘ Real water-bucket click, portal travel by a walking player (80-tick timer, overlay), return trip, client-side break/place packets, pack download via `kestrel:upload` (config-only, per its README).

## Cut (and why)
Bosses, dungeons, armor, accessories, GUIs, Moa/Sheepuff/Aerwhale/Zephyr/Cockatrice, block families, saplings/flowers, other biomes/structures, shaders/HUD: too large for one unattended pass; need real-client verification first. Inventory in `docs/SCOPING.md`.

## Decisions I made without you
1. Fork source = official Aether code only; Fabric ports **not surveyed**.
2. Asset permission taken from your message; recorded in `docs/PERMISSION.md` as *verbal, needs written proof*.
3. Rewrote server core instead of porting NeoForge code; **converted** data to 26.3 via `tools/gen_data.py` instead of copying.
4. Polymer 0.18.7+26.3 / Fabric API 0.166.2 (match `kestrel-pack-upload`), not Polymania's `pb4` build. Java 25 installed via apt in the sandbox.
5. Created a personal environment "Kestrel mods" with hosts: maven.fabricmc.net, maven.nucleoid.xyz, piston-meta/-data.mojang.com, libraries.minecraft.net, resources.download.minecraft.net.
6. Pack is `markAsRequired()` (declined pack = kick); remove if you prefer optional.
7. Did **not** push Aether assets to the public `unhinged` repo (permission is for Kestrel only); `tools/import_aether_assets.py` re-imports them from the upstream checkout.
8. Dev-only `/maether` commands (only in dev env).

## From Polymer docs (you sent the link)
Polymer has per-type block-state limits (slabs only 5, leaves ~52, full blocks ~1149). Fine for now; the cut block families will need the factorytools/display approach from `mPolymerPatchBundle`. Polymer has no vanilla-client test harness I could find (only an in-repo test mod).

## Open questions
- Written permission from Aether devs? Who holds it?
- Create `mAether` yourself or let me? Keep pack required?
- Any existing Fabric Aether port worth comparing?
- Do you want upstream-faithful Aether sky colours (needs a look in a real client)?

## Suggested next step
1. Create `Codename-Kestrel/mAether`, push `feat/polymer-port`, open draft PR.
2. Join with a real 26.3 client on a dev server; walk the portal; place/break; fix registry-sync issues first.
3. Then: block families + leaves decay, then Moa/Sheepuff with display-entity models, then GUIs via sgui.

## Reproduce
`./gradlew build` · `tools/import_aether_assets.py <the-aether checkout> tools/blocks.txt tools/items.txt` · `tools/gen_data.py <the-aether checkout> <minecraft-merged.jar>` · `tools/run_boot_test.sh <log>` / `tools/mc_console.sh`.
