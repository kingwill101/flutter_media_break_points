import 'package:flutter/material.dart';

import '../container_layout.dart';
import '../media_query.dart';

/// The active arrangement used by [AdaptiveComparison].
enum AdaptiveComparisonMode {
  compact,
  columns,
}

/// A single option or variant shown by [AdaptiveComparison].
class AdaptiveComparisonItem {
  /// Label shown in the compact selector and the card header.
  final String label;

  /// Optional supporting description shown below the label.
  final String? description;

  /// Optional leading widget shown in the selector and card header.
  final Widget? leading;

  /// Optional trailing widget shown in the card header.
  final Widget? trailing;

  /// Main content shown inside the card.
  final Widget child;

  /// Optional footer shown below [child].
  final Widget? footer;

  /// Optional tooltip used by the compact selector.
  final String? tooltip;

  /// Creates a comparison item definition.
  const AdaptiveComparisonItem({
    required this.label,
    required this.child,
    this.description,
    this.leading,
    this.trailing,
    this.footer,
    this.tooltip,
  });
}

/// A comparison surface that shows one selected variant on compact layouts and
/// all variants side by side on larger layouts.
class AdaptiveComparison extends StatefulWidget {
  /// Items shown by the comparison surface.
  final List<AdaptiveComparisonItem> items;

  /// Semantic size at which the view should switch to column mode.
  final AdaptiveSize columnsAt;

  /// Minimum height class required before the view can switch to column mode.
  final AdaptiveHeight minimumColumnsHeight;

  /// Whether to derive the active mode from parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should influence container-based breakpoint selection.
  final bool considerOrientation;

  /// Minimum width used by each comparison column in wide mode.
  final double minColumnWidth;

  /// Space between adjacent columns.
  final double columnSpacing;

  /// Space between the compact selector and the active item.
  final double selectorSpacing;

  /// Padding applied inside each comparison card.
  final EdgeInsetsGeometry cardPadding;

  /// Optional controlled selected item index.
  final int? selectedIndex;

  /// Initial selected item index for uncontrolled usage.
  final int initialIndex;

  /// Called when the compact selection changes.
  final ValueChanged<int>? onSelectedIndexChanged;

  /// Whether transitions should animate.
  final bool animateTransitions;

  /// Duration used by animations.
  final Duration transitionDuration;

  /// Curve used by animations.
  final Curve transitionCurve;

  /// Creates an adaptive comparison surface.
  const AdaptiveComparison({
    super.key,
    required this.items,
    this.columnsAt = AdaptiveSize.medium,
    this.minimumColumnsHeight = AdaptiveHeight.compact,
    this.useContainerConstraints = true,
    this.considerOrientation = false,
    this.minColumnWidth = 260,
    this.columnSpacing = 16,
    this.selectorSpacing = 16,
    this.cardPadding = const EdgeInsets.all(16),
    this.selectedIndex,
    this.initialIndex = 0,
    this.onSelectedIndexChanged,
    this.animateTransitions = true,
    this.transitionDuration = const Duration(milliseconds: 250),
    this.transitionCurve = Curves.easeInOutCubic,
  });

  @override
  State<AdaptiveComparison> createState() => _AdaptiveComparisonState();
}

class _AdaptiveComparisonState extends State<AdaptiveComparison> {
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

  @override
  void didUpdateWidget(covariant AdaptiveComparison oldWidget) {
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
      return const SizedBox.shrink();
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

    if (!widget.animateTransitions) {
      return child;
    }

    return AnimatedSize(
      duration: widget.transitionDuration,
      curve: widget.transitionCurve,
      alignment: Alignment.topCenter,
      child: child,
    );
  }

  Widget _buildForData(BuildContext context, BreakPointData data) {
    final mode = _modeForData(data);

    return AnimatedSwitcher(
      duration: widget.transitionDuration,
      switchInCurve: widget.transitionCurve,
      switchOutCurve: widget.transitionCurve.flipped,
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
          AdaptiveComparisonMode.compact => _CompactComparisonLayout(
              items: widget.items,
              currentIndex: _currentIndex,
              onSelectedIndexChanged: _setSelectedIndex,
              selectorSpacing: widget.selectorSpacing,
              cardPadding: widget.cardPadding,
            ),
          AdaptiveComparisonMode.columns => LayoutBuilder(
              builder: (context, constraints) {
                final availableWidth = constraints.maxWidth.isFinite
                    ? constraints.maxWidth
                    : widget.items.length * widget.minColumnWidth;
                final totalSpacing =
                    widget.columnSpacing * (widget.items.length - 1);
                final evenWidth =
                    (availableWidth - totalSpacing) / widget.items.length;
                final canFitWithoutScroll = constraints.maxWidth.isFinite &&
                    evenWidth >= widget.minColumnWidth;
                final boundedHeight = constraints.maxHeight.isFinite
                    ? constraints.maxHeight
                    : null;

                return canFitWithoutScroll
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var index = 0;
                              index < widget.items.length;
                              index++) ...[
                            Expanded(
                              child: SizedBox(
                                height: boundedHeight,
                                child: _ComparisonCard(
                                  item: widget.items[index],
                                  padding: widget.cardPadding,
                                  scrollBody: boundedHeight != null,
                                ),
                              ),
                            ),
                            if (index < widget.items.length - 1)
                              SizedBox(width: widget.columnSpacing),
                          ],
                        ],
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var index = 0;
                                index < widget.items.length;
                                index++) ...[
                              SizedBox(
                                width: widget.minColumnWidth,
                                height: boundedHeight,
                                child: _ComparisonCard(
                                  item: widget.items[index],
                                  padding: widget.cardPadding,
                                  scrollBody: boundedHeight != null,
                                ),
                              ),
                              if (index < widget.items.length - 1)
                                SizedBox(width: widget.columnSpacing),
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

  AdaptiveComparisonMode _modeForData(BreakPointData data) {
    final isWideEnough = data.adaptiveSize.index >= widget.columnsAt.index;
    final isTallEnough =
        data.adaptiveHeight.index >= widget.minimumColumnsHeight.index;

    return isWideEnough && isTallEnough
        ? AdaptiveComparisonMode.columns
        : AdaptiveComparisonMode.compact;
  }

  void _setSelectedIndex(int index) {
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
}

class _CompactComparisonLayout extends StatelessWidget {
  final List<AdaptiveComparisonItem> items;
  final int currentIndex;
  final ValueChanged<int> onSelectedIndexChanged;
  final double selectorSpacing;
  final EdgeInsetsGeometry cardPadding;

  const _CompactComparisonLayout({
    required this.items,
    required this.currentIndex,
    required this.onSelectedIndexChanged,
    required this.selectorSpacing,
    required this.cardPadding,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SegmentedButton<int>(
              showSelectedIcon: false,
              segments: [
                for (var index = 0; index < items.length; index++)
                  ButtonSegment<int>(
                    value: index,
                    icon: items[index].leading,
                    label: Text(items[index].label),
                    tooltip: items[index].tooltip,
                  ),
              ],
              selected: {currentIndex},
              onSelectionChanged: (selection) {
                if (selection.isEmpty) {
                  return;
                }
                onSelectedIndexChanged(selection.first);
              },
            ),
          ),
          SizedBox(height: selectorSpacing),
          _ComparisonCard(
            item: items[currentIndex],
            padding: cardPadding,
          ),
        ],
      ),
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  final AdaptiveComparisonItem item;
  final EdgeInsetsGeometry padding;
  final bool scrollBody;

  const _ComparisonCard({
    required this.item,
    required this.padding,
    this.scrollBody = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.leading != null) ...[
              item.leading!,
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  if (item.description != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      item.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
            if (item.trailing != null) ...[
              const SizedBox(width: 12),
              item.trailing!,
            ],
          ],
        ),
        const SizedBox(height: 16),
        item.child,
        if (item.footer != null) ...[
          const SizedBox(height: 16),
          item.footer!,
        ],
      ],
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding,
        child: scrollBody ? SingleChildScrollView(child: content) : content,
      ),
    );
  }
}
