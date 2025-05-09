import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';
import 'shared.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

void main() {
  testWidgets('DeviceDetector detects device type based on breakpoint',
      (WidgetTester tester) async {
    late DeviceType deviceType;

    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) {
          deviceType = context.deviceType;
          return Text('Device Type: ${deviceType.toString()}');
        },
      ),
    ));

    // In test environment, we need to check what platform we're on
    // as this affects the expected device type
    DeviceType expectedSmallScreenType;
    DeviceType expectedMediumScreenType;

    if (kIsWeb) {
      expectedSmallScreenType = DeviceType.web;
      expectedMediumScreenType = DeviceType.web;
    } else if (Platform.isAndroid || Platform.isIOS) {
      expectedSmallScreenType = DeviceType.mobile;
      expectedMediumScreenType = DeviceType.tablet;
    } else {
      // On desktop platforms, it will always return desktop
      expectedSmallScreenType = DeviceType.desktop;
      expectedMediumScreenType = DeviceType.desktop;
    }

    // Test extra small screen
    setScreenSize(tester, BreakPoint.xs.start);
    await tester.pumpAndSettle();
    expect(deviceType, expectedSmallScreenType);

    // Test small screen
    setScreenSize(tester, BreakPoint.sm.start);
    await tester.pumpAndSettle();
    expect(deviceType, expectedSmallScreenType);

    // Test medium screen
    setScreenSize(tester, BreakPoint.md.start);
    await tester.pumpAndSettle();
    expect(deviceType, expectedMediumScreenType);

    // Test large screen
    setScreenSize(tester, BreakPoint.lg.start);
    await tester.pumpAndSettle();
    expect(deviceType, expectedMediumScreenType);

    resetScreenSize(tester);
  });

  testWidgets(
      'BuildContext extension methods for device detection work correctly',
      (WidgetTester tester) async {
    late bool isMobile;
    late bool isTablet;
    late bool supportsHover;
    late bool hasTouch;

    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) {
          isMobile = context.isMobile;
          isTablet = context.isTablet;
          supportsHover = context.supportsHover;
          hasTouch = context.hasTouch;

          return Text('Device Info');
        },
      ),
    ));

    // In test environment, we need to check what platform we're on
    bool expectedIsMobileOnSmallScreen;
    bool expectedIsTabletOnMediumScreen;
    bool expectedHasTouch;

    if (kIsWeb) {
      expectedIsMobileOnSmallScreen = false;
      expectedIsTabletOnMediumScreen = false;
      expectedHasTouch = false;
    } else if (Platform.isAndroid || Platform.isIOS) {
      expectedIsMobileOnSmallScreen = true;
      expectedIsTabletOnMediumScreen = true;
      expectedHasTouch = true;
    } else {
      // On desktop platforms
      expectedIsMobileOnSmallScreen = false;
      expectedIsTabletOnMediumScreen = false;
      expectedHasTouch = false;
    }

    // Test extra small screen
    setScreenSize(tester, BreakPoint.xs.start);
    await tester.pumpAndSettle();
    expect(isMobile, expectedIsMobileOnSmallScreen);
    expect(isTablet,
        !expectedIsMobileOnSmallScreen && expectedIsTabletOnMediumScreen);
    expect(hasTouch, expectedHasTouch);

    // Test medium screen
    setScreenSize(tester, BreakPoint.md.start);
    await tester.pumpAndSettle();
    expect(isMobile, false);
    expect(isTablet, expectedIsTabletOnMediumScreen);
    expect(hasTouch, expectedHasTouch);

    resetScreenSize(tester);
  });
}
