import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';
import 'shared.dart';

void main() {
  testWidgets('ResponsiveSpacing.padding adjusts based on screen size',
      (WidgetTester tester) async {
    late EdgeInsets padding;

    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) {
          padding = ResponsiveSpacing.padding(
            context,
            xs: EdgeInsets.all(8),
            md: EdgeInsets.all(16),
            lg: EdgeInsets.all(24),
          ) as EdgeInsets;

          return Container(padding: padding);
        },
      ),
    ));

    // Test extra small screen
    setScreenSize(tester, BreakPoint.xs.start);
    await tester.pumpAndSettle();
    expect(padding, EdgeInsets.all(8));

    // Test medium screen
    setScreenSize(tester, BreakPoint.md.start);
    await tester.pumpAndSettle();
    expect(padding, EdgeInsets.all(16));

    // Test large screen
    setScreenSize(tester, BreakPoint.lg.start);
    await tester.pumpAndSettle();
    expect(padding, EdgeInsets.all(24));

    resetScreenSize(tester);
  });

  testWidgets('ResponsiveSpacing.gap adjusts based on screen size',
      (WidgetTester tester) async {
    late double gapHeight;
    late double gapWidth;

    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) {
          final verticalGap = ResponsiveSpacing.gap(
            context,
            xs: 8,
            md: 16,
            lg: 24,
          );

          final horizontalGap = ResponsiveSpacing.gap(
            context,
            xs: 10,
            md: 20,
            lg: 30,
            direction: Axis.horizontal,
          );

          gapHeight = verticalGap.height!;
          gapWidth = horizontalGap.width!;

          return Column(
            children: [
              verticalGap,
              Row(
                children: [horizontalGap],
              ),
            ],
          );
        },
      ),
    ));

    // Test extra small screen
    setScreenSize(tester, BreakPoint.xs.start);
    await tester.pumpAndSettle();
    expect(gapHeight, 8);
    expect(gapWidth, 10);

    // Test medium screen
    setScreenSize(tester, BreakPoint.md.start);
    await tester.pumpAndSettle();
    expect(gapHeight, 16);
    expect(gapWidth, 20);

    // Test large screen
    setScreenSize(tester, BreakPoint.lg.start);
    await tester.pumpAndSettle();
    expect(gapHeight, 24);
    expect(gapWidth, 30);

    resetScreenSize(tester);
  });
}
