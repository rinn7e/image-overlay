# 🖼️ Image Overlay CLI Tool for macOS

A lightweight, native macOS CLI utility that displays a floating, semi-transparent image overlay on top of all windows. Includes full click-and-drag positioning, a sleek top-right close button, clipboard support, and optional click pass-through!

---

## ✨ Features

- 🖐️ **Draggable Window**: Click and drag anywhere on the overlay to move it around your screen.
- 🔴 **Top-Right Close Button**: Click the sleek circular `✕` button to instantly close the overlay.
- 📋 **Clipboard Support**: Display an image directly from your clipboard (`Cmd+C` or `Cmd+Shift+Ctrl+4`) using `-c` / `--clipboard`.
- 👻 **Optional Click Pass-Through**: Pass `--pass-through` to allow mouse clicks to pass straight through the overlay to underlying windows.
- 🎨 **Adjustable Opacity**: Specify transparency levels from `0.01` (almost invisible) to `1.0` (opaque).
- 📐 **Custom Scaling & Dimensions**: Easily scale images or set specific window sizes.
- ⚡ **Zero External Dependencies**: Built natively using macOS Cocoa Framework and Swift.

---

## 🚀 Quick Usage

### 🖐️ Draggable & Interactive Mode (Default)
By default, the overlay is **draggable** by clicking anywhere on the image, and displays a red-hover `✕` close button in the top-right corner!

```bash
# Overlay from clipboard (draggable + close button)
image-overlay -c 0.4

# Overlay from file (draggable + close button)
image-overlay /path/to/image.png 0.5
```

### 👻 Click Pass-Through Mode
If you want clicks to pass through the overlay to apps behind it:

```bash
image-overlay /path/to/image.png 0.4 --pass-through
```

---

## 📋 Command-Line Reference

```
Usage:
    image-overlay <image_path> [opacity]
    image-overlay --clipboard [opacity]
    image-overlay [options]

Source Options:
    <image_path>          Path to image file (PNG, JPG, TIFF, WebP, etc.)
    -c, --clipboard       Use image currently stored in macOS clipboard

Options:
    -o, --opacity <val>   Overlay opacity level (0.0 to 1.0, default: 0.5)
    -s, --scale <factor>  Scale factor for image size (e.g. 0.5 for 50%, 2.0 for 200%)
    -w, --width <pixels>  Set specific overlay width
    -h, --height <pixels> Set specific overlay height
    -x <pixels>           Screen X coordinate (bottom-left origin)
    -y <pixels>           Screen Y coordinate (bottom-left origin)
    --pass-through, --lock Enable click pass-through (clicks go to apps underneath)
    --no-close            Hide the top-right close button
    --help, -h            Show help message and exit
```

---

## 💡 Examples

- **Draggable clipboard overlay with close button**:
  ```bash
  image-overlay -c 0.4
  ```

- **Pass-through mode for tracing/mockup overlay**:
  ```bash
  image-overlay ~/Desktop/mockup.png 0.3 --pass-through
  ```

- **Stopping the overlay**:
  Click the top-right `✕` button, or press `Ctrl + C` in Terminal.
