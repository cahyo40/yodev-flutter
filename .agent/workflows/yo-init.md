---
description: Inisialisasi project Flutter baru dengan yo.dart generator dan YoUI
---

# Inisialisasi Project Flutter dengan YoDev

// turbo-all

## Prerequisites
- Flutter SDK sudah terinstall
- Dart SDK ^3.5.0

## Steps

1. Buat project Flutter baru (skip jika sudah ada):
```bash
flutter create <nama_project>
cd <nama_project>
```

2. Tambahkan yo_ui dependency di `pubspec.yaml`:
```yaml
dependencies:
  yo_ui:
    path: /path/to/yodev/packages/yo_ui
```

3. Jalankan pub get:
```bash
flutter pub get
```

4. Inisialisasi dengan state management. Tanya user mau pilih yang mana:
   - **Riverpod** (recommended): `dart run yo.dart init --state=riverpod`
   - **GetX**: `dart run yo.dart init --state=getx`
   - **BLoC**: `dart run yo.dart init --state=bloc`

5. Install semua dependencies yang ditambahkan oleh init:
```bash
flutter pub get
```

6. Generate localization:
```bash
flutter gen-l10n
```

7. Jika menggunakan freezed/build_runner:
```bash
dart run build_runner build --delete-conflicting-outputs
```

8. Verifikasi setup:
```bash
flutter analyze
```

## Hasil

Setelah init selesai, project akan memiliki:
- `yo.yaml` - konfigurasi generator
- `lib/core/themes/app_theme.dart` - menggunakan `YoTheme.light/dark()`
- `lib/main.dart` - import yo_ui, setup theme
- `lib/features/home/` - halaman default dengan YoUI components
- `lib/core/config/` - router setup
- `lib/l10n/` - file translasi
- `.vscode/tasks.json` - shortcut untuk generator commands
