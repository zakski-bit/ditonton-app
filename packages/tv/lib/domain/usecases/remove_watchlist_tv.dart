import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:tv/domain/repositories/tv_repository.dart';

class RemoveWatchlistTV {
  final TVRepository repository;

  RemoveWatchlistTV(this.repository);

  Future<Either<Failure, String>> execute(TVSeriesDetail tv) {
    return repository.removeWatchlist(tv);
  }
}

typedef RemoveWatchlistTv = RemoveWatchlistTV;
