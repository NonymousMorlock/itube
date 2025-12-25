import 'package:itube/core/typedefs.dart';
import 'package:itube/src/auth/domain/entities/user.dart';

abstract interface class AuthRepo {
  const AuthRepo();

  ResultFuture<User> getCurrentUser();
  ResultFuture<String?> getPendingRegistrationEmail();
  ResultFuture<void> login({required String email, required String password});
  ResultFuture<void> logout();
  ResultFuture<void> register({
    required String email,
    required String name,
    required String password,
  });
  ResultFuture<void> verifyEmail({required String email, required String otp});
}
