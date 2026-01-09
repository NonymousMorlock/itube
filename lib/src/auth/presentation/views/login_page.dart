import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:itube/app/routing/route_constants.dart';
import 'package:itube/app/utils/app_utils.dart';
import 'package:itube/core/extensions/context_extensions.dart';
import 'package:itube/core/presentation/widgets/adaptive_progress_indicator.dart';
import 'package:itube/core/presentation/widgets/auth_layout.dart';
import 'package:itube/src/auth/presentation/adapters/auth_adapter.dart';
import 'package:itube/src/auth/presentation/views/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({this.next, super.key});

  static const path = '/login';

  final String? next;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final ValueNotifier<bool> _obscurePasswordNotifier = ValueNotifier(true);

  String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Field cannot be empty';
    }
    return null;
  }

  void login() {
    if (_formKey.currentState?.validate() ?? false) {
      unawaited(
        context.read<AuthAdapter>().login(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _obscurePasswordNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthAdapter, AuthState>(
      listener: (context, state) {
        if (state case AuthError(:final message, :final title)) {
          AppUtils.showErrorToast(context, message: message, title: title);
        } else if (state is LoggedIn) {
          unawaited(context.read<AuthAdapter>().getCurrentUser());
        } else if (state is CurrentUserLoaded) {
          AppUtils.showSuccessToast(
            context,
            message: 'Logged in successfully.',
          );
          context.go(widget.next ?? RouteConstants.initialRoute);
        }
      },
      child: AuthLayout(
        title: 'Welcome Back',
        subtitle: 'Sign in to continue to iTube',
        form: Form(
          key: _formKey,
          child: Column(
            children: [
              // Email Field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'user@example.com',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: validate,
              ),
              const Gap(16),

              // Password Field
              ValueListenableBuilder(
                valueListenable: _obscurePasswordNotifier,
                builder: (_, obscurePassword, _) {
                  return TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: obscurePassword,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => login(),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _obscurePasswordNotifier.value = !obscurePassword;
                        },
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                    validator: validate,
                  );
                },
              ),

              // Forgot Password Stub
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO(Feat): Navigate to forgot password.
                    // I haven't got this implemented, so, implement it if
                    // you want to.
                  },
                  child: const Text('Forgot Password?'),
                ),
              ),

              const Gap(24),

              // Login Button
              BlocBuilder<AuthAdapter, AuthState>(
                builder: (_, state) {
                  final isLoading = state is AuthLoading;

                  return SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: isLoading ? null : login,
                      child: isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: AdaptiveProgressIndicator(
                                color: context.theme.colorScheme.onPrimary,
                              ),
                            )
                          : const Text('SIGN IN'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        bottomAction: Center(
          child: Text.rich(
            TextSpan(
              text: "Don't have an account? ",
              style: context.textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: 'Sign Up',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: context.theme.primaryColor,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      context.go(SignupPage.path);
                    },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
