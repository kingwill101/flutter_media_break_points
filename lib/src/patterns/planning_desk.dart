import 'package:flutter/material.dart';

import 'incident_desk.dart';
import '../media_query.dart';

/// A staged planning workspace that coordinates a plan list, an active plan
/// focus surface, a risks panel, and a milestones panel from one adaptive
/// model.
class AdaptivePlanningDesk<T> extends StatelessWidget {
  /// Plans shown in the list.
  final List<T> plans;

  /// Builds an individual plan row.
  final Widget Function(
    BuildContext context,
    T plan,
    bool selected,
    VoidCallback onTap,
  ) itemBuilder;

  /// Builds the active plan focus surface for the selected plan.
  final Widget Function(BuildContext context, T plan) focusBuilder;

  /// Builds the risks panel for the selected plan.
  final Widget Function(BuildContext context, T plan) risksBuilder;

  /// Builds the milestones panel for the selected plan.
  final Widget Function(BuildContext context, T plan) milestonesBuilder;

  /// Optional header shown above the active focus surface.
  final Widget? header;

  /// Optional empty state shown when [plans] is empty.
  final Widget? emptyState;

  /// Title shown above the plan list.
  final String planTitle;

  /// Optional description shown below [planTitle].
  final String? planDescription;

  /// Optional leading widget shown beside [planTitle].
  final Widget? planLeading;

  /// Title shown above the risks panel.
  final String risksTitle;

  /// Optional description shown below [risksTitle].
  final String? risksDescription;

  /// Optional leading widget shown beside [risksTitle].
  final Widget? risksLeading;

  /// Title shown above the milestones panel.
  final String milestonesTitle;

  /// Optional description shown below [milestonesTitle].
  final String? milestonesDescription;

  /// Optional leading widget shown beside [milestonesTitle].
  final Widget? milestonesLeading;

  /// Label used by the compact plan-list trigger.
  final String modalPlanLabel;

  /// Icon used by the compact plan-list trigger.
  final Widget modalPlanIcon;

  /// Label used by the compact risks trigger.
  final String modalRisksLabel;

  /// Icon used by the compact risks trigger.
  final Widget modalRisksIcon;

  /// Label used by the compact milestones trigger.
  final String modalMilestonesLabel;

  /// Icon used by the compact milestones trigger.
  final Widget modalMilestonesIcon;

  /// Semantic size at which the plan list should dock inline.
  final AdaptiveSize planDockedAt;

  /// Semantic size at which the risks panel should dock inline.
  final AdaptiveSize risksDockedAt;

  /// Semantic size at which the milestones panel should dock inline.
  final AdaptiveSize milestonesDockedAt;

  /// Minimum height class required before the plan list can dock inline.
  final AdaptiveHeight minimumPlanDockedHeight;

  /// Minimum height class required before risks can dock inline.
  final AdaptiveHeight minimumRisksDockedHeight;

  /// Minimum height class required before milestones can dock inline.
  final AdaptiveHeight minimumMilestonesDockedHeight;

  /// Whether to derive layout decisions from parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should influence container-based breakpoint selection.
  final bool considerOrientation;

  /// Optional controlled selected plan index.
  final int? selectedIndex;

  /// Initial selected plan index for uncontrolled usage.
  final int initialIndex;

  /// Called when the selected plan changes.
  final ValueChanged<int>? onSelectedIndexChanged;

  /// Space between adjacent regions.
  final double spacing;

  /// Space between adjacent plan rows.
  final double itemSpacing;

  /// Flex used by the docked plan-list region.
  final int planFlex;

  /// Flex used by the focus region.
  final int focusFlex;

  /// Flex used by the docked risks region.
  final int risksFlex;

  /// Flex used by the focus surface when milestones are docked below it.
  final int focusPaneFlex;

  /// Flex used by the docked milestones region.
  final int milestonesFlex;

  /// Padding applied inside the plan list surface.
  final EdgeInsetsGeometry planPadding;

  /// Padding applied inside the focus surface.
  final EdgeInsetsGeometry focusPadding;

  /// Padding applied inside the risks surface.
  final EdgeInsetsGeometry risksPadding;

  /// Padding applied inside the milestones surface.
  final EdgeInsetsGeometry milestonesPadding;

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

  /// Creates an adaptive planning desk.
  const AdaptivePlanningDesk({
    super.key,
    required this.plans,
    required this.itemBuilder,
    required this.focusBuilder,
    required this.risksBuilder,
    required this.milestonesBuilder,
    required this.planTitle,
    required this.risksTitle,
    required this.milestonesTitle,
    this.header,
    this.emptyState,
    this.planDescription,
    this.planLeading,
    this.risksDescription,
    this.risksLeading,
    this.milestonesDescription,
    this.milestonesLeading,
    this.modalPlanLabel = 'Open plans',
    this.modalPlanIcon = const Icon(Icons.view_list_outlined),
    this.modalRisksLabel = 'Open risks',
    this.modalRisksIcon = const Icon(Icons.warning_amber_outlined),
    this.modalMilestonesLabel = 'Open milestones',
    this.modalMilestonesIcon = const Icon(Icons.flag_outlined),
    this.planDockedAt = AdaptiveSize.medium,
    this.risksDockedAt = AdaptiveSize.expanded,
    this.milestonesDockedAt = AdaptiveSize.expanded,
    this.minimumPlanDockedHeight = AdaptiveHeight.compact,
    this.minimumRisksDockedHeight = AdaptiveHeight.medium,
    this.minimumMilestonesDockedHeight = AdaptiveHeight.expanded,
    this.useContainerConstraints = true,
    this.considerOrientation = false,
    this.selectedIndex,
    this.initialIndex = 0,
    this.onSelectedIndexChanged,
    this.spacing = 16,
    this.itemSpacing = 12,
    this.planFlex = 2,
    this.focusFlex = 4,
    this.risksFlex = 2,
    this.focusPaneFlex = 3,
    this.milestonesFlex = 2,
    this.planPadding = const EdgeInsets.all(16),
    this.focusPadding = const EdgeInsets.all(16),
    this.risksPadding = const EdgeInsets.all(16),
    this.milestonesPadding = const EdgeInsets.all(16),
    this.modalHeightFactor = 0.72,
    this.showModalDragHandle = true,
    this.animateSize = true,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeInOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveIncidentDesk<T>(
      incidents: plans,
      itemBuilder: itemBuilder,
      detailBuilder: focusBuilder,
      contextBuilder: risksBuilder,
      timelineBuilder: milestonesBuilder,
      header: header,
      emptyState: emptyState,
      listTitle: planTitle,
      listDescription: planDescription,
      listLeading: planLeading,
      contextTitle: risksTitle,
      contextDescription: risksDescription,
      contextLeading: risksLeading,
      timelineTitle: milestonesTitle,
      timelineDescription: milestonesDescription,
      timelineLeading: milestonesLeading,
      modalListLabel: modalPlanLabel,
      modalListIcon: modalPlanIcon,
      modalContextLabel: modalRisksLabel,
      modalContextIcon: modalRisksIcon,
      modalTimelineLabel: modalMilestonesLabel,
      modalTimelineIcon: modalMilestonesIcon,
      listDockedAt: planDockedAt,
      contextDockedAt: risksDockedAt,
      timelineDockedAt: milestonesDockedAt,
      minimumListDockedHeight: minimumPlanDockedHeight,
      minimumContextDockedHeight: minimumRisksDockedHeight,
      minimumTimelineDockedHeight: minimumMilestonesDockedHeight,
      useContainerConstraints: useContainerConstraints,
      considerOrientation: considerOrientation,
      selectedIndex: selectedIndex,
      initialIndex: initialIndex,
      onSelectedIndexChanged: onSelectedIndexChanged,
      spacing: spacing,
      itemSpacing: itemSpacing,
      listFlex: planFlex,
      detailFlex: focusFlex,
      contextFlex: risksFlex,
      detailPaneFlex: focusPaneFlex,
      timelineFlex: milestonesFlex,
      listPadding: planPadding,
      detailPadding: focusPadding,
      contextPadding: risksPadding,
      timelinePadding: milestonesPadding,
      modalHeightFactor: modalHeightFactor,
      showModalDragHandle: showModalDragHandle,
      animateSize: animateSize,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
    );
  }
}
