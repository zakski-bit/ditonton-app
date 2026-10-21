import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';
import 'package:search/search.dart';

class MockMovieSearchBloc extends MockBloc<MovieSearchEvent, MovieSearchState>
    implements MovieSearchBloc {}

void main() {
  late MockMovieSearchBloc mockMovieSearchBloc;

  setUp(() {
    mockMovieSearchBloc = MockMovieSearchBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieSearchBloc>.value(
      value: mockMovieSearchBloc,
      child: MaterialApp(home: body),
    );
  }

  final tMovieModel = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: const [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview: 'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tMovieList = <Movie>[tMovieModel];

  testWidgets('Page should display progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(() => mockMovieSearchBloc.state).thenReturn(SearchMovieLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(makeTestableWidget(const SearchPage()));

    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets(
    'Page should display ListView and MovieCard when data is loaded',
    (WidgetTester tester) async {
      when(() => mockMovieSearchBloc.state)
          .thenReturn(SearchMovieLoaded(tMovieList));

      final listViewFinder = find.byType(ListView);
      final movieCardFinder = find.byType(MovieCard);

      await tester.pumpWidget(makeTestableWidget(const SearchPage()));

      expect(listViewFinder, findsOneWidget);
      expect(movieCardFinder, findsOneWidget);
    },
  );

  testWidgets('Page should display error text when error', (
    WidgetTester tester,
  ) async {
    when(() => mockMovieSearchBloc.state)
        .thenReturn(const SearchMovieError('Error message'));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const SearchPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('TextField should add OnMovieQueryChanged event to bloc', (
    WidgetTester tester,
  ) async {
    when(() => mockMovieSearchBloc.state).thenReturn(SearchMovieEmpty());

    await tester.pumpWidget(makeTestableWidget(const SearchPage()));

    final textFieldFinder = find.byType(TextField);
    await tester.enterText(textFieldFinder, 'spiderman');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();

    verify(
      () => mockMovieSearchBloc.add(const OnMovieQueryChanged('spiderman')),
    ).called(2);
  });
}
