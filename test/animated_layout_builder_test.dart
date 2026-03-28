import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';

import 'shared.dart';

void main() {
  testWidgets('AnimatedResponsiveLayoutBuilder switches layouts with animation',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AnimatedResponsiveLayoutBuilder(
            duration: const Duration(milliseconds: 120),
            xs: (context, breakpoint) =>
                const Text('XS Layout', key: Key('xs')),
            md: (context, breakpoint) =>
                const Text('MD Layout', key: Key('md')),
          ),
        ),
      ),
    );

    setScreenSize(tester, BreakPoint.xs.start);
    await tester.pumpAndSettle();
    expect(find.byType(AnimatedSwitcher), findsOneWidget);
    expect(find.byKey(const Key('xs')), findsOneWidget);

    setScreenSize(tester, BreakPoint.md.start);
    await tester.pump();
    expect(find.byType(AnimatedSwitcher), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('md')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets(
      'AnimatedResponsiveLayoutBuilder can animate on parent constraints',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            width: 320,
            child: AnimatedResponsiveLayoutBuilder(
              useContainerConstraints: true,
              xs: (context, breakpoint) => const Text('container-xs'),
              lg: (context, breakpoint) => const Text('container-lg'),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('container-xs'), findsOneWidget);
    expect(find.text('container-lg'), findsNothing);

    resetScreenSize(tester);
  });
}
