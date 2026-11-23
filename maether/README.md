# mAether
Server-side Fabric + Polymer port of [The Aether](https://github.com/The-Aether-Team/The-Aether) for vanilla 26.3 clients (Project Kestrel).
Code LGPL-3.0; assets All Rights Reserved, used with permission **non-commercially only** (see `NOTICE`, `docs/PERMISSION.md`).
Status and verification details: `docs/PORT_REPORT.md`; scoping: `docs/SCOPING.md`.

- Requires Java 25, Fabric loader 0.19.5, Fabric API 0.166.2+26.3, Polymer 0.18.7+26.3 (autohost; use `kestrel:upload` from `kestrel-pack-upload` for pack hosting).
- Player features: build a glowstone frame and use a water bucket to open the portal; `/accessories` opens the accessory slots (right-clicking an accessory also equips it).
- Dev: `tools/` has the asset/data importers (upstream checkout + the 26.3 `minecraft-merged.jar` required), console probes and a raw-protocol join test.
