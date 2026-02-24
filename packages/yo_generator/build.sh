#!/usr/bin/env bash
# Build script for yo.dart - compiles to native executable
#
# Usage:
#   ./build.sh             # Build for current platform
#   ./build.sh --all       # Build for all platforms (requires cross-compilation)
#
# Output:
#   build/yo               # Unix executable
#   build/yo.exe           # Windows executable (cross-compile only)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$SCRIPT_DIR/build"
VERSION=$(grep 'version:' "$SCRIPT_DIR/pubspec.yaml" | head -1 | awk '{print $2}')

echo "╔═══════════════════════════════════════╗"
echo "║  Building yo.dart v$VERSION            ║"
echo "╚═══════════════════════════════════════╝"
echo ""

# Ensure dependencies are up to date
echo "📦 Fetching dependencies..."
cd "$SCRIPT_DIR"
dart pub get

# Create build directory
mkdir -p "$BUILD_DIR"

# Run tests first
echo ""
echo "🧪 Running tests..."
dart test
echo ""

# Run analyzer
echo "🔍 Running analysis..."
dart analyze
echo ""

# Compile
echo "🔨 Compiling to native executable..."
dart compile exe yo.dart -o "$BUILD_DIR/yo"

# Get file size
SIZE=$(du -sh "$BUILD_DIR/yo" | awk '{print $1}')

echo ""
echo "╔═══════════════════════════════════════╗"
echo "║  Build Complete!                       ║"
echo "╠═══════════════════════════════════════╣"
echo "║  Output:  build/yo                     ║"
echo "║  Size:    $SIZE                          ║"
echo "║  Version: $VERSION                      ║"
echo "╚═══════════════════════════════════════╝"
echo ""
echo "📋 Installation:"
echo "   cp $BUILD_DIR/yo ~/.local/bin/yo"
echo "   # or"
echo "   sudo cp $BUILD_DIR/yo /usr/local/bin/yo"
echo ""
echo "📋 Usage:"
echo "   yo page:home"
echo "   yo init --state=riverpod"
echo ""
