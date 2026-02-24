---
description: Tambahkan key translasi (i18n) ke semua bahasa menggunakan yo.dart
---

# Translate

// turbo-all

## A. Tambah Key Baru

### Steps

1. Cek bahasa yang terdaftar:
```bash
cat yo.yaml | grep -A5 localization
```

2. Tambah key:
```bash
dart run yo.dart translation --key=welcome --en="Welcome" --id="Selamat Datang"
```

3. Generate localization:
```bash
flutter gen-l10n
```

4. Gunakan di kode:
```dart
AppLocalizations.of(context)!.welcome
// atau jika ada extension:
context.l10n.welcome
```

---

## B. Translate Fitur yang Sudah Ada (Retrofit)

Ketika fitur sudah dibuat tapi lupa translate (masih hardcoded string):

### Steps

1. Scan hardcoded strings di fitur target:
```bash
grep -rn "'[A-Z]" lib/features/<feature>/presentation/ --include="*.dart" | grep -v "import\|//\|Key\|Icons\|Color\|Route"
```

2. Identifikasi semua string yang perlu diterjemahkan dari output di atas. Buat daftar key dan terjemahannya.

3. Tambah semua key sekaligus:
```bash
dart run yo.dart translation --key=<feature>_title --en="Title" --id="Judul"
dart run yo.dart translation --key=<feature>_subtitle --en="Subtitle" --id="Subjudul"
dart run yo.dart translation --key=<feature>_button_submit --en="Submit" --id="Kirim"
# ... tambah semua key yang dibutuhkan
```

4. Generate localization:
```bash
flutter gen-l10n
```

5. Replace hardcoded strings di kode dengan key yang baru:
```dart
// ❌ Sebelum (hardcoded)
YoText.heading('Login')
YoButton.primary(text: 'Submit', onPressed: () {})

// ✅ Sesudah (translated)
YoText.heading(context.l10n.auth_login_title)
YoButton.primary(text: context.l10n.auth_button_submit, onPressed: () {})
```

6. Verifikasi tidak ada hardcoded string tersisa:
```bash
grep -rn "'[A-Z]" lib/features/<feature>/presentation/ --include="*.dart" | grep -v "import\|//\|Key\|Icons\|Color\|Route\|l10n"
```

7. Test:
```bash
flutter analyze
flutter test test/features/<feature>/
```

---

## C. Scan Semua Fitur yang Belum Translate

Scan semua fitur sekaligus untuk menemukan hardcoded strings:

```bash
# Scan semua presentation layer
grep -rn "'[A-Z][a-z]" lib/features/*/presentation/ --include="*.dart" | grep -v "import\|//\|Key\|Icons\|Color\|Route\|l10n\|Widget\|State\|Build"
```

Output ini menunjukkan file dan baris yang masih hardcoded. Proses satu per satu menggunakan langkah B di atas.

---

## Naming Convention untuk Key

| Pattern | Contoh Key | English | Indonesia |
|---------|-----------|---------|-----------|
| `<feature>_title` | `auth_title` | `Authentication` | `Autentikasi` |
| `<feature>_<page>_title` | `auth_login_title` | `Login` | `Masuk` |
| `<feature>_button_<action>` | `cart_button_checkout` | `Checkout` | `Bayar` |
| `<feature>_label_<field>` | `auth_label_email` | `Email Address` | `Alamat Email` |
| `<feature>_hint_<field>` | `auth_hint_password` | `Enter password` | `Masukkan kata sandi` |
| `<feature>_error_<type>` | `auth_error_invalid` | `Invalid credentials` | `Kredensial salah` |
| `<feature>_message_<type>` | `cart_message_empty` | `Cart is empty` | `Keranjang kosong` |
| `common_<action>` | `common_save` | `Save` | `Simpan` |
| `common_<action>` | `common_cancel` | `Cancel` | `Batal` |

## Tips
- Prefix key dengan nama fitur: `auth_`, `home_`, `cart_`
- Gunakan `common_` untuk string yang dipakai di banyak fitur
- Selalu jalankan `flutter gen-l10n` setelah menambah key
- Cek ARB file sudah valid JSON sebelum generate
