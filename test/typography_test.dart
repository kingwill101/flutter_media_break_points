import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';
import 'shared.dart';

void main() {
  testWidgets('ResponsiveTextStyle.of adjusts based on screen size', (WidgetTester tester) async {
    late TextStyle textStyle;
    
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) {
          textStyle = ResponsiveTextStyle.of(
            context,
            xs: TextStyle(fontSize: 14, color: Colors.red),
            md: TextStyle(fontSize: 18, color: Colors.blue),
            lg: TextStyle(fontSize: 22, color: Colors.green),
          );
          
          return Text('Test', style: textStyle);
        },
      ),
    ));
    
    // Test extra small screen
    setScreenSize(tester, BreakPoint.xs.start);
    await tester.pumpAndSettle();
    expect(textStyle.fontSize, 14);
    expect(textStyle.color, Colors.red);
    
    // Test medium screen
    setScreenSize(tester, BreakPoint.md.start);
    await tester.pumpAndSettle();
    expect(textStyle.fontSize, 18);
    expect(textStyle.color, Colors.blue);
    
    // Test large screen
    setScreenSize(tester, BreakPoint.lg.start);
    await tester.pumpAndSettle();
    expect(textStyle.fontSize, 22);
    expect(textStyle.color, Colors.green);
    
    resetScreenSize(tester);
  });
  
  testWidgets('ResponsiveTextStyle.fontSize adjusts based on screen size', (WidgetTester tester) async {
    late double fontSize;
    
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) {
          fontSize = ResponsiveTextStyle.fontSize(
            context,
            xs: 14,
            md: 18,
            lg: 22,
          );
          
          return Text('Test', style: TextStyle(fontSize: fontSize));
        },
      ),
    ));
    
    // Test extra small screen
    setScreenSize(tester, BreakPoint.xs.start);
    await tester.pumpAndSettle();
    expect(fontSize, 14);
    
    // Test medium screen
    setScreenSize(tester, BreakPoint.md.start);
    await tester.pumpAndSettle();
    expect(fontSize, 18);
    
    // Test large screen
    setScreenSize(tester, BreakPoint.lg.start);
    await tester.pumpAndSettle();
    expect(fontSize, 22);
    
    resetScreenSize(tester);
  });
}