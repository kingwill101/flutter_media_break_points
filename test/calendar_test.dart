import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';
import 'package:media_break_points/patterns.dart';

import 'shared.dart';

List<AdaptiveCalendarDay> _days() {
  return const [
    AdaptiveCalendarDay(
      label: 'Mon 1',
      entries: [
        _CalendarChip(label: 'Standup'),
      ],
    ),
    AdaptiveCalendarDay(
      label: 'Tue 2',
      entries: [
        _CalendarChip(label: 'Review'),
      ],
    ),
    AdaptiveCalendarDay(
      label: 'Wed 3',
      entries: [
        _CalendarChip(label: 'Ship'),
      ],
    ),
  ];
}

void main() {
  testWidgets('AdaptiveCalendar stacks days on compact widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdaptiveCalendar(
            days: _days(),
          ),
        ),
      ),
    );

    final first = tester.getTopLeft(find.text('Mon 1'));
    final second = tester.getTopLeft(find.text('Tue 2'));
    expect(first.dy < second.dy, isTrue);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveCalendar shows a day grid on larger widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 320,
            child: AdaptiveCalendar(
              days: _days(),
            ),
          ),
        ),
      ),
    );

    final first = tester.getTopLeft(find.text('Mon 1'));
    final second = tester.getTopLeft(find.text('Tue 2'));
    expect(first.dx < second.dx, isTrue);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveCalendar can use narrow container constraints',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xxl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 320,
              child: AdaptiveCalendar(
                days: _days(),
              ),
            ),
          ),
        ),
      ),
    );

    final first = tester.getTopLeft(find.text('Mon 1'));
    final second = tester.getTopLeft(find.text('Tue 2'));
    expect(first.dy < second.dy, isTrue);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveCalendar can demote on short heights',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xl.start, 420);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 220,
            child: AdaptiveCalendar(
              days: _days(),
              minimumGridHeight: AdaptiveHeight.medium,
            ),
          ),
        ),
      ),
    );

    final first = tester.getTopLeft(find.text('Mon 1'));
    final second = tester.getTopLeft(find.text('Tue 2'));
    expect(first.dy < second.dy, isTrue);

    resetScreenSize(tester);
  });
}

class _CalendarChip extends StatelessWidget {
  final String label;

  const _CalendarChip({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(label),
      ),
    );
  }
}
