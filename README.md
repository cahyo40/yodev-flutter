# 🚀 YoDev - Flutter Development Toolkit

[![GitHub](https://img.shields.io/badge/GitHub-cahyo40/yodev--flutter-181717?logo=github)](https://github.com/cahyo40/yodev-flutter)
[![Dart](https://img.shields.io/badge/Dart-3.5+-blue.svg)](https://dart.dev)
[![Flutter](https://img.shields.io/badge/Flutter-3.19+-blue.svg)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![AI Powered](https://img.shields.io/badge/AI-Vibe%20Coding-purple.svg)](#-vibe-coding)

> **🤖 Built for AI Pair Programming**  
> Toolkit lengkap untuk pengembangan Flutter dengan AI — UI Kit + Code Generator dalam satu monorepo terintegrasi.

## 📦 Packages

| Package | Deskripsi | Versi |
|---------|-----------|-------|
| [**yo_ui**](packages/yo_ui/) | UI Component Library — 90+ komponen, 36 color schemes, 51 fonts | `0.0.4` |
| [**yo_generator**](packages/yo_generator/) | Code Generator CLI — Clean Architecture untuk Riverpod, GetX, Bloc | `1.1.0` |

### 🔗 Integrasi YoUI ↔ Generator

Kode yang dihasilkan `yo_generator` **otomatis menggunakan komponen `yo_ui`**:

| Generated Code | YoUI Component |
|----------------|----------------|
| Page scaffold | `YoScaffold` |
| Heading & text | `YoText.heading()`, `YoText()` |
| Buttons | `YoButton.primary/secondary/outline()` |
| Loading state | `YoLoading()` |
| Error handling | `YoErrorState(message:, onRetry:)` |
| Dialogs | `YoConfirmDialog(title:, content:)` |
| Theming | `YoTheme.light()`, `YoTheme.dark()` |

## 🏗️ Struktur Proyek

```
yodev/
├── pubspec.yaml              # Dart Workspace root
├── melos.yaml                # Multi-package management
├── .agent/                   # 🤖 AI Agent integration
│   ├── workflows/            # Workflow automation
│   │   ├── yo-init.md        # /yo-init — Setup project baru
│   │   ├── yo-feature.md     # /yo-feature — Generate fitur lengkap
│   │   └── yo-page.md        # /yo-page — Generate single page
│   └── rules/
│       └── yo-architecture.md # Clean Architecture rules
├── packages/
│   ├── yo_ui/                # Flutter UI Component Library
│   │   ├── lib/              # 90+ widget components
│   │   ├── example/          # Demo app
│   │   └── test/
│   └── yo_generator/         # Flutter Code Generator CLI
│       ├── src/              # Generator source code
│       ├── yo.dart           # CLI entry point
│       └── test/             # 70 tests
└── CHANGELOG.md
```

## 🚀 Quick Start

### 1. Clone & Setup

```bash
git clone https://github.com/cahyo40/yodev-flutter.git
cd yodev-flutter

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
# Dari root monorepo atau dari proyek Flutter target
dart run yo.dart init --state=riverpod
dart run yo.dart page:home
dart run yo.dart page:auth.login
```

## 🤖 AI Agent Workflows

Proyek ini dilengkapi Antigravity workflows yang bisa dipanggil langsung:

| Command | Deskripsi |
|---------|-----------|
| `/yo-init` | Step-by-step inisialisasi project Flutter baru |
| `/yo-feature` | Generate fitur lengkap (page → model → datasource → test) |
| `/yo-page` | Generate single page dengan review |

> Semua workflow menggunakan `// turbo-all` untuk auto-run commands.

## 🛠️ Development Commands

```bash
# Analyze semua packages
melos run analyze

# Test semua packages
melos run test:all

# Test generator saja (70 tests)
melos run test:generator

# Test UI saja
melos run test:ui

# Format semua kode
melos run format
```

## 📖 Dokumentasi

| Dokumen | Isi |
|---------|-----|
| [YoUI README](packages/yo_ui/README.md) | Component showcase, theme setup, 90+ widget examples |
| [YoUI CHANGELOG](packages/yo_ui/CHANGELOG.md) | Version history (v1.0.0 → v0.0.4) |
| [YoGenerator README](packages/yo_generator/README.md) | CLI commands, Vibe Coding guide, architecture reference |
| [YoGenerator CHANGELOG](packages/yo_generator/CHANGELOG.md) | Version history (v1.0.0 → v1.1.0) |
| [Full Generator Docs](packages/yo_generator/YO_GENERATOR.md) | Lengkap: state management patterns, architecture flow |

## 📄 License

MIT License — see [LICENSE](LICENSE)

## 👨‍💻 Author

Created with ❤️ by **Cahyo** — for Flutter developers and AI assistants.
