import 'package:itube/core/typedefs.dart';
import 'package:itube/core/usecases/usecase.dart';
import 'package:itube/src/auth/domain/entities/user.dart';
import 'package:itube/src/auth/domain/repositories/auth_repository.dart';

class GetCurrentUser implements UsecaseWithoutParams<User> {
  const GetCurrentUser(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<User> call() {
    return _repo.getCurrentUser();
  }
}
