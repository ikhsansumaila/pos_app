import 'package:intl/intl.dart';

class AppFormatter {
  static String currency(double amount) {
    return 'Rp${NumberFormat("#,##0", "id_ID").format(amount)}';
  }

  static String date(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }
}
