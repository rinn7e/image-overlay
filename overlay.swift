import Cocoa

// MARK: - Usage & Help

func printUsage() {
    let usage = """
    🖼️  Image Overlay CLI Utility for macOS
    
    Usage:
        image-overlay <image_path> [opacity]
        image-overlay <image_path> [options]
        swift overlay.swift <image_path> [options]

    Positional Arguments:
        <image_path>          Path to the image file (PNG, JPG, TIFF, WebP, etc.)
        [opacity]             Optional opacity level between 0.1 and 1.0 (default: 0.5)

    Options:
        -o, --opacity <val>   Overlay opacity level (0.0 to 1.0, default: 0.5)
        -s, --scale <factor>  Scale factor for original image dimensions (e.g. 0.5, 2.0)
        -w, --width <pixels>  Set specific overlay width
        -h, --height <pixels> Set specific overlay height
        -x <pixels>           Screen X coordinate (bottom-left origin)
        -y <pixels>           Screen Y coordinate (bottom-left origin)
        --interactive         Allow mouse clicks on overlay (disables click pass-through)
        --help, -h            Show this help message and exit

    Examples:
        image-overlay screenshot.png 0.4
        image-overlay mockup.png --opacity 0.6 --scale 0.8
        image-overlay reference.png -o 0.3 -x 100 -y 200 --interactive
    """
    print(usage)
}

// MARK: - CLI Options Parser

struct OverlayOptions {
    var imagePath: String = ""
    var opacity: CGFloat = 0.5
    var scale: CGFloat = 1.0
    var width: CGFloat? = nil
    var height: CGFloat? = nil
    var x: CGFloat? = nil
    var y: CGFloat? = nil
    var interactive: Bool = false
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
        case "--interactive":
            options.interactive = true
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

    if options.imagePath.isEmpty {
        print("❌ Error: Image path is required.")
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

let resolvedPath = resolvePath(config.imagePath)
guard let image = NSImage(contentsOfFile: resolvedPath) else {
    print("❌ Error: Unable to load image at '\(resolvedPath)'")
    exit(1)
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
window.ignoresMouseEvents = !config.interactive
window.isMovableByWindowBackground = config.interactive

// Image View Setup
let imageView = NSImageView(frame: window.contentView!.bounds)
imageView.image = image
imageView.imageScaling = .scaleAxesIndependently
imageView.autoresizingMask = [.width, .height]
window.contentView?.addSubview(imageView)

// Show Window
window.makeKeyAndOrderFront(nil)

print("✨ Image Overlay active! ✨")
print("  📍 File: \(resolvedPath)")
print("  🔍 Dimensions: \(Int(finalWidth))x\(Int(finalHeight))")
print("  opacity: \(config.opacity)")
print("  🖱️ Click Pass-Through: \(config.interactive ? "Disabled (Interactive)" : "Enabled (Clicks pass through)")")
print("  🛑 Press Ctrl+C in terminal to stop.")

app.run()
