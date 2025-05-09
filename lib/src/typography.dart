import 'package:flutter/material.dart';
import 'media_query.dart';

/// A utility class for responsive typography in Flutter applications.
///
/// This class provides methods for creating text styles that adapt
/// to different screen sizes.
class ResponsiveTextStyle {
  /// Creates a responsive text style that adapts to different screen sizes.
  ///
  /// Example:
  ///
  /// Text(
  ///   'Hello, world!',
  ///   style: ResponsiveTextStyle.of(
  ///     context,
  ///     xs: TextStyle(fontSize: 16),
  ///     md: TextStyle(fontSize: 20),
  ///     lg: TextStyle(fontSize: 24),
  ///   ),
  /// )
  ///
  static TextStyle of(
    BuildContext context, {
    TextStyle? xs,
    TextStyle? sm,
    TextStyle? md,
    TextStyle? lg,
    TextStyle? xl,
    TextStyle? xxl,
    TextStyle? defaultValue,
  }) {
    return valueFor<TextStyle>(
      context,
      xs: xs,
      sm: sm,
      md: md,
      lg: lg,
      xl: xl,
      xxl: xxl,
      defaultValue: defaultValue ?? const TextStyle(),
    )!;
  }

  /// Creates a responsive font size that adapts to different screen sizes.
  ///
  /// Example:
  ///
  /// Text(
  ///   'Hello, world!',
  ///   style: TextStyle(
  ///     fontSize: ResponsiveTextStyle.fontSize(
  ///       context,
  ///       xs: 16,
  ///       md: 20,
  ///       lg: 24,
  ///     ),
  ///   ),
  /// )
  ///
  static double fontSize(
    BuildContext context, {
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    double? defaultValue,
  }) {
    return valueFor<double>(
      context,
      xs: xs,
      sm: sm,
      md: md,
      lg: lg,
      xl: xl,
      xxl: xxl,
      defaultValue: defaultValue ?? 14,
    )!;
  }
}
