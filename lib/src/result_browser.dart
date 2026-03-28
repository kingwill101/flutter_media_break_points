import 'package:flutter/material.dart';

import 'container_layout.dart';
import 'media_query.dart';

/// The active arrangement used by [AdaptiveResultBrowser].
enum AdaptiveResultBrowserMode {
  modal,
  split,
}

/// A results surface that opens details in a modal sheet on compact layouts and
/// docks them inline on larger containers.
class AdaptiveResultBrowser<T> extends StatefulWidget {
  /// Records shown in the result list.
  final List<T> results;

  /// Builds an individual result row or card.
  final Widget Function(
    BuildContext context,
    T result,
    bool selected,
    VoidCallback onTap,
  ) itemBuilder;

  /// Builds the detail content for the selected result.
  final Widget Function(BuildContext context, T result) detailBuilder;

  /// Optional header shown above the list of results.
  final Widget? header;

  /// Optional empty state shown when [results] is empty.
  final Widget? emptyState;

  /// Semantic size at which details should dock inline.
  final AdaptiveSize splitAt;

  /// Minimum height class required before details can dock inline.
  final AdaptiveHeight minimumSplitHeight;

  /// Whether to derive the active mode from parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should influence container-based breakpoint selection.
  final bool considerOrientation;

  /// Optional controlled selected result index.
  final int? selectedIndex;

  /// Initial selected result index for uncontrolled usage.
  final int initialIndex;

  /// Called when the active result changes.
  final ValueChanged<int>? onSelectedIndexChanged;

  /// Space between the list and detail regions.
  final double spacing;

  /// Flex used by the list region in split mode.
  final int listFlex;

  /// Flex used by the detail region in split mode.
  final int detailFlex;

  /// Space between adjacent result items.
  final double itemSpacing;

  /// Padding applied inside the list surface.
  final EdgeInsetsGeometry listPadding;

  /// Padding applied inside the detail surface.
  final EdgeInsetsGeometry detailPadding;

  /// Height factor used by the modal bottom sheet.
  final double modalHeightFactor;

  /// Whether to show a drag handle in the modal bottom sheet.
  final bool showModalDragHandle;

  /// Whether to animate size changes when the mode changes.
  final bool animateSize;

  /// Duration used by [AnimatedSize].
  final Duration animationDuration;

  /// Curve used by [AnimatedSize].
  final Curve animationCurve;

  /// Creates an adaptive result browser.
  const AdaptiveResultBrowser({
    super.key,
    required this.results,
    required this.itemBuilder,
    required this.detailBuilder,
    this.header,
    this.emptyState,
    this.splitAt = AdaptiveSize.medium,
    this.minimumSplitHeight = AdaptiveHeight.compact,
    this.useContainerConstraints = true,
    this.considerOrientation = false,
    this.selectedIndex,
    this.initialIndex = 0,
    this.onSelectedIndexChanged,
    this.spacing = 16,
    this.listFlex = 2,
    this.detailFlex = 3,
    this.itemSpacing = 12,
    this.listPadding = const EdgeInsets.all(16),
    this.detailPadding = const EdgeInsets.all(16),
    this.modalHeightFactor = 0.72,
    this.showModalDragHandle = true,
    this.animateSize = true,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeInOutCubic,
  })  : assert(listFlex > 0, 'listFlex must be greater than zero.'),
        assert(detailFlex > 0, 'detailFlex must be greater than zero.'),
        assert(spacing >= 0, 'spacing must be zero or greater.'),
        assert(itemSpacing >= 0, 'itemSpacing must be zero or greater.'),
        assert(
          modalHeightFactor > 0 && modalHeightFactor <= 1,
          'modalHeightFactor must be between 0 and 1.',
        );

  @override
  State<AdaptiveResultBrowser<T>> createState() =>
      _AdaptiveResultBrowserState<T>();
}

class _AdaptiveResultBrowserState<T> extends State<AdaptiveResultBrowser<T>> {
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
  void didUpdateWidget(covariant AdaptiveResultBrowser<T> oldWidget) {
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
          AdaptiveResultBrowserMode.modal => LayoutBuilder(
              builder: (context, constraints) {
                final hasBoundedHeight = constraints.maxHeight.isFinite;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.header != null) ...[
                      widget.header!,
                      SizedBox(height: widget.spacing),
                    ],
                    if (hasBoundedHeight)
                      Expanded(
                        child: _ResultListSurface<T>(
                          results: widget.results,
                          currentIndex: _currentIndex,
                          itemSpacing: widget.itemSpacing,
                          padding: widget.listPadding,
                          boundedHeight: true,
                          itemBuilder: (context, result, selected) =>
                              widget.itemBuilder(
                            context,
                            result,
                            selected,
                            () => _openModalForResult(context, result),
                          ),
                        ),
                      )
                    else
                      _ResultListSurface<T>(
                        results: widget.results,
                        currentIndex: _currentIndex,
                        itemSpacing: widget.itemSpacing,
                        padding: widget.listPadding,
                        itemBuilder: (context, result, selected) =>
                            widget.itemBuilder(
                          context,
                          result,
                          selected,
                          () => _openModalForResult(context, result),
                        ),
                      ),
                  ],
                );
              },
            ),
          AdaptiveResultBrowserMode.split => LayoutBuilder(
              builder: (context, constraints) {
                final hasBoundedHeight = constraints.maxHeight.isFinite;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: widget.listFlex,
                      child: _ListRegion<T>(
                        spacing: widget.spacing,
                        boundedHeight: hasBoundedHeight,
                        header: widget.header,
                        child: _ResultListSurface<T>(
                          results: widget.results,
                          currentIndex: _currentIndex,
                          itemSpacing: widget.itemSpacing,
                          padding: widget.listPadding,
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
                            child: _DetailSurface(
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

  AdaptiveResultBrowserMode _modeForData(BreakPointData data) {
    final isWideEnough = data.adaptiveSize.index >= widget.splitAt.index;
    final isTallEnough =
        data.adaptiveHeight.index >= widget.minimumSplitHeight.index;

    return isWideEnough && isTallEnough
        ? AdaptiveResultBrowserMode.split
        : AdaptiveResultBrowserMode.modal;
  }

  Future<void> _openModalForResult(BuildContext context, T result) async {
    final index = widget.results.indexOf(result);
    _selectResult(index);

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
              child: widget.detailBuilder(context, result),
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

class _ListRegion<T> extends StatelessWidget {
  final double spacing;
  final bool boundedHeight;
  final Widget? header;
  final Widget child;

  const _ListRegion({
    required this.spacing,
    required this.boundedHeight,
    required this.child,
    this.header,
  });

  @override
  Widget build(BuildContext context) {
    if (boundedHeight) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (header != null) ...[
            header!,
            SizedBox(height: spacing),
          ],
          Expanded(child: child),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (header != null) ...[
          header!,
          SizedBox(height: spacing),
        ],
        child,
      ],
    );
  }
}

class _ResultListSurface<T> extends StatelessWidget {
  final List<T> results;
  final int currentIndex;
  final double itemSpacing;
  final EdgeInsetsGeometry padding;
  final bool boundedHeight;
  final Widget Function(BuildContext context, T result, bool selected)
      itemBuilder;

  const _ResultListSurface({
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
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var index = 0; index < results.length; index++) ...[
                itemBuilder(context, results[index], index == currentIndex),
                if (index < results.length - 1) SizedBox(height: itemSpacing),
              ],
            ],
          );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: boundedHeight
          ? list
          : Padding(
              padding: padding,
              child: list,
            ),
    );
  }
}

class _DetailSurface extends StatelessWidget {
  final Widget child;
  final bool scrollBody;

  const _DetailSurface({
    required this.child,
    this.scrollBody = false,
  });

  @override
  Widget build(BuildContext context) {
    return scrollBody ? SingleChildScrollView(child: child) : child;
  }
}
