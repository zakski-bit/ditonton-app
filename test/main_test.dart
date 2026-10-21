import 'package:ditonton/injection.dart' as di;
import 'package:ditonton/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    di.locator.reset();
    di.init();
  });

  tearDown(() {
    di.locator.reset();
  });

  testWidgets('MyApp should build and display HomeMoviePage', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsWidgets);
  });
}
