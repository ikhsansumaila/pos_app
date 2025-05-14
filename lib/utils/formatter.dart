import 'package:intl/intl.dart';

class AppFormatter {
  static String currency(double amount) {
    return 'Rp${NumberFormat("#,##0", "id_ID").format(amount)}';
  }

  static String date(DateTime dateTime, {String format = 'yyyy-MM-dd'}) {
    return DateFormat(format).format(dateTime);
  }

  static String dateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }
}
