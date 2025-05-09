import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../media_break_points.dart' show BreakPoint;
import 'media_query.dart';

/// Enum representing different device types.
enum DeviceType {
  /// Mobile phones (small screens).
  mobile,

  /// Tablets (medium screens).
  tablet,

  /// Desktop computers (large screens).
  desktop,

  /// Web browsers.
  web,
}

/// A utility class for detecting device types in Flutter applications.
class DeviceDetector {
  /// Determines the current device type based on platform and breakpoint.
  ///
  /// This method uses a combination of platform information and breakpoint
  /// to make an educated guess about the device type.
  static DeviceType getDeviceType(BuildContext context) {
    // Check if running on web
    if (kIsWeb) {
      return DeviceType.web;
    }

    // Get current breakpoint
    final currentBreakpoint = breakpoint(context);

    // Check platform and breakpoint
    if (Platform.isAndroid || Platform.isIOS) {
      // Mobile devices: xs and sm are considered mobile, md and above are tablets
      if (currentBreakpoint <= BreakPoint.sm) {
        return DeviceType.mobile;
      } else {
        return DeviceType.tablet;
      }
    } else if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      return DeviceType.desktop;
    }

    // Default to mobile for unknown platforms
    return DeviceType.mobile;
  }

  /// Whether the current device is a mobile phone.
  static bool isMobile(BuildContext context) {
    return getDeviceType(context) == DeviceType.mobile;
  }

  /// Whether the current device is a tablet.
  static bool isTablet(BuildContext context) {
    return getDeviceType(context) == DeviceType.tablet;
  }

  /// Whether the current device is a desktop computer.
  static bool isDesktop(BuildContext context) {
    return getDeviceType(context) == DeviceType.desktop;
  }

  /// Whether the current device is a web browser.
  static bool isWeb(BuildContext context) {
    return getDeviceType(context) == DeviceType.web;
  }

  /// Whether the current device supports hover interactions.
  ///
  /// This is typically true for desktop and web platforms.
  static bool supportsHover(BuildContext context) {
    final deviceType = getDeviceType(context);
    return deviceType == DeviceType.desktop || deviceType == DeviceType.web;
  }

  /// Whether the current device has touch input.
  ///
  /// This is typically true for mobile and tablet devices.
  static bool hasTouch(BuildContext context) {
    final deviceType = getDeviceType(context);
    return deviceType == DeviceType.mobile || deviceType == DeviceType.tablet;
  }
}

/// Extension methods for [BuildContext] to easily check device types.
extension DeviceContextExtension on BuildContext {
  /// The current device type.
  DeviceType get deviceType => DeviceDetector.getDeviceType(this);

  /// Whether the current device is a mobile phone.
  bool get isMobile => DeviceDetector.isMobile(this);

  /// Whether the current device is a tablet.
  bool get isTablet => DeviceDetector.isTablet(this);

  /// Whether the current device is a desktop computer.
  bool get isDesktop => DeviceDetector.isDesktop(this);

  /// Whether the current device is a web browser.
  bool get isWeb => DeviceDetector.isWeb(this);

  /// Whether the current device supports hover interactions.
  bool get supportsHover => DeviceDetector.supportsHover(this);

  /// Whether the current device has touch input.
  bool get hasTouch => DeviceDetector.hasTouch(this);
}
