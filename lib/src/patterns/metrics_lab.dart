import 'package:flutter/material.dart';

import 'incident_desk.dart';
import '../media_query.dart';

/// A staged analytics workspace that coordinates a query list, a main focus
/// surface, an annotations panel, and a query history panel from one adaptive
/// model.
class AdaptiveMetricsLab<T> extends StatelessWidget {
  /// Queries or metric definitions shown in the list.
  final List<T> queries;

  /// Builds an individual query row.
  final Widget Function(
    BuildContext context,
    T query,
    bool selected,
    VoidCallback onTap,
  ) itemBuilder;

  /// Builds the active metric focus surface for the selected query.
  final Widget Function(BuildContext context, T query) focusBuilder;

  /// Builds the annotations panel for the selected query.
  final Widget Function(BuildContext context, T query) annotationsBuilder;

  /// Builds the query history panel for the selected query.
  final Widget Function(BuildContext context, T query) historyBuilder;

  /// Optional header shown above the active focus surface.
  final Widget? header;

  /// Optional empty state shown when [queries] is empty.
  final Widget? emptyState;

  /// Title shown above the query list.
  final String queryTitle;

  /// Optional description shown below [queryTitle].
  final String? queryDescription;

  /// Optional leading widget shown beside [queryTitle].
  final Widget? queryLeading;

  /// Title shown above the annotations panel.
  final String annotationsTitle;

  /// Optional description shown below [annotationsTitle].
  final String? annotationsDescription;

  /// Optional leading widget shown beside [annotationsTitle].
  final Widget? annotationsLeading;

  /// Title shown above the query history panel.
  final String historyTitle;

  /// Optional description shown below [historyTitle].
  final String? historyDescription;

  /// Optional leading widget shown beside [historyTitle].
  final Widget? historyLeading;

  /// Label used by the compact query-list trigger.
  final String modalQueryLabel;

  /// Icon used by the compact query-list trigger.
  final Widget modalQueryIcon;

  /// Label used by the compact annotations trigger.
  final String modalAnnotationsLabel;

  /// Icon used by the compact annotations trigger.
  final Widget modalAnnotationsIcon;

  /// Label used by the compact history trigger.
  final String modalHistoryLabel;

  /// Icon used by the compact history trigger.
  final Widget modalHistoryIcon;

  /// Semantic size at which the query list should dock inline.
  final AdaptiveSize queryDockedAt;

  /// Semantic size at which the annotations panel should dock inline.
  final AdaptiveSize annotationsDockedAt;

  /// Semantic size at which the history panel should dock inline.
  final AdaptiveSize historyDockedAt;

  /// Minimum height class required before the query list can dock inline.
  final AdaptiveHeight minimumQueryDockedHeight;

  /// Minimum height class required before annotations can dock inline.
  final AdaptiveHeight minimumAnnotationsDockedHeight;

  /// Minimum height class required before history can dock inline.
  final AdaptiveHeight minimumHistoryDockedHeight;

  /// Whether to derive layout decisions from parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should influence container-based breakpoint selection.
  final bool considerOrientation;

  /// Optional controlled selected query index.
  final int? selectedIndex;

  /// Initial selected query index for uncontrolled usage.
  final int initialIndex;

  /// Called when the selected query changes.
  final ValueChanged<int>? onSelectedIndexChanged;

  /// Space between adjacent regions.
  final double spacing;

  /// Space between adjacent query rows.
  final double itemSpacing;

  /// Flex used by the docked query-list region.
  final int queryFlex;

  /// Flex used by the focus region.
  final int focusFlex;

  /// Flex used by the docked annotations region.
  final int annotationsFlex;

  /// Flex used by the focus surface when history is docked below it.
  final int focusPaneFlex;

  /// Flex used by the docked history region.
  final int historyFlex;

  /// Padding applied inside the query list surface.
  final EdgeInsetsGeometry queryPadding;

  /// Padding applied inside the focus surface.
  final EdgeInsetsGeometry focusPadding;

  /// Padding applied inside the annotations surface.
  final EdgeInsetsGeometry annotationsPadding;

  /// Padding applied inside the history surface.
  final EdgeInsetsGeometry historyPadding;

  /// Height factor used by compact modal sheets.
  final double modalHeightFactor;

  /// Whether to show a drag handle in compact modal sheets.
  final bool showModalDragHandle;

  /// Whether to animate size changes when the mode changes.
  final bool animateSize;

  /// Duration used by [AnimatedSize] and [AnimatedSwitcher].
  final Duration animationDuration;

  /// Curve used by [AnimatedSize] and [AnimatedSwitcher].
  final Curve animationCurve;

  /// Creates an adaptive metrics lab.
  const AdaptiveMetricsLab({
    super.key,
    required this.queries,
    required this.itemBuilder,
    required this.focusBuilder,
    required this.annotationsBuilder,
    required this.historyBuilder,
    required this.queryTitle,
    required this.annotationsTitle,
    required this.historyTitle,
    this.header,
    this.emptyState,
    this.queryDescription,
    this.queryLeading,
    this.annotationsDescription,
    this.annotationsLeading,
    this.historyDescription,
    this.historyLeading,
    this.modalQueryLabel = 'Open queries',
    this.modalQueryIcon = const Icon(Icons.query_stats_outlined),
    this.modalAnnotationsLabel = 'Open annotations',
    this.modalAnnotationsIcon = const Icon(Icons.draw_outlined),
    this.modalHistoryLabel = 'Open history',
    this.modalHistoryIcon = const Icon(Icons.history_outlined),
    this.queryDockedAt = AdaptiveSize.medium,
    this.annotationsDockedAt = AdaptiveSize.expanded,
    this.historyDockedAt = AdaptiveSize.expanded,
    this.minimumQueryDockedHeight = AdaptiveHeight.compact,
    this.minimumAnnotationsDockedHeight = AdaptiveHeight.medium,
    this.minimumHistoryDockedHeight = AdaptiveHeight.expanded,
    this.useContainerConstraints = true,
    this.considerOrientation = false,
    this.selectedIndex,
    this.initialIndex = 0,
    this.onSelectedIndexChanged,
    this.spacing = 16,
    this.itemSpacing = 12,
    this.queryFlex = 2,
    this.focusFlex = 4,
    this.annotationsFlex = 2,
    this.focusPaneFlex = 3,
    this.historyFlex = 2,
    this.queryPadding = const EdgeInsets.all(16),
    this.focusPadding = const EdgeInsets.all(16),
    this.annotationsPadding = const EdgeInsets.all(16),
    this.historyPadding = const EdgeInsets.all(16),
    this.modalHeightFactor = 0.72,
    this.showModalDragHandle = true,
    this.animateSize = true,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeInOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveIncidentDesk<T>(
      incidents: queries,
      itemBuilder: itemBuilder,
      detailBuilder: focusBuilder,
      contextBuilder: annotationsBuilder,
      timelineBuilder: historyBuilder,
      header: header,
      emptyState: emptyState,
      listTitle: queryTitle,
      listDescription: queryDescription,
      listLeading: queryLeading,
      contextTitle: annotationsTitle,
      contextDescription: annotationsDescription,
      contextLeading: annotationsLeading,
      timelineTitle: historyTitle,
      timelineDescription: historyDescription,
      timelineLeading: historyLeading,
      modalListLabel: modalQueryLabel,
      modalListIcon: modalQueryIcon,
      modalContextLabel: modalAnnotationsLabel,
      modalContextIcon: modalAnnotationsIcon,
      modalTimelineLabel: modalHistoryLabel,
      modalTimelineIcon: modalHistoryIcon,
      listDockedAt: queryDockedAt,
      contextDockedAt: annotationsDockedAt,
      timelineDockedAt: historyDockedAt,
      minimumListDockedHeight: minimumQueryDockedHeight,
      minimumContextDockedHeight: minimumAnnotationsDockedHeight,
      minimumTimelineDockedHeight: minimumHistoryDockedHeight,
      useContainerConstraints: useContainerConstraints,
      considerOrientation: considerOrientation,
      selectedIndex: selectedIndex,
      initialIndex: initialIndex,
      onSelectedIndexChanged: onSelectedIndexChanged,
      spacing: spacing,
      itemSpacing: itemSpacing,
      listFlex: queryFlex,
      detailFlex: focusFlex,
      contextFlex: annotationsFlex,
      detailPaneFlex: focusPaneFlex,
      timelineFlex: historyFlex,
      listPadding: queryPadding,
      detailPadding: focusPadding,
      contextPadding: annotationsPadding,
      timelinePadding: historyPadding,
      modalHeightFactor: modalHeightFactor,
      showModalDragHandle: showModalDragHandle,
      animateSize: animateSize,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
    );
  }
}
