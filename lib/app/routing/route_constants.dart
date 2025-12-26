import 'package:itube/src/auth/auth.dart';

sealed class RouteConstants {
  const RouteConstants();

  static const initialRoute = '/';

  static const authRoutes = <String>[
    SignupPage.path,
    LoginPage.path,
    ConfirmSignupPage.path,
  ];

  static const publicRoutes = <String>[];
}
