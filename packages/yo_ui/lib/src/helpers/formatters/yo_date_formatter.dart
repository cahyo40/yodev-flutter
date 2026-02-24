import 'package:intl/intl.dart';

class YoDateFormatter {
  static DateTexts _texts = DateTexts.indonesian; // default

  /// Consumer tinggal set 1 baris di main
  static set texts(DateTexts t) => _texts = t;
  // === BASIC FORMATTING ===

  // Date Formats - tanpa locale parameter
  static String formatDate(DateTime date, {String format = 'dd MMM yyyy'}) {
    final dateFormat = DateFormat(format);
    return dateFormat.format(date);
  }

  static String formatDateTime(
    DateTime date, {
    String format = 'dd MMM yyyy HH:mm',
  }) {
    final dateFormat = DateFormat(format);
    return dateFormat.format(date);
  }

  static String formatTime(DateTime date, {String format = 'HH:mm'}) {
    final dateFormat = DateFormat(format);
    return dateFormat.format(date);
  }

  // === RELATIVE TIME ===

  static String formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) return _texts.justNow;
        return _texts.minutesAgo(difference.inMinutes);
      }
      return _texts.hoursAgo(difference.inHours);
    } else if (difference.inDays == 1) {
      return _texts.yesterday;
    } else if (difference.inDays < 7) {
      return _texts.daysAgo(difference.inDays);
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return _texts.weeksAgo(weeks);
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return _texts.monthsAgo(months);
    } else {
      final years = (difference.inDays / 365).floor();
      return _texts.yearsAgo(years);
    }
  }

  // === DATE COMPARISON HELPERS ===

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return date.isAfter(startOfWeek) && date.isBefore(endOfWeek);
  }

  static bool isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  static bool isThisYear(DateTime date) {
    return date.year == DateTime.now().year;
  }

  // === DATE MANIPULATION ===

  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  static DateTime startOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  static DateTime endOfWeek(DateTime date) {
    return date.add(Duration(days: DateTime.daysPerWeek - date.weekday));
  }

  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  static DateTime addDays(DateTime date, int days) {
    return date.add(Duration(days: days));
  }

  static DateTime subtractDays(DateTime date, int days) {
    return date.subtract(Duration(days: days));
  }

  // === DATE RANGE HELPERS ===

  static String formatDateRange(DateTime start, DateTime end) {
    if (start.year == end.year &&
        start.month == end.month &&
        start.day == end.day) {
      return '${formatDate(start)} • ${formatTime(start)} - ${formatTime(end)}';
    } else if (start.year == end.year) {
      return '${formatDate(start, format: 'dd MMM')} - ${formatDate(end)}';
    } else {
      return '${formatDate(start)} - ${formatDate(end)}';
    }
  }

  static List<DateTime> getDaysInRange(DateTime start, DateTime end) {
    final days = <DateTime>[];
    var current = startOfDay(start);
    final endDate = startOfDay(end);

    while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
      days.add(current);
      current = current.add(const Duration(days: 1));
    }

    return days;
  }

  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  // === AGE CALCULATION ===

  static int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  static String formatAge(DateTime birthDate) {
    final age = calculateAge(birthDate);
    return '$age tahun';
  }

  // === DURATION FORMATTING ===

  static String formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return _texts.durationHm(
          duration.inHours, duration.inMinutes.remainder(60));
    } else if (duration.inMinutes > 0) {
      return _texts.durationM(duration.inMinutes);
    } else {
      return _texts.durationS(duration.inSeconds);
    }
  }

  static String formatDurationShort(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}j ${duration.inMinutes.remainder(60)}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}d';
    }
  }

  // === CALENDAR HELPERS ===

  static String getMonthName(int month) {
    final date = DateTime(2023, month);
    final format = DateFormat('MMMM');
    return format.format(date);
  }

  static String getDayName(DateTime date) {
    final format = DateFormat('EEEE');
    return format.format(date);
  }

  static String getShortDayName(DateTime date) {
    final format = DateFormat('E');
    return format.format(date);
  }

  static String getRelativeDay(DateTime date) {
    if (isToday(date)) return _texts.today;
    if (isYesterday(date)) return _texts.yesterday;
    if (isTomorrow(date)) return _texts.tomorrow;
    return formatDate(date);
  }

  // === LIST GENERATORS ===

  static List<String> getMonthNames() {
    return List.generate(12, (index) => getMonthName(index + 1));
  }

  static List<String> getShortMonthNames() {
    final format = DateFormat('MMM');
    return List.generate(
      12,
      (index) => format.format(DateTime(2023, index + 1)),
    );
  }

  static List<String> getDayNames() {
    final days = <String>[];
    final today = DateTime.now();
    for (int i = 0; i < 7; i++) {
      days.add(getDayName(today.add(Duration(days: i))));
    }
    return days;
  }

  static List<String> getShortDayNames() {
    final format = DateFormat('E');
    final days = <String>[];
    final today = DateTime.now();
    for (int i = 0; i < 7; i++) {
      days.add(format.format(today.add(Duration(days: i))));
    }
    return days;
  }

  // === WORKDAY HELPERS ===

  static bool isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  static bool isWeekday(DateTime date) {
    return !isWeekend(date);
  }

  static DateTime nextWeekday(DateTime date) {
    var next = date.add(const Duration(days: 1));
    while (isWeekend(next)) {
      next = next.add(const Duration(days: 1));
    }
    return next;
  }

  static DateTime previousWeekday(DateTime date) {
    var previous = date.subtract(const Duration(days: 1));
    while (isWeekend(previous)) {
      previous = previous.subtract(const Duration(days: 1));
    }
    return previous;
  }

  // === VALIDATION HELPERS ===

  static bool isAfterToday(DateTime date) {
    return date.isAfter(DateTime.now());
  }

  static bool isBeforeToday(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  // === TIMESTAMP CONVERSION ===

  static DateTime fromTimestamp(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  static int toTimestamp(DateTime date) {
    return date.millisecondsSinceEpoch;
  }

  // === SPECIAL DATES ===

  static bool isBirthday(DateTime birthDate) {
    final now = DateTime.now();
    return now.month == birthDate.month && now.day == birthDate.day;
  }

  static int daysUntilBirthday(DateTime birthDate) {
    final now = DateTime.now();
    var nextBirthday = DateTime(now.year, birthDate.month, birthDate.day);

    if (nextBirthday.isBefore(now)) {
      nextBirthday = DateTime(now.year + 1, birthDate.month, birthDate.day);
    }

    return daysBetween(now, nextBirthday);
  }
}

class DateTexts {
  final String justNow;
  final String Function(int n) minutesAgo;
  final String Function(int n) hoursAgo;
  final String yesterday;
  final String Function(int n) daysAgo;
  final String Function(int n) weeksAgo;
  final String Function(int n) monthsAgo;
  final String Function(int n) yearsAgo;
  final String Function(int h, int m) durationHm; // h>0
  final String Function(int m) durationM; // m>0
  final String Function(int s) durationS; // s>0
  final String today;
  final String tomorrow;

  const DateTexts({
    required this.justNow,
    required this.minutesAgo,
    required this.hoursAgo,
    required this.yesterday,
    required this.daysAgo,
    required this.weeksAgo,
    required this.monthsAgo,
    required this.yearsAgo,
    required this.durationHm,
    required this.durationM,
    required this.durationS,
    required this.today,
    required this.tomorrow,
  });

  /* ---------- built-in Indo ---------- */
  static final indonesian = DateTexts(
    justNow: 'Baru saja',
    minutesAgo: (n) => n == 1 ? '1 menit lalu' : '$n menit lalu',
    hoursAgo: (n) => n == 1 ? '1 jam lalu' : '$n jam lalu',
    yesterday: 'Kemarin',
    daysAgo: (n) => n == 1 ? '1 hari lalu' : '$n hari lalu',
    weeksAgo: (n) => n == 1 ? '1 minggu lalu' : '$n minggu lalu',
    monthsAgo: (n) => n == 1 ? '1 bulan lalu' : '$n bulan lalu',
    yearsAgo: (n) => n == 1 ? '1 tahun lalu' : '$n tahun lalu',
    durationHm: (h, m) => '$h jam $m menit',
    durationM: (m) => '$m menit',
    durationS: (s) => '$s detik',
    today: 'Hari ini',
    tomorrow: 'Besok',
  );

  /* ---------- built-in English ---------- */
  static final english = DateTexts(
    justNow: 'Now',
    durationHm: (h, m) => '${h}h ${m}m',
    durationM: (m) => '$m min',
    durationS: (s) => '${s}s',
    today: 'Today',
    tomorrow: 'Tomorrow',
    minutesAgo: (n) => n == 1 ? '1 minute ago' : '$n minutes ago',
    hoursAgo: (n) => n == 1 ? '1 hour ago' : '$n hours ago',
    yesterday: 'Yesterday',
    daysAgo: (n) => n == 1 ? '1 day ago' : '$n days ago',
    weeksAgo: (n) => n == 1 ? '1 week ago' : '$n weeks ago',
    monthsAgo: (n) => n == 1 ? '1 month ago' : '$n months ago',
    yearsAgo: (n) => n == 1 ? '1 year ago' : '$n years ago',
  );
}
