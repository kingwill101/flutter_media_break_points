import 'package:flutter/material.dart';

import '../container_layout.dart';
import '../media_query.dart';

/// The active arrangement used by [AdaptiveBoard].
enum AdaptiveBoardMode {
  stacked,
  board,
}

/// A single lane definition used by [AdaptiveBoard].
class AdaptiveBoardLane {
  /// Lane title shown in the lane header.
  final String title;

  /// Optional supporting copy shown below the title.
  final String? description;

  /// Optional leading widget shown in the lane header.
  final Widget? leading;

  /// Optional trailing widget shown in the lane header.
  final Widget? trailing;

  /// Items shown inside the lane body.
  final List<Widget> items;

  /// Optional footer shown after the lane items.
  final Widget? footer;

  /// Optional empty state shown when [items] is empty.
  final Widget? emptyState;

  /// Creates a lane definition.
  const AdaptiveBoardLane({
    required this.title,
    required this.items,
    this.description,
    this.leading,
    this.trailing,
    this.footer,
    this.emptyState,
  });
}

/// A workflow board that stacks lanes on compact widths and becomes a board on
/// larger containers.
///
/// Compact containers render lanes vertically. Medium and expanded containers
/// render horizontally scrollable columns.
class AdaptiveBoard extends StatelessWidget {
  /// Lanes shown by the board.
  final List<AdaptiveBoardLane> lanes;

  /// Semantic size at which the board should switch to column mode.
  final AdaptiveSize boardAt;

  /// Minimum height class required before the board can switch to columns.
  final AdaptiveHeight minimumBoardHeight;

  /// Whether to derive layout mode from parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should influence container-based breakpoint selection.
  final bool considerOrientation;

  /// Width of each board lane in column mode.
  final double laneWidth;

  /// Space between adjacent lanes.
  final double laneSpacing;

  /// Space between items inside a lane.
  final double itemSpacing;

  /// Padding applied inside each lane surface.
  final EdgeInsetsGeometry lanePadding;

  /// Whether transitions should animate.
  final bool animateTransitions;

  /// Duration used by animations.
  final Duration transitionDuration;

  /// Curve used by animations.
  final Curve transitionCurve;

  /// Creates an adaptive board.
  const AdaptiveBoard({
    super.key,
    required this.lanes,
    this.boardAt = AdaptiveSize.medium,
    this.minimumBoardHeight = AdaptiveHeight.compact,
    this.useContainerConstraints = true,
    this.considerOrientation = false,
    this.laneWidth = 280,
    this.laneSpacing = 16,
    this.itemSpacing = 12,
    this.lanePadding = const EdgeInsets.all(16),
    this.animateTransitions = true,
    this.transitionDuration = const Duration(milliseconds: 250),
    this.transitionCurve = Curves.easeInOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    if (lanes.isEmpty) {
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

    return AnimatedSize(
      duration: transitionDuration,
      curve: transitionCurve,
      alignment: Alignment.topCenter,
      child: child,
    );
  }

  Widget _buildForData(BuildContext context, BreakPointData data) {
    final mode = _modeForData(data);

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
      child: KeyedSubtree(
        key: ValueKey(mode),
        child: switch (mode) {
          AdaptiveBoardMode.stacked => _StackedBoardLayout(
              lanes: lanes,
              itemSpacing: itemSpacing,
              laneSpacing: laneSpacing,
              lanePadding: lanePadding,
            ),
          AdaptiveBoardMode.board => LayoutBuilder(
              builder: (context, constraints) {
                final boundedHeight = constraints.maxHeight.isFinite
                    ? constraints.maxHeight
                    : null;

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var index = 0; index < lanes.length; index++) ...[
                        SizedBox(
                          width: laneWidth,
                          height: boundedHeight,
                          child: _BoardLaneCard(
                            lane: lanes[index],
                            itemSpacing: itemSpacing,
                            padding: lanePadding,
                            scrollItems: boundedHeight != null,
                          ),
                        ),
                        if (index < lanes.length - 1)
                          SizedBox(width: laneSpacing),
                      ],
                    ],
                  ),
                );
              },
            ),
        },
      ),
    );
  }

  AdaptiveBoardMode _modeForData(BreakPointData data) {
    final isWideEnough = data.adaptiveSize.index >= boardAt.index;
    final isTallEnough = data.adaptiveHeight.index >= minimumBoardHeight.index;

    return isWideEnough && isTallEnough
        ? AdaptiveBoardMode.board
        : AdaptiveBoardMode.stacked;
  }
}

class _StackedBoardLayout extends StatelessWidget {
  final List<AdaptiveBoardLane> lanes;
  final double itemSpacing;
  final double laneSpacing;
  final EdgeInsetsGeometry lanePadding;

  const _StackedBoardLayout({
    required this.lanes,
    required this.itemSpacing,
    required this.laneSpacing,
    required this.lanePadding,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < lanes.length; index++) ...[
            _BoardLaneCard(
              lane: lanes[index],
              itemSpacing: itemSpacing,
              padding: lanePadding,
            ),
            if (index < lanes.length - 1) SizedBox(height: laneSpacing),
          ],
        ],
      ),
    );
  }
}

class _BoardLaneCard extends StatelessWidget {
  final AdaptiveBoardLane lane;
  final double itemSpacing;
  final EdgeInsetsGeometry padding;
  final bool scrollItems;

  const _BoardLaneCard({
    required this.lane,
    required this.itemSpacing,
    required this.padding,
    this.scrollItems = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = _LaneBody(
      lane: lane,
      itemSpacing: itemSpacing,
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final useWholeLaneScroll =
                scrollItems && constraints.maxWidth < 140;

            if (useWholeLaneScroll) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LaneHeader(lane: lane),
                    const SizedBox(height: 16),
                    content,
                  ],
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LaneHeader(lane: lane),
                const SizedBox(height: 16),
                if (scrollItems)
                  Expanded(
                    child: SingleChildScrollView(
                      child: content,
                    ),
                  )
                else
                  content,
              ],
            );
          },
        ),
      ),
    );
  }
}

class _LaneHeader extends StatelessWidget {
  final AdaptiveBoardLane lane;

  const _LaneHeader({
    required this.lane,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTightHeader = constraints.maxWidth < 140;

        if (isTightHeader) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (lane.leading != null || lane.trailing != null)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (lane.leading != null) lane.leading!,
                    if (lane.trailing != null) lane.trailing!,
                  ],
                ),
              if (lane.leading != null || lane.trailing != null)
                const SizedBox(height: 8),
              _LaneTitleBlock(lane: lane),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (lane.leading != null) ...[
              lane.leading!,
              const SizedBox(width: 12),
            ],
            Expanded(
              child: _LaneTitleBlock(lane: lane),
            ),
            if (lane.trailing != null) ...[
              const SizedBox(width: 12),
              lane.trailing!,
            ],
          ],
        );
      },
    );
  }
}

class _LaneTitleBlock extends StatelessWidget {
  final AdaptiveBoardLane lane;

  const _LaneTitleBlock({
    required this.lane,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lane.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        if (lane.description != null) ...[
          const SizedBox(height: 4),
          Text(
            lane.description!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ],
    );
  }
}

class _LaneBody extends StatelessWidget {
  final AdaptiveBoardLane lane;
  final double itemSpacing;

  const _LaneBody({
    required this.lane,
    required this.itemSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final laneItems = lane.items.isEmpty
        ? [lane.emptyState ?? const _DefaultBoardLaneEmptyState()]
        : lane.items;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < laneItems.length; index++) ...[
          laneItems[index],
          if (index < laneItems.length - 1) SizedBox(height: itemSpacing),
        ],
        if (lane.footer != null) ...[
          SizedBox(height: itemSpacing),
          lane.footer!,
        ],
      ],
    );
  }
}

class _DefaultBoardLaneEmptyState extends StatelessWidget {
  const _DefaultBoardLaneEmptyState();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'No items yet.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
