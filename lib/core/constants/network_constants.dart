sealed class NetworkConstants {
  const NetworkConstants();

  static const baseUrl = 'http://localhost:8000/api/v1';
  static const refreshTokenEndpoint = '/auth/refresh-token';
  static const registerEndpoint = '/auth/signup';
  static const loginEndpoint = '/auth/login';
  static const logoutEndpoint = '/auth/logout';
  static const verifyEmailEndpoint = '/auth/verify-email';
  static const getCurrentUserEndpoint = '/auth/me';

  static const serverFailureMessage = 'Something went wrong';
}
