import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'fluid.dart';
import 'media_query.dart';

/// A utility class for responsive spacing in Flutter applications.
///
/// This class provides methods for creating responsive paddings, margins,
/// and gaps that adapt to different screen sizes.
class ResponsiveSpacing {
  /// Creates responsive padding that adapts to different screen sizes.
  ///
  /// Example:
  ///
  /// Container(
  ///   padding: ResponsiveSpacing.padding(
  ///     context,
  ///     xs: EdgeInsets.all(8),
  ///     md: EdgeInsets.all(16),
  ///     lg: EdgeInsets.all(24),
  ///   ),
  ///   child: Text('Hello, world!'),
  /// )
  ///
  static EdgeInsetsGeometry padding(
    BuildContext context, {
    EdgeInsetsGeometry? xs,
    EdgeInsetsGeometry? sm,
    EdgeInsetsGeometry? md,
    EdgeInsetsGeometry? lg,
    EdgeInsetsGeometry? xl,
    EdgeInsetsGeometry? xxl,
    EdgeInsetsGeometry? compact,
    EdgeInsetsGeometry? medium,
    EdgeInsetsGeometry? expanded,
    EdgeInsetsGeometry? defaultValue,
    ResponsiveResolveMode resolveMode = ResponsiveResolveMode.exact,
  }) {
    return ResponsiveValue<EdgeInsetsGeometry>(
      xs: xs,
      sm: sm,
      md: md,
      lg: lg,
      xl: xl,
      xxl: xxl,
      compact: compact,
      medium: medium,
      expanded: expanded,
      defaultValue: defaultValue ?? EdgeInsets.zero,
      resolveMode: resolveMode,
    ).resolve(context)!;
  }

  /// Creates a responsive gap for use in [Row], [Column], or [Flex].
  ///
  /// Example:
  ///
  /// Column(
  ///   children: [
  ///     Text('First item'),
  ///     ResponsiveSpacing.gap(
  ///       context,
  ///       xs: 8,
  ///       md: 16,
  ///       lg: 24,
  ///     ),
  ///     Text('Second item'),
  ///   ],
  /// )
  ///
  static SizedBox gap(
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
    Axis direction = Axis.vertical,
    ResponsiveResolveMode resolveMode = ResponsiveResolveMode.exact,
  }) {
    final size = ResponsiveValue<double>(
      xs: xs,
      sm: sm,
      md: md,
      lg: lg,
      xl: xl,
      xxl: xxl,
      compact: compact,
      medium: medium,
      expanded: expanded,
      defaultValue: defaultValue ?? 0,
      resolveMode: resolveMode,
    ).resolve(context)!;

    return direction == Axis.vertical
        ? SizedBox(height: size)
        : SizedBox(width: size);
  }

  /// Creates fluid responsive padding that interpolates across breakpoint
  /// anchors instead of switching abruptly.
  static EdgeInsetsGeometry fluidPadding(
    BuildContext context, {
    EdgeInsetsGeometry? xs,
    EdgeInsetsGeometry? sm,
    EdgeInsetsGeometry? md,
    EdgeInsetsGeometry? lg,
    EdgeInsetsGeometry? xl,
    EdgeInsetsGeometry? xxl,
    EdgeInsetsGeometry? compact,
    EdgeInsetsGeometry? medium,
    EdgeInsetsGeometry? expanded,
    EdgeInsetsGeometry? defaultValue,
  }) {
    return FluidResponsiveValue<EdgeInsetsGeometry>(
          lerp: (a, b, t) => EdgeInsetsGeometry.lerp(a, b, t) ?? a,
          xs: xs,
          sm: sm,
          md: md,
          lg: lg,
          xl: xl,
          xxl: xxl,
          compact: compact,
          medium: medium,
          expanded: expanded,
          defaultValue: defaultValue ?? EdgeInsets.zero,
        ).resolve(context) ??
        EdgeInsets.zero;
  }

  /// Creates a fluid responsive gap for use in [Row], [Column], or [Flex].
  static SizedBox fluidGap(
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
    Axis direction = Axis.vertical,
  }) {
    final size = FluidResponsiveValue<double>(
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
          defaultValue: defaultValue ?? 0,
        ).resolve(context) ??
        0;

    return direction == Axis.vertical
        ? SizedBox(height: size)
        : SizedBox(width: size);
  }
}
