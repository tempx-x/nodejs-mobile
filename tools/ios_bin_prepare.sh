#!/bin/bash

set -e

ROOT=${PWD}
SCRIPT_DIR="$(dirname "$BASH_SOURCE")"
cd "$SCRIPT_DIR"
cd ../  # Node.js source root

# Configuration
LIBRARY_PATH='out/Release'
TARGET_BIN_PATH='out/Release/iphone-bin'

# Clean and configure for arm64 iOS device
build_node_for_ios_arm64() {
  echo "Cleaning previous builds..."
  make clean

  echo "Configuring for iOS arm64..."
  GYP_DEFINES="target_arch=arm64 host_os=mac target_os=ios" \
  ./configure \
    --dest-os=ios \
    --dest-cpu=arm64 \
    --with-intl=none \
    --cross-compiling \
    --enable-static \
    --openssl-no-asm \
    --v8-options=--jitless \
    --without-node-code-cache \
    --without-node-snapshot

  echo "Building node binary..."
  make -j$(getconf _NPROCESSORS_ONLN) node

  echo "Build complete. Binary is at: $LIBRARY_PATH/node"
}

# Copy binary to target location and strip debug symbols
package_binary() {
  mkdir -p "$TARGET_BIN_PATH"
  cp "$LIBRARY_PATH/node" "$TARGET_BIN_PATH/node-arm64"
  strip "$TARGET_BIN_PATH/node-arm64"
  echo "Stripped binary ready: $TARGET_BIN_PATH/node-arm64"
}

# Main
build_node_for_ios_arm64
package_binary

echo "✅ Success! Copy out/Release/iphone-bin/node-arm64 to your jailbroken iPhone and run it."