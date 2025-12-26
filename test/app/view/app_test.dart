// Ignore for testing purposes
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:itube/app/app.dart';
import 'package:itube/src/auth/presentation/views/signup_page.dart';

void main() {
  group('App', () {
    testWidgets('renders SignupPage', (tester) async {
      await tester.pumpWidget(App());
      expect(find.byType(SignupPage), findsOneWidget);
    });
  });
}
