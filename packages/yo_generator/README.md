# yo.dart - Flutter Code Generator for AI Vibe Coding

[![Dart](https://img.shields.io/badge/Dart-3.5+-blue.svg)](https://dart.dev)
[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![AI Powered](https://img.shields.io/badge/AI-Vibe%20Coding-purple.svg)](#-vibe-coding-dengan-ai)

> **🤖 Built for AI Pair Programming**  
> Generator kode Flutter yang dirancang khusus untuk membantu AI (Claude, GPT, Gemini) dalam sesi **Vibe Coding** - membuat aplikasi Flutter dengan arsitektur production-ready secara cepat.

## 🎯 Apa itu Vibe Coding?

**Vibe Coding** adalah paradigma baru di mana developer berkolaborasi dengan AI untuk menulis kode. Anda mendeskripsikan apa yang diinginkan, AI membantu implementasinya. `yo.dart` menjadi **jembatan** antara perintah natural language dan struktur kode Flutter yang konsisten.

```
User: "Buatkan halaman login dengan email dan password"
  ↓
AI: dart run yo.dart page:auth.login
  ↓
✅ 12 files generated with Clean Architecture!
  ↓
AI: *implements login logic in generated files*
```

## ✨ Mengapa yo.dart untuk Vibe Coding?

| Masalah | Solusi yo.dart |
|---------|----------------|
| AI generate struktur berbeda setiap kali | ✅ Struktur konsisten dengan Clean Architecture |
| Sulit maintain kode hasil AI | ✅ Separation of concerns yang jelas |
| AI tidak tahu context proyek | ✅ `yo.yaml` menyimpan state management & features |
| Boilerplate code berulang | ✅ Templates production-ready siap pakai |
| State management berbeda tiap file | ✅ Satu state management konsisten per proyek |

## 🚀 Quick Start

### 1. Setup Generator

```bash
cd packages/yo_generator
dart pub get
```

### 2. Inisialisasi Proyek Flutter

```bash
flutter create my_app
cd my_app
# Copy yo_generator ke proyek, atau jalankan dari monorepo

# ✨ Opsi 1: Mode Interaktif (Recommended)
dart run yo.dart --interactive

# ✨ Opsi 2: Command Line
# Pilih state management (AI akan mengikuti pilihan ini)
dart run yo.dart init --state=riverpod
dart run yo.dart init --state=getx
dart run yo.dart init --state=bloc
```

### 3. Generate Features

```bash
dart run yo.dart page:home                    # Full clean architecture
dart run yo.dart page:auth.login              # Sub-feature dengan dot notation
dart run yo.dart page:splash --presentation-only  # UI only
dart run yo.dart page:cart --dry-run          # 🔍 Preview file tanpa menulis
```

## 📋 Commands untuk AI

### Core Commands

```bash
dart run yo.dart init --state=<riverpod|getx|bloc>
dart run yo.dart page:<name> [--presentation-only] [--force]
dart run yo.dart model:<name> [--freezed] [--feature=<name>] [--force]
dart run yo.dart entity:<name> [--feature=<name>] [--force]
dart run yo.dart controller:<name> [--cubit] [--feature=<name>] [--force]
dart run yo.dart datasource:<name> [--remote|--local|--both] [--force]
dart run yo.dart usecase:<name> [--feature=<name>] [--force]
dart run yo.dart repository:<name> [--feature=<name>] [--force]
```

### Infrastructure Commands

```bash
dart run yo.dart network [--force]    # Dio client + interceptors
dart run yo.dart di [--force]         # Dependency injection setup
```

### UI Components

```bash
dart run yo.dart screen:<name> [--feature=<name>] [--force]
dart run yo.dart dialog:<name> [--feature=<name>] [--force]
dart run yo.dart widget:<name> [--feature=<name>|--global] [--force]
dart run yo.dart service:<name> [--force]
```

### Testing Commands

```bash
dart run yo.dart test:<name> [--feature=<name>]  # Generate all tests
dart run yo.dart test:<name> --unit              # Unit tests only
dart run yo.dart test:<name> --widget            # Widget tests only
dart run yo.dart test:<name> --provider          # Provider/controller tests
dart run yo.dart test:<name> --force             # Overwrite existing tests
```

### Utilities

```bash
dart run yo.dart barrel [feature:<feature>] # 🧱 Generate barrel/export files
dart run yo.dart translation --key=<key> --en="txt" --id="teks"
dart run yo.dart package-name:com.company.app
dart run yo.dart app-name:"My App"
dart run yo.dart delete:<name> [--delete-feature]
```

### 🌍 Global Flags

Semua command mendukung flag berikut:

- `--dry-run` : Preview perubahan tanpa menulis file (Aman untuk cek!)
- `--force` : Overwrite file yang sudah ada
- `--interactive` / `-i` : Jalankan mode interaktif (Wizard)

## 📁 Clean Architecture Output

```
lib/
├── core/
│   ├── config/          # Router
│   ├── di/              # Dependency injection
│   ├── network/         # Dio + Interceptors
│   ├── themes/          # Material 3 Theme
│   └── widgets/         # Global widgets
├── features/
│   └── <feature>/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── pages/
│           ├── providers/     # Riverpod
│           ├── controllers/   # GetX
│           └── bloc/          # Bloc
└── l10n/
```

## 🏷️ Naming Convention

| Input | Class | File | Feature Folder |
|-------|-------|------|----------------|
| `home` | `Home` | `home.dart` | `features/home/` |
| `setting.profile` | `SettingProfile` | `setting_profile.dart` | `features/setting/` |
| `user.auth.login` | `UserAuthLogin` | `user_auth_login.dart` | `features/user/` |

## 🤖 Vibe Coding dengan AI

### Instruksi untuk AI Agent

Saat bekerja dengan proyek yang memiliki `yo.yaml`:

1. **Baca `yo.yaml`** untuk mengetahui state management aktif
2. **Gunakan generator** sebelum menulis kode manual
3. **Implementasi logic** di file yang sudah di-generate
4. **Cari marker `// TODO`** sebagai panduan implementasi

### Contoh Prompt ke AI

```
"Buatkan fitur shopping cart dengan:
- List produk yang bisa di-add/remove
- Total harga otomatis
- Checkout dengan form alamat"
```

AI akan menjalankan:

```bash
dart run yo.dart page:cart
dart run yo.dart page:cart.checkout
dart run yo.dart model:product --feature=cart
dart run yo.dart model:cart.item --feature=cart
```

Lalu mengimplementasi logic di file yang sudah ter-generate.

## 📖 Dokumentasi Lengkap

Lihat [YO_GENERATOR.md](YO_GENERATOR.md) untuk panduan lengkap termasuk:

- State management patterns (Riverpod, GetX, Bloc)
- Architecture flow diagrams
- Post-generation tasks
- AI workflow guidelines
- Dependencies reference

## 📄 License

MIT License - see [LICENSE](LICENSE)

## 👨‍💻 Author

Created with ❤️ for Flutter developers and AI assistants.
