import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:tv/tv.dart';

class SearchTVSeries {
  final TVRepository repository;

  SearchTVSeries(this.repository);

  Future<Either<Failure, List<TVSeries>>> execute(String query) {
    return repository.searchTvSeries(query);
  }
}

typedef SearchTvSeries = SearchTVSeries;
