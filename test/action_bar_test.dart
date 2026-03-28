import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';

import 'shared.dart';

List<AdaptiveActionBarAction> _actions() {
  return const [
    AdaptiveActionBarAction(
      icon: Icon(Icons.add),
      label: 'Create',
      priority: 3,
      variant: AdaptiveActionVariant.filled,
    ),
    AdaptiveActionBarAction(
      icon: Icon(Icons.share),
      label: 'Share',
      priority: 2,
      variant: AdaptiveActionVariant.tonal,
    ),
    AdaptiveActionBarAction(
      icon: Icon(Icons.copy),
      label: 'Duplicate',
      priority: 1,
      variant: AdaptiveActionVariant.outlined,
    ),
    AdaptiveActionBarAction(
      icon: Icon(Icons.archive_outlined),
      label: 'Archive',
      priority: 0,
      variant: AdaptiveActionVariant.text,
    ),
  ];
}

void main() {
  testWidgets('AdaptiveActionBar shows all actions when space allows',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 900,
            child: AdaptiveActionBar(actions: _actions()),
          ),
        ),
      ),
    );

    expect(find.text('Create'), findsOneWidget);
    expect(find.text('Share'), findsOneWidget);
    expect(find.text('Duplicate'), findsOneWidget);
    expect(find.text('Archive'), findsOneWidget);
    expect(find.byIcon(Icons.more_horiz), findsNothing);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveActionBar moves lower-priority actions into overflow',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 320,
            child: AdaptiveActionBar(actions: _actions()),
          ),
        ),
      ),
    );

    expect(find.text('Create'), findsOneWidget);
    expect(find.byIcon(Icons.more_horiz), findsOneWidget);

    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();

    expect(find.text('Archive'), findsOneWidget);
    expect(find.text('Duplicate'), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveActionBar can use a narrow container on a wide screen',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xxl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            width: 280,
            child: AdaptiveActionBar(actions: _actions()),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.more_horiz), findsOneWidget);

    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();

    expect(find.text('Share'), findsOneWidget);
    expect(find.text('Archive'), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('Pinned actions stay inline longer than lower-priority actions',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 250,
            child: AdaptiveActionBar(
              actions: const [
                AdaptiveActionBarAction(
                  icon: Icon(Icons.save_outlined),
                  label: 'Save',
                  priority: 0,
                  variant: AdaptiveActionVariant.filled,
                  pinToPrimaryRow: true,
                ),
                AdaptiveActionBarAction(
                  icon: Icon(Icons.ios_share_outlined),
                  label: 'Share',
                  priority: 3,
                ),
                AdaptiveActionBarAction(
                  icon: Icon(Icons.delete_outline),
                  label: 'Delete',
                  priority: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('Save'), findsOneWidget);
    expect(find.byIcon(Icons.more_horiz), findsOneWidget);

    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();

    expect(find.text('Delete'), findsOneWidget);
    resetScreenSize(tester);
  });
}
