import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';

import 'shared.dart';

List<AdaptiveFormSection> _sections() {
  return const [
    AdaptiveFormSection(
      title: 'Workspace',
      description: 'Naming and ownership defaults.',
      children: [
        Text('Workspace content'),
      ],
    ),
    AdaptiveFormSection(
      title: 'Governance',
      description: 'Review cadence and approvals.',
      children: [
        Text('Governance content'),
      ],
    ),
    AdaptiveFormSection(
      title: 'Notifications',
      description: 'Channels and escalation routing.',
      children: [
        Text('Notifications content'),
      ],
    ),
  ];
}

void main() {
  testWidgets('AdaptiveForm shows a stepper on compact widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 360,
            child: AdaptiveForm(sections: _sections()),
          ),
        ),
      ),
    );

    expect(find.byType(Stepper), findsOneWidget);
    expect(find.text('Workspace content'), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveForm lays sections out as cards on larger widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 900,
            child: AdaptiveForm(sections: _sections()),
          ),
        ),
      ),
    );

    expect(find.byType(Stepper), findsNothing);
    expect(find.byType(Card), findsNWidgets(3));

    final workspaceRect = tester.getRect(find.text('Workspace'));
    final governanceRect = tester.getRect(find.text('Governance'));

    expect(workspaceRect.left < governanceRect.left, isTrue);
    expect(workspaceRect.top, governanceRect.top);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveForm can use narrow container constraints',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xxl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            width: 340,
            child: AdaptiveForm(sections: _sections()),
          ),
        ),
      ),
    );

    expect(find.byType(Stepper), findsOneWidget);
    resetScreenSize(tester);
  });

  testWidgets('AdaptiveForm advances steps and completes',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    var completed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 360,
            child: AdaptiveForm(
              sections: const [
                AdaptiveFormSection(
                  title: 'Workspace',
                  children: [
                    Text('Workspace content'),
                  ],
                ),
                AdaptiveFormSection(
                  title: 'Notifications',
                  children: [
                    Text('Notifications content'),
                  ],
                ),
              ],
              onCompleted: () {
                completed = true;
              },
            ),
          ),
        ),
      ),
    );

    expect(
      tester.widget<Stepper>(find.byType(Stepper)).currentStep,
      equals(0),
    );

    await tester.tap(
      find.widgetWithText(FilledButton, 'Continue').hitTestable(),
    );
    await tester.pumpAndSettle();

    expect(
      tester.widget<Stepper>(find.byType(Stepper)).currentStep,
      equals(1),
    );
    expect(find.widgetWithText(FilledButton, 'Finish'), findsWidgets);

    await tester.tap(
      find.widgetWithText(FilledButton, 'Finish').hitTestable(),
    );
    await tester.pumpAndSettle();

    expect(completed, isTrue);
    resetScreenSize(tester);
  });
}
