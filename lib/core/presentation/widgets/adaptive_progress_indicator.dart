import 'package:flutter/material.dart';
import 'package:itube/core/extensions/context_extensions.dart';

class AdaptiveProgressIndicator extends StatelessWidget {
  const AdaptiveProgressIndicator({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator.adaptive(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation(color ?? context.theme.primaryColor),
      ),
    );
  }
}
