import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';
import 'package:media_break_points/patterns.dart';

import 'shared.dart';

const _releases = [
  'Catalog 2.0',
  'Analytics bundle',
  'Planning rollout',
];

Widget _itemBuilder(
  BuildContext context,
  String release,
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
        child: Text(release),
      ),
    ),
  );
}

Widget _readinessBuilder(BuildContext context, String release) {
  return Container(
    key: Key('readiness-$release'),
    alignment: Alignment.centerLeft,
    child: Text('Readiness: $release'),
  );
}

Widget _blockersBuilder(BuildContext context, String release) {
  return Container(
    key: Key('blockers-$release'),
    alignment: Alignment.centerLeft,
    child: Text('Blockers: $release'),
  );
}

Widget _rolloutBuilder(BuildContext context, String release) {
  return Container(
    key: Key('rollout-$release'),
    alignment: Alignment.centerLeft,
    child: Text('Rollout: $release'),
  );
}

void main() {
  testWidgets('AdaptiveReleaseLab shows modal triggers on compact widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdaptiveReleaseLab<String>(
            releases: _releases,
            releaseTitle: 'Releases',
            blockersTitle: 'Blockers',
            rolloutTitle: 'Rollout',
            itemBuilder: _itemBuilder,
            readinessBuilder: _readinessBuilder,
            blockersBuilder: _blockersBuilder,
            rolloutBuilder: _rolloutBuilder,
          ),
        ),
      ),
    );

    expect(find.text('Open releases'), findsOneWidget);
    expect(find.text('Open blockers'), findsOneWidget);
    expect(find.text('Open rollout log'), findsOneWidget);
    expect(find.byKey(const Key('readiness-Catalog 2.0')), findsOneWidget);
    expect(find.byKey(const Key('blockers-Catalog 2.0')), findsNothing);

    await tester.tap(find.text('Open blockers'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('blockers-Catalog 2.0')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveReleaseLab docks releases on medium widths',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.md.start, 720);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 520,
            child: AdaptiveReleaseLab<String>(
              releases: _releases,
              releaseTitle: 'Releases',
              blockersTitle: 'Blockers',
              rolloutTitle: 'Rollout',
              itemBuilder: _itemBuilder,
              readinessBuilder: _readinessBuilder,
              blockersBuilder: _blockersBuilder,
              rolloutBuilder: _rolloutBuilder,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open releases'), findsNothing);
    expect(find.text('Open blockers'), findsOneWidget);
    expect(find.text('Open rollout log'), findsOneWidget);
    expect(find.byKey(const Key('blockers-Catalog 2.0')), findsNothing);

    await tester.tap(find.text('Analytics bundle'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('readiness-Analytics bundle')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets(
      'AdaptiveReleaseLab docks blockers but keeps rollout modal on short heights',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 720);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 560,
            child: AdaptiveReleaseLab<String>(
              releases: _releases,
              releaseTitle: 'Releases',
              blockersTitle: 'Blockers',
              rolloutTitle: 'Rollout',
              itemBuilder: _itemBuilder,
              readinessBuilder: _readinessBuilder,
              blockersBuilder: _blockersBuilder,
              rolloutBuilder: _rolloutBuilder,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open releases'), findsNothing);
    expect(find.text('Open blockers'), findsNothing);
    expect(find.text('Open rollout log'), findsOneWidget);
    expect(find.byKey(const Key('blockers-Catalog 2.0')), findsOneWidget);
    expect(find.byKey(const Key('rollout-Catalog 2.0')), findsNothing);

    await tester.tap(find.text('Open rollout log'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('rollout-Catalog 2.0')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveReleaseLab fully docks on tall expanded layouts',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 920);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 840,
            child: AdaptiveReleaseLab<String>(
              releases: _releases,
              releaseTitle: 'Releases',
              blockersTitle: 'Blockers',
              rolloutTitle: 'Rollout',
              itemBuilder: _itemBuilder,
              readinessBuilder: _readinessBuilder,
              blockersBuilder: _blockersBuilder,
              rolloutBuilder: _rolloutBuilder,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open releases'), findsNothing);
    expect(find.text('Open blockers'), findsNothing);
    expect(find.text('Open rollout log'), findsNothing);
    expect(find.byKey(const Key('blockers-Catalog 2.0')), findsOneWidget);
    expect(find.byKey(const Key('rollout-Catalog 2.0')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets(
      'AdaptiveReleaseLab can use narrow container constraints for local layout',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 920);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 420,
              height: 520,
              child: AdaptiveReleaseLab<String>(
                releases: _releases,
                releaseTitle: 'Releases',
                blockersTitle: 'Blockers',
                rolloutTitle: 'Rollout',
                useContainerConstraints: true,
                itemBuilder: _itemBuilder,
                readinessBuilder: _readinessBuilder,
                blockersBuilder: _blockersBuilder,
                rolloutBuilder: _rolloutBuilder,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open releases'), findsOneWidget);
    expect(find.text('Open blockers'), findsOneWidget);
    expect(find.text('Open rollout log'), findsOneWidget);

    resetScreenSize(tester);
  });
}
