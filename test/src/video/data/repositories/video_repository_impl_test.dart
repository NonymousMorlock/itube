import 'package:cross_file/cross_file.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itube/core/errors/exceptions.dart';
import 'package:itube/core/errors/failures.dart';
import 'package:itube/src/video/data/datasources/video_remote_data_source.dart';
import 'package:itube/src/video/data/models/video_model.dart';
import 'package:itube/src/video/data/repositories/video_repository_impl.dart';
import 'package:itube/src/video/domain/entities/video.dart';
import 'package:itube/src/video/typedefs.dart';
import 'package:mocktail/mocktail.dart';

class MockVideoRemoteDataSource extends Mock implements VideoRemoteDataSource {}

void main() {
  late VideoRemoteDataSource remoteDataSource;
  late VideoRepoImpl repoImpl;

  setUp(() {
    remoteDataSource = MockVideoRemoteDataSource();
    repoImpl = VideoRepoImpl(remoteDataSource);
  });

  const serverFailure = ServerFailure(
    message: 'Something went wrong',
    statusCode: 500,
  );

  group('getAllVideos', () {
    const tResult = <VideoModel>[];

    test(
      'should return [Right<List<Video>>] when  '
      'call to remote source is successful',
      () async {
        when(
          () => remoteDataSource.getAllVideos(),
        ).thenAnswer((_) async => tResult);

        final result = await repoImpl.getAllVideos();

        expect(result, equals(const Right<Failure, List<Video>>(tResult)));

        verify(() => remoteDataSource.getAllVideos()).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should return [Left<Failure>] when call  '
      'to remote source is unsuccessful',
      () async {
        when(() => remoteDataSource.getAllVideos()).thenThrow(
          ServerException(
            message: serverFailure.message,
            statusCode: serverFailure.statusCode,
          ),
        );

        final result = await repoImpl.getAllVideos();

        expect(result, equals(const Left<Failure, List<Video>>(serverFailure)));

        verify(() => remoteDataSource.getAllVideos()).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group('getPresignedThumbnailUrl', () {
    const tResult = (url: 'Test String', id: 'Test String');
    const tAssociatedVideoId = 'Test String';

    test(
      'should return [Right<MediaResponse>]  '
      'when call to remote source is  '
      'successful',
      () async {
        when(
          () => remoteDataSource.getPresignedThumbnailUrl(
            associatedVideoId: any<String>(named: 'associatedVideoId'),
          ),
        ).thenAnswer((_) async => tResult);

        final result = await repoImpl.getPresignedThumbnailUrl(
          associatedVideoId: tAssociatedVideoId,
        );

        expect(result, equals(const Right<Failure, MediaResponse>(tResult)));

        verify(
          () => remoteDataSource.getPresignedThumbnailUrl(
            associatedVideoId: tAssociatedVideoId,
          ),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should return [Left<Failure>] when call  '
      'to remote source is unsuccessful',
      () async {
        when(
          () => remoteDataSource.getPresignedThumbnailUrl(
            associatedVideoId: any<String>(named: 'associatedVideoId'),
          ),
        ).thenThrow(
          ServerException(
            message: serverFailure.message,
            statusCode: serverFailure.statusCode,
          ),
        );

        final result = await repoImpl.getPresignedThumbnailUrl(
          associatedVideoId: tAssociatedVideoId,
        );

        expect(
          result,
          equals(const Left<Failure, MediaResponse>(serverFailure)),
        );

        verify(
          () => remoteDataSource.getPresignedThumbnailUrl(
            associatedVideoId: tAssociatedVideoId,
          ),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group('getPresignedVideoUrl', () {
    const tResult = (url: 'Test String', id: 'Test String');

    test(
      'should return [Right<MediaResponse>]  '
      'when call to remote source is  '
      'successful',
      () async {
        when(
          () => remoteDataSource.getPresignedVideoUrl(),
        ).thenAnswer((_) async => tResult);

        final result = await repoImpl.getPresignedVideoUrl();

        expect(result, equals(const Right<Failure, MediaResponse>(tResult)));

        verify(() => remoteDataSource.getPresignedVideoUrl()).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should return [Left<Failure>] when call  '
      'to remote source is unsuccessful',
      () async {
        when(() => remoteDataSource.getPresignedVideoUrl()).thenThrow(
          ServerException(
            message: serverFailure.message,
            statusCode: serverFailure.statusCode,
          ),
        );

        final result = await repoImpl.getPresignedVideoUrl();

        expect(
          result,
          equals(const Left<Failure, MediaResponse>(serverFailure)),
        );

        verify(() => remoteDataSource.getPresignedVideoUrl()).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group('getVideoById', () {
    final tResult = VideoModel.empty();
    const tId = 'Test String';

    test(
      'should return [Right<Video>] when call  '
      'to remote source is successful',
      () async {
        when(
          () => remoteDataSource.getVideoById(id: any<String>(named: 'id')),
        ).thenAnswer((_) async => tResult);

        final result = await repoImpl.getVideoById(id: tId);

        expect(result, equals(Right<Failure, Video>(tResult)));

        verify(() => remoteDataSource.getVideoById(id: tId)).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should return [Left<Failure>] when call  '
      'to remote source is unsuccessful',
      () async {
        when(
          () => remoteDataSource.getVideoById(id: any<String>(named: 'id')),
        ).thenThrow(
          ServerException(
            message: serverFailure.message,
            statusCode: serverFailure.statusCode,
          ),
        );

        final result = await repoImpl.getVideoById(id: tId);

        expect(result, equals(const Left<Failure, Video>(serverFailure)));

        verify(() => remoteDataSource.getVideoById(id: tId)).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group('uploadThumbnailToS3', () {
    final tThumbnailFile = XFile('Test String');
    const tPresignedUrl = 'Test String';

    setUp(() => registerFallbackValue(tThumbnailFile));

    test(
      'should return [Right<void>] when call  '
      'to remote source is successful',
      () async {
        when(
          () => remoteDataSource.uploadThumbnailToS3(
            presignedUrl: any<String>(named: 'presignedUrl'),
            thumbnailFile: any<XFile>(named: 'thumbnailFile'),
          ),
        ).thenAnswer((_) async => Future.value());

        final result = await repoImpl.uploadThumbnailToS3(
          presignedUrl: tPresignedUrl,
          thumbnailFile: tThumbnailFile,
        );

        expect(result, equals(const Right<Failure, void>(null)));

        verify(
          () => remoteDataSource.uploadThumbnailToS3(
            presignedUrl: tPresignedUrl,
            thumbnailFile: tThumbnailFile,
          ),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should return [Left<Failure>] when call  '
      'to remote source is unsuccessful',
      () async {
        when(
          () => remoteDataSource.uploadThumbnailToS3(
            presignedUrl: any<String>(named: 'presignedUrl'),
            thumbnailFile: any<XFile>(named: 'thumbnailFile'),
          ),
        ).thenThrow(
          ServerException(
            message: serverFailure.message,
            statusCode: serverFailure.statusCode,
          ),
        );

        final result = await repoImpl.uploadThumbnailToS3(
          presignedUrl: tPresignedUrl,
          thumbnailFile: tThumbnailFile,
        );

        expect(result, equals(const Left<Failure, void>(serverFailure)));

        verify(
          () => remoteDataSource.uploadThumbnailToS3(
            presignedUrl: tPresignedUrl,
            thumbnailFile: tThumbnailFile,
          ),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group('uploadVideoMetadata', () {
    final tResult = VideoModel.empty();
    const tTitle = 'Test String';
    const tS3key = 'Test String';
    const tVisibility = 'Test String';
    const tDescription = 'Test String';

    test(
      'should return [Right<Video>] when call  '
      'to remote source is successful',
      () async {
        when(() {
          return remoteDataSource.uploadVideoMetadata(
            title: any<String>(named: 'title'),
            s3Key: any<String>(named: 's3Key'),
            visibility: any<String>(named: 'visibility'),
            description: any<String?>(named: 'description'),
          );
        }).thenAnswer((_) async => tResult);

        final result = await repoImpl.uploadVideoMetadata(
          title: tTitle,
          s3Key: tS3key,
          visibility: tVisibility,
          description: tDescription,
        );

        expect(result, equals(Right<Failure, Video>(tResult)));

        verify(
          () => remoteDataSource.uploadVideoMetadata(
            title: tTitle,
            s3Key: tS3key,
            visibility: tVisibility,
            description: tDescription,
          ),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should return [Left<Failure>] when call  '
      'to remote source is unsuccessful',
      () async {
        when(() {
          return remoteDataSource.uploadVideoMetadata(
            title: any<String>(named: 'title'),
            s3Key: any<String>(named: 's3Key'),
            visibility: any<String>(named: 'visibility'),
            description: any<String?>(named: 'description'),
          );
        }).thenThrow(
          ServerException(
            message: serverFailure.message,
            statusCode: serverFailure.statusCode,
          ),
        );

        final result = await repoImpl.uploadVideoMetadata(
          title: tTitle,
          s3Key: tS3key,
          visibility: tVisibility,
          description: tDescription,
        );

        expect(result, equals(const Left<Failure, Video>(serverFailure)));

        verify(
          () => remoteDataSource.uploadVideoMetadata(
            title: tTitle,
            s3Key: tS3key,
            visibility: tVisibility,
            description: tDescription,
          ),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group('uploadVideoToS3', () {
    final tVideoFile = XFile('Test String');
    const tPresignedUrl = 'Test String';

    setUp(() => registerFallbackValue(tVideoFile));
    test(
      'should return [Right<void>] when call  '
      'to remote source is successful',
      () async {
        when(
          () => remoteDataSource.uploadVideoToS3(
            presignedUrl: any<String>(named: 'presignedUrl'),
            videoFile: any<XFile>(named: 'videoFile'),
          ),
        ).thenAnswer((_) async => Future.value());

        final result = await repoImpl.uploadVideoToS3(
          presignedUrl: tPresignedUrl,
          videoFile: tVideoFile,
        );

        expect(result, equals(const Right<Failure, void>(null)));

        verify(
          () => remoteDataSource.uploadVideoToS3(
            presignedUrl: tPresignedUrl,
            videoFile: tVideoFile,
          ),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should return [Left<Failure>] when call  '
      'to remote source is unsuccessful',
      () async {
        when(
          () => remoteDataSource.uploadVideoToS3(
            presignedUrl: any<String>(named: 'presignedUrl'),
            videoFile: any<XFile>(named: 'videoFile'),
          ),
        ).thenThrow(
          ServerException(
            message: serverFailure.message,
            statusCode: serverFailure.statusCode,
          ),
        );

        final result = await repoImpl.uploadVideoToS3(
          presignedUrl: tPresignedUrl,
          videoFile: tVideoFile,
        );

        expect(result, equals(const Left<Failure, void>(serverFailure)));

        verify(
          () => remoteDataSource.uploadVideoToS3(
            presignedUrl: tPresignedUrl,
            videoFile: tVideoFile,
          ),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });
}
