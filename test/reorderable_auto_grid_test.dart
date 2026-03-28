import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';

import 'shared.dart';

void main() {
  testWidgets('ReorderableAutoResponsiveGrid keeps adaptive columns',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 650,
            child: ReorderableAutoResponsiveGrid(
              minItemWidth: 200,
              columnSpacing: 10,
              rowSpacing: 10,
              onReorder: (_, __) {},
              dragStartDelay: Duration.zero,
              children: [
                for (var index = 0; index < 4; index++)
                  Container(
                    key: ValueKey('item$index'),
                    height: 48,
                    color: Colors.blue,
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    final item0 = tester.getRect(find.byKey(const ValueKey('item0')));
    final item1 = tester.getRect(find.byKey(const ValueKey('item1')));
    final item2 = tester.getRect(find.byKey(const ValueKey('item2')));
    final item3 = tester.getRect(find.byKey(const ValueKey('item3')));

    expect(item0.top, item1.top);
    expect(item1.top, item2.top);
    expect(item0.left < item1.left, isTrue);
    expect(item1.left < item2.left, isTrue);
    expect(item3.top > item0.top, isTrue);

    resetScreenSize(tester);
  });

  testWidgets('ReorderableAutoResponsiveGrid reports final reordered index',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xl.start);

    int? oldIndex;
    int? newIndex;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 650,
            child: ReorderableAutoResponsiveGrid(
              minItemWidth: 200,
              columnSpacing: 10,
              rowSpacing: 10,
              dragStartDelay: Duration.zero,
              onReorder: (from, to) {
                oldIndex = from;
                newIndex = to;
              },
              children: [
                for (var index = 0; index < 4; index++)
                  Container(
                    key: ValueKey('item$index'),
                    height: 48,
                    color: Colors.blue,
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    final dragSource = find.byKey(const ValueKey('item3'));
    final dragTarget = tester.getRect(find.byKey(const ValueKey('item1')));
    final dragStart = tester.getCenter(dragSource);
    final dragEnd = Offset(dragTarget.left + 8, dragTarget.center.dy);

    await tester.dragFrom(
      dragStart,
      Offset(dragEnd.dx - dragStart.dx, dragEnd.dy - dragStart.dy),
    );
    await tester.pumpAndSettle();

    expect(oldIndex, equals(3));
    expect(newIndex, equals(1));

    resetScreenSize(tester);
  });
}
