import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:tv/domain/repositories/tv_repository.dart';

class GetTvSeriesDetail {
  final TvRepository repository;

  GetTvSeriesDetail(this.repository);

  Future<Either<Failure, TvSeriesDetail>> execute(int id) {
    return repository.getTvSeriesDetail(id);
  }
}
