import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:search/search.dart';
import 'package:tv/tv.dart';

class MockTvRepository extends Mock implements TvRepository {}

void main() {
  late SearchTvSeries usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = SearchTvSeries(mockTvRepository);
  });

  final tTvList = <TvSeries>[];
  const tQuery = 'Squid Game';

  test('should get list of TV series from the repository', () async {
    // arrange
    when(() => mockTvRepository.searchTvSeries(tQuery))
        .thenAnswer((_) async => Right(tTvList));
    // act
    final result = await usecase.execute(tQuery);
    // assert
    expect(result, Right(tTvList));
    verify(() => mockTvRepository.searchTvSeries(tQuery)).called(1);
  });
}
