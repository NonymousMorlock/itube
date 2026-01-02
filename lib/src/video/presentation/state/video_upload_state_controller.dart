import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:itube/core/enums/visibility_status.dart';
import 'package:itube/src/video/presentation/utils/media_picker_utils.dart';

class VideoUploadStateController extends ChangeNotifier {
  final ValueNotifier<XFile?> videoFileNotifier = ValueNotifier(null);
  final ValueNotifier<XFile?> thumbnailFileNotifier = ValueNotifier(null);
  final ValueNotifier<Uint8List?> thumbnailBytesNotifier = ValueNotifier(null);
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  ValueNotifier<VisibilityStatus> visibilityNotifier = ValueNotifier(
    VisibilityStatus.public,
  );

  TextEditingController get titleController => _titleController;

  TextEditingController get descriptionController => _descriptionController;

  bool _isDragging = false;

  bool get isDragging => _isDragging;

  // The "Spice": Simulated processing state
  bool _isAnalyzing = false;

  bool get isAnalyzing => _isAnalyzing;

  // Animation Controllers
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  AnimationController get shakeController => _shakeController;

  Animation<double> get shakeAnimation => _shakeAnimation;

  void init({
    required AnimationController shakeController,
  }) {
    _shakeController = shakeController;
    // Create a sine wave shake effect (translation on X axis)
    _shakeAnimation = Tween<double>(
      begin: 0,
      end: 10,
    ).chain(CurveTween(curve: Curves.elasticIn)).animate(_shakeController);

    _shakeController.addStatusListener(shakeControllerStatusListener);
  }

  void shakeControllerStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _shakeController.reset();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _shakeController
      ..removeStatusListener(shakeControllerStatusListener)
      ..dispose();
    super.dispose();
  }

  Future<void> pickVideo() async {
    final video = await MediaPickerUtils.pickVideo();
    if (video != null) {
      await _processSelectedVideo(video);
    }
  }

  /// Simulates "Scanning" the file to make the app feel smarter
  Future<void> _processSelectedVideo(XFile video) async {
    _isAnalyzing = true;
    notifyListeners();

    // Simulate reading metadata / probing file
    await Future<void>.delayed(const Duration(milliseconds: 1500));

    _isAnalyzing = false;
    videoFileNotifier.value = video;
    // Auto-fill title from filename if empty
    if (_titleController.text.isEmpty) {
      final name = video.name.split('.').first;
      _titleController.text = name.replaceAll(RegExp('[-_]'), ' ');
    }
    notifyListeners();
  }

  Future<void> pickThumbnail() async {
    final image = await MediaPickerUtils.pickImage();
    if (image != null) {
      final bytes = await image.readAsBytes();
      thumbnailFileNotifier.value = image;
      thumbnailBytesNotifier.value = bytes;
    }
  }

  void removeVideo() {
    videoFileNotifier.value = null;
    thumbnailFileNotifier.value = null;
    thumbnailBytesNotifier.value = null;
    _titleController.clear();
    _descriptionController.clear();
    visibilityNotifier.value = VisibilityStatus.public;
    _isDragging = false;
    _isAnalyzing = false;
    notifyListeners();
  }

  // --- DRAG AND DROP LOGIC ---

  Future<String?> onDragDone(DropDoneDetails details) async {
    _isDragging = false;
    notifyListeners();

    if (details.files.isEmpty) return null;

    final file = details.files.first;
    final ext = file.name.split('.').last.toLowerCase();

    const validExtensions = ['mp4', 'mov', 'avi', 'mkv', 'webm'];

    if (validExtensions.contains(ext)) {
      await _processSelectedVideo(file);
    } else {
      return 'Invalid file type. Please upload a video.';
    }
    return null;
  }

  void onDragEntered(DropEventDetails details) {
    _isDragging = true;
    notifyListeners();
  }

  void onDragExited(DropEventDetails details) {
    _isDragging = false;
    notifyListeners();
  }
}
