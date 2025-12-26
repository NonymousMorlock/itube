import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:itube/app/app.dart';
import 'package:itube/bootstrap.dart';

Future<void> main() async {
  await bootstrap(
    () => DevicePreview(
      enabled: !kIsWasm && !kIsWeb,
      builder: (_) => const App(),
    ),
  );
}
