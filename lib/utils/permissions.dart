import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';

Future<void> requestCameraPermission() async {
  final status = await Permission.camera.request();

  if (status.isGranted) {
    // Permission granted
    log('Camera permission granted');
  } else if (status.isDenied) {
    // Denied sementara
    log('Camera permission denied');
  } else if (status.isPermanentlyDenied) {
    // Permanent, go to settings
    openAppSettings();
  }
}
