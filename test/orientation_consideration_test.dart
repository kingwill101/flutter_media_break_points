import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';
import 'shared.dart';

void setPhysicalSize(WidgetTester tester, double width, double height) {
  final dpi = tester.view.devicePixelRatio;
  tester.view.physicalSize = Size(width * dpi, height * dpi);
}

void main() {
  testWidgets('Orientation consideration affects breakpoint detection (disabled/enabled)', (WidgetTester tester) async {
    // First test with orientation consideration disabled
    initMediaBreakPoints(
      MediaBreakPointsConfig(
        considerOrientation: false,
      ),
    );
    
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) {
          return Text('Breakpoint: [32m${context.breakPoint.label}[0m');
        },
      ),
    ));
    
    // Test with sm breakpoint in portrait
    setPhysicalSize(tester, 600, 800); // sm width, portrait
    await tester.pumpAndSettle();
    String portraitBreakpointLabel = tester.widget<Text>(find.textContaining('Breakpoint:')).data!.split(': ')[1];
    expect(portraitBreakpointLabel.contains('sm'), true);
    
    // Test with sm breakpoint in landscape (should still be sm)
    setPhysicalSize(tester, 700, 600); // sm width, landscape
    await tester.pumpAndSettle();
    String landscapeBreakpointLabel = tester.widget<Text>(find.textContaining('Breakpoint:')).data!.split(': ')[1];
    expect(landscapeBreakpointLabel.contains('sm'), true);
    
    // With orientation consideration disabled, breakpoints should be the same
    expect(landscapeBreakpointLabel, portraitBreakpointLabel);
    
    // Now test with orientation consideration enabled
    initMediaBreakPoints(
      MediaBreakPointsConfig(
        considerOrientation: true,
      ),
    );
    
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) {
          return Text('Breakpoint: [32m${context.breakPoint.label}[0m');
        },
      ),
    ));
    
    // Test with sm breakpoint in portrait
    setPhysicalSize(tester, 600, 800); // sm width, portrait
    await tester.pumpAndSettle();
    String portraitBreakpointLabel2 = tester.widget<Text>(find.textContaining('Breakpoint:')).data!.split(': ')[1];
    expect(portraitBreakpointLabel2.contains('sm'), true);
    
    // Test with sm breakpoint in landscape (should bump to md)
    setPhysicalSize(tester, 800, 600); // md width, landscape
    await tester.pumpAndSettle();
    String landscapeBreakpointLabel2 = tester.widget<Text>(find.textContaining('Breakpoint:')).data!.split(': ')[1];
    expect(landscapeBreakpointLabel2.contains('lg'), true);
    // With orientation consideration enabled, landscape should have a higher breakpoint
    expect(landscapeBreakpointLabel2 != portraitBreakpointLabel2, true);
    
    // Reset to default configuration for other tests
    initMediaBreakPoints(
      MediaBreakPointsConfig(),
    );
    tester.view.resetPhysicalSize();
  });

  testWidgets('Orientation affects breakpoint label and orientation string', (WidgetTester tester) async {
    // Initialize with orientation consideration
    initMediaBreakPoints(
      MediaBreakPointsConfig(
        considerOrientation: true,
      ),
    );

    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) {
          return Column(
            children: [
              Text('Breakpoint: [32m${context.breakPoint.label}[0m'),
              Text('Orientation: ${MediaQuery.of(context).orientation.toString()}'),
            ],
          );
        },
      ),
    ));

    // Test with xs breakpoint in portrait
    setPhysicalSize(tester, 500, 800); // xs width, portrait
    await tester.pumpAndSettle();
    String portraitBreakpointLabel = tester.widget<Text>(find.textContaining('Breakpoint:')).data!.split(': ')[1];
    expect(portraitBreakpointLabel.contains('xs'), true);
    expect(MediaQuery.of(tester.element(find.text('Orientation: ${Orientation.portrait}'))).orientation, Orientation.portrait);

    // Test with xs breakpoint in landscape (should bump to sm)
    setPhysicalSize(tester, 600, 500); // sm width, landscape
    await tester.pumpAndSettle();
    String landscapeBreakpointLabel = tester.widget<Text>(find.textContaining('Breakpoint:')).data!.split(': ')[1];
    expect(landscapeBreakpointLabel.contains('md'), true);
    expect(MediaQuery.of(tester.element(find.textContaining('Orientation:'))).orientation, Orientation.landscape);

    // Reset to default configuration for other tests
    initMediaBreakPoints(
      MediaBreakPointsConfig(),
    );
    tester.view.resetPhysicalSize();
  });

  testWidgets('Orientation consideration affects valueFor results', (WidgetTester tester) async {
    // Initialize with orientation consideration
    initMediaBreakPoints(
      MediaBreakPointsConfig(
        considerOrientation: true,
      ),
    );
    
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) {
          final value = valueFor<String>(
            context,
            xs: 'xs value',
            sm: 'sm value',
            md: 'md value',
            lg: 'lg value',
            xl: 'xl value',
            xxl: 'xxl value',
          );
          return Text('Value: $value');
        },
      ),
    ));
    
    // Test with sm breakpoint in portrait
    setPhysicalSize(tester, 600, 800); // sm width, portrait
    await tester.pumpAndSettle();
    String portraitValue = tester.widget<Text>(find.textContaining('Value:')).data!.split(': ')[1];
    expect(portraitValue, 'sm value');
    
    // Test with sm breakpoint in landscape (should bump to md)
    setPhysicalSize(tester, 800, 600); // md width, landscape
    await tester.pumpAndSettle();
    String landscapeValue = tester.widget<Text>(find.textContaining('Value:')).data!.split(': ')[1];
    expect(landscapeValue, 'lg value');
    expect(landscapeValue != portraitValue, true);
    
    // Reset to default configuration for other tests
    initMediaBreakPoints(
      MediaBreakPointsConfig(),
    );
    tester.view.resetPhysicalSize();
  });

  testWidgets('Orientation does not affect breakpoint when considerOrientation is false', (WidgetTester tester) async {
    // Initialize with orientation consideration disabled
    initMediaBreakPoints(
      MediaBreakPointsConfig(
        considerOrientation: false,
      ),
    );

    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) {
          return Column(
            children: [
              Text('Breakpoint: [32m${context.breakPoint.label}[0m'),
              Text('Orientation: ${MediaQuery.of(context).orientation.toString()}'),
            ],
          );
        },
      ),
    ));

    // Test with sm breakpoint in portrait
    setPhysicalSize(tester, 600, 800); // sm width, portrait
    await tester.pumpAndSettle();
    String portraitBreakpointLabel = tester.widget<Text>(find.textContaining('Breakpoint:')).data!.split(': ')[1];
    expect(portraitBreakpointLabel.contains('sm'), true);

    // Test with sm breakpoint in landscape (should still be sm)
    setPhysicalSize(tester, 700, 600); // sm width, landscape
    await tester.pumpAndSettle();
    String landscapeBreakpointLabel = tester.widget<Text>(find.textContaining('Breakpoint:')).data!.split(': ')[1];
    expect(landscapeBreakpointLabel.contains('sm'), true);
    // The breakpoint should be the same regardless of orientation
    expect(landscapeBreakpointLabel, portraitBreakpointLabel);

    // Reset to default configuration for other tests
    initMediaBreakPoints(
      MediaBreakPointsConfig(),
    );
    tester.view.resetPhysicalSize();
  });
}