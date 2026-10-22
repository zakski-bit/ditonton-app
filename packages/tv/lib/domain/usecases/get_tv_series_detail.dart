import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:tv/domain/repositories/tv_repository.dart';

class GetTVSeriesDetail {
  final TVRepository repository;

  GetTVSeriesDetail(this.repository);

  Future<Either<Failure, TVSeriesDetail>> execute(int id) {
    return repository.getTvSeriesDetail(id);
  }
}

typedef GetTvSeriesDetail = GetTVSeriesDetail;
