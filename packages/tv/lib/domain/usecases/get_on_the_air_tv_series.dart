import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:tv/domain/repositories/tv_repository.dart';

class GetOnTheAirTVSeries {
  final TVRepository repository;

  GetOnTheAirTVSeries(this.repository);

  Future<Either<Failure, List<TVSeries>>> execute() {
    return repository.getOnTheAirTvSeries();
  }
}

typedef GetOnTheAirTvSeries = GetOnTheAirTVSeries;
