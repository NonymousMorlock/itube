import 'package:dartz/dartz.dart';
import 'package:itube/core/errors/exceptions.dart';
import 'package:itube/core/errors/failures.dart';
import 'package:itube/core/network/interfaces/token_provider.dart';
import 'package:itube/core/typedefs.dart';
import 'package:itube/src/auth/data/datasources/auth_local_data_source.dart';
import 'package:itube/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:itube/src/auth/domain/entities/user.dart';
import 'package:itube/src/auth/domain/repositories/auth_repository.dart';

class AuthRepoImpl implements AuthRepo {
  const AuthRepoImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required TokenProvider tokenProvider,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _tokenProvider = tokenProvider;

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final TokenProvider _tokenProvider;

  @override
  ResultFuture<User> getCurrentUser() async {
    try {
      final result = await _remoteDataSource.getCurrentUser();
      await _localDataSource.cacheUserCognitoSub(result.cognitoSub);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<String?> getPendingRegistrationEmail() async {
    try {
      final result = await _localDataSource.getPendingRegistrationEmail();
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> login({
    required String email,
    required String password,
  }) async {
    try {
      final (:accessToken, :refreshToken) = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      await _localDataSource.cacheToken(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> logout() async {
    try {
      await _remoteDataSource.logout();
      await _localDataSource.clearSession();
      _tokenProvider.clearProviderMemory();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> register({
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      await _remoteDataSource.register(
        email: email,
        name: name,
        password: password,
      );
      await _localDataSource.cachePendingRegistrationEmail(email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> verifyEmail({
    required String email,
    required String otp,
  }) async {
    try {
      await _remoteDataSource.verifyEmail(email: email, otp: otp);
      await _localDataSource.clearPendingRegistrationEmail();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
