import 'package:itube/core/errors/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  final SharedPreferences _storage;

  static const _accessTokenKey = 'ACCESS_TOKEN_KEY';
  static const _refreshTokenKey = 'REFRESH_TOKEN_KEY';
  static const _userCognitoSubKey = 'USER_COGNITO_SUB_KEY';
  static const _pendingRegistrationEmailKey = 'PENDING_REGISTRATION_EMAIL_KEY';

  @override
  Future<void> cachePendingRegistrationEmail(String email) async {
    final result = await _storage.setString(
      _pendingRegistrationEmailKey,
      email,
    );
    if (!result) {
      throw const CacheException(
        message: 'Failed to cache pending registration email',
        statusCode: 'UNKNOWN',
      );
    }
  }

  @override
  Future<void> cacheToken({String? accessToken, String? refreshToken}) async {
    if (accessToken != null) {
      final result = await _storage.setString(_accessTokenKey, accessToken);
      if (!result) {
        throw const CacheException(
          message: 'Failed to cache access token',
          statusCode: 'UNKNOWN',
        );
      }
    }
    if (refreshToken != null) {
      final result = await _storage.setString(_refreshTokenKey, refreshToken);
      if (!result) {
        throw const CacheException(
          message: 'Failed to cache refresh token',
          statusCode: 'UNKNOWN',
        );
      }
    }
  }

  @override
  Future<void> cacheUserCognitoSub(String userCognitoSub) async {
    final result = await _storage.setString(_userCognitoSubKey, userCognitoSub);
    if (!result) {
      throw const CacheException(
        message: 'Failed to cache user cognito sub',
        statusCode: 'UNKNOWN',
      );
    }
  }

  @override
  Future<void> clearPendingRegistrationEmail() async {
    await _storage.remove(_pendingRegistrationEmailKey);
  }

  @override
  Future<void> clearSession() async {
    await _storage.remove(_accessTokenKey);
    await _storage.remove(_refreshTokenKey);
    await _storage.remove(_userCognitoSubKey);
  }

  @override
  Future<String?> getAccessToken() async {
    return _storage.getString(_accessTokenKey);
  }

  @override
  Future<String?> getPendingRegistrationEmail() async {
    return _storage.getString(_pendingRegistrationEmailKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return _storage.getString(_refreshTokenKey);
  }

  @override
  Future<String?> getUserCognitoSub() async {
    return _storage.getString(_userCognitoSubKey);
  }
}
