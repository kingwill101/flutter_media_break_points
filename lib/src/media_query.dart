import 'package:flutter/material.dart';

///screen size xs
const double extraSmallStart = 0;
const double extraSmallEnd = 575;

///screen size sm
const double mobileBreakPointStart = 576;
const double mobileBreakPointEnd = 767;

///screen size md
const double tabletBreakPointStart = 768;
const double tabletBreakPointEnd = 991;

///screen size lg
const double desktopBreakPointStart = 992;
const double desktopBreakPointEnd = 1199;

///screen size xl
const double wideScreenBreakPointStart = 1200;

///screen size xxl
const double extraWideScreenBreakPointStart = 1400;

///check if values are between [start] and [end]
bool valBetween(double val, double start, double end) {
  return (val >= start) && (val <= end);
}

///if screen is xs
bool isXs(BuildContext context) {
  return valBetween(
      MediaQuery.of(context).size.width, extraSmallStart, extraSmallEnd);
}

///if screen is sm
bool isSm(BuildContext context) {
  return valBetween(MediaQuery.of(context).size.width, mobileBreakPointStart,
      mobileBreakPointEnd);
}

///if screen is md
bool isMd(BuildContext context) {
  return valBetween(MediaQuery.of(context).size.width, tabletBreakPointStart,
      tabletBreakPointEnd);
}

///if screen is lg
bool isLg(BuildContext context) {
  return valBetween(MediaQuery.of(context).size.width, desktopBreakPointStart,
      desktopBreakPointEnd);
}

///if screen is xl
bool isXl(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  return width >= wideScreenBreakPointStart &&
      width < extraWideScreenBreakPointStart;
}

///if screen is xxl
bool isXXl(BuildContext context) {
  return MediaQuery.of(context).size.width >= extraWideScreenBreakPointStart;
}

extension BreakPointExtension on BuildContext {
  bool get isExtraSmall => isXs(this);
  bool get isSmall => isSm(this);
  bool get isMedium => isMd(this);
  bool get isLarge => isLg(this);
  bool get isExtraLarge => isXl(this);
  bool get isExtraExtraLarge => isXXl(this);
}

/// Returns value corresponding to current breakpoint
/// if corresponding breakpoint is not provided or [defaultValue] if  a
///  default value is provided provided
/// optional breakpoints include
/// [xs] - between [extraSmallStart] and [extraSmallEnd
/// [sm] - between [mobileBreakPointStart] and [mobileBreakPointEnd]
/// [md] - between [tabletBreakPointStart] and [tabletBreakPointEnd]
/// [lg] - between [desktopBreakPointStart] and [desktopBreakPointEnd]
/// [xl] - viewports above [wideScreenBreakPointStart]
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
  if (xs != null && context.isExtraSmall) {
    return xs;
  }
  if (sm != null && context.isSmall) {
    return sm;
  }
  if (md != null && context.isMedium) {
    return md;
  }
  if (lg != null && context.isLarge) {
    return lg;
  }
  if (xl != null && context.isExtraLarge) {
    return xl;
  }
  if (xxl != null && context.isExtraExtraLarge) {
    return xxl;
  }

  if (defaultValue != null) {
    return defaultValue;
  }
  return null;
}

///return string representation of screen size
String strRep<T>(BuildContext context) {
  String _size = MediaQuery.of(context).size.toString();
  if (isXs(context)) {
    return "xs: $_size";
  }
  if (isSm(context)) {
    return "sm: $_size";
  }
  if (isMd(context)) {
    return "md: $_size";
  }
  if (isLg(context)) {
    return "lg: $_size";
  }
  if (isXl(context)) {
    return "xl: $_size";
  }
  return "unknown: $_size";
}
