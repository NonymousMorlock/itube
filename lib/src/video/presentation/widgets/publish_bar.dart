import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itube/app/utils/app_utils.dart';
import 'package:itube/core/presentation/widgets/adaptive_progress_indicator.dart';
import 'package:itube/src/video/presentation/adapters/video_adapter.dart';
import 'package:itube/src/video/presentation/extensions/context_extensions.dart';

class PublishBar extends StatelessWidget {
  const PublishBar({required this.isDesktop, super.key});

  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final button = FilledButton(
      onPressed: () {
        final uploadController = context.uploadController;

        if (uploadController.thumbnailFileNotifier.value == null) {
          unawaited(uploadController.shakeController.forward());
          AppUtils.showErrorToast(
            context,
            message: 'Please upload a thumbnail',
          );
          return;
        }

        // There's no need to check video file since the publish view
        // containing the publish button doesn't even show up without a video
        // uploaded

        if (uploadController.titleController.text.trim().isEmpty) {
          AppUtils.showErrorToast(context, message: 'Please add a title');
          return;
        }

        AppUtils.showToast(
          context,
          message: 'Starting Upload...',
        );

        unawaited(
          context.read<VideoAdapter>().uploadVideo(
            videoFile: uploadController.videoFileNotifier.value!,
            thumbnailFile: uploadController.thumbnailFileNotifier.value!,
            title: uploadController.titleController.text.trim(),
            visibility: uploadController.visibilityNotifier.value.value,
            description: uploadController.descriptionController.text.trim(),
          ),
        );
      },
      child: const Text('PUBLISH'),
    );

    return BlocBuilder<VideoAdapter, VideoState>(
      builder: (_, state) {
        if (state is VideoLoading) {
          return const AdaptiveProgressIndicator();
        }

        return Align(
          alignment: isDesktop ? .bottomRight : .center,
          child: isDesktop
              ? ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 200),
                  child: button,
                )
              : button,
        );
      },
    );
  }
}
