import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:itube/core/enums/visibility_status.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.videoVisibility, super.key});

  final VisibilityStatus videoVisibility;

  @override
  Widget build(BuildContext context) {
    if (videoVisibility == VisibilityStatus.private) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey.shade600),
        ),
        child: const Row(
          children: [
            Icon(Icons.lock_outline, size: 14, color: Colors.white70),
            Gap(4),
            Text(
              'Private',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
