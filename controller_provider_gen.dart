import 'dart:io';

void main() async {
  final buffer = StringBuffer();
  final controllerDir = Directory('lib');
  final files =
      controllerDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('_controller.dart'))
          .toList();

  final controllers = <String>[];

  buffer.writeln("import 'package:get/get.dart';");

  for (var file in files) {
    final relativePath = file.path.replaceFirst('lib/', '../');
    final name = file.uri.pathSegments.last.replaceAll('.dart', '');

    final content = await file.readAsString();
    final classMatch = RegExp(r'class\s+(\w+Controller)').firstMatch(content);
    if (classMatch != null) {
      final className = classMatch.group(1)!;
      controllers.add(className);
      buffer.writeln("import '$relativePath';");
    }
  }

  buffer.writeln('\nT getOrPut<T extends Object>() {');
  buffer.writeln('  if (Get.isRegistered<T>()) return Get.find<T>();\n');

  for (var className in controllers) {
    buffer.writeln("  if (T == $className) return Get.put($className()) as T;");
  }

  buffer.writeln("\n  throw Exception('getOrPut: Type \$T tidak dikenali.');");
  buffer.writeln('}');

  final outFile = File('lib/core/controller_provider.dart');
  await outFile.writeAsString(buffer.toString());

  print('✅ controller_provider.dart updated with ${controllers.length} controllers.');
}
