import 'package:itube/core/network/interfaces/token_provider.dart';
import 'package:itube/src/auth/data/datasources/auth_local_data_source.dart';

class AuthTokenProviderImpl implements TokenProvider {
  AuthTokenProviderImpl(this._localDataSource);

  final AuthLocalDataSource _localDataSource;

  String? _inMemoryAccessToken;
  String? _inMemoryRefreshToken;
  String? _inMemoryUserCognitoSub;

  @override
  Future<void> cacheToken({String? accessToken, String? refreshToken}) async {
    _inMemoryAccessToken = accessToken ?? _inMemoryAccessToken;
    _inMemoryRefreshToken = refreshToken ?? _inMemoryRefreshToken;
    return _localDataSource.cacheToken(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  @override
  void clearProviderMemory() {
    _inMemoryAccessToken = null;
    _inMemoryRefreshToken = null;
    _inMemoryUserCognitoSub = null;
  }

  @override
  Future<String?> getAccessToken() async {
    return _inMemoryAccessToken ??= await _localDataSource.getAccessToken();
  }

  @override
  Future<String?> getRefreshToken() async {
    return _inMemoryRefreshToken ??= await _localDataSource.getRefreshToken();
  }

  @override
  Future<String?> getUserCognitoSub() async {
    return _inMemoryUserCognitoSub ??= await _localDataSource
        .getUserCognitoSub();
  }
}
