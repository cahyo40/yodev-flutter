# YoDev Architecture Rules

## Clean Architecture

Project Flutter yang menggunakan yo.dart HARUS mengikuti struktur Clean Architecture:

```
lib/features/<feature>/
├── data/           # Implementasi (API calls, models, local storage)
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/         # Business logic (pure Dart, no framework dependency)
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/   # UI (Flutter widgets + state management)
    ├── pages/
    ├── screens/
    └── providers|controllers|bloc/
```

## Aturan

1. **Domain layer TIDAK boleh depend ke data/presentation layer**
2. **Presentation layer berkomunikasi ke domain via usecase**
3. **Data layer mengimplementasi interface dari domain**
4. **JANGAN buat file manual di struktur ini — gunakan yo.dart generator**
5. **Satu state management per project** — cek `yo.yaml` sebelum coding

## Naming Convention

- Feature folder: `snake_case` (contoh: `user_profile`)
- Class name: `PascalCase` (contoh: `UserProfile`)
- File name: `snake_case.dart` (contoh: `user_profile_page.dart`)
- Dot notation untuk sub-feature: `auth.login` → folder `features/auth/`, class `AuthLogin`

## YoUI Components

Semua generated code otomatis menggunakan komponen dari `yo_ui`. JANGAN replace dengan widget Flutter standar kecuali ada alasan spesifik. Komponen yang dipakai:

- `YoScaffold` bukan `Scaffold`
- `YoText` / `YoText.heading()` bukan `Text`
- `YoButton` bukan `ElevatedButton`
- `YoLoading` bukan `CircularProgressIndicator`
- `YoErrorState` bukan manual Column + Text
- `YoConfirmDialog` bukan `AlertDialog`
- `YoCard` bukan `Container` + `BoxDecoration`
- `YoTheme.light/dark()` bukan manual `ThemeData`
