part of 'injection_container.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  await _initStorage();
  await _initServices();
  await _initAuth();
  await _initVideo();
}

Future<void> _initVideo() async {
  sl
    ..registerFactory(
      () => VideoAdapter(
        getAllVideos: sl(),
        getVideoById: sl(),
        uploadVideo: sl(),
      ),
    )
    ..registerLazySingleton(() => GetAllVideos(sl()))
    ..registerLazySingleton(() => GetVideoById(sl()))
    ..registerLazySingleton(() => UploadVideo(sl()))
    ..registerLazySingleton<VideoRepo>(() => VideoRepoImpl(sl()))
    ..registerLazySingleton<VideoRemoteDataSource>(
      () => VideoRemoteDataSourceImpl(
        dio: sl(),
        s3Dio: Dio()
          ..interceptors.add(
            LogInterceptor(requestBody: true, responseBody: true),
          ),
      ),
    );
}

Future<void> _initAuth() async {
  sl
    ..registerFactory(
      () => AuthAdapter(
        register: sl(),
        login: sl(),
        verifyEmail: sl(),
        getCurrentUser: sl(),
        logout: sl(),
        getPendingRegistrationEmail: sl(),
        currentUserProvider: CurrentUserProvider.instance,
      ),
    )
    ..registerLazySingleton(() => Register(sl()))
    ..registerLazySingleton(() => Login(sl()))
    ..registerLazySingleton(() => VerifyEmail(sl()))
    ..registerLazySingleton(() => GetCurrentUser(sl()))
    ..registerLazySingleton(() => Logout(sl()))
    ..registerLazySingleton(() => GetPendingRegistrationEmail(sl()))
    ..registerLazySingleton<AuthRepo>(
      () => AuthRepoImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        tokenProvider: sl(),
      ),
    )
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(dio: sl()),
    );
}

Future<void> _initStorage() async {
  sl.registerLazySingleton(FlutterSecureStorage.new);
}

Future<void> _initServices() async {
  sl
    ..registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(sl()),
    )
    ..registerLazySingleton<TokenProvider>(() => AuthTokenProviderImpl(sl()))
    ..registerLazySingleton(SessionObserver.new)
    ..registerLazySingleton(FToast.new);

  final dioOptions = BaseOptions(
    contentType: 'application/json',
    baseUrl: NetworkConstants.baseUrl,
    extra: {'withCredentials': true},
  );
  final dio = Dio(dioOptions);
  dio.interceptors.addAll([
    RefreshTokenInterceptor(
      dio: dio,
      tokenProvider: sl(),
      sessionObserver: sl(),
    ),
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: false,
      responseHeader: false,
    ),
  ]);
  sl.registerLazySingleton(() => dio);
}
