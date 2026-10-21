import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/tv.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTvSeriesDetailBloc
    extends MockBloc<TvSeriesDetailEvent, TvSeriesDetailState>
    implements TvSeriesDetailBloc {}

class MockTvSeriesRecommendationsBloc
    extends MockBloc<TvSeriesRecommendationsEvent, TvSeriesRecommendationsState>
    implements TvSeriesRecommendationsBloc {}

class MockWatchlistTvSeriesBloc
    extends MockBloc<WatchlistTvSeriesEvent, WatchlistTvSeriesState>
    implements WatchlistTvSeriesBloc {}

void main() {
  late MockTvSeriesDetailBloc mockTvSeriesDetailBloc;
  late MockTvSeriesRecommendationsBloc mockTvSeriesRecommendationsBloc;
  late MockWatchlistTvSeriesBloc mockWatchlistTvSeriesBloc;

  setUp(() {
    mockTvSeriesDetailBloc = MockTvSeriesDetailBloc();
    mockTvSeriesRecommendationsBloc = MockTvSeriesRecommendationsBloc();
    mockWatchlistTvSeriesBloc = MockWatchlistTvSeriesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TvSeriesDetailBloc>.value(value: mockTvSeriesDetailBloc),
        BlocProvider<TvSeriesRecommendationsBloc>.value(
          value: mockTvSeriesRecommendationsBloc,
        ),
        BlocProvider<WatchlistTvSeriesBloc>.value(
          value: mockWatchlistTvSeriesBloc,
        ),
      ],
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display progress bar when detail is loading', (
    WidgetTester tester,
  ) async {
    when(() => mockTvSeriesDetailBloc.state)
        .thenReturn(TvSeriesDetailLoading());
    when(() => mockTvSeriesRecommendationsBloc.state)
        .thenReturn(TvSeriesRecommendationsLoading());
    when(() => mockWatchlistTvSeriesBloc.state)
        .thenReturn(const WatchlistTvSeriesState());

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(
      makeTestableWidget(const TvSeriesDetailPage(id: 1)),
    );

    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display error text when detail request failed', (
    WidgetTester tester,
  ) async {
    when(() => mockTvSeriesDetailBloc.state)
        .thenReturn(const TvSeriesDetailError('Error message'));
    when(() => mockTvSeriesRecommendationsBloc.state)
        .thenReturn(TvSeriesRecommendationsEmpty());
    when(() => mockWatchlistTvSeriesBloc.state)
        .thenReturn(const WatchlistTvSeriesState());

    final textFinder = find.text('Error message');

    await tester.pumpWidget(
      makeTestableWidget(const TvSeriesDetailPage(id: 1)),
    );

    expect(textFinder, findsOneWidget);
  });

  testWidgets(
    'Watchlist button should display add icon when tv series not added to watchlist',
    (WidgetTester tester) async {
      when(() => mockTvSeriesDetailBloc.state)
          .thenReturn(TvSeriesDetailLoaded(testTvDetail));
      when(() => mockTvSeriesRecommendationsBloc.state)
          .thenReturn(const TvSeriesRecommendationsLoaded(<TvSeries>[]));
      when(() => mockWatchlistTvSeriesBloc.state)
          .thenReturn(const WatchlistTvSeriesState(isAddedToWatchlist: false));

      final watchlistButtonIcon = find.byIcon(Icons.add);

      await tester.pumpWidget(
        makeTestableWidget(const TvSeriesDetailPage(id: 1)),
      );

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display check icon when tv series is added to watchlist',
    (WidgetTester tester) async {
      when(() => mockTvSeriesDetailBloc.state)
          .thenReturn(TvSeriesDetailLoaded(testTvDetail));
      when(() => mockTvSeriesRecommendationsBloc.state)
          .thenReturn(const TvSeriesRecommendationsLoaded(<TvSeries>[]));
      when(() => mockWatchlistTvSeriesBloc.state)
          .thenReturn(const WatchlistTvSeriesState(isAddedToWatchlist: true));

      final watchlistButtonIcon = find.byIcon(Icons.check);

      await tester.pumpWidget(
        makeTestableWidget(const TvSeriesDetailPage(id: 1)),
      );

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display Snackbar when added to watchlist',
    (WidgetTester tester) async {
      when(() => mockTvSeriesDetailBloc.state)
          .thenReturn(TvSeriesDetailLoaded(testTvDetail));
      when(() => mockTvSeriesRecommendationsBloc.state)
          .thenReturn(const TvSeriesRecommendationsLoaded(<TvSeries>[]));

      whenListen(
        mockWatchlistTvSeriesBloc,
        Stream.fromIterable([
          const WatchlistTvSeriesState(
            isAddedToWatchlist: false,
            watchlistMessage: '',
          ),
          const WatchlistTvSeriesState(
            isAddedToWatchlist: true,
            watchlistMessage: WatchlistTvSeriesState.watchlistAddSuccessMessage,
          ),
        ]),
        initialState: const WatchlistTvSeriesState(
          isAddedToWatchlist: false,
          watchlistMessage: '',
        ),
      );

      await tester.pumpWidget(
        makeTestableWidget(const TvSeriesDetailPage(id: 1)),
      );
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text(WatchlistTvSeriesState.watchlistAddSuccessMessage),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Watchlist button should display AlertDialog when add to watchlist failed',
    (WidgetTester tester) async {
      when(() => mockTvSeriesDetailBloc.state)
          .thenReturn(TvSeriesDetailLoaded(testTvDetail));
      when(() => mockTvSeriesRecommendationsBloc.state)
          .thenReturn(const TvSeriesRecommendationsLoaded(<TvSeries>[]));

      whenListen(
        mockWatchlistTvSeriesBloc,
        Stream.fromIterable([
          const WatchlistTvSeriesState(
            isAddedToWatchlist: false,
            watchlistMessage: '',
          ),
          const WatchlistTvSeriesState(
            isAddedToWatchlist: false,
            watchlistMessage: 'Failed to Add',
          ),
        ]),
        initialState: const WatchlistTvSeriesState(
          isAddedToWatchlist: false,
          watchlistMessage: '',
        ),
      );

      await tester.pumpWidget(
        makeTestableWidget(const TvSeriesDetailPage(id: 1)),
      );
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Failed to Add'), findsOneWidget);
    },
  );

  testWidgets(
    'Page should display progress bar when recommendations is loading',
    (WidgetTester tester) async {
      when(() => mockTvSeriesDetailBloc.state)
          .thenReturn(TvSeriesDetailLoaded(testTvDetail));
      when(() => mockTvSeriesRecommendationsBloc.state)
          .thenReturn(TvSeriesRecommendationsLoading());
      when(() => mockWatchlistTvSeriesBloc.state)
          .thenReturn(const WatchlistTvSeriesState());

      await tester.pumpWidget(
        makeTestableWidget(const TvSeriesDetailPage(id: 1)),
      );

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    },
  );

  testWidgets('Page should display error text when recommendations failed', (
    WidgetTester tester,
  ) async {
    when(() => mockTvSeriesDetailBloc.state)
        .thenReturn(TvSeriesDetailLoaded(testTvDetail));
    when(
      () => mockTvSeriesRecommendationsBloc.state,
    ).thenReturn(const TvSeriesRecommendationsError('Error recommendations'));
    when(() => mockWatchlistTvSeriesBloc.state)
        .thenReturn(const WatchlistTvSeriesState());

    await tester.pumpWidget(
      makeTestableWidget(const TvSeriesDetailPage(id: 1)),
    );

    expect(find.text('Error recommendations'), findsOneWidget);
  });

  testWidgets('Page should display recommendations when loaded', (
    WidgetTester tester,
  ) async {
    when(() => mockTvSeriesDetailBloc.state)
        .thenReturn(TvSeriesDetailLoaded(testTvDetail));
    when(() => mockTvSeriesRecommendationsBloc.state)
        .thenReturn(TvSeriesRecommendationsLoaded(testTvList));
    when(() => mockWatchlistTvSeriesBloc.state)
        .thenReturn(const WatchlistTvSeriesState());

    await tester.pumpWidget(
      makeTestableWidget(const TvSeriesDetailPage(id: 1)),
    );

    expect(find.byType(ListView), findsWidgets);
    expect(find.text('Seasons'), findsOneWidget);
    expect(find.text('Season 1'), findsOneWidget);
  });
}
