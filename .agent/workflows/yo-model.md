---
description: Generate dan setup model data dengan yo.dart (freezed / standard)
---

# Generate Model

// turbo-all

## Steps

1. Baca `yo.yaml`:
```bash
cat yo.yaml
```

2. Tanyakan nama model dan field-fieldnya ke user jika belum diberikan

3. Generate model:
```bash
# Standard model (Equatable)
dart run yo.dart model:<nama> --feature=<feature>

# Dengan Freezed (recommended untuk complex models)
dart run yo.dart model:<nama> --feature=<feature> --freezed

# Preview dulu
dart run yo.dart model:<nama> --feature=<feature> --dry-run
```

4. Generate entity yang bersesuaian (jika belum ada):
```bash
dart run yo.dart entity:<nama> --feature=<feature>
```

5. Jika menggunakan freezed, jalankan build_runner:
```bash
dart run build_runner build --delete-conflicting-outputs
```

6. Implement field di model yang di-generate (cari `// TODO`):
```bash
grep -rn "// TODO" lib/features/<feature>/data/models/
```

7. Update mapping model ↔ entity jika perlu

## Tips
- Gunakan `--freezed` untuk model yang butuh copyWith, toJson, equality
- Model ada di `data/models/`, Entity ada di `domain/entities/`
- Model bisa punya JSON serialization, Entity hanya Dart purist
