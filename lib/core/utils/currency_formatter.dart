import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: 'Rs. ',
    decimalDigits: 0,
  );

  static final NumberFormat _compactFormat = NumberFormat.compactCurrency(
    symbol: 'Rs. ',
    decimalDigits: 0,
  );

  static String format(double amount) {
    return _currencyFormat.format(amount);
  }

  static String formatCompact(double amount) {
    return _compactFormat.format(amount);
  }

  static String formatWithSign(double amount) {
    final formatted = format(amount.abs());
    return amount < 0 ? '-$formatted' : '+$formatted';
  }
}
