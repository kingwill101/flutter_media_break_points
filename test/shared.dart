import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void setPhysicalSize(WidgetTester tester, double width, double height) {
  final dpi = tester.view.devicePixelRatio;
  tester.view.physicalSize = Size(width * dpi, height * dpi);
}

/// Sets the screen size for testing.
///
/// This function adjusts the physical size of the test environment
/// to simulate a screen with the given width.
void setScreenSize(WidgetTester tester, double width) {
  final dpi = tester.view.devicePixelRatio;
  tester.view.physicalSize = Size(width * dpi, 800 * dpi);
}

/// Resets the screen size after testing.
void resetScreenSize(WidgetTester tester) {
  tester.view.resetPhysicalSize();
}

/// Sets the screen orientation for testing.
///
/// This function adjusts the physical size of the test environment
/// to simulate the given orientation while maintaining the current width.
void setOrientation(WidgetTester tester, Orientation orientation) {
  final dpi = tester.view.devicePixelRatio;
  final currentWidth = tester.view.physicalSize.width / dpi;

  if (orientation == Orientation.portrait) {
    // For portrait, height > width
    tester.view.physicalSize =
        Size(currentWidth * dpi, (currentWidth * 1.5) * dpi);
  } else {
    // For landscape, width > height
    tester.view.physicalSize =
        Size((currentWidth * 1.5) * dpi, currentWidth * dpi);
  }
}
