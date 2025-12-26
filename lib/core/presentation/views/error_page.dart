import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:itube/app/routing/route_constants.dart';
import 'package:itube/app/utils/app_utils.dart';
import 'package:itube/core/extensions/context_extensions.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({
    required this.title,
    required this.message,
    this.canGoBack = true,
    this.canRefresh = true,
    super.key,
  });

  final String title;
  final String message;
  final bool canGoBack;
  final bool canRefresh;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 80,
                      color: context.theme.colorScheme.error,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: context.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: context.textTheme.bodyLarge?.color?.withValues(
                          alpha: .8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Action Buttons
                    _buildActionButtons(context, sizingInformation.isMobile),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isMobile) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: [
        if (canGoBack)
          FilledButton.tonalIcon(
            onPressed: () => _handleBack(context),
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Go Back'),
          ),
        if (canRefresh)
          FilledButton.icon(
            onPressed: () => AppUtils.handleRefresh(context: context),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Refresh'),
          ),
      ],
    );
  }

  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(RouteConstants.initialRoute);
    }
  }
}
