import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';
import 'package:media_break_points/patterns.dart';

import 'shared.dart';

const _approvals = [
  'Workspace shell',
  'Analytics docs',
  'Release checklist',
];

Widget _itemBuilder(
  BuildContext context,
  String approval,
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
        child: Text(approval),
      ),
    ),
  );
}

Widget _proposalBuilder(BuildContext context, String approval) {
  return Container(
    key: Key('proposal-$approval'),
    alignment: Alignment.centerLeft,
    child: Text('Proposal: $approval'),
  );
}

Widget _criteriaBuilder(BuildContext context, String approval) {
  return Container(
    key: Key('criteria-$approval'),
    alignment: Alignment.centerLeft,
    child: Text('Criteria: $approval'),
  );
}

Widget _historyBuilder(BuildContext context, String approval) {
  return Container(
    key: Key('history-$approval'),
    alignment: Alignment.centerLeft,
    child: Text('History: $approval'),
  );
}

void main() {
  testWidgets('AdaptiveApprovalDesk shows modal triggers on compact widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdaptiveApprovalDesk<String>(
            approvals: _approvals,
            approvalTitle: 'Approvals',
            criteriaTitle: 'Criteria',
            historyTitle: 'History',
            itemBuilder: _itemBuilder,
            proposalBuilder: _proposalBuilder,
            criteriaBuilder: _criteriaBuilder,
            historyBuilder: _historyBuilder,
          ),
        ),
      ),
    );

    expect(find.text('Open approvals'), findsOneWidget);
    expect(find.text('Open criteria'), findsOneWidget);
    expect(find.text('Open history'), findsOneWidget);
    expect(find.byKey(const Key('proposal-Workspace shell')), findsOneWidget);
    expect(find.byKey(const Key('criteria-Workspace shell')), findsNothing);

    await tester.tap(find.text('Open criteria'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('criteria-Workspace shell')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveApprovalDesk docks approvals on medium widths',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.md.start, 720);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 520,
            child: AdaptiveApprovalDesk<String>(
              approvals: _approvals,
              approvalTitle: 'Approvals',
              criteriaTitle: 'Criteria',
              historyTitle: 'History',
              itemBuilder: _itemBuilder,
              proposalBuilder: _proposalBuilder,
              criteriaBuilder: _criteriaBuilder,
              historyBuilder: _historyBuilder,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open approvals'), findsNothing);
    expect(find.text('Open criteria'), findsOneWidget);
    expect(find.text('Open history'), findsOneWidget);
    expect(find.byKey(const Key('criteria-Workspace shell')), findsNothing);

    await tester.tap(find.text('Analytics docs'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('proposal-Analytics docs')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets(
      'AdaptiveApprovalDesk docks criteria but keeps history modal on short heights',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 720);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 560,
            child: AdaptiveApprovalDesk<String>(
              approvals: _approvals,
              approvalTitle: 'Approvals',
              criteriaTitle: 'Criteria',
              historyTitle: 'History',
              itemBuilder: _itemBuilder,
              proposalBuilder: _proposalBuilder,
              criteriaBuilder: _criteriaBuilder,
              historyBuilder: _historyBuilder,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open approvals'), findsNothing);
    expect(find.text('Open criteria'), findsNothing);
    expect(find.text('Open history'), findsOneWidget);
    expect(find.byKey(const Key('criteria-Workspace shell')), findsOneWidget);
    expect(find.byKey(const Key('history-Workspace shell')), findsNothing);

    await tester.tap(find.text('Open history'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('history-Workspace shell')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveApprovalDesk fully docks on tall expanded layouts',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 920);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 840,
            child: AdaptiveApprovalDesk<String>(
              approvals: _approvals,
              approvalTitle: 'Approvals',
              criteriaTitle: 'Criteria',
              historyTitle: 'History',
              itemBuilder: _itemBuilder,
              proposalBuilder: _proposalBuilder,
              criteriaBuilder: _criteriaBuilder,
              historyBuilder: _historyBuilder,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open approvals'), findsNothing);
    expect(find.text('Open criteria'), findsNothing);
    expect(find.text('Open history'), findsNothing);
    expect(find.byKey(const Key('criteria-Workspace shell')), findsOneWidget);
    expect(find.byKey(const Key('history-Workspace shell')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets(
      'AdaptiveApprovalDesk can use narrow container constraints for local layout',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 920);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 420,
              height: 520,
              child: AdaptiveApprovalDesk<String>(
                approvals: _approvals,
                approvalTitle: 'Approvals',
                criteriaTitle: 'Criteria',
                historyTitle: 'History',
                useContainerConstraints: true,
                itemBuilder: _itemBuilder,
                proposalBuilder: _proposalBuilder,
                criteriaBuilder: _criteriaBuilder,
                historyBuilder: _historyBuilder,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open approvals'), findsOneWidget);
    expect(find.text('Open criteria'), findsOneWidget);
    expect(find.text('Open history'), findsOneWidget);

    resetScreenSize(tester);
  });
}
