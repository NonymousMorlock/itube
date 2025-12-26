import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itube/core/errors/failures.dart';
import 'package:itube/src/auth/domain/entities/user.dart';
import 'package:itube/src/auth/domain/repositories/auth_repository.dart';
import 'package:itube/src/auth/domain/usecases/get_current_user.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepo repo;
  late GetCurrentUser usecase;
  const tResult = User.empty();
  setUp(() {
    repo = MockAuthRepo();
    usecase = GetCurrentUser(repo);
  });
  test('should call the  '
      '[AuthRepo.getCurrentUser]', () async {
    when(
      () => repo.getCurrentUser(),
    ).thenAnswer((_) async => const Right(tResult));
    final result = await usecase();
    expect(result, equals(const Right<Failure, User>(tResult)));
    verify(() => repo.getCurrentUser()).called(1);
    verifyNoMoreInteractions(repo);
  });
}
