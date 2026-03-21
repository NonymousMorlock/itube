sealed class NetworkConstants {
  const NetworkConstants();

  static const baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:8000/api/v1',
  );
  static const refreshTokenEndpoint = '/auth/refresh-token';
  static const registerEndpoint = '/auth/signup';
  static const loginEndpoint = '/auth/login';
  static const logoutEndpoint = '/auth/logout';
  static const verifyEmailEndpoint = '/auth/verify-email';
  static const getCurrentUserEndpoint = '/auth/me';

  static const getPresignedVideoUrlEndpoint = '/upload/videos/upload-url';

  static String getPresignedThumbnailUrlEndpoint(String associatedVideoId) =>
      '/upload/videos/thumbnail/upload-url'
      '?associated_video_id=$associatedVideoId';
  static const uploadVideoMetadataEndpoint = '/upload/videos/metadata';
  static const getAllVideosEndpoint = '/upload/videos';

  static String getVideoByIdEndpoint(String id) => '/upload/videos/$id';

  static const serverFailureMessage = 'Something went wrong';
}
