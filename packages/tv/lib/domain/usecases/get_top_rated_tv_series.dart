import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:tv/domain/repositories/tv_repository.dart';

class GetTopRatedTvSeries {
  final TvRepository repository;

  GetTopRatedTvSeries(this.repository);

  Future<Either<Failure, List<TvSeries>>> execute() {
    return repository.getTopRatedTvSeries();
  }
}
