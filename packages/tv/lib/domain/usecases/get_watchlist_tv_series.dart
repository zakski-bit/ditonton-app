import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:tv/domain/repositories/tv_repository.dart';

class GetWatchlistTVSeries {
  final TVRepository repository;

  GetWatchlistTVSeries(this.repository);

  Future<Either<Failure, List<TVSeries>>> execute() {
    return repository.getWatchlistTvSeries();
  }
}

typedef GetWatchlistTvSeries = GetWatchlistTVSeries;
