import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:media_break_points/media_break_points.dart';

import 'shared.dart';

void main() {

  testWidgets('AdaptiveContainer changes widget based on screen size',
      (WidgetTester tester) async {

    await tester.pumpWidget(MaterialApp(
      home: AdaptiveContainer(
        configs: {
          BreakPoint.xs: AdaptiveSlot(builder: (context) => Text('XS')),
          BreakPoint.sm: AdaptiveSlot(builder: (context) => Text('SM')),
          BreakPoint.md: AdaptiveSlot(builder: (context) => Text('MD')),
          BreakPoint.lg: AdaptiveSlot(builder: (context) => Text('LG')),
          BreakPoint.xl: AdaptiveSlot(builder: (context) => Text('XL')),
          BreakPoint.xxl: AdaptiveSlot(builder: (context) => Text('XXL')),
        },
      ),
    ));
    
    setScreenSize(tester, extraSmallStart);
    await tester.pumpAndSettle();
    expect(find.text('XS'), findsOneWidget);  
    
    setScreenSize(tester, mobileBreakPointStart);
    await tester.pumpAndSettle();
    expect(find.text('SM'), findsOneWidget);

    setScreenSize(tester, tabletBreakPointEnd);
    await tester.pumpAndSettle();
    expect(find.text('MD'), findsOneWidget);

    setScreenSize(tester, desktopBreakPointStart);
    await tester.pumpAndSettle();
    expect(find.text('LG'), findsOneWidget);

    setScreenSize(tester, wideScreenBreakPointStart);
    await tester.pumpAndSettle();
    expect(find.text('XL'), findsOneWidget);

    setScreenSize(tester, extraWideScreenBreakPointStart);
    await tester.pumpAndSettle();
    expect(find.text('XXL'), findsOneWidget);


  });
}
