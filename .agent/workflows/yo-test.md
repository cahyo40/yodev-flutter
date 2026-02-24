---
description: Generate dan jalankan test untuk fitur menggunakan yo.dart
---

# Generate & Run Tests

// turbo-all

## Steps

1. Baca `yo.yaml` untuk state management:
```bash
cat yo.yaml
```

2. Generate test files:
```bash
# Semua test (unit + widget + provider)
dart run yo.dart test:<nama> --feature=<feature>

# Unit test saja
dart run yo.dart test:<nama> --unit --feature=<feature>

# Widget test saja
dart run yo.dart test:<nama> --widget --feature=<feature>

# Provider/controller test saja
dart run yo.dart test:<nama> --provider --feature=<feature>
```

3. Review dan implement test logic:
```bash
grep -rn "// TODO" test/
```

4. Jalankan test:
```bash
flutter test test/features/<feature>/
```

5. Jalankan semua test:
```bash
flutter test
```

6. Cek coverage (opsional):
```bash
flutter test --coverage
```

## Struktur Test

```
test/
├── features/<feature>/
│   ├── data/
│   │   ├── datasources/<name>_datasource_test.dart
│   │   ├── models/<name>_model_test.dart
│   │   └── repositories/<name>_repository_impl_test.dart
│   ├── domain/
│   │   └── usecases/<name>_usecase_test.dart
│   └── presentation/
│       ├── pages/<name>_page_test.dart
│       └── providers/<name>_provider_test.dart  # atau controllers/ atau bloc/
```

## Tips
- Riverpod: test menggunakan `ProviderContainer` dan `override`
- GetX: test menggunakan `Get.put()` dan `Get.testMode`
- BLoC: test menggunakan `blocTest()` dari package `bloc_test`
