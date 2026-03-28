import 'package:flutter/material.dart';

import 'adaptive.dart';

/// Defines the range of screen widths for each breakpoint.
///
/// Each breakpoint is mapped to a tuple containing the start and end width
/// in logical pixels. For [BreakPoint.xxl], the end width is `0`, indicating
/// there is no upper limit.
Map<BreakPoint, (double, double)> screenSize = {
  BreakPoint.xs: (0, 575),
  BreakPoint.sm: (576, 767),
  BreakPoint.md: (768, 991),
  BreakPoint.lg: (992, 1199),
  BreakPoint.xl: (1200, 1400),
  BreakPoint.xxl: (1401, 0),
};

/// High-level layout classes that are easier to reason about than raw widths.
enum AdaptiveSize {
  compact,
  medium,
  expanded,
}

/// High-level vertical size classes derived from available height.
enum AdaptiveHeight {
  compact,
  medium,
  expanded,
}

/// Controls how missing breakpoint values are resolved.
enum ResponsiveResolveMode {
  /// Only return an exact breakpoint value.
  exact,

  /// Fall back to smaller breakpoints before using semantic values/defaults.
  cascadeDown,
}

/// Snapshot of the layout information used to resolve adaptive UIs.
class BreakPointData {
  /// The available width used to determine the breakpoint.
  final double width;

  /// The available height associated with this layout context.
  final double height;

  /// The orientation used when resolving the breakpoint.
  final Orientation orientation;

  /// The resolved breakpoint for [width].
  final BreakPoint breakPoint;

  /// The semantic size class derived from [breakPoint].
  final AdaptiveSize adaptiveSize;

  /// The semantic height class derived from [height].
  final AdaptiveHeight adaptiveHeight;

  /// Creates an immutable layout snapshot.
  const BreakPointData({
    required this.width,
    required this.height,
    required this.orientation,
    required this.breakPoint,
    required this.adaptiveSize,
    required this.adaptiveHeight,
  });

  /// The full available size.
  Size get size => Size(width, height);

  /// Whether this layout should be treated as compact.
  bool get isCompact => adaptiveSize == AdaptiveSize.compact;

  /// Whether this layout should be treated as medium.
  bool get isMedium => adaptiveSize == AdaptiveSize.medium;

  /// Whether this layout should be treated as expanded.
  bool get isExpanded => adaptiveSize == AdaptiveSize.expanded;

  /// Whether this layout should be treated as height-compact.
  bool get isHeightCompact => adaptiveHeight == AdaptiveHeight.compact;

  /// Whether this layout should be treated as height-medium.
  bool get isHeightMedium => adaptiveHeight == AdaptiveHeight.medium;

  /// Whether this layout should be treated as height-expanded.
  bool get isHeightExpanded => adaptiveHeight == AdaptiveHeight.expanded;
}

/// Extension methods for the [BreakPoint] enum.
extension BreakPointExtension on BreakPoint {
  /// The starting width of this breakpoint in logical pixels.
  double get start => screenSize[this]!.$1;

  /// The ending width of this breakpoint in logical pixels.
  double get end => screenSize[this]!.$2;

  /// Whether this breakpoint is smaller than [breakpoint].
  bool operator <(BreakPoint breakpoint) => index < breakpoint.index;

  /// Whether this breakpoint is larger than [breakpoint].
  bool operator >(BreakPoint breakpoint) => index > breakpoint.index;

  /// Whether this breakpoint is smaller than or equal to [breakpoint].
  bool operator <=(BreakPoint breakpoint) => index <= breakpoint.index;

  /// Whether this breakpoint is larger than or equal to [breakpoint].
  bool operator >=(BreakPoint breakpoint) => index >= breakpoint.index;

  /// The semantic size class for this breakpoint.
  AdaptiveSize get adaptiveSize => adaptiveSizeForBreakPoint(this);

  /// Returns a human-readable representation of this breakpoint with its range.
  String get label {
    return switch (this) {
      BreakPoint.xs => 'xs($start, $end)',
      BreakPoint.sm => 'sm($start, $end)',
      BreakPoint.md => 'md($start, $end)',
      BreakPoint.lg => 'lg($start, $end)',
      BreakPoint.xl => 'xl($start, $end)',
      BreakPoint.xxl => 'xxl($start, $end)',
    };
  }
}

/// Whether to consider device orientation when determining breakpoints.
bool _considerOrientation = false;

/// Sets whether orientation should be considered when determining breakpoints.
void setConsiderOrientation(bool value) {
  _considerOrientation = value;
}

/// Gets whether orientation is considered when determining breakpoints.
bool getConsiderOrientation() {
  return _considerOrientation;
}

/// Determines the semantic size class for a [BreakPoint].
AdaptiveSize adaptiveSizeForBreakPoint(BreakPoint breakPoint) {
  return switch (breakPoint) {
    BreakPoint.xs || BreakPoint.sm => AdaptiveSize.compact,
    BreakPoint.md => AdaptiveSize.medium,
    BreakPoint.lg || BreakPoint.xl || BreakPoint.xxl => AdaptiveSize.expanded,
  };
}

/// Determines the semantic height class for an available height.
AdaptiveHeight adaptiveHeightForHeight(double height) {
  if (height < 560) {
    return AdaptiveHeight.compact;
  }
  if (height < 800) {
    return AdaptiveHeight.medium;
  }
  return AdaptiveHeight.expanded;
}

/// Returns a full layout snapshot for the current [BuildContext].
BreakPointData breakPointDataOf(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);
  return breakPointDataForSize(
    mediaQuery.size,
    orientation: mediaQuery.orientation,
  );
}

/// Builds breakpoint metadata from an arbitrary [Size].
BreakPointData breakPointDataForSize(
  Size size, {
  Orientation? orientation,
  bool? considerOrientation,
}) {
  final resolvedOrientation = orientation ?? _orientationForSize(size);
  final currentBreakPoint = breakPointForWidth(
    size.width,
    orientation: resolvedOrientation,
    considerOrientation: considerOrientation,
  );
  return BreakPointData(
    width: size.width,
    height: size.height,
    orientation: resolvedOrientation,
    breakPoint: currentBreakPoint,
    adaptiveSize: adaptiveSizeForBreakPoint(currentBreakPoint),
    adaptiveHeight: adaptiveHeightForHeight(size.height),
  );
}

/// Determines the current breakpoint based on screen width and orientation.
BreakPoint breakpoint(BuildContext context) {
  return breakPointDataOf(context).breakPoint;
}

/// Resolves a [BreakPoint] for an arbitrary width.
BreakPoint breakPointForWidth(
  double width, {
  Orientation orientation = Orientation.portrait,
  bool? considerOrientation,
}) {
  final shouldConsiderOrientation =
      considerOrientation ?? getConsiderOrientation();
  if (shouldConsiderOrientation && orientation == Orientation.landscape) {
    final current = _breakpointForWidth(width);
    if (current < BreakPoint.lg) {
      final nextIndex = current.index + 1;
      if (nextIndex < BreakPoint.values.length) {
        return BreakPoint.values[nextIndex];
      }
    }
    return current;
  }

  return _breakpointForWidth(width);
}

/// Helper function to determine breakpoint based solely on width.
BreakPoint _breakpointForWidth(double width) {
  for (final breakpoint in screenSize.keys) {
    if (valBetween(width, breakpoint.start, breakpoint.end)) {
      return breakpoint;
    }
  }
  return BreakPoint.xxl;
}

Orientation _orientationForSize(Size size) {
  return size.width > size.height
      ? Orientation.landscape
      : Orientation.portrait;
}

/// Checks if a value is between (inclusive) a start and end range.
bool valBetween(double val, double start, double end) {
  return (val >= start) && (val <= end);
}

/// Declarative responsive values with breakpoint and semantic fallbacks.
class ResponsiveValue<T> {
  /// Creates a responsive value definition.
  const ResponsiveValue({
    this.xs,
    this.sm,
    this.md,
    this.lg,
    this.xl,
    this.xxl,
    this.compact,
    this.medium,
    this.expanded,
    this.heightCompact,
    this.heightMedium,
    this.heightExpanded,
    this.defaultValue,
    this.resolveMode = ResponsiveResolveMode.cascadeDown,
  });

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

  /// Value for height-compact layouts.
  final T? heightCompact;

  /// Value for height-medium layouts.
  final T? heightMedium;

  /// Value for height-expanded layouts.
  final T? heightExpanded;

  /// Value used when no specific match is found.
  final T? defaultValue;

  /// Strategy used when the current breakpoint has no direct value.
  final ResponsiveResolveMode resolveMode;

  /// Resolves this value for the current [BuildContext].
  T? resolve(BuildContext context) {
    return resolveForData(breakPointDataOf(context));
  }

  /// Resolves this value for a custom width and height.
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

  /// Resolves this value from precomputed [BreakPointData].
  T? resolveForData(BreakPointData data) {
    final exact = _valueForBreakPoint(data.breakPoint);
    if (exact != null) {
      return exact;
    }

    if (resolveMode == ResponsiveResolveMode.cascadeDown) {
      final cascaded = _cascadeBreakPointValue(data.breakPoint);
      if (cascaded != null) {
        return cascaded;
      }
    }

    final semantic = _valueForAdaptiveSize(data.adaptiveSize);
    if (semantic != null) {
      return semantic;
    }

    final heightSemantic = _valueForAdaptiveHeight(data.adaptiveHeight);
    if (heightSemantic != null) {
      return heightSemantic;
    }

    return defaultValue;
  }

  T? _cascadeBreakPointValue(BreakPoint breakPoint) {
    for (var index = breakPoint.index; index >= 0; index--) {
      final value = _valueForBreakPoint(BreakPoint.values[index]);
      if (value != null) {
        return value;
      }
    }
    return null;
  }

  T? _valueForBreakPoint(BreakPoint breakPoint) {
    return switch (breakPoint) {
      BreakPoint.xs => xs,
      BreakPoint.sm => sm,
      BreakPoint.md => md,
      BreakPoint.lg => lg,
      BreakPoint.xl => xl,
      BreakPoint.xxl => xxl,
    };
  }

  T? _valueForAdaptiveSize(AdaptiveSize adaptiveSize) {
    return switch (adaptiveSize) {
      AdaptiveSize.compact => compact,
      AdaptiveSize.medium => medium,
      AdaptiveSize.expanded => expanded,
    };
  }

  T? _valueForAdaptiveHeight(AdaptiveHeight adaptiveHeight) {
    return switch (adaptiveHeight) {
      AdaptiveHeight.compact => heightCompact,
      AdaptiveHeight.medium => heightMedium,
      AdaptiveHeight.expanded => heightExpanded,
    };
  }
}

/// Whether the screen is extra small (xs).
bool isXs(BuildContext context) {
  return breakpoint(context) == BreakPoint.xs;
}

/// Whether the screen is small (sm).
bool isSm(BuildContext context) {
  return breakpoint(context) == BreakPoint.sm;
}

/// Whether the screen is medium (md).
bool isMd(BuildContext context) {
  return breakpoint(context) == BreakPoint.md;
}

/// Whether the screen is large (lg).
bool isLg(BuildContext context) {
  return breakpoint(context) == BreakPoint.lg;
}

/// Whether the screen is extra large (xl).
bool isXl(BuildContext context) {
  return breakpoint(context) == BreakPoint.xl;
}

/// Whether the screen is extra extra large (xxl).
bool isXXl(BuildContext context) {
  return breakpoint(context) == BreakPoint.xxl;
}

/// Extension methods for [BuildContext] to easily check screen sizes.
extension BuildContextExtension on BuildContext {
  /// Whether the screen is extra small (xs).
  bool get isExtraSmall => isXs(this);

  /// Whether the screen is small (sm).
  bool get isSmall => isSm(this);

  /// Whether the screen is medium (md).
  bool get isMedium => isMd(this);

  /// Whether the screen is large (lg).
  bool get isLarge => isLg(this);

  /// Whether the screen is extra large (xl).
  bool get isExtraLarge => isXl(this);

  /// Whether the screen is extra extra large (xxl).
  bool get isExtraExtraLarge => isXXl(this);

  /// The current breakpoint based on screen width.
  BreakPoint get breakPoint => breakpoint(this);

  /// Full breakpoint metadata for the current context.
  BreakPointData get breakPointData => breakPointDataOf(this);

  /// The semantic layout class for the current context.
  AdaptiveSize get adaptiveSize => breakPointData.adaptiveSize;

  /// Whether the current layout is compact.
  bool get isCompact => adaptiveSize == AdaptiveSize.compact;

  /// Whether the current layout is medium.
  bool get isAdaptiveMedium => adaptiveSize == AdaptiveSize.medium;

  /// Whether the current layout is expanded.
  bool get isExpanded => adaptiveSize == AdaptiveSize.expanded;

  /// The semantic height class for the current context.
  AdaptiveHeight get adaptiveHeight => breakPointData.adaptiveHeight;

  /// Whether the current layout is height-compact.
  bool get isHeightCompact => adaptiveHeight == AdaptiveHeight.compact;

  /// Whether the current layout is height-medium.
  bool get isHeightMedium => adaptiveHeight == AdaptiveHeight.medium;

  /// Whether the current layout is height-expanded.
  bool get isHeightExpanded => adaptiveHeight == AdaptiveHeight.expanded;

  /// Resolves a [ResponsiveValue] against this context.
  T? resolveResponsive<T>(ResponsiveValue<T> value) {
    return value.resolve(this);
  }

  /// Convenience helper for inline responsive values.
  T? responsive<T>({
    T? xs,
    T? sm,
    T? md,
    T? lg,
    T? xl,
    T? xxl,
    T? compact,
    T? medium,
    T? expanded,
    T? heightCompact,
    T? heightMedium,
    T? heightExpanded,
    T? defaultValue,
    ResponsiveResolveMode resolveMode = ResponsiveResolveMode.cascadeDown,
    double? width,
    double? height,
    bool? considerOrientation,
  }) {
    final value = ResponsiveValue<T>(
      xs: xs,
      sm: sm,
      md: md,
      lg: lg,
      xl: xl,
      xxl: xxl,
      compact: compact,
      medium: medium,
      expanded: expanded,
      heightCompact: heightCompact,
      heightMedium: heightMedium,
      heightExpanded: heightExpanded,
      defaultValue: defaultValue,
      resolveMode: resolveMode,
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

/// Returns a value corresponding to the current breakpoint.
///
/// This preserves the package's original behavior: only exact breakpoint values
/// are used, with [defaultValue] as the fallback.
T? valueFor<T>(
  BuildContext context, {
  T? xs,
  T? sm,
  T? md,
  T? lg,
  T? xl,
  T? xxl,
  T? defaultValue,
}) {
  return ResponsiveValue<T>(
    xs: xs,
    sm: sm,
    md: md,
    lg: lg,
    xl: xl,
    xxl: xxl,
    defaultValue: defaultValue,
    resolveMode: ResponsiveResolveMode.exact,
  ).resolve(context);
}

/// Returns a string representation of the current screen size and breakpoint.
String strRep<T>(BuildContext context) {
  final data = breakPointDataOf(context);
  return '${data.breakPoint.label} - ${data.size}';
}
