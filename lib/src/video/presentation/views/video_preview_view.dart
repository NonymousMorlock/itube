import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:itube/core/extensions/context_extensions.dart';
import 'package:itube/src/video/presentation/extensions/context_extensions.dart';
import 'package:itube/src/video/presentation/state/video_upload_state_controller.dart';
import 'package:provider/provider.dart';

class VideoPreviewView extends StatelessWidget {
  const VideoPreviewView({required this.isMobile, super.key});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Video Player Placeholder
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(
              // Gradient for a sleeker "Waiting" look
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey.shade900,
                  Colors.grey.shade800,
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              alignment: .center,
              children: [
                const Icon(
                  Icons.play_circle_fill,
                  color: Colors.white,
                  size: 64,
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Consumer<VideoUploadStateController>(
                      builder: (_, controller, child) {
                        const style = TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        );
                        if (controller.videoFileNotifier.value != null) {
                          return Text(
                            controller.titleController.text.trim(),
                            style: style,
                          );
                        }
                        return ValueListenableBuilder(
                          valueListenable: controller.titleController,
                          builder: (_, value, _) {
                            return Text(
                              value.text.trim(),
                              style: style,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: IconButton(
                    onPressed: context.uploadController.pickVideo,
                    tooltip: 'Replace Video',
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withValues(alpha: 0.5),
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.swap_horiz_rounded),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Gap(24),

        // Thumbnail Section
        Text(
          'Thumbnail',
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: .bold,
          ),
        ),
        const Gap(12),
        Text(
          "Select or upload a picture that shows what's in your video.",
          style: context.textTheme.bodySmall?.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
        const Gap(16),

        AnimatedBuilder(
          animation: context.uploadController.shakeAnimation,
          builder: (context, child) {
            final shakeController = context.uploadController.shakeController;
            return Transform.translate(
              offset: Offset(
                3.0 *
                    (1 - shakeController.value) *
                    (shakeController.isAnimating
                        ? (2 *
                              (0.5 - (0.5 - shakeController.value).abs()).sign *
                              3)
                        : 0),
                0,
              ),
              child: child,
            );
          },
          child: Row(
            children: [
              // Slot 1: Custom Upload
              ValueListenableBuilder(
                valueListenable: context.uploadController.thumbnailFileNotifier,
                builder: (_, thumbnailFile, _) {
                  final controller = context.uploadController;
                  final thumbnailBytes =
                      controller.thumbnailBytesNotifier.value;
                  final shakeController = controller.shakeController;
                  return GestureDetector(
                    onTap: context.uploadController.pickThumbnail,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 160,
                      height: 90,
                      decoration: BoxDecoration(
                        color: thumbnailFile != null
                            ? Colors.transparent
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: shakeController.isAnimating
                              ? context.theme.colorScheme.error
                              : (thumbnailFile != null
                                    ? Colors.black
                                    : Colors.grey.shade300),
                          width:
                              thumbnailFile != null ||
                                  shakeController.isAnimating
                              ? 2
                              : 1,
                        ),
                        image: thumbnailBytes != null
                            ? DecorationImage(
                                image: MemoryImage(thumbnailBytes),
                                fit: .cover,
                              )
                            : null,
                      ),
                      child: thumbnailFile == null
                          ? Column(
                              mainAxisAlignment: .center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 24,
                                  color: shakeController.isAnimating
                                      ? context.theme.colorScheme.error
                                      : null,
                                ),
                                const Gap(4),
                                Text(
                                  'Upload file',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: shakeController.isAnimating
                                        ? context.theme.colorScheme.error
                                        : null,
                                  ),
                                ),
                              ],
                            )
                          : Stack(
                              children: [
                                Positioned.fill(
                                  child: Container(
                                    color: Colors.black.withValues(alpha: 0.1),
                                  ),
                                ),
                                const Center(
                                  child: Icon(Icons.edit, color: Colors.white),
                                ),
                              ],
                            ),
                    ),
                  );
                },
              ),

              const Gap(16),

              // Slot 2: Auto-gen placeholder
              Container(
                width: 160,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'Auto-gen\n(Coming Soon)',
                    textAlign: .center,
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
