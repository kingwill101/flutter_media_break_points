import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';
import 'package:media_break_points/patterns.dart';

import 'shared.dart';

Widget _libraryPanel() {
  return Container(
    key: const Key('library-panel'),
    color: Colors.green.shade50,
    height: 120,
  );
}

Widget _canvasPanel() {
  return Container(
    key: const Key('canvas-panel'),
    color: Colors.blue.shade50,
    height: 180,
  );
}

Widget _inspectorPanel() {
  return Container(
    key: const Key('inspector-panel'),
    color: Colors.orange.shade50,
    height: 120,
  );
}

void main() {
  testWidgets('AdaptiveWorkbench shows modal panel triggers on compact widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdaptiveWorkbench(
            libraryTitle: 'Library',
            library: _libraryPanel(),
            inspectorTitle: 'Inspector',
            inspector: _inspectorPanel(),
            canvas: _canvasPanel(),
          ),
        ),
      ),
    );

    expect(find.text('Open library'), findsOneWidget);
    expect(find.text('Open inspector'), findsOneWidget);
    expect(find.byKey(const Key('library-panel')), findsNothing);
    expect(find.byKey(const Key('inspector-panel')), findsNothing);
    expect(find.byKey(const Key('canvas-panel')), findsOneWidget);

    await tester.tap(find.text('Open library'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('library-panel')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets(
      'AdaptiveWorkbench docks the library before the inspector on medium widths',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.md.start, 720);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 620,
            child: AdaptiveWorkbench(
              libraryTitle: 'Library',
              library: _libraryPanel(),
              inspectorTitle: 'Inspector',
              inspector: _inspectorPanel(),
              canvas: _canvasPanel(),
            ),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('library-panel')), findsOneWidget);
    expect(find.text('Open inspector'), findsOneWidget);
    expect(find.byKey(const Key('inspector-panel')), findsNothing);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveWorkbench docks both panels on expanded widths',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 720);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 620,
            child: AdaptiveWorkbench(
              libraryTitle: 'Library',
              library: _libraryPanel(),
              inspectorTitle: 'Inspector',
              inspector: _inspectorPanel(),
              canvas: _canvasPanel(),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open library'), findsNothing);
    expect(find.text('Open inspector'), findsNothing);
    expect(find.byKey(const Key('library-panel')), findsOneWidget);
    expect(find.byKey(const Key('inspector-panel')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveWorkbench can use narrow container constraints',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 720);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 360,
              height: 620,
              child: AdaptiveWorkbench(
                libraryTitle: 'Library',
                library: _libraryPanel(),
                inspectorTitle: 'Inspector',
                inspector: _inspectorPanel(),
                canvas: _canvasPanel(),
                useContainerConstraints: true,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open library'), findsOneWidget);
    expect(find.text('Open inspector'), findsOneWidget);
    expect(find.byKey(const Key('library-panel')), findsNothing);
    expect(find.byKey(const Key('inspector-panel')), findsNothing);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveWorkbench can keep the inspector modal on short heights',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 520);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 460,
            child: AdaptiveWorkbench(
              libraryTitle: 'Library',
              library: _libraryPanel(),
              inspectorTitle: 'Inspector',
              inspector: _inspectorPanel(),
              canvas: _canvasPanel(),
            ),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('library-panel')), findsOneWidget);
    expect(find.text('Open inspector'), findsOneWidget);
    expect(find.byKey(const Key('inspector-panel')), findsNothing);

    resetScreenSize(tester);
  });
}
