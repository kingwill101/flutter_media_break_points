import 'package:flutter/material.dart';

import '../container_layout.dart';
import '../media_query.dart';

/// The active arrangement used by [AdaptiveWorkbench].
enum AdaptiveWorkbenchMode {
  modalPanels,
  libraryDocked,
  fullyDocked,
}

/// A compound studio-style surface that coordinates a left library, central
/// canvas, and right inspector from one adaptive layout model.
class AdaptiveWorkbench extends StatefulWidget {
  /// Main canvas or composition surface.
  final Widget canvas;

  /// Optional header shown above the canvas.
  final Widget? header;

  /// Library content shown inline or in a modal sheet.
  final Widget library;

  /// Title shown above the library content.
  final String libraryTitle;

  /// Optional description shown below [libraryTitle].
  final String? libraryDescription;

  /// Optional leading widget shown beside [libraryTitle].
  final Widget? libraryLeading;

  /// Inspector content shown inline or in a modal sheet.
  final Widget inspector;

  /// Title shown above the inspector content.
  final String inspectorTitle;

  /// Optional description shown below [inspectorTitle].
  final String? inspectorDescription;

  /// Optional leading widget shown beside [inspectorTitle].
  final Widget? inspectorLeading;

  /// Label used by the compact library trigger.
  final String modalLibraryLabel;

  /// Icon used by the compact library trigger.
  final Widget modalLibraryIcon;

  /// Label used by the compact inspector trigger.
  final String modalInspectorLabel;

  /// Icon used by the compact inspector trigger.
  final Widget modalInspectorIcon;

  /// Semantic size at which the library should dock inline.
  final AdaptiveSize libraryDockedAt;

  /// Semantic size at which the inspector should dock inline.
  final AdaptiveSize inspectorDockedAt;

  /// Minimum height class required before the library can dock inline.
  final AdaptiveHeight minimumLibraryDockedHeight;

  /// Minimum height class required before the inspector can dock inline.
  final AdaptiveHeight minimumInspectorDockedHeight;

  /// Whether to derive layout decisions from parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should influence container-based breakpoint selection.
  final bool considerOrientation;

  /// Space between adjacent workbench regions.
  final double spacing;

  /// Flex used by the docked library region.
  final int libraryFlex;

  /// Flex used by the canvas region.
  final int canvasFlex;

  /// Flex used by the docked inspector region.
  final int inspectorFlex;

  /// Padding applied inside the canvas surface.
  final EdgeInsetsGeometry canvasPadding;

  /// Padding applied inside the library surface.
  final EdgeInsetsGeometry libraryPadding;

  /// Padding applied inside the inspector surface.
  final EdgeInsetsGeometry inspectorPadding;

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

  /// Creates an adaptive workbench.
  const AdaptiveWorkbench({
    super.key,
    required this.canvas,
    required this.library,
    required this.libraryTitle,
    required this.inspector,
    required this.inspectorTitle,
    this.header,
    this.libraryDescription,
    this.libraryLeading,
    this.inspectorDescription,
    this.inspectorLeading,
    this.modalLibraryLabel = 'Open library',
    this.modalLibraryIcon = const Icon(Icons.inventory_2_outlined),
    this.modalInspectorLabel = 'Open inspector',
    this.modalInspectorIcon = const Icon(Icons.tune_outlined),
    this.libraryDockedAt = AdaptiveSize.medium,
    this.inspectorDockedAt = AdaptiveSize.expanded,
    this.minimumLibraryDockedHeight = AdaptiveHeight.compact,
    this.minimumInspectorDockedHeight = AdaptiveHeight.medium,
    this.useContainerConstraints = true,
    this.considerOrientation = false,
    this.spacing = 16,
    this.libraryFlex = 2,
    this.canvasFlex = 4,
    this.inspectorFlex = 2,
    this.canvasPadding = const EdgeInsets.all(16),
    this.libraryPadding = const EdgeInsets.all(16),
    this.inspectorPadding = const EdgeInsets.all(16),
    this.modalHeightFactor = 0.72,
    this.showModalDragHandle = true,
    this.animateSize = true,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeInOutCubic,
  })  : assert(spacing >= 0, 'spacing must be zero or greater.'),
        assert(libraryFlex > 0, 'libraryFlex must be greater than zero.'),
        assert(canvasFlex > 0, 'canvasFlex must be greater than zero.'),
        assert(inspectorFlex > 0, 'inspectorFlex must be greater than zero.'),
        assert(
          modalHeightFactor > 0 && modalHeightFactor <= 1,
          'modalHeightFactor must be between 0 and 1.',
        );

  @override
  State<AdaptiveWorkbench> createState() => _AdaptiveWorkbenchState();
}

class _AdaptiveWorkbenchState extends State<AdaptiveWorkbench> {
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final hasBoundedHeight = constraints.maxHeight.isFinite;
        final canvasSurface = _WorkbenchCanvasSurface(
          header: widget.header,
          boundedHeight: hasBoundedHeight,
          padding: widget.canvasPadding,
          child: widget.canvas,
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
              AdaptiveWorkbenchMode.modalPanels => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (hasBoundedHeight)
                      Expanded(child: canvasSurface)
                    else
                      canvasSurface,
                    SizedBox(height: widget.spacing),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.end,
                        children: [
                          FilledButton.tonalIcon(
                            onPressed: () => _showLibrarySheet(context),
                            icon: widget.modalLibraryIcon,
                            label: Text(widget.modalLibraryLabel),
                          ),
                          FilledButton.tonalIcon(
                            onPressed: () => _showInspectorSheet(context),
                            icon: widget.modalInspectorIcon,
                            label: Text(widget.modalInspectorLabel),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              AdaptiveWorkbenchMode.libraryDocked => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: widget.libraryFlex,
                      child: _WorkbenchPanelCard(
                        title: widget.libraryTitle,
                        description: widget.libraryDescription,
                        leading: widget.libraryLeading,
                        padding: widget.libraryPadding,
                        boundedHeight: hasBoundedHeight,
                        child: widget.library,
                      ),
                    ),
                    SizedBox(width: widget.spacing),
                    Expanded(
                      flex: widget.canvasFlex,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (hasBoundedHeight)
                            Expanded(child: canvasSurface)
                          else
                            canvasSurface,
                          SizedBox(height: widget.spacing),
                          Align(
                            alignment: Alignment.centerRight,
                            child: FilledButton.tonalIcon(
                              onPressed: () => _showInspectorSheet(context),
                              icon: widget.modalInspectorIcon,
                              label: Text(widget.modalInspectorLabel),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              AdaptiveWorkbenchMode.fullyDocked => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: widget.libraryFlex,
                      child: _WorkbenchPanelCard(
                        title: widget.libraryTitle,
                        description: widget.libraryDescription,
                        leading: widget.libraryLeading,
                        padding: widget.libraryPadding,
                        boundedHeight: hasBoundedHeight,
                        child: widget.library,
                      ),
                    ),
                    SizedBox(width: widget.spacing),
                    Expanded(
                      flex: widget.canvasFlex,
                      child: canvasSurface,
                    ),
                    SizedBox(width: widget.spacing),
                    Expanded(
                      flex: widget.inspectorFlex,
                      child: _WorkbenchPanelCard(
                        title: widget.inspectorTitle,
                        description: widget.inspectorDescription,
                        leading: widget.inspectorLeading,
                        padding: widget.inspectorPadding,
                        boundedHeight: hasBoundedHeight,
                        child: widget.inspector,
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

  AdaptiveWorkbenchMode _modeForData(BreakPointData data) {
    final canDockLibrary = data.adaptiveSize.index >=
            widget.libraryDockedAt.index &&
        data.adaptiveHeight.index >= widget.minimumLibraryDockedHeight.index;
    final canDockInspector = data.adaptiveSize.index >=
            widget.inspectorDockedAt.index &&
        data.adaptiveHeight.index >= widget.minimumInspectorDockedHeight.index;

    if (canDockLibrary && canDockInspector) {
      return AdaptiveWorkbenchMode.fullyDocked;
    }
    if (canDockLibrary) {
      return AdaptiveWorkbenchMode.libraryDocked;
    }
    return AdaptiveWorkbenchMode.modalPanels;
  }

  Future<void> _showLibrarySheet(BuildContext context) {
    return _showPanelSheet(
      context: context,
      title: widget.libraryTitle,
      description: widget.libraryDescription,
      leading: widget.libraryLeading,
      child: widget.library,
    );
  }

  Future<void> _showInspectorSheet(BuildContext context) {
    return _showPanelSheet(
      context: context,
      title: widget.inspectorTitle,
      description: widget.inspectorDescription,
      leading: widget.inspectorLeading,
      child: widget.inspector,
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
              child: _WorkbenchPanelSurface(
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

class _WorkbenchPanelCard extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? leading;
  final EdgeInsetsGeometry padding;
  final bool boundedHeight;
  final Widget child;

  const _WorkbenchPanelCard({
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
        child: _WorkbenchPanelSurface(
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

class _WorkbenchCanvasSurface extends StatelessWidget {
  final Widget? header;
  final bool boundedHeight;
  final EdgeInsetsGeometry padding;
  final Widget child;

  const _WorkbenchCanvasSurface({
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

class _WorkbenchPanelSurface extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? leading;
  final bool boundedHeight;
  final Widget child;

  const _WorkbenchPanelSurface({
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
