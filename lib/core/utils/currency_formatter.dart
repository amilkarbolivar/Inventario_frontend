import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String format(double amount) {
    try {
      final formatter = NumberFormat.currency(
        locale: 'es_CO',
        symbol: '\$',
        decimalDigits: 0,
      );
      return formatter.format(amount);
    } catch (e) {
      // Fallback si hay error con el locale
      return '\$${amount.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      )}';
    }
  }
  
  static String formatWithDecimals(double amount) {
    try {
      final formatter = NumberFormat.currency(
        locale: 'es_CO',
        symbol: '\$',
        decimalDigits: 2,
      );
      return formatter.format(amount);
    } catch (e) {
      // Fallback si hay error con el locale
      return '\$${amount.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      )}';
    }
  }
}