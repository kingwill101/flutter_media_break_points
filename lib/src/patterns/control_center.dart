import 'package:flutter/material.dart';

import '../container_layout.dart';
import '../media_query.dart';

/// The active arrangement used by [AdaptiveControlCenter].
enum AdaptiveControlCenterMode {
  modalPanels,
  sidebarDocked,
  sidePanelsDocked,
  fullyDocked,
}

/// A staged operations workspace that coordinates a left sidebar, central
/// dashboard, right insights panel, and bottom activity panel from one
/// adaptive layout model.
class AdaptiveControlCenter extends StatelessWidget {
  /// Main dashboard or control surface.
  final Widget main;

  /// Optional header shown above the main surface.
  final Widget? header;

  /// Sidebar content shown inline or in a modal sheet.
  final Widget sidebar;

  /// Title shown above the sidebar content.
  final String sidebarTitle;

  /// Optional description shown below [sidebarTitle].
  final String? sidebarDescription;

  /// Optional leading widget shown beside [sidebarTitle].
  final Widget? sidebarLeading;

  /// Insights content shown inline or in a modal sheet.
  final Widget insights;

  /// Title shown above the insights content.
  final String insightsTitle;

  /// Optional description shown below [insightsTitle].
  final String? insightsDescription;

  /// Optional leading widget shown beside [insightsTitle].
  final Widget? insightsLeading;

  /// Activity content shown inline or in a modal sheet.
  final Widget activity;

  /// Title shown above the activity content.
  final String activityTitle;

  /// Optional description shown below [activityTitle].
  final String? activityDescription;

  /// Optional leading widget shown beside [activityTitle].
  final Widget? activityLeading;

  /// Label used by the compact sidebar trigger.
  final String modalSidebarLabel;

  /// Icon used by the compact sidebar trigger.
  final Widget modalSidebarIcon;

  /// Label used by the compact insights trigger.
  final String modalInsightsLabel;

  /// Icon used by the compact insights trigger.
  final Widget modalInsightsIcon;

  /// Label used by the compact activity trigger.
  final String modalActivityLabel;

  /// Icon used by the compact activity trigger.
  final Widget modalActivityIcon;

  /// Semantic size at which the sidebar should dock inline.
  final AdaptiveSize sidebarDockedAt;

  /// Semantic size at which the insights panel should dock inline.
  final AdaptiveSize insightsDockedAt;

  /// Semantic size at which the activity panel should dock inline.
  final AdaptiveSize activityDockedAt;

  /// Minimum height class required before the sidebar can dock inline.
  final AdaptiveHeight minimumSidebarDockedHeight;

  /// Minimum height class required before the insights panel can dock inline.
  final AdaptiveHeight minimumInsightsDockedHeight;

  /// Minimum height class required before the activity panel can dock inline.
  final AdaptiveHeight minimumActivityDockedHeight;

  /// Whether to derive layout decisions from parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should influence container-based breakpoint selection.
  final bool considerOrientation;

  /// Space between adjacent regions.
  final double spacing;

  /// Flex used by the docked sidebar region.
  final int sidebarFlex;

  /// Flex used by the main region.
  final int mainFlex;

  /// Flex used by the docked insights region.
  final int insightsFlex;

  /// Flex used by the main surface when the activity panel is docked below it.
  final int mainPaneFlex;

  /// Flex used by the docked activity region.
  final int activityFlex;

  /// Padding applied inside the sidebar surface.
  final EdgeInsetsGeometry sidebarPadding;

  /// Padding applied inside the main surface.
  final EdgeInsetsGeometry mainPadding;

  /// Padding applied inside the insights surface.
  final EdgeInsetsGeometry insightsPadding;

  /// Padding applied inside the activity surface.
  final EdgeInsetsGeometry activityPadding;

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

  /// Creates an adaptive control center.
  const AdaptiveControlCenter({
    super.key,
    required this.main,
    required this.sidebar,
    required this.sidebarTitle,
    required this.insights,
    required this.insightsTitle,
    required this.activity,
    required this.activityTitle,
    this.header,
    this.sidebarDescription,
    this.sidebarLeading,
    this.insightsDescription,
    this.insightsLeading,
    this.activityDescription,
    this.activityLeading,
    this.modalSidebarLabel = 'Open sidebar',
    this.modalSidebarIcon = const Icon(Icons.view_sidebar_outlined),
    this.modalInsightsLabel = 'Open insights',
    this.modalInsightsIcon = const Icon(Icons.insights_outlined),
    this.modalActivityLabel = 'Open activity',
    this.modalActivityIcon = const Icon(Icons.history_outlined),
    this.sidebarDockedAt = AdaptiveSize.medium,
    this.insightsDockedAt = AdaptiveSize.expanded,
    this.activityDockedAt = AdaptiveSize.expanded,
    this.minimumSidebarDockedHeight = AdaptiveHeight.compact,
    this.minimumInsightsDockedHeight = AdaptiveHeight.medium,
    this.minimumActivityDockedHeight = AdaptiveHeight.expanded,
    this.useContainerConstraints = true,
    this.considerOrientation = false,
    this.spacing = 16,
    this.sidebarFlex = 2,
    this.mainFlex = 4,
    this.insightsFlex = 2,
    this.mainPaneFlex = 3,
    this.activityFlex = 2,
    this.sidebarPadding = const EdgeInsets.all(16),
    this.mainPadding = const EdgeInsets.all(16),
    this.insightsPadding = const EdgeInsets.all(16),
    this.activityPadding = const EdgeInsets.all(16),
    this.modalHeightFactor = 0.72,
    this.showModalDragHandle = true,
    this.animateSize = true,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeInOutCubic,
  })  : assert(spacing >= 0, 'spacing must be zero or greater.'),
        assert(sidebarFlex > 0, 'sidebarFlex must be greater than zero.'),
        assert(mainFlex > 0, 'mainFlex must be greater than zero.'),
        assert(insightsFlex > 0, 'insightsFlex must be greater than zero.'),
        assert(mainPaneFlex > 0, 'mainPaneFlex must be greater than zero.'),
        assert(activityFlex > 0, 'activityFlex must be greater than zero.'),
        assert(
          modalHeightFactor > 0 && modalHeightFactor <= 1,
          'modalHeightFactor must be between 0 and 1.',
        );

  @override
  Widget build(BuildContext context) {
    final child = useContainerConstraints
        ? ResponsiveContainerBuilder(
            considerOrientation: considerOrientation,
            builder: (context, data) => _buildForData(context, data),
          )
        : Builder(
            builder: (context) =>
                _buildForData(context, context.breakPointData),
          );

    if (!animateSize) {
      return child;
    }

    return AnimatedSize(
      duration: animationDuration,
      curve: animationCurve,
      alignment: Alignment.topCenter,
      child: child,
    );
  }

  Widget _buildForData(BuildContext context, BreakPointData data) {
    final mode = _modeForData(data);

    return LayoutBuilder(
      builder: (context, constraints) {
        final hasBoundedHeight = constraints.maxHeight.isFinite;
        final mainSurface = _ControlCenterMainSurface(
          header: header,
          boundedHeight: hasBoundedHeight,
          padding: mainPadding,
          child: main,
        );

        return AnimatedSwitcher(
          duration: animationDuration,
          switchInCurve: animationCurve,
          switchOutCurve: animationCurve.flipped,
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
              AdaptiveControlCenterMode.modalPanels => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (hasBoundedHeight)
                      Expanded(child: mainSurface)
                    else
                      mainSurface,
                    SizedBox(height: spacing),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.end,
                        children: [
                          FilledButton.tonalIcon(
                            onPressed: () => _showSidebarSheet(context),
                            icon: modalSidebarIcon,
                            label: Text(modalSidebarLabel),
                          ),
                          FilledButton.tonalIcon(
                            onPressed: () => _showInsightsSheet(context),
                            icon: modalInsightsIcon,
                            label: Text(modalInsightsLabel),
                          ),
                          FilledButton.tonalIcon(
                            onPressed: () => _showActivitySheet(context),
                            icon: modalActivityIcon,
                            label: Text(modalActivityLabel),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              AdaptiveControlCenterMode.sidebarDocked => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: sidebarFlex,
                      child: _ControlCenterPanelCard(
                        title: sidebarTitle,
                        description: sidebarDescription,
                        leading: sidebarLeading,
                        padding: sidebarPadding,
                        boundedHeight: hasBoundedHeight,
                        child: sidebar,
                      ),
                    ),
                    SizedBox(width: spacing),
                    Expanded(
                      flex: mainFlex,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: hasBoundedHeight
                            ? MainAxisSize.max
                            : MainAxisSize.min,
                        children: [
                          if (hasBoundedHeight)
                            Expanded(child: mainSurface)
                          else
                            mainSurface,
                          SizedBox(height: spacing),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              alignment: WrapAlignment.end,
                              children: [
                                FilledButton.tonalIcon(
                                  onPressed: () => _showInsightsSheet(context),
                                  icon: modalInsightsIcon,
                                  label: Text(modalInsightsLabel),
                                ),
                                FilledButton.tonalIcon(
                                  onPressed: () => _showActivitySheet(context),
                                  icon: modalActivityIcon,
                                  label: Text(modalActivityLabel),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              AdaptiveControlCenterMode.sidePanelsDocked => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: sidebarFlex,
                      child: _ControlCenterPanelCard(
                        title: sidebarTitle,
                        description: sidebarDescription,
                        leading: sidebarLeading,
                        padding: sidebarPadding,
                        boundedHeight: hasBoundedHeight,
                        child: sidebar,
                      ),
                    ),
                    SizedBox(width: spacing),
                    Expanded(
                      flex: mainFlex,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: hasBoundedHeight
                            ? MainAxisSize.max
                            : MainAxisSize.min,
                        children: [
                          if (hasBoundedHeight)
                            Expanded(child: mainSurface)
                          else
                            mainSurface,
                          SizedBox(height: spacing),
                          Align(
                            alignment: Alignment.centerRight,
                            child: FilledButton.tonalIcon(
                              onPressed: () => _showActivitySheet(context),
                              icon: modalActivityIcon,
                              label: Text(modalActivityLabel),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: spacing),
                    Expanded(
                      flex: insightsFlex,
                      child: _ControlCenterPanelCard(
                        title: insightsTitle,
                        description: insightsDescription,
                        leading: insightsLeading,
                        padding: insightsPadding,
                        boundedHeight: hasBoundedHeight,
                        child: insights,
                      ),
                    ),
                  ],
                ),
              AdaptiveControlCenterMode.fullyDocked => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: sidebarFlex,
                      child: _ControlCenterPanelCard(
                        title: sidebarTitle,
                        description: sidebarDescription,
                        leading: sidebarLeading,
                        padding: sidebarPadding,
                        boundedHeight: hasBoundedHeight,
                        child: sidebar,
                      ),
                    ),
                    SizedBox(width: spacing),
                    Expanded(
                      flex: mainFlex,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: hasBoundedHeight
                            ? MainAxisSize.max
                            : MainAxisSize.min,
                        children: [
                          if (hasBoundedHeight)
                            Expanded(
                              flex: mainPaneFlex,
                              child: mainSurface,
                            )
                          else
                            mainSurface,
                          SizedBox(height: spacing),
                          if (hasBoundedHeight)
                            Expanded(
                              flex: activityFlex,
                              child: _ControlCenterPanelCard(
                                title: activityTitle,
                                description: activityDescription,
                                leading: activityLeading,
                                padding: activityPadding,
                                boundedHeight: true,
                                child: activity,
                              ),
                            )
                          else
                            _ControlCenterPanelCard(
                              title: activityTitle,
                              description: activityDescription,
                              leading: activityLeading,
                              padding: activityPadding,
                              boundedHeight: false,
                              child: activity,
                            ),
                        ],
                      ),
                    ),
                    SizedBox(width: spacing),
                    Expanded(
                      flex: insightsFlex,
                      child: _ControlCenterPanelCard(
                        title: insightsTitle,
                        description: insightsDescription,
                        leading: insightsLeading,
                        padding: insightsPadding,
                        boundedHeight: hasBoundedHeight,
                        child: insights,
                      ),
                    ),
                  ],
                ),
            },
          ),
        );
      },
    );
  }

  AdaptiveControlCenterMode _modeForData(BreakPointData data) {
    final canDockSidebar = data.adaptiveSize.index >= sidebarDockedAt.index &&
        data.adaptiveHeight.index >= minimumSidebarDockedHeight.index;
    final canDockInsights = data.adaptiveSize.index >= insightsDockedAt.index &&
        data.adaptiveHeight.index >= minimumInsightsDockedHeight.index;
    final canDockActivity = data.adaptiveSize.index >= activityDockedAt.index &&
        data.adaptiveHeight.index >= minimumActivityDockedHeight.index;

    if (canDockSidebar && canDockInsights && canDockActivity) {
      return AdaptiveControlCenterMode.fullyDocked;
    }
    if (canDockSidebar && canDockInsights) {
      return AdaptiveControlCenterMode.sidePanelsDocked;
    }
    if (canDockSidebar) {
      return AdaptiveControlCenterMode.sidebarDocked;
    }
    return AdaptiveControlCenterMode.modalPanels;
  }

  Future<void> _showSidebarSheet(BuildContext context) {
    return _showPanelSheet(
      context: context,
      title: sidebarTitle,
      description: sidebarDescription,
      leading: sidebarLeading,
      child: sidebar,
    );
  }

  Future<void> _showInsightsSheet(BuildContext context) {
    return _showPanelSheet(
      context: context,
      title: insightsTitle,
      description: insightsDescription,
      leading: insightsLeading,
      child: insights,
    );
  }

  Future<void> _showActivitySheet(BuildContext context) {
    return _showPanelSheet(
      context: context,
      title: activityTitle,
      description: activityDescription,
      leading: activityLeading,
      child: activity,
    );
  }

  Future<void> _showPanelSheet({
    required BuildContext context,
    required String title,
    required Widget child,
    String? description,
    Widget? leading,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: showModalDragHandle,
      builder: (sheetContext) {
        return FractionallySizedBox(
          heightFactor: modalHeightFactor,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 8,
                bottom: 20 + MediaQuery.viewInsetsOf(sheetContext).bottom,
              ),
              child: _ControlCenterPanelSurface(
                title: title,
                description: description,
                leading: leading,
                boundedHeight: true,
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ControlCenterPanelCard extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? leading;
  final EdgeInsetsGeometry padding;
  final bool boundedHeight;
  final Widget child;

  const _ControlCenterPanelCard({
    required this.title,
    required this.padding,
    required this.boundedHeight,
    required this.child,
    this.description,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding,
        child: _ControlCenterPanelSurface(
          title: title,
          description: description,
          leading: leading,
          boundedHeight: boundedHeight,
          child: child,
        ),
      ),
    );
  }
}

class _ControlCenterMainSurface extends StatelessWidget {
  final Widget? header;
  final bool boundedHeight;
  final EdgeInsetsGeometry padding;
  final Widget child;

  const _ControlCenterMainSurface({
    required this.boundedHeight,
    required this.padding,
    required this.child,
    this.header,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: boundedHeight ? MainAxisSize.max : MainAxisSize.min,
          children: [
            if (header != null) ...[
              header!,
              const SizedBox(height: 16),
            ],
            if (boundedHeight) Expanded(child: child) else child,
          ],
        ),
      ),
    );
  }
}

class _ControlCenterPanelSurface extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? leading;
  final bool boundedHeight;
  final Widget child;

  const _ControlCenterPanelSurface({
    required this.title,
    required this.boundedHeight,
    required this.child,
    this.description,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: boundedHeight ? MainAxisSize.max : MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 4),
                    Text(description!),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (boundedHeight) Expanded(child: child) else child,
      ],
    );
  }
}
