#!/bin/bash
# Reports % solid (holystone+dirt+grass) in a 128x128 area, y 0..95. Usage: density_probe.sh <log>
A="execute in aether:the_aether run"
cmds=("$A forceload add 0 0 127 127")
for b in aether:holystone aether:aether_dirt aether:aether_grass_block; do for x in 0 32 64 96; do for z in 0 32 64 96; do for y in 0 32 64; do
  cmds+=("$A fill $x $y $z $((x+31)) $((y+31)) $((z+31)) minecraft:air replace $b"); done; done; done; done
"$(dirname "$0")/mc_console.sh" "$1" 60 "${cmds[@]}" | python3 -c "
import sys,re
t=sum(int(m.group(1)) for l in sys.stdin for m in [re.search(r'filled (\d+) block',l)] if m)
print('solid blocks',t,'= %.2f%% of y0-95 volume'%(100*t/(128*128*96)))"
