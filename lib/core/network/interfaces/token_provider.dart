abstract interface class TokenProvider {
  const TokenProvider();

  Future<void> cacheToken({String? accessToken, String? refreshToken});

  void clearProviderMemory();

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<String?> getUserCognitoSub();
}
