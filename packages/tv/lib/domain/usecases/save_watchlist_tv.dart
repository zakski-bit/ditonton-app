import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:tv/domain/repositories/tv_repository.dart';

class SaveWatchlistTv {
  final TvRepository repository;

  SaveWatchlistTv(this.repository);

  Future<Either<Failure, String>> execute(TvSeriesDetail tv) {
    return repository.saveWatchlist(tv);
  }
}
