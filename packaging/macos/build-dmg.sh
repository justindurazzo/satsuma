#!/bin/bash
# Builds a universal (Apple Silicon + Intel) Satsuma.app and wraps it in dist/Satsuma-<version>.dmg
# Requires: rustup targets aarch64-apple-darwin + x86_64-apple-darwin, node/npm.
set -e
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"
VERSION=$(python3 -c 'import json;print(json.load(open("src-tauri/tauri.conf.json"))["version"])')
npx tauri build --target universal-apple-darwin --bundles app
APP="src-tauri/target/universal-apple-darwin/release/bundle/macos/Satsuma.app"

STAGE=$(mktemp -d)
trap 'rm -rf "$STAGE"' EXIT
ditto "$APP" "$STAGE/Satsuma.app"
cp "packaging/macos/Install Satsuma.command" "packaging/macos/Read Me.txt" "$STAGE/"
cp LICENSE "$STAGE/LICENSE.txt"
mkdir "$STAGE/.support"
ditto "packaging/macos/Convert with Satsuma.workflow" "$STAGE/.support/Convert with Satsuma.workflow"

mkdir -p dist
DMG="dist/Satsuma-$VERSION.dmg"
rm -f "$DMG"
hdiutil create -quiet -volname "Satsuma" -srcfolder "$STAGE" -fs HFS+ -format UDZO -ov "$DMG"
echo "Built $DMG ($(du -h "$DMG" | cut -f1))"
