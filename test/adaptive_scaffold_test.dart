import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';

import 'shared.dart';

List<AdaptiveScaffoldDestination> _destinations() {
  return const [
    AdaptiveScaffoldDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    AdaptiveScaffoldDestination(
      icon: Icon(Icons.auto_stories_outlined),
      selectedIcon: Icon(Icons.auto_stories),
      label: 'Library',
    ),
    AdaptiveScaffoldDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];
}

void main() {
  testWidgets('AdaptiveScaffold switches navigation chrome by adaptive size',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: AdaptiveScaffold(
          selectedIndex: 0,
          destinations: _destinations(),
          body: const Placeholder(),
        ),
      ),
    );

    setScreenSize(tester, BreakPoint.sm.start);
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    expect(find.byType(NavigationDrawer), findsNothing);

    setScreenSize(tester, BreakPoint.md.start);
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsNothing);
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationDrawer), findsNothing);

    setScreenSize(tester, BreakPoint.lg.start);
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsNothing);
    expect(find.byType(NavigationRail), findsNothing);
    expect(find.byType(NavigationDrawer), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveScaffold forwards destination selection changes',
      (WidgetTester tester) async {
    var selectedIndex = 0;

    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: StatefulBuilder(
          builder: (context, setState) {
            return AdaptiveScaffold(
              selectedIndex: selectedIndex,
              destinations: _destinations(),
              onSelectedIndexChanged: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              body: Text('selected:$selectedIndex'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Library'));
    await tester.pumpAndSettle();

    expect(find.text('selected:1'), findsOneWidget);
    resetScreenSize(tester);
  });

  testWidgets('AdaptiveScaffold can animate scaffold mode transitions',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: AdaptiveScaffold(
          animateTransitions: true,
          selectedIndex: 0,
          destinations: _destinations(),
          body: const Placeholder(),
        ),
      ),
    );

    setScreenSize(tester, BreakPoint.sm.start);
    await tester.pumpAndSettle();
    expect(find.byType(AnimatedContainer), findsWidgets);
    expect(find.byType(AnimatedSwitcher), findsWidgets);
    expect(find.byType(NavigationBar), findsOneWidget);

    setScreenSize(tester, BreakPoint.md.start);
    await tester.pump();
    expect(find.byType(AnimatedContainer), findsWidgets);
    await tester.pumpAndSettle();
    expect(find.byType(NavigationRail), findsOneWidget);

    setScreenSize(tester, BreakPoint.lg.start);
    await tester.pumpAndSettle();
    expect(find.byType(NavigationDrawer), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets(
      'AdaptiveScaffold does not throw while rail width is animating in',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: AdaptiveScaffold(
          animateTransitions: true,
          selectedIndex: 0,
          destinations: _destinations(),
          body: const Placeholder(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsOneWidget);

    setScreenSize(tester, BreakPoint.md.start);
    await tester.pump(const Duration(milliseconds: 50));

    expect(tester.takeException(), isNull);

    await tester.pumpAndSettle();
    expect(find.byType(NavigationRail), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveScaffold can demote medium layouts on short heights',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.md.start, 420);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: AdaptiveScaffold(
          selectedIndex: 0,
          destinations: _destinations(),
          minimumRailHeight: AdaptiveHeight.medium,
          body: const Placeholder(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveScaffold can demote expanded layouts on short heights',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xl.start, 420);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: AdaptiveScaffold(
          selectedIndex: 0,
          destinations: _destinations(),
          minimumDrawerHeight: AdaptiveHeight.medium,
          body: const Placeholder(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(NavigationDrawer), findsNothing);
    expect(find.byType(NavigationRail), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets(
      'AdaptiveScaffold keeps a medium rail stable when real rail height is tight',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.md.start, 520);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: AdaptiveScaffold(
          selectedIndex: 0,
          destinations: _destinations(),
          minimumRailHeight: AdaptiveHeight.compact,
          appBar: AppBar(title: const Text('Adaptive shell')),
          navigationHeader: const SizedBox(height: 120, child: Placeholder()),
          navigationFooter: const SizedBox(height: 120, child: Placeholder()),
          body: const Placeholder(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(tester.takeException(), isNull);

    resetScreenSize(tester);
  });
}
