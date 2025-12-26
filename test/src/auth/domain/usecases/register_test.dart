import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itube/core/errors/failures.dart';
import 'package:itube/src/auth/domain/repositories/auth_repository.dart';
import 'package:itube/src/auth/domain/usecases/register.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepo repo;
  late Register usecase;
  const tEmail = 'Test String';
  const tName = 'Test String';
  const tPassword = 'Test String';
  setUp(() {
    repo = MockAuthRepo();
    usecase = Register(repo);
  });
  test('should call the [AuthRepo.register]', () async {
    when(() {
      return repo.register(
        email: any<String>(named: 'email'),
        name: any<String>(named: 'name'),
        password: any<String>(named: 'password'),
      );
    }).thenAnswer((_) async => const Right(null));
    final result = await usecase(
      const RegisterParams(email: tEmail, name: tName, password: tPassword),
    );
    expect(result, equals(const Right<Failure, void>(null)));
    verify(
      () => repo.register(email: tEmail, name: tName, password: tPassword),
    ).called(1);
    verifyNoMoreInteractions(repo);
  });
}
