#!/bin/bash
# Assembles the landing page into _site/: the page itself plus the app's UI under app/ for the live demo
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="${1:-$ROOT/_site}"
rm -rf "$OUT"; mkdir -p "$OUT/app"
cp "$ROOT"/site/*.html "$ROOT"/site/*.png "$OUT/"
cp -R "$ROOT"/src/. "$OUT/app/"
echo "Site built in $OUT"
