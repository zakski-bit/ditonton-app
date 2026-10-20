import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetMovieRecommendations extends Mock
    implements GetMovieRecommendations {}

void main() {
  late MovieRecommendationsBloc movieRecommendationsBloc;
  late MockGetMovieRecommendations mockGetMovieRecommendations;

  setUp(() {
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    movieRecommendationsBloc = MovieRecommendationsBloc(
        getMovieRecommendations: mockGetMovieRecommendations);
  });

  const tId = 1;

  test('initial state should be empty', () {
    expect(movieRecommendationsBloc.state, MovieRecommendationsEmpty());
  });

  blocTest<MovieRecommendationsBloc, MovieRecommendationsState>(
    'should emit [Loading, Loaded] when recommendations are gotten successfully',
    build: () {
      when(() => mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right(testMovieList));
      return movieRecommendationsBloc;
    },
    act: (bloc) => bloc.add(const FetchMovieRecommendations(tId)),
    expect: () => [
      MovieRecommendationsLoading(),
      MovieRecommendationsLoaded(testMovieList),
    ],
    verify: (bloc) {
      verify(() => mockGetMovieRecommendations.execute(tId)).called(1);
    },
  );

  blocTest<MovieRecommendationsBloc, MovieRecommendationsState>(
    'should emit [Loading, Error] when get recommendations is unsuccessful',
    build: () {
      when(() => mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return movieRecommendationsBloc;
    },
    act: (bloc) => bloc.add(const FetchMovieRecommendations(tId)),
    expect: () => [
      MovieRecommendationsLoading(),
      const MovieRecommendationsError('Server Failure'),
    ],
    verify: (bloc) {
      verify(() => mockGetMovieRecommendations.execute(tId)).called(1);
    },
  );
}
