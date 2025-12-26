part of 'router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _appShellNavigatorKey = GlobalKey<NavigatorState>();
final _dashboardShellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RouteConstants.initialRoute,
  redirect: (context, state) async {
    final goingToAuth = RouteConstants.authRoutes.any(
      (route) => state.matchedLocation.startsWith(route),
    );
    final goingToPublicRoute = RouteConstants.publicRoutes.any(
      (route) => state.matchedLocation.startsWith(route),
    );

    final isAuthenticated =
        (await sl<TokenProvider>().getAccessToken()) != null ||
        (await sl<TokenProvider>().getUserCognitoSub() != null);
    if (!goingToAuth && !goingToPublicRoute && !isAuthenticated) {
      return LoginPage.path;
    } else if (goingToAuth && isAuthenticated) {
      return RouteConstants.initialRoute;
    }
    return null;
  },
  routes: [
    ShellRoute(
      navigatorKey: _appShellNavigatorKey,
      builder: (context, _, child) {
        // It's safe to call multiple times as it
        // just updates the context, and it's guaranteed to have an Overlay
        // because ShellRoute builds inside the Navigator.
        sl<FToast>().init(context);
        return child;
      },
      routes: [
        ShellRoute(
          navigatorKey: _dashboardShellNavigatorKey,
          builder: (_, state, child) {
            return BlocProvider(
              create: (_) => sl<AuthAdapter>(),
              child: Shell(routerState: state, child: child),
            );
          },
          routes: [
            GoRoute(
              path: RouteConstants.initialRoute,
              builder: (_, _) {
                if (CurrentUserProvider.instance.userExists) {
                  return const HomePage();
                } else {
                  return BlocProvider(
                    create: (_) => sl<AuthAdapter>(),
                    child: const SplashPage(),
                  );
                }
              },
            ),
          ],
        ),
        GoRoute(
          path: SignupPage.path,
          builder: (_, _) {
            return BlocProvider(
              create: (_) => sl<AuthAdapter>(),
              child: const SignupPage(),
            );
          },
        ),
        GoRoute(
          path: LoginPage.path,
          builder: (_, _) {
            return BlocProvider(
              create: (_) => sl<AuthAdapter>(),
              child: const LoginPage(),
            );
          },
        ),
        GoRoute(
          path: ConfirmSignupPage.path,
          builder: (_, state) {
            final email = state.extra is String ? state.extra! as String : null;

            return BlocProvider(
              create: (_) => sl<AuthAdapter>(),
              child: ConfirmSignupPage(email: email),
            );
          },
        ),
      ],
    ),
  ],
);
