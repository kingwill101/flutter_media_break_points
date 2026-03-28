import 'package:flutter/material.dart';

import 'container_layout.dart';
import 'media_query.dart';

/// The active arrangement used by [AdaptiveDiffView].
enum AdaptiveDiffMode {
  compact,
  split,
}

/// The active pane shown by [AdaptiveDiffView] in compact mode.
enum AdaptiveDiffSide {
  primary,
  secondary,
}

/// A single pane shown by [AdaptiveDiffView].
class AdaptiveDiffPane {
  /// Label shown in the compact selector and pane header.
  final String label;

  /// Optional supporting description shown below [label].
  final String? description;

  /// Optional leading widget shown beside [label].
  final Widget? leading;

  /// Optional trailing widget shown in the pane header.
  final Widget? trailing;

  /// Main content shown inside the pane.
  final Widget child;

  /// Optional footer shown below [child].
  final Widget? footer;

  /// Optional tooltip used by the compact selector.
  final String? tooltip;

  /// Creates a diff pane definition.
  const AdaptiveDiffPane({
    required this.label,
    required this.child,
    this.description,
    this.leading,
    this.trailing,
    this.footer,
    this.tooltip,
  });
}

/// A review surface that shows one pane at a time on compact layouts and both
/// panes side by side on larger containers.
class AdaptiveDiffView extends StatefulWidget {
  /// Primary pane shown on the left in split mode.
  final AdaptiveDiffPane primary;

  /// Secondary pane shown on the right in split mode.
  final AdaptiveDiffPane secondary;

  /// Optional shared header shown above the diff panes.
  final Widget? header;

  /// Semantic size at which the view should switch to split mode.
  final AdaptiveSize splitAt;

  /// Minimum height class required before the view can switch to split mode.
  final AdaptiveHeight minimumSplitHeight;

  /// Whether to derive the active mode from parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should influence container-based breakpoint selection.
  final bool considerOrientation;

  /// Minimum width used by each pane in split mode.
  final double minPaneWidth;

  /// Space between adjacent panes.
  final double paneSpacing;

  /// Space between the compact selector and the active pane.
  final double selectorSpacing;

  /// Padding applied inside each diff pane.
  final EdgeInsetsGeometry panePadding;

  /// Optional controlled selected side.
  final AdaptiveDiffSide? selectedSide;

  /// Initial selected side for uncontrolled usage.
  final AdaptiveDiffSide initialSide;

  /// Called when the compact selection changes.
  final ValueChanged<AdaptiveDiffSide>? onSelectedSideChanged;

  /// Whether transitions should animate.
  final bool animateTransitions;

  /// Duration used by animations.
  final Duration transitionDuration;

  /// Curve used by animations.
  final Curve transitionCurve;

  /// Creates an adaptive diff view.
  const AdaptiveDiffView({
    super.key,
    required this.primary,
    required this.secondary,
    this.header,
    this.splitAt = AdaptiveSize.medium,
    this.minimumSplitHeight = AdaptiveHeight.compact,
    this.useContainerConstraints = true,
    this.considerOrientation = false,
    this.minPaneWidth = 260,
    this.paneSpacing = 16,
    this.selectorSpacing = 16,
    this.panePadding = const EdgeInsets.all(16),
    this.selectedSide,
    this.initialSide = AdaptiveDiffSide.primary,
    this.onSelectedSideChanged,
    this.animateTransitions = true,
    this.transitionDuration = const Duration(milliseconds: 250),
    this.transitionCurve = Curves.easeInOutCubic,
  })  : assert(minPaneWidth > 0, 'minPaneWidth must be greater than zero.'),
        assert(paneSpacing >= 0, 'paneSpacing must be zero or greater.'),
        assert(
            selectorSpacing >= 0, 'selectorSpacing must be zero or greater.');

  @override
  State<AdaptiveDiffView> createState() => _AdaptiveDiffViewState();
}

class _AdaptiveDiffViewState extends State<AdaptiveDiffView> {
  late AdaptiveDiffSide _internalSide = widget.initialSide;

  bool get _isControlled => widget.selectedSide != null;

  AdaptiveDiffSide get _currentSide => widget.selectedSide ?? _internalSide;

  AdaptiveDiffPane get _currentPane => switch (_currentSide) {
        AdaptiveDiffSide.primary => widget.primary,
        AdaptiveDiffSide.secondary => widget.secondary,
      };

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
          AdaptiveDiffMode.compact => _CompactDiffLayout(
              header: widget.header,
              primary: widget.primary,
              secondary: widget.secondary,
              currentSide: _currentSide,
              currentPane: _currentPane,
              selectorSpacing: widget.selectorSpacing,
              panePadding: widget.panePadding,
              onSelectedSideChanged: _setSelectedSide,
            ),
          AdaptiveDiffMode.split => LayoutBuilder(
              builder: (context, constraints) {
                final panes = [widget.primary, widget.secondary];
                final availableWidth = constraints.maxWidth.isFinite
                    ? constraints.maxWidth
                    : (widget.minPaneWidth * panes.length) + widget.paneSpacing;
                final totalSpacing = widget.paneSpacing;
                final evenWidth =
                    (availableWidth - totalSpacing) / panes.length;
                final canFitWithoutScroll = constraints.maxWidth.isFinite &&
                    evenWidth >= widget.minPaneWidth;
                final boundedHeight = constraints.maxHeight.isFinite
                    ? constraints.maxHeight
                    : null;

                final splitChild = canFitWithoutScroll
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var index = 0;
                              index < panes.length;
                              index++) ...[
                            Expanded(
                              child: SizedBox(
                                height: boundedHeight,
                                child: _DiffPaneCard(
                                  pane: panes[index],
                                  padding: widget.panePadding,
                                  scrollBody: boundedHeight != null,
                                ),
                              ),
                            ),
                            if (index == 0) SizedBox(width: widget.paneSpacing),
                          ],
                        ],
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var index = 0;
                                index < panes.length;
                                index++) ...[
                              SizedBox(
                                width: widget.minPaneWidth,
                                height: boundedHeight,
                                child: _DiffPaneCard(
                                  pane: panes[index],
                                  padding: widget.panePadding,
                                  scrollBody: boundedHeight != null,
                                ),
                              ),
                              if (index == 0)
                                SizedBox(width: widget.paneSpacing),
                            ],
                          ],
                        ),
                      );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.header != null) ...[
                      widget.header!,
                      SizedBox(height: widget.selectorSpacing),
                    ],
                    if (boundedHeight != null)
                      Expanded(child: splitChild)
                    else
                      splitChild,
                  ],
                );
              },
            ),
        },
      ),
    );
  }

  AdaptiveDiffMode _modeForData(BreakPointData data) {
    final isWideEnough = data.adaptiveSize.index >= widget.splitAt.index;
    final isTallEnough =
        data.adaptiveHeight.index >= widget.minimumSplitHeight.index;

    return isWideEnough && isTallEnough
        ? AdaptiveDiffMode.split
        : AdaptiveDiffMode.compact;
  }

  void _setSelectedSide(AdaptiveDiffSide side) {
    if (side == _currentSide) {
      return;
    }

    widget.onSelectedSideChanged?.call(side);
    if (_isControlled) {
      return;
    }

    setState(() {
      _internalSide = side;
    });
  }
}

class _CompactDiffLayout extends StatelessWidget {
  final Widget? header;
  final AdaptiveDiffPane primary;
  final AdaptiveDiffPane secondary;
  final AdaptiveDiffSide currentSide;
  final AdaptiveDiffPane currentPane;
  final double selectorSpacing;
  final EdgeInsetsGeometry panePadding;
  final ValueChanged<AdaptiveDiffSide> onSelectedSideChanged;

  const _CompactDiffLayout({
    required this.primary,
    required this.secondary,
    required this.currentSide,
    required this.currentPane,
    required this.selectorSpacing,
    required this.panePadding,
    required this.onSelectedSideChanged,
    this.header,
  });

  @override
  Widget build(BuildContext context) {
    final card = _DiffPaneCard(
      pane: currentPane,
      padding: panePadding,
      scrollBody: true,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final hasBoundedHeight = constraints.maxHeight.isFinite;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (header != null) ...[
              header!,
              SizedBox(height: selectorSpacing),
            ],
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SegmentedButton<AdaptiveDiffSide>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment<AdaptiveDiffSide>(
                    value: AdaptiveDiffSide.primary,
                    icon: primary.leading,
                    label: Text(primary.label),
                    tooltip: primary.tooltip,
                  ),
                  ButtonSegment<AdaptiveDiffSide>(
                    value: AdaptiveDiffSide.secondary,
                    icon: secondary.leading,
                    label: Text(secondary.label),
                    tooltip: secondary.tooltip,
                  ),
                ],
                selected: {currentSide},
                onSelectionChanged: (selection) {
                  if (selection.isEmpty) {
                    return;
                  }
                  onSelectedSideChanged(selection.first);
                },
              ),
            ),
            SizedBox(height: selectorSpacing),
            if (hasBoundedHeight) Expanded(child: card) else card,
          ],
        );
      },
    );
  }
}

class _DiffPaneCard extends StatelessWidget {
  final AdaptiveDiffPane pane;
  final EdgeInsetsGeometry padding;
  final bool scrollBody;

  const _DiffPaneCard({
    required this.pane,
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
            if (pane.leading != null) ...[
              pane.leading!,
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    pane.label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  if (pane.description != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      pane.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
            if (pane.trailing != null) ...[
              const SizedBox(width: 12),
              pane.trailing!,
            ],
          ],
        ),
        const SizedBox(height: 16),
        pane.child,
        if (pane.footer != null) ...[
          const SizedBox(height: 16),
          pane.footer!,
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
