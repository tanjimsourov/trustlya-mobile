class AppFormatters {
  AppFormatters._();

  static String currency(
    num value, {
    String symbol = 'EUR',
    int decimals = 0,
    bool symbolFirst = false,
  }) {
    final formatted = _groupDigits(value.toStringAsFixed(decimals));
    return symbolFirst ? '$symbol$formatted' : '$formatted $symbol';
  }

  static String compactNumber(num value) {
    final absolute = value.abs();
    if (absolute >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)}B';
    }
    if (absolute >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (absolute >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(value % 1 == 0 ? 0 : 1);
  }

  static String percent(num value, {int decimals = 1, bool signed = false}) {
    final prefix = signed && value > 0 ? '+' : '';
    return '$prefix${value.toStringAsFixed(decimals)}%';
  }

  static String dateShort(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  static String dateTimeShort(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '${dateShort(date)} $hour:$minute';
  }

  static String titleCase(String value) {
    if (value.isEmpty) {
      return value;
    }
    return value
        .split(RegExp(r'[_\-\s]+'))
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }

  static String _groupDigits(String formatted) {
    final negative = formatted.startsWith('-');
    final sanitized = negative ? formatted.substring(1) : formatted;
    final parts = sanitized.split('.');
    final digits = parts.first;
    final groups = <String>[];
    var cursor = digits.length;

    while (cursor > 3) {
      groups.insert(0, digits.substring(cursor - 3, cursor));
      cursor -= 3;
    }
    groups.insert(0, digits.substring(0, cursor));

    final integerPart = groups.join(',');
    final prefix = negative ? '-' : '';

    if (parts.length == 1) {
      return '$prefix$integerPart';
    }

    return '$prefix$integerPart.${parts[1]}';
  }
}
