import 'package:equatable/equatable.dart';
import 'package:itube/core/typedefs.dart';
import 'package:itube/core/usecases/usecase.dart';
import 'package:itube/src/auth/domain/repositories/auth_repository.dart';

class Login implements UsecaseWithParams<void, LoginParams> {
  const Login(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<void> call(LoginParams params) {
    return _repo.login(email: params.email, password: params.password);
  }
}

class LoginParams extends Equatable {
  const LoginParams({required this.email, required this.password});

  const LoginParams.empty()
    : this(email: 'Test String', password: 'Test String');

  final String email;

  final String password;

  @override
  List<Object?> get props => [email, password];
}
