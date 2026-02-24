
/// YoStringFormatter - Kumpulan utility formatter untuk String di Flutter
/// Minimal dependency, maksimal utility!
class YoStringFormatter {
  
  /// === FORMATTER TEKS & KAPITALISASI ===
  
  /// Kapitalisasi setiap kata (Title Case)
  /// Contoh: "hello world" -> "Hello World"
  static String titleCase(String text) {
    if (text.isEmpty) return text;
    return text.toLowerCase().split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  /// Kapitalisasi hanya huruf pertama
  /// Contoh: "hello world" -> "Hello world"
  static String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Format camelCase ke Title Case
  /// Contoh: "helloWorld" -> "Hello World"
  static String camelCaseToTitle(String text) {
    if (text.isEmpty) return text;
    return text.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (Match m) => '${m[1]} ${m[2]}',
    ).split(' ').map((word) => capitalizeFirst(word)).join(' ');
  }

  /// Format snake_case ke Title Case
  /// Contoh: "hello_world" -> "Hello World"
  static String snakeCaseToTitle(String text) {
    if (text.isEmpty) return text;
    return text.split('_').map((word) => capitalizeFirst(word)).join(' ');
  }

  /// === FORMATTER NOMOR & TELEPON ===
  
  /// Format nomor telepon Indonesia
  /// Contoh: "08123456789" -> "0812-3456-789"
  static String formatPhoneNumber(String phone) {
    String digits = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digits.length == 11) {
      return '${digits.substring(0, 4)}-${digits.substring(4, 7)}-${digits.substring(7)}';
    } else if (digits.length == 12) {
      return '${digits.substring(0, 4)}-${digits.substring(4, 8)}-${digits.substring(8)}';
    } else if (digits.length >= 9) {
      return '${digits.substring(0, 4)}-${digits.substring(4, 8)}-${digits.substring(8)}';
    }
    
    return phone;
  }

  /// Format angka dengan separator ribuan
  /// Contoh: 1000000 -> "1.000.000"
  static String formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  /// Format persentase dengan simbol %
  /// Contoh: 0.85 -> "85%"
  static String formatPercentage(double decimal, {int decimalPlaces = 0}) {
    int percentage = (decimal * 100).round();
    return '$percentage%';
  }

  /// === FORMATTER ALAMAT & LOKASI ===
  
  /// Format alamat yang dipersingkat
  /// Contoh: "Jalan Merdeka Timur No. 123" -> "Jl. Merdeka Timur No. 123"
  static String formatAddress(String address) {
    return address
        .replaceAll(RegExp(r'Jalan\s', caseSensitive: false), 'Jl. ')
        .replaceAll(RegExp(r'Gang\s', caseSensitive: false), 'Gg. ')
        .replaceAll(RegExp(r'Nomor\s', caseSensitive: false), 'No. ')
        .replaceAll(RegExp(r'Number\s', caseSensitive: false), 'No. ')
        .replaceAll(RegExp(r'RT\s', caseSensitive: false), 'RT ')
        .replaceAll(RegExp(r'RW\s', caseSensitive: false), 'RW ');
  }

  /// Format kode pos (5 digit)
  /// Contoh: "12345" -> "12.345"
  static String formatPostalCode(String postalCode) {
    String digits = postalCode.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length == 5) {
      return '${digits.substring(0, 2)}.${digits.substring(2)}';
    }
    return postalCode;
  }

  /// === FORMATTER EMAIL & URL ===
  
  /// Menyembunyikan sebagian email untuk privacy
  /// Contoh: "user@example.com" -> "us****@example.com"
  static String obscureEmail(String email) {
    if (!email.contains('@')) return email;
    
    List<String> parts = email.split('@');
    String username = parts[0];
    String domain = parts[1];
    
    if (username.length <= 2) {
      return '${'*' * username.length}@$domain';
    } else {
      String visiblePart = username.substring(0, 2);
      return '$visiblePart${'*' * (username.length - 2)}@$domain';
    }
  }

  /// Format URL menjadi display name yang lebih pendek
  /// Contoh: "https://www.example.com/path" -> "example.com"
  static String formatUrlDisplay(String url) {
    try {
      Uri uri = Uri.parse(url);
      String host = uri.host;
      
      // Remove www. prefix
      if (host.startsWith('www.')) {
        host = host.substring(4);
      }
      
      return host;
    } catch (e) {
      return url;
    }
  }

  /// === FORMATTER NAMA & INISIAL ===
  
  /// Mengambil inisial dari nama
  /// Contoh: "John Doe" -> "JD"
  static String getInitials(String name, {int maxInitials = 2}) {
    if (name.isEmpty) return '';
    
    List<String> words = name.trim().split(RegExp(r'\s+'));
    String initials = '';
    
    for (int i = 0; i < words.length && i < maxInitials; i++) {
      if (words[i].isNotEmpty) {
        initials += words[i][0].toUpperCase();
      }
    }
    
    return initials;
  }

  /// Format nama untuk ditampilkan (nama depan + inisial belakang)
  /// Contoh: "John Michael Doe" -> "John M. D."
  static String formatNameShort(String fullName) {
    if (fullName.isEmpty) return '';
    
    List<String> names = fullName.trim().split(RegExp(r'\s+'));
    if (names.length == 1) return names[0];
    
    String formatted = names[0]; // Nama depan lengkap
    
    for (int i = 1; i < names.length; i++) {
      if (names[i].isNotEmpty) {
        formatted += ' ${names[i][0]}.';
      }
    }
    
    return formatted;
  }

  /// === FORMATTER WAKTU & DURASI ===
  
  /// Format durasi dalam detik ke format menit:detik
  /// Contoh: 125 -> "02:05"
  static String formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');
    
    return '$minutesStr:$secondsStr';
  }

  /// Format durasi panjang ke format yang mudah dibaca
  /// Contoh: 3665 -> "1 jam 1 menit"
  static String formatDurationLong(int seconds) {
    if (seconds < 60) {
      return '$seconds detik';
    }
    
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    
    if (hours > 0) {
      if (minutes > 0) {
        return '$hours jam $minutes menit';
      }
      return '$hours jam';
    } else {
      return '$minutes menit';
    }
  }

  /// === FORMATTER FILE & SIZE ===
  
  /// Format ukuran file dalam bytes ke format yang mudah dibaca
  /// Contoh: 1048576 -> "1 MB"
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1048576) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1073741824) {
      return '${(bytes / 1048576).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / 1073741824).toStringAsFixed(1)} GB';
    }
  }

  /// Extract nama file dari path
  /// Contoh: "/path/to/file.jpg" -> "file.jpg"
  static String getFileName(String path) {
    return path.split(RegExp(r'[\\/]')).last;
  }

  /// Extract extension dari nama file
  /// Contoh: "image.jpg" -> "jpg"
  static String getFileExtension(String fileName) {
    List<String> parts = fileName.split('.');
    return parts.length > 1 ? parts.last.toLowerCase() : '';
  }

  /// === FORMATTER SOCIAL & USERNAME ===
  
  /// Format username dengan @ prefix
  /// Contoh: "username" -> "@username"
  static String formatUsername(String username) {
    if (username.isEmpty) return username;
    return username.startsWith('@') ? username : '@$username';
  }

  /// Menyembunyikan sebagian nomor untuk privacy
  /// Contoh: "08123456789" -> "0812****789"
  static String obscurePhoneNumber(String phone) {
    if (phone.length < 8) return phone;
    
    String start = phone.substring(0, 4);
    String end = phone.substring(phone.length - 3);
    
    return '$start****$end';
  }

  /// === FORMATTER TEXT LIMIT & TRUNCATE ===
  
  /// Memotong teks dan menambahkan ellipsis jika terlalu panjang
  /// Contoh: "Very long text here" -> "Very long..."
  static String truncateWithEllipsis(String text, {int maxLength = 30}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Memotong teks di tengah (untuk long addresses/IDs)
  /// Contoh: "0x1234567890abcdef" -> "0x1234...cdef"
  static String truncateMiddle(String text, {int visibleStart = 6, int visibleEnd = 4}) {
    if (text.length <= visibleStart + visibleEnd) return text;
    
    String start = text.substring(0, visibleStart);
    String end = text.substring(text.length - visibleEnd);
    
    return '$start...$end';
  }

  /// === FORMATTER VALIDATION & CLEANING ===
  
  /// Membersihkan teks dari karakter khusus (hanya huruf dan angka)
  static String cleanAlphanumeric(String text) {
    return text.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
  }

  /// Membersihkan teks dari emoji
  static String removeEmojis(String text) {
    return text.replaceAll(
      RegExp(
        r'[\u{1F600}-\u{1F64F}]|[\u{1F300}-\u{1F5FF}]|[\u{1F680}-\u{1F6FF}]|[\u{1F1E0}-\u{1F1FF}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]',
        unicode: true,
      ),
      '',
    );
  }

  /// Extract angka saja dari string
  static String extractNumbers(String text) {
    return text.replaceAll(RegExp(r'[^\d]'), '');
  }

  /// === FORMATTER CASE CONVERSION ===
  
  /// Convert ke camelCase
  /// Contoh: "Hello World" -> "helloWorld"
  static String toCamelCase(String text) {
    if (text.isEmpty) return text;
    
    List<String> words = text.toLowerCase().split(RegExp(r'[_\s]'));
    String result = words[0];
    
    for (int i = 1; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        result += words[i][0].toUpperCase() + words[i].substring(1);
      }
    }
    
    return result;
  }

  /// Convert ke snake_case
  /// Contoh: "Hello World" -> "hello_world"
  static String toSnakeCase(String text) {
    return text.toLowerCase().replaceAll(RegExp(r'[\s]'), '_');
  }

  /// Convert ke kebab-case
  /// Contoh: "Hello World" -> "hello-world"
  static String toKebabCase(String text) {
    return text.toLowerCase().replaceAll(RegExp(r'[\s]'), '-');
  }

  /// === FORMATTER MISC UTILITIES ===
  
  /// Menghitung jumlah kata dalam teks
  static int wordCount(String text) {
    if (text.isEmpty) return 0;
    return text.trim().split(RegExp(r'\s+')).length;
  }

  /// Format boolean ke teks yang user-friendly
  static String formatBoolean(bool value, {String trueText = 'Ya', String falseText = 'Tidak'}) {
    return value ? trueText : falseText;
  }

  /// Masking teks untuk sensitive data
  static String maskText(String text, {int visibleStart = 0, int visibleEnd = 0, String maskChar = '*'}) {
    if (text.length <= visibleStart + visibleEnd) return text;
    
    String start = text.substring(0, visibleStart);
    String end = visibleEnd > 0 ? text.substring(text.length - visibleEnd) : '';
    String masked = maskChar * (text.length - visibleStart - visibleEnd);
    
    return '$start$masked$end';
  }
}