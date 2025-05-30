#!/bin/bash
# StealthKit Build Script
# Usage: ./scripts/build.sh [debug|release]

set -e

# Configuration
BUILD_TYPE=${1:-Debug}
BUILD_DIR="build/${BUILD_TYPE}"
PARALLEL_JOBS=$(sysctl -n hw.ncpu)

# Validate build type
case "$(echo ${BUILD_TYPE} | tr '[:upper:]' '[:lower:]')" in
    debug)
        BUILD_TYPE="Debug"
        ;;
    release)
        BUILD_TYPE="Release"
        ;;
    *)
        echo "❌ Error: Invalid build type '${1}'. Use 'debug' or 'release'"
        exit 1
        ;;
esac

echo "🔨 Building StealthKit (${BUILD_TYPE})..."
echo "   Build Directory: ${BUILD_DIR}"
echo "   Parallel Jobs: ${PARALLEL_JOBS}"
echo

# Create build directory
mkdir -p "${BUILD_DIR}"

# Configure with CMake
echo "📋 Configuring CMake..."
cmake -B "${BUILD_DIR}" \
      -DCMAKE_BUILD_TYPE="${BUILD_TYPE}" \
      -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
      -DCMAKE_OSX_DEPLOYMENT_TARGET=12.0 \
      -DCMAKE_OSX_ARCHITECTURES="arm64;x86_64" \
      -DCMAKE_VERBOSE_MAKEFILE=OFF

if [ $? -ne 0 ]; then
    echo "❌ CMake configuration failed"
    exit 1
fi

echo
echo "🔧 Building..."

# Build with CMake
cmake --build "${BUILD_DIR}" --parallel "${PARALLEL_JOBS}"

if [ $? -ne 0 ]; then
    echo "❌ Build failed"
    exit 1
fi

echo
echo "✅ Build completed successfully!"
echo "   App Location: ${BUILD_DIR}/StealthKit.app"

# Copy compile commands for VSCode IntelliSense
if [ -f "${BUILD_DIR}/compile_commands.json" ]; then
    cp "${BUILD_DIR}/compile_commands.json" .
    echo "📝 Compile commands updated for IntelliSense"
fi

# Show app bundle info
if [ -d "${BUILD_DIR}/StealthKit.app" ]; then
    echo
    echo "📦 App Bundle Information:"
    echo "   Bundle Path: ${BUILD_DIR}/StealthKit.app"
    echo "   Executable: ${BUILD_DIR}/StealthKit.app/Contents/MacOS/StealthKit"
    
    # Check if executable exists and is executable
    if [ -x "${BUILD_DIR}/StealthKit.app/Contents/MacOS/StealthKit" ]; then
        echo "   Status: ✅ Ready to run"
        echo
        echo "🚀 To launch: open ${BUILD_DIR}/StealthKit.app"
    else
        echo "   Status: ❌ Executable not found or not executable"
    fi
else
    echo "❌ App bundle not created"
    exit 1
fi

echo
echo "🎉 StealthKit build process completed!"
