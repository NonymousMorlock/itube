import 'package:itube/core/typedefs.dart';
import 'package:itube/core/usecases/usecase.dart';
import 'package:itube/src/auth/domain/repositories/auth_repository.dart';

class GetPendingRegistrationEmail implements UsecaseWithoutParams<String?> {
  const GetPendingRegistrationEmail(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<String?> call() {
    return _repo.getPendingRegistrationEmail();
  }
}
