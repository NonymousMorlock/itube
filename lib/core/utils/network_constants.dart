sealed class NetworkConstants {
  const NetworkConstants();

  static const baseUrl = 'http://localhost:8080/api/v1';
  static const refreshTokenEndpoint = '/auth/refresh-token';
  static const registerEndpoint = '/auth/register';
  static const loginEndpoint = '/auth/login';

  static const serverFailureMessage = 'Something went wrong';
}
