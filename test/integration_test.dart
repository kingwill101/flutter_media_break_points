import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';
import 'shared.dart';

void main() {
  testWidgets('Integration test for all responsive components',
      (WidgetTester tester) async {
    // Initialize with custom configuration
    initMediaBreakPoints(
      MediaBreakPointsConfig(
        considerOrientation: true,
      ),
    );

    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Builder(
                builder: (context) => Text(
                  'Integration Test',
                  style: ResponsiveTextStyle.of(
                    context,
                    xs: TextStyle(fontSize: 18),
                    md: TextStyle(fontSize: 22),
                    lg: TextStyle(fontSize: 26),
                  ),
                ),
              ),
            ),
            body: Builder(
              builder: (context) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: ResponsiveSpacing.padding(
                      context,
                      xs: EdgeInsets.all(8),
                      md: EdgeInsets.all(16),
                      lg: EdgeInsets.all(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Breakpoint: ${context.breakPoint.label}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                            'Device Type: ${context.deviceType.toString().split('.').last}'),
                        ResponsiveSpacing.gap(context, xs: 16, md: 24, lg: 32),

                        // Responsive visibility
                        ResponsiveVisibility(
                          visibleXs: true,
                          visibleSm: true,
                          visibleMd: false,
                          visibleLg: false,
                          visibleXl: false,
                          visibleXxl: false,
                          child: Text('Mobile Only Content',
                              key: Key('mobileContent')),
                        ),
                        ResponsiveVisibility(
                          visibleXs: false,
                          visibleSm: false,
                          visibleMd: true,
                          visibleLg: true,
                          visibleXl: true,
                          visibleXxl: true,
                          child: Text('Tablet and Desktop Content',
                              key: Key('tabletDesktopContent')),
                        ),

                        ResponsiveSpacing.gap(context, xs: 16, md: 24, lg: 32),

                        // Responsive grid
                        ResponsiveGrid(
                          children: [
                            ResponsiveGridItem(
                              xs: 12,
                              sm: 6,
                              md: 4,
                              lg: 3,
                              child: Container(
                                key: Key('gridItem1'),
                                height: 100,
                                color: Colors.red,
                                child: Center(child: Text('Item 1')),
                              ),
                            ),
                            ResponsiveGridItem(
                              xs: 12,
                              sm: 6,
                              md: 4,
                              lg: 3,
                              child: Container(
                                key: Key('gridItem2'),
                                height: 100,
                                color: Colors.blue,
                                child: Center(child: Text('Item 2')),
                              ),
                            ),
                            ResponsiveGridItem(
                              xs: 12,
                              sm: 6,
                              md: 4,
                              lg: 3,
                              child: Container(
                                key: Key('gridItem3'),
                                height: 100,
                                color: Colors.green,
                                child: Center(child: Text('Item 3')),
                              ),
                            ),
                            ResponsiveGridItem(
                              xs: 12,
                              sm: 6,
                              md: 4,
                              lg: 3,
                              child: Container(
                                key: Key('gridItem4'),
                                height: 100,
                                color: Colors.yellow,
                                child: Center(child: Text('Item 4')),
                              ),
                            ),
                          ],
                        ),

                        ResponsiveSpacing.gap(context, xs: 16, md: 24, lg: 32),

                        // Responsive layout builder
                        ResponsiveLayoutBuilder(
                          xs: (context, _) =>
                              Text('XS Layout', key: Key('xsLayout')),
                          sm: (context, _) =>
                              Text('SM Layout', key: Key('smLayout')),
                          md: (context, _) =>
                              Text('MD Layout', key: Key('mdLayout')),
                          lg: (context, _) =>
                              Text('LG Layout', key: Key('lgLayout')),
                          xl: (context, _) =>
                              Text('XL Layout', key: Key('xlLayout')),
                          xxl: (context, _) =>
                              Text('XXL Layout', key: Key('xxlLayout')),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    ));

    // Test extra small screen
    setScreenSize(tester, BreakPoint.xs.start);
    await tester.pumpAndSettle();

    // Check visibility
    expect(find.byKey(Key('mobileContent')), findsOneWidget);
    expect(find.byKey(Key('tabletDesktopContent')), findsNothing);

    // Check layout builder
    expect(find.byKey(Key('xsLayout')), findsOneWidget);

    // Check grid layout (should be stacked vertically)
    final item1XsRect = tester.getRect(find.byKey(Key('gridItem1')));
    final item2XsRect = tester.getRect(find.byKey(Key('gridItem2')));
    expect(item1XsRect.top < item2XsRect.top, true);

    // Test medium screen
    setScreenSize(tester, BreakPoint.md.start);
    await tester.pumpAndSettle();

    // Check visibility
    expect(find.byKey(Key('mobileContent')), findsNothing);
    expect(find.byKey(Key('tabletDesktopContent')), findsOneWidget);

    // Check layout builder
    expect(find.byKey(Key('mdLayout')), findsOneWidget);

    // Check grid layout (should have 3 items per row)
    final item1MdRect = tester.getRect(find.byKey(Key('gridItem1')));
    final item2MdRect = tester.getRect(find.byKey(Key('gridItem2')));
    final item3MdRect = tester.getRect(find.byKey(Key('gridItem3')));
    final item4MdRect = tester.getRect(find.byKey(Key('gridItem4')));

    expect(item1MdRect.left < item2MdRect.left, true);
    expect(item2MdRect.left < item3MdRect.left, true);
    expect(item1MdRect.top == item2MdRect.top, true);
    expect(item2MdRect.top == item3MdRect.top, true);
    expect(item3MdRect.top < item4MdRect.top, true);

    // Test large screen
    setScreenSize(tester, BreakPoint.lg.start);
    await tester.pumpAndSettle();

    // Check visibility
    expect(find.byKey(Key('mobileContent')), findsNothing);
    expect(find.byKey(Key('tabletDesktopContent')), findsOneWidget);

    // Check layout builder
    expect(find.byKey(Key('lgLayout')), findsOneWidget);

    // Check grid layout (should have 4 items per row)
    final item1LgRect = tester.getRect(find.byKey(Key('gridItem1')));
    final item2LgRect = tester.getRect(find.byKey(Key('gridItem2')));
    final item3LgRect = tester.getRect(find.byKey(Key('gridItem3')));
    final item4LgRect = tester.getRect(find.byKey(Key('gridItem4')));

    expect(item1LgRect.left < item2LgRect.left, true);
    expect(item2LgRect.left < item3LgRect.left, true);
    expect(item3LgRect.left < item4LgRect.left, true);
    expect(item1LgRect.top == item2LgRect.top, true);
    expect(item2LgRect.top == item3LgRect.top, true);
    expect(item3LgRect.top == item4LgRect.top, true);

    // Test orientation
    setOrientation(tester, Orientation.landscape);
    await tester.pumpAndSettle();

    // In landscape, the breakpoint might be bumped up
    final breakpointText = find.textContaining('Current Breakpoint:');
    expect(breakpointText, findsOneWidget);

    resetScreenSize(tester);
  });
}
