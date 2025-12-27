import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:itube/app/di/injection_container.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  bool get usePrint => (kIsWeb || kIsWasm) && kDebugMode;

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (usePrint) {
      debugPrint('onChange(${bloc.runtimeType}, $change)');
    } else {
      log('onChange(${bloc.runtimeType}, $change)');
    }
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    if (usePrint) {
      debugPrint('onError(${bloc.runtimeType}, $error, $stackTrace)');
    } else {
      log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    }
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (details) {
    if ((kIsWeb || kIsWasm) && kDebugMode) {
      debugPrint(details.exceptionAsString());
      debugPrintStack(stackTrace: details.stack);
    } else {
      log(details.exceptionAsString(), stackTrace: details.stack);
    }
  };

  Bloc.observer = const AppBlocObserver();

  // Add cross-flavor configuration here
  await init();

  usePathUrlStrategy();

  runApp(await builder());
}
