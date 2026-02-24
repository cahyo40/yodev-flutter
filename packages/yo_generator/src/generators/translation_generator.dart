import 'dart:convert';

import 'package:path/path.dart' as path;

import '../config.dart';
import '../utils.dart';

/// Generator for updating translations
class TranslationGenerator {
  TranslationGenerator(this.config);
  final YoConfig config;

  /// Add or update a translation
  void generate({
    required String key,
    String? en,
    String? id,
  }) {
    Console.header('Updating Translations');

    final l10nPath = config.l10nPath;
    YoUtils.ensureDirectory(l10nPath);

    // Update English translations
    if (en != null) {
      _updateArbFile(path.join(l10nPath, 'app_en.arb'), key, en, 'en');
    }

    // Update Indonesian translations
    if (id != null) {
      _updateArbFile(path.join(l10nPath, 'app_id.arb'), key, id, 'id');
    }

    Console.success('Translation "$key" updated successfully!');
    Console.info('Run: flutter gen-l10n');
  }

  /// Initialize translation files with default content
  void initTranslations() {
    final l10nPath = config.l10nPath;
    YoUtils.ensureDirectory(l10nPath);

    // English
    final enArb = {
      '@@locale': 'en',
      'appTitle': config.appName,
      'ok': 'OK',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'add': 'Add',
      'search': 'Search',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'warning': 'Warning',
      'confirm': 'Confirm',
      'retry': 'Retry',
      'close': 'Close',
      'back': 'Back',
      'next': 'Next',
      'submit': 'Submit',
      'home': 'Home',
      'settings': 'Settings',
      'profile': 'Profile',
      'logout': 'Logout',
      'login': 'Login',
      'register': 'Register',
      'email': 'Email',
      'password': 'Password',
      'username': 'Username',
      'noData': 'No data available',
      'networkError': 'Network error occurred',
      'unknownError': 'An unknown error occurred',
    };

    // Indonesian
    final idArb = {
      '@@locale': 'id',
      'appTitle': config.appName,
      'ok': 'OK',
      'cancel': 'Batal',
      'save': 'Simpan',
      'delete': 'Hapus',
      'edit': 'Ubah',
      'add': 'Tambah',
      'search': 'Cari',
      'loading': 'Memuat...',
      'error': 'Kesalahan',
      'success': 'Berhasil',
      'warning': 'Peringatan',
      'confirm': 'Konfirmasi',
      'retry': 'Coba Lagi',
      'close': 'Tutup',
      'back': 'Kembali',
      'next': 'Lanjut',
      'submit': 'Kirim',
      'home': 'Beranda',
      'settings': 'Pengaturan',
      'profile': 'Profil',
      'logout': 'Keluar',
      'login': 'Masuk',
      'register': 'Daftar',
      'email': 'Email',
      'password': 'Kata Sandi',
      'username': 'Nama Pengguna',
      'noData': 'Tidak ada data',
      'networkError': 'Terjadi kesalahan jaringan',
      'unknownError': 'Terjadi kesalahan yang tidak diketahui',
    };

    final encoder = JsonEncoder.withIndent('  ');
    YoUtils.writeFile(
      path.join(l10nPath, 'app_en.arb'),
      encoder.convert(enArb),
    );
    YoUtils.writeFile(
      path.join(l10nPath, 'app_id.arb'),
      encoder.convert(idArb),
    );

    Console.success('Translations initialized!');
  }

  void _updateArbFile(
    String filePath,
    String key,
    String value,
    String locale,
  ) {
    Map<String, dynamic> arb;

    if (YoUtils.fileExists(filePath)) {
      final content = YoUtils.readFile(filePath);
      arb = json.decode(content) as Map<String, dynamic>;
    } else {
      arb = {'@@locale': locale};
    }

    arb[key] = value;

    // Sort keys (keeping @@locale at top)
    final sortedArb = <String, dynamic>{};
    if (arb.containsKey('@@locale')) {
      sortedArb['@@locale'] = arb['@@locale'];
    }
    final otherKeys = arb.keys.where((k) => k != '@@locale').toList()..sort();
    for (final k in otherKeys) {
      sortedArb[k] = arb[k];
    }

    final encoder = JsonEncoder.withIndent('  ');
    YoUtils.writeFile(filePath, encoder.convert(sortedArb));
  }
}
