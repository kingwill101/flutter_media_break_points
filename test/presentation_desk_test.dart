import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';
import 'package:media_break_points/patterns.dart';

import 'shared.dart';

const _slides = [
  'Intro',
  'Roadmap',
  'Launch',
];

Widget _slideItemBuilder(
  BuildContext context,
  String slide,
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
        child: Text(slide),
      ),
    ),
  );
}

Widget _stageBuilder(BuildContext context, String slide) {
  return Container(
    key: Key('stage-$slide'),
    height: 180,
    alignment: Alignment.centerLeft,
    child: Text('Stage: $slide'),
  );
}

Widget _notesBuilder(BuildContext context, String slide) {
  return Container(
    key: Key('notes-$slide'),
    height: 120,
    alignment: Alignment.centerLeft,
    child: Text('Notes: $slide'),
  );
}

void main() {
  testWidgets('AdaptivePresentationDesk shows modal triggers on compact widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdaptivePresentationDesk<String>(
            slides: _slides,
            listTitle: 'Slides',
            notesTitle: 'Speaker notes',
            itemBuilder: _slideItemBuilder,
            stageBuilder: _stageBuilder,
            notesBuilder: _notesBuilder,
          ),
        ),
      ),
    );

    expect(find.text('Open slides'), findsOneWidget);
    expect(find.text('Open notes'), findsOneWidget);
    expect(find.byKey(const Key('stage-Intro')), findsOneWidget);
    expect(find.byKey(const Key('notes-Intro')), findsNothing);

    await tester.tap(find.text('Open notes'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('notes-Intro')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptivePresentationDesk docks slide list on medium widths',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.md.start, 720);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 520,
            child: AdaptivePresentationDesk<String>(
              slides: _slides,
              listTitle: 'Slides',
              notesTitle: 'Speaker notes',
              itemBuilder: _slideItemBuilder,
              stageBuilder: _stageBuilder,
              notesBuilder: _notesBuilder,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open slides'), findsNothing);
    expect(find.text('Open notes'), findsOneWidget);
    expect(find.byKey(const Key('notes-Intro')), findsNothing);

    await tester.tap(find.text('Roadmap'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('stage-Roadmap')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets(
      'AdaptivePresentationDesk docks slide list and notes on expanded widths',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 720);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 620,
            child: AdaptivePresentationDesk<String>(
              slides: _slides,
              listTitle: 'Slides',
              notesTitle: 'Speaker notes',
              itemBuilder: _slideItemBuilder,
              stageBuilder: _stageBuilder,
              notesBuilder: _notesBuilder,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open slides'), findsNothing);
    expect(find.text('Open notes'), findsNothing);
    expect(find.byKey(const Key('notes-Intro')), findsOneWidget);

    await tester.tap(find.text('Launch'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('stage-Launch')), findsOneWidget);
    expect(find.byKey(const Key('notes-Launch')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptivePresentationDesk can use narrow container constraints',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 720);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 360,
              height: 520,
              child: AdaptivePresentationDesk<String>(
                slides: _slides,
                listTitle: 'Slides',
                notesTitle: 'Speaker notes',
                itemBuilder: _slideItemBuilder,
                stageBuilder: _stageBuilder,
                notesBuilder: _notesBuilder,
                useContainerConstraints: true,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open slides'), findsOneWidget);
    expect(find.text('Open notes'), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptivePresentationDesk can keep notes modal on short heights',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 520);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 420,
            child: AdaptivePresentationDesk<String>(
              slides: _slides,
              listTitle: 'Slides',
              notesTitle: 'Speaker notes',
              itemBuilder: _slideItemBuilder,
              stageBuilder: _stageBuilder,
              notesBuilder: _notesBuilder,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open slides'), findsNothing);
    expect(find.text('Open notes'), findsOneWidget);
    expect(find.byKey(const Key('notes-Intro')), findsNothing);

    resetScreenSize(tester);
  });
}
