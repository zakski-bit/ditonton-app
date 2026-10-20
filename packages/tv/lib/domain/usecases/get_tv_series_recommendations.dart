import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:tv/domain/repositories/tv_repository.dart';

class GetTvSeriesRecommendations {
  final TvRepository repository;

  GetTvSeriesRecommendations(this.repository);

  Future<Either<Failure, List<TvSeries>>> execute(int id) {
    return repository.getTvSeriesRecommendations(id);
  }
}
