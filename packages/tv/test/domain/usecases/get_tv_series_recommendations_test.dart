import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:tv/domain/usecases/get_tv_series_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvSeriesRecommendations usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTvSeriesRecommendations(mockTvRepository);
  });

  const tId = 1;
  final tTvSeries = <TvSeries>[];

  test(
    'should get list of TV series recommendations from the repository',
    () async {
      // arrange
      when(mockTvRepository.getTvSeriesRecommendations(tId))
          .thenAnswer((_) async => Right(tTvSeries));
      // act
      final result = await usecase.execute(tId);
      // assert
      expect(result, Right(tTvSeries));
    },
  );
}
