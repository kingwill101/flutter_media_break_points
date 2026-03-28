import 'package:flutter/material.dart';

import '../container_layout.dart';
import '../media_query.dart';

/// The active arrangement used by [AdaptiveSchedule].
enum AdaptiveScheduleMode {
  agenda,
  columns,
}

/// A single scheduled item shown inside an [AdaptiveScheduleDay].
class AdaptiveScheduleEntry {
  /// Time label shown beside or above the entry content.
  final String timeLabel;

  /// Entry title.
  final String title;

  /// Optional supporting copy shown below [title].
  final String? description;

  /// Optional leading widget shown with the entry.
  final Widget? leading;

  /// Optional trailing widget shown with the entry.
  final Widget? trailing;

  /// Optional custom content shown below the copy.
  final Widget? child;

  /// Optional footer shown below [child].
  final Widget? footer;

  /// Creates a schedule entry definition.
  const AdaptiveScheduleEntry({
    required this.timeLabel,
    required this.title,
    this.description,
    this.leading,
    this.trailing,
    this.child,
    this.footer,
  });
}

/// A day or lane within [AdaptiveSchedule].
class AdaptiveScheduleDay {
  /// Day label shown in the day header.
  final String label;

  /// Optional supporting copy shown below [label].
  final String? description;

  /// Scheduled items for this day.
  final List<AdaptiveScheduleEntry> entries;

  /// Optional leading widget shown in the day header.
  final Widget? leading;

  /// Optional trailing widget shown in the day header.
  final Widget? trailing;

  /// Optional footer shown below all entries.
  final Widget? footer;

  /// Optional empty state shown when [entries] is empty.
  final Widget? emptyState;

  /// Creates a schedule day definition.
  const AdaptiveScheduleDay({
    required this.label,
    required this.entries,
    this.description,
    this.leading,
    this.trailing,
    this.footer,
    this.emptyState,
  });
}

/// A day-grouped schedule that shows a stacked agenda on compact layouts and
/// side-by-side day columns on larger containers.
class AdaptiveSchedule extends StatelessWidget {
  /// Days shown by the schedule.
  final List<AdaptiveScheduleDay> days;

  /// Semantic size at which the view should switch to column mode.
  final AdaptiveSize columnsAt;

  /// Minimum height class required before the view can switch to column mode.
  final AdaptiveHeight minimumColumnsHeight;

  /// Whether to derive the active mode from parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should influence container-based breakpoint selection.
  final bool considerOrientation;

  /// Width of each day column in wide mode.
  final double dayWidth;

  /// Space between adjacent day surfaces.
  final double daySpacing;

  /// Space between adjacent entries inside a day.
  final double entrySpacing;

  /// Padding applied inside each day surface.
  final EdgeInsetsGeometry dayPadding;

  /// Whether transitions should animate.
  final bool animateTransitions;

  /// Duration used by animations.
  final Duration transitionDuration;

  /// Curve used by animations.
  final Curve transitionCurve;

  /// Creates an adaptive schedule.
  const AdaptiveSchedule({
    super.key,
    required this.days,
    this.columnsAt = AdaptiveSize.medium,
    this.minimumColumnsHeight = AdaptiveHeight.compact,
    this.useContainerConstraints = true,
    this.considerOrientation = false,
    this.dayWidth = 300,
    this.daySpacing = 16,
    this.entrySpacing = 12,
    this.dayPadding = const EdgeInsets.all(16),
    this.animateTransitions = true,
    this.transitionDuration = const Duration(milliseconds: 250),
    this.transitionCurve = Curves.easeInOutCubic,
  });

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
          AdaptiveScheduleMode.agenda => _AgendaScheduleLayout(
              days: days,
              daySpacing: daySpacing,
              entrySpacing: entrySpacing,
              dayPadding: dayPadding,
            ),
          AdaptiveScheduleMode.columns => LayoutBuilder(
              builder: (context, constraints) {
                final availableWidth = constraints.maxWidth.isFinite
                    ? constraints.maxWidth
                    : days.length * dayWidth;
                final totalSpacing = daySpacing * (days.length - 1);
                final evenWidth = (availableWidth - totalSpacing) / days.length;
                final canFitWithoutScroll =
                    constraints.maxWidth.isFinite && evenWidth >= dayWidth;
                final boundedHeight = constraints.maxHeight.isFinite
                    ? constraints.maxHeight
                    : null;

                return canFitWithoutScroll
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var index = 0; index < days.length; index++) ...[
                            Expanded(
                              child: SizedBox(
                                height: boundedHeight,
                                child: _ScheduleDayCard(
                                  day: days[index],
                                  entrySpacing: entrySpacing,
                                  padding: dayPadding,
                                  scrollEntries: boundedHeight != null,
                                ),
                              ),
                            ),
                            if (index < days.length - 1)
                              SizedBox(width: daySpacing),
                          ],
                        ],
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var index = 0;
                                index < days.length;
                                index++) ...[
                              SizedBox(
                                width: dayWidth,
                                height: boundedHeight,
                                child: _ScheduleDayCard(
                                  day: days[index],
                                  entrySpacing: entrySpacing,
                                  padding: dayPadding,
                                  scrollEntries: boundedHeight != null,
                                ),
                              ),
                              if (index < days.length - 1)
                                SizedBox(width: daySpacing),
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

  AdaptiveScheduleMode _modeForData(BreakPointData data) {
    final isWideEnough = data.adaptiveSize.index >= columnsAt.index;
    final isTallEnough =
        data.adaptiveHeight.index >= minimumColumnsHeight.index;

    return isWideEnough && isTallEnough
        ? AdaptiveScheduleMode.columns
        : AdaptiveScheduleMode.agenda;
  }
}

class _AgendaScheduleLayout extends StatelessWidget {
  final List<AdaptiveScheduleDay> days;
  final double daySpacing;
  final double entrySpacing;
  final EdgeInsetsGeometry dayPadding;

  const _AgendaScheduleLayout({
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
            _ScheduleDayCard(
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

class _ScheduleDayCard extends StatelessWidget {
  final AdaptiveScheduleDay day;
  final double entrySpacing;
  final EdgeInsetsGeometry padding;
  final bool scrollEntries;

  const _ScheduleDayCard({
    required this.day,
    required this.entrySpacing,
    required this.padding,
    this.scrollEntries = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = _ScheduleDayBody(
      day: day,
      entrySpacing: entrySpacing,
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ScheduleDayHeader(day: day),
            const SizedBox(height: 16),
            if (scrollEntries)
              Expanded(
                child: SingleChildScrollView(
                  child: content,
                ),
              )
            else
              content,
          ],
        ),
      ),
    );
  }
}

class _ScheduleDayHeader extends StatelessWidget {
  final AdaptiveScheduleDay day;

  const _ScheduleDayHeader({
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              if (day.description != null) ...[
                const SizedBox(height: 4),
                Text(
                  day.description!,
                  style: Theme.of(context).textTheme.bodyMedium,
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
    );
  }
}

class _ScheduleDayBody extends StatelessWidget {
  final AdaptiveScheduleDay day;
  final double entrySpacing;

  const _ScheduleDayBody({
    required this.day,
    required this.entrySpacing,
  });

  @override
  Widget build(BuildContext context) {
    final entries = day.entries.isEmpty
        ? [day.emptyState ?? const _DefaultScheduleEmptyState()]
        : [
            for (final entry in day.entries) _ScheduleEntryCard(entry: entry),
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < entries.length; index++) ...[
          entries[index],
          if (index < entries.length - 1) SizedBox(height: entrySpacing),
        ],
        if (day.footer != null) ...[
          SizedBox(height: entrySpacing),
          day.footer!,
        ],
      ],
    );
  }
}

class _ScheduleEntryCard extends StatelessWidget {
  final AdaptiveScheduleEntry entry;

  const _ScheduleEntryCard({
    required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surfaceContainerHighest;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.timeLabel,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (entry.leading != null) ...[
                  entry.leading!,
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      if (entry.description != null) ...[
                        const SizedBox(height: 6),
                        Text(entry.description!),
                      ],
                    ],
                  ),
                ),
                if (entry.trailing != null) ...[
                  const SizedBox(width: 12),
                  entry.trailing!,
                ],
              ],
            ),
            if (entry.child != null) ...[
              const SizedBox(height: 12),
              entry.child!,
            ],
            if (entry.footer != null) ...[
              const SizedBox(height: 12),
              entry.footer!,
            ],
          ],
        ),
      ),
    );
  }
}

class _DefaultScheduleEmptyState extends StatelessWidget {
  const _DefaultScheduleEmptyState();

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
          'No scheduled items yet.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
