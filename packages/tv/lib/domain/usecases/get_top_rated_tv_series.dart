import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:tv/domain/repositories/tv_repository.dart';

class GetTopRatedTVSeries {
  final TVRepository repository;

  GetTopRatedTVSeries(this.repository);

  Future<Either<Failure, List<TVSeries>>> execute() {
    return repository.getTopRatedTvSeries();
  }
}

typedef GetTopRatedTvSeries = GetTopRatedTVSeries;
