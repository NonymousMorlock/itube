import 'package:image_picker/image_picker.dart';

sealed class MediaPickerUtils {
  static final ImagePicker _picker = ImagePicker();

  /// Picks a video from the gallery or file system.
  static Future<XFile?> pickVideo() async {
    try {
      final video = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 60),
      );
      return video;
    } on Exception catch (_) {
      return null;
    }
  }

  /// Picks an image for the thumbnail.
  static Future<XFile?> pickImage() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        // Optimise for web
        maxWidth: 1920,
      );
      return image;
    } on Exception catch (_) {
      return null;
    }
  }
}
