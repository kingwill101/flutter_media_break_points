import 'package:flutter/material.dart';
import 'package:media_break_points/media_break_points.dart';

/// Defines the range of screen widths for each breakpoint.
///
/// Each breakpoint is mapped to a tuple containing the start and end width
/// in logical pixels. For [BreakPoint.xxl], the end width is 0, indicating
/// there is no upper limit.
Map<BreakPoint, (double, double)> screenSize = {
  BreakPoint.xs: (0, 575),
  BreakPoint.sm: (576, 767),
  BreakPoint.md: (768, 991),
  BreakPoint.lg: (992, 1199),
  BreakPoint.xl: (1200, 1400),
  BreakPoint.xxl: (1401, 0),
};

/// Extension methods for the [BreakPoint] enum.
extension BreakPointExtension on BreakPoint {
  /// The starting width of this breakpoint in logical pixels.
  double get start => screenSize[this]!.$1;
  
  /// The ending width of this breakpoint in logical pixels.
  double get end => screenSize[this]!.$2;
  
  /// Whether this breakpoint is smaller than [breakpoint].
  bool operator <(BreakPoint breakpoint) => this.index < breakpoint.index;
  
  /// Whether this breakpoint is larger than [breakpoint].
  bool operator >(BreakPoint breakpoint) => this.index > breakpoint.index;
  
  /// Whether this breakpoint is smaller than or equal to [breakpoint].
  bool operator <=(BreakPoint breakpoint) => this.index <= breakpoint.index;
  
  /// Whether this breakpoint is larger than or equal to [breakpoint].
  bool operator >=(BreakPoint breakpoint) => this.index >= breakpoint.index;

  /// Returns a human-readable representation of this breakpoint with its range.
  String get label {
    return switch (this) {
      BreakPoint.xs => "xs($start, $end)",
      BreakPoint.sm => "sm($start, $end)",
      BreakPoint.md => "md($start, $end)",
      BreakPoint.lg => "lg($start, $end)",
      BreakPoint.xl => "xl($start, $end)",
      BreakPoint.xxl => "xxl($start, $end)",
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


/// Determines the current breakpoint based on screen width and orientation.
///
/// Uses [MediaQuery] to get the current screen width and orientation,
/// and returns the corresponding [BreakPoint].
BreakPoint breakpoint(BuildContext c) {
  final mediaQuery = MediaQuery.of(c);
  final width = mediaQuery.size.width;
  final orientation = mediaQuery.orientation;

  // If orientation consideration is enabled and device is in landscape,
  // we might want to bump up the breakpoint
  if (getConsiderOrientation() && 
      orientation == Orientation.landscape) {
    // Find the current breakpoint based on width
    BreakPoint current = _breakpointForWidth(width);
    // In landscape, we might want to use a larger breakpoint
    // to account for the increased horizontal space
    if (current < BreakPoint.lg) {
      final values = BreakPoint.values;
      final nextIndex = current.index + 1;
      if (nextIndex < values.length) {
        return values[nextIndex];
      }
    }
    return current;
  }
  final result = _breakpointForWidth(width);
  return result;
}

/// Helper function to determine breakpoint based solely on width.
BreakPoint _breakpointForWidth(double width) {
  for (var val in screenSize.keys) {
    if (valBetween(width, val.start, val.end)) {
      return val;
    }
  }
  return BreakPoint.xxl;
}

/// Checks if a value is between (inclusive) a start and end range.
///
/// Returns `true` if [val] is greater than or equal to [start] and
/// less than or equal to [end].
bool valBetween(double val, double start, double end) {
  return (val >= start) && (val <= end);
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
}

/// Returns a value corresponding to the current breakpoint.
///
/// This function allows you to specify different values for different screen sizes
/// and returns the appropriate one based on the current screen size. If no value
/// is specified for the current breakpoint, returns [defaultValue].
///
/// Optional parameters:
/// - [xs]: Value for extra small screens
/// - [sm]: Value for small screens
/// - [md]: Value for medium screens
/// - [lg]: Value for large screens
/// - [xl]: Value for extra large screens
/// - [xxl]: Value for extra extra large screens
/// - [defaultValue]: Default value to return if no breakpoint value is provided
///
/// Example:
/// 
/// Container(
///   padding: valueFor<EdgeInsets>(
///     context,
///     xs: EdgeInsets.all(8),
///     md: EdgeInsets.all(16),
///     lg: EdgeInsets.all(24),
///     defaultValue: EdgeInsets.all(12),
///   ),
///   child: Text('Responsive padding'),
/// )
/// 
T? valueFor<T>(BuildContext context,
    {T? xs, T? sm, T? md, T? lg, T? xl, T? xxl, T? defaultValue}) {
  if (context.isExtraSmall && xs != null) return xs;
  if (context.isSmall && sm != null) return sm;
  if (context.isMedium && md != null) return md;
  if (context.isLarge && lg != null) return lg;
  if (context.isExtraLarge && xl != null) return xl;
  if (context.isExtraExtraLarge && xxl != null) return xxl;
  return defaultValue;
}

/// Returns a string representation of the current screen size and breakpoint.
///
/// Useful for debugging responsive layouts.
String strRep<T>(BuildContext context) {
  String _size = MediaQuery.of(context).size.toString();
  return "${context.breakPoint.label} - $_size";
}
