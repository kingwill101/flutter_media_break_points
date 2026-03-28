import 'package:flutter/material.dart';

import 'adaptive.dart';
import 'media_query.dart';

/// Lerp function used by [FluidResponsiveValue].
typedef FluidResponsiveLerp<T> = T Function(T a, T b, double t);

/// A responsive value that interpolates between defined breakpoint anchors.
///
/// Unlike [ResponsiveValue], this class does not jump directly from one
/// breakpoint value to another. Instead it linearly interpolates between the
/// nearest values around the current width.
class FluidResponsiveValue<T> {
  /// Creates a fluid responsive value definition.
  const FluidResponsiveValue({
    required this.lerp,
    this.xs,
    this.sm,
    this.md,
    this.lg,
    this.xl,
    this.xxl,
    this.compact,
    this.medium,
    this.expanded,
    this.defaultValue,
  });

  /// Lerp function used to interpolate between two values.
  final FluidResponsiveLerp<T> lerp;

  /// Value for extra small screens.
  final T? xs;

  /// Value for small screens.
  final T? sm;

  /// Value for medium screens.
  final T? md;

  /// Value for large screens.
  final T? lg;

  /// Value for extra large screens.
  final T? xl;

  /// Value for extra extra large screens.
  final T? xxl;

  /// Value for compact layouts.
  final T? compact;

  /// Value for medium layouts.
  final T? medium;

  /// Value for expanded layouts.
  final T? expanded;

  /// Fallback value used when no anchors are defined.
  final T? defaultValue;

  /// Resolves this fluid value against the current [BuildContext].
  T? resolve(BuildContext context) {
    return resolveForData(breakPointDataOf(context));
  }

  /// Resolves this fluid value for a custom width and height.
  T? resolveForWidth(
    double width, {
    double height = 0,
    Orientation? orientation,
    bool? considerOrientation,
  }) {
    return resolveForData(
      breakPointDataForSize(
        Size(width, height),
        orientation: orientation,
        considerOrientation: considerOrientation,
      ),
    );
  }

  /// Resolves this fluid value using precomputed [BreakPointData].
  T? resolveForData(BreakPointData data) {
    final anchors = _anchors;
    if (anchors.isEmpty) {
      return defaultValue;
    }

    if (anchors.length == 1) {
      return anchors.single.value;
    }

    final width = data.width;
    if (width <= anchors.first.width) {
      return anchors.first.value;
    }

    if (width >= anchors.last.width) {
      return anchors.last.value;
    }

    for (var index = 0; index < anchors.length - 1; index++) {
      final start = anchors[index];
      final end = anchors[index + 1];
      if (width <= end.width) {
        final distance = end.width - start.width;
        if (distance <= 0) {
          return end.value;
        }
        final t = ((width - start.width) / distance).clamp(0.0, 1.0).toDouble();
        return lerp(start.value, end.value, t);
      }
    }

    return anchors.last.value;
  }

  List<_FluidAnchor<T>> get _anchors {
    final valuesByWidth = <double, T>{};

    void addAnchor(double width, T? value) {
      if (value != null) {
        valuesByWidth[width] = value;
      }
    }

    // Semantic anchors provide a coarse fluid scale even when raw
    // breakpoint values are not supplied.
    addAnchor(BreakPoint.xs.start, compact);
    addAnchor(BreakPoint.md.start, medium);
    addAnchor(BreakPoint.lg.start, expanded);

    // Explicit breakpoint values override semantic anchors at the same width.
    addAnchor(BreakPoint.xs.start, xs);
    addAnchor(BreakPoint.sm.start, sm);
    addAnchor(BreakPoint.md.start, md);
    addAnchor(BreakPoint.lg.start, lg);
    addAnchor(BreakPoint.xl.start, xl);
    addAnchor(BreakPoint.xxl.start, xxl);

    final entries = valuesByWidth.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return [
      for (final entry in entries)
        _FluidAnchor<T>(width: entry.key, value: entry.value),
    ];
  }
}

class _FluidAnchor<T> {
  final double width;
  final T value;

  const _FluidAnchor({
    required this.width,
    required this.value,
  });
}

/// Extension helpers for fluid responsive values.
extension BuildContextFluidExtension on BuildContext {
  /// Resolves a [FluidResponsiveValue] against this context.
  T? resolveFluid<T>(FluidResponsiveValue<T> value) {
    return value.resolve(this);
  }

  /// Convenience helper for inline fluid responsive values.
  T? fluidResponsive<T>({
    required FluidResponsiveLerp<T> lerp,
    T? xs,
    T? sm,
    T? md,
    T? lg,
    T? xl,
    T? xxl,
    T? compact,
    T? medium,
    T? expanded,
    T? defaultValue,
    double? width,
    double? height,
    bool? considerOrientation,
  }) {
    final value = FluidResponsiveValue<T>(
      lerp: lerp,
      xs: xs,
      sm: sm,
      md: md,
      lg: lg,
      xl: xl,
      xxl: xxl,
      compact: compact,
      medium: medium,
      expanded: expanded,
      defaultValue: defaultValue,
    );

    if (width == null) {
      return value.resolve(this);
    }

    final resolvedHeight = height ?? MediaQuery.of(this).size.height;
    return value.resolveForWidth(
      width,
      height: resolvedHeight,
      considerOrientation: considerOrientation,
    );
  }
}
