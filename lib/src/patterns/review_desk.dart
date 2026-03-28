import 'package:flutter/material.dart';

import '../container_layout.dart';
import '../media_query.dart';

/// The active arrangement used by [AdaptiveReviewDesk].
enum AdaptiveReviewDeskMode {
  modalPanels,
  queueDocked,
  fullyDocked,
}

/// A staged review workspace that coordinates a review queue, a central review
/// surface, and a decision panel from one adaptive layout model.
class AdaptiveReviewDesk<T> extends StatefulWidget {
  /// Review items shown in the queue.
  final List<T> items;

  /// Builds an individual queue item.
  final Widget Function(
    BuildContext context,
    T item,
    bool selected,
    VoidCallback onTap,
  ) itemBuilder;

  /// Builds the central review content for the selected item.
  final Widget Function(BuildContext context, T item) reviewBuilder;

  /// Builds the decision or notes panel for the selected item.
  final Widget Function(BuildContext context, T item) decisionBuilder;

  /// Optional header shown above the review surface.
  final Widget? header;

  /// Optional empty state shown when [items] is empty.
  final Widget? emptyState;

  /// Title shown above the queue surface.
  final String queueTitle;

  /// Optional description shown below [queueTitle].
  final String? queueDescription;

  /// Optional leading widget shown beside [queueTitle].
  final Widget? queueLeading;

  /// Title shown above the decision surface.
  final String decisionTitle;

  /// Optional description shown below [decisionTitle].
  final String? decisionDescription;

  /// Optional leading widget shown beside [decisionTitle].
  final Widget? decisionLeading;

  /// Label used by the compact queue trigger.
  final String modalQueueLabel;

  /// Icon used by the compact queue trigger.
  final Widget modalQueueIcon;

  /// Label used by the compact decision trigger.
  final String modalDecisionLabel;

  /// Icon used by the compact decision trigger.
  final Widget modalDecisionIcon;

  /// Semantic size at which the queue should dock inline.
  final AdaptiveSize queueDockedAt;

  /// Semantic size at which the decision panel should dock inline.
  final AdaptiveSize decisionDockedAt;

  /// Minimum height class required before the queue can dock inline.
  final AdaptiveHeight minimumQueueDockedHeight;

  /// Minimum height class required before the decision panel can dock inline.
  final AdaptiveHeight minimumDecisionDockedHeight;

  /// Whether to derive layout decisions from parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should influence container-based breakpoint selection.
  final bool considerOrientation;

  /// Optional controlled selected item index.
  final int? selectedIndex;

  /// Initial selected item index for uncontrolled usage.
  final int initialIndex;

  /// Called when the selected item changes.
  final ValueChanged<int>? onSelectedIndexChanged;

  /// Space between adjacent workbench regions.
  final double spacing;

  /// Space between adjacent queue items.
  final double itemSpacing;

  /// Flex used by the docked queue region.
  final int queueFlex;

  /// Flex used by the review region.
  final int reviewFlex;

  /// Flex used by the docked decision region.
  final int decisionFlex;

  /// Padding applied inside the queue surface.
  final EdgeInsetsGeometry queuePadding;

  /// Padding applied inside the review surface.
  final EdgeInsetsGeometry reviewPadding;

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

  /// Creates an adaptive review desk.
  const AdaptiveReviewDesk({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.reviewBuilder,
    required this.decisionBuilder,
    required this.queueTitle,
    required this.decisionTitle,
    this.header,
    this.emptyState,
    this.queueDescription,
    this.queueLeading,
    this.decisionDescription,
    this.decisionLeading,
    this.modalQueueLabel = 'Open queue',
    this.modalQueueIcon = const Icon(Icons.playlist_play_outlined),
    this.modalDecisionLabel = 'Open decision',
    this.modalDecisionIcon = const Icon(Icons.rule_outlined),
    this.queueDockedAt = AdaptiveSize.medium,
    this.decisionDockedAt = AdaptiveSize.expanded,
    this.minimumQueueDockedHeight = AdaptiveHeight.compact,
    this.minimumDecisionDockedHeight = AdaptiveHeight.medium,
    this.useContainerConstraints = true,
    this.considerOrientation = false,
    this.selectedIndex,
    this.initialIndex = 0,
    this.onSelectedIndexChanged,
    this.spacing = 16,
    this.itemSpacing = 12,
    this.queueFlex = 2,
    this.reviewFlex = 4,
    this.decisionFlex = 2,
    this.queuePadding = const EdgeInsets.all(16),
    this.reviewPadding = const EdgeInsets.all(16),
    this.decisionPadding = const EdgeInsets.all(16),
    this.modalHeightFactor = 0.72,
    this.showModalDragHandle = true,
    this.animateSize = true,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeInOutCubic,
  })  : assert(spacing >= 0, 'spacing must be zero or greater.'),
        assert(itemSpacing >= 0, 'itemSpacing must be zero or greater.'),
        assert(queueFlex > 0, 'queueFlex must be greater than zero.'),
        assert(reviewFlex > 0, 'reviewFlex must be greater than zero.'),
        assert(decisionFlex > 0, 'decisionFlex must be greater than zero.'),
        assert(
          modalHeightFactor > 0 && modalHeightFactor <= 1,
          'modalHeightFactor must be between 0 and 1.',
        );

  @override
  State<AdaptiveReviewDesk<T>> createState() => _AdaptiveReviewDeskState<T>();
}

class _AdaptiveReviewDeskState<T> extends State<AdaptiveReviewDesk<T>> {
  late int _internalIndex = widget.initialIndex;

  bool get _isControlled => widget.selectedIndex != null;

  int get _maxIndex {
    if (widget.items.isEmpty) {
      return 0;
    }
    return widget.items.length - 1;
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

  T get _currentItem => widget.items[_currentIndex];

  @override
  void didUpdateWidget(covariant AdaptiveReviewDesk<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isControlled || widget.items.isEmpty) {
      return;
    }
    if (_internalIndex > _maxIndex) {
      _internalIndex = _maxIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
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
        final reviewSurface = _ReviewDeskReviewSurface(
          header: widget.header,
          boundedHeight: hasBoundedHeight,
          padding: widget.reviewPadding,
          child: widget.reviewBuilder(context, _currentItem),
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
              AdaptiveReviewDeskMode.modalPanels => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (hasBoundedHeight)
                      Expanded(child: reviewSurface)
                    else
                      reviewSurface,
                    SizedBox(height: widget.spacing),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.end,
                        children: [
                          FilledButton.tonalIcon(
                            onPressed: () => _showQueueSheet(context),
                            icon: widget.modalQueueIcon,
                            label: Text(widget.modalQueueLabel),
                          ),
                          FilledButton.tonalIcon(
                            onPressed: () => _showDecisionSheet(context),
                            icon: widget.modalDecisionIcon,
                            label: Text(widget.modalDecisionLabel),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              AdaptiveReviewDeskMode.queueDocked => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: widget.queueFlex,
                      child: _ReviewDeskPanelCard(
                        title: widget.queueTitle,
                        description: widget.queueDescription,
                        leading: widget.queueLeading,
                        padding: widget.queuePadding,
                        boundedHeight: hasBoundedHeight,
                        child: _ReviewDeskQueueSurface<T>(
                          items: widget.items,
                          currentIndex: _currentIndex,
                          itemSpacing: widget.itemSpacing,
                          boundedHeight: hasBoundedHeight,
                          itemBuilder: (context, item, selected) =>
                              widget.itemBuilder(
                            context,
                            item,
                            selected,
                            () => _selectItem(widget.items.indexOf(item)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: widget.spacing),
                    Expanded(
                      flex: widget.reviewFlex,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (hasBoundedHeight)
                            Expanded(child: reviewSurface)
                          else
                            reviewSurface,
                          SizedBox(height: widget.spacing),
                          Align(
                            alignment: Alignment.centerRight,
                            child: FilledButton.tonalIcon(
                              onPressed: () => _showDecisionSheet(context),
                              icon: widget.modalDecisionIcon,
                              label: Text(widget.modalDecisionLabel),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              AdaptiveReviewDeskMode.fullyDocked => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: widget.queueFlex,
                      child: _ReviewDeskPanelCard(
                        title: widget.queueTitle,
                        description: widget.queueDescription,
                        leading: widget.queueLeading,
                        padding: widget.queuePadding,
                        boundedHeight: hasBoundedHeight,
                        child: _ReviewDeskQueueSurface<T>(
                          items: widget.items,
                          currentIndex: _currentIndex,
                          itemSpacing: widget.itemSpacing,
                          boundedHeight: hasBoundedHeight,
                          itemBuilder: (context, item, selected) =>
                              widget.itemBuilder(
                            context,
                            item,
                            selected,
                            () => _selectItem(widget.items.indexOf(item)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: widget.spacing),
                    Expanded(
                      flex: widget.reviewFlex,
                      child: reviewSurface,
                    ),
                    SizedBox(width: widget.spacing),
                    Expanded(
                      flex: widget.decisionFlex,
                      child: _ReviewDeskPanelCard(
                        title: widget.decisionTitle,
                        description: widget.decisionDescription,
                        leading: widget.decisionLeading,
                        padding: widget.decisionPadding,
                        boundedHeight: hasBoundedHeight,
                        child: widget.decisionBuilder(context, _currentItem),
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

  AdaptiveReviewDeskMode _modeForData(BreakPointData data) {
    final canDockQueue =
        data.adaptiveSize.index >= widget.queueDockedAt.index &&
            data.adaptiveHeight.index >= widget.minimumQueueDockedHeight.index;
    final canDockDecision = data.adaptiveSize.index >=
            widget.decisionDockedAt.index &&
        data.adaptiveHeight.index >= widget.minimumDecisionDockedHeight.index;

    if (canDockQueue && canDockDecision) {
      return AdaptiveReviewDeskMode.fullyDocked;
    }
    if (canDockQueue) {
      return AdaptiveReviewDeskMode.queueDocked;
    }
    return AdaptiveReviewDeskMode.modalPanels;
  }

  void _selectItem(int index) {
    if (index < 0 || index > _maxIndex || index == _currentIndex) {
      return;
    }

    widget.onSelectedIndexChanged?.call(index);
    if (_isControlled) {
      return;
    }

    setState(() {
      _internalIndex = index;
    });
  }

  Future<void> _showQueueSheet(BuildContext context) {
    return _showPanelSheet(
      context: context,
      title: widget.queueTitle,
      description: widget.queueDescription,
      leading: widget.queueLeading,
      child: _ReviewDeskQueueSurface<T>(
        items: widget.items,
        currentIndex: _currentIndex,
        itemSpacing: widget.itemSpacing,
        boundedHeight: true,
        itemBuilder: (context, item, selected) => widget.itemBuilder(
          context,
          item,
          selected,
          () {
            Navigator.of(context).pop();
            _selectItem(widget.items.indexOf(item));
          },
        ),
      ),
    );
  }

  Future<void> _showDecisionSheet(BuildContext context) {
    return _showPanelSheet(
      context: context,
      title: widget.decisionTitle,
      description: widget.decisionDescription,
      leading: widget.decisionLeading,
      child: widget.decisionBuilder(context, _currentItem),
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
              child: _ReviewDeskPanelSurface(
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

class _ReviewDeskPanelCard extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? leading;
  final EdgeInsetsGeometry padding;
  final bool boundedHeight;
  final Widget child;

  const _ReviewDeskPanelCard({
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
        child: _ReviewDeskPanelSurface(
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

class _ReviewDeskReviewSurface extends StatelessWidget {
  final Widget? header;
  final bool boundedHeight;
  final EdgeInsetsGeometry padding;
  final Widget child;

  const _ReviewDeskReviewSurface({
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

class _ReviewDeskPanelSurface extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? leading;
  final bool boundedHeight;
  final Widget child;

  const _ReviewDeskPanelSurface({
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

class _ReviewDeskQueueSurface<T> extends StatelessWidget {
  final List<T> items;
  final int currentIndex;
  final double itemSpacing;
  final bool boundedHeight;
  final Widget Function(BuildContext context, T item, bool selected)
      itemBuilder;

  const _ReviewDeskQueueSurface({
    required this.items,
    required this.currentIndex,
    required this.itemSpacing,
    required this.itemBuilder,
    this.boundedHeight = false,
  });

  @override
  Widget build(BuildContext context) {
    if (boundedHeight) {
      return ListView.separated(
        itemCount: items.length,
        itemBuilder: (context, index) =>
            itemBuilder(context, items[index], index == currentIndex),
        separatorBuilder: (context, index) => SizedBox(height: itemSpacing),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < items.length; index++) ...[
          itemBuilder(context, items[index], index == currentIndex),
          if (index < items.length - 1) SizedBox(height: itemSpacing),
        ],
      ],
    );
  }
}
