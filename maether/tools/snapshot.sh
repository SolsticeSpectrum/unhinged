#!/bin/bash
# Push a code-only snapshot (no Aether assets: All Rights Reserved) of this repo to the unhinged backup branch.
set -e
SRC=/home/user/mAether; DST=/home/user/unhinged
cd $DST && rm -rf maether && mkdir maether
cd $SRC && git ls-files | grep -vE "^src/main/resources/assets/aether/(textures|models|lang|sounds)/" | tar -cf - -T - | tar -xf - -C $DST/maether
cp docs/SCOPING.md docs/PORT_REPORT.md $DST/docs/maether/ 2>/dev/null || true
printf 'Aether textures/models/lang/sounds are NOT included (All Rights Reserved; permission is for Kestrel non-commercial use only).\nRe-import with tools/import_aether_assets.py from an upstream checkout.\n' > $DST/maether/ASSETS_OMITTED.md
cd $DST && ! find maether -name "*.png" -o -name "*.ogg" | grep -q .
git add -A && git commit -qm "mAether snapshot $(date +%H:%M)

Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01G4GKDp4P2xVdqS9S7YkSQd" || true
git push -q origin claude/aether-polymer-port-hl2v2d 2>&1 | tail -1
