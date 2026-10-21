import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class MockMovieRecommendationsBloc
    extends MockBloc<MovieRecommendationsEvent, MovieRecommendationsState>
    implements MovieRecommendationsBloc {}

class MockWatchlistMovieBloc
    extends MockBloc<WatchlistMovieEvent, WatchlistMovieState>
    implements WatchlistMovieBloc {}

void main() {
  late MockMovieDetailBloc mockMovieDetailBloc;
  late MockMovieRecommendationsBloc mockMovieRecommendationsBloc;
  late MockWatchlistMovieBloc mockWatchlistMovieBloc;

  setUp(() {
    mockMovieDetailBloc = MockMovieDetailBloc();
    mockMovieRecommendationsBloc = MockMovieRecommendationsBloc();
    mockWatchlistMovieBloc = MockWatchlistMovieBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieDetailBloc>.value(value: mockMovieDetailBloc),
        BlocProvider<MovieRecommendationsBloc>.value(
          value: mockMovieRecommendationsBloc,
        ),
        BlocProvider<WatchlistMovieBloc>.value(value: mockWatchlistMovieBloc),
      ],
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display progress bar when detail is loading', (
    WidgetTester tester,
  ) async {
    when(() => mockMovieDetailBloc.state).thenReturn(MovieDetailLoading());
    when(() => mockMovieRecommendationsBloc.state)
        .thenReturn(MovieRecommendationsLoading());
    when(() => mockWatchlistMovieBloc.state)
        .thenReturn(const WatchlistMovieState());

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display error text when detail request failed', (
    WidgetTester tester,
  ) async {
    when(() => mockMovieDetailBloc.state)
        .thenReturn(const MovieDetailError('Error message'));
    when(() => mockMovieRecommendationsBloc.state)
        .thenReturn(MovieRecommendationsEmpty());
    when(() => mockWatchlistMovieBloc.state)
        .thenReturn(const WatchlistMovieState());

    final textFinder = find.text('Error message');

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(textFinder, findsOneWidget);
  });

  testWidgets(
    'Watchlist button should display add icon when movie not added to watchlist',
    (WidgetTester tester) async {
      when(() => mockMovieDetailBloc.state)
          .thenReturn(MovieDetailLoaded(testMovieDetail));
      when(() => mockMovieRecommendationsBloc.state)
          .thenReturn(MovieRecommendationsLoaded(const <Movie>[]));
      when(() => mockWatchlistMovieBloc.state)
          .thenReturn(const WatchlistMovieState(isAddedToWatchlist: false));

      final watchlistButtonIcon = find.byIcon(Icons.add);

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display check icon when movie is added to watchlist',
    (WidgetTester tester) async {
      when(() => mockMovieDetailBloc.state)
          .thenReturn(MovieDetailLoaded(testMovieDetail));
      when(() => mockMovieRecommendationsBloc.state)
          .thenReturn(MovieRecommendationsLoaded(const <Movie>[]));
      when(() => mockWatchlistMovieBloc.state)
          .thenReturn(const WatchlistMovieState(isAddedToWatchlist: true));

      final watchlistButtonIcon = find.byIcon(Icons.check);

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display Snackbar when added to watchlist',
    (WidgetTester tester) async {
      when(() => mockMovieDetailBloc.state)
          .thenReturn(MovieDetailLoaded(testMovieDetail));
      when(() => mockMovieRecommendationsBloc.state)
          .thenReturn(MovieRecommendationsLoaded(const <Movie>[]));

      whenListen(
        mockWatchlistMovieBloc,
        Stream.fromIterable([
          const WatchlistMovieState(
            isAddedToWatchlist: false,
            watchlistMessage: '',
          ),
          const WatchlistMovieState(
            isAddedToWatchlist: true,
            watchlistMessage: WatchlistMovieState.watchlistAddSuccessMessage,
          ),
        ]),
        initialState: const WatchlistMovieState(
          isAddedToWatchlist: false,
          watchlistMessage: '',
        ),
      );

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text(WatchlistMovieState.watchlistAddSuccessMessage),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Watchlist button should display AlertDialog when add to watchlist failed',
    (WidgetTester tester) async {
      when(() => mockMovieDetailBloc.state)
          .thenReturn(MovieDetailLoaded(testMovieDetail));
      when(() => mockMovieRecommendationsBloc.state)
          .thenReturn(MovieRecommendationsLoaded(const <Movie>[]));

      whenListen(
        mockWatchlistMovieBloc,
        Stream.fromIterable([
          const WatchlistMovieState(
            isAddedToWatchlist: false,
            watchlistMessage: '',
          ),
          const WatchlistMovieState(
            isAddedToWatchlist: false,
            watchlistMessage: 'Failed to Add',
          ),
        ]),
        initialState: const WatchlistMovieState(
          isAddedToWatchlist: false,
          watchlistMessage: '',
        ),
      );

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Failed to Add'), findsOneWidget);
    },
  );

  testWidgets(
    'Page should display progress bar when recommendations is loading',
    (WidgetTester tester) async {
      when(() => mockMovieDetailBloc.state)
          .thenReturn(MovieDetailLoaded(testMovieDetail));
      when(() => mockMovieRecommendationsBloc.state)
          .thenReturn(MovieRecommendationsLoading());
      when(() => mockWatchlistMovieBloc.state)
          .thenReturn(const WatchlistMovieState());

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    },
  );

  testWidgets('Page should display error text when recommendations failed', (
    WidgetTester tester,
  ) async {
    when(() => mockMovieDetailBloc.state)
        .thenReturn(MovieDetailLoaded(testMovieDetail));
    when(() => mockMovieRecommendationsBloc.state)
        .thenReturn(const MovieRecommendationsError('Error recommendations'));
    when(() => mockWatchlistMovieBloc.state)
        .thenReturn(const WatchlistMovieState());

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.text('Error recommendations'), findsOneWidget);
  });

  testWidgets('Page should display recommendations when loaded', (
    WidgetTester tester,
  ) async {
    when(() => mockMovieDetailBloc.state)
        .thenReturn(MovieDetailLoaded(testMovieDetail));
    when(() => mockMovieRecommendationsBloc.state)
        .thenReturn(MovieRecommendationsLoaded([testMovie]));
    when(() => mockWatchlistMovieBloc.state)
        .thenReturn(const WatchlistMovieState());

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.byType(ListView), findsWidgets);
  });
}
