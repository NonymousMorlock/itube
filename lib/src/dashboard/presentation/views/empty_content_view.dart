import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:itube/core/extensions/context_extensions.dart';

class EmptyContentView extends StatelessWidget {
  const EmptyContentView({
    this.title = 'No videos found',
    this.subtitle =
        'It looks a bit empty here. Check back later or start creating.',
    this.icon = Icons.videocam_off_outlined,
    this.onAction,
    this.actionLabel,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Icon(
                  icon,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
              ),
              const Gap(24),

              Text(
                title,
                textAlign: TextAlign.center,
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
              const Gap(8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),

              if (onAction != null && actionLabel != null) ...[
                const Gap(32),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onAction,
                    icon: const Icon(Icons.add_rounded, size: 20),
                    label: Text(actionLabel!),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
