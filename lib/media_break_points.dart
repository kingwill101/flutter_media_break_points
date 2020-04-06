library media_break_points;

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
  return MediaQuery.of(context).size.width >= wideScreenBreakPointStart;
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
///
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
T valueFor<T>(BuildContext context,
    {T xs, T sm, T md, T lg, T xl, T defaultValue}) {
  if (xs != null && isXs(context)) {
    return xs;
  }
  if (sm != null && isSm(context)) {
    return sm;
  }
  if (md != null && isMd(context)) {
    return md;
  }
  if (lg != null && isLg(context)) {
    return lg;
  }
  if (xl != null && isXl(context)) {
    return xl;
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
