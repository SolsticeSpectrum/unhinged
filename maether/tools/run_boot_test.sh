#!/bin/bash
# Boots a headless dev server, force-generates chunks in the Aether dimension, counts blocks, stops. Log -> $1
export JAVA_HOME=/usr/lib/jvm/java-25-openjdk-amd64
cd "$(dirname "$0")/.." && rm -rf run/world run/polymer
( sleep 45
  echo "execute in aether:the_aether run forceload add 0 0 63 63"; sleep 25
  for b in holystone aether_grass_block aether_dirt ambrosium_ore zanite_ore gravitite_ore; do
    for y in 0 32 64 96 128 160 192 224; do
      echo "execute in aether:the_aether run fill 0 $y 0 31 $((y+31)) 31 minecraft:air replace aether:$b"; sleep 0.4; done; done
  echo stop ) | timeout 220 ./gradlew runServer --no-daemon > "$1" 2>&1
