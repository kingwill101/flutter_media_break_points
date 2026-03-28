import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';
import 'package:media_break_points/patterns.dart';

import 'shared.dart';

Widget _editorSurface() {
  return Container(
    key: const Key('editor-surface'),
    color: Colors.green.shade50,
    height: 180,
  );
}

Widget _previewSurface() {
  return Container(
    key: const Key('preview-surface'),
    color: Colors.blue.shade50,
    height: 180,
  );
}

Widget _settingsSurface() {
  return Container(
    key: const Key('settings-surface'),
    color: Colors.orange.shade50,
    height: 120,
  );
}

void main() {
  testWidgets('AdaptiveComposer shows compact surface toggle on small widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdaptiveComposer(
            editor: _editorSurface(),
            preview: _previewSurface(),
            settings: _settingsSurface(),
          ),
        ),
      ),
    );

    expect(find.text('Editor'), findsWidgets);
    expect(find.text('Preview'), findsOneWidget);
    expect(find.byKey(const Key('editor-surface')), findsOneWidget);
    expect(find.byKey(const Key('preview-surface')), findsNothing);
    expect(find.text('Open settings'), findsOneWidget);

    await tester.tap(find.text('Preview'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('preview-surface')), findsOneWidget);

    await tester.tap(find.text('Open settings'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('settings-surface')), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveComposer splits editor and preview on medium widths',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.md.start, 720);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 520,
            child: AdaptiveComposer(
              editor: _editorSurface(),
              preview: _previewSurface(),
              settings: _settingsSurface(),
            ),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('editor-surface')), findsOneWidget);
    expect(find.byKey(const Key('preview-surface')), findsOneWidget);
    expect(find.text('Open settings'), findsOneWidget);
    expect(find.byKey(const Key('settings-surface')), findsNothing);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveComposer docks settings on expanded widths',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 720);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 620,
            child: AdaptiveComposer(
              editor: _editorSurface(),
              preview: _previewSurface(),
              settings: _settingsSurface(),
            ),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('editor-surface')), findsOneWidget);
    expect(find.byKey(const Key('preview-surface')), findsOneWidget);
    expect(find.byKey(const Key('settings-surface')), findsOneWidget);
    expect(find.text('Open settings'), findsNothing);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveComposer can use narrow container constraints',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 720);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 360,
              height: 520,
              child: AdaptiveComposer(
                editor: _editorSurface(),
                preview: _previewSurface(),
                settings: _settingsSurface(),
                useContainerConstraints: true,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('editor-surface')), findsOneWidget);
    expect(find.byKey(const Key('preview-surface')), findsNothing);
    expect(find.text('Open settings'), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveComposer can keep settings modal on short heights',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xxl.start, 520);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 420,
            child: AdaptiveComposer(
              editor: _editorSurface(),
              preview: _previewSurface(),
              settings: _settingsSurface(),
            ),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('editor-surface')), findsOneWidget);
    expect(find.byKey(const Key('preview-surface')), findsOneWidget);
    expect(find.byKey(const Key('settings-surface')), findsNothing);
    expect(find.text('Open settings'), findsOneWidget);

    resetScreenSize(tester);
  });
}
