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

Ada **2 cara** pakai YoDev, tergantung kebutuhan:

| | **Cara A: YoUI Saja** | **Cara B: YoUI + Generator** |
|---|---|---|
| Cocok untuk | Pakai komponen UI saja | Generate kode otomatis + komponen UI |
| Install | Tambah git dependency | Clone repo + copy file generator |
| Perlu clone? | ❌ Tidak | ✅ Ya |

---

### Cara A: Pakai YoUI Saja (Tanpa Generator)

Kalau kamu hanya butuh komponen UI, cukup tambahkan sebagai dependency:

**1. Tambahkan ke `pubspec.yaml`:**

```yaml
dependencies:
  flutter:
    sdk: flutter
  yo_ui:
    git:
      url: https://github.com/cahyo40/yodev-flutter.git
      path: packages/yo_ui
```

**2. Install:**

```bash
flutter pub get
```

**3. Pasang theme di `main.dart`:**

```dart
import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Pilih font (opsional)
  YoTextTheme.setFont(primary: YoFonts.poppins, secondary: YoFonts.inter);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: YoTheme.lightTheme(context, YoColorScheme.techPurple),
      darkTheme: YoTheme.darkTheme(context, YoColorScheme.techPurple),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}
```

**Selesai!** Langsung pakai komponen seperti `YoButton`, `YoCard`, `YoText`, dll.

---

### Cara B: Pakai YoUI + Generator (Full Toolkit)

Generator (`yo.dart`) butuh **source code** karena dijalankan dengan `dart run yo.dart`, bukan library biasa. Jadi harus copy file-nya ke project kamu.

**1. Clone repo:**

```bash
git clone https://github.com/cahyo40/yodev-flutter.git
```

**2. Buat project Flutter & copy generator:**

```bash
flutter create my_app
cd my_app

# Copy file generator ke project kamu
cp ../yodev-flutter/packages/yo_generator/yo.dart .
cp -r ../yodev-flutter/packages/yo_generator/src .
```

**3. Tambahkan YoUI + dependencies generator ke `pubspec.yaml`:**

```yaml
dependencies:
  flutter:
    sdk: flutter
  yo_ui:
    git:
      url: https://github.com/cahyo40/yodev-flutter.git
      path: packages/yo_ui
  # Dependencies yang dibutuhkan generator
  args: ^2.4.2
  yaml: ^3.1.2
  path: ^1.8.3
  recase: ^4.1.0
```

```bash
flutter pub get
```

**4. Init project:**

```bash
dart run yo.dart init --state=riverpod   # atau getx / bloc
```

Ini otomatis membuat:
- `lib/core/themes/app_theme.dart` — tema dengan YoUI
- `main.dart` — sudah setup `AppTheme.init()` + routing
- `yo.yaml` — konfigurasi generator

**5. Generate fitur:**

```bash
dart run yo.dart page:home                  # full clean architecture
dart run yo.dart page:auth.login            # sub-feature
dart run yo.dart model:user --feature=auth  # model
```

> 💡 **Struktur file setelah copy:**
> ```
> my_app/
> ├── yo.dart          # ← CLI entry point
> ├── src/             # ← generator source code
> ├── yo.yaml          # ← dibuat oleh init
> ├── lib/
> │   ├── core/        # ← dibuat oleh init
> │   └── features/    # ← dibuat per generate
> └── pubspec.yaml
> ```

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
