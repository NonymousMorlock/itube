import 'package:itube/core/typedefs.dart';
import 'package:itube/core/usecases/usecase.dart';
import 'package:itube/src/auth/domain/repositories/auth_repository.dart';

class Logout implements UsecaseWithoutParams<void> {
  const Logout(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<void> call() {
    return _repo.logout();
  }
}
