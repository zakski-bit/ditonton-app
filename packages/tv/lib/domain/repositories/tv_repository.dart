import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

abstract class TVRepository {
  Future<Either<Failure, List<TVSeries>>> getOnTheAirTvSeries();
  Future<Either<Failure, List<TVSeries>>> getPopularTvSeries();
  Future<Either<Failure, List<TVSeries>>> getTopRatedTvSeries();
  Future<Either<Failure, TVSeriesDetail>> getTvSeriesDetail(int id);
  Future<Either<Failure, List<TVSeries>>> getTvSeriesRecommendations(int id);
  Future<Either<Failure, List<TVSeries>>> searchTvSeries(String query);
  Future<Either<Failure, String>> saveWatchlist(TVSeriesDetail tv);
  Future<Either<Failure, String>> removeWatchlist(TVSeriesDetail tv);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<TVSeries>>> getWatchlistTvSeries();
}

typedef TvRepository = TVRepository;
