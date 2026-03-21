import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:itube/src/auth/auth.dart';
import 'package:itube/src/auth/presentation/adapters/auth_adapter.dart';
import 'package:itube/src/splash/presentation/animations/molten_prism.dart';
import 'package:itube/src/splash/presentation/animations/prism_engine.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({required this.next, this.nextExtra, super.key});

  final String next;
  final Object? nextExtra;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final PrismEngine _engine;

  @override
  void initState() {
    super.initState();
    // Initialize the Engine
    _engine = PrismEngine(this);

    // Start the intro animation immediately
    _engine
      ..start()
      // Listen for the "Finished" signal to navigate away
      ..addListener(_onEngineUpdate);

    // Start fetching data
    _bootstrapApp();
  }

  void _onEngineUpdate() {
    if (_engine.isFinished) {
      _navigateToNext();
    }
  }

  void _bootstrapApp() {
    unawaited(context.read<AuthAdapter>().getCurrentUser());
  }

  void _navigateToNext() {
    final state = context.read<AuthAdapter>().state;
    if (state is CurrentUserLoaded) {
      context.go(
        widget.next,
        extra: widget.nextExtra ?? DateTime.now().millisecondsSinceEpoch,
      );
    } else if (state is AuthError) {
      context.go(LoginPage.path, extra: {'force': true});
    }
  }

  @override
  void dispose() {
    _engine
      ..removeListener(_onEngineUpdate)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthAdapter, AuthState>(
      listener: (_, state) {
        if (state is CurrentUserLoaded || state is AuthError) {
          // Tell the engine we are ready.
          // It will gracefully transition from "Liquid" to "Crystal"
          // and then trigger the completion listener.
          _engine.onDataLoaded();
        }
      },
      child: Scaffold(
        // Matches the shader background
        backgroundColor: Colors.black,
        body: MoltenPrism(engine: _engine),
      ),
    );
  }
}
