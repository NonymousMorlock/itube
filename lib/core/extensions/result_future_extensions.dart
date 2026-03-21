import 'package:dartz/dartz.dart';
import 'package:itube/core/typedefs.dart';

extension ResultFutureExtensions<L, R> on ResultFuture<R> {
  /// Chains a new `Future<Either>` only if the previous
  /// one was Right (Success).
  ///
  /// If the previous one was Left, it immediately returns Left.
  ResultFuture<NewR> thenRight<NewR>(
    ResultFuture<NewR> Function(R value) callback,
  ) async {
    final result = await this;
    return result.fold(Left.new, (r) => callback(r));
  }
}
