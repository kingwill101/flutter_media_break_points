import 'package:flutter/material.dart';
import '../media_break_points.dart' show BreakPoint;
import 'media_query.dart';

/// A widget that shows or hides its child based on the current breakpoint.
///
/// This widget is useful for showing different UI elements on different
/// screen sizes without having to write conditional logic in your build method.
///
/// Example:
///
/// ResponsiveVisibility(
///   visibleWhen: {
///     Condition.largerThan(name: BreakPoint.sm): true,
///   },
///   replacement: MobileMenu(),
///   child: DesktopMenu(),
/// )
///
class ResponsiveVisibility extends StatelessWidget {
  /// The child widget to show or hide.
  final Widget child;

  /// The widget to show when the child is hidden.
  ///
  /// If null, an empty [SizedBox] will be used.
  final Widget? replacement;

  /// Whether the child is visible on extra small screens.
  final bool? visibleXs;

  /// Whether the child is visible on small screens.
  final bool? visibleSm;

  /// Whether the child is visible on medium screens.
  final bool? visibleMd;

  /// Whether the child is visible on large screens.
  final bool? visibleLg;

  /// Whether the child is visible on extra large screens.
  final bool? visibleXl;

  /// Whether the child is visible on extra extra large screens.
  final bool? visibleXxl;

  /// A map of conditions to visibility values.
  ///
  /// This allows for more complex visibility rules than the simple
  /// breakpoint-based properties.
  final Map<Condition, bool>? visibleWhen;

  /// Whether to maintain the child's state when it's not visible.
  ///
  /// If true, the child will be built but not shown when it's not visible.
  /// If false, the child will not be built when it's not visible.
  final bool maintainState;

  /// Whether to maintain the child's size when it's not visible.
  ///
  /// If true, the child's size will be preserved when it's not visible.
  /// If false, the child will take up no space when it's not visible.
  final bool maintainSize;

  /// Whether to maintain the child's animation when it's not visible.
  ///
  /// If true, the child's animation will continue when it's not visible.
  /// If false, the child's animation will be paused when it's not visible.
  final bool maintainAnimation;

  /// Whether to maintain the child's interactivity when it's not visible.
  ///
  /// If true, the child will still be interactive when it's not visible.
  /// If false, the child will not be interactive when it's not visible.
  final bool maintainInteractivity;

  /// Creates a responsive visibility widget.
  ///
  /// At least one of the visibility properties or [visibleWhen] must be provided.
  const ResponsiveVisibility({
    Key? key,
    required this.child,
    this.replacement,
    this.visibleXs,
    this.visibleSm,
    this.visibleMd,
    this.visibleLg,
    this.visibleXl,
    this.visibleXxl,
    this.visibleWhen,
    this.maintainState = false,
    this.maintainSize = false,
    this.maintainAnimation = false,
    this.maintainInteractivity = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isVisible = _isVisible(context);

    // Always use Visibility to preserve state if maintainState is true
    if (maintainState || replacement == null) {
      return Visibility(
        visible: isVisible,
        maintainState: maintainState,
        maintainSize: maintainSize,
        maintainAnimation: maintainAnimation,
        maintainInteractivity: maintainInteractivity,
        child: child,
      );
    }

    // If not maintaining state and a replacement is provided, use replacement when not visible
    return isVisible ? child : replacement!;
  }

  /// Determines whether the child should be visible based on the current breakpoint.
  bool _isVisible(BuildContext context) {
    // Check simple breakpoint visibility properties
    final breakpointVisible = valueFor<bool>(
      context,
      xs: visibleXs,
      sm: visibleSm,
      md: visibleMd,
      lg: visibleLg,
      xl: visibleXl,
      xxl: visibleXxl,
    );
    final anyFlagSet = [
      visibleXs,
      visibleSm,
      visibleMd,
      visibleLg,
      visibleXl,
      visibleXxl
    ].any((v) => v != null);
    if (breakpointVisible != null) {
      return breakpointVisible;
    }

    // Check condition-based visibility
    if (visibleWhen != null && visibleWhen!.isNotEmpty) {
      for (final entry in visibleWhen!.entries) {
        final result = entry.key.check(context);
        if (result) {
          return entry.value;
        }
      }
      // If visibleWhen is provided but no condition matches, return false
      return false;
    }

    if (anyFlagSet) {
      return false;
    }

    // Default to visible if no conditions or flags are specified
    return true;
  }
}

/// A condition for responsive visibility.
///
/// This class is used to define complex conditions for [ResponsiveVisibility].
class Condition {
  /// A function that checks whether the condition is met.
  final bool Function(BuildContext) check;

  /// Creates a condition with the given check function.
  const Condition(this.check);

  /// Creates a condition that is true when the current breakpoint is equal to [name].
  static Condition equals(BreakPoint name) {
    return Condition((context) => context.breakPoint == name);
  }

  /// Creates a condition that is true when the current breakpoint is larger than [name].
  static Condition largerThan(BreakPoint name) {
    return Condition((context) => context.breakPoint > name);
  }

  /// Creates a condition that is true when the current breakpoint is smaller than [name].
  static Condition smallerThan(BreakPoint name) {
    return Condition((context) => context.breakPoint < name);
  }

  /// Creates a condition that is true when the current breakpoint is between [start] and [end].
  static Condition between(BreakPoint start, BreakPoint end) {
    return Condition((context) {
      final current = context.breakPoint;
      return current >= start && current <= end;
    });
  }
}
