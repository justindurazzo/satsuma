<p align="center">
  <img src="packaging/icon/mandarina.png" alt="Satsuma logo" width="140">
</p>

<h1 align="center">Satsuma</h1>

<p align="center">
  A file converter for macOS with a floating radial wheel.<br>
  Everything happens on your Mac; nothing is uploaded.
</p>

> **Satsuma is a macOS port of [Mandarina](https://github.com/JorgeFTS/Mandarina) by [JorgeFTS](https://github.com/JorgeFTS)**, a Linux converter launched from Nautilus. All the conversion logic and the wheel UI are JorgeFTS's work; this fork adapts it to macOS. MIT licensed, same as the original. The original README is in [docs/Mandarina-README.md](docs/Mandarina-README.md).

Select files in Finder → right-click → **Quick Actions → Convert with Satsuma**, pick a format from the wheel next to your cursor, and the converted copy lands next to the original.

Images, audio, video, PDF, documents, presentations, spreadsheets, subtitles, archives and folders, 250+ conversions, plus tools to compress, trim, rotate, flip, resize, strip metadata and remove audio. See [docs/Converters.md](docs/Converters.md).

## Install

**[satsuma website](https://justindurazzo.github.io/satsuma/)** · **[⬇ Download the latest DMG](https://github.com/justindurazzo/satsuma/releases/latest)**, open it, and follow `Read Me.txt` (run `Install Satsuma.command`). The installer copies the app, adds the Finder Quick Action and offers to install the converters with Homebrew:

```bash
brew install ffmpeg imagemagick pandoc poppler ghostscript librsvg sevenzip
brew install --cask libreoffice
```

Universal build (Apple Silicon + Intel), macOS 11+. The app is ad-hoc signed, not notarized, so the installer clears the quarantine flag.

## What changed from Mandarina

- Wheel placement uses the real cursor position on macOS (multi-display aware, menu-bar aware) and keeps itself alive by polling the cursor when the window opens without focus.
- Runs as an accessory app (no Dock icon) and extends `PATH` with Homebrew, `~/.local/bin` and `LibreOffice.app`, since Finder-launched apps get a bare `PATH`.
- Missing-tool messages suggest `brew install …` instead of `apt`.
- Finder Quick Action replaces the Nautilus script; `.app` + `.dmg` packaging replaces the `.deb`.
- Settings live in `~/.config/satsuma/config.json`.

## Build

```bash
rustup target add aarch64-apple-darwin x86_64-apple-darwin
npm install
packaging/macos/build-dmg.sh          # → dist/Satsuma-<version>.dmg
cd src-tauri && cargo test --release  # needs the converters installed
```

## License

MIT. Original © 2026 JorgeFTS; macOS port © 2026 Justin Durazzo. See [LICENSE](LICENSE).
