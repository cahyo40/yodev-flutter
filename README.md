# 🚀 YoDev - Flutter Development Toolkit

[![Dart](https://img.shields.io/badge/Dart-3.5+-blue.svg)](https://dart.dev)
[![Flutter](https://img.shields.io/badge/Flutter-3.19+-blue.svg)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![AI Powered](https://img.shields.io/badge/AI-Vibe%20Coding-purple.svg)](#-vibe-coding)

> **🤖 Built for AI Pair Programming**  
> Toolkit lengkap untuk pengembangan Flutter dengan AI — UI Kit + Code Generator dalam satu proyek terpadu.

## 📦 Packages

YoDev terdiri dari dua package yang saling terintegrasi:

| Package | Deskripsi | Versi |
|---------|-----------|-------|
| [**yo_ui**](packages/yo_ui/) | UI Component Library - 90+ komponen, 36 color schemes, 51 fonts | `0.0.4` |
| [**yo_generator**](packages/yo_generator/) | Code Generator CLI - Clean Architecture generator untuk Riverpod, GetX, Bloc | `1.0.0` |

### 🔗 Integrasi

Kode yang dihasilkan `yo_generator` **otomatis menggunakan komponen `yo_ui`**:
- `YoScaffold`, `YoText`, `YoButton` di setiap halaman
- `YoLoading`, `YoErrorState` untuk loading & error handling
- `YoConfirmDialog` untuk dialog
- `YoTheme` untuk theming (light & dark)

## 🏗️ Struktur Proyek

```
yodev/
├── pubspec.yaml          # Root workspace
├── melos.yaml            # Multi-package management
├── packages/
│   ├── yo_ui/            # Flutter UI Component Library
│   │   ├── lib/          # 90+ widget components
│   │   ├── example/      # Demo app
│   │   └── test/
│   └── yo_generator/     # Flutter Code Generator CLI
│       ├── src/           # Generator source code
│       ├── yo.dart        # CLI entry point
│       └── test/
```

## 🚀 Quick Start

### 1. Setup Monorepo

```bash
cd yodev

# Install Melos (jika belum)
dart pub global activate melos

# Bootstrap semua packages
melos bootstrap
```

### 2. Gunakan YoUI di Proyek Flutter

```yaml
# pubspec.yaml proyek Anda
dependencies:
  yo_ui:
    path: /path/to/yodev/packages/yo_ui
```

### 3. Gunakan Code Generator

```bash
cd packages/yo_generator
dart pub get
dart run yo.dart init --state=riverpod
dart run yo.dart page:home
```

## 🛠️ Development Commands

```bash
# Analyze semua packages
melos run analyze

# Test semua packages
melos run test:all

# Test generator saja
melos run test:generator

# Test UI saja
melos run test:ui

# Format semua kode
melos run format
```

## 📖 Dokumentasi

- [YoUI - Component Guide](packages/yo_ui/README.md)
- [YoGenerator - CLI Reference](packages/yo_generator/README.md)
- [YoGenerator - Full Documentation](packages/yo_generator/YO_GENERATOR.md)

## 📄 License

MIT License - see [LICENSE](LICENSE)

## 👨‍💻 Author

Created with ❤️ by Cahyo — for Flutter developers and AI assistants.
