import 'package:flutter/material.dart';

import '../media_break_points.dart' show BreakPoint;
import 'media_query.dart';

/// A builder function that creates a widget based on the current breakpoint.
typedef ResponsiveLayoutWidgetBuilder = Widget Function(
  BuildContext context,
  BreakPoint breakpoint,
);

ResponsiveLayoutWidgetBuilder? _layoutBuilderForBreakpoint(
  BreakPoint breakpoint, {
  ResponsiveLayoutWidgetBuilder? xs,
  ResponsiveLayoutWidgetBuilder? sm,
  ResponsiveLayoutWidgetBuilder? md,
  ResponsiveLayoutWidgetBuilder? lg,
  ResponsiveLayoutWidgetBuilder? xl,
  ResponsiveLayoutWidgetBuilder? xxl,
}) {
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

BreakPoint _resolveLayoutBreakpoint(
  BuildContext context,
  BoxConstraints constraints, {
  required bool useContainerConstraints,
  required bool considerOrientation,
}) {
  if (!useContainerConstraints) {
    return context.breakPoint;
  }

  final mediaSize = MediaQuery.maybeOf(context)?.size ?? Size.zero;
  final width =
      constraints.maxWidth.isFinite ? constraints.maxWidth : mediaSize.width;
  final height =
      constraints.maxHeight.isFinite ? constraints.maxHeight : mediaSize.height;
  return breakPointDataForSize(
    Size(width, height),
    considerOrientation: considerOrientation,
  ).breakPoint;
}

Widget _defaultAnimatedLayoutBuilder(
  Widget? currentChild,
  List<Widget> previousChildren,
) {
  return Stack(
    alignment: AlignmentDirectional.topStart,
    children: <Widget>[
      ...previousChildren,
      if (currentChild != null) currentChild,
    ],
  );
}

/// A widget that builds different layouts based on the current breakpoint.
///
/// This widget is similar to [AdaptiveContainer], but uses a builder function
/// instead of a map of widgets, which can be more flexible in some cases.
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

  /// Default builder to use if no specific builder is provided.
  final ResponsiveLayoutWidgetBuilder? defaultBuilder;

  /// Whether to derive the breakpoint from parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should influence container-based breakpoint selection.
  final bool considerOrientation;

  /// Creates a responsive layout builder.
  const ResponsiveLayoutBuilder({
    super.key,
    this.xs,
    this.sm,
    this.md,
    this.lg,
    this.xl,
    this.xxl,
    this.defaultBuilder,
    this.useContainerConstraints = false,
    this.considerOrientation = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final breakpoint = _resolveLayoutBreakpoint(
          context,
          constraints,
          useContainerConstraints: useContainerConstraints,
          considerOrientation: considerOrientation,
        );
        final builder = _getBuilderForBreakpoint(breakpoint);
        if (builder != null) {
          return builder(context, breakpoint);
        }

        return defaultBuilder != null
            ? defaultBuilder!(context, breakpoint)
            : Container();
      },
    );
  }

  ResponsiveLayoutWidgetBuilder? _getBuilderForBreakpoint(
    BreakPoint breakpoint,
  ) {
    return _layoutBuilderForBreakpoint(
      breakpoint,
      xs: xs,
      sm: sm,
      md: md,
      lg: lg,
      xl: xl,
      xxl: xxl,
    );
  }
}

/// Animates layout transitions as the active breakpoint changes.
class AnimatedResponsiveLayoutBuilder extends StatelessWidget {
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

  /// Default builder to use if no specific builder is found.
  final ResponsiveLayoutWidgetBuilder? defaultBuilder;

  /// Whether to derive the breakpoint from parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should influence container-based breakpoints.
  final bool considerOrientation;

  /// Duration of the transition animation.
  final Duration duration;

  /// Curve used for incoming widgets.
  final Curve switchInCurve;

  /// Curve used for outgoing widgets.
  final Curve switchOutCurve;

  /// Optional custom transition builder.
  final AnimatedSwitcherTransitionBuilder? transitionBuilder;

  /// Optional custom layout builder for [AnimatedSwitcher].
  final AnimatedSwitcherLayoutBuilder? layoutBuilder;

  /// Whether to key animations by semantic adaptive size instead of the raw
  /// breakpoint.
  final bool animateOnAdaptiveSize;

  /// Creates an animated responsive layout builder.
  const AnimatedResponsiveLayoutBuilder({
    super.key,
    this.xs,
    this.sm,
    this.md,
    this.lg,
    this.xl,
    this.xxl,
    this.defaultBuilder,
    this.useContainerConstraints = false,
    this.considerOrientation = false,
    this.duration = const Duration(milliseconds: 250),
    this.switchInCurve = Curves.easeOutCubic,
    this.switchOutCurve = Curves.easeInCubic,
    this.transitionBuilder,
    this.layoutBuilder,
    this.animateOnAdaptiveSize = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final breakpoint = _resolveLayoutBreakpoint(
          context,
          constraints,
          useContainerConstraints: useContainerConstraints,
          considerOrientation: considerOrientation,
        );
        final builder = _layoutBuilderForBreakpoint(
          breakpoint,
          xs: xs,
          sm: sm,
          md: md,
          lg: lg,
          xl: xl,
          xxl: xxl,
        );

        final resolvedChild = builder != null
            ? builder(context, breakpoint)
            : defaultBuilder != null
                ? defaultBuilder!(context, breakpoint)
                : const SizedBox.shrink();
        final keyValue = animateOnAdaptiveSize
            ? adaptiveSizeForBreakPoint(breakpoint)
            : breakpoint;

        return AnimatedSwitcher(
          duration: duration,
          switchInCurve: switchInCurve,
          switchOutCurve: switchOutCurve,
          transitionBuilder: transitionBuilder ??
              (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SizeTransition(
                    sizeFactor: animation,
                    axisAlignment: -1,
                    child: child,
                  ),
                );
              },
          layoutBuilder: layoutBuilder ?? _defaultAnimatedLayoutBuilder,
          child: KeyedSubtree(
            key: ValueKey(keyValue),
            child: resolvedChild,
          ),
        );
      },
    );
  }
}
