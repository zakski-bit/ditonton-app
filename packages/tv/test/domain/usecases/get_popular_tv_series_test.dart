import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:tv/domain/usecases/get_popular_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTvSeries usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetPopularTvSeries(mockTvRepository);
  });

  final tTvSeries = <TvSeries>[];

  test('should get list of TV series from repository', () async {
    // arrange
    when(mockTvRepository.getPopularTvSeries())
        .thenAnswer((_) async => Right(tTvSeries));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTvSeries));
  });
}
