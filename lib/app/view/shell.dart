import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:itube/app/di/injection_container.dart';
import 'package:itube/core/network/interfaces/session_observer.dart';
import 'package:itube/src/auth/auth.dart';
import 'package:itube/src/auth/presentation/adapters/auth_adapter.dart';

class Shell extends StatefulWidget {
  const Shell({
    required this.child,
    required this.routerState,
    super.key,
  });

  final Widget child;
  final GoRouterState routerState;

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  StreamSubscription<void>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = sl<SessionObserver>().onSessionExpired.listen((_) {
      if (mounted) {
        unawaited(context.read<AuthAdapter>().logout());
      }
    });
  }

  @override
  Future<void> dispose() async {
    await _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthAdapter, AuthState>(
      listener: (_, state) {
        if (state is LoggedOut) {
          context.go(LoginPage.path);
        }
      },
      child: widget.child,
    );
  }
}
