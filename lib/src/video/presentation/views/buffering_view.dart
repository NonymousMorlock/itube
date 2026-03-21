import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:itube/core/extensions/context_extensions.dart';

class BufferingView extends StatelessWidget {
  const BufferingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('analyzing'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 60,
            width: 60,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              color: context.theme.colorScheme.primary,
              backgroundColor: Colors.grey.shade200,
            ),
          ),
          const Gap(24),
          Text(
            'Analyzing media...',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: .bold,
            ),
          ),
          const Gap(8),
          Text(
            'Checking video format and metadata',
            style: context.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
