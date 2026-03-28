import 'package:flutter/material.dart';

import 'container_layout.dart';
import 'media_query.dart';

/// The active arrangement used by [AdaptivePriorityLayout].
enum AdaptivePriorityMode {
  collapsed,
  split,
}

/// A priority-aware layout that keeps primary content visible and demotes
/// supporting content into a collapsible surface on compact containers.
class AdaptivePriorityLayout extends StatefulWidget {
  /// Primary content that remains visible in every layout mode.
  final Widget primary;

  /// Supporting content that collapses on compact containers and docks beside
  /// the primary content on wider containers.
  final Widget supporting;

  /// Title shown for the supporting surface when collapsed.
  final String supportingTitle;

  /// Optional supporting description shown with the title.
  final String? supportingDescription;

  /// Optional leading widget shown beside the supporting title.
  final Widget? supportingLeading;

  /// Adaptive size at which the layout should switch to split mode.
  final AdaptiveSize splitAt;

  /// Minimum height class required before the supporting region can dock.
  final AdaptiveHeight minimumSplitHeight;

  /// Whether to derive the layout mode from parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should influence container-based breakpoint selection.
  final bool considerOrientation;

  /// Space between the primary and supporting regions.
  final double spacing;

  /// Flex for the primary region in split mode.
  final int primaryFlex;

  /// Flex for the supporting region in split mode.
  final int supportingFlex;

  /// Padding applied inside the supporting surface.
  final EdgeInsetsGeometry supportingPadding;

  /// Whether the supporting surface should start expanded in compact mode.
  final bool initiallyExpanded;

  /// Called when compact-mode expansion changes.
  final ValueChanged<bool>? onExpansionChanged;

  /// Whether to animate size changes when the layout mode changes.
  final bool animateSize;

  /// Duration used by [AnimatedSize].
  final Duration animationDuration;

  /// Curve used by [AnimatedSize].
  final Curve animationCurve;

  /// Creates an adaptive priority layout.
  const AdaptivePriorityLayout({
    super.key,
    required this.primary,
    required this.supporting,
    required this.supportingTitle,
    this.supportingDescription,
    this.supportingLeading,
    this.splitAt = AdaptiveSize.medium,
    this.minimumSplitHeight = AdaptiveHeight.compact,
    this.useContainerConstraints = true,
    this.considerOrientation = false,
    this.spacing = 16,
    this.primaryFlex = 2,
    this.supportingFlex = 1,
    this.supportingPadding = const EdgeInsets.all(16),
    this.initiallyExpanded = false,
    this.onExpansionChanged,
    this.animateSize = true,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeInOutCubic,
  });

  @override
  State<AdaptivePriorityLayout> createState() => _AdaptivePriorityLayoutState();
}

class _AdaptivePriorityLayoutState extends State<AdaptivePriorityLayout> {
  late bool _isExpanded = widget.initiallyExpanded;

  @override
  void didUpdateWidget(covariant AdaptivePriorityLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initiallyExpanded != widget.initiallyExpanded) {
      _isExpanded = widget.initiallyExpanded;
    }
  }

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
      AdaptivePriorityMode.collapsed => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            widget.primary,
            SizedBox(height: widget.spacing),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                ),
                child: ExpansionTile(
                  key: const PageStorageKey<String>(
                    'adaptive_priority_layout_expansion_tile',
                  ),
                  initiallyExpanded: _isExpanded,
                  onExpansionChanged: _handleExpansionChanged,
                  leading: widget.supportingLeading,
                  title: Text(widget.supportingTitle),
                  subtitle: widget.supportingDescription == null
                      ? null
                      : Text(widget.supportingDescription!),
                  children: [
                    Padding(
                      padding: widget.supportingPadding,
                      child: widget.supporting,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      AdaptivePriorityMode.split => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: widget.primaryFlex,
              child: widget.primary,
            ),
            SizedBox(width: widget.spacing),
            Expanded(
              flex: widget.supportingFlex,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: widget.supportingPadding,
                  child: _SupportingSurface(
                    title: widget.supportingTitle,
                    description: widget.supportingDescription,
                    leading: widget.supportingLeading,
                    child: widget.supporting,
                  ),
                ),
              ),
            ),
          ],
        ),
    };
  }

  AdaptivePriorityMode _modeForData(BreakPointData data) {
    final isWideEnough = data.adaptiveSize.index >= widget.splitAt.index;
    final isTallEnough =
        data.adaptiveHeight.index >= widget.minimumSplitHeight.index;

    return isWideEnough && isTallEnough
        ? AdaptivePriorityMode.split
        : AdaptivePriorityMode.collapsed;
  }

  void _handleExpansionChanged(bool value) {
    widget.onExpansionChanged?.call(value);
    setState(() {
      _isExpanded = value;
    });
  }
}

class _SupportingSurface extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? leading;
  final Widget child;

  const _SupportingSurface({
    required this.title,
    required this.child,
    this.description,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
  }
}
