import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';
import 'package:media_break_points/patterns.dart';

import 'shared.dart';

List<AdaptiveScheduleDay> _days() {
  return const [
    AdaptiveScheduleDay(
      label: 'Monday',
      entries: [
        AdaptiveScheduleEntry(
          timeLabel: '09:00',
          title: 'Design review',
        ),
      ],
    ),
    AdaptiveScheduleDay(
      label: 'Tuesday',
      entries: [
        AdaptiveScheduleEntry(
          timeLabel: '11:00',
          title: 'Build sync',
        ),
      ],
    ),
    AdaptiveScheduleDay(
      label: 'Wednesday',
      entries: [
        AdaptiveScheduleEntry(
          timeLabel: '14:00',
          title: 'Release pass',
        ),
      ],
    ),
  ];
}

void main() {
  testWidgets('AdaptiveSchedule stacks days on compact widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdaptiveSchedule(
            days: _days(),
          ),
        ),
      ),
    );

    final monday = tester.getTopLeft(find.text('Monday'));
    final tuesday = tester.getTopLeft(find.text('Tuesday'));
    expect(monday.dy < tuesday.dy, isTrue);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveSchedule shows day columns on larger widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 320,
            child: AdaptiveSchedule(
              days: _days(),
            ),
          ),
        ),
      ),
    );

    final monday = tester.getTopLeft(find.text('Monday'));
    final tuesday = tester.getTopLeft(find.text('Tuesday'));
    expect(monday.dx < tuesday.dx, isTrue);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveSchedule can use narrow container constraints',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xxl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 320,
              child: AdaptiveSchedule(
                days: _days(),
              ),
            ),
          ),
        ),
      ),
    );

    final monday = tester.getTopLeft(find.text('Monday'));
    final tuesday = tester.getTopLeft(find.text('Tuesday'));
    expect(monday.dy < tuesday.dy, isTrue);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveSchedule can demote on short heights',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xl.start, 420);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 220,
            child: AdaptiveSchedule(
              days: _days(),
              minimumColumnsHeight: AdaptiveHeight.medium,
            ),
          ),
        ),
      ),
    );

    final monday = tester.getTopLeft(find.text('Monday'));
    final tuesday = tester.getTopLeft(find.text('Tuesday'));
    expect(monday.dy < tuesday.dy, isTrue);

    resetScreenSize(tester);
  });
}
