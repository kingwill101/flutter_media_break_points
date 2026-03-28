import 'package:flutter/material.dart';

import 'incident_desk.dart';
import '../media_query.dart';

/// A staged approval workspace that coordinates an approval list, an active
/// proposal surface, a criteria panel, and a decision history panel from one
/// adaptive model.
class AdaptiveApprovalDesk<T> extends StatelessWidget {
  /// Approval items shown in the list.
  final List<T> approvals;

  /// Builds an individual approval row.
  final Widget Function(
    BuildContext context,
    T approval,
    bool selected,
    VoidCallback onTap,
  ) itemBuilder;

  /// Builds the active proposal surface for the selected approval item.
  final Widget Function(BuildContext context, T approval) proposalBuilder;

  /// Builds the criteria panel for the selected approval item.
  final Widget Function(BuildContext context, T approval) criteriaBuilder;

  /// Builds the decision history panel for the selected approval item.
  final Widget Function(BuildContext context, T approval) historyBuilder;

  /// Optional header shown above the active proposal surface.
  final Widget? header;

  /// Optional empty state shown when [approvals] is empty.
  final Widget? emptyState;

  /// Title shown above the approval list.
  final String approvalTitle;

  /// Optional description shown below [approvalTitle].
  final String? approvalDescription;

  /// Optional leading widget shown beside [approvalTitle].
  final Widget? approvalLeading;

  /// Title shown above the criteria panel.
  final String criteriaTitle;

  /// Optional description shown below [criteriaTitle].
  final String? criteriaDescription;

  /// Optional leading widget shown beside [criteriaTitle].
  final Widget? criteriaLeading;

  /// Title shown above the history panel.
  final String historyTitle;

  /// Optional description shown below [historyTitle].
  final String? historyDescription;

  /// Optional leading widget shown beside [historyTitle].
  final Widget? historyLeading;

  /// Label used by the compact approval-list trigger.
  final String modalApprovalLabel;

  /// Icon used by the compact approval-list trigger.
  final Widget modalApprovalIcon;

  /// Label used by the compact criteria trigger.
  final String modalCriteriaLabel;

  /// Icon used by the compact criteria trigger.
  final Widget modalCriteriaIcon;

  /// Label used by the compact history trigger.
  final String modalHistoryLabel;

  /// Icon used by the compact history trigger.
  final Widget modalHistoryIcon;

  /// Semantic size at which the approval list should dock inline.
  final AdaptiveSize approvalDockedAt;

  /// Semantic size at which the criteria panel should dock inline.
  final AdaptiveSize criteriaDockedAt;

  /// Semantic size at which the history panel should dock inline.
  final AdaptiveSize historyDockedAt;

  /// Minimum height class required before the approval list can dock inline.
  final AdaptiveHeight minimumApprovalDockedHeight;

  /// Minimum height class required before criteria can dock inline.
  final AdaptiveHeight minimumCriteriaDockedHeight;

  /// Minimum height class required before history can dock inline.
  final AdaptiveHeight minimumHistoryDockedHeight;

  /// Whether to derive layout decisions from parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should influence container-based breakpoint selection.
  final bool considerOrientation;

  /// Optional controlled selected approval index.
  final int? selectedIndex;

  /// Initial selected approval index for uncontrolled usage.
  final int initialIndex;

  /// Called when the selected approval changes.
  final ValueChanged<int>? onSelectedIndexChanged;

  /// Space between adjacent regions.
  final double spacing;

  /// Space between adjacent approval rows.
  final double itemSpacing;

  /// Flex used by the docked approval-list region.
  final int approvalFlex;

  /// Flex used by the proposal region.
  final int proposalFlex;

  /// Flex used by the docked criteria region.
  final int criteriaFlex;

  /// Flex used by the proposal surface when history is docked below it.
  final int proposalPaneFlex;

  /// Flex used by the docked history region.
  final int historyFlex;

  /// Padding applied inside the approval list surface.
  final EdgeInsetsGeometry approvalPadding;

  /// Padding applied inside the proposal surface.
  final EdgeInsetsGeometry proposalPadding;

  /// Padding applied inside the criteria surface.
  final EdgeInsetsGeometry criteriaPadding;

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

  /// Creates an adaptive approval desk.
  const AdaptiveApprovalDesk({
    super.key,
    required this.approvals,
    required this.itemBuilder,
    required this.proposalBuilder,
    required this.criteriaBuilder,
    required this.historyBuilder,
    required this.approvalTitle,
    required this.criteriaTitle,
    required this.historyTitle,
    this.header,
    this.emptyState,
    this.approvalDescription,
    this.approvalLeading,
    this.criteriaDescription,
    this.criteriaLeading,
    this.historyDescription,
    this.historyLeading,
    this.modalApprovalLabel = 'Open approvals',
    this.modalApprovalIcon = const Icon(Icons.approval_outlined),
    this.modalCriteriaLabel = 'Open criteria',
    this.modalCriteriaIcon = const Icon(Icons.fact_check_outlined),
    this.modalHistoryLabel = 'Open history',
    this.modalHistoryIcon = const Icon(Icons.history_outlined),
    this.approvalDockedAt = AdaptiveSize.medium,
    this.criteriaDockedAt = AdaptiveSize.expanded,
    this.historyDockedAt = AdaptiveSize.expanded,
    this.minimumApprovalDockedHeight = AdaptiveHeight.compact,
    this.minimumCriteriaDockedHeight = AdaptiveHeight.medium,
    this.minimumHistoryDockedHeight = AdaptiveHeight.expanded,
    this.useContainerConstraints = true,
    this.considerOrientation = false,
    this.selectedIndex,
    this.initialIndex = 0,
    this.onSelectedIndexChanged,
    this.spacing = 16,
    this.itemSpacing = 12,
    this.approvalFlex = 2,
    this.proposalFlex = 4,
    this.criteriaFlex = 2,
    this.proposalPaneFlex = 3,
    this.historyFlex = 2,
    this.approvalPadding = const EdgeInsets.all(16),
    this.proposalPadding = const EdgeInsets.all(16),
    this.criteriaPadding = const EdgeInsets.all(16),
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
      incidents: approvals,
      itemBuilder: itemBuilder,
      detailBuilder: proposalBuilder,
      contextBuilder: criteriaBuilder,
      timelineBuilder: historyBuilder,
      header: header,
      emptyState: emptyState,
      listTitle: approvalTitle,
      listDescription: approvalDescription,
      listLeading: approvalLeading,
      contextTitle: criteriaTitle,
      contextDescription: criteriaDescription,
      contextLeading: criteriaLeading,
      timelineTitle: historyTitle,
      timelineDescription: historyDescription,
      timelineLeading: historyLeading,
      modalListLabel: modalApprovalLabel,
      modalListIcon: modalApprovalIcon,
      modalContextLabel: modalCriteriaLabel,
      modalContextIcon: modalCriteriaIcon,
      modalTimelineLabel: modalHistoryLabel,
      modalTimelineIcon: modalHistoryIcon,
      listDockedAt: approvalDockedAt,
      contextDockedAt: criteriaDockedAt,
      timelineDockedAt: historyDockedAt,
      minimumListDockedHeight: minimumApprovalDockedHeight,
      minimumContextDockedHeight: minimumCriteriaDockedHeight,
      minimumTimelineDockedHeight: minimumHistoryDockedHeight,
      useContainerConstraints: useContainerConstraints,
      considerOrientation: considerOrientation,
      selectedIndex: selectedIndex,
      initialIndex: initialIndex,
      onSelectedIndexChanged: onSelectedIndexChanged,
      spacing: spacing,
      itemSpacing: itemSpacing,
      listFlex: approvalFlex,
      detailFlex: proposalFlex,
      contextFlex: criteriaFlex,
      detailPaneFlex: proposalPaneFlex,
      timelineFlex: historyFlex,
      listPadding: approvalPadding,
      detailPadding: proposalPadding,
      contextPadding: criteriaPadding,
      timelinePadding: historyPadding,
      modalHeightFactor: modalHeightFactor,
      showModalDragHandle: showModalDragHandle,
      animateSize: animateSize,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
    );
  }
}
