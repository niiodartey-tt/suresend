/// Currency Formatting Utility
/// Ensures consistent GHS (₵) currency formatting across the app
library;

class CurrencyFormatter {
  CurrencyFormatter._();

  /// Format amount to GHS with proper symbol and decimal places
  ///
  /// Examples:
  /// - formatGHS(1234.50) -> "GHS 1,234.50"
  /// - formatGHS(1234.50, showSymbol: true) -> "₵1,234.50"
  /// - formatGHS(1234.50, compact: true) -> "GHS 1.2K"
  static String formatGHS(
    double amount, {
    bool showSymbol = false,
    bool compact = false,
    int decimalPlaces = 2,
  }) {
    if (compact) {
      return _formatCompact(amount, showSymbol);
    }

    final formatted = _formatWithCommas(amount, decimalPlaces);

    if (showSymbol) {
      return '₵$formatted';
    } else {
      return 'GHS $formatted';
    }
  }

  /// Format with thousands separators
  static String _formatWithCommas(double amount, int decimalPlaces) {
    final parts = amount.toStringAsFixed(decimalPlaces).split('.');
    final wholePart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : '';

    // Add commas to whole part
    final buffer = StringBuffer();
    var count = 0;

    for (var i = wholePart.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(wholePart[i]);
      count++;
    }

    final reversedWhole = buffer.toString().split('').reversed.join('');

    if (decimalPart.isNotEmpty) {
      return '$reversedWhole.$decimalPart';
    } else {
      return reversedWhole;
    }
  }

  /// Format in compact notation (K, M, B)
  static String _formatCompact(double amount, bool showSymbol) {
    final prefix = showSymbol ? '₵' : 'GHS ';

    if (amount >= 1000000000) {
      return '$prefix${(amount / 1000000000).toStringAsFixed(1)}B';
    } else if (amount >= 1000000) {
      return '$prefix${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '$prefix${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return '$prefix${amount.toStringAsFixed(2)}';
    }
  }

  /// Parse GHS string back to double
  /// Handles both "GHS 1,234.50" and "₵1,234.50" formats
  static double parseGHS(String value) {
    // Remove GHS, ₵, commas, and spaces
    final cleaned = value
        .replaceAll('GHS', '')
        .replaceAll('₵', '')
        .replaceAll(',', '')
        .replaceAll(' ', '')
        .trim();

    return double.tryParse(cleaned) ?? 0.0;
  }

  /// Convert USD to GHS (using approximate exchange rate)
  /// Note: In production, fetch real-time rates from an API
  static double usdToGHS(double usd, {double rate = 12.5}) {
    return usd * rate;
  }

  /// Convert GHS to USD
  static double ghsToUSD(double ghs, {double rate = 12.5}) {
    return ghs / rate;
  }
}
