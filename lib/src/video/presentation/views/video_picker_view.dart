import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:itube/app/utils/app_utils.dart';
import 'package:itube/core/extensions/context_extensions.dart';
import 'package:itube/src/video/presentation/extensions/context_extensions.dart';
import 'package:itube/src/video/presentation/state/video_upload_state_controller.dart';
import 'package:itube/src/video/presentation/widgets/dashed_border.dart';
import 'package:provider/provider.dart';

class VideoPickerView extends StatelessWidget {
  const VideoPickerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoUploadStateController>(
      builder: (_, controller, _) {
        final isDragging = controller.isDragging;

        final color = isDragging
            ? context.theme.colorScheme.primary
            : Colors.grey.shade400;

        final bgColor = isDragging
            ? context.theme.colorScheme.primary.withValues(alpha: 0.05)
            : Colors.grey.shade50;

        final isDesktop =
            context.platform == TargetPlatform.windows ||
            context.platform == TargetPlatform.macOS ||
            context.platform == TargetPlatform.linux;
        return Center(
          key: const ValueKey('dropzone'),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600, maxHeight: 400),
              child: DropTarget(
                onDragDone: (details) async {
                  final error = await context.uploadController.onDragDone(
                    details,
                  );
                  if (error != null) {
                    if (!context.mounted) return;
                    AppUtils.showErrorToast(context, message: error);
                  }
                },
                onDragEntered: controller.onDragEntered,
                onDragExited: controller.onDragExited,
                child: DashedBorder(
                  onTap: controller.pickVideo,
                  color: color,
                  strokeWidth: isDragging ? 3 : 2,
                  gap: 12,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: const EdgeInsets.all(24),
                    color: bgColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedScale(
                          scale: isDragging ? 1.1 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: isDragging
                                  ? context.theme.colorScheme.primary
                                        .withValues(alpha: 0.1)
                                  : Colors.black.withValues(alpha: 0.05),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.upload_file_rounded,
                              size: 64,
                              color: isDragging
                                  ? context.theme.colorScheme.primary
                                  : Colors.black,
                            ),
                          ),
                        ),
                        const Gap(24),
                        Text(
                          isDragging
                              ? 'Drop video to upload'
                              : isDesktop
                              ? 'Drag and drop video files to upload'
                              : 'Tap to upload video files',
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDragging
                                ? context.theme.colorScheme.primary
                                : null,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Gap(8),
                        Text(
                          'Your videos will be private until you publish them.',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Gap(32),
                        FilledButton.icon(
                          onPressed: controller.pickVideo,
                          icon: const Icon(Icons.video_library_outlined),
                          label: const Text('SELECT FILES'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
