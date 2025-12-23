import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:itube/core/constants/network_constants.dart';
import 'package:itube/core/errors/exceptions.dart';
import 'package:itube/core/typedefs.dart';

abstract class NetworkUtils {
  static ServerException handleDioException(
    DioException e,
    StackTrace s, {
    required String repositoryName,
    required String methodName,
  }) {
    log(
      'Error Occurred',
      name: '$repositoryName.$methodName',
      error: e,
      stackTrace: s,
      level: 1200,
    );
    if (e.response != null) {
      return handleDioResponseError(e.response!);
    }
    return ServerException(
      message: NetworkConstants.serverFailureMessage,
      statusCode: e.response?.statusCode ?? 500,
    );
  }

  static ServerException handleException(
    dynamic e,
    StackTrace s, {
    required String repositoryName,
    required String methodName,
  }) {
    log(
      'Error Occurred',
      name: '$repositoryName.$methodName',
      error: e,
      stackTrace: s,
      level: 1200,
    );
    return const ServerException(
      message: NetworkConstants.serverFailureMessage,
      statusCode: 500,
    );
  }

  static ServerException handleDioResponseError(
    Response<dynamic> response, {
    String? repositoryName,
    String? methodName,
  }) {
    log(
      'Error Occurred',
      name: '$repositoryName.$methodName',
      error: response.data,
      level: 1200,
    );
    String? message;
    String? type;
    if (response.data is Map) {
      final error =
          ((response.data as DataMap)['detail'] as List<DataMap>).firstOrNull;

      message = error?['msg'] as String?;
      type = error?['type'] as String?;
    } else {
      message = response.statusMessage;
    }
    message ??= NetworkConstants.serverFailureMessage;
    return ServerException(
      message: message,
      statusCode: type ?? response.statusCode ?? 500,
    );
  }
}
