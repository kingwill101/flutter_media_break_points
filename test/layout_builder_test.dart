import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';
import 'shared.dart';

void main() {
  testWidgets(
      'ResponsiveLayoutBuilder shows different layouts based on breakpoint',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ResponsiveLayoutBuilder(
          xs: (context, breakpoint) => Text('XS Layout', key: Key('xs')),
          sm: (context, breakpoint) => Text('SM Layout', key: Key('sm')),
          md: (context, breakpoint) => Text('MD Layout', key: Key('md')),
          lg: (context, breakpoint) => Text('LG Layout', key: Key('lg')),
          xl: (context, breakpoint) => Text('XL Layout', key: Key('xl')),
          xxl: (context, breakpoint) => Text('XXL Layout', key: Key('xxl')),
        ),
      ),
    ));

    // Test extra small screen
    setScreenSize(tester, BreakPoint.xs.start);
    await tester.pumpAndSettle();
    expect(find.byKey(Key('xs')), findsOneWidget);
    expect(find.byKey(Key('sm')), findsNothing);
    expect(find.byKey(Key('md')), findsNothing);
    expect(find.byKey(Key('lg')), findsNothing);
    expect(find.byKey(Key('xl')), findsNothing);
    expect(find.byKey(Key('xxl')), findsNothing);

    // Test small screen
    setScreenSize(tester, BreakPoint.sm.start);
    await tester.pumpAndSettle();
    expect(find.byKey(Key('xs')), findsNothing);
    expect(find.byKey(Key('sm')), findsOneWidget);
    expect(find.byKey(Key('md')), findsNothing);
    expect(find.byKey(Key('lg')), findsNothing);
    expect(find.byKey(Key('xl')), findsNothing);
    expect(find.byKey(Key('xxl')), findsNothing);

    // Test medium screen
    setScreenSize(tester, BreakPoint.md.start);
    await tester.pumpAndSettle();
    expect(find.byKey(Key('xs')), findsNothing);
    expect(find.byKey(Key('sm')), findsNothing);
    expect(find.byKey(Key('md')), findsOneWidget);
    expect(find.byKey(Key('lg')), findsNothing);
    expect(find.byKey(Key('xl')), findsNothing);
    expect(find.byKey(Key('xxl')), findsNothing);

    // Test large screen
    setScreenSize(tester, BreakPoint.lg.start);
    await tester.pumpAndSettle();
    expect(find.byKey(Key('xs')), findsNothing);
    expect(find.byKey(Key('sm')), findsNothing);
    expect(find.byKey(Key('md')), findsNothing);
    expect(find.byKey(Key('lg')), findsOneWidget);
    expect(find.byKey(Key('xl')), findsNothing);
    expect(find.byKey(Key('xxl')), findsNothing);

    // Test extra large screen
    setScreenSize(tester, BreakPoint.xl.start);
    await tester.pumpAndSettle();
    expect(find.byKey(Key('xs')), findsNothing);
    expect(find.byKey(Key('sm')), findsNothing);
    expect(find.byKey(Key('md')), findsNothing);
    expect(find.byKey(Key('lg')), findsNothing);
    expect(find.byKey(Key('xl')), findsOneWidget);
    expect(find.byKey(Key('xxl')), findsNothing);

    // Test extra extra large screen
    setScreenSize(tester, BreakPoint.xxl.start);
    await tester.pumpAndSettle();
    expect(find.byKey(Key('xs')), findsNothing);
    expect(find.byKey(Key('sm')), findsNothing);
    expect(find.byKey(Key('md')), findsNothing);
    expect(find.byKey(Key('lg')), findsNothing);
    expect(find.byKey(Key('xl')), findsNothing);
    expect(find.byKey(Key('xxl')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets(
      'ResponsiveLayoutBuilder falls back to smaller breakpoints when needed',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ResponsiveLayoutBuilder(
          xs: (context, breakpoint) => Text('XS Layout', key: Key('xs')),
          md: (context, breakpoint) => Text('MD Layout', key: Key('md')),
          xl: (context, breakpoint) => Text('XL Layout', key: Key('xl')),
        ),
      ),
    ));

    // Test extra small screen (should use xs)
    setScreenSize(tester, BreakPoint.xs.start);
    await tester.pumpAndSettle();
    expect(find.byKey(Key('xs')), findsOneWidget);

    // Test small screen (should fall back to xs)
    setScreenSize(tester, BreakPoint.sm.start);
    await tester.pumpAndSettle();
    expect(find.byKey(Key('xs')), findsOneWidget);

    // Test medium screen (should use md)
    setScreenSize(tester, BreakPoint.md.start);
    await tester.pumpAndSettle();
    expect(find.byKey(Key('md')), findsOneWidget);

    // Test large screen (should fall back to md)
    setScreenSize(tester, BreakPoint.lg.start);
    await tester.pumpAndSettle();
    expect(find.byKey(Key('md')), findsOneWidget);

    // Test extra large screen (should use xl)
    setScreenSize(tester, BreakPoint.xl.start);
    await tester.pumpAndSettle();
    expect(find.byKey(Key('xl')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets(
      'ResponsiveLayoutBuilder uses defaultBuilder when no specific builder is found',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ResponsiveLayoutBuilder(
          defaultBuilder: (context, breakpoint) =>
              Text('Default Layout', key: Key('default')),
        ),
      ),
    ));

    // Test any screen size (should use default)
    setScreenSize(tester, BreakPoint.md.start);
    await tester.pumpAndSettle();
    expect(find.byKey(Key('default')), findsOneWidget);

    resetScreenSize(tester);
  });
}
