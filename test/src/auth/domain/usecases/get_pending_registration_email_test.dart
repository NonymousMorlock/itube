import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itube/core/errors/failures.dart';
import 'package:itube/src/auth/domain/repositories/auth_repository.dart';
import 'package:itube/src/auth/domain/usecases/get_pending_registration_email.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepo repo;
  late GetPendingRegistrationEmail usecase;
  setUp(() {
    repo = MockAuthRepo();
    usecase = GetPendingRegistrationEmail(repo);
  });
  test('should call the [AuthRepo.getPendingRegistrationEmail]', () async {
    when(
      () => repo.getPendingRegistrationEmail(),
    ).thenAnswer((_) async => const Right(null));
    final result = await usecase();
    expect(result, equals(const Right<Failure, void>(null)));
    verify(() => repo.getPendingRegistrationEmail()).called(1);
    verifyNoMoreInteractions(repo);
  });
}
