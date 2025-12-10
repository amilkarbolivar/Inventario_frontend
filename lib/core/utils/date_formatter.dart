import 'package:intl/intl.dart';

class DateFormatter {
  static String format(DateTime date, {String pattern = 'yyyy-MM-dd HH:mm'}) {
    return DateFormat(pattern, 'es_CO').format(date);
  }
  
  static String formatShort(DateTime date) {
    return DateFormat('dd/MM/yyyy', 'es_CO').format(date);
  }
  
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm', 'es_CO').format(date);
  }
  
  static DateTime? parse(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }
}