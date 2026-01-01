import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itube/core/errors/failures.dart';
import 'package:itube/src/video/domain/entities/video.dart';
import 'package:itube/src/video/domain/repositories/video_repository.dart';
import 'package:itube/src/video/domain/usecases/get_video_by_id.dart';
import 'package:mocktail/mocktail.dart';

import 'video_repo.mock.dart';

void main() {
  late VideoRepo repo;
  late GetVideoById usecase;
  const tId = 'Test String';
  final tResult = Video.empty();
  setUp(() {
    repo = MockVideoRepo();
    usecase = GetVideoById(repo);
  });
  test('should call the [VideoRepo.getVideoById]', () async {
    when(
      () => repo.getVideoById(id: any<String>(named: 'id')),
    ).thenAnswer((_) async => Right(tResult));
    final result = await usecase(tId);
    expect(result, equals(Right<Failure, Video>(tResult)));
    verify(() => repo.getVideoById(id: tId)).called(1);
    verifyNoMoreInteractions(repo);
  });
}
