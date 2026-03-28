import 'package:flutter/material.dart';

import 'incident_desk.dart';
import '../media_query.dart';

/// A staged release workspace that coordinates a release list, an active
/// readiness surface, a blockers panel, and a rollout log from one adaptive
/// model.
class AdaptiveReleaseLab<T> extends StatelessWidget {
  /// Releases shown in the list.
  final List<T> releases;

  /// Builds an individual release row.
  final Widget Function(
    BuildContext context,
    T release,
    bool selected,
    VoidCallback onTap,
  ) itemBuilder;

  /// Builds the active readiness surface for the selected release.
  final Widget Function(BuildContext context, T release) readinessBuilder;

  /// Builds the blockers panel for the selected release.
  final Widget Function(BuildContext context, T release) blockersBuilder;

  /// Builds the rollout log for the selected release.
  final Widget Function(BuildContext context, T release) rolloutBuilder;

  /// Optional header shown above the active readiness surface.
  final Widget? header;

  /// Optional empty state shown when [releases] is empty.
  final Widget? emptyState;

  /// Title shown above the release list.
  final String releaseTitle;

  /// Optional description shown below [releaseTitle].
  final String? releaseDescription;

  /// Optional leading widget shown beside [releaseTitle].
  final Widget? releaseLeading;

  /// Title shown above the blockers panel.
  final String blockersTitle;

  /// Optional description shown below [blockersTitle].
  final String? blockersDescription;

  /// Optional leading widget shown beside [blockersTitle].
  final Widget? blockersLeading;

  /// Title shown above the rollout panel.
  final String rolloutTitle;

  /// Optional description shown below [rolloutTitle].
  final String? rolloutDescription;

  /// Optional leading widget shown beside [rolloutTitle].
  final Widget? rolloutLeading;

  /// Label used by the compact release-list trigger.
  final String modalReleaseLabel;

  /// Icon used by the compact release-list trigger.
  final Widget modalReleaseIcon;

  /// Label used by the compact blockers trigger.
  final String modalBlockersLabel;

  /// Icon used by the compact blockers trigger.
  final Widget modalBlockersIcon;

  /// Label used by the compact rollout trigger.
  final String modalRolloutLabel;

  /// Icon used by the compact rollout trigger.
  final Widget modalRolloutIcon;

  /// Semantic size at which the release list should dock inline.
  final AdaptiveSize releaseDockedAt;

  /// Semantic size at which the blockers panel should dock inline.
  final AdaptiveSize blockersDockedAt;

  /// Semantic size at which the rollout panel should dock inline.
  final AdaptiveSize rolloutDockedAt;

  /// Minimum height class required before the release list can dock inline.
  final AdaptiveHeight minimumReleaseDockedHeight;

  /// Minimum height class required before blockers can dock inline.
  final AdaptiveHeight minimumBlockersDockedHeight;

  /// Minimum height class required before rollout can dock inline.
  final AdaptiveHeight minimumRolloutDockedHeight;

  /// Whether to derive layout decisions from parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should influence container-based breakpoint selection.
  final bool considerOrientation;

  /// Optional controlled selected release index.
  final int? selectedIndex;

  /// Initial selected release index for uncontrolled usage.
  final int initialIndex;

  /// Called when the selected release changes.
  final ValueChanged<int>? onSelectedIndexChanged;

  /// Space between adjacent regions.
  final double spacing;

  /// Space between adjacent release rows.
  final double itemSpacing;

  /// Flex used by the docked release-list region.
  final int releaseFlex;

  /// Flex used by the readiness region.
  final int readinessFlex;

  /// Flex used by the docked blockers region.
  final int blockersFlex;

  /// Flex used by the readiness surface when rollout is docked below it.
  final int readinessPaneFlex;

  /// Flex used by the docked rollout region.
  final int rolloutFlex;

  /// Padding applied inside the release list surface.
  final EdgeInsetsGeometry releasePadding;

  /// Padding applied inside the readiness surface.
  final EdgeInsetsGeometry readinessPadding;

  /// Padding applied inside the blockers surface.
  final EdgeInsetsGeometry blockersPadding;

  /// Padding applied inside the rollout surface.
  final EdgeInsetsGeometry rolloutPadding;

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

  /// Creates an adaptive release lab.
  const AdaptiveReleaseLab({
    super.key,
    required this.releases,
    required this.itemBuilder,
    required this.readinessBuilder,
    required this.blockersBuilder,
    required this.rolloutBuilder,
    required this.releaseTitle,
    required this.blockersTitle,
    required this.rolloutTitle,
    this.header,
    this.emptyState,
    this.releaseDescription,
    this.releaseLeading,
    this.blockersDescription,
    this.blockersLeading,
    this.rolloutDescription,
    this.rolloutLeading,
    this.modalReleaseLabel = 'Open releases',
    this.modalReleaseIcon = const Icon(Icons.rocket_launch_outlined),
    this.modalBlockersLabel = 'Open blockers',
    this.modalBlockersIcon = const Icon(Icons.warning_amber_outlined),
    this.modalRolloutLabel = 'Open rollout log',
    this.modalRolloutIcon = const Icon(Icons.history_outlined),
    this.releaseDockedAt = AdaptiveSize.medium,
    this.blockersDockedAt = AdaptiveSize.expanded,
    this.rolloutDockedAt = AdaptiveSize.expanded,
    this.minimumReleaseDockedHeight = AdaptiveHeight.compact,
    this.minimumBlockersDockedHeight = AdaptiveHeight.medium,
    this.minimumRolloutDockedHeight = AdaptiveHeight.expanded,
    this.useContainerConstraints = true,
    this.considerOrientation = false,
    this.selectedIndex,
    this.initialIndex = 0,
    this.onSelectedIndexChanged,
    this.spacing = 16,
    this.itemSpacing = 12,
    this.releaseFlex = 2,
    this.readinessFlex = 4,
    this.blockersFlex = 2,
    this.readinessPaneFlex = 3,
    this.rolloutFlex = 2,
    this.releasePadding = const EdgeInsets.all(16),
    this.readinessPadding = const EdgeInsets.all(16),
    this.blockersPadding = const EdgeInsets.all(16),
    this.rolloutPadding = const EdgeInsets.all(16),
    this.modalHeightFactor = 0.72,
    this.showModalDragHandle = true,
    this.animateSize = true,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeInOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveIncidentDesk<T>(
      incidents: releases,
      itemBuilder: itemBuilder,
      detailBuilder: readinessBuilder,
      contextBuilder: blockersBuilder,
      timelineBuilder: rolloutBuilder,
      header: header,
      emptyState: emptyState,
      listTitle: releaseTitle,
      listDescription: releaseDescription,
      listLeading: releaseLeading,
      contextTitle: blockersTitle,
      contextDescription: blockersDescription,
      contextLeading: blockersLeading,
      timelineTitle: rolloutTitle,
      timelineDescription: rolloutDescription,
      timelineLeading: rolloutLeading,
      modalListLabel: modalReleaseLabel,
      modalListIcon: modalReleaseIcon,
      modalContextLabel: modalBlockersLabel,
      modalContextIcon: modalBlockersIcon,
      modalTimelineLabel: modalRolloutLabel,
      modalTimelineIcon: modalRolloutIcon,
      listDockedAt: releaseDockedAt,
      contextDockedAt: blockersDockedAt,
      timelineDockedAt: rolloutDockedAt,
      minimumListDockedHeight: minimumReleaseDockedHeight,
      minimumContextDockedHeight: minimumBlockersDockedHeight,
      minimumTimelineDockedHeight: minimumRolloutDockedHeight,
      useContainerConstraints: useContainerConstraints,
      considerOrientation: considerOrientation,
      selectedIndex: selectedIndex,
      initialIndex: initialIndex,
      onSelectedIndexChanged: onSelectedIndexChanged,
      spacing: spacing,
      itemSpacing: itemSpacing,
      listFlex: releaseFlex,
      detailFlex: readinessFlex,
      contextFlex: blockersFlex,
      detailPaneFlex: readinessPaneFlex,
      timelineFlex: rolloutFlex,
      listPadding: releasePadding,
      detailPadding: readinessPadding,
      contextPadding: blockersPadding,
      timelinePadding: rolloutPadding,
      modalHeightFactor: modalHeightFactor,
      showModalDragHandle: showModalDragHandle,
      animateSize: animateSize,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
    );
  }
}
