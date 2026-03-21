import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:itube/core/constants/network_constants.dart';
import 'package:itube/core/network/interfaces/session_observer.dart';
import 'package:itube/core/network/interfaces/token_provider.dart';
import 'package:itube/core/typedefs.dart';
import 'package:itube/core/utils/network_utils.dart';

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
    if (!kIsWeb && !kIsWasm) {
      final accessToken = await _tokenProvider.getAccessToken();
      if (accessToken != null) {
        options.headers['Cookie'] = 'access_token=$accessToken';
      }
    }
    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    const isWeb = kIsWeb || kIsWasm;
    if (err.response?.statusCode == 401) {
      Options? refreshOptions;
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: _dio.options.baseUrl,
          contentType: _dio.options.contentType,
          extra: isWeb ? {'withCredentials': true} : {},
        ),
      );
      refreshDio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      if (!isWeb) {
        final refreshToken = await _tokenProvider.getRefreshToken();
        final userSub = await _tokenProvider.getUserCognitoSub();

        if (refreshToken == null || userSub == null) {
          _sessionObserver.invalidate();
          return handler.reject(err);
        }
        refreshOptions = Options(
          headers: {
            'Cookie': [
              'refresh_token=$refreshToken',
              'user_cognito_sub=$userSub',
            ].join('; '),
          },
        );
      }

      try {
        final response = await refreshDio.post<DataMap>(
          NetworkConstants.refreshTokenEndpoint,
          options: refreshOptions,
        );

        if (!isWeb) {
          final setCookieHeaders = response.headers['set-cookie'];
          if (setCookieHeaders != null) {
            await extractAndCacheCookies(setCookieHeaders);
          }
        }

        final options = err.requestOptions;
        if (options.data is FormData) {
          final data = options.data as FormData;
          final formData = FormData();

          for (final mapFile in data.files) {
            formData.files.add(MapEntry(mapFile.key, mapFile.value.clone()));
          }
          options.data = formData;
        }
        if (!isWeb) {
          final newAccessToken = await _tokenProvider.getAccessToken();
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
        _sessionObserver.invalidate();

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
    final (:accessToken, :refreshToken) = NetworkUtils.extractTokensFromCookies(
      setCookies,
    );
    if (accessToken != null || refreshToken != null) {
      await _tokenProvider.cacheToken(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    }
  }
}
