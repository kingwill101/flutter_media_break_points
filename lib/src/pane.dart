import 'package:flutter/material.dart';

import 'container_layout.dart';
import 'media_query.dart';

/// The active arrangement used by [AdaptivePane].
enum AdaptivePaneMode {
  stacked,
  split,
}

/// A pane layout that stacks content in compact spaces and splits it in
/// medium or expanded spaces.
class AdaptivePane extends StatelessWidget {
  /// Primary pane content.
  final Widget primary;

  /// Secondary pane content.
  final Widget secondary;

  /// The semantic size at which the layout should switch to split mode.
  final AdaptiveSize splitAt;

  /// Minimum height class required before the pane can split.
  final AdaptiveHeight minimumSplitHeight;

  /// Whether to derive the layout mode from parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should influence container-based breakpoint selection.
  final bool considerOrientation;

  /// Axis used when the pane is stacked.
  final Axis stackedAxis;

  /// Axis used when the pane is split.
  final Axis splitAxis;

  /// Whether the secondary pane should appear first in stacked mode.
  final bool secondaryFirstWhenStacked;

  /// Whether the secondary pane should appear first in split mode.
  final bool secondaryFirstWhenSplit;

  /// Space between the two panes.
  final double spacing;

  /// Flex for the primary pane in split mode.
  final int primaryFlex;

  /// Flex for the secondary pane in split mode.
  final int secondaryFlex;

  /// Whether to animate size changes when the layout mode changes.
  final bool animateSize;

  /// Duration used by [AnimatedSize].
  final Duration animationDuration;

  /// Curve used by [AnimatedSize].
  final Curve animationCurve;

  /// Cross-axis alignment used by the internal [Flex].
  final CrossAxisAlignment crossAxisAlignment;

  /// Main-axis alignment used by the internal [Flex].
  final MainAxisAlignment mainAxisAlignment;

  /// Creates an adaptive pane layout.
  const AdaptivePane({
    super.key,
    required this.primary,
    required this.secondary,
    this.splitAt = AdaptiveSize.medium,
    this.minimumSplitHeight = AdaptiveHeight.compact,
    this.useContainerConstraints = true,
    this.considerOrientation = false,
    this.stackedAxis = Axis.vertical,
    this.splitAxis = Axis.horizontal,
    this.secondaryFirstWhenStacked = false,
    this.secondaryFirstWhenSplit = false,
    this.spacing = 16,
    this.primaryFlex = 2,
    this.secondaryFlex = 1,
    this.animateSize = true,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeInOutCubic,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final child = useContainerConstraints
        ? ResponsiveContainerBuilder(
            considerOrientation: considerOrientation,
            builder: (context, data) => _buildForData(context, data),
          )
        : Builder(
            builder: (context) =>
                _buildForData(context, context.breakPointData),
          );

    if (!animateSize) {
      return child;
    }

    return AnimatedSize(
      duration: animationDuration,
      curve: animationCurve,
      alignment: Alignment.topCenter,
      child: child,
    );
  }

  Widget _buildForData(BuildContext context, BreakPointData data) {
    final mode = _paneModeFor(data);
    return _AdaptivePaneLayout(
      mode: mode,
      primary: primary,
      secondary: secondary,
      stackedAxis: stackedAxis,
      splitAxis: splitAxis,
      secondaryFirstWhenStacked: secondaryFirstWhenStacked,
      secondaryFirstWhenSplit: secondaryFirstWhenSplit,
      spacing: spacing,
      primaryFlex: primaryFlex,
      secondaryFlex: secondaryFlex,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
    );
  }

  AdaptivePaneMode _paneModeFor(BreakPointData data) {
    final isWideEnough = data.adaptiveSize.index >= splitAt.index;
    final isTallEnough = data.adaptiveHeight.index >= minimumSplitHeight.index;

    return isWideEnough && isTallEnough
        ? AdaptivePaneMode.split
        : AdaptivePaneMode.stacked;
  }
}

class _AdaptivePaneLayout extends StatelessWidget {
  final AdaptivePaneMode mode;
  final Widget primary;
  final Widget secondary;
  final Axis stackedAxis;
  final Axis splitAxis;
  final bool secondaryFirstWhenStacked;
  final bool secondaryFirstWhenSplit;
  final double spacing;
  final int primaryFlex;
  final int secondaryFlex;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  const _AdaptivePaneLayout({
    required this.mode,
    required this.primary,
    required this.secondary,
    required this.stackedAxis,
    required this.splitAxis,
    required this.secondaryFirstWhenStacked,
    required this.secondaryFirstWhenSplit,
    required this.spacing,
    required this.primaryFlex,
    required this.secondaryFlex,
    required this.crossAxisAlignment,
    required this.mainAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    final isSplit = mode == AdaptivePaneMode.split;
    final axis = isSplit ? splitAxis : stackedAxis;
    final placeSecondaryFirst =
        isSplit ? secondaryFirstWhenSplit : secondaryFirstWhenStacked;
    final firstChild = placeSecondaryFirst ? secondary : primary;
    final secondChild = placeSecondaryFirst ? primary : secondary;

    return Flex(
      direction: axis,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        if (isSplit)
          Expanded(
            flex: placeSecondaryFirst ? secondaryFlex : primaryFlex,
            child: firstChild,
          )
        else
          firstChild,
        _PaneGap(axis: axis, spacing: spacing),
        if (isSplit)
          Expanded(
            flex: placeSecondaryFirst ? primaryFlex : secondaryFlex,
            child: secondChild,
          )
        else
          secondChild,
      ],
    );
  }
}

class _PaneGap extends StatelessWidget {
  final Axis axis;
  final double spacing;

  const _PaneGap({
    required this.axis,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return axis == Axis.horizontal
        ? SizedBox(width: spacing)
        : SizedBox(height: spacing);
  }
}
