# mAether port — report (phone version)

## TL;DR
**No code was written.** Two hard limits hit; stopped per your rules.
1. **Asset license:** Aether code = LGPL-3.0 (forkable), but **all art/sounds/lang = All Rights Reserved.** Our auto-hosted pack would redistribute them. Not allowed without the Aether Team's permission.
2. **Environment:** I can't build or boot anything here (see Blockers). `Codename-Kestrel/mAether` also doesn't exist, so no repo/PR.

Phase 1 is done: `docs/maether/SCOPING.md` (desk research).

## What works / partial / cut
- Works: nothing implemented.
- Partial: scoping only.
- Cut: everything in Phase 2 (not started).

## Blockers
- Sandbox network denies `maven.fabricmc.net`, Nucleoid Maven (Polymer), Modrinth, Mojang → no Gradle build, no server boot, no bot test. **No test results exist; nothing was verified.**
- `Codename-Kestrel/mAether` not found (I'm not creating repos). Org repos became visible after you fixed access; I read `mPolymania` (MC 26.3, Fabric loader 0.19.5, Polymer 0.18.6+26.3pb4 with autohost/virtual-entity/resource-pack modules). Did not read `kestrel-pack-upload`.
- No vanilla 26.3 client/bot available (can't download either).

## Decisions I made without you
1. Fork source = official Aether (only complete one); Fabric ports not surveyed (my search was interrupted).
2. Treated All-Rights-Reserved assets as a hard-limit stop; did not start Phase 2.
3. Put docs on branch `claude/aether-polymer-port-hl2v2d` of the `unhinged` repo (the only repo I could write); **no PR opened**. Move them into `mAether` when it exists.
4. Classified nothing as "B (Polymer patch)" yet.

## Open questions
- Will the Aether Team grant written permission (contact: Oz on the Aether Discord) to ship textures/models/sounds in our pack?
- If not: OK to do code-only port with **original/placeholder art**, no Aether textures or branding?
- Should I create `Codename-Kestrel/mAether` (or will you)?

## Suggested next step
1. Email/Discord the Aether Team for asset permission (or approve original art).
2. Create `mAether`; allow hosts: maven.fabricmc.net, maven.nucleoid.xyz, piston-meta/piston-data.mojang.com, libraries.minecraft.net, api.modrinth.com, cdn.modrinth.com.
3. New session with `mAether`, `mPolymania`, `kestrel-pack-upload`, `mPolymerPatchBundle` attached, and I run Phase 2 steps 1–2 first.
