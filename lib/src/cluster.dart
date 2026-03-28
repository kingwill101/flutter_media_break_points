import 'package:flutter/material.dart';

import 'container_layout.dart';
import 'media_query.dart';

/// Layout modes supported by [AdaptiveCluster].
enum AdaptiveClusterLayout {
  column,
  wrap,
  row,
}

/// A compositional layout primitive that can switch between stacked, wrapped,
/// and inline arrangements from the same child list.
class AdaptiveCluster extends StatelessWidget {
  /// Children displayed by the cluster.
  final List<Widget> children;

  /// Layout used for compact sizes.
  final AdaptiveClusterLayout compactLayout;

  /// Layout used for medium sizes.
  final AdaptiveClusterLayout mediumLayout;

  /// Layout used for expanded sizes.
  final AdaptiveClusterLayout expandedLayout;

  /// Spacing between adjacent children.
  final double spacing;

  /// Run spacing used by [Wrap].
  final double runSpacing;

  /// Whether to resolve the active layout from parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should affect container-based breakpoint resolution.
  final bool considerOrientation;

  /// Whether layout transitions should animate.
  final bool animateTransitions;

  /// Duration for animated layout transitions.
  final Duration transitionDuration;

  /// Curve for animated layout transitions.
  final Curve transitionCurve;

  /// Main-axis alignment used by row and column layouts.
  final MainAxisAlignment mainAxisAlignment;

  /// Cross-axis alignment used by row and column layouts.
  final CrossAxisAlignment crossAxisAlignment;

  /// Alignment used by [Wrap].
  final WrapAlignment wrapAlignment;

  /// Cross-axis alignment used by [Wrap].
  final WrapCrossAlignment wrapCrossAlignment;

  /// Creates an adaptive cluster.
  const AdaptiveCluster({
    super.key,
    required this.children,
    this.compactLayout = AdaptiveClusterLayout.column,
    this.mediumLayout = AdaptiveClusterLayout.wrap,
    this.expandedLayout = AdaptiveClusterLayout.wrap,
    this.spacing = 12,
    this.runSpacing = 12,
    this.useContainerConstraints = true,
    this.considerOrientation = false,
    this.animateTransitions = true,
    this.transitionDuration = const Duration(milliseconds: 250),
    this.transitionCurve = Curves.easeInOutCubic,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.wrapAlignment = WrapAlignment.start,
    this.wrapCrossAlignment = WrapCrossAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    final child = useContainerConstraints
        ? ResponsiveContainerBuilder(
            considerOrientation: considerOrientation,
            builder: (context, data) => _buildForData(context, data),
          )
        : Builder(
            builder: (context) =>
                _buildForData(context, context.breakPointData),
          );

    if (!animateTransitions) {
      return child;
    }

    return AnimatedSwitcher(
      duration: transitionDuration,
      switchInCurve: transitionCurve,
      switchOutCurve: transitionCurve.flipped,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            axisAlignment: -1,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildForData(BuildContext context, BreakPointData data) {
    final layout = _layoutForAdaptiveSize(data.adaptiveSize);

    return KeyedSubtree(
      key: ValueKey(layout),
      child: switch (layout) {
        AdaptiveClusterLayout.column => Column(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: _separatedChildren(
              axis: Axis.vertical,
              spacing: spacing,
              children: children,
            ),
          ),
        AdaptiveClusterLayout.row => Row(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: _separatedChildren(
              axis: Axis.horizontal,
              spacing: spacing,
              children: children,
            ),
          ),
        AdaptiveClusterLayout.wrap => Wrap(
            spacing: spacing,
            runSpacing: runSpacing,
            alignment: wrapAlignment,
            crossAxisAlignment: wrapCrossAlignment,
            children: children,
          ),
      },
    );
  }

  AdaptiveClusterLayout _layoutForAdaptiveSize(AdaptiveSize adaptiveSize) {
    return switch (adaptiveSize) {
      AdaptiveSize.compact => compactLayout,
      AdaptiveSize.medium => mediumLayout,
      AdaptiveSize.expanded => expandedLayout,
    };
  }

  List<Widget> _separatedChildren({
    required Axis axis,
    required double spacing,
    required List<Widget> children,
  }) {
    if (children.length < 2) {
      return children;
    }

    final separated = <Widget>[];
    for (var index = 0; index < children.length; index++) {
      if (index > 0) {
        separated.add(
          axis == Axis.horizontal
              ? SizedBox(width: spacing)
              : SizedBox(height: spacing),
        );
      }
      separated.add(children[index]);
    }
    return separated;
  }
}
