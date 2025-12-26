import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itube/core/errors/failures.dart';
import 'package:itube/src/auth/domain/repositories/auth_repository.dart';
import 'package:itube/src/auth/domain/usecases/verify_email.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepo repo;
  late VerifyEmail usecase;
  const tEmail = 'Test String';
  const tOtp = 'Test String';
  setUp(() {
    repo = MockAuthRepo();
    usecase = VerifyEmail(repo);
  });
  test('should call the [AuthRepo.verifyEmail]', () async {
    when(() {
      return repo.verifyEmail(
        email: any<String>(named: 'email'),
        otp: any<String>(named: 'otp'),
      );
    }).thenAnswer((_) async => const Right(null));
    final result = await usecase(
      const VerifyEmailParams(email: tEmail, otp: tOtp),
    );
    expect(result, equals(const Right<Failure, void>(null)));
    verify(() => repo.verifyEmail(email: tEmail, otp: tOtp)).called(1);
    verifyNoMoreInteractions(repo);
  });
}
