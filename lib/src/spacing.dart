import 'package:flutter/material.dart';
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
    EdgeInsetsGeometry? defaultValue,
  }) {
    return valueFor<EdgeInsetsGeometry>(
      context,
      xs: xs,
      sm: sm,
      md: md,
      lg: lg,
      xl: xl,
      xxl: xxl,
      defaultValue: defaultValue ?? EdgeInsets.zero,
    )!;
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
    double? defaultValue,
    Axis direction = Axis.vertical,
  }) {
    final size = valueFor<double>(
      context,
      xs: xs,
      sm: sm,
      md: md,
      lg: lg,
      xl: xl,
      xxl: xxl,
      defaultValue: defaultValue ?? 0,
    )!;

    return direction == Axis.vertical
        ? SizedBox(height: size)
        : SizedBox(width: size);
  }
}
