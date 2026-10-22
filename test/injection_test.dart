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
      expect(di.locator<OnTheAirTVSeriesBloc>(), isNotNull);
      expect(di.locator<PopularTVSeriesBloc>(), isNotNull);
      expect(di.locator<TopRatedTVSeriesBloc>(), isNotNull);
      expect(di.locator<TVSeriesDetailBloc>(), isNotNull);
      expect(di.locator<TVSeriesRecommendationsBloc>(), isNotNull);
      expect(di.locator<WatchlistTVSeriesBloc>(), isNotNull);
    });

    test('should resolve Search BLoCs successfully', () {
      expect(di.locator<MovieSearchBloc>(), isNotNull);
      expect(di.locator<TVSearchBloc>(), isNotNull);
    });

    test('should resolve Repositories and Data Sources successfully', () {
      expect(di.locator<MovieRepository>(), isNotNull);
      expect(di.locator<TVRepository>(), isNotNull);
      expect(di.locator<MovieRemoteDataSource>(), isNotNull);
      expect(di.locator<MovieLocalDataSource>(), isNotNull);
      expect(di.locator<TVRemoteDataSource>(), isNotNull);
      expect(di.locator<TVLocalDataSource>(), isNotNull);
    });
  });
}
