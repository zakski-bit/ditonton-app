import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/tv.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetPopularTvSeries extends Mock implements GetPopularTvSeries {}

void main() {
  late PopularTvSeriesBloc popularTvSeriesBloc;
  late MockGetPopularTvSeries mockGetPopularTvSeries;

  setUp(() {
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    popularTvSeriesBloc =
        PopularTvSeriesBloc(getPopularTvSeries: mockGetPopularTvSeries);
  });

  test('initial state should be empty', () {
    expect(popularTvSeriesBloc.state, PopularTvSeriesEmpty());
  });

  blocTest<PopularTvSeriesBloc, PopularTvSeriesState>(
    'should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(() => mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Right(testTvList));
      return popularTvSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchPopularTvSeries()),
    expect: () => [
      PopularTvSeriesLoading(),
      PopularTvSeriesLoaded(testTvList),
    ],
    verify: (bloc) {
      verify(() => mockGetPopularTvSeries.execute()).called(1);
    },
  );

  blocTest<PopularTvSeriesBloc, PopularTvSeriesState>(
    'should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(() => mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularTvSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchPopularTvSeries()),
    expect: () => [
      PopularTvSeriesLoading(),
      const PopularTvSeriesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(() => mockGetPopularTvSeries.execute()).called(1);
    },
  );
}
