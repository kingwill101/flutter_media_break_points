import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'fluid.dart';
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
    TextStyle? compact,
    TextStyle? medium,
    TextStyle? expanded,
    TextStyle? defaultValue,
    ResponsiveResolveMode resolveMode = ResponsiveResolveMode.exact,
  }) {
    return ResponsiveValue<TextStyle>(
      xs: xs,
      sm: sm,
      md: md,
      lg: lg,
      xl: xl,
      xxl: xxl,
      compact: compact,
      medium: medium,
      expanded: expanded,
      defaultValue: defaultValue ?? const TextStyle(),
      resolveMode: resolveMode,
    ).resolve(context)!;
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
    double? compact,
    double? medium,
    double? expanded,
    double? defaultValue,
    ResponsiveResolveMode resolveMode = ResponsiveResolveMode.exact,
  }) {
    return ResponsiveValue<double>(
      xs: xs,
      sm: sm,
      md: md,
      lg: lg,
      xl: xl,
      xxl: xxl,
      compact: compact,
      medium: medium,
      expanded: expanded,
      defaultValue: defaultValue ?? 14,
      resolveMode: resolveMode,
    ).resolve(context)!;
  }

  /// Creates a fluid text style that interpolates across breakpoint anchors.
  static TextStyle fluid(
    BuildContext context, {
    TextStyle? xs,
    TextStyle? sm,
    TextStyle? md,
    TextStyle? lg,
    TextStyle? xl,
    TextStyle? xxl,
    TextStyle? compact,
    TextStyle? medium,
    TextStyle? expanded,
    TextStyle? defaultValue,
  }) {
    return FluidResponsiveValue<TextStyle>(
          lerp: (a, b, t) => TextStyle.lerp(a, b, t) ?? a,
          xs: xs,
          sm: sm,
          md: md,
          lg: lg,
          xl: xl,
          xxl: xxl,
          compact: compact,
          medium: medium,
          expanded: expanded,
          defaultValue: defaultValue ?? const TextStyle(),
        ).resolve(context) ??
        const TextStyle();
  }

  /// Creates a fluid font size that interpolates across breakpoint anchors.
  static double fluidFontSize(
    BuildContext context, {
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    double? compact,
    double? medium,
    double? expanded,
    double? defaultValue,
  }) {
    return FluidResponsiveValue<double>(
          lerp: (a, b, t) => lerpDouble(a, b, t) ?? a,
          xs: xs,
          sm: sm,
          md: md,
          lg: lg,
          xl: xl,
          xxl: xxl,
          compact: compact,
          medium: medium,
          expanded: expanded,
          defaultValue: defaultValue ?? 14,
        ).resolve(context) ??
        14;
  }
}
