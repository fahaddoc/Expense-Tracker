import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  static final DateFormat _dateTimeFormat = DateFormat('MMM dd, yyyy • hh:mm a');
  static final DateFormat _shortDateFormat = DateFormat('dd MMM');
  static final DateFormat _monthYearFormat = DateFormat('MMMM yyyy');
  static final DateFormat _dayFormat = DateFormat('EEEE');

  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  static String formatDateTime(DateTime date) {
    return _dateTimeFormat.format(date);
  }

  static String formatShortDate(DateTime date) {
    return _shortDateFormat.format(date);
  }

  static String formatMonthYear(DateTime date) {
    return _monthYearFormat.format(date);
  }

  static String formatDay(DateTime date) {
    return _dayFormat.format(date);
  }

  static String getRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    final difference = today.difference(dateOnly).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return formatDay(date);
    } else {
      return formatDate(date);
    }
  }
}
