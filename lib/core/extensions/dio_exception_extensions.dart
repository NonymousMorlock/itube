import 'package:dio/dio.dart';
import 'package:itube/core/extensions/dio_exception_type_extensions.dart';

extension DioExceptionExtensions on DioException {
  String get title {
    return switch (type) {
      DioExceptionType.badResponse => _handleBadResponseTitle(),
      _ => type.title,
    };
  }

  String get errorMessage {
    return switch (type) {
      DioExceptionType.badResponse => _handleBadResponseMessage(),
      _ => type.message,
    };
  }

  String _handleBadResponseTitle() {
    return switch (response?.statusCode) {
      400 => 'Invalid Request',
      401 || 403 => 'Authentication Error',
      404 => 'Not Found',
      500 => 'Server Error',
      _ => 'Response Error',
    };
  }

  String _handleBadResponseMessage() {
    return switch (response?.statusCode) {
      400 => 'The request was invalid. Please check your input.',
      401 => 'Your session has expired. Please log in again.',
      403 => 'You do not have permission to perform this action.',
      404 => 'The requested resource was not found.',
      500 => 'Something went wrong on our end. Please try again later.',
      _ => 'The server returned an invalid response.',
    };
  }
}
