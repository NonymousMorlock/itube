import 'package:itube/core/typedefs.dart';
import 'package:itube/core/usecases/usecase.dart';
import 'package:itube/src/video/domain/entities/video.dart';
import 'package:itube/src/video/domain/repositories/video_repository.dart';

class GetAllVideos implements UsecaseWithoutParams<List<Video>> {
  const GetAllVideos(this._repo);

  final VideoRepo _repo;

  @override
  ResultFuture<List<Video>> call() {
    return _repo.getAllVideos();
  }
}
