import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itube/core/errors/failures.dart';
import 'package:itube/src/auth/domain/repositories/auth_repository.dart';
import 'package:itube/src/auth/domain/usecases/login.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepo repo;
  late Login usecase;
  const tEmail = 'Test String';
  const tPassword = 'Test String';
  setUp(() {
    repo = MockAuthRepo();
    usecase = Login(repo);
  });
  test('should call the [AuthRepo.login]', () async {
    when(() {
      return repo.login(
        email: any<String>(named: 'email'),
        password: any<String>(named: 'password'),
      );
    }).thenAnswer((_) async => const Right(null));
    final result = await usecase(
      const LoginParams(email: tEmail, password: tPassword),
    );
    expect(result, equals(const Right<Failure, void>(null)));
    verify(() => repo.login(email: tEmail, password: tPassword)).called(1);
    verifyNoMoreInteractions(repo);
  });
}
