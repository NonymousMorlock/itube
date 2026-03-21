import 'package:cross_file/cross_file.dart';
import 'package:dartz/dartz.dart';
import 'package:itube/core/errors/exceptions.dart';
import 'package:itube/core/errors/failures.dart';
import 'package:itube/core/typedefs.dart';
import 'package:itube/src/video/data/datasources/video_remote_data_source.dart';
import 'package:itube/src/video/domain/entities/video.dart';
import 'package:itube/src/video/domain/repositories/video_repository.dart';
import 'package:itube/src/video/typedefs.dart';

class VideoRepoImpl implements VideoRepo {
  const VideoRepoImpl(this._remoteDataSource);

  final VideoRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<List<Video>> getAllVideos() async {
    try {
      final result = await _remoteDataSource.getAllVideos();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<MediaResponse> getPresignedThumbnailUrl({
    required String associatedVideoId,
  }) async {
    try {
      final result = await _remoteDataSource.getPresignedThumbnailUrl(
        associatedVideoId: associatedVideoId,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<MediaResponse> getPresignedVideoUrl() async {
    try {
      final result = await _remoteDataSource.getPresignedVideoUrl();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<Video> getVideoById({required String id}) async {
    try {
      final result = await _remoteDataSource.getVideoById(id: id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> uploadThumbnailToS3({
    required String presignedUrl,
    required XFile thumbnailFile,
  }) async {
    try {
      await _remoteDataSource.uploadThumbnailToS3(
        presignedUrl: presignedUrl,
        thumbnailFile: thumbnailFile,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<Video> uploadVideoMetadata({
    required String title,
    required String s3Key,
    required String visibility,
    String? description,
  }) async {
    try {
      final result = await _remoteDataSource.uploadVideoMetadata(
        title: title,
        s3Key: s3Key,
        visibility: visibility,
        description: description,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> uploadVideoToS3({
    required String presignedUrl,
    required XFile videoFile,
  }) async {
    try {
      await _remoteDataSource.uploadVideoToS3(
        presignedUrl: presignedUrl,
        videoFile: videoFile,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
