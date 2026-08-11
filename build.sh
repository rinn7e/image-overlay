#!/usr/bin/env bash
set -e

echo "🔨 Compiling Image Overlay CLI binary..."
mkdir -p bin
swiftc -O -framework Cocoa overlay.swift -o bin/image-overlay
chmod +x bin/image-overlay

echo "✅ Compiled successfully: ./bin/image-overlay"
echo "👉 Run: ./bin/image-overlay --help"
