import 'package:flutter/material.dart';

import 'container_layout.dart';
import 'media_query.dart';

/// The active arrangement used by [AdaptiveInspectorLayout].
enum AdaptiveInspectorMode {
  modal,
  docked,
}

/// A dockable inspector layout that keeps supporting controls inline on larger
/// widths and opens them in a modal sheet on compact layouts.
class AdaptiveInspectorLayout extends StatefulWidget {
  /// Main content that remains visible in every mode.
  final Widget primary;

  /// Inspector content shown inline or in a modal sheet.
  final Widget inspector;

  /// Title shown above the inspector content.
  final String inspectorTitle;

  /// Optional description shown below the title.
  final String? inspectorDescription;

  /// Optional leading widget shown beside the title.
  final Widget? inspectorLeading;

  /// Label used by the compact-mode modal trigger.
  final String modalTriggerLabel;

  /// Icon used by the compact-mode modal trigger.
  final Widget modalTriggerIcon;

  /// Adaptive size at which the inspector should dock inline.
  final AdaptiveSize dockedAt;

  /// Minimum height class required before the inspector can dock inline.
  final AdaptiveHeight minimumDockedHeight;

  /// Whether to derive the layout mode from parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should influence container-based breakpoint selection.
  final bool considerOrientation;

  /// Space between the primary content and the inspector region.
  final double spacing;

  /// Flex used by the primary region in docked mode.
  final int primaryFlex;

  /// Flex used by the inspector region in docked mode.
  final int inspectorFlex;

  /// Padding applied inside the inspector surface.
  final EdgeInsetsGeometry inspectorPadding;

  /// Whether to animate size changes when the mode changes.
  final bool animateSize;

  /// Duration used by [AnimatedSize].
  final Duration animationDuration;

  /// Curve used by [AnimatedSize].
  final Curve animationCurve;

  /// Height factor used by the modal bottom sheet.
  final double modalHeightFactor;

  /// Whether to show a drag handle in the modal bottom sheet.
  final bool showModalDragHandle;

  /// Creates an adaptive inspector layout.
  const AdaptiveInspectorLayout({
    super.key,
    required this.primary,
    required this.inspector,
    required this.inspectorTitle,
    this.inspectorDescription,
    this.inspectorLeading,
    this.modalTriggerLabel = 'Open inspector',
    this.modalTriggerIcon = const Icon(Icons.tune_outlined),
    this.dockedAt = AdaptiveSize.medium,
    this.minimumDockedHeight = AdaptiveHeight.compact,
    this.useContainerConstraints = true,
    this.considerOrientation = false,
    this.spacing = 16,
    this.primaryFlex = 3,
    this.inspectorFlex = 2,
    this.inspectorPadding = const EdgeInsets.all(16),
    this.animateSize = true,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeInOutCubic,
    this.modalHeightFactor = 0.72,
    this.showModalDragHandle = true,
  });

  @override
  State<AdaptiveInspectorLayout> createState() =>
      _AdaptiveInspectorLayoutState();
}

class _AdaptiveInspectorLayoutState extends State<AdaptiveInspectorLayout> {
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
      AdaptiveInspectorMode.modal => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            widget.primary,
            SizedBox(height: widget.spacing),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.tonalIcon(
                onPressed: () => _showInspectorSheet(context),
                icon: widget.modalTriggerIcon,
                label: Text(widget.modalTriggerLabel),
              ),
            ),
          ],
        ),
      AdaptiveInspectorMode.docked => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: widget.primaryFlex,
              child: widget.primary,
            ),
            SizedBox(width: widget.spacing),
            Expanded(
              flex: widget.inspectorFlex,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: widget.inspectorPadding,
                  child: _InspectorSurface(
                    title: widget.inspectorTitle,
                    description: widget.inspectorDescription,
                    leading: widget.inspectorLeading,
                    child: widget.inspector,
                  ),
                ),
              ),
            ),
          ],
        ),
    };
  }

  AdaptiveInspectorMode _modeForData(BreakPointData data) {
    final isWideEnough = data.adaptiveSize.index >= widget.dockedAt.index;
    final isTallEnough =
        data.adaptiveHeight.index >= widget.minimumDockedHeight.index;

    return isWideEnough && isTallEnough
        ? AdaptiveInspectorMode.docked
        : AdaptiveInspectorMode.modal;
  }

  Future<void> _showInspectorSheet(BuildContext context) {
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
              child: _InspectorSurface(
                title: widget.inspectorTitle,
                description: widget.inspectorDescription,
                leading: widget.inspectorLeading,
                child: widget.inspector,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _InspectorSurface extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? leading;
  final Widget child;

  const _InspectorSurface({
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
