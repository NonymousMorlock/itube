import 'package:equatable/equatable.dart';
import 'package:itube/core/typedefs.dart';
import 'package:itube/core/usecases/usecase.dart';
import 'package:itube/src/auth/domain/repositories/auth_repository.dart';

class VerifyEmail implements UsecaseWithParams<void, VerifyEmailParams> {
  const VerifyEmail(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<void> call(VerifyEmailParams params) {
    return _repo.verifyEmail(email: params.email, otp: params.otp);
  }
}

class VerifyEmailParams extends Equatable {
  const VerifyEmailParams({required this.email, required this.otp});

  const VerifyEmailParams.empty()
    : this(email: 'Test String', otp: 'Test String');

  final String email;

  final String otp;

  @override
  List<Object?> get props => [email, otp];
}
