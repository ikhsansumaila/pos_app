import 'package:permission_handler/permission_handler.dart';

Future<void> requestCameraPermission() async {
  final status = await Permission.camera.request();

  if (status.isGranted) {
    // Permission granted
    print('Camera permission granted');
  } else if (status.isDenied) {
    // Denied sementara
    print('Camera permission denied');
  } else if (status.isPermanentlyDenied) {
    // Permanent, go to settings
    openAppSettings();
  }
}
