import 'package:cross_file/cross_file.dart';
import 'package:equatable/equatable.dart';
import 'package:itube/core/extensions/result_future_extensions.dart';
import 'package:itube/core/typedefs.dart';
import 'package:itube/core/usecases/usecase.dart';
import 'package:itube/src/video/domain/entities/video.dart';
import 'package:itube/src/video/domain/repositories/video_repository.dart';

class UploadVideo implements UsecaseWithParams<Video, UploadVideoParams> {
  const UploadVideo(this._repo);

  final VideoRepo _repo;

  @override
  ResultFuture<Video> call(UploadVideoParams params) async {
    return _repo.getPresignedVideoUrl().thenRight((videoMediaResponse) {
      return _repo
          .getPresignedThumbnailUrl(associatedVideoId: videoMediaResponse.id)
          .thenRight((thumbnailMediaResponse) {
            return _repo
                .uploadVideoToS3(
                  presignedUrl: videoMediaResponse.url,
                  videoFile: params.videoFile,
                )
                .thenRight((_) {
                  return _repo
                      .uploadThumbnailToS3(
                        presignedUrl: thumbnailMediaResponse.url,
                        thumbnailFile: params.thumbnailFile,
                      )
                      .thenRight((_) {
                        return _repo.uploadVideoMetadata(
                          title: params.title,
                          s3Key: videoMediaResponse.id,
                          visibility: params.visibility,
                          description: params.description,
                        );
                      });
                });
          });
    });
  }
}

class UploadVideoParams extends Equatable {
  const UploadVideoParams({
    required this.videoFile,
    required this.thumbnailFile,
    required this.title,
    required this.visibility,
    this.description,
  });

  UploadVideoParams.empty()
    : this(
        videoFile: XFile('Test String'),
        thumbnailFile: XFile('Test String'),
        title: 'Test String',
        description: null,
        visibility: 'Test String',
      );

  final XFile videoFile;
  final XFile thumbnailFile;
  final String title;
  final String? description;
  final String visibility;

  @override
  List<Object?> get props => [
    videoFile,
    thumbnailFile,
    title,
    visibility,
    description,
  ];
}
