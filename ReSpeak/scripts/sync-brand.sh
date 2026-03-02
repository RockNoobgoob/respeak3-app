#!/usr/bin/env bash
# sync-brand.sh
# ReSpeak — HovaRehab BrandKit sync script
#
# Runs the BrandKit token generators and copies the output Swift files
# into the ReSpeak/Theme/ directory.
#
# Usage (from ReSpeak/ or ReSpeak.xcodeproj directory):
#   bash ReSpeak/scripts/sync-brand.sh
#
# Xcode Build Phase ("Run Script", before Compile Sources):
#   bash "$SRCROOT/scripts/sync-brand.sh"
#
# Prerequisites:
#   - Node.js >= 18 and npm must be on PATH
#   - brandkit/ must exist at the monorepo root (one level above ReSpeak/)

set -euo pipefail

# ---------------------------------------------------------------------------
# Resolve paths
# ---------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IOS_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MONOREPO_ROOT="$(cd "$IOS_ROOT/.." && pwd)"
BRANDKIT_DIR="$MONOREPO_ROOT/brandkit"
THEME_DIR="$IOS_ROOT/Theme"
GENERATED_IOS_DIR="$BRANDKIT_DIR/generated/ios"

# ---------------------------------------------------------------------------
# Validation
# ---------------------------------------------------------------------------

if [ ! -d "$BRANDKIT_DIR" ]; then
  echo "ERROR: brandkit directory not found at $BRANDKIT_DIR"
  echo "  Run the brandkit setup first, or init the git submodule:"
  echo "    git submodule update --init --recursive"
  exit 1
fi

if [ ! -d "$THEME_DIR" ]; then
  echo "INFO: Creating Theme directory at $THEME_DIR"
  mkdir -p "$THEME_DIR"
fi

# ---------------------------------------------------------------------------
# Step 1 — install brandkit dependencies
# ---------------------------------------------------------------------------

echo "[sync-brand] Installing brandkit dependencies..."
cd "$BRANDKIT_DIR"
npm install --silent

# ---------------------------------------------------------------------------
# Step 2 — run iOS generator
# ---------------------------------------------------------------------------

echo "[sync-brand] Running iOS token generator..."
npm run gen:ios

# ---------------------------------------------------------------------------
# Step 3 — copy generated Swift files into Theme/
# ---------------------------------------------------------------------------

echo "[sync-brand] Copying generated Swift files to $THEME_DIR..."

SWIFT_FILES=("BrandColors.swift" "BrandTypography.swift" "BrandLayout.swift")

for file in "${SWIFT_FILES[@]}"; do
  src="$GENERATED_IOS_DIR/$file"
  dst="$THEME_DIR/$file"

  if [ ! -f "$src" ]; then
    echo "ERROR: Expected generated file not found: $src"
    exit 1
  fi

  cp "$src" "$dst"
  echo "  Copied $file -> ReSpeak/Theme/$file"
done

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------

echo ""
echo "[sync-brand] SUCCESS — BrandKit tokens synced to ReSpeak/Theme/"
echo ""
echo "Files updated:"
for file in "${SWIFT_FILES[@]}"; do
  echo "  ReSpeak/Theme/$file"
done
echo ""
