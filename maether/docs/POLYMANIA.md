# mAether alongside the Polymania pack

Tested by booting mAether in a dev server together with Polymania's server-side mods (`tools/polymania_fetch.py` +
`tools/poly_iter.py`), then joining with the raw 26.3-protocol client (`tools/vanilla_join_test.sh`).

## Result: mAether coexists; the pack itself is mid-upgrade
79 of Polymania's 86 mods plus mAether boot to `Done`, the merged resource pack builds (32 MB, ~60k files), and the
vanilla-protocol client joins and travels through the Aether portal. **No registry-sync, mixin, duplicate-id or namespace clash involves mAether.**

Polymer shared state budget (per `PolymerBlockResourceUtils.getBlocksLeft`), full pack + mAether:
| type | left | mAether uses |
|---|---|---|
| FULL_BLOCK | 655 (of ~1640) | ~95 (~6%) |
| LEAVES | 93 (of ~103) | ~9 |
| PLANT | 8 (of 8) | 0 (shared empty state) |
Everything else (stairs, slabs, walls, doors, plants, torches) uses factorytools display models and takes **no** Polymer states.

The Aether biomes are not in `#minecraft:is_overworld`, so Polymania's biome modifications / mob mods (Tom's Mobs, Friends & Foes,
Terrestria, TerraBlender, ...) do not leak into the Aether (log: "Applied 0 biome modifications to 0 of N new biomes" for our biomes).

## Things in the pack that did NOT load on 26.3 at this commit (not mAether)
Removed one at a time to get a clean boot; Polymania's own README says it is partway through the 26.2 -> 26.3 update.
- `cinderscapes` 6.1.0-alpha.2: requires Minecraft 26.2 (Kestrel's `mCinderscapes` fork is the 26.3 one)
- `chalk`: calls `PushReaction.DESTROY`, removed in 26.3
- `jsonpatcher` (legacy 26.2 jar): mixin into `MultiPackResourceManager` fails on 26.3 (use Kestrel's `mJsonPatcher`)
- `explorify`: older-format datapack fails to parse without jsonpatcher
- `blahaj-replushed`: **registry-sync kicks vanilla clients** (not polymerized for 26.3)
- `polydecorations`: occasional `ConcurrentModificationException` while loading (race in its `ModdedCompat$VirtualPackResources.hashCode`), ~50% of boots in this setup

## Suggestions
- `trinkets-polymer` is in the pack: consider backing mAether's accessories with Trinkets slots instead of its own `/accessories` store.
- `polydex` already lists recipes; the altar/freezer/incubator recipes are mAether-internal and not shown there yet.
