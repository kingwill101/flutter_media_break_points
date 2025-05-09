import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';
import 'shared.dart';

void main() {
  testWidgets('ResponsiveGrid adjusts columns based on screen size',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ResponsiveGrid(
          children: [
            ResponsiveGridItem(
              xs: 12, // Full width on xs
              sm: 6, // Half width on sm
              md: 4, // One-third width on md
              lg: 3, // One-fourth width on lg
              child: Container(key: Key('item1'), color: Colors.red),
            ),
            ResponsiveGridItem(
              xs: 12,
              sm: 6,
              md: 4,
              lg: 3,
              child: Container(key: Key('item2'), color: Colors.blue),
            ),
            ResponsiveGridItem(
              xs: 12,
              sm: 6,
              md: 4,
              lg: 3,
              child: Container(key: Key('item3'), color: Colors.green),
            ),
            ResponsiveGridItem(
              xs: 12,
              sm: 6,
              md: 4,
              lg: 3,
              child: Container(key: Key('item4'), color: Colors.yellow),
            ),
          ],
        ),
      ),
    ));

    // Test extra small screen (1 item per row)
    setScreenSize(tester, BreakPoint.xs.start);
    await tester.pumpAndSettle();

    // All items should be stacked vertically
    final item1Xs = tester.getRect(find.byKey(Key('item1')));
    final item2Xs = tester.getRect(find.byKey(Key('item2')));
    expect(item1Xs.top < item2Xs.top, true);

    // Test small screen (2 items per row)
    setScreenSize(tester, BreakPoint.sm.start);
    await tester.pumpAndSettle();

    // Items should be in a 2x2 grid
    final item1Sm = tester.getRect(find.byKey(Key('item1')));
    final item2Sm = tester.getRect(find.byKey(Key('item2')));
    final item3Sm = tester.getRect(find.byKey(Key('item3')));

    // First two items should be side by side
    expect(item1Sm.left < item2Sm.left, true);
    expect(item1Sm.top == item2Sm.top, true);

    // Third item should be below the first
    expect(item1Sm.top < item3Sm.top, true);

    // Test medium screen (3 items per row)
    setScreenSize(tester, BreakPoint.md.start);
    await tester.pumpAndSettle();

    // Items should be in a 3x2 grid (approximately)
    final item1Md = tester.getRect(find.byKey(Key('item1')));
    final item2Md = tester.getRect(find.byKey(Key('item2')));
    final item3Md = tester.getRect(find.byKey(Key('item3')));
    final item4Md = tester.getRect(find.byKey(Key('item4')));

    // First three items should be side by side
    expect(item1Md.left < item2Md.left, true);
    expect(item2Md.left < item3Md.left, true);
    expect(item1Md.top == item2Md.top, true);
    expect(item2Md.top == item3Md.top, true);

    // Fourth item should be below
    expect(item1Md.top < item4Md.top, true);

    resetScreenSize(tester);
  });
}
