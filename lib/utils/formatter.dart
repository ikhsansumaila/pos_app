import 'package:intl/intl.dart';

class AppFormatter {
  static String currency(double amount) {
    return 'Rp${NumberFormat("#,##0", "id_ID").format(amount)}';
  }

  static double parseCurrency(String formatted) {
    final clean = formatted
        .replaceAll(RegExp(r'[^\d,]'), '') // hapus semua kecuali angka dan koma
        .replaceAll(',', '.'); // ganti koma jadi titik untuk desimal
    return double.tryParse(clean) ?? 0.0;
  }

  static String date(DateTime dateTime, {String format = 'yyyy-MM-dd'}) {
    return DateFormat(format).format(dateTime);
  }

  static String dateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }
}
