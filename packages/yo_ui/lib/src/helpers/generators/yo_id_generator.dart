import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

class YoIdGenerator {
  static final Random _random = Random();
  static const String _chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  static const String _numbers = '0123456789';

  // === BASIC ID GENERATORS ===

  /// Generate random numeric ID dengan panjang tertentu
  static String numericId({int length = 8}) {
    final buffer = StringBuffer();
    for (int i = 0; i < length; i++) {
      buffer.write(_numbers[_random.nextInt(_numbers.length)]);
    }
    return buffer.toString();
  }

  /// Generate random alphanumeric ID dengan panjang tertentu
  static String alphanumericId({int length = 12}) {
    final buffer = StringBuffer();
    for (int i = 0; i < length; i++) {
      buffer.write(_chars[_random.nextInt(_chars.length)]);
    }
    return buffer.toString();
  }

  /// Generate UUID version 4
  static String uuid() {
    final bytes = Uint8List(16);
    for (int i = 0; i < 16; i++) {
      bytes[i] = _random.nextInt(256);
    }

    // Set version to 4
    bytes[6] = (bytes[6] & 0x0F) | 0x40;
    // Set variant to 1
    bytes[8] = (bytes[8] & 0x3F) | 0x80;

    final hex = bytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }

  // === PREFIXED ID GENERATORS ===

  /// Generate ID dengan prefix (contoh: USR_123456)
  static String prefixedId(
    String prefix, {
    int length = 8,
    bool numeric = true,
  }) {
    final id = numeric
        ? numericId(length: length)
        : alphanumericId(length: length);
    return '${prefix}_$id';
  }

  /// Generate user ID (contoh: USR_8A2B4C6D)
  static String userId({int length = 8}) {
    return prefixedId('USR', length: length, numeric: false);
  }

  /// Generate order ID (contoh: ORD_20240115001)
  static String orderId() {
    final now = DateTime.now();
    final datePart = DateFormat('yyyyMMdd').format(now);
    final randomPart = numericId(length: 3);
    return 'ORD_$datePart$randomPart';
  }

  /// Generate transaction ID (contoh: TRX_8A2B4C6D)
  static String transactionId({int length = 8}) {
    return prefixedId('TRX', length: length, numeric: false);
  }

  /// Generate product ID (contoh: PROD_8A2B4C6D)
  static String productId({int length = 8}) {
    return prefixedId('PROD', length: length, numeric: false);
  }

  /// Generate category ID (contoh: CAT_8A2B4C6D)
  static String categoryId({int length = 6}) {
    return prefixedId('CAT', length: length, numeric: false);
  }

  // === TIMESTAMP-BASED ID GENERATORS ===

  /// Generate ID berdasarkan timestamp (contoh: 17052024093015)
  static String timestampId() {
    final now = DateTime.now();
    return DateFormat('ddMMyyyyHHmmss').format(now);
  }

  /// Generate short timestamp ID (contoh: 240115093015)
  static String shortTimestampId() {
    final now = DateTime.now();
    return DateFormat('yyMMddHHmmss').format(now);
  }

  /// Generate timestamp ID dengan random suffix
  static String timestampWithRandomId({int randomLength = 4}) {
    final timestamp = shortTimestampId();
    final random = numericId(length: randomLength);
    return '$timestamp$random';
  }

  // === HASH-BASED ID GENERATORS ===

  /// Generate MD5 hash dari string
  static String md5Id(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  /// Generate SHA-1 hash dari string
  static String sha1Id(String input) {
    return sha1.convert(utf8.encode(input)).toString();
  }

  /// Generate SHA-256 hash dari string
  static String sha256Id(String input) {
    return sha256.convert(utf8.encode(input)).toString();
  }

  /// Generate short hash ID (8 karakter pertama dari MD5)
  static String shortHashId(String input, {int length = 8}) {
    final hash = md5.convert(utf8.encode(input)).toString();
    return hash.substring(0, length);
  }

  // === SEQUENTIAL ID GENERATORS ===

  /// Generate sequential ID dengan prefix dan counter
  static String sequentialId(String prefix, int counter, {int padding = 6}) {
    return '$prefix${counter.toString().padLeft(padding, '0')}';
  }

  /// Generate auto-increment ID berdasarkan timestamp dan counter
  static String autoIncrementId(String prefix, int counter) {
    final date = DateFormat('yyyyMMdd').format(DateTime.now());
    return '$prefix$date${counter.toString().padLeft(4, '0')}';
  }

  // === CUSTOM FORMAT ID GENERATORS ===

  /// Generate ID dengan custom format (contoh: XXX-XXX-XXX)
  static String customFormatId(String format, {String charset = _chars}) {
    final buffer = StringBuffer();
    for (int i = 0; i < format.length; i++) {
      if (format[i] == 'X') {
        buffer.write(charset[_random.nextInt(charset.length)]);
      } else {
        buffer.write(format[i]);
      }
    }
    return buffer.toString();
  }

  /// Generate license key style ID (contoh: A1B2-C3D4-E5F6-G7H8)
  static String licenseKeyId({int blocks = 4, int blockLength = 4}) {
    final blocksList = <String>[];
    for (int i = 0; i < blocks; i++) {
      blocksList.add(alphanumericId(length: blockLength));
    }
    return blocksList.join('-');
  }

  /// Generate coupon code (contoh: DISCOUNT20)
  static String couponCode({String prefix = '', int length = 8}) {
    final code = alphanumericId(length: length).toUpperCase();
    return prefix.isEmpty ? code : '$prefix$code';
  }

  // === BATCH GENERATORS ===

  /// Generate multiple IDs
  static List<String> batchGenerate({
    required int count,
    String? prefix,
    int length = 8,
    bool numeric = false,
  }) {
    final ids = <String>[];
    for (int i = 0; i < count; i++) {
      if (prefix != null) {
        ids.add(prefixedId(prefix, length: length, numeric: numeric));
      } else {
        ids.add(
          numeric ? numericId(length: length) : alphanumericId(length: length),
        );
      }
    }
    return ids;
  }

  /// Generate unique batch IDs (memastikan tidak ada duplikat)
  static List<String> batchGenerateUnique({
    required int count,
    String? prefix,
    int length = 8,
    bool numeric = false,
  }) {
    final ids = <String>{};
    while (ids.length < count) {
      final id = prefix != null
          ? prefixedId(prefix, length: length, numeric: numeric)
          : (numeric
                ? numericId(length: length)
                : alphanumericId(length: length));
      ids.add(id);
    }
    return ids.toList();
  }

  // === VALIDATION HELPERS ===

  /// Validasi apakah string adalah numeric ID
  static bool isValidNumericId(String id, {int? length}) {
    if (length != null && id.length != length) return false;
    return RegExp(r'^\d+$').hasMatch(id);
  }

  /// Validasi apakah string adalah alphanumeric ID
  static bool isValidAlphanumericId(String id, {int? length}) {
    if (length != null && id.length != length) return false;
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(id);
  }

  /// Validasi UUID format
  static bool isValidUuid(String uuid) {
    final pattern =
        r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$';
    return RegExp(pattern, caseSensitive: false).hasMatch(uuid);
  }

  /// Validasi prefixed ID format
  static bool isValidPrefixedId(String id, String prefix, {int? idLength}) {
    if (!id.startsWith('${prefix}_')) return false;
    final idPart = id.substring(prefix.length + 1);
    if (idLength != null && idPart.length != idLength) return false;
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(idPart);
  }

  // === UTILITY METHODS ===

  /// Extract prefix dari ID
  static String? extractPrefix(String id) {
    final parts = id.split('_');
    return parts.length > 1 ? parts[0] : null;
  }

  /// Extract numeric part dari ID
  static String? extractNumericPart(String id) {
    final matches = RegExp(r'\d+').allMatches(id);
    return matches.isNotEmpty ? matches.first.group(0) : null;
  }

  /// Generate ID dengan checksum
  static String idWithChecksum(String baseId) {
    final hash = md5.convert(utf8.encode(baseId)).toString();
    return '$baseId${hash.substring(0, 2)}';
  }

  /// Verify checksum pada ID
  static bool verifyChecksum(String idWithChecksum) {
    if (idWithChecksum.length < 3) return false;
    final baseId = idWithChecksum.substring(0, idWithChecksum.length - 2);
    final checksum = idWithChecksum.substring(idWithChecksum.length - 2);
    final calculatedChecksum = md5
        .convert(utf8.encode(baseId))
        .toString()
        .substring(0, 2);
    return checksum == calculatedChecksum;
  }
}
