import 'package:about/about.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestableWidget(Widget body) {
    return MaterialApp(home: body);
  }

  testWidgets('AboutPage should display description text and back button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget(AboutPage()));

    expect(find.byType(IconButton), findsOneWidget);
    expect(
      find.text(
        'Ditonton merupakan sebuah aplikasi katalog film yang dikembangkan oleh Dicoding Indonesia sebagai contoh proyek aplikasi untuk kelas Menjadi Flutter Developer Expert.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.byType(IconButton));
  });
}
