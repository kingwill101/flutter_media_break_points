import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';

import 'shared.dart';

void main() {
  testWidgets('AutoResponsiveGrid computes columns from available width',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            width: 650,
            child: AutoResponsiveGrid(
              minItemWidth: 200,
              columnSpacing: 10,
              rowSpacing: 10,
              children: [
                for (var index = 0; index < 4; index++)
                  Container(
                    key: Key('item$index'),
                    height: 48,
                    color: Colors.blue,
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    final item0 = tester.getRect(find.byKey(const Key('item0')));
    final item1 = tester.getRect(find.byKey(const Key('item1')));
    final item2 = tester.getRect(find.byKey(const Key('item2')));
    final item3 = tester.getRect(find.byKey(const Key('item3')));

    expect(item0.top, item1.top);
    expect(item1.top, item2.top);
    expect(item0.left < item1.left, isTrue);
    expect(item1.left < item2.left, isTrue);
    expect(item3.top > item0.top, isTrue);

    resetScreenSize(tester);
  });
}
