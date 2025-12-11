import 'package:intl/intl.dart';

class DateFormatter {
  static String format(DateTime date, {String pattern = 'yyyy-MM-dd HH:mm'}) {
    try {
      return DateFormat(pattern, 'es_CO').format(date);
    } catch (e) {
      // Fallback si hay error con el locale
      return DateFormat(pattern).format(date);
    }
  }
  
  static String formatShort(DateTime date) {
    try {
      return DateFormat('dd/MM/yyyy', 'es_CO').format(date);
    } catch (e) {
      // Fallback si hay error con el locale
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }
  
  static String formatTime(DateTime date) {
    try {
      return DateFormat('HH:mm', 'es_CO').format(date);
    } catch (e) {
      // Fallback si hay error con el locale
      return DateFormat('HH:mm').format(date);
    }
  }
  
  static DateTime? parse(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }
  
  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Ahora';
        }
        return 'Hace ${difference.inMinutes} min';
      }
      return 'Hace ${difference.inHours} horas';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else {
      return formatShort(date);
    }
  }
}