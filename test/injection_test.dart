import 'package:ditonton/injection.dart' as di;
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/movie.dart';
import 'package:search/search.dart';
import 'package:tv/tv.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    di.locator.reset();
    di.init();
  });

  tearDown(() {
    di.locator.reset();
  });

  group('Dependency Injection', () {
    test('should resolve Movie BLoCs successfully', () {
      expect(di.locator<NowPlayingMoviesBloc>(), isNotNull);
      expect(di.locator<PopularMoviesBloc>(), isNotNull);
      expect(di.locator<TopRatedMoviesBloc>(), isNotNull);
      expect(di.locator<MovieDetailBloc>(), isNotNull);
      expect(di.locator<MovieRecommendationsBloc>(), isNotNull);
      expect(di.locator<WatchlistMovieBloc>(), isNotNull);
    });

    test('should resolve TV Series BLoCs successfully', () {
      expect(di.locator<OnTheAirTvSeriesBloc>(), isNotNull);
      expect(di.locator<PopularTvSeriesBloc>(), isNotNull);
      expect(di.locator<TopRatedTvSeriesBloc>(), isNotNull);
      expect(di.locator<TvSeriesDetailBloc>(), isNotNull);
      expect(di.locator<TvSeriesRecommendationsBloc>(), isNotNull);
      expect(di.locator<WatchlistTvSeriesBloc>(), isNotNull);
    });

    test('should resolve Search BLoCs successfully', () {
      expect(di.locator<MovieSearchBloc>(), isNotNull);
      expect(di.locator<TvSearchBloc>(), isNotNull);
    });

    test('should resolve Repositories and Data Sources successfully', () {
      expect(di.locator<MovieRepository>(), isNotNull);
      expect(di.locator<TvRepository>(), isNotNull);
      expect(di.locator<MovieRemoteDataSource>(), isNotNull);
      expect(di.locator<MovieLocalDataSource>(), isNotNull);
      expect(di.locator<TvRemoteDataSource>(), isNotNull);
      expect(di.locator<TvLocalDataSource>(), isNotNull);
    });
  });
}
