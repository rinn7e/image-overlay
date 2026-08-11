import Cocoa

// MARK: - Custom Draggable Image View

class DraggableImageView: NSImageView {
    private var initialLocation: NSPoint = .zero
    var isDraggable: Bool = true

    override func mouseDown(with event: NSEvent) {
        initialLocation = event.locationInWindow
        super.mouseDown(with: event)
    }

    override func mouseDragged(with event: NSEvent) {
        guard isDraggable, let window = self.window else {
            super.mouseDragged(with: event)
            return
        }
        let currentLocation = event.locationInWindow
        var newOrigin = window.frame.origin
        newOrigin.x += currentLocation.x - initialLocation.x
        newOrigin.y += currentLocation.y - initialLocation.y
        window.setFrameOrigin(newOrigin)
    }
}

// MARK: - Close Action Target

class CloseHandler: NSObject {
    @objc func closeOverlay() {
        print("👋 Overlay closed.")
        exit(0)
    }
}

let closeHandler = CloseHandler()

// MARK: - Custom Floating Close Button

class OverlayCloseButton: NSButton {
    private var trackingArea: NSTrackingArea?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.title = "✕"
        self.font = NSFont.systemFont(ofSize: 11, weight: .bold)
        self.bezelStyle = .circular
        self.isBordered = false
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor(white: 0.15, alpha: 0.75).cgColor
        self.layer?.cornerRadius = frameRect.width / 2
        self.contentTintColor = .white
        
        self.target = closeHandler
        self.action = #selector(CloseHandler.closeOverlay)
        
        setupTracking()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTracking() {
        let area = NSTrackingArea(
            rect: self.bounds,
            options: [.mouseEnteredAndExited, .activeAlways, .inVisibleRect],
            owner: self,
            userInfo: nil
        )
        self.addTrackingArea(area)
    }

    override func mouseEntered(with event: NSEvent) {
        self.layer?.backgroundColor = NSColor.systemRed.withAlphaComponent(0.9).cgColor
    }

    override func mouseExited(with event: NSEvent) {
        self.layer?.backgroundColor = NSColor(white: 0.15, alpha: 0.75).cgColor
    }
}

// MARK: - Usage & Help

func printUsage() {
    let usage = """
    🖼️  Image Overlay CLI Utility for macOS
    
    Usage:
        image-overlay <image_path> [opacity]
        image-overlay --clipboard [opacity]
        image-overlay [options]

    Source Options:
        <image_path>          Path to image file (PNG, JPG, TIFF, WebP, etc.)
        -c, --clipboard       Use image currently stored in macOS clipboard

    Options:
        -o, --opacity <val>   Overlay opacity level (0.0 to 1.0, default: 0.5)
        -s, --scale <factor>  Scale factor for original image dimensions (e.g. 0.5, 2.0)
        -w, --width <pixels>  Set specific overlay width
        -h, --height <pixels> Set specific overlay height
        -x <pixels>           Screen X coordinate (bottom-left origin)
        -y <pixels>           Screen Y coordinate (bottom-left origin)
        --pass-through, --lock Enable click pass-through mode (clicks go to apps underneath)
        --no-close            Hide the top-right close button
        --help, -h            Show this help message and exit

    Interactivity & Dragging:
        By default, the overlay is DRAGGABLE by clicking and moving the image, and includes
        a top-right '✕' close button. Pass --pass-through to make mouse clicks pass through.

    Examples:
        image-overlay --clipboard 0.4
        image-overlay mockup.png --opacity 0.6 --scale 0.8
        image-overlay reference.png -o 0.3 --pass-through
    """
    print(usage)
}

// MARK: - CLI Options Parser

struct OverlayOptions {
    var imagePath: String = ""
    var useClipboard: Bool = false
    var opacity: CGFloat = 0.5
    var scale: CGFloat = 1.0
    var width: CGFloat? = nil
    var height: CGFloat? = nil
    var x: CGFloat? = nil
    var y: CGFloat? = nil
    var passThrough: Bool = false
    var showCloseButton: Bool = true
}

func parseArguments() -> OverlayOptions? {
    let args = Array(CommandLine.arguments.dropFirst())
    
    if args.isEmpty || args.contains("-h") || args.contains("--help") {
        printUsage()
        exit(0)
    }

    var options = OverlayOptions()
    var positionalIndex = 0
    var i = 0

    while i < args.count {
        let arg = args[i]

        switch arg {
        case "-c", "--clipboard":
            options.useClipboard = true
        case "-o", "--opacity":
            if i + 1 < args.count, let val = Float(args[i + 1]) {
                options.opacity = CGFloat(max(0.01, min(1.0, val)))
                i += 1
            } else {
                print("❌ Error: Invalid opacity value after \(arg)")
                return nil
            }
        case "-s", "--scale":
            if i + 1 < args.count, let val = Float(args[i + 1]) {
                options.scale = CGFloat(max(0.05, val))
                i += 1
            } else {
                print("❌ Error: Invalid scale factor after \(arg)")
                return nil
            }
        case "-w", "--width":
            if i + 1 < args.count, let val = Float(args[i + 1]) {
                options.width = CGFloat(val)
                i += 1
            } else {
                print("❌ Error: Invalid width value after \(arg)")
                return nil
            }
        case "-h", "--height":
            if i + 1 < args.count, let val = Float(args[i + 1]) {
                options.height = CGFloat(val)
                i += 1
            } else {
                print("❌ Error: Invalid height value after \(arg)")
                return nil
            }
        case "-x":
            if i + 1 < args.count, let val = Float(args[i + 1]) {
                options.x = CGFloat(val)
                i += 1
            } else {
                print("❌ Error: Invalid X coordinate after \(arg)")
                return nil
            }
        case "-y":
            if i + 1 < args.count, let val = Float(args[i + 1]) {
                options.y = CGFloat(val)
                i += 1
            } else {
                print("❌ Error: Invalid Y coordinate after \(arg)")
                return nil
            }
        case "--pass-through", "--lock":
            options.passThrough = true
        case "--no-close":
            options.showCloseButton = false
        default:
            if arg.hasPrefix("-") {
                print("❌ Error: Unknown option '\(arg)'")
                printUsage()
                return nil
            } else {
                if positionalIndex == 0 {
                    options.imagePath = arg
                } else if positionalIndex == 1 {
                    if let val = Float(arg) {
                        options.opacity = CGFloat(max(0.01, min(1.0, val)))
                    } else {
                        print("❌ Error: Invalid positional opacity value '\(arg)'")
                        return nil
                    }
                }
                positionalIndex += 1
            }
        }
        i += 1
    }

    if options.imagePath.isEmpty && !options.useClipboard {
        print("❌ Error: Image path or --clipboard flag is required.")
        printUsage()
        return nil
    }

    return options
}

// MARK: - Path Resolution Helper

func resolvePath(_ path: String) -> String {
    let NSStringPath = path as NSString
    let expanded = NSStringPath.expandingTildeInPath
    if expanded.hasPrefix("/") {
        return expanded
    } else {
        let currentDir = FileManager.default.currentDirectoryPath
        return (currentDir as NSString).appendingPathComponent(expanded)
    }
}

// MARK: - Application Entry Point

guard let config = parseArguments() else {
    exit(1)
}

let image: NSImage
let sourceDescription: String

if config.useClipboard {
    let pasteboard = NSPasteboard.general
    guard let clipboardImage = NSImage(pasteboard: pasteboard) else {
        print("❌ Error: No valid image found in macOS clipboard.")
        print("💡 Tip: Copy an image or screenshot (Cmd+Shift+Ctrl+4) first!")
        exit(1)
    }
    image = clipboardImage
    sourceDescription = "macOS Clipboard"
} else {
    let resolvedPath = resolvePath(config.imagePath)
    guard let fileImage = NSImage(contentsOfFile: resolvedPath) else {
        print("❌ Error: Unable to load image at '\(resolvedPath)'")
        exit(1)
    }
    image = fileImage
    sourceDescription = resolvedPath
}

// Initialize Application
let app = NSApplication.shared
app.setActivationPolicy(.accessory)

// Determine Dimensions
var finalWidth = image.size.width * config.scale
var finalHeight = image.size.height * config.scale

if let customW = config.width, let customH = config.height {
    finalWidth = customW
    finalHeight = customH
} else if let customW = config.width {
    let ratio = image.size.height / image.size.width
    finalWidth = customW
    finalHeight = customW * ratio
} else if let customH = config.height {
    let ratio = image.size.width / image.size.height
    finalHeight = customH
    finalWidth = customH * ratio
}

// Determine Position
let screenFrame = NSScreen.main?.frame ?? NSRect(x: 0, y: 0, width: 1920, height: 1080)
let originX = config.x ?? (screenFrame.midX - finalWidth / 2)
let originY = config.y ?? (screenFrame.midY - finalHeight / 2)

let frame = NSRect(x: originX, y: originY, width: finalWidth, height: finalHeight)

// Create Borderless Transparent Window
let window = NSWindow(
    contentRect: frame,
    styleMask: [.borderless, .resizable],
    backing: .buffered,
    defer: false
)

window.level = .floating
window.isOpaque = false
window.backgroundColor = .clear
window.alphaValue = config.opacity
window.ignoresMouseEvents = config.passThrough
window.isMovableByWindowBackground = !config.passThrough

// Draggable Image View Setup
let imageView = DraggableImageView(frame: window.contentView!.bounds)
imageView.image = image
imageView.imageScaling = .scaleAxesIndependently
imageView.autoresizingMask = [.width, .height]
imageView.isDraggable = !config.passThrough
window.contentView?.addSubview(imageView)

// Floating Close Button Setup
if config.showCloseButton && !config.passThrough {
    let btnSize: CGFloat = 22
    let margin: CGFloat = 6
    let btnFrame = NSRect(
        x: finalWidth - btnSize - margin,
        y: finalHeight - btnSize - margin,
        width: btnSize,
        height: btnSize
    )
    let closeBtn = OverlayCloseButton(frame: btnFrame)
    closeBtn.autoresizingMask = [.minXMargin, .minYMargin]
    window.contentView?.addSubview(closeBtn)
}

// Show Window
window.makeKeyAndOrderFront(nil)

print("✨ Image Overlay active! ✨")
print("  📍 Source: \(sourceDescription)")
print("  🔍 Dimensions: \(Int(finalWidth))x\(Int(finalHeight))")
print("  🎚️ Opacity: \(config.opacity)")
print("  🖐️ Draggable: \(!config.passThrough ? "Yes (Click & Drag)" : "No (Pass-Through Active)")")
print("  🔴 Close Button: \(config.showCloseButton && !config.passThrough ? "Visible (Top-Right)" : "Hidden")")
print("  🛑 Press Ctrl+C in terminal or click ✕ to stop.")

app.run()
