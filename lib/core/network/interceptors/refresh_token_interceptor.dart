import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:itube/core/network/interfaces/session_observer.dart';
import 'package:itube/core/network/interfaces/token_provider.dart';
import 'package:itube/core/typedefs.dart';
import 'package:itube/core/utils/network_constants.dart';

class RefreshTokenInterceptor extends Interceptor {
  const RefreshTokenInterceptor({
    required Dio dio,
    required TokenProvider tokenProvider,
    required SessionObserver sessionObserver,
  }) : _dio = dio,
       _sessionObserver = sessionObserver,
       _tokenProvider = tokenProvider;

  final Dio _dio;
  final TokenProvider _tokenProvider;
  final SessionObserver _sessionObserver;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await _tokenProvider.getAccessToken();
    if (accessToken != null) {
      options.headers['Cookie'] = 'access_token=$accessToken';
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final refreshDio = Dio(
      BaseOptions(
        baseUrl: _dio.options.baseUrl,
        contentType: _dio.options.contentType,
      ),
    );
    if (err.response?.statusCode == 401) {
      final refreshToken = await _tokenProvider.getRefreshToken();
      final userSub = await _tokenProvider.getUserCognitoSub();

      if (refreshToken == null || userSub == null) {
        _sessionObserver.invalidate();
        return handler.reject(err);
      }

      try {
        final response = await refreshDio.post<DataMap>(
          NetworkConstants.refreshTokenEndpoint,
          options: Options(
            headers: {
              'Cookie': [
                'refresh_token=$refreshToken',
                'user_cognito_sub=$userSub',
              ].join('; '),
            },
          ),
        );

        final setCookieHeaders = response.headers['set-cookie'];
        if (setCookieHeaders != null) {
          await extractAndCacheCookies(setCookieHeaders);
        }

        final newAccessToken = await _tokenProvider.getAccessToken();

        final options = err.requestOptions;
        if (options.data is FormData) {
          final data = options.data as FormData;
          final formData = FormData();

          for (final mapFile in data.files) {
            formData.files.add(MapEntry(mapFile.key, mapFile.value.clone()));
          }
          options.data = formData;
          options.headers['Cookie'] = 'access_token=$newAccessToken';
        } else {
          options.headers['Cookie'] = 'access_token=$newAccessToken';
        }
        return handler.resolve(await _dio.fetch(options));
      } on DioException catch (e, s) {
        log(
          'Error Occurred [Token]',
          error: e,
          stackTrace: s,
          level: 1200,
          name: 'RefreshTokenInterceptor.DioException',
        );
        if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
          _sessionObserver.invalidate();
        }
        return handler.reject(e);
      } on Exception catch (e, s) {
        log(
          'Error Occurred [Token]',
          error: e,
          stackTrace: s,
          level: 1200,
          name: 'RefreshTokenInterceptor.UnknownException',
        );
        _sessionObserver.invalidate();
      }
    }
    return handler.next(err);
  }

  Future<void> extractAndCacheCookies(List<String> setCookies) async {
    String? accessToken;
    String? refreshToken;

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
    if (accessToken != null || refreshToken != null) {
      await _tokenProvider.cacheToken(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    }
  }
}
