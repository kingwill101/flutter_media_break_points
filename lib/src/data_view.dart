import 'package:flutter/material.dart';

import 'container_layout.dart';
import 'media_query.dart';

/// The active arrangement used by [AdaptiveDataView].
enum AdaptiveDataViewMode {
  cards,
  table,
}

/// A column definition used by [AdaptiveDataView].
class AdaptiveDataColumn<T> {
  /// Label shown in the table header and compact details.
  final String label;

  /// Builds the cell content for a record.
  final Widget Function(BuildContext context, T record) cellBuilder;

  /// Whether the column should right-align like numeric table data.
  final bool numeric;

  /// Whether the column should appear in compact card mode.
  final bool showInCompact;

  /// Optional tooltip shown by the table header.
  final String? tooltip;

  /// Creates a data column definition.
  const AdaptiveDataColumn({
    required this.label,
    required this.cellBuilder,
    this.numeric = false,
    this.showInCompact = true,
    this.tooltip,
  });
}

/// A responsive records surface that switches between cards and a table.
///
/// Compact containers render stacked cards. Medium and expanded containers
/// render a horizontally scrollable [DataTable].
class AdaptiveDataView<T> extends StatelessWidget {
  /// Records rendered by the view.
  final List<T> records;

  /// Columns rendered in table mode and optionally in compact mode.
  final List<AdaptiveDataColumn<T>> columns;

  /// Semantic size at which the view should switch to table mode.
  final AdaptiveSize tableAt;

  /// Minimum height class required before the table can appear.
  final AdaptiveHeight minimumTableHeight;

  /// Whether to derive the active mode from parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should affect container-based breakpoint resolution.
  final bool considerOrientation;

  /// Builder used for the compact card title.
  final Widget Function(BuildContext context, T record)? compactTitleBuilder;

  /// Builder used for compact card subtitle content.
  final Widget Function(BuildContext context, T record)? compactSubtitleBuilder;

  /// Builder used for compact card leading content.
  final Widget Function(BuildContext context, T record)? compactLeadingBuilder;

  /// Builder used for compact card trailing content.
  final Widget Function(BuildContext context, T record)? compactTrailingBuilder;

  /// Optional empty state shown when [records] is empty.
  final Widget? emptyState;

  /// Called when a record is tapped or selected.
  final ValueChanged<T>? onRecordTap;

  /// Optional selected record index.
  final int? selectedIndex;

  /// Space between compact cards.
  final double cardSpacing;

  /// Padding inside compact cards.
  final EdgeInsetsGeometry cardPadding;

  /// Table column spacing.
  final double columnSpacing;

  /// Table horizontal margin.
  final double horizontalMargin;

  /// Table heading row height.
  final double headingRowHeight;

  /// Table minimum data row height.
  final double dataRowMinHeight;

  /// Table maximum data row height.
  final double dataRowMaxHeight;

  /// Whether the table should show a checkbox column for selection.
  final bool showCheckboxColumn;

  /// Whether transitions should animate.
  final bool animateTransitions;

  /// Duration used by animated transitions.
  final Duration transitionDuration;

  /// Curve used by animated transitions.
  final Curve transitionCurve;

  /// Creates an adaptive data view.
  const AdaptiveDataView({
    super.key,
    required this.records,
    required this.columns,
    this.tableAt = AdaptiveSize.medium,
    this.minimumTableHeight = AdaptiveHeight.compact,
    this.useContainerConstraints = true,
    this.considerOrientation = false,
    this.compactTitleBuilder,
    this.compactSubtitleBuilder,
    this.compactLeadingBuilder,
    this.compactTrailingBuilder,
    this.emptyState,
    this.onRecordTap,
    this.selectedIndex,
    this.cardSpacing = 12,
    this.cardPadding = const EdgeInsets.all(16),
    this.columnSpacing = 24,
    this.horizontalMargin = 24,
    this.headingRowHeight = 56,
    this.dataRowMinHeight = 52,
    this.dataRowMaxHeight = 72,
    this.showCheckboxColumn = false,
    this.animateTransitions = true,
    this.transitionDuration = const Duration(milliseconds: 250),
    this.transitionCurve = Curves.easeInOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return emptyState ?? const _AdaptiveDataViewEmptyState();
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
          AdaptiveDataViewMode.cards => _CompactDataCards<T>(
              records: records,
              columns: columns,
              cardSpacing: cardSpacing,
              cardPadding: cardPadding,
              compactTitleBuilder: compactTitleBuilder,
              compactSubtitleBuilder: compactSubtitleBuilder,
              compactLeadingBuilder: compactLeadingBuilder,
              compactTrailingBuilder: compactTrailingBuilder,
              onRecordTap: onRecordTap,
              selectedIndex: selectedIndex,
            ),
          AdaptiveDataViewMode.table => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                showCheckboxColumn: showCheckboxColumn,
                columnSpacing: columnSpacing,
                horizontalMargin: horizontalMargin,
                headingRowHeight: headingRowHeight,
                dataRowMinHeight: dataRowMinHeight,
                dataRowMaxHeight: dataRowMaxHeight,
                columns: [
                  for (final column in columns)
                    DataColumn(
                      label: Text(column.label),
                      tooltip: column.tooltip,
                      numeric: column.numeric,
                    ),
                ],
                rows: [
                  for (var index = 0; index < records.length; index++)
                    DataRow.byIndex(
                      index: index,
                      selected: selectedIndex == index,
                      onSelectChanged: onRecordTap == null
                          ? null
                          : (_) => onRecordTap!(records[index]),
                      cells: [
                        for (final column in columns)
                          DataCell(
                            column.cellBuilder(context, records[index]),
                          ),
                      ],
                    ),
                ],
              ),
            ),
        },
      ),
    );
  }

  AdaptiveDataViewMode _modeForData(BreakPointData data) {
    final isWideEnough = data.adaptiveSize.index >= tableAt.index;
    final isTallEnough = data.adaptiveHeight.index >= minimumTableHeight.index;

    return isWideEnough && isTallEnough
        ? AdaptiveDataViewMode.table
        : AdaptiveDataViewMode.cards;
  }
}

class _CompactDataCards<T> extends StatelessWidget {
  final List<T> records;
  final List<AdaptiveDataColumn<T>> columns;
  final double cardSpacing;
  final EdgeInsetsGeometry cardPadding;
  final Widget Function(BuildContext context, T record)? compactTitleBuilder;
  final Widget Function(BuildContext context, T record)? compactSubtitleBuilder;
  final Widget Function(BuildContext context, T record)? compactLeadingBuilder;
  final Widget Function(BuildContext context, T record)? compactTrailingBuilder;
  final ValueChanged<T>? onRecordTap;
  final int? selectedIndex;

  const _CompactDataCards({
    required this.records,
    required this.columns,
    required this.cardSpacing,
    required this.cardPadding,
    required this.compactTitleBuilder,
    required this.compactSubtitleBuilder,
    required this.compactLeadingBuilder,
    required this.compactTrailingBuilder,
    required this.onRecordTap,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (var index = 0; index < records.length; index++) ...[
            _CompactDataCard<T>(
              record: records[index],
              columns: columns,
              padding: cardPadding,
              selected: selectedIndex == index,
              titleBuilder: compactTitleBuilder,
              subtitleBuilder: compactSubtitleBuilder,
              leadingBuilder: compactLeadingBuilder,
              trailingBuilder: compactTrailingBuilder,
              onTap: onRecordTap == null
                  ? null
                  : () => onRecordTap!(records[index]),
            ),
            if (index < records.length - 1) SizedBox(height: cardSpacing),
          ],
        ],
      ),
    );
  }
}

class _CompactDataCard<T> extends StatelessWidget {
  final T record;
  final List<AdaptiveDataColumn<T>> columns;
  final EdgeInsetsGeometry padding;
  final bool selected;
  final Widget Function(BuildContext context, T record)? titleBuilder;
  final Widget Function(BuildContext context, T record)? subtitleBuilder;
  final Widget Function(BuildContext context, T record)? leadingBuilder;
  final Widget Function(BuildContext context, T record)? trailingBuilder;
  final VoidCallback? onTap;

  const _CompactDataCard({
    required this.record,
    required this.columns,
    required this.padding,
    required this.selected,
    required this.titleBuilder,
    required this.subtitleBuilder,
    required this.leadingBuilder,
    required this.trailingBuilder,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final visibleColumns =
        columns.where((column) => column.showInCompact).toList();
    final title = titleBuilder?.call(context, record);
    final subtitle = subtitleBuilder?.call(context, record);
    final leading = leadingBuilder?.call(context, record);
    final trailing = trailingBuilder?.call(context, record);
    final hasHeader = title != null ||
        subtitle != null ||
        leading != null ||
        trailing != null;

    final color =
        selected ? Theme.of(context).colorScheme.primaryContainer : null;

    return Card(
      color: color,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasHeader)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (leading != null) ...[
                      leading,
                      const SizedBox(width: 12),
                    ],
                    if (title != null || subtitle != null)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (title != null) title,
                            if (subtitle != null) ...[
                              const SizedBox(height: 6),
                              subtitle,
                            ],
                          ],
                        ),
                      ),
                    if (trailing != null) ...[
                      if (title != null || subtitle != null)
                        const SizedBox(width: 12),
                      trailing,
                    ],
                  ],
                ),
              if (hasHeader && visibleColumns.isNotEmpty)
                const SizedBox(height: 16),
              for (var index = 0; index < visibleColumns.length; index++) ...[
                _CompactDataField<T>(
                  record: record,
                  column: visibleColumns[index],
                ),
                if (index < visibleColumns.length - 1)
                  const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CompactDataField<T> extends StatelessWidget {
  final T record;
  final AdaptiveDataColumn<T> column;

  const _CompactDataField({
    required this.record,
    required this.column,
  });

  @override
  Widget build(BuildContext context) {
    final alignment =
        column.numeric ? Alignment.centerRight : Alignment.centerLeft;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            column.label,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Align(
            alignment: alignment,
            child: column.cellBuilder(context, record),
          ),
        ),
      ],
    );
  }
}

class _AdaptiveDataViewEmptyState extends StatelessWidget {
  const _AdaptiveDataViewEmptyState();

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          'No records available.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
