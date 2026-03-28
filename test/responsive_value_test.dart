import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';

import 'shared.dart';

void main() {
  testWidgets('ResponsiveValue cascades down to smaller breakpoints',
      (WidgetTester tester) async {
    late String? resolvedValue;

    setScreenSize(tester, BreakPoint.lg.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            resolvedValue = context.responsive<String>(
              md: 'tablet',
              resolveMode: ResponsiveResolveMode.cascadeDown,
            );
            return const Placeholder();
          },
        ),
      ),
    );

    expect(resolvedValue, 'tablet');
    resetScreenSize(tester);
  });

  testWidgets('ResponsiveValue resolves semantic adaptive sizes',
      (WidgetTester tester) async {
    late String? resolvedValue;

    setScreenSize(tester, BreakPoint.xl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            resolvedValue = context.responsive<String>(
              expanded: 'desktop',
            );
            return const Placeholder();
          },
        ),
      ),
    );

    expect(resolvedValue, 'desktop');
    resetScreenSize(tester);
  });

  testWidgets('BreakPointData exposes semantic size information',
      (WidgetTester tester) async {
    late BreakPointData data;

    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            data = context.breakPointData;
            return const Placeholder();
          },
        ),
      ),
    );

    expect(data.breakPoint, BreakPoint.sm);
    expect(data.adaptiveSize, AdaptiveSize.compact);
    expect(data.isCompact, isTrue);
    resetScreenSize(tester);
  });

  testWidgets('BreakPointData exposes semantic height information',
      (WidgetTester tester) async {
    late BreakPointData data;

    setPhysicalSize(tester, BreakPoint.xl.start, 420);

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            data = context.breakPointData;
            return const Placeholder();
          },
        ),
      ),
    );

    expect(data.adaptiveHeight, AdaptiveHeight.compact);
    expect(data.isHeightCompact, isTrue);
    resetScreenSize(tester);
  });

  testWidgets('ResponsiveValue resolves height semantic values',
      (WidgetTester tester) async {
    late String? resolvedValue;

    setPhysicalSize(tester, BreakPoint.xl.start, 420);

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            resolvedValue = context.responsive<String>(
              heightCompact: 'short-view',
            );
            return const Placeholder();
          },
        ),
      ),
    );

    expect(resolvedValue, 'short-view');
    resetScreenSize(tester);
  });

  testWidgets('ResponsiveValue keeps width semantics ahead of height semantics',
      (WidgetTester tester) async {
    late String? resolvedValue;

    setPhysicalSize(tester, BreakPoint.xl.start, 420);

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            resolvedValue = context.responsive<String>(
              expanded: 'desktop',
              heightCompact: 'short-view',
            );
            return const Placeholder();
          },
        ),
      ),
    );

    expect(resolvedValue, 'desktop');
    resetScreenSize(tester);
  });
}
