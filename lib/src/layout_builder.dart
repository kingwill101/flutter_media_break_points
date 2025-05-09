import 'package:flutter/material.dart';
import '../media_break_points.dart' show BreakPoint;
import 'media_query.dart';

/// A builder function that creates a widget based on the current breakpoint.
typedef ResponsiveLayoutWidgetBuilder = Widget Function(
  BuildContext context,
  BreakPoint breakpoint,
);

/// A widget that builds different layouts based on the current breakpoint.
///
/// This widget is similar to [AdaptiveContainer], but uses a builder function
/// instead of a map of widgets, which can be more flexible in some cases.
///
/// Example:
/// 
/// ResponsiveLayoutBuilder(
///   xs: (context, _) => MobileLayout(),
///   sm: (context, _) => MobileLayout(),
///   md: (context, _) => TabletLayout(),
///   lg: (context, _) => DesktopLayout(),
///   xl: (context, _) => DesktopLayout(),
///   xxl: (context, _) => DesktopLayout(),
/// )
/// 
class ResponsiveLayoutBuilder extends StatelessWidget {
  /// Builder for extra small screens.
  final ResponsiveLayoutWidgetBuilder? xs;
  
  /// Builder for small screens.
  final ResponsiveLayoutWidgetBuilder? sm;
  
  /// Builder for medium screens.
  final ResponsiveLayoutWidgetBuilder? md;
  
  /// Builder for large screens.
  final ResponsiveLayoutWidgetBuilder? lg;
  
  /// Builder for extra large screens.
  final ResponsiveLayoutWidgetBuilder? xl;
  
  /// Builder for extra extra large screens.
  final ResponsiveLayoutWidgetBuilder? xxl;
  
  /// Default builder to use if no specific builder is provided for the current breakpoint.
  final ResponsiveLayoutWidgetBuilder? defaultBuilder;

  /// Creates a responsive layout builder.
  ///
  /// At least one builder must be provided.
  const ResponsiveLayoutBuilder({
    Key? key,
    this.xs,
    this.sm,
    this.md,
    this.lg,
    this.xl,
    this.xxl,
    this.defaultBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final breakpoint = context.breakPoint;
        
        // Try to find a builder for the current breakpoint
        final builder = _getBuilderForBreakpoint(breakpoint);
        
        if (builder != null) {
          return builder(context, breakpoint);
        }
        
        // If no builder is found and no default builder is provided, return an empty container
        return defaultBuilder != null
            ? defaultBuilder!(context, breakpoint)
            : Container();
      },
    );
  }
  
  /// Gets the appropriate builder for the given breakpoint.
  ResponsiveLayoutWidgetBuilder? _getBuilderForBreakpoint(BreakPoint breakpoint) {
    switch (breakpoint) {
      case BreakPoint.xs:
        return xs;
      case BreakPoint.sm:
        return sm ?? xs;
      case BreakPoint.md:
        return md ?? sm ?? xs;
      case BreakPoint.lg:
        return lg ?? md ?? sm ?? xs;
      case BreakPoint.xl:
        return xl ?? lg ?? md ?? sm ?? xs;
      case BreakPoint.xxl:
        return xxl ?? xl ?? lg ?? md ?? sm ?? xs;
    }
  }
}