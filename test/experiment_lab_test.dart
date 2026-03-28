import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';
import 'package:media_break_points/patterns.dart';

import 'shared.dart';

const _experiments = [
  'Checkout copy',
  'Onboarding checklist',
  'Search zero-state',
];

Widget _itemBuilder(
  BuildContext context,
  String experiment,
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
        child: Text(experiment),
      ),
    ),
  );
}

Widget _focusBuilder(BuildContext context, String experiment) {
  return Container(
    key: Key('focus-$experiment'),
    alignment: Alignment.centerLeft,
    child: Text('Focus: $experiment'),
  );
}

Widget _evidenceBuilder(BuildContext context, String experiment) {
  return Container(
    key: Key('evidence-$experiment'),
    alignment: Alignment.centerLeft,
    child: Text('Evidence: $experiment'),
  );
}

Widget _decisionBuilder(BuildContext context, String experiment) {
  return Container(
    key: Key('decision-$experiment'),
    alignment: Alignment.centerLeft,
    child: Text('Decision: $experiment'),
  );
}

void main() {
  testWidgets('AdaptiveExperimentLab shows modal triggers on compact widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdaptiveExperimentLab<String>(
            experiments: _experiments,
            experimentTitle: 'Experiments',
            evidenceTitle: 'Evidence',
            decisionTitle: 'Decisions',
            itemBuilder: _itemBuilder,
            focusBuilder: _focusBuilder,
            evidenceBuilder: _evidenceBuilder,
            decisionBuilder: _decisionBuilder,
          ),
        ),
      ),
    );

    expect(find.text('Open experiments'), findsOneWidget);
    expect(find.text('Open evidence'), findsOneWidget);
    expect(find.text('Open decisions'), findsOneWidget);
    expect(find.byKey(const Key('focus-Checkout copy')), findsOneWidget);
    expect(find.byKey(const Key('evidence-Checkout copy')), findsNothing);

    await tester.tap(find.text('Open evidence'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('evidence-Checkout copy')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveExperimentLab docks experiments on medium widths',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.md.start, 720);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 520,
            child: AdaptiveExperimentLab<String>(
              experiments: _experiments,
              experimentTitle: 'Experiments',
              evidenceTitle: 'Evidence',
              decisionTitle: 'Decisions',
              itemBuilder: _itemBuilder,
              focusBuilder: _focusBuilder,
              evidenceBuilder: _evidenceBuilder,
              decisionBuilder: _decisionBuilder,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open experiments'), findsNothing);
    expect(find.text('Open evidence'), findsOneWidget);
    expect(find.text('Open decisions'), findsOneWidget);
    expect(find.byKey(const Key('evidence-Checkout copy')), findsNothing);

    await tester.tap(find.text('Onboarding checklist'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('focus-Onboarding checklist')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets(
      'AdaptiveExperimentLab docks evidence but keeps decisions modal on short heights',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 720);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 560,
            child: AdaptiveExperimentLab<String>(
              experiments: _experiments,
              experimentTitle: 'Experiments',
              evidenceTitle: 'Evidence',
              decisionTitle: 'Decisions',
              itemBuilder: _itemBuilder,
              focusBuilder: _focusBuilder,
              evidenceBuilder: _evidenceBuilder,
              decisionBuilder: _decisionBuilder,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open experiments'), findsNothing);
    expect(find.text('Open evidence'), findsNothing);
    expect(find.text('Open decisions'), findsOneWidget);
    expect(find.byKey(const Key('evidence-Checkout copy')), findsOneWidget);
    expect(find.byKey(const Key('decision-Checkout copy')), findsNothing);

    await tester.tap(find.text('Open decisions'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('decision-Checkout copy')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveExperimentLab fully docks on tall expanded layouts',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 920);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 840,
            child: AdaptiveExperimentLab<String>(
              experiments: _experiments,
              experimentTitle: 'Experiments',
              evidenceTitle: 'Evidence',
              decisionTitle: 'Decisions',
              itemBuilder: _itemBuilder,
              focusBuilder: _focusBuilder,
              evidenceBuilder: _evidenceBuilder,
              decisionBuilder: _decisionBuilder,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open experiments'), findsNothing);
    expect(find.text('Open evidence'), findsNothing);
    expect(find.text('Open decisions'), findsNothing);
    expect(find.byKey(const Key('evidence-Checkout copy')), findsOneWidget);
    expect(find.byKey(const Key('decision-Checkout copy')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets(
      'AdaptiveExperimentLab can use narrow container constraints for local layout',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 920);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 420,
              height: 520,
              child: AdaptiveExperimentLab<String>(
                experiments: _experiments,
                experimentTitle: 'Experiments',
                evidenceTitle: 'Evidence',
                decisionTitle: 'Decisions',
                useContainerConstraints: true,
                itemBuilder: _itemBuilder,
                focusBuilder: _focusBuilder,
                evidenceBuilder: _evidenceBuilder,
                decisionBuilder: _decisionBuilder,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open experiments'), findsOneWidget);
    expect(find.text('Open evidence'), findsOneWidget);
    expect(find.text('Open decisions'), findsOneWidget);

    resetScreenSize(tester);
  });
}
