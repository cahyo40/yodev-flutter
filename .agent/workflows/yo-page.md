---
description: Generate single page Flutter dengan yo.dart generator
---

# Generate Single Page

// turbo-all

## Prerequisites
- File `yo.yaml` ada di root project

## Steps

1. Baca `yo.yaml`:
```bash
cat yo.yaml
```

2. Tanyakan nama page ke user jika belum diberikan

3. Generate page:
```bash
# Full clean architecture (semua layer)
dart run yo.dart page:<nama>

# Presentation only (UI saja)
dart run yo.dart page:<nama> --presentation-only

# Sub-feature dengan dot notation
dart run yo.dart page:<feature>.<sub_page>

# Preview dulu tanpa menulis
dart run yo.dart page:<nama> --dry-run
```

4. Review generated page — sudah menggunakan YoUI:
   - `YoScaffold` sebagai wrapper
   - `YoText.heading()` untuk judul
   - `YoLoading()` untuk loading state
   - `YoErrorState()` untuk error state

5. Cari dan implementasi `// TODO` markers:
```bash
grep -rn "// TODO" lib/features/<nama>/
```

6. Jalankan analyze:
```bash
flutter analyze
```

## Naming Convention

| Input | Class | File | Feature Folder |
|-------|-------|------|----------------|
| `home` | `Home` | `home.dart` | `features/home/` |
| `setting.profile` | `SettingProfile` | `setting_profile.dart` | `features/setting/` |
| `user.auth.login` | `UserAuthLogin` | `user_auth_login.dart` | `features/user/` |
