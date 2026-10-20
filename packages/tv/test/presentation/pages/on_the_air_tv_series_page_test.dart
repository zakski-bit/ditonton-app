import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/tv.dart';

import '../../dummy_data/dummy_objects.dart';

class MockOnTheAirTvSeriesBloc
    extends MockBloc<OnTheAirTvSeriesEvent, OnTheAirTvSeriesState>
    implements OnTheAirTvSeriesBloc {}

void main() {
  late MockOnTheAirTvSeriesBloc mockBloc;

  setUp(() {
    mockBloc = MockOnTheAirTvSeriesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<OnTheAirTvSeriesBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(OnTheAirTvSeriesLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(const OnTheAirTvSeriesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets(
      'Page should display ListView and TvSeriesCard when data is loaded',
      (WidgetTester tester) async {
    when(() => mockBloc.state)
        .thenReturn(OnTheAirTvSeriesLoaded(testTvList));

    final listViewFinder = find.byType(ListView);
    final cardFinder = find.byType(TvSeriesCard);

    await tester.pumpWidget(makeTestableWidget(const OnTheAirTvSeriesPage()));

    expect(listViewFinder, findsOneWidget);
    expect(cardFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockBloc.state)
        .thenReturn(const OnTheAirTvSeriesError('Error message'));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const OnTheAirTvSeriesPage()));

    expect(textFinder, findsOneWidget);
  });
}
