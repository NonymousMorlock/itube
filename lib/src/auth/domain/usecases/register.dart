import 'package:equatable/equatable.dart';
import 'package:itube/core/typedefs.dart';
import 'package:itube/core/usecases/usecase.dart';
import 'package:itube/src/auth/domain/repositories/auth_repository.dart';

class Register implements UsecaseWithParams<void, RegisterParams> {
  const Register(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<void> call(RegisterParams params) {
    return _repo.register(
      email: params.email,
      name: params.name,
      password: params.password,
    );
  }
}

class RegisterParams extends Equatable {
  const RegisterParams({
    required this.email,
    required this.name,
    required this.password,
  });

  const RegisterParams.empty()
    : this(email: 'Test String', name: 'Test String', password: 'Test String');

  final String email;

  final String name;

  final String password;

  @override
  List<Object?> get props => [email, name, password];
}
