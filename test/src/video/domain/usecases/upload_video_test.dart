import 'package:cross_file/cross_file.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itube/core/errors/failures.dart';
import 'package:itube/src/video/domain/entities/video.dart';
import 'package:itube/src/video/domain/repositories/video_repository.dart';
import 'package:itube/src/video/domain/usecases/upload_video.dart';
import 'package:mocktail/mocktail.dart';

import 'video_repo.mock.dart';

void main() {
  late VideoRepo repo;
  late UploadVideo usecase;

  const tPresignedVideoResponse = (url: 'Test Video Url', id: 'Test Video id');
  const tPresignedThumbnailResponse = (
    url: 'Test Thumbnail Url',
    id: 'Test Thumbnail id',
  );

  final tParams = UploadVideoParams.empty();

  final tResult = Video.empty();

  setUp(() {
    repo = MockVideoRepo();
    usecase = UploadVideo(repo);
    registerFallbackValue(XFile('Test String'));
  });

  test(
    'should call '
    '[VideoRepo.getPresignedVideoUrl], '
    '[VideoRepo.getPresignedThumbnailUrl], '
    '[VideoRepo.uploadVideoToS3], '
    '[VideoRepo.uploadThumbnailToS3], '
    '[VideoRepo.uploadVideoMetadata]',
    () async {
      when(
        () => repo.getPresignedVideoUrl(),
      ).thenAnswer((_) async => const Right(tPresignedVideoResponse));

      when(
        () => repo.getPresignedThumbnailUrl(
          associatedVideoId: any<String>(named: 'associatedVideoId'),
        ),
      ).thenAnswer((_) async => const Right(tPresignedThumbnailResponse));

      when(
        () => repo.uploadVideoToS3(
          presignedUrl: any<String>(named: 'presignedUrl'),
          videoFile: any<XFile>(named: 'videoFile'),
        ),
      ).thenAnswer((_) async => const Right(null));

      when(
        () => repo.uploadThumbnailToS3(
          presignedUrl: any<String>(named: 'presignedUrl'),
          thumbnailFile: any<XFile>(named: 'thumbnailFile'),
        ),
      ).thenAnswer((_) async => const Right(null));

      when(
        () => repo.uploadVideoMetadata(
          title: any<String>(named: 'title'),
          s3Key: any<String>(named: 's3Key'),
          visibility: any<String>(named: 'visibility'),
        ),
      ).thenAnswer((_) async => Right(tResult));

      final result = await usecase(tParams);
      expect(result, equals(Right<Failure, Video>(tResult)));

      verify(() => repo.getPresignedVideoUrl()).called(1);
      verify(
        () => repo.getPresignedThumbnailUrl(
          associatedVideoId: tPresignedVideoResponse.id,
        ),
      ).called(1);
      verify(
        () => repo.uploadVideoToS3(
          presignedUrl: tPresignedVideoResponse.url,
          videoFile: tParams.videoFile,
        ),
      ).called(1);

      verify(
        () => repo.uploadThumbnailToS3(
          presignedUrl: tPresignedThumbnailResponse.url,
          thumbnailFile: tParams.thumbnailFile,
        ),
      ).called(1);

      verify(
        () => repo.uploadVideoMetadata(
          title: tParams.title,
          s3Key: tPresignedVideoResponse.id,
          visibility: tParams.visibility,
        ),
      ).called(1);

      verifyNoMoreInteractions(repo);
    },
  );
}
