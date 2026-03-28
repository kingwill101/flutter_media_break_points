import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';

import 'shared.dart';

void main() {
  testWidgets('AdaptiveInspectorLayout shows a modal trigger on compact widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdaptiveInspectorLayout(
            inspectorTitle: 'Inspector',
            primary: Container(
              key: const Key('primary'),
              height: 80,
            ),
            inspector: Container(
              key: const Key('inspector'),
              height: 80,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open inspector'), findsOneWidget);
    expect(find.byKey(const Key('inspector')), findsNothing);

    await tester.tap(find.text('Open inspector'));
    await tester.pumpAndSettle();

    expect(find.text('Inspector'), findsOneWidget);
    expect(find.byKey(const Key('inspector')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveInspectorLayout docks inspector on larger widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 220,
            child: AdaptiveInspectorLayout(
              inspectorTitle: 'Inspector',
              primary: Container(
                key: const Key('primary'),
              ),
              inspector: Container(
                key: const Key('inspector'),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open inspector'), findsNothing);
    expect(find.text('Inspector'), findsOneWidget);

    final primaryRect = tester.getRect(find.byKey(const Key('primary')));
    final inspectorRect = tester.getRect(find.byKey(const Key('inspector')));
    expect(primaryRect.left < inspectorRect.left, isTrue);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveInspectorLayout can use narrow container constraints',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xxl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            width: 320,
            child: AdaptiveInspectorLayout(
              inspectorTitle: 'Inspector',
              primary: Container(
                key: const Key('primary'),
                height: 80,
              ),
              inspector: Container(
                key: const Key('inspector'),
                height: 80,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open inspector'), findsOneWidget);
    expect(find.text('Inspector'), findsNothing);

    resetScreenSize(tester);
  });

  testWidgets(
      'AdaptiveInspectorLayout can keep wide layouts modal on short heights',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xl.start, 420);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdaptiveInspectorLayout(
            inspectorTitle: 'Inspector',
            minimumDockedHeight: AdaptiveHeight.medium,
            primary: Container(
              key: const Key('primary'),
              height: 80,
            ),
            inspector: Container(
              key: const Key('inspector'),
              height: 80,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open inspector'), findsOneWidget);
    expect(find.text('Inspector'), findsNothing);

    resetScreenSize(tester);
  });
}
