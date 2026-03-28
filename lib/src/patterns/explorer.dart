import 'package:flutter/material.dart';

import '../container_layout.dart';
import '../media_query.dart';

/// The active arrangement used by [AdaptiveExplorer].
enum AdaptiveExplorerMode {
  modal,
  docked,
}

/// A compound browsing surface that combines filters, results, and detail
/// panels into one adaptive workspace.
class AdaptiveExplorer<T> extends StatefulWidget {
  /// Records shown in the result list.
  final List<T> results;

  /// Filter controls shown inline or in a modal sheet.
  final Widget filters;

  /// Title shown above the filter controls.
  final String filtersTitle;

  /// Optional description shown below the filter title.
  final String? filtersDescription;

  /// Optional leading widget shown beside the filter title.
  final Widget? filtersLeading;

  /// Active filter chips or badges shown above the results.
  final List<Widget> activeFilters;

  /// Label shown above [activeFilters].
  final String activeFiltersLabel;

  /// Optional header shown above the results.
  final Widget? header;

  /// Builds an individual result row or card.
  final Widget Function(
    BuildContext context,
    T result,
    bool selected,
    VoidCallback onTap,
  ) itemBuilder;

  /// Builds the detail content for the selected result.
  final Widget Function(BuildContext context, T result) detailBuilder;

  /// Optional empty state shown when [results] is empty.
  final Widget? emptyState;

  /// Semantic size at which the explorer should dock inline.
  final AdaptiveSize dockedAt;

  /// Minimum height class required before the explorer can dock inline.
  final AdaptiveHeight minimumDockedHeight;

  /// Whether to derive the layout mode from parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should influence container-based breakpoint selection.
  final bool considerOrientation;

  /// Optional controlled selected result index.
  final int? selectedIndex;

  /// Initial selected result index for uncontrolled usage.
  final int initialIndex;

  /// Called when the active result changes.
  final ValueChanged<int>? onSelectedIndexChanged;

  /// Label used by the compact filter trigger.
  final String modalFilterLabel;

  /// Icon used by the compact filter trigger.
  final Widget modalFilterIcon;

  /// Space between the docked regions.
  final double spacing;

  /// Flex used by the filter region in docked mode.
  final int filtersFlex;

  /// Flex used by the results region in docked mode.
  final int resultsFlex;

  /// Flex used by the detail region in docked mode.
  final int detailFlex;

  /// Space between adjacent result items.
  final double itemSpacing;

  /// Padding applied inside the filter surface.
  final EdgeInsetsGeometry filtersPadding;

  /// Padding applied inside the result surface.
  final EdgeInsetsGeometry resultsPadding;

  /// Padding applied inside the detail surface.
  final EdgeInsetsGeometry detailPadding;

  /// Padding applied inside the active filters surface.
  final EdgeInsetsGeometry activeFiltersPadding;

  /// Height factor used by compact modal sheets.
  final double modalHeightFactor;

  /// Whether to show a drag handle in modal sheets.
  final bool showModalDragHandle;

  /// Whether to animate size changes when the mode changes.
  final bool animateSize;

  /// Duration used by [AnimatedSize].
  final Duration animationDuration;

  /// Curve used by [AnimatedSize].
  final Curve animationCurve;

  /// Creates an adaptive explorer.
  const AdaptiveExplorer({
    super.key,
    required this.results,
    required this.filters,
    required this.filtersTitle,
    required this.itemBuilder,
    required this.detailBuilder,
    this.filtersDescription,
    this.filtersLeading,
    this.activeFilters = const [],
    this.activeFiltersLabel = 'Active filters',
    this.header,
    this.emptyState,
    this.dockedAt = AdaptiveSize.expanded,
    this.minimumDockedHeight = AdaptiveHeight.medium,
    this.useContainerConstraints = true,
    this.considerOrientation = false,
    this.selectedIndex,
    this.initialIndex = 0,
    this.onSelectedIndexChanged,
    this.modalFilterLabel = 'Open filters',
    this.modalFilterIcon = const Icon(Icons.tune_outlined),
    this.spacing = 16,
    this.filtersFlex = 2,
    this.resultsFlex = 2,
    this.detailFlex = 3,
    this.itemSpacing = 12,
    this.filtersPadding = const EdgeInsets.all(16),
    this.resultsPadding = const EdgeInsets.all(16),
    this.detailPadding = const EdgeInsets.all(16),
    this.activeFiltersPadding = const EdgeInsets.all(12),
    this.modalHeightFactor = 0.72,
    this.showModalDragHandle = true,
    this.animateSize = true,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeInOutCubic,
  })  : assert(filtersFlex > 0, 'filtersFlex must be greater than zero.'),
        assert(resultsFlex > 0, 'resultsFlex must be greater than zero.'),
        assert(detailFlex > 0, 'detailFlex must be greater than zero.'),
        assert(spacing >= 0, 'spacing must be zero or greater.'),
        assert(itemSpacing >= 0, 'itemSpacing must be zero or greater.'),
        assert(
          modalHeightFactor > 0 && modalHeightFactor <= 1,
          'modalHeightFactor must be between 0 and 1.',
        );

  @override
  State<AdaptiveExplorer<T>> createState() => _AdaptiveExplorerState<T>();
}

class _AdaptiveExplorerState<T> extends State<AdaptiveExplorer<T>> {
  late int _internalIndex = widget.initialIndex;

  bool get _isControlled => widget.selectedIndex != null;

  int get _maxIndex {
    if (widget.results.isEmpty) {
      return 0;
    }
    return widget.results.length - 1;
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
  void didUpdateWidget(covariant AdaptiveExplorer<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isControlled || widget.results.isEmpty) {
      return;
    }
    if (_internalIndex > _maxIndex) {
      _internalIndex = _maxIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.results.isEmpty) {
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
          AdaptiveExplorerMode.modal => LayoutBuilder(
              builder: (context, constraints) {
                final hasBoundedHeight = constraints.maxHeight.isFinite;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.header != null) ...[
                      widget.header!,
                      SizedBox(height: widget.spacing),
                    ],
                    if (widget.activeFilters.isNotEmpty) ...[
                      _ExplorerActiveFiltersSurface(
                        label: widget.activeFiltersLabel,
                        padding: widget.activeFiltersPadding,
                        children: widget.activeFilters,
                      ),
                      SizedBox(height: widget.spacing),
                    ],
                    if (hasBoundedHeight)
                      Expanded(
                        child: _ExplorerResultSurface<T>(
                          results: widget.results,
                          currentIndex: _currentIndex,
                          itemSpacing: widget.itemSpacing,
                          padding: widget.resultsPadding,
                          boundedHeight: true,
                          itemBuilder: (context, result, selected) =>
                              widget.itemBuilder(
                            context,
                            result,
                            selected,
                            () => _openDetailSheet(
                              context,
                              widget.results.indexOf(result),
                            ),
                          ),
                        ),
                      )
                    else
                      _ExplorerResultSurface<T>(
                        results: widget.results,
                        currentIndex: _currentIndex,
                        itemSpacing: widget.itemSpacing,
                        padding: widget.resultsPadding,
                        itemBuilder: (context, result, selected) =>
                            widget.itemBuilder(
                          context,
                          result,
                          selected,
                          () => _openDetailSheet(
                            context,
                            widget.results.indexOf(result),
                          ),
                        ),
                      ),
                    SizedBox(height: widget.spacing),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton.tonalIcon(
                        onPressed: () => _showFilterSheet(context),
                        icon: widget.modalFilterIcon,
                        label: Text(widget.modalFilterLabel),
                      ),
                    ),
                  ],
                );
              },
            ),
          AdaptiveExplorerMode.docked => LayoutBuilder(
              builder: (context, constraints) {
                final hasBoundedHeight = constraints.maxHeight.isFinite;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: widget.filtersFlex,
                      child: SizedBox(
                        height: hasBoundedHeight ? constraints.maxHeight : null,
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Padding(
                            padding: widget.filtersPadding,
                            child: _ExplorerFilterSurface(
                              title: widget.filtersTitle,
                              description: widget.filtersDescription,
                              leading: widget.filtersLeading,
                              scrollBody: hasBoundedHeight,
                              child: widget.filters,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: widget.spacing),
                    Expanded(
                      flex: widget.resultsFlex,
                      child: _ExplorerListRegion<T>(
                        spacing: widget.spacing,
                        boundedHeight: hasBoundedHeight,
                        header: widget.header,
                        activeFilters: widget.activeFilters.isEmpty
                            ? null
                            : _ExplorerActiveFiltersSurface(
                                label: widget.activeFiltersLabel,
                                padding: widget.activeFiltersPadding,
                                children: widget.activeFilters,
                              ),
                        child: _ExplorerResultSurface<T>(
                          results: widget.results,
                          currentIndex: _currentIndex,
                          itemSpacing: widget.itemSpacing,
                          padding: widget.resultsPadding,
                          boundedHeight: hasBoundedHeight,
                          itemBuilder: (context, result, selected) =>
                              widget.itemBuilder(
                            context,
                            result,
                            selected,
                            () => _selectResult(
                              widget.results.indexOf(result),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: widget.spacing),
                    Expanded(
                      flex: widget.detailFlex,
                      child: SizedBox(
                        height: hasBoundedHeight ? constraints.maxHeight : null,
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Padding(
                            padding: widget.detailPadding,
                            child: _ExplorerDetailSurface(
                              scrollBody: hasBoundedHeight,
                              child: widget.detailBuilder(
                                context,
                                widget.results[_currentIndex],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
        },
      ),
    );
  }

  AdaptiveExplorerMode _modeForData(BreakPointData data) {
    final isWideEnough = data.adaptiveSize.index >= widget.dockedAt.index;
    final isTallEnough =
        data.adaptiveHeight.index >= widget.minimumDockedHeight.index;

    return isWideEnough && isTallEnough
        ? AdaptiveExplorerMode.docked
        : AdaptiveExplorerMode.modal;
  }

  Future<void> _openDetailSheet(BuildContext context, int index) async {
    final targetIndex = index.clamp(0, _maxIndex);
    _selectResult(targetIndex);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: widget.showModalDragHandle,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: widget.modalHeightFactor,
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 8,
                bottom: 20 + MediaQuery.viewInsetsOf(context).bottom,
              ),
              child: widget.detailBuilder(
                context,
                widget.results[targetIndex],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showFilterSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: widget.showModalDragHandle,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: widget.modalHeightFactor,
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 8,
                bottom: 20 + MediaQuery.viewInsetsOf(context).bottom,
              ),
              child: _ExplorerFilterSurface(
                title: widget.filtersTitle,
                description: widget.filtersDescription,
                leading: widget.filtersLeading,
                child: widget.filters,
              ),
            ),
          ),
        );
      },
    );
  }

  void _selectResult(int index) {
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

class _ExplorerListRegion<T> extends StatelessWidget {
  final double spacing;
  final bool boundedHeight;
  final Widget? header;
  final Widget? activeFilters;
  final Widget child;

  const _ExplorerListRegion({
    required this.spacing,
    required this.boundedHeight,
    required this.child,
    this.header,
    this.activeFilters,
  });

  @override
  Widget build(BuildContext context) {
    final leadingChildren = <Widget>[
      if (header != null) header!,
      if (header != null && activeFilters != null) SizedBox(height: spacing),
      if (activeFilters != null) activeFilters!,
      if (header != null || activeFilters != null) SizedBox(height: spacing),
    ];

    if (boundedHeight) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...leadingChildren,
          Expanded(child: child),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...leadingChildren,
        child,
      ],
    );
  }
}

class _ExplorerResultSurface<T> extends StatelessWidget {
  final List<T> results;
  final int currentIndex;
  final double itemSpacing;
  final EdgeInsetsGeometry padding;
  final bool boundedHeight;
  final Widget Function(BuildContext context, T result, bool selected)
      itemBuilder;

  const _ExplorerResultSurface({
    required this.results,
    required this.currentIndex,
    required this.itemSpacing,
    required this.padding,
    required this.itemBuilder,
    this.boundedHeight = false,
  });

  @override
  Widget build(BuildContext context) {
    final list = boundedHeight
        ? ListView.separated(
            padding: padding,
            itemCount: results.length,
            itemBuilder: (context, index) =>
                itemBuilder(context, results[index], index == currentIndex),
            separatorBuilder: (context, index) => SizedBox(height: itemSpacing),
          )
        : Padding(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var index = 0; index < results.length; index++) ...[
                  itemBuilder(context, results[index], index == currentIndex),
                  if (index < results.length - 1) SizedBox(height: itemSpacing),
                ],
              ],
            ),
          );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: list,
    );
  }
}

class _ExplorerActiveFiltersSurface extends StatelessWidget {
  final String label;
  final EdgeInsetsGeometry padding;
  final List<Widget> children;

  const _ExplorerActiveFiltersSurface({
    required this.label,
    required this.padding,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: children,
            ),
          ],
        ),
      ),
    );
  }
}

class _ExplorerFilterSurface extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? leading;
  final Widget child;
  final bool scrollBody;

  const _ExplorerFilterSurface({
    required this.title,
    required this.child,
    this.description,
    this.leading,
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
        child,
      ],
    );

    return scrollBody ? SingleChildScrollView(child: content) : content;
  }
}

class _ExplorerDetailSurface extends StatelessWidget {
  final Widget child;
  final bool scrollBody;

  const _ExplorerDetailSurface({
    required this.child,
    this.scrollBody = false,
  });

  @override
  Widget build(BuildContext context) {
    return scrollBody ? SingleChildScrollView(child: child) : child;
  }
}
