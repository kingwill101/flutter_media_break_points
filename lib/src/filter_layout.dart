import 'package:flutter/material.dart';

import 'container_layout.dart';
import 'media_query.dart';

/// The active arrangement used by [AdaptiveFilterLayout].
enum AdaptiveFilterMode {
  modal,
  docked,
}

/// A results-first layout that keeps filters docked on larger surfaces and
/// moves them behind a modal sheet on compact layouts.
class AdaptiveFilterLayout extends StatefulWidget {
  /// Main results content that remains visible in every mode.
  final Widget results;

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
  final Widget? resultsHeader;

  /// Label used by the compact-mode modal trigger.
  final String modalTriggerLabel;

  /// Icon used by the compact-mode modal trigger.
  final Widget modalTriggerIcon;

  /// Adaptive size at which filters should dock inline.
  final AdaptiveSize dockedAt;

  /// Minimum height class required before filters can dock inline.
  final AdaptiveHeight minimumDockedHeight;

  /// Whether to derive the layout mode from parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should influence container-based breakpoint selection.
  final bool considerOrientation;

  /// Space between the main regions.
  final double spacing;

  /// Flex used by the results region in docked mode.
  final int resultsFlex;

  /// Flex used by the filters region in docked mode.
  final int filtersFlex;

  /// Padding applied inside the filter surface.
  final EdgeInsetsGeometry filtersPadding;

  /// Padding applied inside the active filters surface.
  final EdgeInsetsGeometry activeFiltersPadding;

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

  /// Creates an adaptive filter layout.
  const AdaptiveFilterLayout({
    super.key,
    required this.results,
    required this.filters,
    required this.filtersTitle,
    this.filtersDescription,
    this.filtersLeading,
    this.activeFilters = const [],
    this.activeFiltersLabel = 'Active filters',
    this.resultsHeader,
    this.modalTriggerLabel = 'Open filters',
    this.modalTriggerIcon = const Icon(Icons.tune_outlined),
    this.dockedAt = AdaptiveSize.medium,
    this.minimumDockedHeight = AdaptiveHeight.compact,
    this.useContainerConstraints = true,
    this.considerOrientation = false,
    this.spacing = 16,
    this.resultsFlex = 3,
    this.filtersFlex = 2,
    this.filtersPadding = const EdgeInsets.all(16),
    this.activeFiltersPadding = const EdgeInsets.all(12),
    this.modalHeightFactor = 0.72,
    this.showModalDragHandle = true,
    this.animateSize = true,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeInOutCubic,
  })  : assert(resultsFlex > 0, 'resultsFlex must be greater than zero.'),
        assert(filtersFlex > 0, 'filtersFlex must be greater than zero.'),
        assert(spacing >= 0, 'spacing must be zero or greater.'),
        assert(
          modalHeightFactor > 0 && modalHeightFactor <= 1,
          'modalHeightFactor must be between 0 and 1.',
        );

  @override
  State<AdaptiveFilterLayout> createState() => _AdaptiveFilterLayoutState();
}

class _AdaptiveFilterLayoutState extends State<AdaptiveFilterLayout> {
  @override
  Widget build(BuildContext context) {
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

    return switch (mode) {
      AdaptiveFilterMode.modal => LayoutBuilder(
          builder: (context, constraints) {
            final hasBoundedHeight = constraints.maxHeight.isFinite;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.resultsHeader != null) ...[
                  widget.resultsHeader!,
                  SizedBox(height: widget.spacing),
                ],
                if (widget.activeFilters.isNotEmpty) ...[
                  _ActiveFiltersSurface(
                    label: widget.activeFiltersLabel,
                    padding: widget.activeFiltersPadding,
                    children: widget.activeFilters,
                  ),
                  SizedBox(height: widget.spacing),
                ],
                if (hasBoundedHeight)
                  Expanded(child: widget.results)
                else
                  widget.results,
                SizedBox(height: widget.spacing),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.tonalIcon(
                    onPressed: () => _showFilterSheet(context),
                    icon: widget.modalTriggerIcon,
                    label: Text(widget.modalTriggerLabel),
                  ),
                ),
              ],
            );
          },
        ),
      AdaptiveFilterMode.docked => LayoutBuilder(
          builder: (context, constraints) {
            final hasBoundedHeight = constraints.maxHeight.isFinite;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: widget.resultsFlex,
                  child: _ResultsRegion(
                    spacing: widget.spacing,
                    boundedHeight: hasBoundedHeight,
                    header: widget.resultsHeader,
                    activeFilters: widget.activeFilters.isEmpty
                        ? null
                        : _ActiveFiltersSurface(
                            label: widget.activeFiltersLabel,
                            padding: widget.activeFiltersPadding,
                            children: widget.activeFilters,
                          ),
                    child: widget.results,
                  ),
                ),
                SizedBox(width: widget.spacing),
                Expanded(
                  flex: widget.filtersFlex,
                  child: SizedBox(
                    height: hasBoundedHeight ? constraints.maxHeight : null,
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Padding(
                        padding: widget.filtersPadding,
                        child: _FilterSurface(
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
              ],
            );
          },
        ),
    };
  }

  AdaptiveFilterMode _modeForData(BreakPointData data) {
    final isWideEnough = data.adaptiveSize.index >= widget.dockedAt.index;
    final isTallEnough =
        data.adaptiveHeight.index >= widget.minimumDockedHeight.index;

    return isWideEnough && isTallEnough
        ? AdaptiveFilterMode.docked
        : AdaptiveFilterMode.modal;
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
              child: _FilterSurface(
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
}

class _ResultsRegion extends StatelessWidget {
  final double spacing;
  final bool boundedHeight;
  final Widget? header;
  final Widget? activeFilters;
  final Widget child;

  const _ResultsRegion({
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
      if ((header != null || activeFilters != null)) SizedBox(height: spacing),
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

class _ActiveFiltersSurface extends StatelessWidget {
  final String label;
  final EdgeInsetsGeometry padding;
  final List<Widget> children;

  const _ActiveFiltersSurface({
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

class _FilterSurface extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? leading;
  final Widget child;
  final bool scrollBody;

  const _FilterSurface({
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
