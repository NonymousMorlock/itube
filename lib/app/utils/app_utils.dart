import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:itube/app/di/injection_container.dart';
import 'package:itube/core/extensions/context_extensions.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:universal_html/html.dart' as html;

enum SnackBarType {
  error(color: Colors.red, icon: Icons.error),
  warning(color: Colors.orange, icon: Icons.warning),
  success(color: Colors.green, icon: Icons.check_circle),
  info(color: Colors.blue, icon: Icons.info)
  ;

  const SnackBarType({required this.color, required this.icon});

  final Color color;
  final IconData icon;
}

sealed class AppUtils {
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
          sl<FToast>().removeCustomToast();
        },
        color: Colors.white,
        icon: const Icon(Icons.close),
        padding: EdgeInsets.zero,
      );
      final toast = Container(
        constraints: BoxConstraints(
          maxWidth: switch (getDeviceType(context.screenSize)) {
            DeviceScreenType.mobile => 300,
            DeviceScreenType.tablet => 400,
            DeviceScreenType.desktop => 500,
            DeviceScreenType.watch => 300,
            _ => 300,
          },
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: type.color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
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
      );
      sl<FToast>()
        ..removeCustomToast()
        ..showToast(
          child: toast,
          toastDuration: const Duration(seconds: 5),
          gravity: ToastGravity.BOTTOM_RIGHT,
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
    String title = 'Success',
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

  static void handleRefresh({
    required BuildContext context,
  }) {
    if (kIsWeb || kIsWasm) {
      html.window.location.reload();
    } else {
      context.go(
        GoRouterState.of(context).matchedLocation,
        extra: DateTime.now().millisecondsSinceEpoch,
      );
    }
  }
}
