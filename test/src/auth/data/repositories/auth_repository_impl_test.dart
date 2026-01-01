import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itube/core/errors/exceptions.dart';
import 'package:itube/core/errors/failures.dart';
import 'package:itube/core/network/interfaces/token_provider.dart';
import 'package:itube/src/auth/data/datasources/auth_local_data_source.dart';
import 'package:itube/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:itube/src/auth/data/models/user_model.dart';
import 'package:itube/src/auth/data/repositories/auth_repository_impl.dart';
import 'package:itube/src/auth/domain/entities/user.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

class MockTokenProvider extends Mock implements TokenProvider {}

void main() {
  late AuthRemoteDataSource remoteDataSource;
  late AuthLocalDataSource localDataSource;
  late TokenProvider tokenProvider;
  late AuthRepoImpl repoImpl;
  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    localDataSource = MockAuthLocalDataSource();
    tokenProvider = MockTokenProvider();
    repoImpl = AuthRepoImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      tokenProvider: tokenProvider,
    );
  });
  const serverFailure = ServerFailure(
    message: 'Something went wrong',
    statusCode: 500,
  );
  const cacheException = CacheException(
    message: 'Something went wrong',
    statusCode: 'CACHE_FAILURE',
  );

  group('getCurrentUser', () {
    const tResult = UserModel.empty();
    test('should return [Right<User>] when calls  '
        'to remote and local sources are successful', () async {
      when(
        () => remoteDataSource.getCurrentUser(),
      ).thenAnswer((_) async => tResult);

      when(
        () => localDataSource.cacheUserCognitoSub(any()),
      ).thenAnswer((_) => Future.value());

      final result = await repoImpl.getCurrentUser();

      expect(result, equals(const Right<Failure, User>(tResult)));

      verify(() => remoteDataSource.getCurrentUser()).called(1);
      verify(
        () => localDataSource.cacheUserCognitoSub(tResult.cognitoSub),
      ).called(1);

      verifyNoMoreInteractions(remoteDataSource);
      verifyNoMoreInteractions(localDataSource);
    });

    test('should return [Left<Failure>] when call  '
        'to remote source is unsuccessful', () async {
      when(() => remoteDataSource.getCurrentUser()).thenThrow(
        ServerException(
          message: serverFailure.message,
          statusCode: serverFailure.statusCode,
        ),
      );

      final result = await repoImpl.getCurrentUser();

      expect(result, equals(const Left<Failure, User>(serverFailure)));

      verify(() => remoteDataSource.getCurrentUser()).called(1);

      verifyNoMoreInteractions(remoteDataSource);
      verifyZeroInteractions(localDataSource);
    });

    test('should return [Left<Failure>] when call  '
        'to local source is unsuccessful', () async {
      when(
        () => remoteDataSource.getCurrentUser(),
      ).thenAnswer((_) async => tResult);

      when(
        () => localDataSource.cacheUserCognitoSub(any()),
      ).thenThrow(cacheException);

      final result = await repoImpl.getCurrentUser();

      expect(
        result,
        equals(Left<Failure, User>(CacheFailure.fromException(cacheException))),
      );

      verify(() => remoteDataSource.getCurrentUser()).called(1);

      verify(
        () => localDataSource.cacheUserCognitoSub(tResult.cognitoSub),
      ).called(1);

      verifyNoMoreInteractions(remoteDataSource);
      verifyNoMoreInteractions(localDataSource);
    });
  });

  group('getPendingRegistrationEmail', () {
    test('should complete successfully when call  '
        'to local source is successful', () async {
      when(
        () => localDataSource.getPendingRegistrationEmail(),
      ).thenAnswer((_) async => Future.value());

      final result = await repoImpl.getPendingRegistrationEmail();

      expect(result, equals(const Right<Failure, void>(null)));

      verify(() => localDataSource.getPendingRegistrationEmail()).called(1);

      verifyNoMoreInteractions(localDataSource);

      verifyZeroInteractions(tokenProvider);
      verifyZeroInteractions(remoteDataSource);
    });
    test('should return [Left<Failure>] when call  '
        'to local source is unsuccessful', () async {
      when(
        () => localDataSource.getPendingRegistrationEmail(),
      ).thenThrow(cacheException);
      final result = await repoImpl.getPendingRegistrationEmail();
      expect(
        result,
        equals(Left<Failure, void>(CacheFailure.fromException(cacheException))),
      );
      verify(() => localDataSource.getPendingRegistrationEmail()).called(1);

      verifyNoMoreInteractions(localDataSource);

      verifyZeroInteractions(tokenProvider);
      verifyZeroInteractions(remoteDataSource);
    });
  });

  group('login', () {
    const tEmail = 'Test String';
    const tPassword = 'Test String';
    const tAccessToken = 'Test String';
    const tRefreshToken = 'Test String';
    test('should complete successfully when calls  '
        'to remote and local sources are successful', () async {
      when(() {
        return remoteDataSource.login(
          email: any<String>(named: 'email'),
          password: any<String>(named: 'password'),
        );
      }).thenAnswer(
        (_) async => (accessToken: tAccessToken, refreshToken: tRefreshToken),
      );
      when(() {
        return tokenProvider.cacheToken(
          accessToken: any<String>(named: 'accessToken'),
          refreshToken: any<String>(named: 'refreshToken'),
        );
      }).thenAnswer((_) => Future.value());

      final result = await repoImpl.login(email: tEmail, password: tPassword);

      expect(result, equals(const Right<Failure, void>(null)));

      verify(
        () => remoteDataSource.login(email: tEmail, password: tPassword),
      ).called(1);
      verify(
        () => tokenProvider.cacheToken(
          accessToken: tAccessToken,
          refreshToken: tRefreshToken,
        ),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSource);
      verifyNoMoreInteractions(tokenProvider);
    });

    test('should return [Left<Failure>] when call  '
        'to remote source is unsuccessful', () async {
      when(() {
        return remoteDataSource.login(
          email: any<String>(named: 'email'),
          password: any<String>(named: 'password'),
        );
      }).thenThrow(
        ServerException(
          message: serverFailure.message,
          statusCode: serverFailure.statusCode,
        ),
      );

      final result = await repoImpl.login(email: tEmail, password: tPassword);

      expect(result, equals(const Left<Failure, void>(serverFailure)));

      verify(
        () => remoteDataSource.login(email: tEmail, password: tPassword),
      ).called(1);

      verifyNoMoreInteractions(remoteDataSource);

      verifyZeroInteractions(tokenProvider);
    });

    test('should return [Left<Failure>] when call  '
        'to local source is unsuccessful', () async {
      when(() {
        return remoteDataSource.login(
          email: any<String>(named: 'email'),
          password: any<String>(named: 'password'),
        );
      }).thenAnswer(
        (_) async => (accessToken: tAccessToken, refreshToken: tRefreshToken),
      );
      when(() {
        return tokenProvider.cacheToken(
          accessToken: any<String>(named: 'accessToken'),
          refreshToken: any<String>(named: 'refreshToken'),
        );
      }).thenThrow(cacheException);

      final result = await repoImpl.login(email: tEmail, password: tPassword);

      expect(
        result,
        equals(Left<Failure, void>(CacheFailure.fromException(cacheException))),
      );

      verify(
        () => remoteDataSource.login(email: tEmail, password: tPassword),
      ).called(1);

      verify(
        () => tokenProvider.cacheToken(
          accessToken: tAccessToken,
          refreshToken: tRefreshToken,
        ),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSource);
      verifyNoMoreInteractions(tokenProvider);
    });
  });

  group('logout', () {
    test('should complete successfully when calls  '
        'to remote and local sources are successful', () async {
      when(
        () => remoteDataSource.logout(),
      ).thenAnswer((_) async => Future.value());
      when(
        () => localDataSource.clearSession(),
      ).thenAnswer((_) async => Future.value());
      when(() => tokenProvider.clearProviderMemory()).thenReturn(null);

      final result = await repoImpl.logout();

      expect(result, equals(const Right<Failure, void>(null)));

      verify(() => remoteDataSource.logout()).called(1);
      verify(() => localDataSource.clearSession()).called(1);
      verify(() => tokenProvider.clearProviderMemory()).called(1);

      verifyNoMoreInteractions(localDataSource);
      verifyNoMoreInteractions(tokenProvider);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test('should return [Left<Failure>] when call  '
        'to remote source is unsuccessful', () async {
      when(
        () => remoteDataSource.logout(),
      ).thenThrow(
        ServerException(
          message: serverFailure.message,
          statusCode: serverFailure.statusCode,
        ),
      );

      final result = await repoImpl.logout();

      expect(
        result,
        equals(const Left<Failure, void>(serverFailure)),
      );

      verify(() => remoteDataSource.logout()).called(1);

      verifyNoMoreInteractions(remoteDataSource);

      verifyZeroInteractions(localDataSource);
      verifyZeroInteractions(tokenProvider);
    });

    test('should return [Left<Failure>] when call  '
        'to local source is unsuccessful', () async {
      when(
        () => remoteDataSource.logout(),
      ).thenAnswer((_) async => Future.value());
      when(() => localDataSource.clearSession()).thenThrow(cacheException);

      final result = await repoImpl.logout();

      expect(
        result,
        equals(Left<Failure, void>(CacheFailure.fromException(cacheException))),
      );

      verify(() => remoteDataSource.logout()).called(1);
      verify(() => localDataSource.clearSession()).called(1);

      verifyNoMoreInteractions(remoteDataSource);
      verifyNoMoreInteractions(localDataSource);

      verifyZeroInteractions(tokenProvider);
    });
  });

  group('register', () {
    const tEmail = 'Test String';
    const tName = 'Test String';
    const tPassword = 'Test String';
    test('should complete successfully when calls  '
        'to remote and local sources are successful', () async {
      when(() {
        return remoteDataSource.register(
          email: any<String>(named: 'email'),
          name: any<String>(named: 'name'),
          password: any<String>(named: 'password'),
        );
      }).thenAnswer((_) async => Future.value());

      when(() {
        return localDataSource.cachePendingRegistrationEmail(any());
      }).thenAnswer((_) async => Future.value());

      final result = await repoImpl.register(
        email: tEmail,
        name: tName,
        password: tPassword,
      );

      expect(result, equals(const Right<Failure, void>(null)));

      verify(
        () => remoteDataSource.register(
          email: tEmail,
          name: tName,
          password: tPassword,
        ),
      ).called(1);

      verify(
        () => localDataSource.cachePendingRegistrationEmail(tEmail),
      ).called(1);

      verifyNoMoreInteractions(remoteDataSource);
      verifyNoMoreInteractions(localDataSource);

      verifyZeroInteractions(tokenProvider);
    });
    test('should return [Left<Failure>] when call  '
        'to remote source is unsuccessful', () async {
      when(() {
        return remoteDataSource.register(
          email: any<String>(named: 'email'),
          name: any<String>(named: 'name'),
          password: any<String>(named: 'password'),
        );
      }).thenThrow(
        ServerException(
          message: serverFailure.message,
          statusCode: serverFailure.statusCode,
        ),
      );
      final result = await repoImpl.register(
        email: tEmail,
        name: tName,
        password: tPassword,
      );
      expect(result, equals(const Left<Failure, void>(serverFailure)));
      verify(
        () => remoteDataSource.register(
          email: tEmail,
          name: tName,
          password: tPassword,
        ),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSource);
      verifyZeroInteractions(localDataSource);
    });
    test('should return [Left<Failure>] when call  '
        'to local source is unsuccessful', () async {
      when(() {
        return remoteDataSource.register(
          email: any<String>(named: 'email'),
          name: any<String>(named: 'name'),
          password: any<String>(named: 'password'),
        );
      }).thenAnswer((_) async => Future.value());

      when(() {
        return localDataSource.cachePendingRegistrationEmail(any());
      }).thenThrow(cacheException);

      final result = await repoImpl.register(
        email: tEmail,
        name: tName,
        password: tPassword,
      );

      expect(
        result,
        equals(Left<Failure, void>(CacheFailure.fromException(cacheException))),
      );

      verify(
        () => remoteDataSource.register(
          email: tEmail,
          name: tName,
          password: tPassword,
        ),
      ).called(1);

      verify(
        () => localDataSource.cachePendingRegistrationEmail(tEmail),
      ).called(1);

      verifyNoMoreInteractions(remoteDataSource);
      verifyNoMoreInteractions(localDataSource);

      verifyZeroInteractions(tokenProvider);
    });
  });

  group('verifyEmail', () {
    const tEmail = 'Test String';
    const tOtp = 'Test String';
    test('should complete successfully when calls  '
        'to remote and local sources are successful', () async {
      when(() {
        return remoteDataSource.verifyEmail(
          email: any<String>(named: 'email'),
          otp: any<String>(named: 'otp'),
        );
      }).thenAnswer((_) async => Future.value());

      when(() {
        return localDataSource.clearPendingRegistrationEmail();
      }).thenAnswer((_) async => Future.value());

      final result = await repoImpl.verifyEmail(email: tEmail, otp: tOtp);

      expect(result, equals(const Right<Failure, void>(null)));

      verify(
        () => remoteDataSource.verifyEmail(email: tEmail, otp: tOtp),
      ).called(1);
      verify(
        () => localDataSource.clearPendingRegistrationEmail(),
      ).called(1);

      verifyNoMoreInteractions(remoteDataSource);
      verifyNoMoreInteractions(localDataSource);
      verifyZeroInteractions(tokenProvider);
    });
    test('should return [Left<Failure>] when call  '
        'to remote source is unsuccessful', () async {
      when(() {
        return remoteDataSource.verifyEmail(
          email: any<String>(named: 'email'),
          otp: any<String>(named: 'otp'),
        );
      }).thenThrow(
        ServerException(
          message: serverFailure.message,
          statusCode: serverFailure.statusCode,
        ),
      );
      final result = await repoImpl.verifyEmail(email: tEmail, otp: tOtp);

      expect(result, equals(const Left<Failure, void>(serverFailure)));

      verify(
        () => remoteDataSource.verifyEmail(email: tEmail, otp: tOtp),
      ).called(1);

      verifyNoMoreInteractions(remoteDataSource);
      verifyZeroInteractions(localDataSource);
    });

    test('should return [Left<Failure>] when call  '
        'to local source is unsuccessful', () async {
      when(() {
        return remoteDataSource.verifyEmail(
          email: any<String>(named: 'email'),
          otp: any<String>(named: 'otp'),
        );
      }).thenAnswer((_) async => Future.value());

      when(() {
        return localDataSource.clearPendingRegistrationEmail();
      }).thenThrow(cacheException);

      final result = await repoImpl.verifyEmail(email: tEmail, otp: tOtp);

      expect(
        result,
        equals(Left<Failure, void>(CacheFailure.fromException(cacheException))),
      );

      verify(
        () => remoteDataSource.verifyEmail(email: tEmail, otp: tOtp),
      ).called(1);

      verify(
        () => localDataSource.clearPendingRegistrationEmail(),
      ).called(1);

      verifyNoMoreInteractions(remoteDataSource);
      verifyNoMoreInteractions(localDataSource);

      verifyZeroInteractions(tokenProvider);
    });
  });
}
