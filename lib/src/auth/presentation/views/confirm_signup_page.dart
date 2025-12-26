import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:itube/app/utils/app_utils.dart';
import 'package:itube/core/extensions/context_extensions.dart';
import 'package:itube/core/presentation/views/error_page.dart';
import 'package:itube/core/presentation/widgets/adaptive_progress_indicator.dart';
import 'package:itube/core/presentation/widgets/auth_layout.dart';
import 'package:itube/src/auth/auth.dart';
import 'package:itube/src/auth/presentation/adapters/auth_adapter.dart';

class ConfirmSignupPage extends StatefulWidget {
  const ConfirmSignupPage({required this.email, super.key});

  static const path = '/confirm-signup';

  final String? email;

  @override
  State<ConfirmSignupPage> createState() => _ConfirmSignupPageState();
}

class _ConfirmSignupPageState extends State<ConfirmSignupPage> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _email;

  @override
  void initState() {
    if (widget.email != null) _email = widget.email;
    super.initState();
    if (widget.email == null) {
      unawaited(context.read<AuthAdapter>().getPendingRegistrationEmail());
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _submit() {
    unawaited(
      context.read<AuthAdapter>().verifyEmail(
        email: _email!,
        otp: _codeController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthAdapter, AuthState>(
      listener: (_, state) {
        if (state case PendingRegistrationEmailLoaded(:final email)) {
          _email = email;
        } else if (state case AuthError(
          :final message,
          :final title,
        ) when state is! PendingRegistrationEmailError) {
          AppUtils.showErrorToast(context, message: message, title: title);
        } else if (state is EmailVerified) {
          context.go(LoginPage.path);
          AppUtils.showSuccessToast(
            context,
            message: 'Email verified. Log in.',
          );
        }
      },
      buildWhen: (_, state) {
        return state is PendingRegistrationEmailLoaded ||
            state is FetchingPendingRegistrationEmail ||
            state is PendingRegistrationEmailError;
      },
      builder: (_, state) {
        if (state is FetchingPendingRegistrationEmail) {
          return const Scaffold(
            body: Center(child: AdaptiveProgressIndicator()),
          );
        } else if (_email == null) {
          return const ErrorPage(
            title: 'Session Expired',
            message:
                'We could not verify your session details. '
                'For security, please try the sign-up process again.',
            canRefresh: false,
          );
        }
        return AuthLayout(
          title: 'Check your email',
          // Dynamic subtitle showing where we sent the code
          subtitle: 'We sent a confirmation code to\n$_email',
          form: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    letterSpacing: 8,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Confirmation Code',
                    hintText: '123456',
                    prefixIcon: Icon(Icons.key_outlined),
                    // Note: No 'border: OutlineInputBorder()' here!
                    // It inherits the Theme from app.dart perfectly.
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Code is required';
                    }
                    if (value.length < 6) return 'Invalid code length';
                    return null;
                  },
                ),
                const Gap(32),
                BlocBuilder<AuthAdapter, AuthState>(
                  builder: (_, state) {
                    final isLoading = state is AuthLoading;

                    return SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: isLoading ? null : _submit,
                        child: isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: AdaptiveProgressIndicator(
                                  color: context.theme.colorScheme.onPrimary,
                                ),
                              )
                            : const Text('VERIFY EMAIL'),
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
                text: "Didn't receive code? ",
                style: context.textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: 'Resend',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: context.theme.primaryColor,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Trigger Resend Logic
                      },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
