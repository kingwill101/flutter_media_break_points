import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';

import 'shared.dart';

void main() {
  testWidgets('AdaptiveFilterLayout shows a modal trigger on compact widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdaptiveFilterLayout(
            filtersTitle: 'Filters',
            activeFilters: const [
              Chip(label: Text('Mobile')),
              Chip(label: Text('Live')),
            ],
            results: Container(
              key: const Key('results'),
              height: 80,
            ),
            filters: Container(
              key: const Key('filters'),
              height: 80,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open filters'), findsOneWidget);
    expect(find.text('Active filters'), findsOneWidget);
    expect(find.byKey(const Key('filters')), findsNothing);

    await tester.tap(find.text('Open filters'));
    await tester.pumpAndSettle();

    expect(find.text('Filters'), findsOneWidget);
    expect(find.byKey(const Key('filters')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveFilterLayout docks filters on larger widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 260,
            child: AdaptiveFilterLayout(
              filtersTitle: 'Filters',
              activeFilters: const [
                Chip(label: Text('Design')),
              ],
              results: Container(
                key: const Key('results'),
              ),
              filters: Container(
                key: const Key('filters'),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open filters'), findsNothing);
    expect(find.text('Filters'), findsOneWidget);
    expect(find.text('Active filters'), findsOneWidget);

    final resultsRect = tester.getRect(find.byKey(const Key('results')));
    final filtersRect = tester.getRect(find.byKey(const Key('filters')));
    expect(resultsRect.left < filtersRect.left, isTrue);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveFilterLayout can use narrow container constraints',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xxl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            width: 320,
            child: AdaptiveFilterLayout(
              filtersTitle: 'Filters',
              results: Container(
                key: const Key('results'),
                height: 80,
              ),
              filters: Container(
                key: const Key('filters'),
                height: 80,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open filters'), findsOneWidget);
    expect(find.text('Filters'), findsNothing);

    resetScreenSize(tester);
  });

  testWidgets(
      'AdaptiveFilterLayout can keep wide layouts modal on short heights',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xl.start, 420);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 220,
            child: AdaptiveFilterLayout(
              filtersTitle: 'Filters',
              minimumDockedHeight: AdaptiveHeight.medium,
              results: Container(
                key: const Key('results'),
              ),
              filters: Container(
                key: const Key('filters'),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open filters'), findsOneWidget);
    expect(find.text('Filters'), findsNothing);

    resetScreenSize(tester);
  });
}
