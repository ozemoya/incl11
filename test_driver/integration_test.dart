import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async {
  await integrationDriver(
    onScreenshot:
        (String name, List<int> bytes, [Map<String, Object?>? args]) async {
          await Directory('docs').create(recursive: true);
          await File('docs/nightfall-$name.png').writeAsBytes(bytes);
          return bytes.isNotEmpty;
        },
  );
}
