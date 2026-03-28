import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';
import 'package:media_break_points/patterns.dart';

import 'shared.dart';

const _conversations = [
  'Ava Johnson',
  'Noah Clarke',
  'Mia Lopez',
];

Widget _conversationItemBuilder(
  BuildContext context,
  String conversation,
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
        child: Text(conversation),
      ),
    ),
  );
}

Widget _threadBuilder(BuildContext context, String conversation) {
  return Container(
    key: Key('thread-$conversation'),
    height: 140,
    alignment: Alignment.centerLeft,
    child: Text('Thread: $conversation'),
  );
}

Widget _contextBuilder(BuildContext context, String conversation) {
  return Container(
    key: Key('context-$conversation'),
    height: 120,
    alignment: Alignment.centerLeft,
    child: Text('Context: $conversation'),
  );
}

void main() {
  testWidgets('AdaptiveConversationDesk shows modal triggers on compact widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdaptiveConversationDesk<String>(
            conversations: _conversations,
            listTitle: 'Conversations',
            contextTitle: 'Participant context',
            itemBuilder: _conversationItemBuilder,
            threadBuilder: _threadBuilder,
            contextBuilder: _contextBuilder,
          ),
        ),
      ),
    );

    expect(find.text('Open conversations'), findsOneWidget);
    expect(find.text('Open context'), findsOneWidget);
    expect(find.byKey(const Key('thread-Ava Johnson')), findsOneWidget);
    expect(find.byKey(const Key('context-Ava Johnson')), findsNothing);

    await tester.tap(find.text('Open context'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('context-Ava Johnson')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveConversationDesk docks list on medium widths',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.md.start, 720);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 520,
            child: AdaptiveConversationDesk<String>(
              conversations: _conversations,
              listTitle: 'Conversations',
              contextTitle: 'Participant context',
              itemBuilder: _conversationItemBuilder,
              threadBuilder: _threadBuilder,
              contextBuilder: _contextBuilder,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open conversations'), findsNothing);
    expect(find.text('Open context'), findsOneWidget);
    expect(find.byKey(const Key('context-Ava Johnson')), findsNothing);

    await tester.tap(find.text('Noah Clarke'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('thread-Noah Clarke')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets(
      'AdaptiveConversationDesk docks list and context on expanded widths',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 720);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 620,
            child: AdaptiveConversationDesk<String>(
              conversations: _conversations,
              listTitle: 'Conversations',
              contextTitle: 'Participant context',
              itemBuilder: _conversationItemBuilder,
              threadBuilder: _threadBuilder,
              contextBuilder: _contextBuilder,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open conversations'), findsNothing);
    expect(find.text('Open context'), findsNothing);
    expect(find.byKey(const Key('context-Ava Johnson')), findsOneWidget);

    await tester.tap(find.text('Mia Lopez'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('thread-Mia Lopez')), findsOneWidget);
    expect(find.byKey(const Key('context-Mia Lopez')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveConversationDesk can use narrow container constraints',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 720);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 360,
              height: 520,
              child: AdaptiveConversationDesk<String>(
                conversations: _conversations,
                listTitle: 'Conversations',
                contextTitle: 'Participant context',
                itemBuilder: _conversationItemBuilder,
                threadBuilder: _threadBuilder,
                contextBuilder: _contextBuilder,
                useContainerConstraints: true,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open conversations'), findsOneWidget);
    expect(find.text('Open context'), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets(
      'AdaptiveConversationDesk can keep context modal on short heights',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 520);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 420,
            child: AdaptiveConversationDesk<String>(
              conversations: _conversations,
              listTitle: 'Conversations',
              contextTitle: 'Participant context',
              itemBuilder: _conversationItemBuilder,
              threadBuilder: _threadBuilder,
              contextBuilder: _contextBuilder,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open conversations'), findsNothing);
    expect(find.text('Open context'), findsOneWidget);
    expect(find.byKey(const Key('context-Ava Johnson')), findsNothing);

    resetScreenSize(tester);
  });
}
