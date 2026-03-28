import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';
import 'package:media_break_points/patterns.dart';

import 'shared.dart';

List<AdaptiveComparisonItem> _items() {
  return const [
    AdaptiveComparisonItem(
      label: 'Starter',
      description: 'Lean defaults for smaller teams.',
      child: SizedBox(
        key: Key('starter-content'),
        height: 120,
      ),
    ),
    AdaptiveComparisonItem(
      label: 'Growth',
      description: 'More adaptive controls and inspectors.',
      child: SizedBox(
        key: Key('growth-content'),
        height: 120,
      ),
    ),
    AdaptiveComparisonItem(
      label: 'Scale',
      description: 'The full workspace shell and workflow surface set.',
      child: SizedBox(
        key: Key('scale-content'),
        height: 120,
      ),
    ),
  ];
}

void main() {
  testWidgets('AdaptiveComparison shows one selected item on compact widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdaptiveComparison(
            items: _items(),
          ),
        ),
      ),
    );

    expect(find.byType(SegmentedButton<int>), findsOneWidget);
    expect(find.byKey(const Key('starter-content')), findsOneWidget);
    expect(find.byKey(const Key('growth-content')), findsNothing);

    await tester.tap(find.text('Growth'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('growth-content')), findsOneWidget);
    expect(find.byKey(const Key('starter-content')), findsNothing);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveComparison shows columns on larger widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 320,
            child: AdaptiveComparison(
              items: _items(),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(SegmentedButton<int>), findsNothing);
    expect(find.byKey(const Key('starter-content')), findsOneWidget);
    expect(find.byKey(const Key('growth-content')), findsOneWidget);
    expect(find.byKey(const Key('scale-content')), findsOneWidget);

    final starter = tester.getTopLeft(find.byKey(const Key('starter-content')));
    final growth = tester.getTopLeft(find.byKey(const Key('growth-content')));
    expect(starter.dx < growth.dx, isTrue);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveComparison can use narrow container constraints',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xxl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 320,
              child: AdaptiveComparison(
                items: _items(),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(SegmentedButton<int>), findsOneWidget);
    expect(find.byKey(const Key('starter-content')), findsOneWidget);
    expect(find.byKey(const Key('growth-content')), findsNothing);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveComparison can demote on short heights',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xl.start, 420);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 220,
            child: AdaptiveComparison(
              items: _items(),
              minimumColumnsHeight: AdaptiveHeight.medium,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(SegmentedButton<int>), findsOneWidget);
    expect(find.byKey(const Key('starter-content')), findsOneWidget);
    expect(find.byKey(const Key('growth-content')), findsNothing);

    resetScreenSize(tester);
  });
}
