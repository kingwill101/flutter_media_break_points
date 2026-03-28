import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';
import 'package:media_break_points/patterns.dart';

import 'shared.dart';

const _results = [
  'Foundation',
  'Workflow',
  'Launch',
];

Widget _itemBuilder(
  BuildContext context,
  String result,
  bool selected,
  VoidCallback onTap,
) {
  return Material(
    color: selected ? Colors.blue.shade50 : Colors.grey.shade100,
    borderRadius: BorderRadius.circular(16),
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(result),
      ),
    ),
  );
}

Widget _detailBuilder(BuildContext context, String result) {
  return Container(
    key: Key('detail-$result'),
    height: 120,
    alignment: Alignment.centerLeft,
    child: Text('Detail: $result'),
  );
}

void main() {
  testWidgets(
      'AdaptiveExplorer uses modal filters and details on compact widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdaptiveExplorer<String>(
            results: _results,
            filtersTitle: 'Filters',
            filters: Container(
              key: const Key('filters'),
              height: 80,
            ),
            activeFilters: const [
              Chip(label: Text('Live')),
            ],
            itemBuilder: _itemBuilder,
            detailBuilder: _detailBuilder,
          ),
        ),
      ),
    );

    expect(find.text('Open filters'), findsOneWidget);
    expect(find.byKey(const Key('filters')), findsNothing);
    expect(find.byKey(const Key('detail-Foundation')), findsNothing);

    await tester.tap(find.text('Workflow'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('detail-Workflow')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets(
      'AdaptiveExplorer docks filters results and detail on larger widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xxl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 520,
            child: AdaptiveExplorer<String>(
              results: _results,
              filtersTitle: 'Filters',
              minimumDockedHeight: AdaptiveHeight.compact,
              filters: Container(
                key: const Key('filters'),
              ),
              header: const Text('Header'),
              itemBuilder: _itemBuilder,
              detailBuilder: _detailBuilder,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open filters'), findsNothing);
    expect(find.byKey(const Key('filters')), findsOneWidget);
    expect(find.byKey(const Key('detail-Foundation')), findsOneWidget);

    final filterRect = tester.getRect(find.byKey(const Key('filters')));
    final detailRect =
        tester.getRect(find.byKey(const Key('detail-Foundation')));
    expect(filterRect.left < detailRect.left, isTrue);

    await tester.tap(find.text('Launch'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('detail-Launch')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveExplorer can use narrow container constraints',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xxl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            width: 340,
            child: AdaptiveExplorer<String>(
              results: _results,
              filtersTitle: 'Filters',
              filters: Container(
                key: const Key('filters'),
                height: 80,
              ),
              useContainerConstraints: true,
              itemBuilder: _itemBuilder,
              detailBuilder: _detailBuilder,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open filters'), findsOneWidget);
    expect(find.byKey(const Key('filters')), findsNothing);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveExplorer can demote on short heights',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 420);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 240,
            child: AdaptiveExplorer<String>(
              results: _results,
              filtersTitle: 'Filters',
              filters: Container(
                key: const Key('filters'),
              ),
              minimumDockedHeight: AdaptiveHeight.expanded,
              itemBuilder: _itemBuilder,
              detailBuilder: _detailBuilder,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open filters'), findsOneWidget);
    expect(find.byKey(const Key('filters')), findsNothing);

    resetScreenSize(tester);
  });
}
