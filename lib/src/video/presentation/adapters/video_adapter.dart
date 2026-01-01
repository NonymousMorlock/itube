import 'package:bloc/bloc.dart';
import 'package:cross_file/cross_file.dart';
import 'package:equatable/equatable.dart';
import 'package:itube/core/errors/failures.dart';
import 'package:itube/src/video/domain/entities/video.dart';
import 'package:itube/src/video/domain/usecases/get_all_videos.dart';
import 'package:itube/src/video/domain/usecases/get_video_by_id.dart';
import 'package:itube/src/video/domain/usecases/upload_video.dart';

part 'video_state.dart';

class VideoAdapter extends Cubit<VideoState> {
  VideoAdapter({
    required GetAllVideos getAllVideos,
    required GetVideoById getVideoById,
    required UploadVideo uploadVideo,
  }) : _getAllVideos = getAllVideos,
       _getVideoById = getVideoById,
       _uploadVideo = uploadVideo,
       super(const VideoInitial());

  final GetAllVideos _getAllVideos;

  final GetVideoById _getVideoById;

  final UploadVideo _uploadVideo;

  Future<void> getAllVideos() async {
    emit(const VideoLoading());
    final result = await _getAllVideos();
    result.fold(
      (failure) => emit(VideoError.fromFailure(failure)),
      (videos) => emit(AllVideosLoaded(videos: videos)),
    );
  }

  Future<void> getVideoById({required String id}) async {
    emit(const VideoLoading());
    final result = await _getVideoById(id);
    result.fold(
      (failure) => emit(VideoError.fromFailure(failure)),
      (video) => emit(VideoLoaded(video: video)),
    );
  }

  Future<void> uploadVideo({
    required XFile videoFile,
    required XFile thumbnailFile,
    required String title,
    required String? description,
    required String visibility,
  }) async {
    emit(const VideoLoading());

    final result = await _uploadVideo(
      UploadVideoParams(
        videoFile: videoFile,
        thumbnailFile: thumbnailFile,
        title: title,
        description: description,
        visibility: visibility,
      ),
    );

    result.fold(
      (failure) => emit(VideoError.fromFailure(failure)),
      (video) => emit(VideoUploaded(video: video)),
    );
  }

  @override
  void emit(VideoState state) {
    if (isClosed) return;
    super.emit(state);
  }
}
