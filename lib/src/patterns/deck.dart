import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../container_layout.dart';
import '../media_query.dart';

/// The active arrangement used by [AdaptiveDeck].
enum AdaptiveDeckMode {
  pager,
  grid,
}

/// A single card shown by [AdaptiveDeck].
class AdaptiveDeckItem {
  /// Label shown in the card header.
  final String label;

  /// Optional supporting copy shown below [label].
  final String? description;

  /// Optional leading widget shown in the card header.
  final Widget? leading;

  /// Optional trailing widget shown in the card header.
  final Widget? trailing;

  /// Main content shown inside the card.
  final Widget child;

  /// Optional footer shown below [child].
  final Widget? footer;

  /// Optional tooltip used by compact indicators.
  final String? tooltip;

  /// Creates a deck item definition.
  const AdaptiveDeckItem({
    required this.label,
    required this.child,
    this.description,
    this.leading,
    this.trailing,
    this.footer,
    this.tooltip,
  });
}

/// A card deck that pages on compact layouts and expands into a grid on larger
/// containers.
class AdaptiveDeck extends StatefulWidget {
  /// Cards shown by the deck.
  final List<AdaptiveDeckItem> items;

  /// Semantic size at which the view should switch to grid mode.
  final AdaptiveSize gridAt;

  /// Minimum height class required before the view can switch to grid mode.
  final AdaptiveHeight minimumGridHeight;

  /// Whether to derive the active mode from parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should influence container-based breakpoint selection.
  final bool considerOrientation;

  /// Minimum width used by each card in grid mode.
  final double minColumnWidth;

  /// Space between adjacent columns.
  final double columnSpacing;

  /// Space between adjacent rows in grid mode.
  final double rowSpacing;

  /// Fixed height used by the compact pager.
  final double compactHeight;

  /// Fraction of the viewport occupied by each compact page.
  final double compactViewportFraction;

  /// Space between compact pages and below the pager.
  final double pageSpacing;

  /// Padding applied inside each card.
  final EdgeInsetsGeometry cardPadding;

  /// Initial selected page when the widget is first built.
  final int initialIndex;

  /// Called when the compact pager changes the active page.
  final ValueChanged<int>? onSelectedIndexChanged;

  /// Whether compact mode should show a page indicator.
  final bool showPageIndicator;

  /// Whether transitions should animate.
  final bool animateTransitions;

  /// Duration used by animations.
  final Duration transitionDuration;

  /// Curve used by animations.
  final Curve transitionCurve;

  /// Creates an adaptive deck surface.
  const AdaptiveDeck({
    super.key,
    required this.items,
    this.gridAt = AdaptiveSize.medium,
    this.minimumGridHeight = AdaptiveHeight.compact,
    this.useContainerConstraints = true,
    this.considerOrientation = false,
    this.minColumnWidth = 280,
    this.columnSpacing = 16,
    this.rowSpacing = 16,
    this.compactHeight = 320,
    this.compactViewportFraction = 0.9,
    this.pageSpacing = 16,
    this.cardPadding = const EdgeInsets.all(16),
    this.initialIndex = 0,
    this.onSelectedIndexChanged,
    this.showPageIndicator = true,
    this.animateTransitions = true,
    this.transitionDuration = const Duration(milliseconds: 250),
    this.transitionCurve = Curves.easeInOutCubic,
  })  : assert(minColumnWidth > 0, 'minColumnWidth must be greater than zero.'),
        assert(columnSpacing >= 0, 'columnSpacing must be zero or greater.'),
        assert(rowSpacing >= 0, 'rowSpacing must be zero or greater.'),
        assert(compactHeight > 0, 'compactHeight must be greater than zero.'),
        assert(
          compactViewportFraction > 0 && compactViewportFraction <= 1,
          'compactViewportFraction must be between 0 and 1.',
        ),
        assert(pageSpacing >= 0, 'pageSpacing must be zero or greater.');

  @override
  State<AdaptiveDeck> createState() => _AdaptiveDeckState();
}

class _AdaptiveDeckState extends State<AdaptiveDeck> {
  late int _currentIndex;
  late PageController _pageController;

  int get _maxIndex {
    if (widget.items.isEmpty) {
      return 0;
    }
    return widget.items.length - 1;
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = _clampIndex(widget.initialIndex);
    _pageController = _createPageController();
  }

  @override
  void didUpdateWidget(covariant AdaptiveDeck oldWidget) {
    super.didUpdateWidget(oldWidget);

    final clampedIndex = _clampIndex(_currentIndex);
    if (clampedIndex != _currentIndex) {
      _currentIndex = clampedIndex;
      if (_pageController.hasClients) {
        _pageController.jumpToPage(_currentIndex);
      }
    }

    if (oldWidget.compactViewportFraction == widget.compactViewportFraction) {
      return;
    }

    final oldController = _pageController;
    _pageController = _createPageController();
    oldController.dispose();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
          AdaptiveDeckMode.pager => _CompactDeckLayout(
              controller: _pageController,
              items: widget.items,
              currentIndex: _currentIndex,
              compactHeight: widget.compactHeight,
              pageSpacing: widget.pageSpacing,
              cardPadding: widget.cardPadding,
              showPageIndicator: widget.showPageIndicator,
              transitionDuration: widget.transitionDuration,
              transitionCurve: widget.transitionCurve,
              onPageChanged: _handlePageChanged,
              onIndicatorSelected: _animateToIndex,
            ),
          AdaptiveDeckMode.grid => LayoutBuilder(
              builder: (context, constraints) {
                if (!constraints.maxWidth.isFinite) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var index = 0;
                            index < widget.items.length;
                            index++)
                          Padding(
                            padding: EdgeInsets.only(
                              right: index == widget.items.length - 1
                                  ? 0
                                  : widget.columnSpacing,
                            ),
                            child: SizedBox(
                              width: widget.minColumnWidth,
                              child: _DeckCard(
                                item: widget.items[index],
                                padding: widget.cardPadding,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }

                final columnCount = _gridColumnCount(constraints.maxWidth);
                final totalSpacing = widget.columnSpacing * (columnCount - 1);
                final itemWidth =
                    (constraints.maxWidth - totalSpacing) / columnCount;

                return SingleChildScrollView(
                  child: Wrap(
                    spacing: widget.columnSpacing,
                    runSpacing: widget.rowSpacing,
                    children: [
                      for (final item in widget.items)
                        SizedBox(
                          width: itemWidth,
                          child: _DeckCard(
                            item: item,
                            padding: widget.cardPadding,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
        },
      ),
    );
  }

  int _clampIndex(int index) {
    if (index < 0) {
      return 0;
    }
    if (index > _maxIndex) {
      return _maxIndex;
    }
    return index;
  }

  PageController _createPageController() {
    return PageController(
      initialPage: _currentIndex,
      viewportFraction: widget.compactViewportFraction,
    );
  }

  int _gridColumnCount(double availableWidth) {
    final rawCount = ((availableWidth + widget.columnSpacing) /
            (widget.minColumnWidth + widget.columnSpacing))
        .floor();
    return math.max(1, math.min(widget.items.length, rawCount));
  }

  AdaptiveDeckMode _modeForData(BreakPointData data) {
    final isWideEnough = data.adaptiveSize.index >= widget.gridAt.index;
    final isTallEnough =
        data.adaptiveHeight.index >= widget.minimumGridHeight.index;

    return isWideEnough && isTallEnough
        ? AdaptiveDeckMode.grid
        : AdaptiveDeckMode.pager;
  }

  void _animateToIndex(int index) {
    final targetIndex = _clampIndex(index);
    if (targetIndex == _currentIndex) {
      return;
    }

    if (_pageController.hasClients) {
      _pageController.animateToPage(
        targetIndex,
        duration: widget.transitionDuration,
        curve: widget.transitionCurve,
      );
      return;
    }

    _handlePageChanged(targetIndex);
  }

  void _handlePageChanged(int index) {
    final targetIndex = _clampIndex(index);
    if (targetIndex == _currentIndex) {
      return;
    }

    setState(() {
      _currentIndex = targetIndex;
    });
    widget.onSelectedIndexChanged?.call(targetIndex);
  }
}

class _CompactDeckLayout extends StatelessWidget {
  final PageController controller;
  final List<AdaptiveDeckItem> items;
  final int currentIndex;
  final double compactHeight;
  final double pageSpacing;
  final EdgeInsetsGeometry cardPadding;
  final bool showPageIndicator;
  final Duration transitionDuration;
  final Curve transitionCurve;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onIndicatorSelected;

  const _CompactDeckLayout({
    required this.controller,
    required this.items,
    required this.currentIndex,
    required this.compactHeight,
    required this.pageSpacing,
    required this.cardPadding,
    required this.showPageIndicator,
    required this.transitionDuration,
    required this.transitionCurve,
    required this.onPageChanged,
    required this.onIndicatorSelected,
  });

  @override
  Widget build(BuildContext context) {
    final pager = PageView.builder(
      controller: controller,
      itemCount: items.length,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: pageSpacing / 2),
          child: _DeckCard(
            item: items[index],
            padding: cardPadding,
            scrollBody: true,
          ),
        );
      },
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final hasBoundedHeight = constraints.maxHeight.isFinite;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (hasBoundedHeight)
              Expanded(child: pager)
            else
              SizedBox(
                height: compactHeight,
                child: pager,
              ),
            if (showPageIndicator && items.length > 1) ...[
              SizedBox(height: pageSpacing),
              Center(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (var index = 0; index < items.length; index++)
                      Tooltip(
                        message: items[index].tooltip ?? items[index].label,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(999),
                          onTap: () => onIndicatorSelected(index),
                          child: AnimatedContainer(
                            duration: transitionDuration,
                            curve: transitionCurve,
                            width: index == currentIndex ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: index == currentIndex
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context)
                                      .colorScheme
                                      .outlineVariant,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _DeckCard extends StatelessWidget {
  final AdaptiveDeckItem item;
  final EdgeInsetsGeometry padding;
  final bool scrollBody;

  const _DeckCard({
    required this.item,
    required this.padding,
    this.scrollBody = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
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
                mainAxisSize: MainAxisSize.min,
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
