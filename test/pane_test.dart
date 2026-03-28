import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';

import 'shared.dart';

void main() {
  testWidgets('AdaptivePane stacks vertically on compact widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdaptivePane(
            primary: Container(key: const Key('primary'), height: 80),
            secondary: Container(key: const Key('secondary'), height: 80),
          ),
        ),
      ),
    );

    final primaryRect = tester.getRect(find.byKey(const Key('primary')));
    final secondaryRect = tester.getRect(find.byKey(const Key('secondary')));

    expect(primaryRect.top < secondaryRect.top, isTrue);
    expect(primaryRect.left, secondaryRect.left);
    resetScreenSize(tester);
  });

  testWidgets('AdaptivePane splits horizontally from medium widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.lg.start);

    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          height: 200,
          child: AdaptivePane(
            primary: Container(key: const Key('primary')),
            secondary: Container(key: const Key('secondary')),
          ),
        ),
      ),
    );

    final primaryRect = tester.getRect(find.byKey(const Key('primary')));
    final secondaryRect = tester.getRect(find.byKey(const Key('secondary')));

    expect(primaryRect.left < secondaryRect.left, isTrue);
    expect(primaryRect.top, secondaryRect.top);
    resetScreenSize(tester);
  });

  testWidgets('AdaptivePane can use container constraints for mode selection',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            width: 320,
            child: AdaptivePane(
              primary: Container(key: const Key('primary'), height: 80),
              secondary: Container(key: const Key('secondary'), height: 80),
            ),
          ),
        ),
      ),
    );

    final primaryRect = tester.getRect(find.byKey(const Key('primary')));
    final secondaryRect = tester.getRect(find.byKey(const Key('secondary')));

    expect(primaryRect.top < secondaryRect.top, isTrue);
    resetScreenSize(tester);
  });

  testWidgets('AdaptivePane can stay stacked on short heights',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xl.start, 420);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 200,
            child: AdaptivePane(
              minimumSplitHeight: AdaptiveHeight.medium,
              primary: Container(key: const Key('primary')),
              secondary: Container(key: const Key('secondary')),
            ),
          ),
        ),
      ),
    );

    final primaryRect = tester.getRect(find.byKey(const Key('primary')));
    final secondaryRect = tester.getRect(find.byKey(const Key('secondary')));

    expect(primaryRect.top < secondaryRect.top, isTrue);
    expect(primaryRect.left, secondaryRect.left);

    resetScreenSize(tester);
  });
}
