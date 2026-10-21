import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:search/search.dart';

class MockSearchTvSeries extends Mock implements SearchTvSeries {}

void main() {
  late TvSearchBloc tvSearchBloc;
  late MockSearchTvSeries mockSearchTvSeries;

  setUp(() {
    mockSearchTvSeries = MockSearchTvSeries();
    tvSearchBloc = TvSearchBloc(searchTvSeries: mockSearchTvSeries);
  });

  final tTvModel = TvSeries(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: const [14, 28],
    id: 1,
    originalName: 'Original Name',
    overview: 'Overview',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    firstAirDate: '2021-09-03',
    name: 'Name',
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tTvList = <TvSeries>[tTvModel];
  const tQuery = 'squid game';

  test('initial state should be empty', () {
    expect(tvSearchBloc.state, SearchTvEmpty());
  });

  blocTest<TvSearchBloc, TvSearchState>(
    'should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(() => mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => Right(tTvList));
      return tvSearchBloc;
    },
    act: (bloc) => bloc.add(const OnTvQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [SearchTvLoading(), SearchTvLoaded(tTvList)],
    verify: (bloc) {
      verify(() => mockSearchTvSeries.execute(tQuery)).called(1);
    },
  );

  blocTest<TvSearchBloc, TvSearchState>(
    'should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(() => mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvSearchBloc;
    },
    act: (bloc) => bloc.add(const OnTvQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [SearchTvLoading(), const SearchTvError('Server Failure')],
    verify: (bloc) {
      verify(() => mockSearchTvSeries.execute(tQuery)).called(1);
    },
  );

  blocTest<TvSearchBloc, TvSearchState>(
    'should emit [SearchTvEmpty] when query is empty',
    build: () {
      return tvSearchBloc;
    },
    act: (bloc) => bloc.add(const OnTvQueryChanged('')),
    wait: const Duration(milliseconds: 500),
    expect: () => [SearchTvEmpty()],
  );
}
