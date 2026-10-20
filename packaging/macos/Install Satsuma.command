#!/bin/bash
# Installs Satsuma, its Finder Quick Action and (optionally) the converters it uses.
set -e
cd "$(dirname "$0")"
SUPPORT="$PWD/.support"

echo ""
echo "  🍊 Satsuma installer"
echo "  macOS port of Mandarina by JorgeFTS (MIT licensed)"
echo ""

# 1. The app: /Applications if writable, otherwise ~/Applications
DEST=/Applications
[ -w "$DEST" ] || { DEST="$HOME/Applications"; mkdir -p "$DEST"; }
echo "→ Installing Satsuma.app to $DEST"
rm -rf "$DEST/Satsuma.app"
ditto "Satsuma.app" "$DEST/Satsuma.app"
# Not signed with an Apple developer ID: remove the "downloaded from the internet" flag
xattr -dr com.apple.quarantine "$DEST/Satsuma.app" 2>/dev/null || true
# Register this copy so the Quick Action (which opens the app by its id) finds it
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$DEST/Satsuma.app" 2>/dev/null || true

# 2. The Finder right-click menu item
echo "→ Adding Finder Quick Action \"Convert with Satsuma\""
mkdir -p "$HOME/Library/Services"
rm -rf "$HOME/Library/Services/Convert with Satsuma.workflow"
ditto "$SUPPORT/Convert with Satsuma.workflow" "$HOME/Library/Services/Convert with Satsuma.workflow"
xattr -dr com.apple.quarantine "$HOME/Library/Services/Convert with Satsuma.workflow" 2>/dev/null || true
/System/Library/CoreServices/pbs -update 2>/dev/null || true

# 3. Converters (Satsuma drives these tools; each one unlocks some formats)
for d in /opt/homebrew/bin /usr/local/bin; do [ -d "$d" ] && PATH="$d:$PATH"; done
missing=()
have() { command -v "$1" >/dev/null 2>&1; }
have ffmpeg || missing+=(ffmpeg)
have magick || missing+=(imagemagick)
have pandoc || missing+=(pandoc)
have pdftoppm || missing+=(poppler)
have gs || missing+=(ghostscript)
have rsvg-convert || missing+=(librsvg)
have 7zz || have 7z || missing+=(sevenzip)
need_lo=0
[ -d /Applications/LibreOffice.app ] || [ -d "$HOME/Applications/LibreOffice.app" ] || need_lo=1

echo ""
if [ ${#missing[@]} -eq 0 ] && [ $need_lo -eq 0 ]; then
    echo "✓ All converters are already installed."
elif have brew; then
    echo "Some converters are missing: ${missing[*]}$([ $need_lo -eq 1 ] && echo " libreoffice")"
    echo "  ffmpeg = audio/video · imagemagick = images · pandoc = documents"
    echo "  poppler/ghostscript = PDF · librsvg = SVG · sevenzip = RAR · libreoffice = Office files"
    read -r -p "Install them now with Homebrew? [Y/n] " answer
    if [[ ! "$answer" =~ ^[Nn] ]]; then
        [ ${#missing[@]} -gt 0 ] && brew install "${missing[@]}"
        [ $need_lo -eq 1 ] && brew install --cask libreoffice
    fi
else
    echo "Satsuma needs a few free converters, installed with Homebrew (https://brew.sh)."
    echo "Install Homebrew, then run:"
    echo ""
    echo "  brew install ffmpeg imagemagick pandoc poppler ghostscript librsvg sevenzip"
    echo "  brew install --cask libreoffice"
    echo ""
    echo "(Without them Satsuma still opens, and tells you which tool a format needs.)"
fi

echo ""
echo "✓ Done! Right-click any file in Finder → Quick Actions → Convert with Satsuma."
echo "  Tip: give it a shortcut in System Settings → Keyboard → Keyboard Shortcuts →"
echo "  Services → Files and Folders → Convert with Satsuma."
echo ""
