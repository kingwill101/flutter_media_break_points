import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';

import 'shared.dart';

void main() {
  testWidgets('AdaptiveCluster stacks on compact widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        home: AdaptiveCluster(
          animateTransitions: false,
          children: const [
            SizedBox(key: Key('first'), width: 80, height: 40),
            SizedBox(key: Key('second'), width: 80, height: 40),
          ],
        ),
      ),
    );

    expect(find.byType(Column), findsOneWidget);

    final firstRect = tester.getRect(find.byKey(const Key('first')));
    final secondRect = tester.getRect(find.byKey(const Key('second')));
    expect(firstRect.top < secondRect.top, isTrue);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveCluster wraps on medium widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.md.start);

    await tester.pumpWidget(
      MaterialApp(
        home: AdaptiveCluster(
          animateTransitions: false,
          children: const [
            SizedBox(width: 120, height: 40),
            SizedBox(width: 120, height: 40),
            SizedBox(width: 120, height: 40),
          ],
        ),
      ),
    );

    expect(find.byType(Wrap), findsOneWidget);
    resetScreenSize(tester);
  });

  testWidgets('AdaptiveCluster can switch to row layout when configured',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: AdaptiveCluster(
          animateTransitions: false,
          expandedLayout: AdaptiveClusterLayout.row,
          children: const [
            SizedBox(key: Key('first'), width: 80, height: 40),
            SizedBox(key: Key('second'), width: 80, height: 40),
          ],
        ),
      ),
    );

    expect(find.byType(Row), findsOneWidget);

    final firstRect = tester.getRect(find.byKey(const Key('first')));
    final secondRect = tester.getRect(find.byKey(const Key('second')));
    expect(firstRect.left < secondRect.left, isTrue);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveCluster can resolve from container constraints',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xxl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            width: 320,
            child: AdaptiveCluster(
              animateTransitions: false,
              children: const [
                SizedBox(width: 80, height: 40),
                SizedBox(width: 80, height: 40),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.byType(Column), findsOneWidget);
    expect(find.byType(Wrap), findsNothing);
    resetScreenSize(tester);
  });
}
