---
description: Tambahkan key translasi (i18n) ke semua bahasa menggunakan yo.dart
---

# Add Translation

// turbo-all

## Steps

1. Cek bahasa yang terdaftar:
```bash
cat yo.yaml | grep -A5 localization
```

2. Cek file ARB yang ada:
```bash
ls lib/l10n/
```

3. Tambah key baru:
```bash
dart run yo.dart translation --key=<key_name> --en="English text" --id="Teks Indonesia"
```

4. Generate localization:
```bash
flutter gen-l10n
```

5. Gunakan di kode:
```dart
// import
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// usage
AppLocalizations.of(context)!.keyName
// atau jika extension tersedia
context.l10n.keyName
```

6. Verifikasi:
```bash
flutter analyze
```

## Contoh
```bash
# Satu key
dart run yo.dart translation --key=welcome --en="Welcome" --id="Selamat Datang"

# Beberapa key sekaligus
dart run yo.dart translation --key=login_title --en="Login" --id="Masuk"
dart run yo.dart translation --key=login_email --en="Email Address" --id="Alamat Email"
dart run yo.dart translation --key=login_password --en="Password" --id="Kata Sandi"
dart run yo.dart translation --key=login_button --en="Sign In" --id="Masuk"
```

## Tips
- Gunakan snake_case untuk key name
- Prefix key dengan nama fitur: `auth_`, `home_`, `cart_`
- Selalu jalankan `flutter gen-l10n` setelah menambah key
