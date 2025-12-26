import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:itube/app/routing/router.dart';
import 'package:itube/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'iTube',
      routerConfig: router,
      theme: ThemeData(
        useMaterial3: true,
        // NEUTRAL BRANDING: purely black/white.
        colorScheme: const ColorScheme.light(
          primary: Colors.black,
          error: Color(0xFFE53935),
        ),

        scaffoldBackgroundColor: Colors.white,

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),

        navigationRailTheme: NavigationRailThemeData(
          backgroundColor: Colors.white,
          elevation: 0,
          indicatorColor: Colors.transparent,
          selectedIconTheme: const IconThemeData(
            color: Colors.black,
            size: 28,
            opacity: 1,
          ),
          unselectedIconTheme: IconThemeData(
            color: Colors.grey.shade400,
            size: 28,
            opacity: 1,
          ),
          selectedLabelTextStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelTextStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 12,
          ),
          // Push items to the top
          groupAlignment: -0.9,
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF3F4F6),
          // Very subtle grey (Tailwind style)
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),

          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(8), // Sharp, not round
          ),

          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2),
            borderRadius: BorderRadius.circular(8),
          ),

          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFE53935)),
            borderRadius: BorderRadius.circular(8),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFE53935), width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        // SHARPER BUTTONS: Matches inputs exactly
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            elevation: 0,
            // Flat is cleaner for web
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),

        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
      ),
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
