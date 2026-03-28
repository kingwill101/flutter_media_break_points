import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';
import 'package:media_break_points/patterns.dart';

import 'shared.dart';

List<AdaptiveGalleryItem> _items() {
  return const [
    AdaptiveGalleryItem(
      label: 'Foundation',
      description: 'Core responsive primitives.',
      preview: SizedBox(
        height: 160,
        child: ColoredBox(color: Colors.green),
      ),
      child: Text('Semantic breakpoints and fluid values'),
    ),
    AdaptiveGalleryItem(
      label: 'Workflow',
      description: 'Compound workspace surfaces.',
      preview: SizedBox(
        height: 160,
        child: ColoredBox(color: Colors.blue),
      ),
      child: Text('Inspector, pane, and shell coordination'),
    ),
    AdaptiveGalleryItem(
      label: 'Launch',
      description: 'Release verification.',
      preview: SizedBox(
        height: 160,
        child: ColoredBox(color: Colors.orange),
      ),
      child: Text('Catalog demos and regression coverage'),
    ),
  ];
}

void main() {
  testWidgets('AdaptiveGallery uses a compact carousel on small widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdaptiveGallery(
            items: _items(),
          ),
        ),
      ),
    );

    expect(find.byType(PageView), findsOneWidget);
    expect(find.text('Foundation'), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveGallery shows spotlight and selector on larger widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 420,
            child: AdaptiveGallery(
              items: _items(),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(PageView), findsNothing);
    expect(find.byType(ListView), findsOneWidget);

    final detail = tester.getTopLeft(
      find.text('Semantic breakpoints and fluid values'),
    );
    final selector = tester.getTopLeft(find.text('Workflow'));
    expect(detail.dx < selector.dx, isTrue);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveGallery can use narrow container constraints',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xxl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 320,
              child: AdaptiveGallery(
                items: _items(),
                useContainerConstraints: true,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(PageView), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveGallery can demote on short heights',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xl.start, 420);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 240,
            child: AdaptiveGallery(
              items: _items(),
              minimumSpotlightHeight: AdaptiveHeight.medium,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(PageView), findsOneWidget);

    resetScreenSize(tester);
  });
}
