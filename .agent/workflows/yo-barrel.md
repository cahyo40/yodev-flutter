---
description: Generate barrel/export files dan widget global menggunakan yo.dart
---

# Generate Barrel Files & Global Widgets

// turbo-all

## Barrel Files

Barrel file = file export yang mengumpulkan semua exports dari satu folder.

### Steps

1. Generate barrel files untuk satu feature:
```bash
dart run yo.dart barrel feature:<nama_feature>
```

2. Atau untuk semua features sekaligus:
```bash
dart run yo.dart barrel
```

3. Review file barrel yang dihasilkan:
```bash
cat lib/features/<nama_feature>/<nama_feature>.dart
```

## Global Widgets

### Steps

1. Generate widget global (tersedia di semua fitur):
```bash
dart run yo.dart widget:<nama> --global
```

2. Widget akan dibuat di:
```
lib/core/widgets/<nama>_widget.dart
```

3. Generate widget per fitur:
```bash
dart run yo.dart widget:<nama> --feature=<feature>
```

4. Widget per fitur dibuat di:
```
lib/features/<feature>/presentation/widgets/<nama>_widget.dart
```

## Tips
- Barrel files memudahkan import: satu import untuk semua class di folder itu
- Widget global untuk komponen yang dipakai di banyak fitur (header, footer, custom card)
- Widget per fitur untuk komponen spesifik fitur itu saja
- Generated widget sudah menggunakan YoUI components (YoCard, YoText)
