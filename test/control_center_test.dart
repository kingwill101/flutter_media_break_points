import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';
import 'package:media_break_points/patterns.dart';

import 'shared.dart';

const _mainKey = Key('control-center-main');
const _sidebarKey = Key('control-center-sidebar');
const _insightsKey = Key('control-center-insights');
const _activityKey = Key('control-center-activity');

Widget _surface(String label, Key key) {
  return Container(
    key: key,
    alignment: Alignment.centerLeft,
    child: Text(label),
  );
}

AdaptiveControlCenter _buildControlCenter({
  bool useContainerConstraints = true,
}) {
  return AdaptiveControlCenter(
    useContainerConstraints: useContainerConstraints,
    sidebarTitle: 'Services',
    insightsTitle: 'Insights',
    activityTitle: 'Activity',
    main: _surface('Main dashboard', _mainKey),
    sidebar: _surface('Service list', _sidebarKey),
    insights: _surface('Insights panel', _insightsKey),
    activity: _surface('Activity stream', _activityKey),
  );
}

void main() {
  testWidgets('AdaptiveControlCenter shows modal triggers on compact widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: _buildControlCenter(),
        ),
      ),
    );

    expect(find.text('Open sidebar'), findsOneWidget);
    expect(find.text('Open insights'), findsOneWidget);
    expect(find.text('Open activity'), findsOneWidget);
    expect(find.byKey(_mainKey), findsOneWidget);
    expect(find.byKey(_insightsKey), findsNothing);

    await tester.tap(find.text('Open insights'));
    await tester.pumpAndSettle();

    expect(find.byKey(_insightsKey), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveControlCenter docks sidebar on medium widths',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.md.start, 720);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 520,
            child: _buildControlCenter(),
          ),
        ),
      ),
    );

    expect(find.text('Open sidebar'), findsNothing);
    expect(find.text('Open insights'), findsOneWidget);
    expect(find.text('Open activity'), findsOneWidget);
    expect(find.byKey(_sidebarKey), findsOneWidget);
    expect(find.byKey(_insightsKey), findsNothing);

    resetScreenSize(tester);
  });

  testWidgets(
      'AdaptiveControlCenter docks side panels but keeps activity modal on short heights',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 720);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 560,
            child: _buildControlCenter(),
          ),
        ),
      ),
    );

    expect(find.text('Open sidebar'), findsNothing);
    expect(find.text('Open insights'), findsNothing);
    expect(find.text('Open activity'), findsOneWidget);
    expect(find.byKey(_sidebarKey), findsOneWidget);
    expect(find.byKey(_insightsKey), findsOneWidget);
    expect(find.byKey(_activityKey), findsNothing);

    await tester.tap(find.text('Open activity'));
    await tester.pumpAndSettle();

    expect(find.byKey(_activityKey), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveControlCenter fully docks on tall expanded layouts',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 920);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 840,
            child: _buildControlCenter(),
          ),
        ),
      ),
    );

    expect(find.text('Open sidebar'), findsNothing);
    expect(find.text('Open insights'), findsNothing);
    expect(find.text('Open activity'), findsNothing);
    expect(find.byKey(_sidebarKey), findsOneWidget);
    expect(find.byKey(_insightsKey), findsOneWidget);
    expect(find.byKey(_activityKey), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets(
      'AdaptiveControlCenter can use narrow container constraints for local layout',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 920);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 420,
              height: 520,
              child: _buildControlCenter(useContainerConstraints: true),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open sidebar'), findsOneWidget);
    expect(find.text('Open insights'), findsOneWidget);
    expect(find.text('Open activity'), findsOneWidget);

    resetScreenSize(tester);
  });
}
