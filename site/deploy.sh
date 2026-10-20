#!/bin/bash
# Builds the landing page and publishes it to the gh-pages branch (served by GitHub Pages)
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT=$(mktemp -d)
trap 'rm -rf "$OUT"' EXIT
"$ROOT/site/build.sh" "$OUT" >/dev/null
touch "$OUT/.nojekyll"
cd "$OUT"
git init -q -b gh-pages
git add -A
git -c commit.gpgsign=false commit -qm "Deploy website from $(git -C "$ROOT" rev-parse --short HEAD)"
git push -q -f "$(git -C "$ROOT" remote get-url origin)" gh-pages
echo "Deployed: https://justindurazzo.github.io/satsuma/"
