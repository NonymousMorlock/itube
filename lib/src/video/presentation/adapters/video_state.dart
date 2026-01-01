part of 'video_adapter.dart';

sealed class VideoState extends Equatable {
  const VideoState();

  @override
  List<Object?> get props => [];
}

final class VideoInitial extends VideoState {
  const VideoInitial();
}

final class VideoLoading extends VideoState {
  const VideoLoading();
}

final class AllVideosLoaded extends VideoState {
  const AllVideosLoaded({required this.videos});

  final List<Video> videos;

  @override
  List<Object?> get props => videos;
}

final class VideoLoaded extends VideoState {
  const VideoLoaded({required this.video});

  final Video video;

  @override
  List<Object?> get props => [video];
}

final class VideoUploaded extends VideoState {
  const VideoUploaded({required this.video});

  final Video video;

  @override
  List<Object?> get props => [video];
}

final class VideoError extends VideoState {
  const VideoError({required this.message, required this.title});

  VideoError.fromFailure(Failure failure)
    : this(message: failure.message, title: 'Error ${failure.statusCode}');

  final String message;

  final String? title;

  @override
  List<Object?> get props => [message, title];
}
