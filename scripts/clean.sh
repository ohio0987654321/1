#!/bin/bash
# StealthKit Clean Script
# Usage: ./scripts/clean.sh

set -e

echo "🧹 Cleaning StealthKit build artifacts..."

# Remove build directories
if [ -d "build" ]; then
    echo "   Removing build/ directory..."
    rm -rf build/
    echo "   ✅ Build directory removed"
else
    echo "   ℹ️  No build directory found"
fi

# Remove compile commands file
if [ -f "compile_commands.json" ]; then
    echo "   Removing compile_commands.json..."
    rm -f compile_commands.json
    echo "   ✅ Compile commands removed"
else
    echo "   ℹ️  No compile_commands.json found"
fi

# Remove CMake cache files in source directory (if any)
if [ -f "CMakeCache.txt" ]; then
    echo "   Removing CMakeCache.txt..."
    rm -f CMakeCache.txt
    echo "   ✅ CMakeCache.txt removed"
fi

if [ -d "CMakeFiles" ]; then
    echo "   Removing CMakeFiles/ directory..."
    rm -rf CMakeFiles/
    echo "   ✅ CMakeFiles directory removed"
fi

# Remove .DS_Store files
echo "   Removing .DS_Store files..."
find . -name ".DS_Store" -type f -delete 2>/dev/null || true
echo "   ✅ .DS_Store files cleaned"

# Remove temporary files
echo "   Removing temporary files..."
find . -name "*.tmp" -type f -delete 2>/dev/null || true
find . -name "*.temp" -type f -delete 2>/dev/null || true
echo "   ✅ Temporary files cleaned"

echo
echo "🎉 StealthKit workspace cleaned successfully!"
echo "   All build artifacts have been removed."
echo "   Ready for a fresh build with ./scripts/build.sh"
