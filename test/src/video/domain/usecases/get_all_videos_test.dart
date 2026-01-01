import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itube/core/errors/failures.dart';
import 'package:itube/src/video/domain/entities/video.dart';
import 'package:itube/src/video/domain/repositories/video_repository.dart';
import 'package:itube/src/video/domain/usecases/get_all_videos.dart';
import 'package:mocktail/mocktail.dart';

import 'video_repo.mock.dart';

void main() {
  late VideoRepo repo;
  late GetAllVideos usecase;
  const tResult = <Video>[];
  setUp(() {
    repo = MockVideoRepo();
    usecase = GetAllVideos(repo);
  });
  test('should call the [VideoRepo.getAllVideos]', () async {
    when(
      () => repo.getAllVideos(),
    ).thenAnswer((_) async => const Right(tResult));
    final result = await usecase();
    expect(result, equals(const Right<Failure, List<Video>>(tResult)));
    verify(() => repo.getAllVideos()).called(1);
    verifyNoMoreInteractions(repo);
  });
}
