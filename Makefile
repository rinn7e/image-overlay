# Image Overlay CLI Makefile for macOS

BINARY_NAME = image-overlay
BUILD_DIR = bin
SOURCE = overlay.swift
INSTALL_PATH = /usr/local/bin/$(BINARY_NAME)

.PHONY: all build clean install uninstall run help

all: build

build:
	@mkdir -p $(BUILD_DIR)
	@echo "🔨 Compiling $(BINARY_NAME)..."
	swiftc -O -framework Cocoa $(SOURCE) -o $(BUILD_DIR)/$(BINARY_NAME)
	@echo "✅ Build complete: $(BUILD_DIR)/$(BINARY_NAME)"

clean:
	@echo "🧹 Cleaning build artifacts..."
	rm -rf $(BUILD_DIR)
	@echo "✨ Clean complete."

install: build
	@echo "🚀 Installing $(BINARY_NAME) to /usr/local/bin..."
	@mkdir -p /usr/local/bin
	cp $(BUILD_DIR)/$(BINARY_NAME) $(INSTALL_PATH)
	@chmod +x $(INSTALL_PATH)
	@echo "🎉 Installed successfully! You can now run '$(BINARY_NAME)' from anywhere."

uninstall:
	@echo "🗑️ Uninstalling $(BINARY_NAME)..."
	rm -f $(INSTALL_PATH)
	@echo "✨ Uninstalled successfully."

run:
	swift $(SOURCE)

help:
	@echo "Available targets:"
	@echo "  make build      Build the binary in ./bin/image-overlay"
	@echo "  make clean      Remove build artifacts"
	@echo "  make install    Install binary to /usr/local/bin"
	@echo "  make uninstall  Remove binary from /usr/local/bin"
