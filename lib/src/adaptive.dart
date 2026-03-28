/// A library for creating adaptive UI components in Flutter applications.
///
/// This library provides utilities and widgets that help build responsive UIs
/// that adapt to different screen sizes and device types. It works in conjunction
/// with the media query utilities to create layouts that respond to different
/// breakpoints.
import 'package:flutter/material.dart';
import 'media_query.dart';

/// Defines standard breakpoints for responsive design.
///
/// These breakpoints follow common responsive design patterns:
/// - [xs]: Extra small screens (e.g., small phones)
/// - [sm]: Small screens (e.g., large phones)
/// - [md]: Medium screens (e.g., tablets in portrait)
/// - [lg]: Large screens (e.g., tablets in landscape)
/// - [xl]: Extra large screens (e.g., small desktops)
/// - [xxl]: Extra extra large screens (e.g., large desktops)
enum BreakPoint {
  xs,
  sm,
  md,
  lg,
  xl,
  xxl,
}

/// A function type that builds a value of type [T].
///
/// Used for creating values that depend on the current build context.
typedef ValueBuilderFunc<T> = T Function();

/// Executes a value builder function with the given context.
///
/// This function serves as a utility to create values that may depend
/// on the current build context.
///
/// Example:
/// ```dart
/// final padding = ValueBuilder<EdgeInsets>(context, () {
///   return context.isSmall ? EdgeInsets.all(8) : EdgeInsets.all(16);
/// });
/// ```
T ValueBuilder<T>(BuildContext context, ValueBuilderFunc<T> f) {
  return f();
}

/// Extension on [BuildContext] to provide a more concise way to use [ValueBuilder].
extension BuildValueExtension on BuildContext {
  /// Creates a value using the provided builder function.
  ///
  /// This is a convenience method that calls [ValueBuilder] with this context.
  ///
  /// Example:
  /// ```dart
  /// final padding = context.value<EdgeInsets>(() {
  ///   return context.isSmall ? EdgeInsets.all(8) : EdgeInsets.all(16);
  /// });
  /// ```
  value<T>(ValueBuilderFunc<T> f) {
    return ValueBuilder<T>(this, f);
  }
}

/// A function type that defines how to transition between widgets.
///
/// Used by [AdaptiveContainer] to animate between different layouts.
typedef AdaptiveTransition = Widget Function(Widget, Animation<double>);

/// A widget that builds content based on a builder function.
///
/// This widget is used by [AdaptiveContainer] to create different layouts
/// for different breakpoints.
class AdaptiveSlot extends StatelessWidget {
  /// A function that builds the widget for this slot.
  final WidgetBuilder builder;

  /// Creates an adaptive slot with the given builder.
  ///
  /// The [builder] parameter must not be null.
  const AdaptiveSlot({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: builder,
    );
  }
}

/// A container that displays different content based on the current breakpoint.
///
/// This widget allows you to define different layouts for different screen sizes
/// and automatically switches between them as the screen size changes. It can also
/// animate the transition between layouts.
///
/// Example:
/// ```dart
/// AdaptiveContainer(
///   configs: {
///     BreakPoint.xs: AdaptiveSlot(
///       builder: (context) => MobileLayout(),
///     ),
///     BreakPoint.md: AdaptiveSlot(
///       builder: (context) => TabletLayout(),
///     ),
///     BreakPoint.lg: AdaptiveSlot(
///       builder: (context) => DesktopLayout(),
///     ),
///   },
///   enableAnimation: true,
///   animationDuration: 300,
/// )
/// ```
class AdaptiveContainer extends StatefulWidget {
  /// A map of breakpoints to their corresponding layout slots.
  ///
  /// Each entry in this map defines a layout for a specific breakpoint.
  final Map<BreakPoint, AdaptiveSlot> configs;

  /// A map of semantic adaptive sizes to layout slots.
  final Map<AdaptiveSize, AdaptiveSlot> adaptiveConfigs;

  /// Slot used for compact layouts.
  final AdaptiveSlot? compact;

  /// Slot used for medium layouts.
  final AdaptiveSlot? medium;

  /// Slot used for expanded layouts.
  final AdaptiveSlot? expanded;

  /// Fallback slot used when no breakpoint or semantic slot matches.
  final AdaptiveSlot? defaultSlot;

  /// The duration of the transition animation in milliseconds.
  ///
  /// This is only used if [enableAnimation] is true.
  final int animationDuration;

  /// A function that defines how to transition between layouts.
  ///
  /// If not provided, a fade transition is used by default.
  final AdaptiveTransition? transitionBuilder;

  /// Whether to animate transitions between layouts.
  ///
  /// If true, layouts will animate when switching between breakpoints.
  /// If false, layouts will switch instantly.
  final bool enableAnimation;

  /// Whether to resolve the active layout from parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should affect container-based breakpoint resolution.
  final bool considerOrientation;

  /// Whether animations should be keyed by semantic size instead of breakpoint.
  final bool animateOnAdaptiveSize;

  /// Controls how missing breakpoint slots are resolved.
  final ResponsiveResolveMode resolveMode;

  /// Creates an adaptive container.
  ///
  /// The [configs] parameter defines the layouts for different breakpoints.
  /// The [animationDuration] parameter defines how long transitions take.
  /// The [enableAnimation] parameter determines if transitions are animated.
  /// The [transitionBuilder] parameter customizes the transition animation.
  const AdaptiveContainer(
      {Key? key,
      this.configs = const {},
      this.adaptiveConfigs = const {},
      this.compact,
      this.medium,
      this.expanded,
      this.defaultSlot,
      this.animationDuration = 0,
      this.enableAnimation = false,
      this.transitionBuilder,
      this.useContainerConstraints = false,
      this.considerOrientation = false,
      this.animateOnAdaptiveSize = false,
      this.resolveMode = ResponsiveResolveMode.cascadeDown})
      : super(key: key);

  @override
  _AdaptiveContainerState createState() => _AdaptiveContainerState();
}

class _AdaptiveContainerState extends State<AdaptiveContainer> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final data = widget.useContainerConstraints
            ? breakPointDataForSize(
                Size(
                  constraints.maxWidth.isFinite
                      ? constraints.maxWidth
                      : MediaQuery.of(context).size.width,
                  constraints.maxHeight.isFinite
                      ? constraints.maxHeight
                      : MediaQuery.of(context).size.height,
                ),
                considerOrientation: widget.considerOrientation,
              )
            : context.breakPointData;
        final slot = _slotForData(data);
        final resolvedChild = slot?.build(context) ?? const SizedBox.shrink();

        if (!widget.enableAnimation) {
          return resolvedChild;
        }

        final child = KeyedSubtree(
          key: ValueKey(
            widget.animateOnAdaptiveSize ? data.adaptiveSize : data.breakPoint,
          ),
          child: resolvedChild,
        );

        return AnimatedSwitcher(
          duration: Duration(milliseconds: widget.animationDuration),
          child: child,
          transitionBuilder: (Widget child, Animation<double> animation) {
            if (widget.transitionBuilder != null) {
              return widget.transitionBuilder!(child, animation);
            }
            return FadeTransition(child: child, opacity: animation);
          },
        );
      },
    );
  }

  AdaptiveSlot? _slotForData(BreakPointData data) {
    final exact = widget.configs[data.breakPoint];
    if (exact != null) {
      return exact;
    }

    if (widget.resolveMode == ResponsiveResolveMode.cascadeDown) {
      final cascaded = _cascadeBreakPointSlot(data.breakPoint);
      if (cascaded != null) {
        return cascaded;
      }
    }

    return _slotForAdaptiveSize(data.adaptiveSize) ?? widget.defaultSlot;
  }

  AdaptiveSlot? _cascadeBreakPointSlot(BreakPoint breakPoint) {
    for (var index = breakPoint.index; index >= 0; index--) {
      final slot = widget.configs[BreakPoint.values[index]];
      if (slot != null) {
        return slot;
      }
    }
    return null;
  }

  AdaptiveSlot? _slotForAdaptiveSize(AdaptiveSize adaptiveSize) {
    return widget.adaptiveConfigs[adaptiveSize] ??
        switch (adaptiveSize) {
          AdaptiveSize.compact => widget.compact,
          AdaptiveSize.medium => widget.medium,
          AdaptiveSize.expanded => widget.expanded,
        };
  }
}
