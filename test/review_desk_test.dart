import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';
import 'package:media_break_points/patterns.dart';

import 'shared.dart';

const _items = [
  'Queue A',
  'Queue B',
  'Queue C',
];

Widget _queueItemBuilder(
  BuildContext context,
  String item,
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
        child: Text(item),
      ),
    ),
  );
}

Widget _reviewBuilder(BuildContext context, String item) {
  return Container(
    key: Key('review-$item'),
    height: 140,
    alignment: Alignment.centerLeft,
    child: Text('Review: $item'),
  );
}

Widget _decisionBuilder(BuildContext context, String item) {
  return Container(
    key: Key('decision-$item'),
    height: 120,
    alignment: Alignment.centerLeft,
    child: Text('Decision: $item'),
  );
}

void main() {
  testWidgets('AdaptiveReviewDesk shows modal triggers on compact widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdaptiveReviewDesk<String>(
            items: _items,
            queueTitle: 'Review queue',
            decisionTitle: 'Decision panel',
            itemBuilder: _queueItemBuilder,
            reviewBuilder: _reviewBuilder,
            decisionBuilder: _decisionBuilder,
          ),
        ),
      ),
    );

    expect(find.text('Open queue'), findsOneWidget);
    expect(find.text('Open decision'), findsOneWidget);
    expect(find.byKey(const Key('review-Queue A')), findsOneWidget);
    expect(find.byKey(const Key('decision-Queue A')), findsNothing);

    await tester.tap(find.text('Open decision'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('decision-Queue A')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveReviewDesk docks queue on medium widths',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.md.start, 720);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 520,
            child: AdaptiveReviewDesk<String>(
              items: _items,
              queueTitle: 'Review queue',
              decisionTitle: 'Decision panel',
              itemBuilder: _queueItemBuilder,
              reviewBuilder: _reviewBuilder,
              decisionBuilder: _decisionBuilder,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open queue'), findsNothing);
    expect(find.text('Open decision'), findsOneWidget);
    expect(find.byKey(const Key('decision-Queue A')), findsNothing);

    await tester.tap(find.text('Queue B'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('review-Queue B')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveReviewDesk docks queue and decision on expanded widths',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 720);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 620,
            child: AdaptiveReviewDesk<String>(
              items: _items,
              queueTitle: 'Review queue',
              decisionTitle: 'Decision panel',
              itemBuilder: _queueItemBuilder,
              reviewBuilder: _reviewBuilder,
              decisionBuilder: _decisionBuilder,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open queue'), findsNothing);
    expect(find.text('Open decision'), findsNothing);
    expect(find.byKey(const Key('decision-Queue A')), findsOneWidget);

    await tester.tap(find.text('Queue C'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('review-Queue C')), findsOneWidget);
    expect(find.byKey(const Key('decision-Queue C')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveReviewDesk can use narrow container constraints',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 720);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 360,
              height: 520,
              child: AdaptiveReviewDesk<String>(
                items: _items,
                queueTitle: 'Review queue',
                decisionTitle: 'Decision panel',
                itemBuilder: _queueItemBuilder,
                reviewBuilder: _reviewBuilder,
                decisionBuilder: _decisionBuilder,
                useContainerConstraints: true,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open queue'), findsOneWidget);
    expect(find.text('Open decision'), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets(
      'AdaptiveReviewDesk can keep the decision panel modal on short heights',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 520);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 420,
            child: AdaptiveReviewDesk<String>(
              items: _items,
              queueTitle: 'Review queue',
              decisionTitle: 'Decision panel',
              itemBuilder: _queueItemBuilder,
              reviewBuilder: _reviewBuilder,
              decisionBuilder: _decisionBuilder,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open queue'), findsNothing);
    expect(find.text('Open decision'), findsOneWidget);
    expect(find.byKey(const Key('decision-Queue A')), findsNothing);

    resetScreenSize(tester);
  });
}
