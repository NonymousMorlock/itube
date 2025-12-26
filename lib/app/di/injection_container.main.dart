part of 'injection_container.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  await _initStorage();
  await _initServices();
  await _initAuth();
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
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);
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
  if (kIsWeb || kIsWasm) {
    dio.httpClientAdapter = BrowserHttpClientAdapter(withCredentials: true);
  }
  dio.interceptors.addAll([
    LogInterceptor(requestBody: true, responseBody: true),
    RefreshTokenInterceptor(
      dio: dio,
      tokenProvider: sl(),
      sessionObserver: sl(),
    ),
  ]);
  sl.registerLazySingleton(() => dio);
}
