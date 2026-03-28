import 'package:flutter/material.dart';

import 'container_layout.dart';
import 'media_query.dart';

/// The active arrangement used by [AdaptiveDocumentView].
enum AdaptiveDocumentMode {
  modalOutline,
  dockedOutline,
}

/// A single section shown by [AdaptiveDocumentView].
class AdaptiveDocumentSection {
  /// Label shown in the outline and above the section body.
  final String label;

  /// Main content shown inside the section.
  final Widget child;

  /// Optional supporting copy shown below [label].
  final String? summary;

  /// Optional leading widget shown beside [label].
  final Widget? leading;

  /// Optional trailing widget shown in the section header and outline row.
  final Widget? trailing;

  /// Optional tooltip used by outline rows.
  final String? tooltip;

  /// Creates a document section definition.
  const AdaptiveDocumentSection({
    required this.label,
    required this.child,
    this.summary,
    this.leading,
    this.trailing,
    this.tooltip,
  });
}

/// A long-form document surface that keeps content primary on compact layouts
/// and docks a section outline beside it on larger containers.
class AdaptiveDocumentView extends StatefulWidget {
  /// Sections shown by the document.
  final List<AdaptiveDocumentSection> sections;

  /// Optional header shown above the document content.
  final Widget? header;

  /// Optional empty state shown when [sections] is empty.
  final Widget? emptyState;

  /// Title shown above the outline.
  final String outlineTitle;

  /// Optional description shown below [outlineTitle].
  final String? outlineDescription;

  /// Optional leading widget shown beside [outlineTitle].
  final Widget? outlineLeading;

  /// Label used by the compact outline trigger.
  final String modalTriggerLabel;

  /// Icon used by the compact outline trigger.
  final Widget modalTriggerIcon;

  /// Semantic size at which the outline should dock inline.
  final AdaptiveSize dockedAt;

  /// Minimum height class required before the outline can dock inline.
  final AdaptiveHeight minimumDockedHeight;

  /// Whether to derive the layout mode from parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should influence container-based breakpoint selection.
  final bool considerOrientation;

  /// Width used by the outline surface in docked mode.
  final double outlineWidth;

  /// Space between the main regions.
  final double spacing;

  /// Space between document sections.
  final double sectionSpacing;

  /// Padding applied inside the outline surface.
  final EdgeInsetsGeometry outlinePadding;

  /// Padding applied around the document content.
  final EdgeInsetsGeometry contentPadding;

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

  /// Creates an adaptive document view.
  const AdaptiveDocumentView({
    super.key,
    required this.sections,
    this.header,
    this.emptyState,
    this.outlineTitle = 'Outline',
    this.outlineDescription,
    this.outlineLeading,
    this.modalTriggerLabel = 'Open outline',
    this.modalTriggerIcon = const Icon(Icons.menu_book_outlined),
    this.dockedAt = AdaptiveSize.medium,
    this.minimumDockedHeight = AdaptiveHeight.compact,
    this.useContainerConstraints = true,
    this.considerOrientation = false,
    this.outlineWidth = 240,
    this.spacing = 16,
    this.sectionSpacing = 24,
    this.outlinePadding = const EdgeInsets.all(16),
    this.contentPadding = EdgeInsets.zero,
    this.modalHeightFactor = 0.72,
    this.showModalDragHandle = true,
    this.animateSize = true,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeInOutCubic,
  })  : assert(outlineWidth > 0, 'outlineWidth must be greater than zero.'),
        assert(spacing >= 0, 'spacing must be zero or greater.'),
        assert(sectionSpacing >= 0, 'sectionSpacing must be zero or greater.'),
        assert(
          modalHeightFactor > 0 && modalHeightFactor <= 1,
          'modalHeightFactor must be between 0 and 1.',
        );

  @override
  State<AdaptiveDocumentView> createState() => _AdaptiveDocumentViewState();
}

class _AdaptiveDocumentViewState extends State<AdaptiveDocumentView> {
  late List<GlobalKey> _sectionKeys =
      _createSectionKeys(widget.sections.length);
  int _currentIndex = 0;

  @override
  void didUpdateWidget(covariant AdaptiveDocumentView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sections.length != widget.sections.length) {
      _sectionKeys = _createSectionKeys(widget.sections.length);
      if (_currentIndex >= widget.sections.length) {
        _currentIndex =
            widget.sections.isEmpty ? 0 : widget.sections.length - 1;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sections.isEmpty) {
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
        final content = _DocumentContent(
          header: widget.header,
          sections: widget.sections,
          sectionKeys: _sectionKeys,
          sectionSpacing: widget.sectionSpacing,
          contentPadding: widget.contentPadding,
          boundedHeight: hasBoundedHeight,
        );

        return switch (mode) {
          AdaptiveDocumentMode.modalOutline => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (hasBoundedHeight) Expanded(child: content) else content,
                SizedBox(height: widget.spacing),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.tonalIcon(
                    onPressed: () => _showOutlineSheet(context),
                    icon: widget.modalTriggerIcon,
                    label: Text(widget.modalTriggerLabel),
                  ),
                ),
              ],
            ),
          AdaptiveDocumentMode.dockedOutline => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: widget.outlineWidth,
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: widget.outlinePadding,
                      child: _OutlineSurface(
                        title: widget.outlineTitle,
                        description: widget.outlineDescription,
                        leading: widget.outlineLeading,
                        sections: widget.sections,
                        currentIndex: _currentIndex,
                        onSelected: _scrollToSection,
                        boundedHeight: hasBoundedHeight,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: widget.spacing),
                Expanded(child: content),
              ],
            ),
        };
      },
    );
  }

  AdaptiveDocumentMode _modeForData(BreakPointData data) {
    final isWideEnough = data.adaptiveSize.index >= widget.dockedAt.index;
    final isTallEnough =
        data.adaptiveHeight.index >= widget.minimumDockedHeight.index;

    return isWideEnough && isTallEnough
        ? AdaptiveDocumentMode.dockedOutline
        : AdaptiveDocumentMode.modalOutline;
  }

  List<GlobalKey> _createSectionKeys(int length) {
    return List<GlobalKey>.generate(length, (_) => GlobalKey());
  }

  Future<void> _scrollToSection(int index) async {
    if (index < 0 || index >= _sectionKeys.length) {
      return;
    }

    setState(() {
      _currentIndex = index;
    });

    final targetContext = _sectionKeys[index].currentContext;
    if (targetContext == null) {
      return;
    }

    await Scrollable.ensureVisible(
      targetContext,
      duration: widget.animationDuration,
      curve: widget.animationCurve,
      alignment: 0.05,
    );
  }

  Future<void> _showOutlineSheet(BuildContext context) {
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
              child: _OutlineSurface(
                title: widget.outlineTitle,
                description: widget.outlineDescription,
                leading: widget.outlineLeading,
                sections: widget.sections,
                currentIndex: _currentIndex,
                onSelected: (index) async {
                  Navigator.of(sheetContext).pop();
                  await _scrollToSection(index);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DocumentContent extends StatelessWidget {
  final Widget? header;
  final List<AdaptiveDocumentSection> sections;
  final List<GlobalKey> sectionKeys;
  final double sectionSpacing;
  final EdgeInsetsGeometry contentPadding;
  final bool boundedHeight;

  const _DocumentContent({
    required this.sections,
    required this.sectionKeys,
    required this.sectionSpacing,
    required this.contentPadding,
    required this.boundedHeight,
    this.header,
  });

  @override
  Widget build(BuildContext context) {
    final children = [
      if (header != null) ...[
        header!,
        SizedBox(height: sectionSpacing),
      ],
      for (var index = 0; index < sections.length; index++) ...[
        KeyedSubtree(
          key: sectionKeys[index],
          child: _DocumentSectionSurface(section: sections[index]),
        ),
        if (index < sections.length - 1) SizedBox(height: sectionSpacing),
      ],
    ];

    return Card(
      clipBehavior: Clip.antiAlias,
      child: boundedHeight
          ? ListView(
              padding: contentPadding.add(const EdgeInsets.all(16)),
              children: children,
            )
          : Padding(
              padding: contentPadding.add(const EdgeInsets.all(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
    );
  }
}

class _DocumentSectionSurface extends StatelessWidget {
  final AdaptiveDocumentSection section;

  const _DocumentSectionSurface({
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (section.leading != null) ...[
              section.leading!,
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.label,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  if (section.summary != null) ...[
                    const SizedBox(height: 6),
                    Text(section.summary!),
                  ],
                ],
              ),
            ),
            if (section.trailing != null) ...[
              const SizedBox(width: 12),
              section.trailing!,
            ],
          ],
        ),
        const SizedBox(height: 16),
        section.child,
      ],
    );
  }
}

class _OutlineSurface extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? leading;
  final List<AdaptiveDocumentSection> sections;
  final int currentIndex;
  final ValueChanged<int> onSelected;
  final bool boundedHeight;

  const _OutlineSurface({
    required this.title,
    required this.sections,
    required this.currentIndex,
    required this.onSelected,
    this.description,
    this.leading,
    this.boundedHeight = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = boundedHeight
        ? ListView.separated(
            itemCount: sections.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _OutlineHeader(
                  title: title,
                  description: description,
                  leading: leading,
                );
              }
              final sectionIndex = index - 1;
              return _OutlineTile(
                section: sections[sectionIndex],
                selected: sectionIndex == currentIndex,
                onTap: () => onSelected(sectionIndex),
              );
            },
            separatorBuilder: (context, index) =>
                SizedBox(height: index == 0 ? 16 : 10),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _OutlineHeader(
                title: title,
                description: description,
                leading: leading,
              ),
              const SizedBox(height: 16),
              for (var index = 0; index < sections.length; index++) ...[
                _OutlineTile(
                  section: sections[index],
                  selected: index == currentIndex,
                  onTap: () => onSelected(index),
                ),
                if (index < sections.length - 1) const SizedBox(height: 10),
              ],
            ],
          );

    return content;
  }
}

class _OutlineHeader extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? leading;

  const _OutlineHeader({
    required this.title,
    this.description,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

class _OutlineTile extends StatelessWidget {
  final AdaptiveDocumentSection section;
  final bool selected;
  final VoidCallback onTap;

  const _OutlineTile({
    required this.section,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: section.tooltip ?? section.label,
      child: Material(
        color: selected
            ? Theme.of(context).colorScheme.secondaryContainer
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (section.leading != null) ...[
                  section.leading!,
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        section.label,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      if (section.summary != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          section.summary!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
                if (section.trailing != null) ...[
                  const SizedBox(width: 12),
                  section.trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
