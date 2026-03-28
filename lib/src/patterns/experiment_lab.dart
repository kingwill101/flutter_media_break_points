import 'package:flutter/material.dart';

import 'incident_desk.dart';
import '../media_query.dart';

/// A staged experimentation workspace that coordinates an experiment list, an
/// active focus surface, an evidence panel, and a decision log from one
/// adaptive model.
class AdaptiveExperimentLab<T> extends StatelessWidget {
  /// Experiments shown in the list.
  final List<T> experiments;

  /// Builds an individual experiment row.
  final Widget Function(
    BuildContext context,
    T experiment,
    bool selected,
    VoidCallback onTap,
  ) itemBuilder;

  /// Builds the active experiment focus surface for the selected experiment.
  final Widget Function(BuildContext context, T experiment) focusBuilder;

  /// Builds the evidence panel for the selected experiment.
  final Widget Function(BuildContext context, T experiment) evidenceBuilder;

  /// Builds the decision log for the selected experiment.
  final Widget Function(BuildContext context, T experiment) decisionBuilder;

  /// Optional header shown above the active focus surface.
  final Widget? header;

  /// Optional empty state shown when [experiments] is empty.
  final Widget? emptyState;

  /// Title shown above the experiment list.
  final String experimentTitle;

  /// Optional description shown below [experimentTitle].
  final String? experimentDescription;

  /// Optional leading widget shown beside [experimentTitle].
  final Widget? experimentLeading;

  /// Title shown above the evidence panel.
  final String evidenceTitle;

  /// Optional description shown below [evidenceTitle].
  final String? evidenceDescription;

  /// Optional leading widget shown beside [evidenceTitle].
  final Widget? evidenceLeading;

  /// Title shown above the decision panel.
  final String decisionTitle;

  /// Optional description shown below [decisionTitle].
  final String? decisionDescription;

  /// Optional leading widget shown beside [decisionTitle].
  final Widget? decisionLeading;

  /// Label used by the compact experiment-list trigger.
  final String modalExperimentLabel;

  /// Icon used by the compact experiment-list trigger.
  final Widget modalExperimentIcon;

  /// Label used by the compact evidence trigger.
  final String modalEvidenceLabel;

  /// Icon used by the compact evidence trigger.
  final Widget modalEvidenceIcon;

  /// Label used by the compact decision trigger.
  final String modalDecisionLabel;

  /// Icon used by the compact decision trigger.
  final Widget modalDecisionIcon;

  /// Semantic size at which the experiment list should dock inline.
  final AdaptiveSize experimentDockedAt;

  /// Semantic size at which the evidence panel should dock inline.
  final AdaptiveSize evidenceDockedAt;

  /// Semantic size at which the decision panel should dock inline.
  final AdaptiveSize decisionDockedAt;

  /// Minimum height class required before the experiment list can dock inline.
  final AdaptiveHeight minimumExperimentDockedHeight;

  /// Minimum height class required before evidence can dock inline.
  final AdaptiveHeight minimumEvidenceDockedHeight;

  /// Minimum height class required before decisions can dock inline.
  final AdaptiveHeight minimumDecisionDockedHeight;

  /// Whether to derive layout decisions from parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should influence container-based breakpoint selection.
  final bool considerOrientation;

  /// Optional controlled selected experiment index.
  final int? selectedIndex;

  /// Initial selected experiment index for uncontrolled usage.
  final int initialIndex;

  /// Called when the selected experiment changes.
  final ValueChanged<int>? onSelectedIndexChanged;

  /// Space between adjacent regions.
  final double spacing;

  /// Space between adjacent experiment rows.
  final double itemSpacing;

  /// Flex used by the docked experiment-list region.
  final int experimentFlex;

  /// Flex used by the focus region.
  final int focusFlex;

  /// Flex used by the docked evidence region.
  final int evidenceFlex;

  /// Flex used by the focus surface when decisions are docked below it.
  final int focusPaneFlex;

  /// Flex used by the docked decision region.
  final int decisionFlex;

  /// Padding applied inside the experiment list surface.
  final EdgeInsetsGeometry experimentPadding;

  /// Padding applied inside the focus surface.
  final EdgeInsetsGeometry focusPadding;

  /// Padding applied inside the evidence surface.
  final EdgeInsetsGeometry evidencePadding;

  /// Padding applied inside the decision surface.
  final EdgeInsetsGeometry decisionPadding;

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

  /// Creates an adaptive experiment lab.
  const AdaptiveExperimentLab({
    super.key,
    required this.experiments,
    required this.itemBuilder,
    required this.focusBuilder,
    required this.evidenceBuilder,
    required this.decisionBuilder,
    required this.experimentTitle,
    required this.evidenceTitle,
    required this.decisionTitle,
    this.header,
    this.emptyState,
    this.experimentDescription,
    this.experimentLeading,
    this.evidenceDescription,
    this.evidenceLeading,
    this.decisionDescription,
    this.decisionLeading,
    this.modalExperimentLabel = 'Open experiments',
    this.modalExperimentIcon = const Icon(Icons.science_outlined),
    this.modalEvidenceLabel = 'Open evidence',
    this.modalEvidenceIcon = const Icon(Icons.fact_check_outlined),
    this.modalDecisionLabel = 'Open decisions',
    this.modalDecisionIcon = const Icon(Icons.rule_outlined),
    this.experimentDockedAt = AdaptiveSize.medium,
    this.evidenceDockedAt = AdaptiveSize.expanded,
    this.decisionDockedAt = AdaptiveSize.expanded,
    this.minimumExperimentDockedHeight = AdaptiveHeight.compact,
    this.minimumEvidenceDockedHeight = AdaptiveHeight.medium,
    this.minimumDecisionDockedHeight = AdaptiveHeight.expanded,
    this.useContainerConstraints = true,
    this.considerOrientation = false,
    this.selectedIndex,
    this.initialIndex = 0,
    this.onSelectedIndexChanged,
    this.spacing = 16,
    this.itemSpacing = 12,
    this.experimentFlex = 2,
    this.focusFlex = 4,
    this.evidenceFlex = 2,
    this.focusPaneFlex = 3,
    this.decisionFlex = 2,
    this.experimentPadding = const EdgeInsets.all(16),
    this.focusPadding = const EdgeInsets.all(16),
    this.evidencePadding = const EdgeInsets.all(16),
    this.decisionPadding = const EdgeInsets.all(16),
    this.modalHeightFactor = 0.72,
    this.showModalDragHandle = true,
    this.animateSize = true,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeInOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveIncidentDesk<T>(
      incidents: experiments,
      itemBuilder: itemBuilder,
      detailBuilder: focusBuilder,
      contextBuilder: evidenceBuilder,
      timelineBuilder: decisionBuilder,
      header: header,
      emptyState: emptyState,
      listTitle: experimentTitle,
      listDescription: experimentDescription,
      listLeading: experimentLeading,
      contextTitle: evidenceTitle,
      contextDescription: evidenceDescription,
      contextLeading: evidenceLeading,
      timelineTitle: decisionTitle,
      timelineDescription: decisionDescription,
      timelineLeading: decisionLeading,
      modalListLabel: modalExperimentLabel,
      modalListIcon: modalExperimentIcon,
      modalContextLabel: modalEvidenceLabel,
      modalContextIcon: modalEvidenceIcon,
      modalTimelineLabel: modalDecisionLabel,
      modalTimelineIcon: modalDecisionIcon,
      listDockedAt: experimentDockedAt,
      contextDockedAt: evidenceDockedAt,
      timelineDockedAt: decisionDockedAt,
      minimumListDockedHeight: minimumExperimentDockedHeight,
      minimumContextDockedHeight: minimumEvidenceDockedHeight,
      minimumTimelineDockedHeight: minimumDecisionDockedHeight,
      useContainerConstraints: useContainerConstraints,
      considerOrientation: considerOrientation,
      selectedIndex: selectedIndex,
      initialIndex: initialIndex,
      onSelectedIndexChanged: onSelectedIndexChanged,
      spacing: spacing,
      itemSpacing: itemSpacing,
      listFlex: experimentFlex,
      detailFlex: focusFlex,
      contextFlex: evidenceFlex,
      detailPaneFlex: focusPaneFlex,
      timelineFlex: decisionFlex,
      listPadding: experimentPadding,
      detailPadding: focusPadding,
      contextPadding: evidencePadding,
      timelinePadding: decisionPadding,
      modalHeightFactor: modalHeightFactor,
      showModalDragHandle: showModalDragHandle,
      animateSize: animateSize,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
    );
  }
}
