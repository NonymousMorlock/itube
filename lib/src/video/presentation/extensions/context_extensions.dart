import 'package:flutter/material.dart';
import 'package:itube/src/video/presentation/state/video_upload_state_controller.dart';
import 'package:provider/provider.dart';

extension ContextExtensions on BuildContext {
  VideoUploadStateController get uploadController =>
      read<VideoUploadStateController>();
}
