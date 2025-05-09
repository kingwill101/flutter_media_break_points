import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:media_break_points/media_break_points.dart';

import 'shared.dart';

void main() {
  testWidgets('AdaptiveContainer changes widget based on screen size',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: AdaptiveContainer(
        configs: {
          BreakPoint.xs: AdaptiveSlot(builder: (context) => Text('XS')),
          BreakPoint.sm: AdaptiveSlot(builder: (context) => Text('SM')),
          BreakPoint.md: AdaptiveSlot(builder: (context) => Text('MD')),
          BreakPoint.lg: AdaptiveSlot(builder: (context) => Text('LG')),
          BreakPoint.xl: AdaptiveSlot(builder: (context) => Text('XL')),
          BreakPoint.xxl: AdaptiveSlot(builder: (context) => Text('XXL')),
        },
      ),
    ));

    setScreenSize(tester, BreakPoint.xs.start);
    await tester.pumpAndSettle();
    expect(find.text('XS'), findsOneWidget);

    setScreenSize(tester, BreakPoint.sm.start);
    await tester.pumpAndSettle();
    expect(find.text('SM'), findsOneWidget);

    setScreenSize(tester, BreakPoint.md.start);
    await tester.pumpAndSettle();
    expect(find.text('MD'), findsOneWidget);

    setScreenSize(tester, BreakPoint.lg.start);
    await tester.pumpAndSettle();
    expect(find.text('LG'), findsOneWidget);

    setScreenSize(tester, BreakPoint.xl.start);
    await tester.pumpAndSettle();
    expect(find.text('XL'), findsOneWidget);

    setScreenSize(tester, BreakPoint.xxl.start);
    await tester.pumpAndSettle();
    expect(find.text('XXL'), findsOneWidget);
    
    resetScreenSize(tester);
  });

  testWidgets('AdaptiveContainer supports animations between breakpoints',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: AdaptiveContainer(
        enableAnimation: true,
        animationDuration: 300,
        configs: {
          BreakPoint.xs: AdaptiveSlot(builder: (context) => Text('XS', key: Key('xs'))),
          BreakPoint.md: AdaptiveSlot(builder: (context) => Text('MD', key: Key('md'))),
        },
      ),
    ));

    // Start with xs screen size
    setScreenSize(tester, BreakPoint.xs.start);
    await tester.pumpAndSettle();
    expect(find.byKey(Key('xs')), findsOneWidget);

    // Change to md screen size
    setScreenSize(tester, BreakPoint.md.start);
    
    // Check that animation is in progress
    await tester.pump(Duration(milliseconds: 150));
    
    // After animation completes, md should be visible
    await tester.pumpAndSettle();
    expect(find.byKey(Key('md')), findsOneWidget);
    expect(find.byKey(Key('xs')), findsNothing);
    
    resetScreenSize(tester);
  });

  testWidgets('AdaptiveContainer uses custom transition builder',
      (WidgetTester tester) async {
    // This is a bit harder to test directly, but we can verify it doesn't crash
    await tester.pumpWidget(MaterialApp(
      home: AdaptiveContainer(
        enableAnimation: true,
        animationDuration: 300,
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
        configs: {
          BreakPoint.xs: AdaptiveSlot(builder: (context) => Text('XS')),
          BreakPoint.md: AdaptiveSlot(builder: (context) => Text('MD')),
        },
      ),
    ));

    // Start with xs screen size
    setScreenSize(tester, BreakPoint.xs.start);
    await tester.pumpAndSettle();
    expect(find.text('XS'), findsOneWidget);

    // Change to md screen size
    setScreenSize(tester, BreakPoint.md.start);
    await tester.pumpAndSettle();
    expect(find.text('MD'), findsOneWidget);
    
    resetScreenSize(tester);
  });
}
