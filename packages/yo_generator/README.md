# yo.dart - Flutter Code Generator CLI

[![Dart](https://img.shields.io/badge/Dart-3.5+-blue.svg)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Tests](https://img.shields.io/badge/Tests-70%20passing-brightgreen.svg)](#)
[![Version](https://img.shields.io/badge/version-1.1.0-blue.svg)](CHANGELOG.md)

> **🤖 Built for AI Vibe Coding**  
> Generator kode Flutter dengan Clean Architecture — support **Riverpod**, **GetX**, dan **Bloc** dalam satu CLI tool.

## 🎯 Apa itu yo.dart?

CLI tool yang menghasilkan kode Flutter berstruktur Clean Architecture secara konsisten. Cocok untuk AI pair programming (Vibe Coding) maupun pengembangan manual.

```
User: "Buatkan halaman login"
  ↓
AI: dart run yo.dart page:auth.login
  ↓
✅ 12 files generated (presentation + domain + data layers)
  ↓
AI: implements logic di file // TODO markers
```

## 🚀 Quick Start

### 1. Setup

```bash
dart pub get
```

### 2. Init Project

```bash
# Di project Flutter target
dart run yo.dart init --state=riverpod   # atau getx / bloc

# Mode interaktif (wizard)
dart run yo.dart --interactive
```

### 3. Generate

```bash
dart run yo.dart page:home                        # Full clean architecture
dart run yo.dart page:auth.login                  # Sub-feature (dot notation)
dart run yo.dart page:splash --presentation-only  # UI layer saja
dart run yo.dart page:cart --dry-run               # Preview tanpa menulis
```

---

## 📋 Semua Commands

### Project Init

```bash
dart run yo.dart init --state=<riverpod|getx|bloc>
```

### Page & Feature

```bash
dart run yo.dart page:<name>                     # Full clean architecture
dart run yo.dart page:<name> --presentation-only  # UI saja
dart run yo.dart page:<name> --dry-run            # Preview
dart run yo.dart page:<name> --force              # Overwrite
```

### Model & Entity

```bash
dart run yo.dart model:<name> [--freezed] [--feature=<name>]
dart run yo.dart entity:<name> [--feature=<name>]
```

### Controller / Provider / BLoC

```bash
dart run yo.dart controller:<name> [--feature=<name>]
dart run yo.dart controller:<name> --cubit  # khusus Bloc
```

### Data Layer

```bash
dart run yo.dart datasource:<name> --remote [--feature=<name>]
dart run yo.dart datasource:<name> --local  [--feature=<name>]
dart run yo.dart datasource:<name> --both   [--feature=<name>]
dart run yo.dart repository:<name> [--feature=<name>]
dart run yo.dart usecase:<name> [--feature=<name>]
```

### Infrastructure

```bash
dart run yo.dart network   # Dio client + interceptors
dart run yo.dart di         # Dependency injection setup
```

### UI Components

```bash
dart run yo.dart screen:<name> [--feature=<name>]
dart run yo.dart dialog:<name> [--feature=<name>]
dart run yo.dart widget:<name> [--feature=<name>|--global]
dart run yo.dart service:<name>
```

### Testing

```bash
dart run yo.dart test:<name> [--feature=<name>]  # Semua test
dart run yo.dart test:<name> --unit              # Unit saja
dart run yo.dart test:<name> --widget            # Widget saja
dart run yo.dart test:<name> --provider          # Provider/controller
```

### Utilities

```bash
dart run yo.dart barrel [feature:<name>]                            # Export files
dart run yo.dart translation --key=welcome --en="Hello" --id="Halo"
dart run yo.dart package-name:com.company.app
dart run yo.dart app-name:"My App"
dart run yo.dart delete:<name> [--delete-feature]
```

### Global Flags

| Flag | Keterangan |
|------|------------|
| `--dry-run` | Preview tanpa menulis file |
| `--force` | Overwrite file yang sudah ada |
| `--interactive` / `-i` | Mode wizard interaktif |
| `--presentation-only` | Generate UI layer saja |
| `--freezed` | Gunakan freezed untuk model |

---

## 📁 Output: Clean Architecture

```
lib/
├── core/
│   ├── config/          # Router (go_router / GetX routes)
│   ├── di/              # Dependency injection
│   ├── network/         # Dio + Interceptors
│   ├── themes/          # AppTheme (light/dark)
│   └── widgets/         # Global widgets
├── features/
│   └── <feature>/
│       ├── data/
│       │   ├── datasources/     # API calls, local storage
│       │   ├── models/          # JSON serialization
│       │   └── repositories/    # Repository implementations
│       ├── domain/
│       │   ├── entities/        # Business objects (pure Dart)
│       │   ├── repositories/    # Abstract interfaces
│       │   └── usecases/        # Business logic
│       └── presentation/
│           ├── pages/           # UI pages
│           ├── providers/       # Riverpod
│           ├── controllers/     # GetX
│           └── bloc/            # BLoC/Cubit
└── l10n/                        # Localization (en, id)
```

## 🏷️ Naming Convention

Gunakan **dot notation** untuk sub-feature:

| Input | Class | File | Feature |
|-------|-------|------|---------|
| `home` | `Home` | `home.dart` | `features/home/` |
| `setting.profile` | `SettingProfile` | `setting_profile.dart` | `features/setting/` |
| `user.auth.login` | `UserAuthLogin` | `user_auth_login.dart` | `features/user/` |

## ⚙️ yo.yaml

File konfigurasi yang dibuat otomatis saat `init`:

```yaml
project_name: my_app
state_management: riverpod   # riverpod | bloc | getx
use_freezed: true
use_go_router: true
localization:
  - en
  - id
```

> **⚠️ Penting:** Selalu baca `yo.yaml` sebelum generate. Jangan mix state management!

## 🤖 Panduan AI Agent

1. **Baca `yo.yaml`** → tahu state management aktif
2. **Gunakan generator** → jangan tulis struktur manual
3. **Cari `// TODO`** → marker di file yang di-generate
4. **Implementasi logic** → di tempat yang tepat

### Contoh Workflow

```bash
# Fitur authentication
dart run yo.dart page:auth.login
dart run yo.dart page:auth.register
dart run yo.dart model:user --feature=auth --freezed
dart run yo.dart datasource:auth --remote --feature=auth
dart run yo.dart usecase:login --feature=auth
dart run yo.dart test:auth --feature=auth
```

## 📖 Dokumentasi Lengkap

| File | Isi |
|------|-----|
| [YO_GENERATOR.md](YO_GENERATOR.md) | Full docs: architecture flow, state management patterns, AI guidelines |
| [CHANGELOG.md](CHANGELOG.md) | Version history v1.0.0 → v1.1.0 |
| [dependencies.yaml](dependencies.yaml) | Daftar dependencies per state management |

## 📄 License

MIT License — see [LICENSE](LICENSE)
