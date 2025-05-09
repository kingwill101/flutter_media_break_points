import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';
import 'shared.dart';

void main() {
  testWidgets('ResponsiveVisibility shows/hides content based on breakpoint',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            // Visible only on xs and sm
            ResponsiveVisibility(
              visibleXs: true,
              visibleSm: true,
              visibleMd: false,
              visibleLg: false,
              visibleXl: false,
              visibleXxl: false,
              child: Text('Mobile Only', key: Key('mobile')),
            ),
            // Visible only on md and lg
            ResponsiveVisibility(
              visibleXs: false,
              visibleSm: false,
              visibleMd: true,
              visibleLg: true,
              visibleXl: false,
              visibleXxl: false,
              child: Text('Tablet Only', key: Key('tablet')),
            ),
            // Visible only on xl and xxl
            ResponsiveVisibility(
              visibleXs: false,
              visibleSm: false,
              visibleMd: false,
              visibleLg: false,
              visibleXl: true,
              visibleXxl: true,
              child: Text('Desktop Only', key: Key('desktop')),
            ),
            // Using conditions - visible on lg and larger screens
            ResponsiveVisibility(
              visibleWhen: {
                Condition.largerThan(BreakPoint.md): true,
              },
              child: Text('Large Screens Only', key: Key('large')),
            ),
            // With replacement
            ResponsiveVisibility(
              visibleXs: false,
              visibleSm: false,
              replacement: Text('Replacement', key: Key('replacement')),
              child: Text('Original', key: Key('original')),
            ),
          ],
        ),
      ),
    ));

    // Test extra small screen
    setScreenSize(tester, BreakPoint.xs.start);
    await tester.pumpAndSettle();
    expect(find.byKey(Key('mobile')), findsOneWidget);
    expect(find.byKey(Key('tablet')), findsNothing);
    expect(find.byKey(Key('desktop')), findsNothing);

    // The 'large' widget uses Condition.largerThan(BreakPoint.md)
    // So it should not be visible on xs screens
    expect(find.byKey(Key('large')), findsNothing);

    expect(find.byKey(Key('replacement')), findsOneWidget);
    expect(find.byKey(Key('original')), findsNothing);

    // Test medium screen
    setScreenSize(tester, BreakPoint.md.start);
    await tester.pumpAndSettle();
    expect(find.byKey(Key('mobile')), findsNothing);
    expect(find.byKey(Key('tablet')), findsOneWidget);
    expect(find.byKey(Key('desktop')), findsNothing);

    // The 'large' widget uses Condition.largerThan(BreakPoint.md)
    // So it should not be visible on md screens (it needs to be larger than md)
    expect(find.byKey(Key('large')), findsNothing);

    expect(find.byKey(Key('replacement')), findsOneWidget);
    expect(find.byKey(Key('original')), findsNothing);

    // Test large screen
    setScreenSize(tester, BreakPoint.lg.start);
    await tester.pumpAndSettle();
    expect(find.byKey(Key('mobile')), findsNothing);
    expect(find.byKey(Key('tablet')), findsOneWidget);
    expect(find.byKey(Key('desktop')), findsNothing);

    // The 'large' widget uses Condition.largerThan(BreakPoint.md)
    // So it should be visible on lg screens
    expect(find.byKey(Key('large')), findsOneWidget);

    expect(find.byKey(Key('replacement')), findsOneWidget);
    expect(find.byKey(Key('original')), findsNothing);

    // Test extra large screen
    setScreenSize(tester, BreakPoint.xl.start);
    await tester.pumpAndSettle();
    expect(find.byKey(Key('mobile')), findsNothing);
    expect(find.byKey(Key('tablet')), findsNothing);
    expect(find.byKey(Key('desktop')), findsOneWidget);
    expect(find.byKey(Key('large')), findsOneWidget);
    expect(find.byKey(Key('replacement')), findsOneWidget);
    expect(find.byKey(Key('original')), findsNothing);

    resetScreenSize(tester);
  });

  testWidgets('ResponsiveVisibility maintains state when configured',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: ResponsiveVisibility(
            visibleXs: false,
            visibleSm: true,
            maintainState: true,
            child: StatefulTestWidget(key: Key('stateful')),
          ),
        ),
      ),
    ));

    // Test small screen (widget should be visible)
    setScreenSize(tester, BreakPoint.sm.start);
    await tester.pumpAndSettle();

    // Verify the widget is visible
    expect(find.byKey(Key('stateful')), findsOneWidget);

    // Increment counter
    await tester.tap(find.byKey(Key('increment')));
    await tester.pumpAndSettle();
    expect(find.text('Count: 1'), findsOneWidget);

    // Test extra small screen (widget should be hidden but state maintained)
    setScreenSize(tester, BreakPoint.xs.start);
    await tester.pumpAndSettle();

    // Widget should be hidden
    expect(find.byKey(Key('stateful')), findsNothing);
    expect(find.text('Count: 1'), findsNothing); // Text is not visible

    // Back to small screen (widget should be visible with state maintained)
    setScreenSize(tester, BreakPoint.sm.start);
    await tester.pumpAndSettle();

    // Widget should be visible again with state maintained
    expect(find.byKey(Key('stateful')), findsOneWidget);
    expect(find.text('Count: 1'), findsOneWidget);

    resetScreenSize(tester);
  });
}

class StatefulTestWidget extends StatefulWidget {
  const StatefulTestWidget({Key? key}) : super(key: key);

  @override
  _StatefulTestWidgetState createState() => _StatefulTestWidgetState();
}

class _StatefulTestWidgetState extends State<StatefulTestWidget> {
  int count = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Count: $count'),
        ElevatedButton(
          key: Key('increment'),
          onPressed: () {
            setState(() {
              count++;
            });
          },
          child: Text('Increment'),
        ),
      ],
    );
  }
}
