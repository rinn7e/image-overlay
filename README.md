# 🖼️ Image Overlay CLI Tool for macOS

A lightweight, native macOS CLI utility that displays a floating, semi-transparent image overlay on top of all windows. Includes full click-and-drag positioning, a sleek top-right close button, clipboard support, temp image caching, and a `--resume` flag!

---

## ✨ Features

- 🔄 **Resume Last Image (`-r`, `--resume`)**: Instantly re-open the last displayed image without needing to specify the file path or copy to clipboard again!
- 💾 **Auto-Save to Temp**: Automatically caches any loaded file or clipboard image to macOS temp directory (`image-overlay-last.png`).
- 🖐️ **Draggable Window**: Click and drag anywhere on the overlay to move it around your screen.
- 🔴 **Top-Right Close Button**: Click the sleek circular `✕` button to instantly close the overlay.
- 📋 **Clipboard Support**: Display an image directly from your clipboard (`Cmd+C` or `Cmd+Shift+Ctrl+4`) using `-c` / `--clipboard`.
- 👻 **Optional Click Pass-Through**: Pass `--pass-through` to allow mouse clicks to pass straight through the overlay to underlying windows.
- 🎨 **Adjustable Opacity**: Specify transparency levels from `0.01` (almost invisible) to `1.0` (opaque).
- 📐 **Custom Scaling & Dimensions**: Easily scale images or set specific window sizes.
- ⚡ **Zero External Dependencies**: Built natively using macOS Cocoa Framework and Swift.

---

## 🚀 Quick Usage

### 🔄 Resume Previous Image
Re-open the last image you used:

```bash
image-overlay -r
# or
image-overlay --resume 0.4
```

### 📋 Clipboard Overlay
Copy any image or screenshot to your clipboard (`Cmd+Shift+Ctrl+4`), then run:

```bash
image-overlay -c 0.4
```

### 📁 Image File Overlay

```bash
image-overlay /path/to/image.png 0.5
```

---

## 📋 Command-Line Reference

```
Usage:
    image-overlay <image_path> [opacity]
    image-overlay --clipboard [opacity]
    image-overlay --resume [opacity]
    image-overlay [options]

Source Options:
    <image_path>          Path to image file (PNG, JPG, TIFF, WebP, etc.)
    -c, --clipboard       Use image currently stored in macOS clipboard
    -r, --resume          Reuse the last displayed image saved in temp storage

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

- **Quickly resume last overlay at 30% opacity**:
  ```bash
  image-overlay -r 0.3
  ```

- **Overlay clipboard image and cache it for future resume**:
  ```bash
  image-overlay -c 0.4
  ```

- **Stopping the overlay**:
  Click the top-right `✕` button, or press `Ctrl + C` in Terminal.
