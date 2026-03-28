import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';
import 'package:media_break_points/patterns.dart';

import 'shared.dart';

List<AdaptiveTimelineEntry> _entries() {
  return const [
    AdaptiveTimelineEntry(
      title: 'Prototype',
      label: 'Q1',
      description: 'Validate the core adaptive model.',
    ),
    AdaptiveTimelineEntry(
      title: 'Systemize',
      label: 'Q2',
      description: 'Ship reusable navigation and pane primitives.',
    ),
    AdaptiveTimelineEntry(
      title: 'Scale',
      label: 'Q3',
      description: 'Bring boards, tables, and workspace shells together.',
    ),
  ];
}

void main() {
  testWidgets('AdaptiveTimeline stacks entries on compact widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdaptiveTimeline(
            entries: _entries(),
          ),
        ),
      ),
    );

    final first = tester.getTopLeft(find.text('Prototype'));
    final second = tester.getTopLeft(find.text('Systemize'));
    expect(first.dy < second.dy, isTrue);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveTimeline lays out entries horizontally on larger widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 320,
            child: AdaptiveTimeline(
              entries: _entries(),
            ),
          ),
        ),
      ),
    );

    final first = tester.getTopLeft(find.text('Prototype'));
    final second = tester.getTopLeft(find.text('Systemize'));
    expect(first.dx < second.dx, isTrue);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveTimeline can use narrow container constraints',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xxl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 320,
              child: AdaptiveTimeline(
                entries: _entries(),
              ),
            ),
          ),
        ),
      ),
    );

    final first = tester.getTopLeft(find.text('Prototype'));
    final second = tester.getTopLeft(find.text('Systemize'));
    expect(first.dy < second.dy, isTrue);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveTimeline can demote on short heights',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xl.start, 420);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 220,
            child: AdaptiveTimeline(
              entries: _entries(),
              minimumHorizontalHeight: AdaptiveHeight.medium,
            ),
          ),
        ),
      ),
    );

    final first = tester.getTopLeft(find.text('Prototype'));
    final second = tester.getTopLeft(find.text('Systemize'));
    expect(first.dy < second.dy, isTrue);

    resetScreenSize(tester);
  });
}
