import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';

import 'shared.dart';

List<AdaptiveSection> _sections() {
  return [
    const AdaptiveSection(
      label: 'Overview',
      icon: Icon(Icons.space_dashboard_outlined),
      child: SizedBox(
        key: Key('overview-content'),
        height: 120,
      ),
    ),
    const AdaptiveSection(
      label: 'Members',
      icon: Icon(Icons.people_outline),
      child: SizedBox(
        key: Key('members-content'),
        height: 120,
      ),
    ),
    const AdaptiveSection(
      label: 'Settings',
      icon: Icon(Icons.settings_outlined),
      child: SizedBox(
        key: Key('settings-content'),
        height: 120,
      ),
    ),
  ];
}

List<AdaptiveSection> _flexSections() {
  return [
    AdaptiveSection(
      label: 'Profile',
      icon: const Icon(Icons.person_outline),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            key: Key('profile-flex-content'),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Profile settings'),
              SizedBox(height: 12),
              Text('This child uses flex and needs a bounded compact section.'),
              Spacer(),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(label: Text('Adaptive')),
                  Chip(label: Text('Sectioned')),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  ];
}

void main() {
  testWidgets('AdaptiveSections shows chips on compact widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdaptiveSections(
            sections: _sections(),
          ),
        ),
      ),
    );

    expect(find.byType(ChoiceChip), findsNWidgets(3));
    expect(find.widgetWithText(ListTile, 'Members'), findsNothing);
    expect(find.byKey(const Key('overview-content')), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Members'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('members-content')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveSections docks a sidebar on larger widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 320,
            child: AdaptiveSections(
              sections: _sections(),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(ChoiceChip), findsNothing);
    expect(find.widgetWithText(ListTile, 'Members'), findsOneWidget);
    expect(find.byKey(const Key('overview-content')), findsOneWidget);

    await tester.tap(find.widgetWithText(ListTile, 'Settings'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('settings-content')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveSections can use narrow container constraints',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xxl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 320,
              child: AdaptiveSections(
                sections: _sections(),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(ChoiceChip), findsNWidgets(3));
    expect(find.widgetWithText(ListTile, 'Members'), findsNothing);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveSections can demote on short heights',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xl.start, 420);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 220,
            child: AdaptiveSections(
              sections: _sections(),
              minimumSidebarHeight: AdaptiveHeight.medium,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(ChoiceChip), findsNWidgets(3));
    expect(find.widgetWithText(ListTile, 'Overview'), findsNothing);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveSections bounds compact content when height is finite',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 280,
            child: AdaptiveSections(
              sections: _flexSections(),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('profile-flex-content')), findsOneWidget);
    expect(tester.takeException(), isNull);

    resetScreenSize(tester);
  });
}
