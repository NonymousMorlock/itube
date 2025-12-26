// Ignore for testing purposes
// ignore_for_file: prefer_const_constructors

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:itube/app/app.dart';
import 'package:itube/core/network/interfaces/token_provider.dart';
import 'package:itube/src/auth/auth.dart';
import 'package:itube/src/auth/presentation/adapters/auth_adapter.dart';
import 'package:mocktail/mocktail.dart';

class MockTokenProvider extends Mock implements TokenProvider {}

class MockAuthAdapter extends Mock implements AuthAdapter {}

class MockFToast extends Mock implements FToast {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late TokenProvider tokenProvider;
  late AuthAdapter authAdapter;
  late FToast fToast;

  setUp(() {
    tokenProvider = MockTokenProvider();
    authAdapter = MockAuthAdapter();
    fToast = MockFToast();
  });
  group('App', () {
    setUp(() {
      GetIt.instance.registerSingleton<TokenProvider>(tokenProvider);
      GetIt.instance.registerSingleton<AuthAdapter>(authAdapter);
      GetIt.instance.registerSingleton<FToast>(fToast);

      registerFallbackValue(MockBuildContext());
      registerFallbackValue(SizedBox());
    });
    testWidgets('renders LoginPage', (tester) async {
      when(() => tokenProvider.getAccessToken()).thenAnswer((_) async => null);
      when(
        () => tokenProvider.getUserCognitoSub(),
      ).thenAnswer((_) async => null);

      when(
        () => authAdapter.login(
          email: any<String>(named: 'email'),
          password: any<String>(named: 'password'),
        ),
      ).thenAnswer((_) async => Future.value());

      when(() => fToast.init(any<BuildContext>())).thenAnswer((_) => fToast);
      when(
        () => fToast.showToast(child: any<Widget>(named: 'child')),
      ).thenAnswer((_) => fToast);
      when(() => fToast.removeCustomToast()).thenAnswer((_) => fToast);

      when(() => authAdapter.stream).thenAnswer((_) => Stream.empty());

      when(() => authAdapter.state).thenReturn(AuthInitial());

      when(() => authAdapter.close()).thenAnswer((_) => Future.value());

      await tester.pumpWidget(App());
      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);
    });
  });
}
