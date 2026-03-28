import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';
import 'package:media_break_points/patterns.dart';

import 'shared.dart';

const _plans = [
  'Q3 launch',
  'Analytics refresh',
  'Workspace migration',
];

Widget _itemBuilder(
  BuildContext context,
  String plan,
  bool selected,
  VoidCallback onTap,
) {
  return Material(
    color: selected ? Colors.blue.shade50 : Colors.grey.shade100,
    borderRadius: BorderRadius.circular(16),
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(plan),
      ),
    ),
  );
}

Widget _focusBuilder(BuildContext context, String plan) {
  return Container(
    key: Key('focus-$plan'),
    alignment: Alignment.centerLeft,
    child: Text('Focus: $plan'),
  );
}

Widget _risksBuilder(BuildContext context, String plan) {
  return Container(
    key: Key('risks-$plan'),
    alignment: Alignment.centerLeft,
    child: Text('Risks: $plan'),
  );
}

Widget _milestonesBuilder(BuildContext context, String plan) {
  return Container(
    key: Key('milestones-$plan'),
    alignment: Alignment.centerLeft,
    child: Text('Milestones: $plan'),
  );
}

void main() {
  testWidgets('AdaptivePlanningDesk shows modal triggers on compact widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdaptivePlanningDesk<String>(
            plans: _plans,
            planTitle: 'Plans',
            risksTitle: 'Risks',
            milestonesTitle: 'Milestones',
            itemBuilder: _itemBuilder,
            focusBuilder: _focusBuilder,
            risksBuilder: _risksBuilder,
            milestonesBuilder: _milestonesBuilder,
          ),
        ),
      ),
    );

    expect(find.text('Open plans'), findsOneWidget);
    expect(find.text('Open risks'), findsOneWidget);
    expect(find.text('Open milestones'), findsOneWidget);
    expect(find.byKey(const Key('focus-Q3 launch')), findsOneWidget);
    expect(find.byKey(const Key('risks-Q3 launch')), findsNothing);

    await tester.tap(find.text('Open risks'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('risks-Q3 launch')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptivePlanningDesk docks plans on medium widths',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.md.start, 720);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 520,
            child: AdaptivePlanningDesk<String>(
              plans: _plans,
              planTitle: 'Plans',
              risksTitle: 'Risks',
              milestonesTitle: 'Milestones',
              itemBuilder: _itemBuilder,
              focusBuilder: _focusBuilder,
              risksBuilder: _risksBuilder,
              milestonesBuilder: _milestonesBuilder,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open plans'), findsNothing);
    expect(find.text('Open risks'), findsOneWidget);
    expect(find.text('Open milestones'), findsOneWidget);
    expect(find.byKey(const Key('risks-Q3 launch')), findsNothing);

    await tester.tap(find.text('Analytics refresh'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('focus-Analytics refresh')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets(
      'AdaptivePlanningDesk docks risks but keeps milestones modal on short heights',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 720);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 560,
            child: AdaptivePlanningDesk<String>(
              plans: _plans,
              planTitle: 'Plans',
              risksTitle: 'Risks',
              milestonesTitle: 'Milestones',
              itemBuilder: _itemBuilder,
              focusBuilder: _focusBuilder,
              risksBuilder: _risksBuilder,
              milestonesBuilder: _milestonesBuilder,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open plans'), findsNothing);
    expect(find.text('Open risks'), findsNothing);
    expect(find.text('Open milestones'), findsOneWidget);
    expect(find.byKey(const Key('risks-Q3 launch')), findsOneWidget);
    expect(find.byKey(const Key('milestones-Q3 launch')), findsNothing);

    await tester.tap(find.text('Open milestones'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('milestones-Q3 launch')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptivePlanningDesk fully docks on tall expanded layouts',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 920);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 840,
            child: AdaptivePlanningDesk<String>(
              plans: _plans,
              planTitle: 'Plans',
              risksTitle: 'Risks',
              milestonesTitle: 'Milestones',
              itemBuilder: _itemBuilder,
              focusBuilder: _focusBuilder,
              risksBuilder: _risksBuilder,
              milestonesBuilder: _milestonesBuilder,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open plans'), findsNothing);
    expect(find.text('Open risks'), findsNothing);
    expect(find.text('Open milestones'), findsNothing);
    expect(find.byKey(const Key('risks-Q3 launch')), findsOneWidget);
    expect(find.byKey(const Key('milestones-Q3 launch')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets(
      'AdaptivePlanningDesk can use narrow container constraints for local layout',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 920);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 420,
              height: 520,
              child: AdaptivePlanningDesk<String>(
                plans: _plans,
                planTitle: 'Plans',
                risksTitle: 'Risks',
                milestonesTitle: 'Milestones',
                useContainerConstraints: true,
                itemBuilder: _itemBuilder,
                focusBuilder: _focusBuilder,
                risksBuilder: _risksBuilder,
                milestonesBuilder: _milestonesBuilder,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open plans'), findsOneWidget);
    expect(find.text('Open risks'), findsOneWidget);
    expect(find.text('Open milestones'), findsOneWidget);

    resetScreenSize(tester);
  });
}
