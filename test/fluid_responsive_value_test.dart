import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';

import 'shared.dart';

void main() {
  testWidgets('FluidResponsiveValue interpolates between breakpoint anchors',
      (WidgetTester tester) async {
    late double resolvedValue;

    setScreenSize(tester, 672);

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            resolvedValue = context.fluidResponsive<double>(
              lerp: (a, b, t) => lerpDouble(a, b, t) ?? a,
              sm: 10,
              md: 20,
            )!;
            return const Placeholder();
          },
        ),
      ),
    );

    expect(resolvedValue, closeTo(15, 0.001));
    resetScreenSize(tester);
  });

  testWidgets('FluidResponsiveValue supports semantic anchors',
      (WidgetTester tester) async {
    late double resolvedValue;

    setScreenSize(tester, 880);

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            resolvedValue = context.fluidResponsive<double>(
              lerp: (a, b, t) => lerpDouble(a, b, t) ?? a,
              compact: 12,
              medium: 20,
              expanded: 36,
            )!;
            return const Placeholder();
          },
        ),
      ),
    );

    expect(resolvedValue, closeTo(28, 0.001));
    resetScreenSize(tester);
  });

  testWidgets('Fluid spacing and typography helpers interpolate values',
      (WidgetTester tester) async {
    late SizedBox gap;
    late double fontSize;

    setScreenSize(tester, 672);

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            gap = ResponsiveSpacing.fluidGap(
              context,
              sm: 8,
              md: 16,
            );
            fontSize = ResponsiveTextStyle.fluidFontSize(
              context,
              sm: 16,
              md: 24,
            );
            return const Placeholder();
          },
        ),
      ),
    );

    expect(gap.height, closeTo(12, 0.001));
    expect(fontSize, closeTo(20, 0.001));
    resetScreenSize(tester);
  });
}
