import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';
import 'shared.dart';

void main() {
  testWidgets('MediaBreakPointsConfig allows custom breakpoints', (WidgetTester tester) async {
    // Define custom breakpoints
    final customBreakpoints = {
      BreakPoint.xs: (0.0, 400.0),
      BreakPoint.sm: (401.0, 600.0),
      BreakPoint.md: (601.0, 800.0),
      BreakPoint.lg: (801.0, 1000.0),
      BreakPoint.xl: (1001.0, 1200.0),
      BreakPoint.xxl: (1201.0, 0.0),
    };

    // Initialize with custom configuration
    initMediaBreakPoints(
      MediaBreakPointsConfig(
        customBreakpoints: customBreakpoints,
      ),
    );

    late BreakPoint detectedBreakpoint;

    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) {
          detectedBreakpoint = context.breakPoint;
          return Text('Breakpoint: ${detectedBreakpoint.label}');
        },
      ),
    ));

    // Test with 350px width (should be xs with custom breakpoints)
    setScreenSize(tester, 350);
    await tester.pumpAndSettle();
    expect(detectedBreakpoint, BreakPoint.xs);

    // Test with 450px width (should be sm with custom breakpoints)
    setScreenSize(tester, 450);
    await tester.pumpAndSettle();
    expect(detectedBreakpoint, BreakPoint.sm);

    // Test with 650px width (should be md with custom breakpoints)
    setScreenSize(tester, 650);
    await tester.pumpAndSettle();
    expect(detectedBreakpoint, BreakPoint.md);

    // Test with 850px width (should be lg with custom breakpoints)
    setScreenSize(tester, 850);
    await tester.pumpAndSettle();
    expect(detectedBreakpoint, BreakPoint.lg);

    // Test with 1050px width (should be xl with custom breakpoints)
    setScreenSize(tester, 1050);
    await tester.pumpAndSettle();
    expect(detectedBreakpoint, BreakPoint.xl);

    // Test with 1250px width (should be xxl with custom breakpoints)
    setScreenSize(tester, 1250);
    await tester.pumpAndSettle();
    expect(detectedBreakpoint, BreakPoint.xxl);

    // Reset to default breakpoints for other tests
    initMediaBreakPoints(
      MediaBreakPointsConfig(),
    );

    resetScreenSize(tester);
  });

  testWidgets('MediaBreakPointsConfig considerOrientation affects breakpoint detection', (WidgetTester tester) async {
    // Initialize with orientation consideration
    initMediaBreakPoints(
      MediaBreakPointsConfig(
        considerOrientation: true,
      ),
    );

    late BreakPoint detectedBreakpoint;

    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) {
          detectedBreakpoint = context.breakPoint;
          return Text('Breakpoint: ${detectedBreakpoint.label}');
        },
      ),
    ));

    // Test with portrait orientation at sm breakpoint
    setScreenSize(tester, BreakPoint.sm.start);
    setOrientation(tester, Orientation.portrait);
    await tester.pumpAndSettle();
    final portraitBreakpoint = detectedBreakpoint;

    // Test with landscape orientation at same width
    // This should bump up the breakpoint by one level
    setOrientation(tester, Orientation.landscape);
    await tester.pumpAndSettle();
    final landscapeBreakpoint = detectedBreakpoint;

    // The landscape breakpoint should be one level higher
    expect(landscapeBreakpoint.index > portraitBreakpoint.index, true);

    // Reset to default configuration for other tests
    initMediaBreakPoints(
      MediaBreakPointsConfig(),
    );

    resetScreenSize(tester);
  });
}