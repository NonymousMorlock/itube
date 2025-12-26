import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:itube/app/utils/app_utils.dart';
import 'package:itube/core/extensions/context_extensions.dart';
import 'package:itube/core/presentation/widgets/adaptive_progress_indicator.dart';
import 'package:itube/core/presentation/widgets/auth_layout.dart';
import 'package:itube/src/auth/presentation/adapters/auth_adapter.dart';
import 'package:itube/src/auth/presentation/views/confirm_signup_page.dart';
import 'package:itube/src/auth/presentation/views/login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  static const path = '/register';

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final ValueNotifier<bool> _obscurePasswordNotifier = ValueNotifier(true);

  String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Field cannot be empty';
    }
    return null;
  }

  void signUp() {
    if (_formKey.currentState?.validate() ?? false) {
      unawaited(
        context.read<AuthAdapter>().register(
          email: _emailController.text.trim(),
          name: _nameController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
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
        } else if (state is Registered) {
          context.go(
            ConfirmSignupPage.path,
            extra: _emailController.text.trim(),
          );
          AppUtils.showSuccessToast(
            context,
            message: 'Registered successfully. Check your email.',
          );
        }
      },
      child: AuthLayout(
        title: 'Create Account',
        subtitle: 'Join iTube to start watching',
        form: Form(
          key: _formKey,
          child: Column(
            children: [
              // Name Field
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: validate,
              ),
              const Gap(16),

              // Email Field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Email',
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
                    onFieldSubmitted: (_) => signUp(),
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
              const Gap(32),

              // Sign Up Button
              BlocBuilder<AuthAdapter, AuthState>(
                builder: (_, state) {
                  final isLoading = state is AuthLoading;

                  return SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: isLoading ? null : signUp,
                      child: isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: AdaptiveProgressIndicator(
                                color: context.theme.colorScheme.onPrimary,
                              ),
                            )
                          : const Text('SIGN UP'),
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
              text: 'Already have an account? ',
              style: context.textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: 'Sign In',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: context.theme.primaryColor,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      context.go(LoginPage.path);
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
