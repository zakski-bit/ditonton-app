import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/tv.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetOnTheAirTvSeries extends Mock implements GetOnTheAirTvSeries {}

void main() {
  late OnTheAirTvSeriesBloc onTheAirTvSeriesBloc;
  late MockGetOnTheAirTvSeries mockGetOnTheAirTvSeries;

  setUp(() {
    mockGetOnTheAirTvSeries = MockGetOnTheAirTvSeries();
    onTheAirTvSeriesBloc = OnTheAirTvSeriesBloc(
        getOnTheAirTvSeries: mockGetOnTheAirTvSeries);
  });

  test('initial state should be empty', () {
    expect(onTheAirTvSeriesBloc.state, OnTheAirTvSeriesEmpty());
  });

  blocTest<OnTheAirTvSeriesBloc, OnTheAirTvSeriesState>(
    'should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(() => mockGetOnTheAirTvSeries.execute())
          .thenAnswer((_) async => Right(testTvList));
      return onTheAirTvSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchOnTheAirTvSeries()),
    expect: () => [
      OnTheAirTvSeriesLoading(),
      OnTheAirTvSeriesLoaded(testTvList),
    ],
    verify: (bloc) {
      verify(() => mockGetOnTheAirTvSeries.execute()).called(1);
    },
  );

  blocTest<OnTheAirTvSeriesBloc, OnTheAirTvSeriesState>(
    'should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(() => mockGetOnTheAirTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return onTheAirTvSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchOnTheAirTvSeries()),
    expect: () => [
      OnTheAirTvSeriesLoading(),
      const OnTheAirTvSeriesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(() => mockGetOnTheAirTvSeries.execute()).called(1);
    },
  );
}
