import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';
import 'shared.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

void main() {
  testWidgets(
      'DeviceDetector correctly identifies device types based on breakpoint',
      (WidgetTester tester) async {
    late DeviceType deviceType;
    late bool isMobile;
    late bool isTablet;
    late bool isDesktop;
    late bool supportsHover;
    late bool hasTouch;

    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) {
          deviceType = context.deviceType;
          isMobile = context.isMobile;
          isTablet = context.isTablet;
          isDesktop = context.isDesktop;
          supportsHover = context.supportsHover;
          hasTouch = context.hasTouch;

          return Column(
            children: [
              Text('Device Type: $deviceType'),
              Text('Is Mobile: $isMobile'),
              Text('Is Tablet: $isTablet'),
              Text('Is Desktop: $isDesktop'),
              Text('Supports Hover: $supportsHover'),
              Text('Has Touch: $hasTouch'),
            ],
          );
        },
      ),
    ));

    // Test extra small screen (should be mobile)
    setScreenSize(tester, BreakPoint.xs.start);
    await tester.pumpAndSettle();

    // On mobile platforms, xs should be detected as mobile
    if (kIsWeb) {
      expect(deviceType, DeviceType.web);
    } else if (Platform.isAndroid || Platform.isIOS) {
      expect(deviceType, DeviceType.mobile);
      expect(isMobile, true);
      expect(isTablet, false);
      expect(hasTouch, true);
    } else if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      expect(deviceType, DeviceType.desktop);
      expect(isDesktop, true);
      expect(supportsHover, true);
    }

    // Test medium screen (should be tablet on mobile platforms)
    setScreenSize(tester, BreakPoint.md.start);
    await tester.pumpAndSettle();

    if (kIsWeb) {
      expect(deviceType, DeviceType.web);
    } else if (Platform.isAndroid || Platform.isIOS) {
      expect(deviceType, DeviceType.tablet);
      expect(isMobile, false);
      expect(isTablet, true);
      expect(hasTouch, true);
    } else if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      expect(deviceType, DeviceType.desktop);
      expect(isDesktop, true);
      expect(supportsHover, true);
    }

    resetScreenSize(tester);
  });
}
