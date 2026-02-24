---
description: Generate fitur lengkap dengan clean architecture menggunakan yo.dart
---

# Generate Fitur Lengkap

// turbo-all

## Prerequisites
- Project sudah di-init dengan `dart run yo.dart init --state=<state>`
- File `yo.yaml` ada di root project
- `flutter pub get` sudah dijalankan

## Steps

1. Baca `yo.yaml` untuk mengetahui state management yang digunakan:
```bash
cat yo.yaml
```

2. Tanyakan nama fitur ke user jika belum diberikan. Gunakan format:
   - Simple: `home`, `profile`, `settings`
   - Nested: `auth.login`, `auth.register`, `cart.checkout`

3. Generate page (full clean architecture):
```bash
dart run yo.dart page:<nama_fitur>
```
Ini akan menghasilkan:
- `presentation/pages/` - Page dengan YoScaffold, YoLoading, YoErrorState
- `presentation/providers|controllers|bloc/` - State management
- `domain/entities/`, `domain/repositories/`, `domain/usecases/`
- `data/models/`, `data/datasources/`, `data/repositories/`

4. Jika perlu model tambahan:
```bash
dart run yo.dart model:<nama_model> --feature=<nama_fitur> --freezed
```

5. Jika perlu datasource tambahan:
```bash
dart run yo.dart datasource:<nama> --both --feature=<nama_fitur>
```

6. Jika perlu usecase tambahan:
```bash
dart run yo.dart usecase:<nama> --feature=<nama_fitur>
```

7. Generate tests:
```bash
dart run yo.dart test:<nama_fitur> --feature=<nama_fitur>
```

8. Review file yang di-generate, cari marker `// TODO` dan implementasi logic:
```bash
grep -rn "// TODO" lib/features/<nama_fitur>/
```

9. Jika menggunakan freezed, jalankan code generation:
```bash
dart run build_runner build --delete-conflicting-outputs
```

10. Verifikasi:
```bash
flutter analyze
```

## Tips
- Gunakan `--dry-run` untuk preview sebelum generate
- Gunakan `--force` untuk overwrite file yang sudah ada
- Gunakan `--presentation-only` jika hanya butuh UI layer
- Generated code sudah menggunakan YoUI components secara otomatis
