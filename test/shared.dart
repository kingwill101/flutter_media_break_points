import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

setScreenSize(WidgetTester tester, double width) {
  final dpi = tester.view.devicePixelRatio;
  tester.view.physicalSize = Size(width * dpi, 200 * dpi);
}
