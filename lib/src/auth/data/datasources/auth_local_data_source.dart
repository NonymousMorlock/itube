import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:itube/core/errors/exceptions.dart';

abstract interface class AuthLocalDataSource {
  Future<void> cachePendingRegistrationEmail(String email);

  Future<void> cacheToken({String? accessToken, String? refreshToken});

  Future<void> cacheUserCognitoSub(String userCognitoSub);

  Future<void> clearPendingRegistrationEmail();

  Future<void> clearSession();

  Future<String?> getAccessToken();

  Future<String?> getPendingRegistrationEmail();

  Future<String?> getRefreshToken();

  Future<String?> getUserCognitoSub();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._storage);

  final FlutterSecureStorage _storage;

  static const _accessTokenKey = 'ACCESS_TOKEN_KEY';
  static const _refreshTokenKey = 'REFRESH_TOKEN_KEY';
  static const _userCognitoSubKey = 'USER_COGNITO_SUB_KEY';
  static const _pendingRegistrationEmailKey = 'PENDING_REGISTRATION_EMAIL_KEY';

  @override
  Future<void> cachePendingRegistrationEmail(String email) async {
    try {
      await _storage.write(
        key: _pendingRegistrationEmailKey,
        value: email,
      );
    } on PlatformException catch (e, s) {
      log(
        'Error: Failed to cache pending registration email',
        name: 'AuthLocalDataSourceImpl.cachePendingRegistrationEmail',
        error: e,
        stackTrace: s,
        level: 1200,
      );

      throw const CacheException(
        message: 'Something went wrong',
        statusCode: 'UNKNOWN',
      );
    } on Exception catch (e, s) {
      log(
        'Error: Failed to cache pending registration email',
        name: 'AuthLocalDataSourceImpl.cachePendingRegistrationEmail',
        error: e,
        stackTrace: s,
        level: 1200,
      );

      throw const CacheException(
        message: 'Something went wrong',
        statusCode: 'UNKNOWN',
      );
    }
  }

  @override
  Future<void> cacheToken({String? accessToken, String? refreshToken}) async {
    try {
      if (accessToken != null) {
        await _storage.write(key: _accessTokenKey, value: accessToken);
      }
      if (refreshToken != null) {
        await _storage.write(key: _refreshTokenKey, value: refreshToken);
      }
    } on PlatformException catch (e, s) {
      log(
        'Error: Failed to cache tokens',
        name: 'AuthLocalDataSourceImpl.cacheToken',
        error: e,
        stackTrace: s,
        level: 1200,
      );

      throw const CacheException(
        message: 'Something went wrong',
        statusCode: 'UNKNOWN',
      );
    } on Exception catch (e, s) {
      log(
        'Error: Failed to cache tokens',
        name: 'AuthLocalDataSourceImpl.cacheToken',
        error: e,
        stackTrace: s,
        level: 1200,
      );

      throw const CacheException(
        message: 'Something went wrong',
        statusCode: 'UNKNOWN',
      );
    }
  }

  @override
  Future<void> cacheUserCognitoSub(String userCognitoSub) async {
    try {
      await _storage.write(
        key: _userCognitoSubKey,
        value: userCognitoSub,
      );
    } on PlatformException catch (e, s) {
      log(
        'Error: Failed to cache user cognito sub',
        name: 'AuthLocalDataSourceImpl.cacheUserCognitoSub',
        error: e,
        stackTrace: s,
        level: 1200,
      );

      throw const CacheException(
        message: 'Something went wrong',
        statusCode: 'UNKNOWN',
      );
    } on Exception catch (e, s) {
      log(
        'Error: Failed to cache user cognito sub',
        name: 'AuthLocalDataSourceImpl.cacheUserCognitoSub',
        error: e,
        stackTrace: s,
        level: 1200,
      );

      throw const CacheException(
        message: 'Something went wrong',
        statusCode: 'UNKNOWN',
      );
    }
  }

  @override
  Future<void> clearPendingRegistrationEmail() async {
    try {
      await _storage.delete(key: _pendingRegistrationEmailKey);
    } on PlatformException catch (e, s) {
      log(
        'Error: Failed to clear pending registration email',
        name: 'AuthLocalDataSourceImpl.clearPendingRegistrationEmail',
        error: e,
        stackTrace: s,
        level: 1200,
      );

      throw const CacheException(
        message: 'Something went wrong',
        statusCode: 'UNKNOWN',
      );
    } on Exception catch (e, s) {
      log(
        'Error: Failed to clear pending registration email',
        name: 'AuthLocalDataSourceImpl.clearPendingRegistrationEmail',
        error: e,
        stackTrace: s,
        level: 1200,
      );

      throw const CacheException(
        message: 'Something went wrong',
        statusCode: 'UNKNOWN',
      );
    }
  }

  @override
  Future<void> clearSession() async {
    try {
      await _storage.delete(key: _accessTokenKey);
      await _storage.delete(key: _refreshTokenKey);
      await _storage.delete(key: _userCognitoSubKey);
    } on PlatformException catch (e, s) {
      log(
        'Error: Failed to clear session',
        name: 'AuthLocalDataSourceImpl.clearSession',
        error: e,
        stackTrace: s,
        level: 1200,
      );

      throw const CacheException(
        message: 'Something went wrong',
        statusCode: 'UNKNOWN',
      );
    } on Exception catch (e, s) {
      log(
        'Error: Failed to clear session',
        name: 'AuthLocalDataSourceImpl.clearSession',
        error: e,
        stackTrace: s,
        level: 1200,
      );

      throw const CacheException(
        message: 'Something went wrong',
        statusCode: 'UNKNOWN',
      );
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return _storage.read(key: _accessTokenKey);
    } on PlatformException catch (e, s) {
      log(
        'Error: Failed to get access token',
        name: 'AuthLocalDataSourceImpl.getAccessToken',
        error: e,
        stackTrace: s,
        level: 1200,
      );

      throw const CacheException(
        message: 'Something went wrong',
        statusCode: 'UNKNOWN',
      );
    } on Exception catch (e, s) {
      log(
        'Error: Failed to get access token',
        name: 'AuthLocalDataSourceImpl.getAccessToken',
        error: e,
        stackTrace: s,
        level: 1200,
      );

      throw const CacheException(
        message: 'Something went wrong',
        statusCode: 'UNKNOWN',
      );
    }
  }

  @override
  Future<String?> getPendingRegistrationEmail() async {
    try {
      return _storage.read(key: _pendingRegistrationEmailKey);
    } on PlatformException catch (e, s) {
      log(
        'Error: Failed to get pending registration email',
        name: 'AuthLocalDataSourceImpl.getPendingRegistrationEmail',
        error: e,
        stackTrace: s,
        level: 1200,
      );

      throw const CacheException(
        message: 'Something went wrong',
        statusCode: 'UNKNOWN',
      );
    } on Exception catch (e, s) {
      log(
        'Error: Failed to get pending registration email',
        name: 'AuthLocalDataSourceImpl.getPendingRegistrationEmail',
        error: e,
        stackTrace: s,
        level: 1200,
      );

      throw const CacheException(
        message: 'Something went wrong',
        statusCode: 'UNKNOWN',
      );
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return _storage.read(key: _refreshTokenKey);
    } on PlatformException catch (e, s) {
      log(
        'Error: Failed to get refresh token',
        name: 'AuthLocalDataSourceImpl.getRefreshToken',
        error: e,
        stackTrace: s,
        level: 1200,
      );

      throw const CacheException(
        message: 'Something went wrong',
        statusCode: 'UNKNOWN',
      );
    } on Exception catch (e, s) {
      log(
        'Error: Failed to get refresh token',
        name: 'AuthLocalDataSourceImpl.getRefreshToken',
        error: e,
        stackTrace: s,
        level: 1200,
      );

      throw const CacheException(
        message: 'Something went wrong',
        statusCode: 'UNKNOWN',
      );
    }
  }

  @override
  Future<String?> getUserCognitoSub() async {
    try {
      return _storage.read(key: _userCognitoSubKey);
    } on PlatformException catch (e, s) {
      log(
        'Error: Failed to get user cognito sub',
        name: 'AuthLocalDataSourceImpl.getUserCognitoSub',
        error: e,
        stackTrace: s,
        level: 1200,
      );
      throw const CacheException(
        message: 'Something went wrong',
        statusCode: 'UNKNOWN',
      );
    } on Exception catch (e, s) {
      log(
        'Error: Failed to get user cognito sub',
        name: 'AuthLocalDataSourceImpl.getUserCognitoSub',
        error: e,
        stackTrace: s,
        level: 1200,
      );
      throw const CacheException(
        message: 'Something went wrong',
        statusCode: 'UNKNOWN',
      );
    }
  }
}
