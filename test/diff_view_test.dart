import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';

import 'shared.dart';

AdaptiveDiffPane _primaryPane() {
  return const AdaptiveDiffPane(
    label: 'Current',
    description: 'The shipped workspace shell.',
    child: SizedBox(
      key: Key('current-content'),
      height: 120,
    ),
  );
}

AdaptiveDiffPane _secondaryPane() {
  return const AdaptiveDiffPane(
    label: 'Proposed',
    description: 'The next adaptive review pass.',
    child: SizedBox(
      key: Key('proposed-content'),
      height: 120,
    ),
  );
}

void main() {
  testWidgets('AdaptiveDiffView shows one selected pane on compact widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdaptiveDiffView(
            primary: _primaryPane(),
            secondary: _secondaryPane(),
          ),
        ),
      ),
    );

    expect(find.byType(SegmentedButton<AdaptiveDiffSide>), findsOneWidget);
    expect(find.byKey(const Key('current-content')), findsOneWidget);
    expect(find.byKey(const Key('proposed-content')), findsNothing);

    await tester.tap(find.text('Proposed'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('proposed-content')), findsOneWidget);
    expect(find.byKey(const Key('current-content')), findsNothing);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveDiffView shows split panes on larger widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 320,
            child: AdaptiveDiffView(
              primary: _primaryPane(),
              secondary: _secondaryPane(),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(SegmentedButton<AdaptiveDiffSide>), findsNothing);
    expect(find.byKey(const Key('current-content')), findsOneWidget);
    expect(find.byKey(const Key('proposed-content')), findsOneWidget);

    final current = tester.getTopLeft(find.byKey(const Key('current-content')));
    final proposed =
        tester.getTopLeft(find.byKey(const Key('proposed-content')));
    expect(current.dx < proposed.dx, isTrue);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveDiffView can use narrow container constraints',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xxl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 320,
              child: AdaptiveDiffView(
                primary: _primaryPane(),
                secondary: _secondaryPane(),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(SegmentedButton<AdaptiveDiffSide>), findsOneWidget);
    expect(find.byKey(const Key('current-content')), findsOneWidget);
    expect(find.byKey(const Key('proposed-content')), findsNothing);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveDiffView can demote on short heights',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xl.start, 420);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 220,
            child: AdaptiveDiffView(
              primary: _primaryPane(),
              secondary: _secondaryPane(),
              minimumSplitHeight: AdaptiveHeight.medium,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(SegmentedButton<AdaptiveDiffSide>), findsOneWidget);
    expect(find.byKey(const Key('current-content')), findsOneWidget);
    expect(find.byKey(const Key('proposed-content')), findsNothing);

    resetScreenSize(tester);
  });
}
