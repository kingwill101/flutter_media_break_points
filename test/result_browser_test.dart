import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';

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
      'AdaptiveResultBrowser opens details in a modal on compact widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdaptiveResultBrowser<String>(
            results: _results,
            itemBuilder: _itemBuilder,
            detailBuilder: _detailBuilder,
          ),
        ),
      ),
    );

    expect(find.text('Foundation'), findsOneWidget);
    expect(find.byKey(const Key('detail-Foundation')), findsNothing);

    await tester.tap(find.text('Workflow'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('detail-Workflow')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveResultBrowser docks details on larger widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 280,
            child: AdaptiveResultBrowser<String>(
              results: _results,
              itemBuilder: _itemBuilder,
              detailBuilder: _detailBuilder,
            ),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('detail-Foundation')), findsOneWidget);

    final listRect = tester.getRect(find.text('Foundation').first);
    final detailRect =
        tester.getRect(find.byKey(const Key('detail-Foundation')));
    expect(listRect.left < detailRect.left, isTrue);

    await tester.tap(find.text('Launch'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('detail-Launch')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveResultBrowser can use narrow container constraints',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xxl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            width: 320,
            child: AdaptiveResultBrowser<String>(
              results: _results,
              itemBuilder: _itemBuilder,
              detailBuilder: _detailBuilder,
              useContainerConstraints: true,
            ),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('detail-Foundation')), findsNothing);

    resetScreenSize(tester);
  });

  testWidgets(
      'AdaptiveResultBrowser can keep wide layouts modal on short heights',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xl.start, 420);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 220,
            child: AdaptiveResultBrowser<String>(
              results: _results,
              itemBuilder: _itemBuilder,
              detailBuilder: _detailBuilder,
              minimumSplitHeight: AdaptiveHeight.medium,
            ),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('detail-Foundation')), findsNothing);

    resetScreenSize(tester);
  });
}
