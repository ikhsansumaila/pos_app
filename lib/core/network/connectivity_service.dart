// core/network/connectivity_service.dart
import 'dart:developer';
import 'dart:io';

// import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  // final Connectivity _connectivity = Connectivity();

  Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      final isConnected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      log("Internet is ${isConnected ? "on" : "off"}");
      return isConnected;
    } catch (_) {
      log("Internet is off");
      return false;
    }
  }
}
