import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/tv.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetTopRatedTvSeries extends Mock implements GetTopRatedTvSeries {}

void main() {
  late TopRatedTvSeriesBloc topRatedTvSeriesBloc;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;

  setUp(() {
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    topRatedTvSeriesBloc =
        TopRatedTvSeriesBloc(getTopRatedTvSeries: mockGetTopRatedTvSeries);
  });

  test('initial state should be empty', () {
    expect(topRatedTvSeriesBloc.state, TopRatedTvSeriesEmpty());
  });

  blocTest<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
    'should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(() => mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Right(testTvList));
      return topRatedTvSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTvSeries()),
    expect: () => [
      TopRatedTvSeriesLoading(),
      TopRatedTvSeriesLoaded(testTvList),
    ],
    verify: (bloc) {
      verify(() => mockGetTopRatedTvSeries.execute()).called(1);
    },
  );

  blocTest<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
    'should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(() => mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return topRatedTvSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTvSeries()),
    expect: () => [
      TopRatedTvSeriesLoading(),
      const TopRatedTvSeriesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(() => mockGetTopRatedTvSeries.execute()).called(1);
    },
  );
}
