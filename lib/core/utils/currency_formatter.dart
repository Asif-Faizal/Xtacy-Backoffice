import 'package:intl/intl.dart';

/// Currency formatting utilities.
class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _formatter = NumberFormat.currency(
    symbol: '₹',
    decimalDigits: 0,
  );

  static String format(double amount) => _formatter.format(amount);

  static String formatNullable(double? amount) {
    if (amount == null) return '—';
    return format(amount);
  }
}
