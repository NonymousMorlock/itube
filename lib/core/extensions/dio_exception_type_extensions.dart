import 'package:dio/dio.dart';

extension DioExceptionTypeExtensions on DioExceptionType {
  String get message {
    return switch (this) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        'The connection timed out. Please check your internet and try again.',
      DioExceptionType.badCertificate =>
        'A security error occurred while connecting to the server.',
      DioExceptionType.badResponse =>
        'The server returned an invalid response. Please try again later.',
      DioExceptionType.cancel => 'The request was cancelled.',
      DioExceptionType.connectionError =>
        'Unable to connect to the server. '
            'Please check your internet connection.',
      DioExceptionType.unknown =>
        'An unexpected error occurred. Please try again.',
    };
  }

  String get title {
    return switch (this) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => 'Connection Timeout',
      DioExceptionType.badCertificate => 'Security Error',
      DioExceptionType.badResponse => 'Server Error',
      DioExceptionType.cancel => 'Request Cancelled',
      DioExceptionType.connectionError => 'Network Error',
      DioExceptionType.unknown => 'Unexpected Error',
    };
  }
}
