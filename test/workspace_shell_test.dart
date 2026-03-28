import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';

import 'shared.dart';

List<AdaptiveScaffoldDestination> _workspaceDestinations() {
  return const [
    AdaptiveScaffoldDestination(
      icon: Icon(Icons.dashboard_outlined),
      selectedIcon: Icon(Icons.dashboard),
      label: 'Home',
    ),
    AdaptiveScaffoldDestination(
      icon: Icon(Icons.folder_outlined),
      selectedIcon: Icon(Icons.folder),
      label: 'Projects',
    ),
  ];
}

List<AdaptiveActionBarAction> _workspaceActions() {
  return const [
    AdaptiveActionBarAction(
      icon: Icon(Icons.add),
      label: 'Create',
      priority: 3,
      variant: AdaptiveActionVariant.filled,
      pinToPrimaryRow: true,
    ),
    AdaptiveActionBarAction(
      icon: Icon(Icons.share_outlined),
      label: 'Share',
      priority: 2,
      variant: AdaptiveActionVariant.tonal,
    ),
  ];
}

void main() {
  testWidgets(
      'AdaptiveWorkspaceShell composes compact navigation and modal inspector',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        home: AdaptiveWorkspaceShell(
          title: 'Workspace',
          description: 'Adaptive shell demo.',
          destinations: _workspaceDestinations(),
          actions: _workspaceActions(),
          content: Container(
            key: const Key('content'),
            height: 120,
          ),
          inspector: Container(
            key: const Key('inspector'),
            height: 80,
          ),
          inspectorTitle: 'Inspector',
        ),
      ),
    );

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Create'), findsOneWidget);
    expect(find.text('Open inspector'), findsOneWidget);
    expect(find.byKey(const Key('inspector')), findsNothing);

    await tester.tap(find.text('Open inspector'));
    await tester.pumpAndSettle();

    expect(find.text('Inspector'), findsOneWidget);
    expect(find.byKey(const Key('inspector')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveWorkspaceShell docks inspector on larger layouts',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: AdaptiveWorkspaceShell(
          title: 'Workspace',
          destinations: _workspaceDestinations(),
          actions: _workspaceActions(),
          content: Container(
            key: const Key('content'),
            height: 120,
          ),
          inspector: Container(
            key: const Key('inspector'),
            height: 80,
          ),
          inspectorTitle: 'Inspector',
        ),
      ),
    );

    expect(find.byType(NavigationDrawer), findsOneWidget);
    expect(find.text('Open inspector'), findsNothing);
    expect(find.byKey(const Key('inspector')), findsOneWidget);
    expect(find.text('Share'), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveWorkspaceShell can demote chrome on short heights',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xl.start, 420);

    await tester.pumpWidget(
      MaterialApp(
        home: AdaptiveWorkspaceShell(
          title: 'Workspace',
          destinations: _workspaceDestinations(),
          minimumDrawerHeight: AdaptiveHeight.medium,
          minimumInspectorDockedHeight: AdaptiveHeight.medium,
          content: Container(
            key: const Key('content'),
            height: 120,
          ),
          inspector: Container(
            key: const Key('inspector'),
            height: 80,
          ),
          inspectorTitle: 'Inspector',
        ),
      ),
    );

    expect(find.byType(NavigationDrawer), findsNothing);
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.text('Open inspector'), findsOneWidget);
    expect(find.byKey(const Key('inspector')), findsNothing);

    resetScreenSize(tester);
  });
}
