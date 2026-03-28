import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';
import 'package:media_break_points/patterns.dart';

import 'shared.dart';

List<AdaptiveBoardLane> _lanes() {
  return const [
    AdaptiveBoardLane(
      title: 'Queued',
      items: [
        _BoardItem(label: 'Spec review'),
      ],
    ),
    AdaptiveBoardLane(
      title: 'Building',
      items: [
        _BoardItem(label: 'Adaptive shell'),
      ],
    ),
    AdaptiveBoardLane(
      title: 'Done',
      items: [
        _BoardItem(label: 'Fluid values'),
      ],
    ),
  ];
}

void main() {
  testWidgets('AdaptiveBoard stacks lanes on compact widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdaptiveBoard(
            lanes: _lanes(),
          ),
        ),
      ),
    );

    final queued = tester.getTopLeft(find.text('Queued'));
    final building = tester.getTopLeft(find.text('Building'));
    expect(queued.dy < building.dy, isTrue);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveBoard lays out lanes horizontally on larger widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 320,
            child: AdaptiveBoard(
              lanes: _lanes(),
            ),
          ),
        ),
      ),
    );

    final queued = tester.getTopLeft(find.text('Queued'));
    final building = tester.getTopLeft(find.text('Building'));
    expect(queued.dx < building.dx, isTrue);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveBoard can use narrow container constraints',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xxl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 320,
              child: AdaptiveBoard(
                lanes: _lanes(),
              ),
            ),
          ),
        ),
      ),
    );

    final queued = tester.getTopLeft(find.text('Queued'));
    final building = tester.getTopLeft(find.text('Building'));
    expect(queued.dy < building.dy, isTrue);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveBoard can demote on short heights',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xl.start, 420);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 220,
            child: AdaptiveBoard(
              lanes: _lanes(),
              minimumBoardHeight: AdaptiveHeight.medium,
            ),
          ),
        ),
      ),
    );

    final queued = tester.getTopLeft(find.text('Queued'));
    final building = tester.getTopLeft(find.text('Building'));
    expect(queued.dy < building.dy, isTrue);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveBoard header degrades safely in very narrow lanes',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xl.start, 420);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 260,
            child: AdaptiveBoard(
              boardAt: AdaptiveSize.compact,
              laneWidth: 96,
              lanes: const [
                AdaptiveBoardLane(
                  title: 'Queued',
                  description: 'Ready for review',
                  leading: Icon(Icons.schedule_outlined),
                  trailing: Chip(label: Text('3')),
                  items: [
                    _BoardItem(label: 'Spec review'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    resetScreenSize(tester);
  });
}

class _BoardItem extends StatelessWidget {
  final String label;

  const _BoardItem({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Text(label),
      ),
    );
  }
}
