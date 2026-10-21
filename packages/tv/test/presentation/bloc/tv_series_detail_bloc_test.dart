import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/tv.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetTvSeriesDetail extends Mock implements GetTvSeriesDetail {}

void main() {
  late TvSeriesDetailBloc tvSeriesDetailBloc;
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;

  setUp(() {
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();
    tvSeriesDetailBloc = TvSeriesDetailBloc(
      getTvSeriesDetail: mockGetTvSeriesDetail,
    );
  });

  const tId = 1;

  test('initial state should be empty', () {
    expect(tvSeriesDetailBloc.state, TvSeriesDetailEmpty());
  });

  blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
    'should emit [Loading, Loaded] when detail is gotten successfully',
    build: () {
      when(() => mockGetTvSeriesDetail.execute(tId))
          .thenAnswer((_) async => Right(testTvDetail));
      return tvSeriesDetailBloc;
    },
    act: (bloc) => bloc.add(const FetchTvSeriesDetail(tId)),
    expect: () => [TvSeriesDetailLoading(), TvSeriesDetailLoaded(testTvDetail)],
    verify: (bloc) {
      verify(() => mockGetTvSeriesDetail.execute(tId)).called(1);
    },
  );

  blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
    'should emit [Loading, Error] when get detail is unsuccessful',
    build: () {
      when(() => mockGetTvSeriesDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvSeriesDetailBloc;
    },
    act: (bloc) => bloc.add(const FetchTvSeriesDetail(tId)),
    expect: () => [
      TvSeriesDetailLoading(),
      const TvSeriesDetailError('Server Failure'),
    ],
    verify: (bloc) {
      verify(() => mockGetTvSeriesDetail.execute(tId)).called(1);
    },
  );
}
