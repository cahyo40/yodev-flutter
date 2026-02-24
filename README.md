# 🚀 YoDev - Flutter Development Toolkit

[![GitHub](https://img.shields.io/badge/GitHub-cahyo40/yodev--flutter-181717?logo=github)](https://github.com/cahyo40/yodev-flutter)
[![Dart](https://img.shields.io/badge/Dart-3.5+-blue.svg)](https://dart.dev)
[![Flutter](https://img.shields.io/badge/Flutter-3.19+-blue.svg)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

> Toolkit lengkap untuk pengembangan Flutter — **UI Kit** + **Code Generator** dalam satu paket.

## 📦 Isinya Apa?

YoDev punya 2 package:

| Package | Fungsi |
|---------|--------|
| [**yo_ui**](packages/yo_ui/) | Library 90+ komponen UI siap pakai (tombol, kartu, form, chart, dll) |
| [**yo_generator**](packages/yo_generator/) | CLI tool yang generate kode Flutter secara otomatis |

**Hubungannya:** Kalau kamu generate kode pakai `yo_generator`, kode yang dihasilkan **otomatis pakai komponen `yo_ui`**. Jadi 2 package ini saling terintegrasi.

---

## 🚀 Mulai dari Nol

### Step 1: Clone Project

```bash
git clone https://github.com/cahyo40/yodev-flutter.git
cd yodev-flutter
```

### Step 2: Install Dependencies

```bash
# Install Melos (alat untuk kelola multi-package)
dart pub global activate melos

# Install semua dependencies
melos bootstrap
```

### Step 3: Buat Project Flutter Baru

```bash
flutter create my_app
cd my_app
```

### Step 4: Tambahkan YoUI ke Project Kamu

Edit `pubspec.yaml` di project Flutter kamu:

```yaml
dependencies:
  flutter:
    sdk: flutter
  yo_ui:
    path: /path/ke/yodev-flutter/packages/yo_ui  # sesuaikan path
```

Lalu jalankan:

```bash
flutter pub get
```

### Step 5: Pasang Theme di `main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      // ✨ Pakai YoTheme — otomatis dapat warna, font, shadow yang konsisten
      theme: YoTheme.light(
        colorScheme: YoColorScheme.blue,     // pilih warna (ada 36 pilihan)
        fontFamily: YoFonts.inter,           // pilih font (ada 51 pilihan)
      ),
      darkTheme: YoTheme.dark(
        colorScheme: YoColorScheme.blue,
        fontFamily: YoFonts.inter,
      ),
      themeMode: ThemeMode.system,           // otomatis ikut pengaturan HP
      home: const HomePage(),
    );
  }
}
```

### Step 6: Mulai Pakai Komponen

```dart
import 'package:yo_ui/yo_ui.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return YoScaffold(
      appBar: AppBar(title: YoText.heading('Home')),
      body: YoColumn(
        spacing: 16,  // jarak antar widget 16px
        children: [
          // Teks
          YoText.headlineMedium('Selamat Datang!'),
          YoText.bodyMedium('Ini adalah halaman pertamamu.'),

          // Tombol
          YoButton.primary(
            text: 'Mulai',
            onPressed: () {
              // aksi ketika tombol ditekan
            },
          ),

          // Kartu
          YoCard(
            child: YoText('Ini konten di dalam kartu'),
          ),
        ],
      ),
    );
  }
}
```

**Selesai!** 🎉 Kamu sudah bisa pakai YoUI.

---

## 🎨 Contoh Komponen yang Tersedia

### Tombol

```dart
YoButton.primary(text: 'Simpan', onPressed: () {})        // tombol utama (warna penuh)
YoButton.secondary(text: 'Batal', onPressed: () {})       // tombol sekunder
YoButton.outline(text: 'Detail', onPressed: () {})        // tombol garis tepi saja
YoButton.ghost(text: 'Lewati', onPressed: () {})          // tombol tanpa background
```

### Loading & Error

```dart
// Tampilkan loading spinner
const YoLoading()

// Tampilkan pesan error + tombol coba lagi
YoErrorState(
  message: 'Gagal memuat data',
  onRetry: () {
    // muat ulang data
  },
)

// Tampilkan halaman kosong
YoEmptyState(
  message: 'Belum ada data',
  icon: Icons.inbox,
)
```

### Toast (Notifikasi Kecil)

```dart
// Tampilkan pesan sukses
YoToast.success(context: context, message: 'Data berhasil disimpan!')

// Tampilkan pesan error
YoToast.error(context: context, message: 'Gagal menyimpan')

// Tampilkan pesan info
YoToast.info(context: context, message: 'Sedang diproses...')
```

### Dialog

```dart
// Dialog konfirmasi (misalnya konfirmasi hapus)
YoConfirmDialog(
  title: 'Hapus Data?',
  content: YoText('Data yang dihapus tidak bisa dikembalikan'),
  onConfirm: () {
    // hapus data
  },
)
```

### Form

```dart
YoForm(
  onSubmit: (values) {
    // semua nilai form
  },
  children: [
    YoTextFormField(label: 'Nama', hint: 'Masukkan nama'),
    YoTextFormField(label: 'Email', hint: 'contoh@email.com'),
    YoDropdown<String>(label: 'Kota', items: [...], onChanged: (v) {}),
  ],
)
```

### Lainnya

```dart
YoCarousel(images: [...], autoPlay: true)       // slider gambar
YoDataTable(columns: [...], rows: [...])        // tabel data
YoAvatar(url: '...', radius: 24)               // foto profil bulat
YoBadge(count: 3, child: Icon(Icons.mail))      // ikon dengan angka
YoRating(value: 4.5)                            // bintang rating
YoShimmer.card(height: 120)                     // animasi loading skeleton
YoStepper(currentStep: 0, steps: [...])         // wizard bertahap
YoPagination(currentPage: 1, totalPages: 10)    // navigasi halaman
```

> 📖 Lihat daftar **90+ komponen lengkap** di [yo_ui README](packages/yo_ui/README.md)

---

## ⚡ Code Generator (Opsional)

Kalau kamu mau generate kode otomatis dengan Clean Architecture:

```bash
# 1. Init project (pilih state management)
dart run yo.dart init --state=riverpod

# 2. Generate halaman (otomatis buat 12 file: page, model, repository, dll)
dart run yo.dart page:home
dart run yo.dart page:auth.login

# 3. Generate model
dart run yo.dart model:user --feature=auth

# 4. Preview dulu tanpa generate file
dart run yo.dart page:cart --dry-run
```

> 📖 Lihat semua commands di [yo_generator README](packages/yo_generator/README.md)

---

## 🤖 AI Workflows

Kalau kamu pakai AI assistant (Antigravity, Claude, dll), project ini punya workflows otomatis:

| Command | Fungsi |
|---------|--------|
| `/yo-init` | Setup project Flutter baru |
| `/yo-feature` | Generate fitur lengkap |
| `/yo-page` | Generate satu halaman |
| `/yo-model` | Generate model data |
| `/yo-test` | Generate & jalankan test |
| `/yo-network` | Setup Dio + interceptors |
| `/yo-delete` | Hapus fitur |
| `/yo-translate` | Tambah terjemahan (bisa juga translate fitur yang sudah ada) |
| `/yo-barrel` | Generate file export |

---

## 🏗️ Struktur Project

```
yodev-flutter/
├── packages/
│   ├── yo_ui/            # 90+ komponen UI
│   └── yo_generator/     # CLI code generator
├── .agent/
│   ├── workflows/        # 9 workflow untuk AI
│   └── rules/            # 5 aturan untuk AI
├── pubspec.yaml
├── melos.yaml
├── CHANGELOG.md
└── README.md             # ← kamu di sini
```

## 📖 Dokumentasi

| Dokumen | Isi |
|---------|-----|
| [yo_ui README](packages/yo_ui/README.md) | 90+ komponen, theme, color, font |
| [yo_generator README](packages/yo_generator/README.md) | Semua CLI commands |
| [CHANGELOG](CHANGELOG.md) | Riwayat perubahan |

## 📄 License

MIT License — see [LICENSE](LICENSE)

## 👨‍💻 Author

Created with ❤️ by **Cahyo** — for Flutter developers and AI assistants.
