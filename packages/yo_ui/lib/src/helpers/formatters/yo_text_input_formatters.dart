import 'package:flutter/services.dart';

/// TextInputFormatter for credit card number
/// Example: 1234567890123456 -> 1234 5678 9012 3456
class CreditCardFormatter extends TextInputFormatter {
  final String separator;

  CreditCardFormatter({this.separator = ' '});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Limit to 16 digits
    if (digitsOnly.length > 16) {
      digitsOnly = digitsOnly.substring(0, 16);
    }

    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(separator);
      }
      buffer.write(digitsOnly[i]);
    }

    final String formatted = buffer.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// TextInputFormatter for currency input with thousand separators
/// Example: 1000000 -> 1.000.000
class CurrencyTextInputFormatter extends TextInputFormatter {
  final String thousandSeparator;
  final String decimalSeparator;
  final int decimalDigits;
  final bool allowDecimal;

  CurrencyTextInputFormatter({
    this.thousandSeparator = '.',
    this.decimalSeparator = ',',
    this.decimalDigits = 0,
    this.allowDecimal = false,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // If empty, return empty
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digit characters except decimal separator
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Format with thousand separator
    final StringBuffer buffer = StringBuffer();
    int counter = 0;

    for (int i = digitsOnly.length - 1; i >= 0; i--) {
      if (counter != 0 && counter % 3 == 0) {
        buffer.write(thousandSeparator);
      }
      buffer.write(digitsOnly[i]);
      counter++;
    }

    final String formatted = buffer.toString().split('').reversed.join();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// TextInputFormatter for decimal number input
class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalPlaces;
  final String decimalSeparator;

  DecimalTextInputFormatter({
    this.decimalPlaces = 2,
    this.decimalSeparator = ',',
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Only allow digits and one decimal separator
    String text = newValue.text;

    // Replace any other separator with the configured one
    text = text.replaceAll('.', decimalSeparator);

    // Count decimal separators
    int separatorCount = decimalSeparator.allMatches(text).length;

    // Only allow one decimal separator
    if (separatorCount > 1) {
      text = oldValue.text;
    }

    // Limit decimal places
    if (text.contains(decimalSeparator)) {
      final parts = text.split(decimalSeparator);
      if (parts.length == 2 && parts[1].length > decimalPlaces) {
        text =
            '${parts[0]}$decimalSeparator${parts[1].substring(0, decimalPlaces)}';
      }
    }

    // Remove non-valid characters
    text = text.replaceAll(RegExp('[^0-9$decimalSeparator]'), '');

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

/// TextInputFormatter for Indonesian currency with Rp prefix
/// Uses intl package for proper formatting
/// Example: 1000000 -> Rp 1.000.000
class IndonesiaCurrencyFormatter extends TextInputFormatter {
  final bool showSymbol;
  final String symbol;

  IndonesiaCurrencyFormatter({
    this.showSymbol = true,
    this.symbol = 'Rp ',
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final cleanedText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanedText.isEmpty) return newValue.copyWith(text: '');

    final number = int.parse(cleanedText);
    final formatted = _formatCurrency(number);

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _formatCurrency(int amount) {
    if (amount == 0) return showSymbol ? '${symbol}0' : '0';

    // Manual formatting for Indonesian locale
    final StringBuffer buffer = StringBuffer();
    final String digits = amount.toString();

    int counter = 0;
    for (int i = digits.length - 1; i >= 0; i--) {
      if (counter != 0 && counter % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(digits[i]);
      counter++;
    }

    final formatted = buffer.toString().split('').reversed.join();
    return showSymbol ? '$symbol$formatted' : formatted;
  }
}

/// TextInputFormatter for Indonesian phone numbers
/// Supports both local format (0xxx) and international format (+62)
/// Example: 081234567890 -> 0812 3456 7890
/// Example: 6281234567890 -> +62 812 3456 7890
class IndonesiaPhoneFormatter extends TextInputFormatter {
  final String separator;

  IndonesiaPhoneFormatter({this.separator = ' '});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (text.isEmpty) return newValue.copyWith(text: '');

    String formatted = '';
    if (text.startsWith('0')) {
      // Local format: 0812 3456 7890
      if (text.length >= 3) {
        formatted = text.substring(0, 4.clamp(0, text.length));
        if (text.length > 4) {
          formatted +=
              '$separator${text.substring(4, 8.clamp(4, text.length))}';
        }
        if (text.length > 8) {
          formatted +=
              '$separator${text.substring(8, 12.clamp(8, text.length))}';
        }
        if (text.length > 12) {
          formatted +=
              '$separator${text.substring(12, 16.clamp(12, text.length))}';
        }
      } else {
        formatted = text;
      }
    } else if (text.startsWith('62')) {
      // International format: +62 812 3456 7890
      formatted = '+62';
      if (text.length > 2) {
        formatted += '$separator${text.substring(2, 5.clamp(2, text.length))}';
      }
      if (text.length > 5) {
        formatted += '$separator${text.substring(5, 9.clamp(5, text.length))}';
      }
      if (text.length > 9) {
        formatted += '$separator${text.substring(9, 13.clamp(9, text.length))}';
      }
    } else {
      formatted = text;
    }

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// TextInputFormatter to convert all input to lowercase
class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}

/// TextInputFormatter for phone number input
/// Formats phone numbers with proper spacing
/// Example: 081234567890 -> 0812-3456-7890
class PhoneNumberFormatter extends TextInputFormatter {
  final String separator;
  final List<int> groupSizes;

  PhoneNumberFormatter({
    this.separator = '-',
    this.groupSizes = const [4, 4, 4],
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove all non-digit characters
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d+]'), '');

    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Format phone number with groups
    final StringBuffer buffer = StringBuffer();
    int digitIndex = 0;
    int groupIndex = 0;
    int currentGroupCount = 0;

    for (int i = 0;
        i < digitsOnly.length && groupIndex < groupSizes.length;
        i++) {
      if (currentGroupCount == groupSizes[groupIndex]) {
        buffer.write(separator);
        groupIndex++;
        currentGroupCount = 0;
        if (groupIndex >= groupSizes.length) break;
      }
      buffer.write(digitsOnly[i]);
      currentGroupCount++;
      digitIndex++;
    }

    // Add remaining digits
    if (digitIndex < digitsOnly.length) {
      for (int i = digitIndex; i < digitsOnly.length; i++) {
        buffer.write(digitsOnly[i]);
      }
    }

    final String formatted = buffer.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// TextInputFormatter to convert all input to uppercase
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
