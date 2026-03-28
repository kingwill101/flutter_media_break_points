import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';

import 'shared.dart';

void main() {
  testWidgets('ResponsiveContainerBuilder resolves breakpoint from container',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            width: 320,
            child: ResponsiveContainerBuilder(
              builder: (context, data) {
                return Text(
                  data.breakPoint == BreakPoint.xs ? 'xs' : 'not-xs',
                );
              },
            ),
          ),
        ),
      ),
    );

    expect(find.text('xs'), findsOneWidget);
    resetScreenSize(tester);
  });

  testWidgets(
      'ResponsiveLayoutBuilder can use parent constraints instead of screen size',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            width: 320,
            child: ResponsiveLayoutBuilder(
              useContainerConstraints: true,
              xs: (context, breakpoint) => const Text('container-xs'),
              lg: (context, breakpoint) => const Text('screen-lg'),
            ),
          ),
        ),
      ),
    );

    expect(find.text('container-xs'), findsOneWidget);
    expect(find.text('screen-lg'), findsNothing);
    resetScreenSize(tester);
  });
}
