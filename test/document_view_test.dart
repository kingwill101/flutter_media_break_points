import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';

import 'shared.dart';

List<AdaptiveDocumentSection> _sections() {
  return const [
    AdaptiveDocumentSection(
      label: 'Overview',
      child: SizedBox(
        key: Key('overview-content'),
        height: 120,
      ),
    ),
    AdaptiveDocumentSection(
      label: 'Layout rules',
      child: SizedBox(
        key: Key('layout-rules-content'),
        height: 120,
      ),
    ),
    AdaptiveDocumentSection(
      label: 'Examples',
      child: SizedBox(
        key: Key('examples-content'),
        height: 120,
      ),
    ),
  ];
}

void main() {
  testWidgets(
      'AdaptiveDocumentView shows a modal outline trigger on compact widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdaptiveDocumentView(
            sections: _sections(),
          ),
        ),
      ),
    );

    expect(find.text('Open outline'), findsOneWidget);
    expect(find.text('Outline'), findsNothing);
    expect(find.byKey(const Key('overview-content')), findsOneWidget);

    await tester.tap(find.text('Open outline'));
    await tester.pumpAndSettle();

    expect(find.text('Outline'), findsOneWidget);
    expect(find.text('Layout rules'), findsWidgets);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveDocumentView docks outline on larger widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 360,
            child: AdaptiveDocumentView(
              sections: _sections(),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open outline'), findsNothing);
    expect(find.text('Outline'), findsOneWidget);
    expect(find.byKey(const Key('layout-rules-content')), findsOneWidget);

    final outline = tester.getTopLeft(find.text('Outline'));
    final content =
        tester.getTopLeft(find.byKey(const Key('overview-content')));
    expect(outline.dx < content.dx, isTrue);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveDocumentView can use narrow container constraints',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xxl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 320,
              child: AdaptiveDocumentView(
                sections: _sections(),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open outline'), findsOneWidget);
    expect(find.text('Outline'), findsNothing);

    resetScreenSize(tester);
  });

  testWidgets(
      'AdaptiveDocumentView can keep wide layouts modal on short heights',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xl.start, 420);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 220,
            child: AdaptiveDocumentView(
              sections: _sections(),
              minimumDockedHeight: AdaptiveHeight.medium,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Open outline'), findsOneWidget);
    expect(find.text('Outline'), findsNothing);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveDocumentView can build inside unbounded-height parents',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: AdaptiveDocumentView(
              sections: _sections(),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Outline'), findsOneWidget);
    expect(find.byKey(const Key('examples-content')), findsOneWidget);
    expect(tester.takeException(), isNull);

    resetScreenSize(tester);
  });
}
