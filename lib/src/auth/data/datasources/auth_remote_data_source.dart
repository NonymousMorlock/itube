import 'package:dio/dio.dart';
import 'package:itube/core/constants/network_constants.dart';
import 'package:itube/core/errors/exceptions.dart';
import 'package:itube/core/typedefs.dart';
import 'package:itube/core/utils/network_utils.dart';
import 'package:itube/src/auth/data/models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<UserModel> getCurrentUser();

  Future<AuthTokens> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<void> register({
    required String email,
    required String name,
    required String password,
  });

  Future<void> verifyEmail({required String email, required String otp});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _dio.get<DataMap>(
        NetworkConstants.getCurrentUserEndpoint,
      );

      if (![200, 201].contains(response.statusCode)) {
        throw NetworkUtils.handleDioResponseError(
          response,
          repositoryName: 'AuthRemoteDataSrcImpl',
          methodName: 'getCurrentUser',
        );
      }
      return UserModel.fromMap(response.data!);
    } on ServerException {
      rethrow;
    } on DioException catch (exception, stackTrace) {
      throw NetworkUtils.handleDioException(
        exception,
        stackTrace,
        repositoryName: 'AuthRemoteDataSrcImpl',
        methodName: 'getCurrentUser',
      );
    } on Exception catch (exception, stackTrace) {
      throw NetworkUtils.handleException(
        exception,
        stackTrace,
        repositoryName: 'AuthRemoteDataSrcImpl',
        methodName: 'getCurrentUser',
      );
    }
  }

  @override
  Future<AuthTokens> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post<DataMap>(
        NetworkConstants.loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (![200, 201].contains(response.statusCode)) {
        throw NetworkUtils.handleDioResponseError(
          response,
          repositoryName: 'AuthRemoteDataSrcImpl',
          methodName: 'login',
        );
      }

      final setCookieHeaders = response.headers['set-cookie'];
      String? accessToken;
      String? refreshToken;
      if (setCookieHeaders != null) {
        (:accessToken, :refreshToken) = NetworkUtils.extractTokensFromCookies(
          setCookieHeaders,
        );
      }
      return (accessToken: accessToken, refreshToken: refreshToken);
    } on ServerException {
      rethrow;
    } on DioException catch (exception, stackTrace) {
      throw NetworkUtils.handleDioException(
        exception,
        stackTrace,
        repositoryName: 'AuthRemoteDataSrcImpl',
        methodName: 'login',
      );
    } catch (exception, stackTrace) {
      throw NetworkUtils.handleException(
        exception,
        stackTrace,
        repositoryName: 'AuthRemoteDataSrcImpl',
        methodName: 'login',
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      final response = await _dio.post<DataMap>(
        NetworkConstants.logoutEndpoint,
      );

      if (![200, 201].contains(response.statusCode)) {
        throw NetworkUtils.handleDioResponseError(
          response,
          repositoryName: 'AuthRemoteDataSrcImpl',
          methodName: 'logout',
        );
      }
    } on ServerException {
      rethrow;
    } on DioException catch (exception, stackTrace) {
      throw NetworkUtils.handleDioException(
        exception,
        stackTrace,
        repositoryName: 'AuthRemoteDataSrcImpl',
        methodName: 'logout',
      );
    } on Exception catch (exception, stackTrace) {
      throw NetworkUtils.handleException(
        exception,
        stackTrace,
        repositoryName: 'AuthRemoteDataSrcImpl',
        methodName: 'logout',
      );
    }
  }

  @override
  Future<void> register({
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      final response = await _dio.post<DataMap>(
        NetworkConstants.registerEndpoint,
        data: {
          'email': email,
          'name': name,
          'password': password,
        },
      );
      if (![200, 201].contains(response.statusCode)) {
        throw NetworkUtils.handleDioResponseError(
          response,
          repositoryName: 'AuthRemoteDataSrcImpl',
          methodName: 'register',
        );
      }
    } on ServerException {
      rethrow;
    } on DioException catch (exception, stackTrace) {
      throw NetworkUtils.handleDioException(
        exception,
        stackTrace,
        repositoryName: 'AuthRemoteDataSrcImpl',
        methodName: 'register',
      );
    } catch (exception, stackTrace) {
      throw NetworkUtils.handleException(
        exception,
        stackTrace,
        repositoryName: 'AuthRemoteDataSrcImpl',
        methodName: 'register',
      );
    }
  }

  @override
  Future<void> verifyEmail({required String email, required String otp}) async {
    try {
      final response = await _dio.post<DataMap>(
        NetworkConstants.verifyEmailEndpoint,
        data: {
          'email': email,
          'otp': otp,
        },
      );

      if (![200, 201].contains(response.statusCode)) {
        throw NetworkUtils.handleDioResponseError(
          response,
          repositoryName: 'AuthRemoteDataSrcImpl',
          methodName: 'verifyEmail',
        );
      }
    } on ServerException {
      rethrow;
    } on DioException catch (exception, stackTrace) {
      throw NetworkUtils.handleDioException(
        exception,
        stackTrace,
        repositoryName: 'AuthRemoteDataSrcImpl',
        methodName: 'verifyEmail',
      );
    } on Exception catch (exception, stackTrace) {
      throw NetworkUtils.handleException(
        exception,
        stackTrace,
        repositoryName: 'AuthRemoteDataSrcImpl',
        methodName: 'verifyEmail',
      );
    }
  }
}
