import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';
import 'package:media_break_points/patterns.dart';

import 'shared.dart';

const _queries = [
  'Latency',
  'Conversion',
  'Queue depth',
];

Widget _itemBuilder(
  BuildContext context,
  String query,
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
        child: Text(query),
      ),
    ),
  );
}

Widget _focusBuilder(BuildContext context, String query) {
  return Container(
    key: Key('focus-$query'),
    alignment: Alignment.centerLeft,
    child: Text('Focus: $query'),
  );
}

Widget _annotationsBuilder(BuildContext context, String query) {
  return Container(
    key: Key('annotations-$query'),
    alignment: Alignment.centerLeft,
    child: Text('Annotations: $query'),
  );
}

Widget _historyBuilder(BuildContext context, String query) {
  return Container(
    key: Key('history-$query'),
    alignment: Alignment.centerLeft,
    child: Text('History: $query'),
  );
}

void main() {
  testWidgets('AdaptiveMetricsLab shows modal triggers on compact widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdaptiveMetricsLab<String>(
            queries: _queries,
            queryTitle: 'Queries',
            annotationsTitle: 'Annotations',
            historyTitle: 'History',
            itemBuilder: _itemBuilder,
            focusBuilder: _focusBuilder,
            annotationsBuilder: _annotationsBuilder,
            historyBuilder: _historyBuilder,
          ),
        ),
      ),
    );

    expect(find.text('Open queries'), findsOneWidget);
    expect(find.text('Open annotations'), findsOneWidget);
    expect(find.text('Open history'), findsOneWidget);
    expect(find.byKey(const Key('focus-Latency')), findsOneWidget);
    expect(find.byKey(const Key('annotations-Latency')), findsNothing);

    await tester.tap(find.text('Open annotations'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('annotations-Latency')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveMetricsLab docks queries on medium widths',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.md.start, 720);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 520,
            child: AdaptiveMetricsLab<String>(
              queries: _queries,
              queryTitle: 'Queries',
              annotationsTitle: 'Annotations',
              historyTitle: 'History',
              itemBuilder: _itemBuilder,
              focusBuilder: _focusBuilder,
              annotationsBuilder: _annotationsBuilder,
              historyBuilder: _historyBuilder,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open queries'), findsNothing);
    expect(find.text('Open annotations'), findsOneWidget);
    expect(find.text('Open history'), findsOneWidget);
    expect(find.byKey(const Key('annotations-Latency')), findsNothing);

    await tester.tap(find.text('Conversion'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('focus-Conversion')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets(
      'AdaptiveMetricsLab docks annotations but keeps history modal on short heights',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 720);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 560,
            child: AdaptiveMetricsLab<String>(
              queries: _queries,
              queryTitle: 'Queries',
              annotationsTitle: 'Annotations',
              historyTitle: 'History',
              itemBuilder: _itemBuilder,
              focusBuilder: _focusBuilder,
              annotationsBuilder: _annotationsBuilder,
              historyBuilder: _historyBuilder,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open queries'), findsNothing);
    expect(find.text('Open annotations'), findsNothing);
    expect(find.text('Open history'), findsOneWidget);
    expect(find.byKey(const Key('annotations-Latency')), findsOneWidget);
    expect(find.byKey(const Key('history-Latency')), findsNothing);

    await tester.tap(find.text('Open history'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('history-Latency')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveMetricsLab fully docks on tall expanded layouts',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 920);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 840,
            child: AdaptiveMetricsLab<String>(
              queries: _queries,
              queryTitle: 'Queries',
              annotationsTitle: 'Annotations',
              historyTitle: 'History',
              itemBuilder: _itemBuilder,
              focusBuilder: _focusBuilder,
              annotationsBuilder: _annotationsBuilder,
              historyBuilder: _historyBuilder,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open queries'), findsNothing);
    expect(find.text('Open annotations'), findsNothing);
    expect(find.text('Open history'), findsNothing);
    expect(find.byKey(const Key('annotations-Latency')), findsOneWidget);
    expect(find.byKey(const Key('history-Latency')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets(
      'AdaptiveMetricsLab can use narrow container constraints for local layout',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 920);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 420,
              height: 520,
              child: AdaptiveMetricsLab<String>(
                queries: _queries,
                queryTitle: 'Queries',
                annotationsTitle: 'Annotations',
                historyTitle: 'History',
                useContainerConstraints: true,
                itemBuilder: _itemBuilder,
                focusBuilder: _focusBuilder,
                annotationsBuilder: _annotationsBuilder,
                historyBuilder: _historyBuilder,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open queries'), findsOneWidget);
    expect(find.text('Open annotations'), findsOneWidget);
    expect(find.text('Open history'), findsOneWidget);

    resetScreenSize(tester);
  });
}
