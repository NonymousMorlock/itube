import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:itube/core/constants/network_constants.dart';
import 'package:itube/core/errors/exceptions.dart';
import 'package:itube/core/extensions/dio_exception_extensions.dart';
import 'package:itube/core/extensions/string_extensions.dart';
import 'package:itube/core/typedefs.dart';

sealed class NetworkUtils {
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
      return handleDioResponseError(
        e.response!,
        repositoryName: repositoryName,
        methodName: methodName,
        title: e.title,
      );
    }
    return ServerException(
      message: e.errorMessage,
      statusCode: e.title,
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
    String? title,
  }) {
    log(
      'Error Occurred',
      name: '$repositoryName.$methodName',
      error: response.data,
      level: 1200,
    );

    String? message;
    dynamic errorTitle = title ?? response.statusCode;

    if (response.data is Map) {
      final data = response.data as Map<String, dynamic>;

      final summary = data['error'] ?? data['message'];

      final details = data['detail'] ?? data['details'];

      if (summary is String) {
        // If "error" exists in the body, it becomes our main title
        errorTitle = summary.replaceAll('Exception', '');
      } else if (details is List && details.isNotEmpty) {
        final firstDetail = details.first;
        if (firstDetail is Map && firstDetail.containsKey('type')) {
          errorTitle = (firstDetail['type'] as String).normalize;
        }
      }

      if (details is List && details.isNotEmpty) {
        final messages = details
            .map((e) {
              if (e is Map) {
                final rawMsg = (e['msg'] ?? e['message'])?.toString() ?? '';
                return rawMsg.contains(': ') ? rawMsg.split(': ').last : rawMsg;
              }
              return e.toString();
            })
            .where((m) => m.isNotEmpty)
            .toSet();

        if (messages.isNotEmpty) {
          if (messages.length == 1) {
            message = messages.first;
          } else {
            // Capping at 3 messages for mobile safety, join with bullet points
            final displayList = messages.take(3).map((m) => '• $m').toList();
            if (messages.length > 3) {
              displayList.add('• ...and ${messages.length - 3} more errors');
            }
            message = displayList.join('\n');
          }
        }
      } else if (details is String) {
        message = details;
      } else if (summary is String) {
        message = summary;
      }
    }

    return ServerException(
      message:
          message ??
          response.statusMessage ??
          NetworkConstants.serverFailureMessage,
      statusCode: errorTitle,
    );
  }

  static AuthTokens extractTokensFromCookies(List<String> setCookies) {
    String? accessToken;
    String? refreshToken;

    log('Cookies: $setCookies', name: 'NetworkUtils.extractTokensFromCookies');

    for (final cookie in setCookies) {
      final parts = cookie.split(';');
      final nameValue = parts.first;
      final index = nameValue.indexOf('=');

      if (index == -1) continue;

      final name = nameValue.substring(0, index);
      final value = nameValue.substring(index + 1);

      if (name == 'access_token') accessToken = value;

      if (name == 'refresh_token') refreshToken = value;
    }

    log(
      'Access Token: $accessToken',
      name: 'NetworkUtils.extractTokensFromCookies',
    );

    log(
      'Refresh Token: $refreshToken',
      name: 'NetworkUtils.extractTokensFromCookies',
    );

    return (accessToken: accessToken, refreshToken: refreshToken);
  }
}
