import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/tv.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetTvSeriesRecommendations extends Mock
    implements GetTvSeriesRecommendations {}

void main() {
  late TvSeriesRecommendationsBloc tvSeriesRecommendationsBloc;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;

  setUp(() {
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    tvSeriesRecommendationsBloc = TvSeriesRecommendationsBloc(
      getTvSeriesRecommendations: mockGetTvSeriesRecommendations,
    );
  });

  const tId = 1;

  test('initial state should be empty', () {
    expect(tvSeriesRecommendationsBloc.state, TvSeriesRecommendationsEmpty());
  });

  blocTest<TvSeriesRecommendationsBloc, TvSeriesRecommendationsState>(
    'should emit [Loading, Loaded] when recommendations are gotten successfully',
    build: () {
      when(() => mockGetTvSeriesRecommendations.execute(tId))
          .thenAnswer((_) async => Right(testTvList));
      return tvSeriesRecommendationsBloc;
    },
    act: (bloc) => bloc.add(const FetchTvSeriesRecommendations(tId)),
    expect: () => [
      TvSeriesRecommendationsLoading(),
      TvSeriesRecommendationsLoaded(testTvList),
    ],
    verify: (bloc) {
      verify(() => mockGetTvSeriesRecommendations.execute(tId)).called(1);
    },
  );

  blocTest<TvSeriesRecommendationsBloc, TvSeriesRecommendationsState>(
    'should emit [Loading, Error] when get recommendations is unsuccessful',
    build: () {
      when(() => mockGetTvSeriesRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvSeriesRecommendationsBloc;
    },
    act: (bloc) => bloc.add(const FetchTvSeriesRecommendations(tId)),
    expect: () => [
      TvSeriesRecommendationsLoading(),
      const TvSeriesRecommendationsError('Server Failure'),
    ],
    verify: (bloc) {
      verify(() => mockGetTvSeriesRecommendations.execute(tId)).called(1);
    },
  );
}
