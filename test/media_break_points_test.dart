import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'shared.dart';
import 'package:media_break_points/media_break_points.dart';

const _d = {
  "sm": 10,
  "xs": 20,
  "md": 30,
  "lg": 40,
  "xl": 50,
};

EdgeInsets? _testData(BuildContext context) {
  return valueFor<EdgeInsets>(
    context,
    sm: const EdgeInsets.only(left: 10),
    xs: const EdgeInsets.only(left: 20),
    md: const EdgeInsets.only(left: 30),
    lg: const EdgeInsets.only(left: 40),
    xl: const EdgeInsets.only(left: 50),
  );
}

void main() {
  testWidgets('xs', (WidgetTester tester) async {
    EdgeInsets? _g;
    EdgeInsets? _g2;

    setScreenSize(tester, BreakPoint.xs.start);

    // resets the screen to its orinal size after the test end
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (BuildContext context) {
          _g = valueFor<EdgeInsets>(context);
          _g2 = _testData(context);
          expect(_g, null);
          expect(_d["xs"], _g2!.left);
          return Placeholder();
        },
      ),
    ));
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });

  testWidgets('sm', (WidgetTester tester) async {
    EdgeInsets? _g;
    EdgeInsets? _g2;

    setScreenSize(tester,  BreakPoint.sm.start);
    // resets the screen to its orinal size after the test end
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (BuildContext context) {
          _g = valueFor<EdgeInsets>(context);
          _g2 = _testData(context);
          expect(_g, null);
          expect(_d["sm"], _g2!.left);
          return Placeholder();
        },
      ),
    ));
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });

  testWidgets('md', (WidgetTester tester) async {
    EdgeInsets? _g;
    EdgeInsets? _g2;

    setScreenSize(tester,  BreakPoint.md.end);
    // resets the screen to its orinal size after the test end
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (BuildContext context) {
          _g = valueFor<EdgeInsets>(context);
          _g2 = _testData(context);
          expect(_g, null);
          expect(_d["md"], _g2!.left);
          return Placeholder();
        },
      ),
    ));
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });

  testWidgets('lg', (WidgetTester tester) async {
    EdgeInsets? _g;
    EdgeInsets? _g2;

    setScreenSize(tester,  BreakPoint.lg.start);
    // resets the screen to its orinal size after the test end
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (BuildContext context) {
          _g = valueFor<EdgeInsets>(context);
          _g2 = _testData(context);
          expect(_g, null);
          expect(_d["lg"], _g2!.left);
          return Placeholder();
        },
      ),
    ));
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });
  testWidgets('xl', (WidgetTester tester) async {
    EdgeInsets? _g;
    EdgeInsets? _g2;

    setScreenSize(tester,  BreakPoint.xl.start);
    // resets the screen to its orinal size after the test end
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (BuildContext context) {
          _g = valueFor<EdgeInsets>(context);
          _g2 = _testData(context);
          expect(_g, null);
          expect(_d["xl"], _g2!.left);
          return Placeholder();
        },
      ),
    ));
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });

  testWidgets('xxl', (WidgetTester tester) async {
    String? test;

    setScreenSize(tester,  BreakPoint.xxl.start);
    // resets the screen to its orinal size after the test end
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (BuildContext context) {
          String testValue = "value for xxl large";
          test = valueFor<String>(context, xxl: testValue);
          expect(testValue, test);
          return Placeholder();
        },
      ),
    ));
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });

  testWidgets('default value test', (WidgetTester tester) async {
    String? test;
    setScreenSize(tester,  BreakPoint.xl.start);
    // resets the screen to its orinal size after the test end
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (BuildContext context) {
          String testValue = "default";
          test = valueFor<String>(context, defaultValue: testValue);
          expect(testValue, test);
          return Placeholder();
        },
      ),
    ));
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });
}
