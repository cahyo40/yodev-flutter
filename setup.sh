#!/bin/bash

# ═══════════════════════════════════════════════════════════
#  YoDev Setup Script
#  Setup yo_ui + yo_generator di project Flutter kamu
# ═══════════════════════════════════════════════════════════

set -e

# Warna
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Path ke repo yodev (folder tempat script ini berada)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GENERATOR_DIR="$SCRIPT_DIR/packages/yo_generator"
TARGET_DIR="${1:-.}"

echo -e "${BLUE}╔═══════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║         🚀 YoDev Setup Script                 ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════╝${NC}"
echo ""

# Validasi: pastikan ini dijalankan dari repo yodev
if [ ! -f "$GENERATOR_DIR/yo.dart" ]; then
  echo -e "${RED}❌ Error: yo.dart tidak ditemukan di $GENERATOR_DIR${NC}"
  echo -e "${YELLOW}💡 Pastikan script ini dijalankan dari root repo yodev-flutter${NC}"
  exit 1
fi

# Validasi: pastikan target adalah project Flutter
if [ ! -f "$TARGET_DIR/pubspec.yaml" ]; then
  echo -e "${RED}❌ Error: pubspec.yaml tidak ditemukan di $TARGET_DIR${NC}"
  echo -e "${YELLOW}💡 Pastikan target adalah project Flutter yang valid${NC}"
  echo -e "${YELLOW}   Usage: bash setup.sh /path/ke/project/flutter${NC}"
  exit 1
fi

TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

echo -e "${GREEN}📁 Target: $TARGET_DIR${NC}"
echo ""

# Step 1: Copy generator files
echo -e "${BLUE}[1/3]${NC} Copy generator files..."
cp "$GENERATOR_DIR/yo.dart" "$TARGET_DIR/"
cp -r "$GENERATOR_DIR/src" "$TARGET_DIR/"
echo -e "  ✅ yo.dart"
echo -e "  ✅ src/"

# Step 2: Tambah yo_ui dependency ke pubspec.yaml
echo ""
echo -e "${BLUE}[2/3]${NC} Menambahkan dependencies..."

# Cek apakah yo_ui sudah ada di pubspec.yaml
if grep -q "yo_ui:" "$TARGET_DIR/pubspec.yaml"; then
  echo -e "  ⏭️  yo_ui sudah ada di pubspec.yaml"
else
  # Tambahkan yo_ui sebagai git dependency
  # Cari baris 'dependencies:' dan tambahkan setelahnya
  if grep -q "dependencies:" "$TARGET_DIR/pubspec.yaml"; then
    # Menggunakan sed untuk menambah dependency
    sed -i '/^dependencies:/a\  yo_ui:\n    git:\n      url: https://github.com/cahyo40/yodev-flutter.git\n      path: packages/yo_ui' "$TARGET_DIR/pubspec.yaml"
    echo -e "  ✅ yo_ui (git dependency)"
  else
    echo -e "  ${YELLOW}⚠️  'dependencies:' tidak ditemukan. Tambahkan yo_ui secara manual.${NC}"
  fi
fi

# Cek dan tambahkan dependencies yang dibutuhkan generator
for dep in "args: ^2.4.2" "yaml: ^3.1.2" "path: ^1.8.3" "recase: ^4.1.0"; do
  dep_name=$(echo "$dep" | cut -d: -f1)
  if grep -q "$dep_name:" "$TARGET_DIR/pubspec.yaml"; then
    echo -e "  ⏭️  $dep_name sudah ada"
  else
    sed -i "/^dependencies:/a\  $dep" "$TARGET_DIR/pubspec.yaml"
    echo -e "  ✅ $dep_name"
  fi
done

# Step 3: flutter pub get
echo ""
echo -e "${BLUE}[3/3]${NC} Menjalankan flutter pub get..."
cd "$TARGET_DIR" && flutter pub get 2>/dev/null && echo -e "  ✅ Dependencies installed" || echo -e "  ${YELLOW}⚠️  flutter pub get gagal. Jalankan manual.${NC}"

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ Setup selesai!${NC}"
echo ""
echo -e "Langkah selanjutnya:"
echo -e "  ${BLUE}cd $TARGET_DIR${NC}"
echo -e "  ${BLUE}dart run yo.dart init --state=riverpod${NC}  # atau getx / bloc"
echo -e "  ${BLUE}dart run yo.dart page:home${NC}"
echo ""
echo -e "Dokumentasi: https://github.com/cahyo40/yodev-flutter"
echo -e "${GREEN}═══════════════════════════════════════════════${NC}"
