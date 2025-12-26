import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:itube/core/extensions/context_extensions.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({
    required this.title,
    required this.subtitle,
    required this.form,
    required this.bottomAction,
    super.key,
  });

  final String title;
  final String subtitle;
  final Widget form;
  final Widget bottomAction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // --- Header Section ---
                    Icon(
                      Icons.play_circle_filled_rounded,
                      size: 64,
                      color: context.theme.primaryColor,
                    ),
                    const Gap(24),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: context.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.theme.colorScheme.onSurface,
                      ),
                    ),
                    const Gap(8),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: context.theme.colorScheme.onSurface.withValues(
                          alpha: .7,
                        ),
                      ),
                    ),
                    const Gap(48),

                    // --- Form Section ---
                    form,

                    const Gap(24),

                    // --- Bottom Action (Switch Auth Mode) ---
                    const Divider(),
                    const Gap(16),
                    bottomAction,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
