import 'package:flutter/material.dart';

import '../container_layout.dart';
import '../media_query.dart';

/// The active arrangement used by [AdaptiveGallery].
enum AdaptiveGalleryMode {
  carousel,
  spotlight,
}

/// A single entry shown by [AdaptiveGallery].
class AdaptiveGalleryItem {
  /// Label shown in the card header and selector list.
  final String label;

  /// Optional supporting copy shown below [label].
  final String? description;

  /// Optional leading widget shown in the selector row.
  final Widget? leading;

  /// Optional trailing widget shown in the card header and selector row.
  final Widget? trailing;

  /// Optional compact visual used by the selector list.
  final Widget? thumbnail;

  /// Main visual preview shown by the gallery card.
  final Widget preview;

  /// Supporting details shown below [preview].
  final Widget child;

  /// Optional footer shown below [child].
  final Widget? footer;

  /// Optional tooltip used by compact indicators and selector rows.
  final String? tooltip;

  /// Creates a gallery item definition.
  const AdaptiveGalleryItem({
    required this.label,
    required this.preview,
    required this.child,
    this.description,
    this.leading,
    this.trailing,
    this.thumbnail,
    this.footer,
    this.tooltip,
  });
}

/// A showcase surface that pages through rich previews on compact layouts and
/// switches to a spotlight view with a selector list on larger containers.
class AdaptiveGallery extends StatefulWidget {
  /// Items shown by the gallery.
  final List<AdaptiveGalleryItem> items;

  /// Semantic size at which the view should switch to spotlight mode.
  final AdaptiveSize spotlightAt;

  /// Minimum height class required before the view can switch to spotlight
  /// mode.
  final AdaptiveHeight minimumSpotlightHeight;

  /// Whether to derive the active mode from parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should influence container-based breakpoint selection.
  final bool considerOrientation;

  /// Width used by the selector list in spotlight mode.
  final double selectorWidth;

  /// Flex used by the spotlight card when both regions are visible.
  final int previewFlex;

  /// Space between the spotlight card and selector list.
  final double spacing;

  /// Space between the preview and details inside the gallery card.
  final double previewSpacing;

  /// Space between selector rows.
  final double selectorItemSpacing;

  /// Fixed height used by the compact carousel.
  final double compactHeight;

  /// Fraction of the viewport occupied by each compact page.
  final double compactViewportFraction;

  /// Space between compact pages and below the pager.
  final double pageSpacing;

  /// Padding applied inside cards and the selector surface.
  final EdgeInsetsGeometry cardPadding;

  /// Initial selected index when the widget is first built.
  final int initialIndex;

  /// Called when the active item changes.
  final ValueChanged<int>? onSelectedIndexChanged;

  /// Whether compact mode should show a page indicator.
  final bool showPageIndicator;

  /// Whether transitions should animate.
  final bool animateTransitions;

  /// Duration used by animations.
  final Duration transitionDuration;

  /// Curve used by animations.
  final Curve transitionCurve;

  /// Creates an adaptive gallery surface.
  const AdaptiveGallery({
    super.key,
    required this.items,
    this.spotlightAt = AdaptiveSize.medium,
    this.minimumSpotlightHeight = AdaptiveHeight.compact,
    this.useContainerConstraints = true,
    this.considerOrientation = false,
    this.selectorWidth = 240,
    this.previewFlex = 3,
    this.spacing = 16,
    this.previewSpacing = 16,
    this.selectorItemSpacing = 12,
    this.compactHeight = 380,
    this.compactViewportFraction = 0.92,
    this.pageSpacing = 16,
    this.cardPadding = const EdgeInsets.all(16),
    this.initialIndex = 0,
    this.onSelectedIndexChanged,
    this.showPageIndicator = true,
    this.animateTransitions = true,
    this.transitionDuration = const Duration(milliseconds: 250),
    this.transitionCurve = Curves.easeInOutCubic,
  })  : assert(selectorWidth > 0, 'selectorWidth must be greater than zero.'),
        assert(previewFlex > 0, 'previewFlex must be greater than zero.'),
        assert(spacing >= 0, 'spacing must be zero or greater.'),
        assert(previewSpacing >= 0, 'previewSpacing must be zero or greater.'),
        assert(
          selectorItemSpacing >= 0,
          'selectorItemSpacing must be zero or greater.',
        ),
        assert(compactHeight > 0, 'compactHeight must be greater than zero.'),
        assert(
          compactViewportFraction > 0 && compactViewportFraction <= 1,
          'compactViewportFraction must be between 0 and 1.',
        ),
        assert(pageSpacing >= 0, 'pageSpacing must be zero or greater.');

  @override
  State<AdaptiveGallery> createState() => _AdaptiveGalleryState();
}

class _AdaptiveGalleryState extends State<AdaptiveGallery> {
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
  void didUpdateWidget(covariant AdaptiveGallery oldWidget) {
    super.didUpdateWidget(oldWidget);

    final clampedIndex = _clampIndex(_currentIndex);
    if (clampedIndex != _currentIndex) {
      _currentIndex = clampedIndex;
      _replacePageController();
    }

    if (oldWidget.compactViewportFraction != widget.compactViewportFraction) {
      _replacePageController();
    }
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
    final currentItem = widget.items[_currentIndex];

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
          AdaptiveGalleryMode.carousel => _CompactGalleryLayout(
              controller: _pageController,
              items: widget.items,
              currentIndex: _currentIndex,
              compactHeight: widget.compactHeight,
              pageSpacing: widget.pageSpacing,
              previewSpacing: widget.previewSpacing,
              cardPadding: widget.cardPadding,
              showPageIndicator: widget.showPageIndicator,
              transitionDuration: widget.transitionDuration,
              transitionCurve: widget.transitionCurve,
              onPageChanged: _handlePageChanged,
              onIndicatorSelected: _animateToIndex,
            ),
          AdaptiveGalleryMode.spotlight => LayoutBuilder(
              builder: (context, constraints) {
                final hasBoundedHeight = constraints.maxHeight.isFinite;
                final spotlightCard = _GalleryCard(
                  item: currentItem,
                  previewSpacing: widget.previewSpacing,
                  padding: widget.cardPadding,
                  scrollBody: hasBoundedHeight,
                );
                final selector = _GallerySelectorList(
                  items: widget.items,
                  currentIndex: _currentIndex,
                  itemSpacing: widget.selectorItemSpacing,
                  padding: widget.cardPadding,
                  onSelected: _setSelectedIndex,
                );

                if (!constraints.maxWidth.isFinite) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      spotlightCard,
                      SizedBox(height: widget.spacing),
                      selector,
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: widget.previewFlex,
                      child: SizedBox(
                        height: hasBoundedHeight ? constraints.maxHeight : null,
                        child: spotlightCard,
                      ),
                    ),
                    SizedBox(width: widget.spacing),
                    SizedBox(
                      width: widget.selectorWidth,
                      height: hasBoundedHeight ? constraints.maxHeight : null,
                      child: selector,
                    ),
                  ],
                );
              },
            ),
        },
      ),
    );
  }

  PageController _createPageController() {
    return PageController(
      initialPage: _currentIndex,
      viewportFraction: widget.compactViewportFraction,
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

  AdaptiveGalleryMode _modeForData(BreakPointData data) {
    final isWideEnough = data.adaptiveSize.index >= widget.spotlightAt.index;
    final isTallEnough =
        data.adaptiveHeight.index >= widget.minimumSpotlightHeight.index;

    return isWideEnough && isTallEnough
        ? AdaptiveGalleryMode.spotlight
        : AdaptiveGalleryMode.carousel;
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

    _setSelectedIndex(targetIndex);
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

  void _replacePageController() {
    final oldController = _pageController;
    _pageController = _createPageController();
    oldController.dispose();
  }

  void _setSelectedIndex(int index) {
    final targetIndex = _clampIndex(index);
    if (targetIndex == _currentIndex) {
      return;
    }

    setState(() {
      _currentIndex = targetIndex;
      if (!_pageController.hasClients) {
        _replacePageController();
      }
    });
    widget.onSelectedIndexChanged?.call(targetIndex);
  }
}

class _CompactGalleryLayout extends StatelessWidget {
  final PageController controller;
  final List<AdaptiveGalleryItem> items;
  final int currentIndex;
  final double compactHeight;
  final double pageSpacing;
  final double previewSpacing;
  final EdgeInsetsGeometry cardPadding;
  final bool showPageIndicator;
  final Duration transitionDuration;
  final Curve transitionCurve;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onIndicatorSelected;

  const _CompactGalleryLayout({
    required this.controller,
    required this.items,
    required this.currentIndex,
    required this.compactHeight,
    required this.pageSpacing,
    required this.previewSpacing,
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
          child: _GalleryCard(
            item: items[index],
            previewSpacing: previewSpacing,
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

class _GalleryCard extends StatelessWidget {
  final AdaptiveGalleryItem item;
  final double previewSpacing;
  final EdgeInsetsGeometry padding;
  final bool scrollBody;

  const _GalleryCard({
    required this.item,
    required this.previewSpacing,
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
        SizedBox(height: previewSpacing),
        item.preview,
        SizedBox(height: previewSpacing),
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

class _GallerySelectorList extends StatelessWidget {
  final List<AdaptiveGalleryItem> items;
  final int currentIndex;
  final double itemSpacing;
  final EdgeInsetsGeometry padding;
  final ValueChanged<int> onSelected;

  const _GallerySelectorList({
    required this.items,
    required this.currentIndex,
    required this.itemSpacing,
    required this.padding,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isScrollable = constraints.maxHeight.isFinite;

            if (isScrollable) {
              return ListView.separated(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return _GallerySelectorTile(
                    item: items[index],
                    selected: index == currentIndex,
                    onTap: () => onSelected(index),
                  );
                },
                separatorBuilder: (context, index) =>
                    SizedBox(height: itemSpacing),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var index = 0; index < items.length; index++) ...[
                  _GallerySelectorTile(
                    item: items[index],
                    selected: index == currentIndex,
                    onTap: () => onSelected(index),
                  ),
                  if (index < items.length - 1) SizedBox(height: itemSpacing),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _GallerySelectorTile extends StatelessWidget {
  final AdaptiveGalleryItem item;
  final bool selected;
  final VoidCallback onTap;

  const _GallerySelectorTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: item.tooltip ?? item.label,
      child: Material(
        color: selected
            ? colorScheme.secondaryContainer
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.thumbnail != null) ...[
                  item.thumbnail!,
                  const SizedBox(width: 12),
                ] else if (item.leading != null) ...[
                  item.leading!,
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.label,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      if (item.description != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          item.description!,
                          style: Theme.of(context).textTheme.bodySmall,
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
          ),
        ),
      ),
    );
  }
}
