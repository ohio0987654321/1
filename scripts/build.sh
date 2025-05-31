#!/bin/bash
# StealthKit Build Script
# Usage: ./scripts/build.sh [debug|release]

set -e

echo "🧹 Cleaning build artifacts..."

rm -rf build compile_commands.json CMakeCache.txt CMakeFiles
find . -name ".DS_Store" -o -name "*.tmp" -o -name "*.temp" -type f -delete 2>/dev/null || true

echo "✅ Cleaned up"

# Determine build type
BUILD_TYPE=$(echo "${1:-debug}" | tr '[:upper:]' '[:lower:]')
[[ "$BUILD_TYPE" == "debug" || "$BUILD_TYPE" == "release" ]] || {
    echo "❌ Invalid build type: '${1}'. Use 'debug' or 'release'"
    exit 1
}
BUILD_TYPE="$(tr '[:lower:]' '[:upper:]' <<< ${BUILD_TYPE:0:1})${BUILD_TYPE:1}"
BUILD_DIR="build/${BUILD_TYPE}"
JOBS=$(sysctl -n hw.ncpu)

echo "🔨 Building (${BUILD_TYPE}) with ${JOBS} jobs..."

mkdir -p "$BUILD_DIR"
cmake -B "$BUILD_DIR" \
      -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
      -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
      -DCMAKE_OSX_DEPLOYMENT_TARGET=12.0 \
      -DCMAKE_OSX_ARCHITECTURES="arm64;x86_64" \
      -DCMAKE_VERBOSE_MAKEFILE=OFF

cmake --build "$BUILD_DIR" --parallel "$JOBS"

cp "$BUILD_DIR/compile_commands.json" . 2>/dev/null || true
echo "📝 compile_commands.json updated"

APP_PATH="$BUILD_DIR/StealthKit.app"
if [ -x "$APP_PATH/Contents/MacOS/StealthKit" ]; then
    echo "✅ Build complete: $APP_PATH"
    echo "🚀 To launch: open $APP_PATH"
else
    echo "❌ Build failed: App bundle or executable missing"
    exit 1
fi