import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';
import 'package:tv/tv.dart';
import 'package:watchlist/watchlist.dart';

class MockWatchlistMovieBloc
    extends MockBloc<WatchlistMovieEvent, WatchlistMovieState>
    implements WatchlistMovieBloc {}

class MockWatchlistTvSeriesBloc
    extends MockBloc<WatchlistTvSeriesEvent, WatchlistTvSeriesState>
    implements WatchlistTvSeriesBloc {}

void main() {
  late MockWatchlistMovieBloc mockWatchlistMovieBloc;
  late MockWatchlistTvSeriesBloc mockWatchlistTvSeriesBloc;

  setUp(() {
    mockWatchlistMovieBloc = MockWatchlistMovieBloc();
    mockWatchlistTvSeriesBloc = MockWatchlistTvSeriesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WatchlistMovieBloc>.value(value: mockWatchlistMovieBloc),
        BlocProvider<WatchlistTvSeriesBloc>.value(
          value: mockWatchlistTvSeriesBloc,
        ),
      ],
      child: MaterialApp(home: body),
    );
  }

  final tMovie = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: const [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview: 'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tTvSeries = TvSeries(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: const [14, 28],
    id: 1,
    originalName: 'Game of Thrones',
    overview: 'Seven noble families fight for control of the mythical land of Westeros.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    firstAirDate: '2011-04-17',
    name: 'Game of Thrones',
    voteAverage: 8.4,
    voteCount: 13507,
  );

  testWidgets('Page should display center progress bar when loading movies', (
    WidgetTester tester,
  ) async {
    when(() => mockWatchlistMovieBloc.state).thenReturn(
      const WatchlistMovieState(watchlistState: RequestState.Loading),
    );
    when(() => mockWatchlistTvSeriesBloc.state).thenReturn(
      const WatchlistTvSeriesState(watchlistState: RequestState.Empty),
    );

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(makeTestableWidget(const WatchlistPage()));

    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets(
    'Page should display ListView and MovieCard when movies are loaded',
    (WidgetTester tester) async {
      when(() => mockWatchlistMovieBloc.state).thenReturn(
        WatchlistMovieState(
          watchlistState: RequestState.Loaded,
          watchlistMovies: [tMovie],
        ),
      );
      when(() => mockWatchlistTvSeriesBloc.state).thenReturn(
        const WatchlistTvSeriesState(watchlistState: RequestState.Empty),
      );

      final listViewFinder = find.byType(ListView);
      final movieCardFinder = find.byType(MovieCard);

      await tester.pumpWidget(makeTestableWidget(const WatchlistPage()));

      expect(listViewFinder, findsOneWidget);
      expect(movieCardFinder, findsOneWidget);
    },
  );

  testWidgets('Page should display error text when movies fail to load', (
    WidgetTester tester,
  ) async {
    when(() => mockWatchlistMovieBloc.state).thenReturn(
      const WatchlistMovieState(
        watchlistState: RequestState.Error,
        message: 'Error message',
      ),
    );
    when(() => mockWatchlistTvSeriesBloc.state).thenReturn(
      const WatchlistTvSeriesState(watchlistState: RequestState.Empty),
    );

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const WatchlistPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets(
    'Page should display ListView and TvSeriesCard when TV series loaded',
    (WidgetTester tester) async {
      when(() => mockWatchlistMovieBloc.state).thenReturn(
        const WatchlistMovieState(watchlistState: RequestState.Empty),
      );
      when(() => mockWatchlistTvSeriesBloc.state).thenReturn(
        WatchlistTvSeriesState(
          watchlistState: RequestState.Loaded,
          watchlistTvSeries: [tTvSeries],
        ),
      );

      await tester.pumpWidget(makeTestableWidget(const WatchlistPage()));

      // Tap on TV Series tab
      await tester.tap(find.text('TV Series'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      final listViewFinder = find.byType(ListView);
      final tvCardFinder = find.byType(TvSeriesCard);

      expect(listViewFinder, findsOneWidget);
      expect(tvCardFinder, findsOneWidget);
    },
  );

  testWidgets('Page should display error text when TV series fail to load', (
    WidgetTester tester,
  ) async {
    when(
      () => mockWatchlistMovieBloc.state,
    ).thenReturn(const WatchlistMovieState(watchlistState: RequestState.Empty));
    when(() => mockWatchlistTvSeriesBloc.state).thenReturn(
      const WatchlistTvSeriesState(
        watchlistState: RequestState.Error,
        message: 'Error message TV',
      ),
    );

    await tester.pumpWidget(makeTestableWidget(const WatchlistPage()));

    // Tap on TV Series tab
    await tester.tap(find.text('TV Series'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final textFinder = find.byKey(const Key('error_message_tv'));

    expect(textFinder, findsOneWidget);
  });
}
