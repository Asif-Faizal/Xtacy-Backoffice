import 'package:intl/intl.dart';

/// Date formatting and parsing utilities.
class AppDateUtils {
  AppDateUtils._();

  static final DateFormat _displayFormat = DateFormat('dd MMM yyyy');
  static final DateFormat _monthFormat = DateFormat('MMM yyyy');
  static final DateFormat _isoFormat = DateFormat('yyyy-MM-dd');

  static String formatDisplay(DateTime date) => _displayFormat.format(date);

  static String formatMonth(DateTime date) => _monthFormat.format(date);

  static String formatIso(DateTime date) => _isoFormat.format(date);

  static DateTime startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static DateTime startOfMonth(DateTime date) =>
      DateTime(date.year, date.month);

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static bool isToday(DateTime date) => isSameDay(date, DateTime.now());
}
