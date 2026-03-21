import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:itube/app/app.dart';
import 'package:itube/bootstrap.dart';

Future<void> main() async {
  await bootstrap(
    () => DevicePreview(
      enabled:
          !kIsWasm &&
          !kIsWeb &&
          defaultTargetPlatform != TargetPlatform.fuchsia &&
          defaultTargetPlatform != TargetPlatform.iOS &&
          defaultTargetPlatform != TargetPlatform.android,
      builder: (_) => const App(),
    ),
  );
}
