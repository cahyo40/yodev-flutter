import 'package:intl/intl.dart';

class YoCurrencyFormatter {
  // Currency Formatting dengan locale support
  static String formatCurrency(
    double amount, {
    String? symbol,
    int decimalDigits = 0,
    String locale = 'id_ID',
  }) {
    final format = NumberFormat.currency(
      locale: locale,
      symbol: symbol ?? _getDefaultSymbol(locale),
      decimalDigits: decimalDigits,
    );
    return format.format(amount);
  }

  static String _getDefaultSymbol(String locale) {
    switch (locale) {
      case 'id_ID':
        return 'Rp';
      case 'en_US':
        return '\$';
      case 'en_GB':
        return '£';
      case 'ja_JP':
        return '¥';
      default:
        return '';
    }
  }

  // Number Formatting
  static String formatNumber(
    double number, {
    int decimalDigits = 0,
    String locale = 'id_ID',
  }) {
    final format = NumberFormat(
      '#,##0${decimalDigits > 0 ? '.${'0' * decimalDigits}' : ''}',
      locale,
    );
    return format.format(number);
  }

  // Compact Number Formatting (1K, 1M, 1B)
  static String formatCompactNumber(double number, {String locale = 'id_ID'}) {
    final format = NumberFormat.compact(locale: locale);
    return format.format(number);
  }

  // Percentage Formatting
  static String formatPercentage(
    double value, {
    int decimalDigits = 1,
    String locale = 'id_ID',
  }) {
    final percentage = value * 100;
    final format = NumberFormat(
      '0${decimalDigits > 0 ? '.${'0' * decimalDigits}' : ''}',
      locale,
    );
    return '${format.format(percentage)}%';
  }

  // === FORMAT RUPIAH DENGAN SATUAN (Rp 1.56 Juta) ===

  /// Format Rupiah dengan satuan yang mudah dibaca
  /// Contoh: 1560000 -> "Rp 1.56 Juta"
  static String formatRupiahWithUnit(
    num amount, {
    int decimalDigits = 2,
    bool showSymbol = true,
    bool useShortUnit = false,
  }) {
    final double value = amount.toDouble();
    final bool isNegative = value < 0;
    final double absoluteValue = value.abs();

    // Tentukan satuan berdasarkan besaran angka
    final unitInfo = _getRupiahUnitInfo(absoluteValue, useShortUnit);

    // Hitung nilai yang sudah dibagi
    final double dividedValue = absoluteValue / unitInfo.divisor;

    // Format angka
    final String numberPart = _formatRupiahDecimal(dividedValue, decimalDigits);

    // Gabungkan semua bagian
    final String symbol = showSymbol ? 'Rp ' : '';
    final String negativeSign = isNegative ? '-' : '';

    return '$negativeSign$symbol$numberPart ${unitInfo.unit}'.trim();
  }

  /// Info satuan untuk Rupiah
  static RupiahUnitInfo _getRupiahUnitInfo(double amount, bool useShortUnit) {
    if (amount >= 1e15) return RupiahUnitInfo('Kuadriliun', 1e15, 'Q');
    if (amount >= 1e12) return RupiahUnitInfo('Triliun', 1e12, 'T');
    if (amount >= 1e9) return RupiahUnitInfo('Miliar', 1e9, 'B');
    if (amount >= 1e6) return RupiahUnitInfo('Juta', 1e6, 'Jt');
    if (amount >= 1e3) return RupiahUnitInfo('Ribu', 1e3, 'Rb');

    return RupiahUnitInfo('', 1, '');
  }

  /// Format decimal untuk Rupiah
  static String _formatRupiahDecimal(double value, int decimalDigits) {
    if (decimalDigits == 0) {
      return value.round().toString();
    }

    final format = NumberFormat(
      '0${decimalDigits > 0 ? '.${'#' * decimalDigits}' : ''}',
    );
    return format.format(value);
  }

  // === FORMAT RUPIAH DENGAN SIMBOL SINGKAT ===

  /// Format Rupiah dengan simbol singkat (Rp 1.5Jt, Rp 2.3B)
  static String formatRupiahCompact(
    num amount, {
    int decimalDigits = 1,
    bool showSymbol = true,
  }) {
    final double value = amount.toDouble();
    final bool isNegative = value < 0;
    final double absoluteValue = value.abs();

    final unitInfo = _getRupiahUnitInfo(absoluteValue, true);

    final double dividedValue = absoluteValue / unitInfo.divisor;
    final String numberPart = _formatRupiahDecimal(dividedValue, decimalDigits);

    final String symbol = showSymbol ? 'Rp ' : '';
    final String negativeSign = isNegative ? '-' : '';
    final String unitSymbol = unitInfo.shortUnit.isNotEmpty
        ? unitInfo.shortUnit
        : '';

    return '$negativeSign$symbol$numberPart$unitSymbol';
  }

  // === FORMAT ANGKA SANGAT BESAR (Custom Implementation) ===

  /// Format angka yang sangat besar menjadi format yang mudah dibaca
  /// Contoh: 1000000000000000000000 -> "1 Sextilion"
  static String formatVeryLargeNumber(
    num number, {
    String locale = 'id_ID',
    int decimalDigits = 2,
    bool useShortScale =
        true, // true untuk short scale (US), false untuk long scale (EU)
  }) {
    // Handle angka kecil yang bisa diformat dengan NumberFormat biasa
    if (number.abs() < 1e12) {
      // Kurang dari 1 triliun
      return formatNumber(
        number.toDouble(),
        decimalDigits: decimalDigits,
        locale: locale,
      );
    }

    // Untuk angka yang sangat besar, gunakan custom formatter
    return _formatExtremelyLargeNumber(
      number.toDouble(),
      locale: locale,
      decimalDigits: decimalDigits,
      useShortScale: useShortScale,
    );
  }

  /// Format angka ekstrim besar dengan satuan custom
  static String _formatExtremelyLargeNumber(
    double number, {
    required String locale,
    required int decimalDigits,
    required bool useShortScale,
  }) {
    final bool isNegative = number < 0;
    final double absoluteNumber = number.abs();

    // Daftar satuan untuk short scale (US) dan long scale (EU)
    final scales = useShortScale ? _shortScaleUnits : _longScaleUnits;

    // Cari satuan yang sesuai
    String unit = '';
    double divisor = 1.0;

    for (int i = scales.length - 1; i >= 0; i--) {
      final scaleValue = scales[i].value;
      if (absoluteNumber >= scaleValue) {
        unit = _getLocalizedUnit(scales[i].unit, locale);
        divisor = scaleValue;
        break;
      }
    }

    // Jika tidak ada satuan yang cocok, gunakan satuan terbesar
    if (unit.isEmpty && scales.isNotEmpty) {
      final largestScale = scales.last;
      unit = _getLocalizedUnit(largestScale.unit, locale);
      divisor = largestScale.value;
    }

    // Format angka
    final double formattedValue = absoluteNumber / divisor;
    final String numberPart = _formatDecimal(
      formattedValue,
      decimalDigits,
      locale,
    );

    return '${isNegative ? '-' : ''}$numberPart $unit'.trim();
  }

  /// Format decimal number dengan locale support
  static String _formatDecimal(double value, int decimalDigits, String locale) {
    final format = NumberFormat(
      '0${decimalDigits > 0 ? '.${'#' * decimalDigits}' : ''}',
      locale,
    );
    return format.format(value);
  }

  /// Daftar satuan untuk Short Scale (US System)
  static final List<NumberScale> _shortScaleUnits = [
    NumberScale('Ribu', 1e3),
    NumberScale('Juta', 1e6),
    NumberScale('Miliar', 1e9),
    NumberScale('Triliun', 1e12),
    NumberScale('Quadriliun', 1e15),
    NumberScale('Quintiliun', 1e18),
    NumberScale('Sextiliun', 1e21),
    NumberScale('Septiliun', 1e24),
    NumberScale('Oktiliun', 1e27),
    NumberScale('Noniliun', 1e30),
    NumberScale('Desiliun', 1e33),
  ];

  /// Daftar satuan untuk Long Scale (European System)
  static final List<NumberScale> _longScaleUnits = [
    NumberScale('Ribu', 1e3),
    NumberScale('Juta', 1e6),
    NumberScale('Miliar', 1e9),
    NumberScale('Biliun', 1e12),
    NumberScale('Biliar', 1e15),
    NumberScale('Triliun', 1e18),
    NumberScale('Triliar', 1e21),
    NumberScale('Quadriliun', 1e24),
    NumberScale('Quadriliar', 1e27),
    NumberScale('Quintiliun', 1e30),
    NumberScale('Quintiliar', 1e33),
  ];

  /// Get localized unit name berdasarkan locale
  static String _getLocalizedUnit(String unit, String locale) {
    if (locale == 'id_ID') {
      return _indonesianUnits[unit] ?? unit;
    }
    // Untuk locale lain, bisa ditambahkan mapping di sini
    return unit;
  }

  /// Mapping satuan untuk Bahasa Indonesia
  static final Map<String, String> _indonesianUnits = {
    'Ribu': 'Ribu',
    'Juta': 'Juta',
    'Miliar': 'Miliar',
    'Triliun': 'Triliun',
    'Quadriliun': 'Quadriliun',
    'Quintiliun': 'Quintiliun',
    'Sextiliun': 'Sextiliun',
    'Septiliun': 'Septiliun',
    'Oktiliun': 'Oktiliun',
    'Noniliun': 'Noniliun',
    'Desiliun': 'Desiliun',
    'Biliun': 'Biliun',
    'Biliar': 'Biliar',
    'Triliar': 'Triliar',
    'Quadriliar': 'Quadriliar',
    'Quintiliar': 'Quintiliar',
  };

  // === FORMAT ANGKA BESAR DENGAN SIMBOL ===

  /// Format angka besar dengan simbol (K, M, B, T, dll)
  /// Contoh: 1500000 -> "1.5M"
  static String formatLargeNumberWithSymbol(
    num number, {
    String locale = 'id_ID',
    int decimalDigits = 1,
  }) {
    final double value = number.toDouble();
    final bool isNegative = value < 0;
    final double absoluteValue = value.abs();

    // Tentukan simbol dan divisor berdasarkan besaran angka
    final scaleInfo = _getScaleInfo(absoluteValue);

    final double formattedValue = absoluteValue / scaleInfo.divisor;
    final String numberPart = _formatDecimal(
      formattedValue,
      decimalDigits,
      locale,
    );

    return '${isNegative ? '-' : ''}$numberPart${scaleInfo.symbol}';
  }

  /// Info tentang skala yang digunakan
  static ScaleInfo _getScaleInfo(double number) {
    if (number >= 1e21) return ScaleInfo('S', 1e21);
    if (number >= 1e18) return ScaleInfo('Q', 1e18);
    if (number >= 1e15) return ScaleInfo('P', 1e15);
    if (number >= 1e12) return ScaleInfo('T', 1e12);
    if (number >= 1e9) return ScaleInfo('B', 1e9);
    if (number >= 1e6) return ScaleInfo('M', 1e6);
    if (number >= 1e3) return ScaleInfo('K', 1e3);
    return ScaleInfo('', 1);
  }

  // === UTILITY FUNCTIONS ===

  /// Parse string angka dengan locale support
  static double? parseNumber(String text, {String locale = 'id_ID'}) {
    try {
      final format = NumberFormat(locale);
      return format.parse(text).toDouble();
    } catch (e) {
      return null;
    }
  }

  /// Cek apakah string adalah angka yang valid
  static bool isValidNumber(String text, {String locale = 'id_ID'}) {
    return parseNumber(text, locale: locale) != null;
  }

  /// Format range angka (contoh: "1K - 5M")
  static String formatNumberRange(
    num start,
    num end, {
    String locale = 'id_ID',
    int decimalDigits = 1,
    String separator = ' - ',
  }) {
    final startFormatted = formatLargeNumberWithSymbol(
      start,
      locale: locale,
      decimalDigits: decimalDigits,
    );
    final endFormatted = formatLargeNumberWithSymbol(
      end,
      locale: locale,
      decimalDigits: decimalDigits,
    );

    return '$startFormatted$separator$endFormatted';
  }

  /// Format range Rupiah (contoh: "Rp 1 Jt - Rp 5 Jt")
  static String formatRupiahRange(
    num start,
    num end, {
    int decimalDigits = 1,
    String separator = ' - ',
  }) {
    final startFormatted = formatRupiahCompact(
      start,
      decimalDigits: decimalDigits,
    );
    final endFormatted = formatRupiahCompact(end, decimalDigits: decimalDigits);

    return '$startFormatted$separator$endFormatted';
  }
}

/// Model untuk menyimpan informasi skala
class NumberScale {
  final String unit;
  final double value;

  NumberScale(this.unit, this.value);
}

/// Model untuk menyimpan info simbol skala
class ScaleInfo {
  final String symbol;
  final double divisor;

  ScaleInfo(this.symbol, this.divisor);
}

/// Model untuk satuan Rupiah
class RupiahUnitInfo {
  final String unit;
  final double divisor;
  final String shortUnit;

  RupiahUnitInfo(this.unit, this.divisor, this.shortUnit);
}
