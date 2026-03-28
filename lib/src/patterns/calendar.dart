import 'package:flutter/material.dart';

import '../container_layout.dart';
import '../media_query.dart';

/// The active arrangement used by [AdaptiveCalendar].
enum AdaptiveCalendarMode {
  agenda,
  grid,
}

/// A single day shown by [AdaptiveCalendar].
class AdaptiveCalendarDay {
  /// Day label shown in the day header.
  final String label;

  /// Optional supporting copy shown below [label].
  final String? subtitle;

  /// Optional leading widget shown in the day header.
  final Widget? leading;

  /// Optional trailing widget shown in the day header.
  final Widget? trailing;

  /// Events or blocks shown inside the day.
  final List<Widget> entries;

  /// Whether the day should be visually emphasized.
  final bool highlight;

  /// Optional footer shown below the entries.
  final Widget? footer;

  /// Optional empty state shown when [entries] is empty.
  final Widget? emptyState;

  /// Creates a calendar day definition.
  const AdaptiveCalendarDay({
    required this.label,
    required this.entries,
    this.subtitle,
    this.leading,
    this.trailing,
    this.highlight = false,
    this.footer,
    this.emptyState,
  });
}

/// A calendar surface that shows a stacked agenda on compact layouts and a
/// multi-column day grid on larger containers.
class AdaptiveCalendar extends StatelessWidget {
  /// Days shown by the calendar.
  final List<AdaptiveCalendarDay> days;

  /// Semantic size at which the view should switch to grid mode.
  final AdaptiveSize gridAt;

  /// Minimum height class required before the view can switch to grid mode.
  final AdaptiveHeight minimumGridHeight;

  /// Whether to derive the active mode from parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should influence container-based breakpoint selection.
  final bool considerOrientation;

  /// Number of day columns shown in grid mode.
  final int gridColumns;

  /// Minimum width used by each grid day.
  final double minDayWidth;

  /// Space between days.
  final double daySpacing;

  /// Space between entries inside a day.
  final double entrySpacing;

  /// Padding applied inside each day surface.
  final EdgeInsetsGeometry dayPadding;

  /// Whether transitions should animate.
  final bool animateTransitions;

  /// Duration used by animations.
  final Duration transitionDuration;

  /// Curve used by animations.
  final Curve transitionCurve;

  /// Creates an adaptive calendar.
  const AdaptiveCalendar({
    super.key,
    required this.days,
    this.gridAt = AdaptiveSize.medium,
    this.minimumGridHeight = AdaptiveHeight.compact,
    this.useContainerConstraints = true,
    this.considerOrientation = false,
    this.gridColumns = 7,
    this.minDayWidth = 170,
    this.daySpacing = 12,
    this.entrySpacing = 10,
    this.dayPadding = const EdgeInsets.all(14),
    this.animateTransitions = true,
    this.transitionDuration = const Duration(milliseconds: 250),
    this.transitionCurve = Curves.easeInOutCubic,
  }) : assert(gridColumns > 0, 'gridColumns must be greater than zero.');

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) {
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
          AdaptiveCalendarMode.agenda => _CalendarAgenda(
              days: days,
              daySpacing: daySpacing,
              entrySpacing: entrySpacing,
              dayPadding: dayPadding,
            ),
          AdaptiveCalendarMode.grid => LayoutBuilder(
              builder: (context, constraints) {
                final availableWidth = constraints.maxWidth.isFinite
                    ? constraints.maxWidth
                    : (gridColumns * minDayWidth) +
                        (daySpacing * (gridColumns - 1));
                final candidateWidth =
                    (availableWidth - (daySpacing * (gridColumns - 1))) /
                        gridColumns;
                final canFitWithoutScroll = constraints.maxWidth.isFinite &&
                    candidateWidth >= minDayWidth;
                final cellWidth =
                    canFitWithoutScroll ? candidateWidth : minDayWidth;
                final rowWidth = (gridColumns * cellWidth) +
                    (daySpacing * (gridColumns - 1));

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: rowWidth,
                      child: Wrap(
                        spacing: daySpacing,
                        runSpacing: daySpacing,
                        children: [
                          for (final day in days)
                            SizedBox(
                              width: cellWidth,
                              child: _CalendarDayCard(
                                day: day,
                                entrySpacing: entrySpacing,
                                padding: dayPadding,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        },
      ),
    );
  }

  AdaptiveCalendarMode _modeForData(BreakPointData data) {
    final isWideEnough = data.adaptiveSize.index >= gridAt.index;
    final isTallEnough = data.adaptiveHeight.index >= minimumGridHeight.index;

    return isWideEnough && isTallEnough
        ? AdaptiveCalendarMode.grid
        : AdaptiveCalendarMode.agenda;
  }
}

class _CalendarAgenda extends StatelessWidget {
  final List<AdaptiveCalendarDay> days;
  final double daySpacing;
  final double entrySpacing;
  final EdgeInsetsGeometry dayPadding;

  const _CalendarAgenda({
    required this.days,
    required this.daySpacing,
    required this.entrySpacing,
    required this.dayPadding,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < days.length; index++) ...[
            _CalendarDayCard(
              day: days[index],
              entrySpacing: entrySpacing,
              padding: dayPadding,
            ),
            if (index < days.length - 1) SizedBox(height: daySpacing),
          ],
        ],
      ),
    );
  }
}

class _CalendarDayCard extends StatelessWidget {
  final AdaptiveCalendarDay day;
  final double entrySpacing;
  final EdgeInsetsGeometry padding;

  const _CalendarDayCard({
    required this.day,
    required this.entrySpacing,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = day.highlight
        ? Theme.of(context).colorScheme.primary
        : Colors.transparent;

    final entries = day.entries.isEmpty
        ? [day.emptyState ?? const _DefaultCalendarEmptyState()]
        : day.entries;

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor, width: day.highlight ? 1.5 : 0),
      ),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (day.leading != null) ...[
                  day.leading!,
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        day.label,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      if (day.subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          day.subtitle!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
                if (day.trailing != null) ...[
                  const SizedBox(width: 12),
                  day.trailing!,
                ],
              ],
            ),
            const SizedBox(height: 14),
            for (var index = 0; index < entries.length; index++) ...[
              entries[index],
              if (index < entries.length - 1) SizedBox(height: entrySpacing),
            ],
            if (day.footer != null) ...[
              SizedBox(height: entrySpacing),
              day.footer!,
            ],
          ],
        ),
      ),
    );
  }
}

class _DefaultCalendarEmptyState extends StatelessWidget {
  const _DefaultCalendarEmptyState();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          'No events scheduled.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
