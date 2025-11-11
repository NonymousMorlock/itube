import 'package:itube/app/app.dart';
import 'package:itube/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
