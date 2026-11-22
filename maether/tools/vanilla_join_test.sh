#!/bin/bash
# Drives a raw 26.3-protocol client (tools/raw_client.js) through join + dimension change + block edits + portal.
# Usage: vanilla_join_test.sh <server log> <client log>   (needs node; client keep-alive is not implemented => scenario must finish < 30s)
export JAVA_HOME=/usr/lib/jvm/java-25-openjdk-amd64
cd "$(dirname "$0")/.." && rm -rf run/world run/polymer
SLOG=$1; CLOG=$2
O="execute in minecraft:overworld run"; A="execute in aether:the_aether run"
(
  while ! grep -aq "Done (" "$SLOG" 2>/dev/null; do sleep 1; done
  (cd tools && node raw_client.js > "$CLOG" 2>&1 &)
  while ! grep -aq "RawBot joined the game" "$SLOG" 2>/dev/null; do sleep 0.5; done
  for c in "gamemode creative RawBot" \
    "$A forceload add 0 0 31 31" "$A tp RawBot 10 90 10" "$A setblock 10 88 10 aether:holystone" "$A setblock 10 88 10 minecraft:air" \
    "$A fill 8 80 8 12 84 12 aether:aether_grass_block" \
    "$O forceload add 150 160 175 180" "$O tp RawBot 160 90 160" \
    "$O fill 160 70 170 163 74 170 minecraft:glowstone" "$O fill 161 71 170 162 73 170 minecraft:air" "$O maether light 161 71 170" \
    "$O tp RawBot 161.5 71 170.5"; do echo "$c"; sleep 0.9; done
  sleep 4
  echo "execute as RawBot if dimension aether:the_aether run say IN-AETHER"; sleep 1
  echo "execute as RawBot if dimension minecraft:overworld run say IN-OVERWORLD"; sleep 1
  echo "execute as RawBot at @s run say BOT-POS-IS-HERE"; sleep 1
  echo "$A fill -4 0 -4 40 255 40 minecraft:air replace aether:aether_portal"; sleep 1
  echo stop
) | timeout 240 ./gradlew runServer --no-daemon > "$SLOG" 2>&1
