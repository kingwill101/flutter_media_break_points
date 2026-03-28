import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';

import 'shared.dart';

void main() {
  testWidgets(
      'AdaptivePriorityLayout collapses supporting content on compact widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdaptivePriorityLayout(
            supportingTitle: 'Summary',
            primary: Container(
              key: const Key('primary'),
              height: 80,
            ),
            supporting: Container(
              key: const Key('supporting'),
              height: 80,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(ExpansionTile), findsOneWidget);
    final primaryRect = tester.getRect(find.byKey(const Key('primary')));
    final tileRect = tester.getRect(find.byType(ExpansionTile));
    expect(primaryRect.top < tileRect.top, isTrue);

    resetScreenSize(tester);
  });

  testWidgets('AdaptivePriorityLayout splits on larger widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 200,
            child: AdaptivePriorityLayout(
              supportingTitle: 'Summary',
              primary: Container(
                key: const Key('primary'),
              ),
              supporting: Container(
                key: const Key('supporting'),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(ExpansionTile), findsNothing);
    final primaryRect = tester.getRect(find.byKey(const Key('primary')));
    final supportingRect = tester.getRect(find.byKey(const Key('supporting')));
    expect(primaryRect.left < supportingRect.left, isTrue);
    expect(primaryRect.right < supportingRect.left, isTrue);

    resetScreenSize(tester);
  });

  testWidgets('AdaptivePriorityLayout can use narrow container constraints',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xxl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            width: 320,
            child: AdaptivePriorityLayout(
              supportingTitle: 'Summary',
              primary: Container(
                key: const Key('primary'),
                height: 80,
              ),
              supporting: Container(
                key: const Key('supporting'),
                height: 80,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(ExpansionTile), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptivePriorityLayout notifies expansion changes',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    bool? expanded;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdaptivePriorityLayout(
            supportingTitle: 'Summary',
            onExpansionChanged: (value) {
              expanded = value;
            },
            primary: Container(height: 80),
            supporting: Container(height: 80),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Summary'));
    await tester.pumpAndSettle();

    expect(expanded, isTrue);
    resetScreenSize(tester);
  });

  testWidgets('AdaptivePriorityLayout can stay collapsed on short heights',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xl.start, 420);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 220,
            child: AdaptivePriorityLayout(
              supportingTitle: 'Summary',
              minimumSplitHeight: AdaptiveHeight.medium,
              primary: Container(
                key: const Key('primary'),
              ),
              supporting: Container(
                key: const Key('supporting'),
                height: 80,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(ExpansionTile), findsOneWidget);
    expect(find.byKey(const Key('supporting')), findsNothing);

    resetScreenSize(tester);
  });
}
