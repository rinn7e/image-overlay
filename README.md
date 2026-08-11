# 🖼️ Image Overlay CLI Tool for macOS

A lightweight, native macOS CLI utility that displays a floating, semi-transparent image overlay on top of all windows with mouse click pass-through support.

---

## ✨ Features

- 🪟 **Floating Window**: Stays above all open applications.
- 👻 **Click Pass-Through**: Mouse clicks pass straight through the overlay to underlying windows by default.
- 🎨 **Adjustable Opacity**: Specify transparency levels from `0.01` (almost invisible) to `1.0` (opaque).
- 📐 **Custom Scaling & Positioning**: Easily scale images, set custom dimensions, or place the overlay anywhere on screen.
- ⚡ **Zero External Dependencies**: Built natively using macOS Cocoa Framework and Swift.

---

## 🚀 Quick Usage

### Option A: Direct Swift Script Execution
No pre-compilation required! macOS has `swift` built-in:

```bash
swift overlay.swift /path/to/image.png 0.4
```

### Option B: Pre-compiled Standalone Binary (Recommended)
Compile the fast release binary once:

```bash
# Build binary
make build
# or run ./build.sh

# Run executable
./bin/image-overlay /path/to/image.png 0.4
```

### Option C: System-wide Installation
Install the binary into `/usr/local/bin` so you can call `image-overlay` from any directory:

```bash
make install
image-overlay /path/to/image.png -o 0.5
```

---

## 📋 Command-Line Reference

```
Usage:
    image-overlay <image_path> [opacity]
    image-overlay <image_path> [options]
    swift overlay.swift <image_path> [options]

Positional Arguments:
    <image_path>          Path to image file (PNG, JPG, TIFF, WebP, etc.)
    [opacity]             Optional opacity level (0.1 to 1.0, default: 0.5)

Options:
    -o, --opacity <val>   Overlay opacity level (0.0 to 1.0, default: 0.5)
    -s, --scale <factor>  Scale factor for image size (e.g. 0.5 for 50%, 2.0 for 200%)
    -w, --width <pixels>  Set specific overlay width
    -h, --height <pixels> Set specific overlay height
    -x <pixels>           Screen X coordinate (bottom-left origin)
    -y <pixels>           Screen Y coordinate (bottom-left origin)
    --interactive         Allow mouse clicks on overlay (disables click pass-through)
    --help, -h            Show help message and exit
```

---

## 💡 Examples

- **Quick 40% transparent overlay**:
  ```bash
  image-overlay ~/Desktop/mockup.png 0.4
  ```

- **Scaled down image with custom position**:
  ```bash
  image-overlay ~/Desktop/design.png --opacity 0.3 --scale 0.75 -x 100 -y 200
  ```

- **Interactive mode (draggable / receives mouse clicks)**:
  ```bash
  image-overlay ~/Desktop/reference.png -o 0.5 --interactive
  ```

- **Stopping the overlay**:
  Press `Ctrl + C` in the Terminal window running the command to close the overlay.
