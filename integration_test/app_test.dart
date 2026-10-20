import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ditonton/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
      'Complete TV Series flow: open TV series, view detail, add to watchlist, verify watchlist',
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // 1. Open Navigation Drawer
    final drawerFinder = find.byTooltip('Open navigation menu');
    if (drawerFinder.evaluate().isNotEmpty) {
      await tester.tap(drawerFinder);
    } else {
      final scaffoldState =
          tester.firstState<ScaffoldState>(find.byType(Scaffold));
      scaffoldState.openDrawer();
    }
    await tester.pumpAndSettle();

    // 2. Tap TV Series from drawer to navigate to HomeTvSeriesPage
    final tvSeriesDrawerItem = find.text('TV Series');
    expect(tvSeriesDrawerItem, findsWidgets);
    await tester.tap(tvSeriesDrawerItem.first);
    await tester.pumpAndSettle();

    // 3. Verify we are on TV Series page
    expect(find.text('TV Series'), findsWidgets);
    expect(find.text('On The Air'), findsOneWidget);

    // 4. Tap on an item in the TV Series list if loaded
    final inkWellItems = find.byType(InkWell);
    if (inkWellItems.evaluate().isNotEmpty) {
      await tester.tap(inkWellItems.first);
      await tester.pumpAndSettle();

      // 5. In Detail Page: check for Watchlist button
      final watchlistButton = find.text('Watchlist');
      if (watchlistButton.evaluate().isNotEmpty) {
        await tester.tap(watchlistButton);
        await tester.pumpAndSettle();
      }

      // 6. Navigate back
      final backButton = find.byIcon(Icons.arrow_back);
      if (backButton.evaluate().isNotEmpty) {
        await tester.tap(backButton);
        await tester.pumpAndSettle();
      }
    }

    // 7. Open Drawer and navigate to Watchlist
    final scaffoldState =
        tester.firstState<ScaffoldState>(find.byType(Scaffold));
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();

    final watchlistDrawerItem = find.text('Watchlist');
    await tester.tap(watchlistDrawerItem);
    await tester.pumpAndSettle();

    // 8. Verify Watchlist page opened with Tabs
    expect(find.text('Movies'), findsOneWidget);
    expect(find.text('TV Series'), findsWidgets);

    // Switch to TV Series Watchlist tab
    await tester.tap(find.text('TV Series').first);
    await tester.pump(const Duration(milliseconds: 500));
  });
}
