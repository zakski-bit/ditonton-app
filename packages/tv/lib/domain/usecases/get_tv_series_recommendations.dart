import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:tv/domain/repositories/tv_repository.dart';

class GetTVSeriesRecommendations {
  final TVRepository repository;

  GetTVSeriesRecommendations(this.repository);

  Future<Either<Failure, List<TVSeries>>> execute(int id) {
    return repository.getTvSeriesRecommendations(id);
  }
}

typedef GetTvSeriesRecommendations = GetTVSeriesRecommendations;
