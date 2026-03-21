import 'package:itube/core/typedefs.dart';
import 'package:itube/core/usecases/usecase.dart';
import 'package:itube/src/video/domain/entities/video.dart';
import 'package:itube/src/video/domain/repositories/video_repository.dart';

class GetVideoById implements UsecaseWithParams<Video, String> {
  const GetVideoById(this._repo);

  final VideoRepo _repo;

  @override
  ResultFuture<Video> call(String params) {
    return _repo.getVideoById(id: params);
  }
}
