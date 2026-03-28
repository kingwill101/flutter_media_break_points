import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';

import 'shared.dart';

void main() {
  testWidgets('ResponsiveDebugOverlay shows current screen state',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.md.start);

    await tester.pumpWidget(
      const MaterialApp(
        home: ResponsiveDebugOverlay(
          label: 'screen',
          child: Placeholder(),
        ),
      ),
    );

    expect(find.text('screen'), findsOneWidget);
    expect(find.text('breakpoint: md'), findsOneWidget);
    expect(find.text('adaptive: medium'), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('ResponsiveDebugOverlay can inspect container constraints',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xl.start);

    await tester.pumpWidget(
      const MaterialApp(
        home: Center(
          child: SizedBox(
            width: 320,
            height: 180,
            child: ResponsiveDebugOverlay(
              label: 'pane',
              useContainerConstraints: true,
              child: Placeholder(),
            ),
          ),
        ),
      ),
    );

    expect(find.text('pane'), findsOneWidget);
    expect(find.text('breakpoint: xs'), findsOneWidget);
    expect(find.text('adaptive: compact'), findsOneWidget);
    expect(find.text('size: 320 x 180'), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('ResponsiveDebugOverlay can shrink into short containers',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xl.start);

    await tester.pumpWidget(
      const MaterialApp(
        home: Center(
          child: SizedBox(
            width: 320,
            height: 48,
            child: ResponsiveDebugOverlay(
              label: 'tiny',
              useContainerConstraints: true,
              child: Placeholder(),
            ),
          ),
        ),
      ),
    );

    expect(find.text('tiny'), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);

    resetScreenSize(tester);
  });
}
