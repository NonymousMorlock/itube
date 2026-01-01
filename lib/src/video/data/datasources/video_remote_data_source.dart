import 'package:cross_file/cross_file.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:itube/core/constants/network_constants.dart';
import 'package:itube/core/errors/exceptions.dart';
import 'package:itube/core/typedefs.dart';
import 'package:itube/core/utils/network_utils.dart';
import 'package:itube/src/video/data/models/video_model.dart';
import 'package:itube/src/video/typedefs.dart';

abstract interface class VideoRemoteDataSource {
  const VideoRemoteDataSource();

  Future<List<VideoModel>> getAllVideos();

  Future<MediaResponse> getPresignedThumbnailUrl({
    required String associatedVideoId,
  });

  Future<MediaResponse> getPresignedVideoUrl();

  Future<VideoModel> getVideoById({required String id});

  Future<void> uploadThumbnailToS3({
    required String presignedUrl,
    required XFile thumbnailFile,
  });

  Future<VideoModel> uploadVideoMetadata({
    required String title,
    required String s3Key,
    required String visibility,
    String? description,
  });

  Future<void> uploadVideoToS3({
    required String presignedUrl,
    required XFile videoFile,
  });
}

class VideoRemoteDataSourceImpl implements VideoRemoteDataSource {
  const VideoRemoteDataSourceImpl({required Dio dio, required Dio s3Dio})
    : _dio = dio,
      _s3Dio = s3Dio;

  final Dio _dio;
  final Dio _s3Dio;

  @override
  Future<List<VideoModel>> getAllVideos() async {
    try {
      final response = await _dio.get<List<dynamic>>(
        NetworkConstants.getAllVideosEndpoint,
      );

      if (![200].contains(response.statusCode)) {
        throw NetworkUtils.handleDioResponseError(
          response,
          repositoryName: 'VideoRemoteDataSourceImpl',
          methodName: 'getAllVideos',
        );
      }

      return List<DataMap>.from(
        response.data!,
      ).map(VideoModel.fromMap).toList();
    } on ServerException {
      rethrow;
    } on DioException catch (exception, stackTrace) {
      throw NetworkUtils.handleDioException(
        exception,
        stackTrace,
        repositoryName: 'VideoRemoteDataSourceImpl',
        methodName: 'getAllVideos',
      );
    } on Exception catch (exception, stackTrace) {
      throw NetworkUtils.handleException(
        exception,
        stackTrace,
        repositoryName: 'VideoRemoteDataSourceImpl',
        methodName: 'getAllVideos',
      );
    }
  }

  @override
  Future<MediaResponse> getPresignedThumbnailUrl({
    required String associatedVideoId,
  }) async {
    try {
      final response = await _dio.post<DataMap>(
        NetworkConstants.getPresignedThumbnailUrlEndpoint(associatedVideoId),
      );

      if (![200, 201].contains(response.statusCode)) {
        throw NetworkUtils.handleDioResponseError(
          response,
          repositoryName: 'VideoRemoteDataSourceImpl',
          methodName: 'getPresignedThumbnailUrl',
        );
      }

      final data = response.data!;
      return (url: data['url'] as String, id: data['media_id'] as String);
    } on ServerException {
      rethrow;
    } on DioException catch (exception, stackTrace) {
      throw NetworkUtils.handleDioException(
        exception,
        stackTrace,
        repositoryName: 'VideoRemoteDataSourceImpl',
        methodName: 'getPresignedThumbnailUrl',
      );
    } on Exception catch (exception, stackTrace) {
      throw NetworkUtils.handleException(
        exception,
        stackTrace,
        repositoryName: 'VideoRemoteDataSourceImpl',
        methodName: 'getPresignedThumbnailUrl',
      );
    }
  }

  @override
  Future<MediaResponse> getPresignedVideoUrl() async {
    try {
      final response = await _dio.post<DataMap>(
        NetworkConstants.getPresignedVideoUrlEndpoint,
      );

      if (![200, 201].contains(response.statusCode)) {
        throw NetworkUtils.handleDioResponseError(
          response,
          repositoryName: 'VideoRemoteDataSourceImpl',
          methodName: 'getPresignedVideoUrl',
        );
      }

      final data = response.data!;
      return (url: data['url'] as String, id: data['media_id'] as String);
    } on ServerException {
      rethrow;
    } on DioException catch (exception, stackTrace) {
      throw NetworkUtils.handleDioException(
        exception,
        stackTrace,
        repositoryName: 'VideoRemoteDataSourceImpl',
        methodName: 'getPresignedVideoUrl',
      );
    } on Exception catch (exception, stackTrace) {
      throw NetworkUtils.handleException(
        exception,
        stackTrace,
        repositoryName: 'VideoRemoteDataSourceImpl',
        methodName: 'getPresignedVideoUrl',
      );
    }
  }

  @override
  Future<VideoModel> getVideoById({required String id}) async {
    try {
      final response = await _dio.get<DataMap>(
        NetworkConstants.getVideoByIdEndpoint(id),
      );

      if (![200].contains(response.statusCode)) {
        throw NetworkUtils.handleDioResponseError(
          response,
          repositoryName: 'VideoRemoteDataSourceImpl',
          methodName: 'getVideoById',
        );
      }

      return VideoModel.fromMap(response.data!);
    } on ServerException {
      rethrow;
    } on DioException catch (exception, stackTrace) {
      throw NetworkUtils.handleDioException(
        exception,
        stackTrace,
        repositoryName: 'VideoRemoteDataSourceImpl',
        methodName: 'getVideoById',
      );
    } on Exception catch (exception, stackTrace) {
      throw NetworkUtils.handleException(
        exception,
        stackTrace,
        repositoryName: 'VideoRemoteDataSourceImpl',
        methodName: 'getVideoById',
      );
    }
  }

  @override
  Future<void> uploadThumbnailToS3({
    required String presignedUrl,
    required XFile thumbnailFile,
  }) async {
    try {
      final response = await _uploadFileToS3(
        signedUrl: presignedUrl,
        file: thumbnailFile,
        mimeType: 'image/jpg',
        type: #thumbnail,
      );
      if (![200, 201].contains(response.statusCode)) {
        throw NetworkUtils.handleDioResponseError(
          response,
          repositoryName: 'VideoRemoteDataSourceImpl',
          methodName: 'uploadThumbnailToS3',
        );
      }
    } on ServerException {
      rethrow;
    } on DioException catch (exception, stackTrace) {
      throw NetworkUtils.handleDioException(
        exception,
        stackTrace,
        repositoryName: 'VideoRemoteDataSourceImpl',
        methodName: 'uploadThumbnailToS3',
      );
    } on Exception catch (exception, stackTrace) {
      throw NetworkUtils.handleException(
        exception,
        stackTrace,
        repositoryName: 'VideoRemoteDataSourceImpl',
        methodName: 'uploadThumbnailToS3',
      );
    }
  }

  @override
  Future<VideoModel> uploadVideoMetadata({
    required String title,
    required String s3Key,
    required String visibility,
    String? description,
  }) async {
    try {
      final response = await _dio.post<DataMap>(
        NetworkConstants.uploadVideoMetadataEndpoint,
        data: {
          'title': title,
          'description': description,
          'video_s3_key': s3Key,
          'visibility': visibility,
        },
      );
      if (![200, 201].contains(response.statusCode)) {
        throw NetworkUtils.handleDioResponseError(
          response,
          repositoryName: 'VideoRemoteDataSourceImpl',
          methodName: 'uploadVideoMetadata',
        );
      }

      return VideoModel.fromMap(response.data!);
    } on ServerException {
      rethrow;
    } on DioException catch (exception, stackTrace) {
      throw NetworkUtils.handleDioException(
        exception,
        stackTrace,
        repositoryName: 'VideoRemoteDataSourceImpl',
        methodName: 'uploadVideoMetadata',
      );
    } on Exception catch (exception, stackTrace) {
      throw NetworkUtils.handleException(
        exception,
        stackTrace,
        repositoryName: 'VideoRemoteDataSourceImpl',
        methodName: 'uploadVideoMetadata',
      );
    }
  }

  @override
  Future<void> uploadVideoToS3({
    required String presignedUrl,
    required XFile videoFile,
  }) async {
    try {
      final response = await _uploadFileToS3(
        signedUrl: presignedUrl,
        file: videoFile,
        mimeType: 'video/mp4',
        type: #video,
      );
      if (![200, 201].contains(response.statusCode)) {
        throw NetworkUtils.handleDioResponseError(
          response,
          repositoryName: 'VideoRemoteDataSourceImpl',
          methodName: 'uploadVideoToS3',
        );
      }
    } on ServerException {
      rethrow;
    } on DioException catch (exception, stackTrace) {
      throw NetworkUtils.handleDioException(
        exception,
        stackTrace,
        repositoryName: 'VideoRemoteDataSourceImpl',
        methodName: 'uploadVideoToS3',
      );
    } on Exception catch (exception, stackTrace) {
      throw NetworkUtils.handleException(
        exception,
        stackTrace,
        repositoryName: 'VideoRemoteDataSourceImpl',
        methodName: 'uploadVideoToS3',
      );
    }
  }

  Future<Response<void>> _uploadFileToS3({
    required String signedUrl,
    required XFile file,
    required String mimeType,
    required Symbol type,
  }) async {
    final length = await file.length();

    // On Web, read as bytes (Blob/ArrayBuffer).
    // On Mobile, stream it to avoid Out of Memory (OOM) on large videos.
    final dynamic data;
    if (kIsWeb || kIsWasm) {
      data = await file.readAsBytes();
    } else {
      data = file.openRead();
    }

    return _s3Dio.put<void>(
      signedUrl,
      data: data,
      options: Options(
        headers: {
          Headers.contentLengthHeader: length,
          Headers.contentTypeHeader: mimeType,
          if (type == #thumbnail) 'x-amz-acl': 'public-read',
        },
      ),
    );
  }
}
