import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:tv/domain/repositories/tv_repository.dart';

class SaveWatchlistTV {
  final TVRepository repository;

  SaveWatchlistTV(this.repository);

  Future<Either<Failure, String>> execute(TVSeriesDetail tv) {
    return repository.saveWatchlist(tv);
  }
}

typedef SaveWatchlistTv = SaveWatchlistTV;
