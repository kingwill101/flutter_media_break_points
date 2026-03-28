import 'package:flutter/material.dart';

import '../container_layout.dart';
import '../media_query.dart';

/// The active arrangement used by [AdaptivePresentationDesk].
enum AdaptivePresentationDeskMode {
  modalPanels,
  listDocked,
  fullyDocked,
}

/// A staged presentation workspace that coordinates a slide list, a stage
/// preview, and speaker notes from one adaptive model.
class AdaptivePresentationDesk<T> extends StatefulWidget {
  /// Slides shown in the list.
  final List<T> slides;

  /// Builds an individual slide row or thumbnail.
  final Widget Function(
    BuildContext context,
    T slide,
    bool selected,
    VoidCallback onTap,
  ) itemBuilder;

  /// Builds the active stage preview for the selected slide.
  final Widget Function(BuildContext context, T slide) stageBuilder;

  /// Builds the speaker notes for the selected slide.
  final Widget Function(BuildContext context, T slide) notesBuilder;

  /// Optional header shown above the stage.
  final Widget? header;

  /// Optional empty state shown when [slides] is empty.
  final Widget? emptyState;

  /// Title shown above the slide list.
  final String listTitle;

  /// Optional description shown below [listTitle].
  final String? listDescription;

  /// Optional leading widget shown beside [listTitle].
  final Widget? listLeading;

  /// Title shown above the notes surface.
  final String notesTitle;

  /// Optional description shown below [notesTitle].
  final String? notesDescription;

  /// Optional leading widget shown beside [notesTitle].
  final Widget? notesLeading;

  /// Label used by the compact slide-list trigger.
  final String modalListLabel;

  /// Icon used by the compact slide-list trigger.
  final Widget modalListIcon;

  /// Label used by the compact notes trigger.
  final String modalNotesLabel;

  /// Icon used by the compact notes trigger.
  final Widget modalNotesIcon;

  /// Semantic size at which the slide list should dock inline.
  final AdaptiveSize listDockedAt;

  /// Semantic size at which the notes surface should dock inline.
  final AdaptiveSize notesDockedAt;

  /// Minimum height class required before the slide list can dock inline.
  final AdaptiveHeight minimumListDockedHeight;

  /// Minimum height class required before the notes surface can dock inline.
  final AdaptiveHeight minimumNotesDockedHeight;

  /// Whether to derive layout decisions from parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should influence container-based breakpoint selection.
  final bool considerOrientation;

  /// Optional controlled selected slide index.
  final int? selectedIndex;

  /// Initial selected slide index for uncontrolled usage.
  final int initialIndex;

  /// Called when the selected slide changes.
  final ValueChanged<int>? onSelectedIndexChanged;

  /// Space between adjacent regions.
  final double spacing;

  /// Space between adjacent slide items.
  final double itemSpacing;

  /// Flex used by the docked list region.
  final int listFlex;

  /// Flex used by the stage region.
  final int stageFlex;

  /// Flex used by the docked notes region.
  final int notesFlex;

  /// Padding applied inside the slide list surface.
  final EdgeInsetsGeometry listPadding;

  /// Padding applied inside the stage surface.
  final EdgeInsetsGeometry stagePadding;

  /// Padding applied inside the notes surface.
  final EdgeInsetsGeometry notesPadding;

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

  /// Creates an adaptive presentation desk.
  const AdaptivePresentationDesk({
    super.key,
    required this.slides,
    required this.itemBuilder,
    required this.stageBuilder,
    required this.notesBuilder,
    required this.listTitle,
    required this.notesTitle,
    this.header,
    this.emptyState,
    this.listDescription,
    this.listLeading,
    this.notesDescription,
    this.notesLeading,
    this.modalListLabel = 'Open slides',
    this.modalListIcon = const Icon(Icons.view_carousel_outlined),
    this.modalNotesLabel = 'Open notes',
    this.modalNotesIcon = const Icon(Icons.sticky_note_2_outlined),
    this.listDockedAt = AdaptiveSize.medium,
    this.notesDockedAt = AdaptiveSize.expanded,
    this.minimumListDockedHeight = AdaptiveHeight.compact,
    this.minimumNotesDockedHeight = AdaptiveHeight.medium,
    this.useContainerConstraints = true,
    this.considerOrientation = false,
    this.selectedIndex,
    this.initialIndex = 0,
    this.onSelectedIndexChanged,
    this.spacing = 16,
    this.itemSpacing = 12,
    this.listFlex = 2,
    this.stageFlex = 4,
    this.notesFlex = 2,
    this.listPadding = const EdgeInsets.all(16),
    this.stagePadding = const EdgeInsets.all(16),
    this.notesPadding = const EdgeInsets.all(16),
    this.modalHeightFactor = 0.72,
    this.showModalDragHandle = true,
    this.animateSize = true,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeInOutCubic,
  })  : assert(spacing >= 0, 'spacing must be zero or greater.'),
        assert(itemSpacing >= 0, 'itemSpacing must be zero or greater.'),
        assert(listFlex > 0, 'listFlex must be greater than zero.'),
        assert(stageFlex > 0, 'stageFlex must be greater than zero.'),
        assert(notesFlex > 0, 'notesFlex must be greater than zero.'),
        assert(
          modalHeightFactor > 0 && modalHeightFactor <= 1,
          'modalHeightFactor must be between 0 and 1.',
        );

  @override
  State<AdaptivePresentationDesk<T>> createState() =>
      _AdaptivePresentationDeskState<T>();
}

class _AdaptivePresentationDeskState<T>
    extends State<AdaptivePresentationDesk<T>> {
  late int _internalIndex = widget.initialIndex;

  bool get _isControlled => widget.selectedIndex != null;

  int get _maxIndex {
    if (widget.slides.isEmpty) {
      return 0;
    }
    return widget.slides.length - 1;
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

  T get _currentSlide => widget.slides[_currentIndex];

  @override
  void didUpdateWidget(covariant AdaptivePresentationDesk<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isControlled || widget.slides.isEmpty) {
      return;
    }
    if (_internalIndex > _maxIndex) {
      _internalIndex = _maxIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.slides.isEmpty) {
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
        final stageSurface = _PresentationDeskStageSurface(
          header: widget.header,
          boundedHeight: hasBoundedHeight,
          padding: widget.stagePadding,
          child: widget.stageBuilder(context, _currentSlide),
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
              AdaptivePresentationDeskMode.modalPanels => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (hasBoundedHeight)
                      Expanded(child: stageSurface)
                    else
                      stageSurface,
                    SizedBox(height: widget.spacing),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.end,
                        children: [
                          FilledButton.tonalIcon(
                            onPressed: () => _showSlidesSheet(context),
                            icon: widget.modalListIcon,
                            label: Text(widget.modalListLabel),
                          ),
                          FilledButton.tonalIcon(
                            onPressed: () => _showNotesSheet(context),
                            icon: widget.modalNotesIcon,
                            label: Text(widget.modalNotesLabel),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              AdaptivePresentationDeskMode.listDocked => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: widget.listFlex,
                      child: _PresentationDeskPanelCard(
                        title: widget.listTitle,
                        description: widget.listDescription,
                        leading: widget.listLeading,
                        padding: widget.listPadding,
                        boundedHeight: hasBoundedHeight,
                        child: _PresentationDeskListSurface<T>(
                          slides: widget.slides,
                          currentIndex: _currentIndex,
                          itemSpacing: widget.itemSpacing,
                          boundedHeight: hasBoundedHeight,
                          itemBuilder: (context, slide, selected) =>
                              widget.itemBuilder(
                            context,
                            slide,
                            selected,
                            () => _selectSlide(widget.slides.indexOf(slide)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: widget.spacing),
                    Expanded(
                      flex: widget.stageFlex,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (hasBoundedHeight)
                            Expanded(child: stageSurface)
                          else
                            stageSurface,
                          SizedBox(height: widget.spacing),
                          Align(
                            alignment: Alignment.centerRight,
                            child: FilledButton.tonalIcon(
                              onPressed: () => _showNotesSheet(context),
                              icon: widget.modalNotesIcon,
                              label: Text(widget.modalNotesLabel),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              AdaptivePresentationDeskMode.fullyDocked => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: widget.listFlex,
                      child: _PresentationDeskPanelCard(
                        title: widget.listTitle,
                        description: widget.listDescription,
                        leading: widget.listLeading,
                        padding: widget.listPadding,
                        boundedHeight: hasBoundedHeight,
                        child: _PresentationDeskListSurface<T>(
                          slides: widget.slides,
                          currentIndex: _currentIndex,
                          itemSpacing: widget.itemSpacing,
                          boundedHeight: hasBoundedHeight,
                          itemBuilder: (context, slide, selected) =>
                              widget.itemBuilder(
                            context,
                            slide,
                            selected,
                            () => _selectSlide(widget.slides.indexOf(slide)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: widget.spacing),
                    Expanded(
                      flex: widget.stageFlex,
                      child: stageSurface,
                    ),
                    SizedBox(width: widget.spacing),
                    Expanded(
                      flex: widget.notesFlex,
                      child: _PresentationDeskPanelCard(
                        title: widget.notesTitle,
                        description: widget.notesDescription,
                        leading: widget.notesLeading,
                        padding: widget.notesPadding,
                        boundedHeight: hasBoundedHeight,
                        child: widget.notesBuilder(context, _currentSlide),
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

  AdaptivePresentationDeskMode _modeForData(BreakPointData data) {
    final canDockList = data.adaptiveSize.index >= widget.listDockedAt.index &&
        data.adaptiveHeight.index >= widget.minimumListDockedHeight.index;
    final canDockNotes =
        data.adaptiveSize.index >= widget.notesDockedAt.index &&
            data.adaptiveHeight.index >= widget.minimumNotesDockedHeight.index;

    if (canDockList && canDockNotes) {
      return AdaptivePresentationDeskMode.fullyDocked;
    }
    if (canDockList) {
      return AdaptivePresentationDeskMode.listDocked;
    }
    return AdaptivePresentationDeskMode.modalPanels;
  }

  void _selectSlide(int index) {
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

  Future<void> _showSlidesSheet(BuildContext context) {
    return _showPanelSheet(
      context: context,
      title: widget.listTitle,
      description: widget.listDescription,
      leading: widget.listLeading,
      child: _PresentationDeskListSurface<T>(
        slides: widget.slides,
        currentIndex: _currentIndex,
        itemSpacing: widget.itemSpacing,
        boundedHeight: true,
        itemBuilder: (context, slide, selected) => widget.itemBuilder(
          context,
          slide,
          selected,
          () {
            Navigator.of(context).pop();
            _selectSlide(widget.slides.indexOf(slide));
          },
        ),
      ),
    );
  }

  Future<void> _showNotesSheet(BuildContext context) {
    return _showPanelSheet(
      context: context,
      title: widget.notesTitle,
      description: widget.notesDescription,
      leading: widget.notesLeading,
      child: widget.notesBuilder(context, _currentSlide),
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
              child: _PresentationDeskPanelSurface(
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

class _PresentationDeskPanelCard extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? leading;
  final EdgeInsetsGeometry padding;
  final bool boundedHeight;
  final Widget child;

  const _PresentationDeskPanelCard({
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
        child: _PresentationDeskPanelSurface(
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

class _PresentationDeskStageSurface extends StatelessWidget {
  final Widget? header;
  final bool boundedHeight;
  final EdgeInsetsGeometry padding;
  final Widget child;

  const _PresentationDeskStageSurface({
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

class _PresentationDeskPanelSurface extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? leading;
  final bool boundedHeight;
  final Widget child;

  const _PresentationDeskPanelSurface({
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

class _PresentationDeskListSurface<T> extends StatelessWidget {
  final List<T> slides;
  final int currentIndex;
  final double itemSpacing;
  final bool boundedHeight;
  final Widget Function(BuildContext context, T slide, bool selected)
      itemBuilder;

  const _PresentationDeskListSurface({
    required this.slides,
    required this.currentIndex,
    required this.itemSpacing,
    required this.itemBuilder,
    this.boundedHeight = false,
  });

  @override
  Widget build(BuildContext context) {
    if (boundedHeight) {
      return ListView.separated(
        itemCount: slides.length,
        itemBuilder: (context, index) =>
            itemBuilder(context, slides[index], index == currentIndex),
        separatorBuilder: (context, index) => SizedBox(height: itemSpacing),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < slides.length; index++) ...[
          itemBuilder(context, slides[index], index == currentIndex),
          if (index < slides.length - 1) SizedBox(height: itemSpacing),
        ],
      ],
    );
  }
}
