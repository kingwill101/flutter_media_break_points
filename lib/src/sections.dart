import 'package:flutter/material.dart';

import 'container_layout.dart';
import 'media_query.dart';

/// The active navigation mode used by [AdaptiveSections].
enum AdaptiveSectionsMode {
  compact,
  sidebar,
}

/// A logical section within [AdaptiveSections].
class AdaptiveSection {
  /// Label used by the section navigation.
  final String label;

  /// Content shown when this section is active.
  final Widget child;

  /// Optional icon shown beside the section label.
  final Widget? icon;

  /// Optional trailing widget shown in sidebar mode.
  final Widget? trailing;

  /// Optional supporting copy shown below the label in sidebar mode.
  final String? description;

  /// Optional tooltip shown by compact navigation chips.
  final String? tooltip;

  /// Creates a section definition.
  const AdaptiveSection({
    required this.label,
    required this.child,
    this.icon,
    this.trailing,
    this.description,
    this.tooltip,
  });
}

/// A sectioned layout that becomes a compact chip row or a docked section list.
///
/// Compact containers render horizontally scrollable chips above the selected
/// section content. Medium and expanded containers render a docked sidebar so
/// settings and workspace sections can stay visible while content changes.
class AdaptiveSections extends StatefulWidget {
  /// Sections displayed by the layout.
  final List<AdaptiveSection> sections;

  /// Semantic size at which the sidebar should appear.
  final AdaptiveSize sidebarAt;

  /// Minimum height class required before the sidebar can appear.
  final AdaptiveHeight minimumSidebarHeight;

  /// Whether to resolve the active mode from parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should influence container-based breakpoint selection.
  final bool considerOrientation;

  /// Width of the docked sidebar.
  final double navigationWidth;

  /// Space between navigation and content.
  final double spacing;

  /// Space between compact navigation chips.
  final double chipSpacing;

  /// Padding applied inside the sidebar surface.
  final EdgeInsetsGeometry navigationPadding;

  /// Padding applied around compact navigation chips.
  final EdgeInsetsGeometry compactNavigationPadding;

  /// Optional padding applied around the active section content.
  final EdgeInsetsGeometry? contentPadding;

  /// Optional controlled selected section index.
  final int? selectedIndex;

  /// Initial index used when [selectedIndex] is not provided.
  final int initialIndex;

  /// Called when the active section changes.
  final ValueChanged<int>? onSelectedIndexChanged;

  /// Optional header shown above sidebar navigation items.
  final Widget? navigationHeader;

  /// Optional footer shown below sidebar navigation items.
  final Widget? navigationFooter;

  /// Whether layout and content changes should animate.
  final bool animateTransitions;

  /// Duration used by animated transitions.
  final Duration transitionDuration;

  /// Curve used by animated transitions.
  final Curve transitionCurve;

  /// Creates an adaptive section layout.
  const AdaptiveSections({
    super.key,
    required this.sections,
    this.sidebarAt = AdaptiveSize.medium,
    this.minimumSidebarHeight = AdaptiveHeight.compact,
    this.useContainerConstraints = true,
    this.considerOrientation = false,
    this.navigationWidth = 240,
    this.spacing = 16,
    this.chipSpacing = 8,
    this.navigationPadding = const EdgeInsets.all(12),
    this.compactNavigationPadding = EdgeInsets.zero,
    this.contentPadding,
    this.selectedIndex,
    this.initialIndex = 0,
    this.onSelectedIndexChanged,
    this.navigationHeader,
    this.navigationFooter,
    this.animateTransitions = true,
    this.transitionDuration = const Duration(milliseconds: 250),
    this.transitionCurve = Curves.easeInOutCubic,
  });

  @override
  State<AdaptiveSections> createState() => _AdaptiveSectionsState();
}

class _AdaptiveSectionsState extends State<AdaptiveSections> {
  late int _internalIndex = widget.initialIndex;

  bool get _isControlled => widget.selectedIndex != null;

  int get _maxIndex {
    if (widget.sections.isEmpty) {
      return 0;
    }
    return widget.sections.length - 1;
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
  void didUpdateWidget(covariant AdaptiveSections oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isControlled || widget.sections.isEmpty) {
      return;
    }
    if (_internalIndex > _maxIndex) {
      _internalIndex = _maxIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sections.isEmpty) {
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

    return switch (mode) {
      AdaptiveSectionsMode.compact => LayoutBuilder(
          builder: (context, constraints) {
            final content = _AnimatedSectionContent(
              duration: widget.transitionDuration,
              curve: widget.transitionCurve,
              child: _buildContentForCurrentSection(),
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: widget.compactNavigationPadding,
                  child: Row(
                    children: [
                      for (var index = 0;
                          index < widget.sections.length;
                          index++) ...[
                        _CompactSectionChip(
                          section: widget.sections[index],
                          selected: index == _currentIndex,
                          onSelected: () => _setSelectedIndex(index),
                        ),
                        if (index < widget.sections.length - 1)
                          SizedBox(width: widget.chipSpacing),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: widget.spacing),
                if (constraints.maxHeight.isFinite)
                  Expanded(child: content)
                else
                  content,
              ],
            );
          },
        ),
      AdaptiveSectionsMode.sidebar => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: widget.navigationWidth,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: widget.navigationPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (widget.navigationHeader != null) ...[
                        widget.navigationHeader!,
                        SizedBox(height: widget.spacing),
                      ],
                      for (var index = 0;
                          index < widget.sections.length;
                          index++) ...[
                        _SidebarSectionTile(
                          section: widget.sections[index],
                          selected: index == _currentIndex,
                          onTap: () => _setSelectedIndex(index),
                        ),
                        if (index < widget.sections.length - 1)
                          const SizedBox(height: 6),
                      ],
                      if (widget.navigationFooter != null) ...[
                        SizedBox(height: widget.spacing),
                        widget.navigationFooter!,
                      ],
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: widget.spacing),
            Expanded(
              child: _AnimatedSectionContent(
                duration: widget.transitionDuration,
                curve: widget.transitionCurve,
                child: _buildContentForCurrentSection(),
              ),
            ),
          ],
        ),
    };
  }

  AdaptiveSectionsMode _modeForData(BreakPointData data) {
    final isWideEnough = data.adaptiveSize.index >= widget.sidebarAt.index;
    final isTallEnough =
        data.adaptiveHeight.index >= widget.minimumSidebarHeight.index;

    return isWideEnough && isTallEnough
        ? AdaptiveSectionsMode.sidebar
        : AdaptiveSectionsMode.compact;
  }

  Widget _buildContentForCurrentSection() {
    final currentSection = widget.sections[_currentIndex];
    final child = KeyedSubtree(
      key: ValueKey('section-${_currentIndex}-${currentSection.label}'),
      child: currentSection.child,
    );

    if (widget.contentPadding == null) {
      return child;
    }

    return Padding(
      padding: widget.contentPadding!,
      child: child,
    );
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

class _CompactSectionChip extends StatelessWidget {
  final AdaptiveSection section;
  final bool selected;
  final VoidCallback onSelected;

  const _CompactSectionChip({
    required this.section,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final chip = ChoiceChip(
      label: Text(section.label),
      avatar: section.icon,
      selected: selected,
      onSelected: (_) => onSelected(),
    );

    if (section.tooltip == null) {
      return chip;
    }

    return Tooltip(
      message: section.tooltip!,
      child: chip,
    );
  }
}

class _SidebarSectionTile extends StatelessWidget {
  final AdaptiveSection section;
  final bool selected;
  final VoidCallback onTap;

  const _SidebarSectionTile({
    required this.section,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selectedColor = Theme.of(context).colorScheme.primaryContainer;

    return Material(
      color: selected ? selectedColor : Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        selected: selected,
        leading: section.icon,
        trailing: section.trailing,
        title: Text(section.label),
        subtitle:
            section.description == null ? null : Text(section.description!),
        onTap: onTap,
      ),
    );
  }
}

class _AnimatedSectionContent extends StatelessWidget {
  final Duration duration;
  final Curve curve;
  final Widget child;

  const _AnimatedSectionContent({
    required this.duration,
    required this.curve,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: curve,
      switchOutCurve: curve.flipped,
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: child,
    );
  }
}
