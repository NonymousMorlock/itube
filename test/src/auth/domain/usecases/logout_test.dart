import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itube/core/errors/failures.dart';
import 'package:itube/src/auth/domain/repositories/auth_repository.dart';
import 'package:itube/src/auth/domain/usecases/logout.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepo repo;
  late Logout usecase;
  setUp(() {
    repo = MockAuthRepo();
    usecase = Logout(repo);
  });
  test('should call the [AuthRepo.logout]', () async {
    when(() => repo.logout()).thenAnswer((_) async => const Right(null));
    final result = await usecase();
    expect(result, equals(const Right<Failure, void>(null)));
    verify(() => repo.logout()).called(1);
    verifyNoMoreInteractions(repo);
  });
}
