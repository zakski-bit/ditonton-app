import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/tv.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetWatchlistTvSeries extends Mock implements GetWatchlistTvSeries {}

class MockGetWatchlistStatusTv extends Mock implements GetWatchlistStatusTv {}

class MockSaveWatchlistTv extends Mock implements SaveWatchlistTv {}

class MockRemoveWatchlistTv extends Mock implements RemoveWatchlistTv {}

void main() {
  late WatchlistTvSeriesBloc watchlistTvSeriesBloc;
  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;
  late MockGetWatchlistStatusTv mockGetWatchlistStatusTv;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late MockRemoveWatchlistTv mockRemoveWatchlistTv;

  setUp(() {
    mockGetWatchlistTvSeries = MockGetWatchlistTvSeries();
    mockGetWatchlistStatusTv = MockGetWatchlistStatusTv();
    mockSaveWatchlistTv = MockSaveWatchlistTv();
    mockRemoveWatchlistTv = MockRemoveWatchlistTv();
    watchlistTvSeriesBloc = WatchlistTvSeriesBloc(
      getWatchlistTvSeries: mockGetWatchlistTvSeries,
      getWatchListStatusTv: mockGetWatchlistStatusTv,
      saveWatchlistTv: mockSaveWatchlistTv,
      removeWatchlistTv: mockRemoveWatchlistTv,
    );
  });

  const tId = 1;

  test('initial state should be empty / default WatchlistTvSeriesState', () {
    expect(watchlistTvSeriesBloc.state, const WatchlistTvSeriesState());
  });

  group('FetchWatchlistTvSeries', () {
    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emit [Loading, Loaded] when watchlist TV series are fetched successfully',
      build: () {
        when(() => mockGetWatchlistTvSeries.execute())
            .thenAnswer((_) async => Right(testTvList));
        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistTvSeries()),
      expect: () => [
        const WatchlistTvSeriesState(watchlistState: RequestState.Loading),
        WatchlistTvSeriesState(
          watchlistState: RequestState.Loaded,
          watchlistTvSeries: testTvList,
        ),
      ],
      verify: (bloc) {
        verify(() => mockGetWatchlistTvSeries.execute()).called(1);
      },
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emit [Loading, Error] when fetching watchlist TV series fails',
      build: () {
        when(() => mockGetWatchlistTvSeries.execute())
            .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistTvSeries()),
      expect: () => [
        const WatchlistTvSeriesState(watchlistState: RequestState.Loading),
        const WatchlistTvSeriesState(
          watchlistState: RequestState.Error,
          message: 'Database Failure',
        ),
      ],
      verify: (bloc) {
        verify(() => mockGetWatchlistTvSeries.execute()).called(1);
      },
    );
  });

  group('LoadWatchlistTvSeriesStatus', () {
    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emit state with isAddedToWatchlist: true when TV is in watchlist',
      build: () {
        when(() => mockGetWatchlistStatusTv.execute(tId))
            .thenAnswer((_) async => true);
        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistTvSeriesStatus(tId)),
      expect: () => [
        const WatchlistTvSeriesState(isAddedToWatchlist: true),
      ],
      verify: (bloc) {
        verify(() => mockGetWatchlistStatusTv.execute(tId)).called(1);
      },
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emit state with isAddedToWatchlist: false when TV is not in watchlist',
      build: () {
        when(() => mockGetWatchlistStatusTv.execute(tId))
            .thenAnswer((_) async => false);
        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistTvSeriesStatus(tId)),
      expect: () => [
        const WatchlistTvSeriesState(isAddedToWatchlist: false),
      ],
      verify: (bloc) {
        verify(() => mockGetWatchlistStatusTv.execute(tId)).called(1);
      },
    );
  });

  group('AddWatchlistTvSeries', () {
    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emit state with watchlistMessage and isAddedToWatchlist: true when save success',
      build: () {
        when(() => mockSaveWatchlistTv.execute(testTvDetail))
            .thenAnswer((_) async => const Right(WatchlistTvSeriesState.watchlistAddSuccessMessage));
        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(AddWatchlistTvSeries(testTvDetail)),
      expect: () => [
        const WatchlistTvSeriesState(
          watchlistMessage: WatchlistTvSeriesState.watchlistAddSuccessMessage,
          isAddedToWatchlist: true,
        ),
      ],
      verify: (bloc) {
        verify(() => mockSaveWatchlistTv.execute(testTvDetail)).called(1);
      },
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emit state with watchlistMessage failure when save failed',
      build: () {
        when(() => mockSaveWatchlistTv.execute(testTvDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed to Add')));
        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(AddWatchlistTvSeries(testTvDetail)),
      expect: () => [
        const WatchlistTvSeriesState(
          watchlistMessage: 'Failed to Add',
          isAddedToWatchlist: false,
        ),
      ],
      verify: (bloc) {
        verify(() => mockSaveWatchlistTv.execute(testTvDetail)).called(1);
      },
    );
  });

  group('RemoveWatchlistTvSeries', () {
    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emit state with watchlistMessage and isAddedToWatchlist: false when remove success',
      build: () {
        when(() => mockRemoveWatchlistTv.execute(testTvDetail))
            .thenAnswer((_) async => const Right(WatchlistTvSeriesState.watchlistRemoveSuccessMessage));
        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(RemoveWatchlistTvSeries(testTvDetail)),
      expect: () => [
        const WatchlistTvSeriesState(
          watchlistMessage: WatchlistTvSeriesState.watchlistRemoveSuccessMessage,
          isAddedToWatchlist: false,
        ),
      ],
      verify: (bloc) {
        verify(() => mockRemoveWatchlistTv.execute(testTvDetail)).called(1);
      },
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emit state with watchlistMessage failure when remove failed',
      build: () {
        when(() => mockRemoveWatchlistTv.execute(testTvDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed to Remove')));
        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(RemoveWatchlistTvSeries(testTvDetail)),
      expect: () => [
        const WatchlistTvSeriesState(
          watchlistMessage: 'Failed to Remove',
          isAddedToWatchlist: false,
        ),
      ],
      verify: (bloc) {
        verify(() => mockRemoveWatchlistTv.execute(testTvDetail)).called(1);
      },
    );
  });
}
