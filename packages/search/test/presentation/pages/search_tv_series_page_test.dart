import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:search/search.dart';
import 'package:tv/tv.dart';

class MockTvSearchBloc extends MockBloc<TvSearchEvent, TvSearchState>
    implements TvSearchBloc {}

void main() {
  late MockTvSearchBloc mockTvSearchBloc;

  setUp(() {
    mockTvSearchBloc = MockTvSearchBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvSearchBloc>.value(
      value: mockTvSearchBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  final tTvSeriesModel = TvSeries(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: const [14, 28],
    id: 1,
    originalName: 'Game of Thrones',
    overview:
        'Seven noble families fight for control of the mythical land of Westeros.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    firstAirDate: '2011-04-17',
    name: 'Game of Thrones',
    voteAverage: 8.4,
    voteCount: 13507,
  );
  final tTvList = <TvSeries>[tTvSeriesModel];

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockTvSearchBloc.state).thenReturn(SearchTvLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(makeTestableWidget(const SearchTvSeriesPage()));

    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView and TvSeriesCard when data is loaded',
      (WidgetTester tester) async {
    when(() => mockTvSearchBloc.state).thenReturn(SearchTvLoaded(tTvList));

    final listViewFinder = find.byType(ListView);
    final tvCardFinder = find.byType(TvSeriesCard);

    await tester.pumpWidget(makeTestableWidget(const SearchTvSeriesPage()));

    expect(listViewFinder, findsOneWidget);
    expect(tvCardFinder, findsOneWidget);
  });

  testWidgets('Page should display error text when error',
      (WidgetTester tester) async {
    when(() => mockTvSearchBloc.state)
        .thenReturn(const SearchTvError('Error message'));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const SearchTvSeriesPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('TextField should add OnTvQueryChanged event to bloc',
      (WidgetTester tester) async {
    when(() => mockTvSearchBloc.state).thenReturn(SearchTvEmpty());

    await tester.pumpWidget(makeTestableWidget(const SearchTvSeriesPage()));

    final textFieldFinder = find.byType(TextField);
    await tester.enterText(textFieldFinder, 'game of thrones');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();

    verify(() => mockTvSearchBloc.add(const OnTvQueryChanged('game of thrones')))
        .called(2);
  });
}
