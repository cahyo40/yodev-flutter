---
description: Hapus fitur atau halaman yang di-generate yo.dart
---

# Delete Feature / Page

## Steps

1. Cek fitur yang ada:
```bash
ls lib/features/
```

2. Preview file yang akan dihapus:
```bash
dart run yo.dart delete:<nama> --dry-run
```

3. Tanya konfirmasi ke user sebelum menghapus

4. Hapus fitur lengkap (semua layer):
```bash
dart run yo.dart delete:<nama> --delete-feature
```

5. Atau hapus page saja (presentation layer saja):
```bash
dart run yo.dart delete:<nama>
```

6. Bersihkan import dan referensi yang tersisa:
```bash
flutter analyze
```

7. Update router jika perlu (hapus route yang terhapus)

8. Jalankan test untuk memastikan tidak ada yang rusak:
```bash
flutter test
```

## ⚠️ Peringatan
- `--delete-feature` menghapus SELURUH folder feature termasuk data, domain, dan presentation
- Tanpa flag tersebut, hanya presentation layer yang dihapus
- SELALU preview dengan `--dry-run` sebelum menghapus
- Pastikan tidak ada fitur lain yang depend ke fitur yang dihapus
