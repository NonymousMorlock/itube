import 'package:cross_file/cross_file.dart';
import 'package:itube/core/typedefs.dart';
import 'package:itube/src/video/domain/entities/video.dart';
import 'package:itube/src/video/typedefs.dart';

abstract interface class VideoRepo {
  const VideoRepo();

  ResultFuture<List<Video>> getAllVideos();

  ResultFuture<MediaResponse> getPresignedThumbnailUrl({
    required String associatedVideoId,
  });

  ResultFuture<MediaResponse> getPresignedVideoUrl();

  ResultFuture<Video> getVideoById({required String id});

  ResultFuture<void> uploadThumbnailToS3({
    required String presignedUrl,
    required XFile thumbnailFile,
  });

  ResultFuture<Video> uploadVideoMetadata({
    required String title,
    required String s3Key,
    required String visibility,
    String? description,
  });

  ResultFuture<void> uploadVideoToS3({
    required String presignedUrl,
    required XFile videoFile,
  });
}
