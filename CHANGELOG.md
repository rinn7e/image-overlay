# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added
- Native macOS floating image overlay script in Swift (`overlay.swift`), run directly via `swift overlay.swift`.
- Draggable overlay window positioning.
- Sleek circular top-right close button (`✕`).
- Clipboard support (`-c`, `--clipboard`) to load images directly from macOS clipboard.
- Automatic temp caching of loaded images (`image-overlay-last.png`).
- Resume flag (`-r`, `--resume`) to quickly re-open the last overlay image.
- Adjustable opacity level (`-o`, `--opacity`), scale factor (`-s`, `--scale`), custom width/height (`-w`, `-H`), and positioning (`-x`, `-y`).
- Click pass-through mode (`--pass-through`, `--lock`) allowing mouse clicks to interact with underlying apps.
- Option to hide close button (`--no-close`).
- Compose mode (`--compose <base> <overlay> [opacity] [--out <path>]`) that writes a PNG with the overlay drawn top-aligned and horizontally centered on the base.
- MIT License ([LICENSE](LICENSE)).
