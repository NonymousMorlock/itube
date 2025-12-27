import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get screenSize => MediaQuery.sizeOf(this);

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  TargetPlatform get platform => theme.platform;
}
