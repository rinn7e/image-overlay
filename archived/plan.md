Since Apple's Preview app cannot perform window-level opacity or floating overlays, you can achieve this exact function natively on macOS using **Terminal** and a tiny built-in tool, or with a lightweight utility.

---

### Option 1: Native macOS Script (No Installation Required)

macOS includes a command-line tool called `swift` that can run a script to create a floating, semi-transparent window.

1. Open **Terminal** (press `Cmd + Space`, type `Terminal`, and hit Enter).
2. Paste the following command and hit Enter:

```bash
cat << 'EOF' > overlay.swift
import Cocoa

let app = NSApplication.shared
app.setActivationPolicy(.accessory)

let imagePath = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
guard let image = NSImage(contentsOfFile: imagePath) else {
    print("Usage: swift overlay.swift /path/to/image.png [opacity 0.1-1.0]")
    exit(1)
}

let alpha = CommandLine.arguments.count > 2 ? (Float(CommandLine.arguments[2]) ?? 0.5) : 0.5

let frame = NSRect(x: 200, y: 200, width: image.size.width, height: image.size.height)
let window = NSWindow(contentRect: frame, styleMask: [.borderless, .resizable], backing: .buffered, defer: false)
window.level = .floating
window.isOpaque = false
window.backgroundColor = .clear
window.alphaValue = CGFloat(alpha)
window.ignoresMouseEvents = true // Passes clicks through to the app underneath

let imageView = NSImageView(frame: window.contentView!.bounds)
imageView.image = image
imageView.autoresizingMask = [.width, .height]
window.contentView?.addSubview(imageView)

window.makeKeyAndOrderFront(nil)
app.run()
EOF

```

3. Run the script with your image path and optional opacity level (e.g., `0.4` for 40% opacity):

```bash
swift overlay.swift /path/to/your/image.png 0.4

```

**Result:** The image floats on your screen at 40% opacity, stays on top, and **all mouse clicks pass straight through it** to whatever application is behind it.

To close it, go back to Terminal and press `Ctrl + C`.

---

### Option 2: The Minimalist Single-Purpose App

If you prefer a standard Mac app rather than Terminal scripts, **Overlay Lite** (free on the Mac App Store) is built strictly for this single function:

1. Download **Overlay Lite** from the Mac App Store.
2. Open your image inside it.
3. Use its opacity slider to adjust window transparency.
4. Toggle **Lock / Pass-Through Mode** so clicks go through to your background workspace.