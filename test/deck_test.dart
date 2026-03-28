import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';
import 'package:media_break_points/patterns.dart';

import 'shared.dart';

List<AdaptiveDeckItem> _items() {
  return const [
    AdaptiveDeckItem(
      label: 'Foundation',
      description: 'Core responsive primitives.',
      child: Text('Semantic breakpoints and fluid values'),
    ),
    AdaptiveDeckItem(
      label: 'Workflow',
      description: 'Compound adaptive layouts.',
      child: Text('Scaffold, pane, inspector, and board'),
    ),
    AdaptiveDeckItem(
      label: 'Release',
      description: 'Verification and polish.',
      child: Text('Analyze, test, and catalog review'),
    ),
  ];
}

void main() {
  testWidgets('AdaptiveDeck pages on compact widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdaptiveDeck(
            items: _items(),
          ),
        ),
      ),
    );

    expect(find.byType(PageView), findsOneWidget);
    expect(find.text('Foundation'), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveDeck shows cards side by side on larger widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 420,
            child: AdaptiveDeck(
              items: _items(),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(PageView), findsNothing);

    final foundation = tester.getTopLeft(find.text('Foundation'));
    final workflow = tester.getTopLeft(find.text('Workflow'));
    expect(foundation.dx < workflow.dx, isTrue);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveDeck can use narrow container constraints',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xxl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 320,
              child: AdaptiveDeck(
                items: _items(),
                useContainerConstraints: true,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(PageView), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveDeck can demote on short heights',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xl.start, 420);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 240,
            child: AdaptiveDeck(
              items: _items(),
              minimumGridHeight: AdaptiveHeight.medium,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(PageView), findsOneWidget);

    resetScreenSize(tester);
  });
}
