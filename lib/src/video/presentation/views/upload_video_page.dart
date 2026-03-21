import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:itube/app/utils/app_utils.dart';
import 'package:itube/src/video/presentation/adapters/video_adapter.dart';
import 'package:itube/src/video/presentation/extensions/context_extensions.dart';
import 'package:itube/src/video/presentation/state/video_upload_state_controller.dart';
import 'package:itube/src/video/presentation/views/buffering_view.dart';
import 'package:itube/src/video/presentation/views/studio_layout_view.dart';
import 'package:itube/src/video/presentation/views/video_picker_view.dart';
import 'package:provider/provider.dart';

class UploadVideoPage extends StatefulWidget {
  const UploadVideoPage({super.key});

  static const path = '/upload';

  @override
  State<UploadVideoPage> createState() => _UploadVideoPageState();
}

class _UploadVideoPageState extends State<UploadVideoPage>
    with TickerProviderStateMixin {
  late final AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    context.uploadController.init(
      shakeController: _shakeController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VideoAdapter, VideoState>(
      listener: (context, state) {
        if (state case VideoError(:final message, :final title)) {
          AppUtils.showErrorToast(context, message: message, title: title);
        } else if (state is VideoUploaded) {
          AppUtils.showToast(context, message: 'Video uploaded successfully!');
          context.uploadController.removeVideo();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Studio'),
          centerTitle: false,
          actions: [
            if (context.uploadController.videoFileNotifier.value != null)
              TextButton.icon(
                onPressed: context.uploadController.removeVideo,
                icon: const Icon(Icons.delete_outline, size: 20),
                label: const Text('Cancel'),
                style: TextButton.styleFrom(foregroundColor: Colors.grey),
              ),
            const Gap(16),
          ],
        ),

        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: Consumer<VideoUploadStateController>(
            builder: (_, controller, _) {
              if (controller.isAnalyzing) {
                return const BufferingView();
              } else if (controller.videoFileNotifier.value == null) {
                return const VideoPickerView();
              } else {
                return const StudioLayoutView();
              }
            },
          ),
        ),
      ),
    );
  }
}
