import 'package:flutter/material.dart';

import '../container_layout.dart';
import '../media_query.dart';

/// The active arrangement used by [AdaptiveIncidentDesk].
enum AdaptiveIncidentDeskMode {
  modalPanels,
  listDocked,
  sidePanelsDocked,
  fullyDocked,
}

/// A staged incident workspace that coordinates an incident list, an active
/// incident detail surface, a context panel, and a timeline panel from one
/// adaptive model.
class AdaptiveIncidentDesk<T> extends StatefulWidget {
  /// Incidents shown in the list.
  final List<T> incidents;

  /// Builds an individual incident row.
  final Widget Function(
    BuildContext context,
    T incident,
    bool selected,
    VoidCallback onTap,
  ) itemBuilder;

  /// Builds the active incident detail for the selected incident.
  final Widget Function(BuildContext context, T incident) detailBuilder;

  /// Builds the supporting context panel for the selected incident.
  final Widget Function(BuildContext context, T incident) contextBuilder;

  /// Builds the timeline or activity panel for the selected incident.
  final Widget Function(BuildContext context, T incident) timelineBuilder;

  /// Optional header shown above the active incident detail surface.
  final Widget? header;

  /// Optional empty state shown when [incidents] is empty.
  final Widget? emptyState;

  /// Title shown above the incident list.
  final String listTitle;

  /// Optional description shown below [listTitle].
  final String? listDescription;

  /// Optional leading widget shown beside [listTitle].
  final Widget? listLeading;

  /// Title shown above the context panel.
  final String contextTitle;

  /// Optional description shown below [contextTitle].
  final String? contextDescription;

  /// Optional leading widget shown beside [contextTitle].
  final Widget? contextLeading;

  /// Title shown above the timeline panel.
  final String timelineTitle;

  /// Optional description shown below [timelineTitle].
  final String? timelineDescription;

  /// Optional leading widget shown beside [timelineTitle].
  final Widget? timelineLeading;

  /// Label used by the compact list trigger.
  final String modalListLabel;

  /// Icon used by the compact list trigger.
  final Widget modalListIcon;

  /// Label used by the compact context trigger.
  final String modalContextLabel;

  /// Icon used by the compact context trigger.
  final Widget modalContextIcon;

  /// Label used by the compact timeline trigger.
  final String modalTimelineLabel;

  /// Icon used by the compact timeline trigger.
  final Widget modalTimelineIcon;

  /// Semantic size at which the incident list should dock inline.
  final AdaptiveSize listDockedAt;

  /// Semantic size at which the context panel should dock inline.
  final AdaptiveSize contextDockedAt;

  /// Semantic size at which the timeline panel should dock inline.
  final AdaptiveSize timelineDockedAt;

  /// Minimum height class required before the list can dock inline.
  final AdaptiveHeight minimumListDockedHeight;

  /// Minimum height class required before the context panel can dock inline.
  final AdaptiveHeight minimumContextDockedHeight;

  /// Minimum height class required before the timeline panel can dock inline.
  final AdaptiveHeight minimumTimelineDockedHeight;

  /// Whether to derive layout decisions from parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should influence container-based breakpoint selection.
  final bool considerOrientation;

  /// Optional controlled selected incident index.
  final int? selectedIndex;

  /// Initial selected incident index for uncontrolled usage.
  final int initialIndex;

  /// Called when the selected incident changes.
  final ValueChanged<int>? onSelectedIndexChanged;

  /// Space between adjacent regions.
  final double spacing;

  /// Space between adjacent incident rows.
  final double itemSpacing;

  /// Flex used by the docked list region.
  final int listFlex;

  /// Flex used by the detail region.
  final int detailFlex;

  /// Flex used by the docked context region.
  final int contextFlex;

  /// Flex used by the detail surface when the timeline is docked below it.
  final int detailPaneFlex;

  /// Flex used by the docked timeline region.
  final int timelineFlex;

  /// Padding applied inside the list surface.
  final EdgeInsetsGeometry listPadding;

  /// Padding applied inside the detail surface.
  final EdgeInsetsGeometry detailPadding;

  /// Padding applied inside the context surface.
  final EdgeInsetsGeometry contextPadding;

  /// Padding applied inside the timeline surface.
  final EdgeInsetsGeometry timelinePadding;

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

  /// Creates an adaptive incident desk.
  const AdaptiveIncidentDesk({
    super.key,
    required this.incidents,
    required this.itemBuilder,
    required this.detailBuilder,
    required this.contextBuilder,
    required this.timelineBuilder,
    required this.listTitle,
    required this.contextTitle,
    required this.timelineTitle,
    this.header,
    this.emptyState,
    this.listDescription,
    this.listLeading,
    this.contextDescription,
    this.contextLeading,
    this.timelineDescription,
    this.timelineLeading,
    this.modalListLabel = 'Open incidents',
    this.modalListIcon = const Icon(Icons.warning_amber_outlined),
    this.modalContextLabel = 'Open context',
    this.modalContextIcon = const Icon(Icons.people_outline),
    this.modalTimelineLabel = 'Open timeline',
    this.modalTimelineIcon = const Icon(Icons.timeline_outlined),
    this.listDockedAt = AdaptiveSize.medium,
    this.contextDockedAt = AdaptiveSize.expanded,
    this.timelineDockedAt = AdaptiveSize.expanded,
    this.minimumListDockedHeight = AdaptiveHeight.compact,
    this.minimumContextDockedHeight = AdaptiveHeight.medium,
    this.minimumTimelineDockedHeight = AdaptiveHeight.expanded,
    this.useContainerConstraints = true,
    this.considerOrientation = false,
    this.selectedIndex,
    this.initialIndex = 0,
    this.onSelectedIndexChanged,
    this.spacing = 16,
    this.itemSpacing = 12,
    this.listFlex = 2,
    this.detailFlex = 4,
    this.contextFlex = 2,
    this.detailPaneFlex = 3,
    this.timelineFlex = 2,
    this.listPadding = const EdgeInsets.all(16),
    this.detailPadding = const EdgeInsets.all(16),
    this.contextPadding = const EdgeInsets.all(16),
    this.timelinePadding = const EdgeInsets.all(16),
    this.modalHeightFactor = 0.72,
    this.showModalDragHandle = true,
    this.animateSize = true,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeInOutCubic,
  })  : assert(spacing >= 0, 'spacing must be zero or greater.'),
        assert(itemSpacing >= 0, 'itemSpacing must be zero or greater.'),
        assert(listFlex > 0, 'listFlex must be greater than zero.'),
        assert(detailFlex > 0, 'detailFlex must be greater than zero.'),
        assert(contextFlex > 0, 'contextFlex must be greater than zero.'),
        assert(
          detailPaneFlex > 0,
          'detailPaneFlex must be greater than zero.',
        ),
        assert(timelineFlex > 0, 'timelineFlex must be greater than zero.'),
        assert(
          modalHeightFactor > 0 && modalHeightFactor <= 1,
          'modalHeightFactor must be between 0 and 1.',
        );

  @override
  State<AdaptiveIncidentDesk<T>> createState() =>
      _AdaptiveIncidentDeskState<T>();
}

class _AdaptiveIncidentDeskState<T> extends State<AdaptiveIncidentDesk<T>> {
  late int _internalIndex = widget.initialIndex;

  bool get _isControlled => widget.selectedIndex != null;

  int get _maxIndex {
    if (widget.incidents.isEmpty) {
      return 0;
    }
    return widget.incidents.length - 1;
  }

  int get _currentIndex {
    final rawIndex = widget.selectedIndex ?? _internalIndex;
    if (rawIndex < 0) {
      return 0;
    }
    if (rawIndex > _maxIndex) {
      return _maxIndex;
    }
    return rawIndex;
  }

  T get _currentIncident => widget.incidents[_currentIndex];

  @override
  void didUpdateWidget(covariant AdaptiveIncidentDesk<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isControlled || widget.incidents.isEmpty) {
      return;
    }
    if (_internalIndex > _maxIndex) {
      _internalIndex = _maxIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.incidents.isEmpty) {
      return widget.emptyState ?? const SizedBox.shrink();
    }

    final child = widget.useContainerConstraints
        ? ResponsiveContainerBuilder(
            considerOrientation: widget.considerOrientation,
            builder: (context, data) => _buildForData(context, data),
          )
        : Builder(
            builder: (context) =>
                _buildForData(context, context.breakPointData),
          );

    if (!widget.animateSize) {
      return child;
    }

    return AnimatedSize(
      duration: widget.animationDuration,
      curve: widget.animationCurve,
      alignment: Alignment.topCenter,
      child: child,
    );
  }

  Widget _buildForData(BuildContext context, BreakPointData data) {
    final mode = _modeForData(data);

    return LayoutBuilder(
      builder: (context, constraints) {
        final hasBoundedHeight = constraints.maxHeight.isFinite;
        final detailSurface = _IncidentDeskDetailSurface(
          header: widget.header,
          boundedHeight: hasBoundedHeight,
          padding: widget.detailPadding,
          child: widget.detailBuilder(context, _currentIncident),
        );

        return AnimatedSwitcher(
          duration: widget.animationDuration,
          switchInCurve: widget.animationCurve,
          switchOutCurve: widget.animationCurve.flipped,
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
              AdaptiveIncidentDeskMode.modalPanels => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (hasBoundedHeight)
                      Expanded(child: detailSurface)
                    else
                      detailSurface,
                    SizedBox(height: widget.spacing),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.end,
                        children: [
                          FilledButton.tonalIcon(
                            onPressed: () => _showListSheet(context),
                            icon: widget.modalListIcon,
                            label: Text(widget.modalListLabel),
                          ),
                          FilledButton.tonalIcon(
                            onPressed: () => _showContextSheet(context),
                            icon: widget.modalContextIcon,
                            label: Text(widget.modalContextLabel),
                          ),
                          FilledButton.tonalIcon(
                            onPressed: () => _showTimelineSheet(context),
                            icon: widget.modalTimelineIcon,
                            label: Text(widget.modalTimelineLabel),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              AdaptiveIncidentDeskMode.listDocked => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: widget.listFlex,
                      child: _IncidentDeskPanelCard(
                        title: widget.listTitle,
                        description: widget.listDescription,
                        leading: widget.listLeading,
                        padding: widget.listPadding,
                        boundedHeight: hasBoundedHeight,
                        child: _buildIncidentList(context),
                      ),
                    ),
                    SizedBox(width: widget.spacing),
                    Expanded(
                      flex: widget.detailFlex,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: hasBoundedHeight
                            ? MainAxisSize.max
                            : MainAxisSize.min,
                        children: [
                          if (hasBoundedHeight)
                            Expanded(child: detailSurface)
                          else
                            detailSurface,
                          SizedBox(height: widget.spacing),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              alignment: WrapAlignment.end,
                              children: [
                                FilledButton.tonalIcon(
                                  onPressed: () => _showContextSheet(context),
                                  icon: widget.modalContextIcon,
                                  label: Text(widget.modalContextLabel),
                                ),
                                FilledButton.tonalIcon(
                                  onPressed: () => _showTimelineSheet(context),
                                  icon: widget.modalTimelineIcon,
                                  label: Text(widget.modalTimelineLabel),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              AdaptiveIncidentDeskMode.sidePanelsDocked => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: widget.listFlex,
                      child: _IncidentDeskPanelCard(
                        title: widget.listTitle,
                        description: widget.listDescription,
                        leading: widget.listLeading,
                        padding: widget.listPadding,
                        boundedHeight: hasBoundedHeight,
                        child: _buildIncidentList(context),
                      ),
                    ),
                    SizedBox(width: widget.spacing),
                    Expanded(
                      flex: widget.detailFlex,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: hasBoundedHeight
                            ? MainAxisSize.max
                            : MainAxisSize.min,
                        children: [
                          if (hasBoundedHeight)
                            Expanded(child: detailSurface)
                          else
                            detailSurface,
                          SizedBox(height: widget.spacing),
                          Align(
                            alignment: Alignment.centerRight,
                            child: FilledButton.tonalIcon(
                              onPressed: () => _showTimelineSheet(context),
                              icon: widget.modalTimelineIcon,
                              label: Text(widget.modalTimelineLabel),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: widget.spacing),
                    Expanded(
                      flex: widget.contextFlex,
                      child: _IncidentDeskPanelCard(
                        title: widget.contextTitle,
                        description: widget.contextDescription,
                        leading: widget.contextLeading,
                        padding: widget.contextPadding,
                        boundedHeight: hasBoundedHeight,
                        child: widget.contextBuilder(context, _currentIncident),
                      ),
                    ),
                  ],
                ),
              AdaptiveIncidentDeskMode.fullyDocked => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: widget.listFlex,
                      child: _IncidentDeskPanelCard(
                        title: widget.listTitle,
                        description: widget.listDescription,
                        leading: widget.listLeading,
                        padding: widget.listPadding,
                        boundedHeight: hasBoundedHeight,
                        child: _buildIncidentList(context),
                      ),
                    ),
                    SizedBox(width: widget.spacing),
                    Expanded(
                      flex: widget.detailFlex,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: hasBoundedHeight
                            ? MainAxisSize.max
                            : MainAxisSize.min,
                        children: [
                          if (hasBoundedHeight)
                            Expanded(
                              flex: widget.detailPaneFlex,
                              child: detailSurface,
                            )
                          else
                            detailSurface,
                          SizedBox(height: widget.spacing),
                          if (hasBoundedHeight)
                            Expanded(
                              flex: widget.timelineFlex,
                              child: _IncidentDeskPanelCard(
                                title: widget.timelineTitle,
                                description: widget.timelineDescription,
                                leading: widget.timelineLeading,
                                padding: widget.timelinePadding,
                                boundedHeight: true,
                                child: widget.timelineBuilder(
                                    context, _currentIncident),
                              ),
                            )
                          else
                            _IncidentDeskPanelCard(
                              title: widget.timelineTitle,
                              description: widget.timelineDescription,
                              leading: widget.timelineLeading,
                              padding: widget.timelinePadding,
                              boundedHeight: false,
                              child: widget.timelineBuilder(
                                  context, _currentIncident),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(width: widget.spacing),
                    Expanded(
                      flex: widget.contextFlex,
                      child: _IncidentDeskPanelCard(
                        title: widget.contextTitle,
                        description: widget.contextDescription,
                        leading: widget.contextLeading,
                        padding: widget.contextPadding,
                        boundedHeight: hasBoundedHeight,
                        child: widget.contextBuilder(context, _currentIncident),
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

  AdaptiveIncidentDeskMode _modeForData(BreakPointData data) {
    final canDockList = data.adaptiveSize.index >= widget.listDockedAt.index &&
        data.adaptiveHeight.index >= widget.minimumListDockedHeight.index;
    final canDockContext = data.adaptiveSize.index >=
            widget.contextDockedAt.index &&
        data.adaptiveHeight.index >= widget.minimumContextDockedHeight.index;
    final canDockTimeline = data.adaptiveSize.index >=
            widget.timelineDockedAt.index &&
        data.adaptiveHeight.index >= widget.minimumTimelineDockedHeight.index;

    if (canDockList && canDockContext && canDockTimeline) {
      return AdaptiveIncidentDeskMode.fullyDocked;
    }
    if (canDockList && canDockContext) {
      return AdaptiveIncidentDeskMode.sidePanelsDocked;
    }
    if (canDockList) {
      return AdaptiveIncidentDeskMode.listDocked;
    }
    return AdaptiveIncidentDeskMode.modalPanels;
  }

  Widget _buildIncidentList(BuildContext context) {
    return ListView.separated(
      itemCount: widget.incidents.length,
      separatorBuilder: (context, index) =>
          SizedBox(height: widget.itemSpacing),
      itemBuilder: (context, index) {
        final incident = widget.incidents[index];
        return widget.itemBuilder(
          context,
          incident,
          index == _currentIndex,
          () => _selectIndex(index),
        );
      },
    );
  }

  void _selectIndex(int index) {
    if (!_isControlled) {
      setState(() {
        _internalIndex = index;
      });
    }
    widget.onSelectedIndexChanged?.call(index);
  }

  Future<void> _showListSheet(BuildContext context) {
    return _showPanelSheet(
      context: context,
      title: widget.listTitle,
      description: widget.listDescription,
      leading: widget.listLeading,
      child: _buildIncidentList(context),
    );
  }

  Future<void> _showContextSheet(BuildContext context) {
    return _showPanelSheet(
      context: context,
      title: widget.contextTitle,
      description: widget.contextDescription,
      leading: widget.contextLeading,
      child: widget.contextBuilder(context, _currentIncident),
    );
  }

  Future<void> _showTimelineSheet(BuildContext context) {
    return _showPanelSheet(
      context: context,
      title: widget.timelineTitle,
      description: widget.timelineDescription,
      leading: widget.timelineLeading,
      child: widget.timelineBuilder(context, _currentIncident),
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
      showDragHandle: widget.showModalDragHandle,
      builder: (sheetContext) {
        return FractionallySizedBox(
          heightFactor: widget.modalHeightFactor,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 8,
                bottom: 20 + MediaQuery.viewInsetsOf(sheetContext).bottom,
              ),
              child: _IncidentDeskPanelSurface(
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

class _IncidentDeskPanelCard extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? leading;
  final EdgeInsetsGeometry padding;
  final bool boundedHeight;
  final Widget child;

  const _IncidentDeskPanelCard({
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
        child: _IncidentDeskPanelSurface(
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

class _IncidentDeskDetailSurface extends StatelessWidget {
  final Widget? header;
  final bool boundedHeight;
  final EdgeInsetsGeometry padding;
  final Widget child;

  const _IncidentDeskDetailSurface({
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

class _IncidentDeskPanelSurface extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? leading;
  final bool boundedHeight;
  final Widget child;

  const _IncidentDeskPanelSurface({
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
