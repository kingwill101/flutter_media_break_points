import 'package:flutter/material.dart';

import '../container_layout.dart';
import '../media_query.dart';

/// The active arrangement used by [AdaptiveTimeline].
enum AdaptiveTimelineMode {
  stacked,
  horizontal,
}

/// A single milestone definition used by [AdaptiveTimeline].
class AdaptiveTimelineEntry {
  /// Milestone title.
  final String title;

  /// Optional supporting copy shown under [title].
  final String? description;

  /// Optional short label shown above the milestone title.
  final String? label;

  /// Optional leading widget shown near the milestone marker.
  final Widget? leading;

  /// Optional trailing widget shown in the milestone card.
  final Widget? trailing;

  /// Optional footer shown below the milestone body.
  final Widget? footer;

  /// Optional custom content shown below the copy.
  final Widget? child;

  /// Creates a timeline entry definition.
  const AdaptiveTimelineEntry({
    required this.title,
    this.description,
    this.label,
    this.leading,
    this.trailing,
    this.footer,
    this.child,
  });
}

/// A milestone timeline that stacks on compact widths and becomes horizontal on
/// larger containers.
class AdaptiveTimeline extends StatelessWidget {
  /// Timeline entries shown by the widget.
  final List<AdaptiveTimelineEntry> entries;

  /// Semantic size at which the timeline should switch to horizontal mode.
  final AdaptiveSize horizontalAt;

  /// Minimum height class required before the horizontal mode is allowed.
  final AdaptiveHeight minimumHorizontalHeight;

  /// Whether to derive the active mode from parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should affect container-based breakpoint resolution.
  final bool considerOrientation;

  /// Width used by entries in horizontal mode.
  final double entryWidth;

  /// Space between entries.
  final double entrySpacing;

  /// Padding applied inside each milestone card.
  final EdgeInsetsGeometry cardPadding;

  /// Whether transitions should animate.
  final bool animateTransitions;

  /// Duration used by animations.
  final Duration transitionDuration;

  /// Curve used by animations.
  final Curve transitionCurve;

  /// Creates an adaptive timeline.
  const AdaptiveTimeline({
    super.key,
    required this.entries,
    this.horizontalAt = AdaptiveSize.medium,
    this.minimumHorizontalHeight = AdaptiveHeight.compact,
    this.useContainerConstraints = true,
    this.considerOrientation = false,
    this.entryWidth = 260,
    this.entrySpacing = 20,
    this.cardPadding = const EdgeInsets.all(16),
    this.animateTransitions = true,
    this.transitionDuration = const Duration(milliseconds: 250),
    this.transitionCurve = Curves.easeInOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
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
          AdaptiveTimelineMode.stacked => _StackedTimeline(
              entries: entries,
              entrySpacing: entrySpacing,
              cardPadding: cardPadding,
            ),
          AdaptiveTimelineMode.horizontal => LayoutBuilder(
              builder: (context, constraints) {
                final boundedHeight = constraints.maxHeight.isFinite
                    ? constraints.maxHeight
                    : null;

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var index = 0; index < entries.length; index++) ...[
                        SizedBox(
                          width: entryWidth,
                          height: boundedHeight,
                          child: _HorizontalTimelineEntry(
                            entry: entries[index],
                            cardPadding: cardPadding,
                            showConnectorAfter: index < entries.length - 1,
                            scrollBody: boundedHeight != null,
                            entrySpacing: entrySpacing,
                          ),
                        ),
                        if (index < entries.length - 1)
                          SizedBox(width: entrySpacing),
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

  AdaptiveTimelineMode _modeForData(BreakPointData data) {
    final isWideEnough = data.adaptiveSize.index >= horizontalAt.index;
    final isTallEnough =
        data.adaptiveHeight.index >= minimumHorizontalHeight.index;

    return isWideEnough && isTallEnough
        ? AdaptiveTimelineMode.horizontal
        : AdaptiveTimelineMode.stacked;
  }
}

class _StackedTimeline extends StatelessWidget {
  final List<AdaptiveTimelineEntry> entries;
  final double entrySpacing;
  final EdgeInsetsGeometry cardPadding;

  const _StackedTimeline({
    required this.entries,
    required this.entrySpacing,
    required this.cardPadding,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < entries.length; index++) ...[
            _StackedTimelineEntry(
              entry: entries[index],
              cardPadding: cardPadding,
              showConnectorAfter: index < entries.length - 1,
            ),
            if (index < entries.length - 1) SizedBox(height: entrySpacing),
          ],
        ],
      ),
    );
  }
}

class _StackedTimelineEntry extends StatelessWidget {
  final AdaptiveTimelineEntry entry;
  final EdgeInsetsGeometry cardPadding;
  final bool showConnectorAfter;

  const _StackedTimelineEntry({
    required this.entry,
    required this.cardPadding,
    required this.showConnectorAfter,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 28,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _TimelineMarker(leading: entry.leading),
              if (showConnectorAfter)
                Container(
                  width: 2,
                  height: 48,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  color: Theme.of(context).dividerColor,
                ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _TimelineCard(
            entry: entry,
            padding: cardPadding,
          ),
        ),
      ],
    );
  }
}

class _HorizontalTimelineEntry extends StatelessWidget {
  final AdaptiveTimelineEntry entry;
  final EdgeInsetsGeometry cardPadding;
  final bool showConnectorAfter;
  final bool scrollBody;
  final double entrySpacing;

  const _HorizontalTimelineEntry({
    required this.entry,
    required this.cardPadding,
    required this.showConnectorAfter,
    required this.scrollBody,
    required this.entrySpacing,
  });

  @override
  Widget build(BuildContext context) {
    final card = _TimelineCard(
      entry: entry,
      padding: cardPadding,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _TimelineMarker(leading: entry.leading),
            if (showConnectorAfter)
              Expanded(
                child: Container(
                  height: 2,
                  margin: EdgeInsets.only(left: 10, right: entrySpacing / 2),
                  color: Theme.of(context).dividerColor,
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (scrollBody)
          Expanded(
            child: SingleChildScrollView(
              child: card,
            ),
          )
        else
          card,
      ],
    );
  }
}

class _TimelineMarker extends StatelessWidget {
  final Widget? leading;

  const _TimelineMarker({
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: SizedBox(
        width: 20,
        height: 20,
        child: leading == null
            ? null
            : IconTheme(
                data: const IconThemeData(
                  size: 12,
                  color: Colors.white,
                ),
                child: Center(child: leading),
              ),
      ),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  final AdaptiveTimelineEntry entry;
  final EdgeInsetsGeometry padding;

  const _TimelineCard({
    required this.entry,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (entry.label != null) ...[
                        Text(
                          entry.label!,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 6),
                      ],
                      Text(
                        entry.title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                    ],
                  ),
                ),
                if (entry.trailing != null) ...[
                  const SizedBox(width: 12),
                  entry.trailing!,
                ],
              ],
            ),
            if (entry.description != null) ...[
              const SizedBox(height: 10),
              Text(
                entry.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            if (entry.child != null) ...[
              const SizedBox(height: 14),
              entry.child!,
            ],
            if (entry.footer != null) ...[
              const SizedBox(height: 14),
              entry.footer!,
            ],
          ],
        ),
      ),
    );
  }
}
