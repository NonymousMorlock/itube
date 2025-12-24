import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:itube/core/extensions/context_extensions.dart';

enum SnackBarType {
  error(color: Colors.red, icon: Icons.error),
  success(color: Colors.green, icon: Icons.check_circle),
  info(color: Colors.blue, icon: Icons.info)
  ;

  const SnackBarType({required this.color, required this.icon});

  final Color color;
  final IconData icon;
}

sealed class CoreUtils {
  static void showToast(
    BuildContext context, {
    required String message,
    String? title,
    SnackBarType type = SnackBarType.info,
  }) {
    postFrameCallback(() {
      final icon = Icon(type.icon, color: Colors.white, size: 24);
      final closeButton = IconButton(
        onPressed: () {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
        color: Colors.white,
        icon: const Icon(Icons.close),
        padding: EdgeInsets.zero,
      );
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            backgroundColor: type.color,
            content: Column(
              spacing: 8,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null)
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          spacing: 8,
                          children: [
                            icon,
                            Flexible(
                              child: Text(
                                title,
                                style: context.textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      closeButton,
                    ],
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        spacing: 8,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (title == null) icon,
                          Flexible(
                            child: Text(
                              message,
                              softWrap: true,
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (title == null) closeButton,
                  ],
                ),
              ],
            ),
            duration: const Duration(seconds: 5),
          ),
        );
    });
  }

  static void showErrorToast(
    BuildContext context, {
    required String message,
    String? title,
  }) {
    showToast(
      context,
      message: message,
      title: title,
      type: SnackBarType.error,
    );
  }

  static void showSuccessToast(
    BuildContext context, {
    required String message,
    String? title,
  }) {
    showToast(
      context,
      message: message,
      title: title,
      type: SnackBarType.success,
    );
  }

  static void postFrameCallback(VoidCallback? callback) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      callback?.call();
    });
  }
}
