#!/bin/bash
# usage: mc_console.sh <log> <wait-before-seconds> <command>...   (each command followed by 1s pause), then stop
export JAVA_HOME=/usr/lib/jvm/java-25-openjdk-amd64
cd "$(dirname "$0")/.." && { [ -n "$KEEP_WORLD" ] || rm -rf run/world; rm -rf run/polymer; }
log=$1; wait=$2; shift 2
( sleep "$wait"; for c in "$@"; do echo "$c"; sleep ${CMD_SLEEP:-0.25}; done; echo stop ) | timeout 300 ./gradlew runServer --no-daemon > "$log" 2>&1
grep "System chat" "$log" | sed 's/.*System chat: //'
