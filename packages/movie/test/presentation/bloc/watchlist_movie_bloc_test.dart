import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetWatchlistMovies extends Mock implements GetWatchlistMovies {}

class MockGetWatchListStatus extends Mock implements GetWatchListStatus {}

class MockSaveWatchlist extends Mock implements SaveWatchlist {}

class MockRemoveWatchlist extends Mock implements RemoveWatchlist {}

void main() {
  late WatchlistMovieBloc watchlistMovieBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    watchlistMovieBloc = WatchlistMovieBloc(
      getWatchlistMovies: mockGetWatchlistMovies,
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  const tId = 1;

  test('initial state should be empty / default WatchlistMovieState', () {
    expect(watchlistMovieBloc.state, const WatchlistMovieState());
  });

  group('FetchWatchlistMovies', () {
    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should emit [Loading, Loaded] when watchlist movies are fetched successfully',
      build: () {
        when(() => mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistMovies()),
      expect: () => [
        const WatchlistMovieState(watchlistState: RequestState.Loading),
        WatchlistMovieState(
          watchlistState: RequestState.Loaded,
          watchlistMovies: testMovieList,
        ),
      ],
      verify: (bloc) {
        verify(() => mockGetWatchlistMovies.execute()).called(1);
      },
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should emit [Loading, Error] when fetching watchlist movies fails',
      build: () {
        when(() => mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistMovies()),
      expect: () => [
        const WatchlistMovieState(watchlistState: RequestState.Loading),
        const WatchlistMovieState(
          watchlistState: RequestState.Error,
          message: 'Database Failure',
        ),
      ],
      verify: (bloc) {
        verify(() => mockGetWatchlistMovies.execute()).called(1);
      },
    );
  });

  group('LoadWatchlistMovieStatus', () {
    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should emit state with isAddedToWatchlist: true when movie is in watchlist',
      build: () {
        when(() => mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => true);
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistMovieStatus(tId)),
      expect: () => [const WatchlistMovieState(isAddedToWatchlist: true)],
      verify: (bloc) {
        verify(() => mockGetWatchListStatus.execute(tId)).called(1);
      },
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should emit state with isAddedToWatchlist: false when movie is not in watchlist',
      build: () {
        when(() => mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => false);
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistMovieStatus(tId)),
      expect: () => [const WatchlistMovieState(isAddedToWatchlist: false)],
      verify: (bloc) {
        verify(() => mockGetWatchListStatus.execute(tId)).called(1);
      },
    );
  });

  group('AddWatchlistMovie', () {
    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should emit state with watchlistMessage and isAddedToWatchlist: true when save success',
      build: () {
        when(() => mockSaveWatchlist.execute(testMovieDetail)).thenAnswer(
          (_) async =>
              const Right(WatchlistMovieState.watchlistAddSuccessMessage),
        );
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(AddWatchlistMovie(testMovieDetail)),
      expect: () => [
        const WatchlistMovieState(
          watchlistMessage: WatchlistMovieState.watchlistAddSuccessMessage,
          isAddedToWatchlist: true,
        ),
      ],
      verify: (bloc) {
        verify(() => mockSaveWatchlist.execute(testMovieDetail)).called(1);
      },
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should emit state with watchlistMessage failure when save failed',
      build: () {
        when(() => mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed to Add')));
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(AddWatchlistMovie(testMovieDetail)),
      expect: () => [
        const WatchlistMovieState(
          watchlistMessage: 'Failed to Add',
          isAddedToWatchlist: false,
        ),
      ],
      verify: (bloc) {
        verify(() => mockSaveWatchlist.execute(testMovieDetail)).called(1);
      },
    );
  });

  group('RemoveWatchlistMovie', () {
    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should emit state with watchlistMessage and isAddedToWatchlist: false when remove success',
      build: () {
        when(() => mockRemoveWatchlist.execute(testMovieDetail)).thenAnswer(
          (_) async =>
              const Right(WatchlistMovieState.watchlistRemoveSuccessMessage),
        );
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(RemoveWatchlistMovie(testMovieDetail)),
      expect: () => [
        const WatchlistMovieState(
          watchlistMessage: WatchlistMovieState.watchlistRemoveSuccessMessage,
          isAddedToWatchlist: false,
        ),
      ],
      verify: (bloc) {
        verify(() => mockRemoveWatchlist.execute(testMovieDetail)).called(1);
      },
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should emit state with watchlistMessage failure when remove failed',
      build: () {
        when(() => mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed to Remove')));
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(RemoveWatchlistMovie(testMovieDetail)),
      expect: () => [
        const WatchlistMovieState(
          watchlistMessage: 'Failed to Remove',
          isAddedToWatchlist: false,
        ),
      ],
      verify: (bloc) {
        verify(() => mockRemoveWatchlist.execute(testMovieDetail)).called(1);
      },
    );
  });
}
