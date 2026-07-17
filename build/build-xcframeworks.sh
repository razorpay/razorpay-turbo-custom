#!/bin/bash
set -e

# ============================================================
# build-xcframeworks.sh
# Creates stripped xcframework.zip files for SPM distribution
# ============================================================
# Usage:
#   ./build-xcframeworks.sh [--strip]
#
# Options:
#   --strip    Strip dev-only files (abi.json, swiftdoc, Project/) from swiftmodule
#              Default: enabled
#
# This script:
#   1. Reads frameworks from generated_builds/
#   2. Creates device-only xcframeworks (arm64)
#   3. Strips dev-only files to reduce size
#   4. Zips xcframeworks for GitHub release upload
#   5. Generates checksums for Package.swift
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="$SCRIPT_DIR/output"
GENERATED_BUILDS="$HOME/Documents/generated_builds"

# Frameworks to process
# Format: "name:relative_path_from_generated_builds"
# If framework is not in generated_builds, set path to empty and it will use existing xcframework
FRAMEWORKS=(
  "CommonLibrary:CL/PROD/CommonLibrary.framework"
  "two_party:two_party/Release/two_party.framework"
  "RazorpayTurboUPI:RazorpayTurboUPI/Release/RazorpayTurboUPI.framework"
  "TurboUpiPlugin:"  # Built via RazorpayIOS, use existing xcframework from output/
)

STRIP_ENABLED=true

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --strip)
      STRIP_ENABLED=true
      shift
    ;;
    --no-strip)
      STRIP_ENABLED=false
      shift
    ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 [--strip|--no-strip]"
      exit 1
    ;;
  esac
done

echo "============================================================"
echo "  Building stripped xcframeworks for SPM distribution"
echo "============================================================"
echo ""

# Save existing xcframeworks that need to be preserved
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

for entry in "${FRAMEWORKS[@]}"; do
  IFS=':' read -r name relative_path <<< "$entry"
  if [ -z "$relative_path" ] && [ -d "$OUTPUT_DIR/$name.xcframework" ]; then
    echo "Saving existing $name.xcframework..."
    cp -R "$OUTPUT_DIR/$name.xcframework" "$TEMP_DIR/$name.xcframework"
  fi
done

# Clean previous output
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

# Restore saved xcframeworks
if [ -d "$TEMP_DIR" ]; then
  for item in "$TEMP_DIR"/*.xcframework; do
    if [ -d "$item" ]; then
      cp -R "$item" "$OUTPUT_DIR/"
    fi
  done
fi

strip_swiftmodule() {
  local framework_path="$1"
  local swiftmodule_dir="$framework_path/Modules/$(basename "$framework_path" .framework).swiftmodule"

  if [ ! -d "$swiftmodule_dir" ]; then
    echo "  No swiftmodule directory found, skipping strip"
    return
  fi

  echo "  Stripping dev-only files from swiftmodule..."

  local before_size=$(du -sh "$swiftmodule_dir" | cut -f1)

  # Keep abi.json for module stability across Swift versions

  # Remove swiftdoc (documentation)
  rm -f "$swiftmodule_dir"/*.swiftdoc

  # Remove Project/ directory (debug symbols, source info)
  rm -rf "$swiftmodule_dir/Project"

  local after_size=$(du -sh "$swiftmodule_dir" | cut -f1)
  echo "  Stripped: $before_size -> $after_size"
}

for entry in "${FRAMEWORKS[@]}"; do
  IFS=':' read -r name relative_path <<< "$entry"

  echo "Processing: $name"

  # Check if we have a framework path
  if [ -n "$relative_path" ]; then
    framework_path="$GENERATED_BUILDS/$relative_path"
    echo "  Source: $framework_path"

    # Check if framework exists
    if [ ! -d "$framework_path" ]; then
      echo "  ⚠ Framework not found, skipping"
      echo ""
      continue
    fi

    # Verify it's an arm64 binary
    binary_path="$framework_path/$(basename "$framework_path" .framework)"
    if [ -f "$binary_path" ]; then
      arch=$(file "$binary_path" | grep -o "arm64" || true)
      if [ -z "$arch" ]; then
        echo "  ⚠ Not arm64 architecture, skipping"
        echo ""
        continue
      fi
    fi

    # Strip dev-only files if enabled
    if [ "$STRIP_ENABLED" = true ]; then
      strip_swiftmodule "$framework_path"
    fi

    # Create xcframework
    xcframework_path="$OUTPUT_DIR/$name.xcframework"
    echo "  Creating xcframework..."

    rm -rf "$xcframework_path"

    xcodebuild -create-xcframework \
      -framework "$framework_path" \
      -output "$xcframework_path"
  else
    # Framework not in generated_builds, use existing xcframework
    existing_xcframework="$OUTPUT_DIR/$name.xcframework"
    if [ -d "$existing_xcframework" ]; then
      echo "  Using existing xcframework: $existing_xcframework"
      xcframework_path="$OUTPUT_DIR/$name.xcframework"

      # Strip if enabled
      if [ "$STRIP_ENABLED" = true ]; then
        # Find the framework inside the xcframework
        inner_fw=$(find "$xcframework_path" -name "$name.framework" -type d | head -1)
        if [ -n "$inner_fw" ]; then
          strip_swiftmodule "$inner_fw"
        fi
      fi
    else
      echo "  ⚠ No existing xcframework found, skipping"
      echo ""
      continue
    fi
  fi

  # Zip the xcframework
  zip_path="$OUTPUT_DIR/$name.xcframework.zip"
  echo "  Creating zip..."

  cd "$OUTPUT_DIR"
  rm -f "$name.xcframework.zip"
  zip -r -q "$name.xcframework.zip" "$name.xcframework"
  cd "$SCRIPT_DIR"

  # Get sizes
  xcframework_size=$(du -sh "$xcframework_path" | cut -f1)
  zip_size=$(du -sh "$zip_path" | cut -f1)
  echo "  xcframework: $xcframework_size | zip: $zip_size"
  echo ""
done

# Generate checksums for Package.swift
echo "============================================================"
echo "  Checksums for Package.swift"
echo "============================================================"
echo ""
for entry in "${FRAMEWORKS[@]}"; do
  IFS=':' read -r name relative_path <<< "$entry"
  zip_path="$OUTPUT_DIR/$name.xcframework.zip"

  if [ -f "$zip_path" ]; then
    checksum=$(swift package compute-checksum "$zip_path" 2>/dev/null || shasum -a 256 "$zip_path" | awk '{print $1}')
    echo "\"$name\": \"$checksum\""
  fi
done
echo ""

# Summary
echo "============================================================"
echo "  Build Complete"
echo "============================================================"
echo ""
echo "Output directory: $OUTPUT_DIR"
echo ""
echo "Files created:"
ls -lh "$OUTPUT_DIR"/*.zip 2>/dev/null || echo "  No zip files created"
echo ""
echo "Next steps:"
echo "  1. Upload the .xcframework.zip files to GitHub releases"
echo "  2. Update checksums in Package.swift"
echo "  3. Tag the release"
