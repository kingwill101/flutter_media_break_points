import 'package:flutter/material.dart';
import 'package:media_break_points/media_break_points.dart';
import 'package:media_break_points/src/adaptive.dart';

Map<BreakPoint, (double, double)> screenSize = {
  BreakPoint.xs: (0, 575),
  BreakPoint.sm: (576, 767),
  BreakPoint.md: (768, 991),
  BreakPoint.lg: (992, 1199),
  BreakPoint.xl: (1200, 1400),
  BreakPoint.xxl: (1401, 0),
};

extension BreakPointExtension on BreakPoint {
  double get start => screenSize[this]!.$1;
  double get end => screenSize[this]!.$2;
  bool operator <(BreakPoint breakpoint) => this.index < breakpoint.index;
  bool operator >(BreakPoint breakpoint) => this.index > breakpoint.index;
  bool operator <=(BreakPoint breakpoint) => this.index <= breakpoint.index;
  bool operator >=(BreakPoint breakpoint) => this.index >= breakpoint.index;

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

BreakPoint breakpoint(BuildContext c) {
  final width = MediaQuery.of(c).size.width;
  for (var val in screenSize.keys) {
    if (valBetween(width, val.start, val.end)) {
      return val;
    }
  }
  return BreakPoint.xxl;
}

bool valBetween(double val, double start, double end) {
  return (val >= start) && (val <= end);
}

///if screen is xs
bool isXs(BuildContext context) {
  return breakpoint(context) == BreakPoint.xs;
}

///if screen is sm
bool isSm(BuildContext context) {
  return breakpoint(context) == BreakPoint.sm;
}

///if screen is md
bool isMd(BuildContext context) {
  return breakpoint(context) == BreakPoint.md;
}

///if screen is lg
bool isLg(BuildContext context) {
  return breakpoint(context) == BreakPoint.lg;
}

///if screen is xl
bool isXl(BuildContext context) {
  return breakpoint(context) == BreakPoint.xl;
}

///if screen is xxl
bool isXXl(BuildContext context) {
  return breakpoint(context) == BreakPoint.xxl;
}

extension BuildContextExtension on BuildContext {
  bool get isExtraSmall => isXs(this);
  bool get isSmall => isSm(this);
  bool get isMedium => isMd(this);
  bool get isLarge => isLg(this);
  bool get isExtraLarge => isXl(this);
  bool get isExtraExtraLarge => isXXl(this);
  BreakPoint get breakPoint => breakpoint(this);
}

/// Returns value corresponding to current breakpoint
/// if corresponding breakpoint is not provided or [defaultValue] if  a
///  default value is provided provided
/// optional breakpoints include
/// [xs]
/// [sm]
/// [md]
/// [lg]
/// [lg]
/// [xxl]
/// [defaultValue] the default value to return if a breakpoint value isn't set
/// ```dart
/// Container c = Container(
/// padding: valueFor<EdgeInsetGeometry>(
/// xs:EdgeInsets.only(left: 25, right: 20),
/// md:EdgeInsets.only(left: 25, right: 20),
/// lg:EdgeInsets.only(left: 25, right: 20),
/// );
/// )
/// ```
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

///return string representation of screen size
String strRep<T>(BuildContext context) {
  String _size = MediaQuery.of(context).size.toString();
  return "${context.breakPoint.label} - $_size";
}
