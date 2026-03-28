import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';
import 'package:media_break_points/patterns.dart';

import 'shared.dart';

const _incidents = [
  'Checkout API',
  'Editor sync',
  'Search indexing',
];

Widget _itemBuilder(
  BuildContext context,
  String incident,
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
        child: Text(incident),
      ),
    ),
  );
}

Widget _detailBuilder(BuildContext context, String incident) {
  return Container(
    key: Key('detail-$incident'),
    alignment: Alignment.centerLeft,
    child: Text('Detail: $incident'),
  );
}

Widget _contextBuilder(BuildContext context, String incident) {
  return Container(
    key: Key('context-$incident'),
    alignment: Alignment.centerLeft,
    child: Text('Context: $incident'),
  );
}

Widget _timelineBuilder(BuildContext context, String incident) {
  return Container(
    key: Key('timeline-$incident'),
    alignment: Alignment.centerLeft,
    child: Text('Timeline: $incident'),
  );
}

void main() {
  testWidgets('AdaptiveIncidentDesk shows modal triggers on compact widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdaptiveIncidentDesk<String>(
            incidents: _incidents,
            listTitle: 'Incidents',
            contextTitle: 'Context',
            timelineTitle: 'Timeline',
            itemBuilder: _itemBuilder,
            detailBuilder: _detailBuilder,
            contextBuilder: _contextBuilder,
            timelineBuilder: _timelineBuilder,
          ),
        ),
      ),
    );

    expect(find.text('Open incidents'), findsOneWidget);
    expect(find.text('Open context'), findsOneWidget);
    expect(find.text('Open timeline'), findsOneWidget);
    expect(find.byKey(const Key('detail-Checkout API')), findsOneWidget);
    expect(find.byKey(const Key('context-Checkout API')), findsNothing);

    await tester.tap(find.text('Open context'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('context-Checkout API')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveIncidentDesk docks list on medium widths',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.md.start, 720);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 520,
            child: AdaptiveIncidentDesk<String>(
              incidents: _incidents,
              listTitle: 'Incidents',
              contextTitle: 'Context',
              timelineTitle: 'Timeline',
              itemBuilder: _itemBuilder,
              detailBuilder: _detailBuilder,
              contextBuilder: _contextBuilder,
              timelineBuilder: _timelineBuilder,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open incidents'), findsNothing);
    expect(find.text('Open context'), findsOneWidget);
    expect(find.text('Open timeline'), findsOneWidget);
    expect(find.byKey(const Key('context-Checkout API')), findsNothing);

    await tester.tap(find.text('Editor sync'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('detail-Editor sync')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets(
      'AdaptiveIncidentDesk docks side panels but keeps timeline modal on short heights',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 720);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 560,
            child: AdaptiveIncidentDesk<String>(
              incidents: _incidents,
              listTitle: 'Incidents',
              contextTitle: 'Context',
              timelineTitle: 'Timeline',
              itemBuilder: _itemBuilder,
              detailBuilder: _detailBuilder,
              contextBuilder: _contextBuilder,
              timelineBuilder: _timelineBuilder,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open incidents'), findsNothing);
    expect(find.text('Open context'), findsNothing);
    expect(find.text('Open timeline'), findsOneWidget);
    expect(find.byKey(const Key('context-Checkout API')), findsOneWidget);
    expect(find.byKey(const Key('timeline-Checkout API')), findsNothing);

    await tester.tap(find.text('Open timeline'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('timeline-Checkout API')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveIncidentDesk fully docks on tall expanded layouts',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 920);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 840,
            child: AdaptiveIncidentDesk<String>(
              incidents: _incidents,
              listTitle: 'Incidents',
              contextTitle: 'Context',
              timelineTitle: 'Timeline',
              itemBuilder: _itemBuilder,
              detailBuilder: _detailBuilder,
              contextBuilder: _contextBuilder,
              timelineBuilder: _timelineBuilder,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open incidents'), findsNothing);
    expect(find.text('Open context'), findsNothing);
    expect(find.text('Open timeline'), findsNothing);
    expect(find.byKey(const Key('context-Checkout API')), findsOneWidget);
    expect(find.byKey(const Key('timeline-Checkout API')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets(
      'AdaptiveIncidentDesk can use narrow container constraints for local layout',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 920);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 420,
              height: 520,
              child: AdaptiveIncidentDesk<String>(
                incidents: _incidents,
                listTitle: 'Incidents',
                contextTitle: 'Context',
                timelineTitle: 'Timeline',
                useContainerConstraints: true,
                itemBuilder: _itemBuilder,
                detailBuilder: _detailBuilder,
                contextBuilder: _contextBuilder,
                timelineBuilder: _timelineBuilder,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open incidents'), findsOneWidget);
    expect(find.text('Open context'), findsOneWidget);
    expect(find.text('Open timeline'), findsOneWidget);

    resetScreenSize(tester);
  });
}
