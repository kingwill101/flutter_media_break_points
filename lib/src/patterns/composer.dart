import 'package:flutter/material.dart';

import '../container_layout.dart';
import '../media_query.dart';

/// The active arrangement used by [AdaptiveComposer].
enum AdaptiveComposerMode {
  compact,
  split,
  fullyDocked,
}

/// The active compact surface shown by [AdaptiveComposer].
enum AdaptiveComposerSurface {
  editor,
  preview,
}

/// A staged composition workspace that moves between a compact editor/preview
/// toggle, a split editor-preview layout, and a fully docked editor-preview
/// plus settings surface.
class AdaptiveComposer extends StatefulWidget {
  /// Main editor surface.
  final Widget editor;

  /// Preview surface.
  final Widget preview;

  /// Settings or inspector surface.
  final Widget settings;

  /// Optional header shown above the composition region.
  final Widget? header;

  /// Title shown above the editor surface.
  final String editorTitle;

  /// Optional description shown below [editorTitle].
  final String? editorDescription;

  /// Optional leading widget shown beside [editorTitle].
  final Widget? editorLeading;

  /// Title shown above the preview surface.
  final String previewTitle;

  /// Optional description shown below [previewTitle].
  final String? previewDescription;

  /// Optional leading widget shown beside [previewTitle].
  final Widget? previewLeading;

  /// Title shown above the settings surface.
  final String settingsTitle;

  /// Optional description shown below [settingsTitle].
  final String? settingsDescription;

  /// Optional leading widget shown beside [settingsTitle].
  final Widget? settingsLeading;

  /// Label used by the compact settings trigger.
  final String modalSettingsLabel;

  /// Icon used by the compact settings trigger.
  final Widget modalSettingsIcon;

  /// Semantic size at which the editor and preview should split.
  final AdaptiveSize splitAt;

  /// Semantic size at which the settings surface should dock inline.
  final AdaptiveSize settingsDockedAt;

  /// Minimum height class required before editor and preview can split.
  final AdaptiveHeight minimumSplitHeight;

  /// Minimum height class required before settings can dock inline.
  final AdaptiveHeight minimumSettingsDockedHeight;

  /// Whether to derive layout decisions from parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should influence container-based breakpoint selection.
  final bool considerOrientation;

  /// Optional controlled selected compact surface.
  final AdaptiveComposerSurface? selectedSurface;

  /// Initial selected compact surface for uncontrolled usage.
  final AdaptiveComposerSurface initialSurface;

  /// Called when the compact surface selection changes.
  final ValueChanged<AdaptiveComposerSurface>? onSelectedSurfaceChanged;

  /// Space between adjacent regions.
  final double spacing;

  /// Space between the compact selector and the active surface.
  final double selectorSpacing;

  /// Flex used by the editor region.
  final int editorFlex;

  /// Flex used by the preview region.
  final int previewFlex;

  /// Flex used by the settings region.
  final int settingsFlex;

  /// Padding applied inside the editor surface.
  final EdgeInsetsGeometry editorPadding;

  /// Padding applied inside the preview surface.
  final EdgeInsetsGeometry previewPadding;

  /// Padding applied inside the settings surface.
  final EdgeInsetsGeometry settingsPadding;

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

  /// Creates an adaptive composer.
  const AdaptiveComposer({
    super.key,
    required this.editor,
    required this.preview,
    required this.settings,
    this.header,
    this.editorTitle = 'Editor',
    this.editorDescription,
    this.editorLeading,
    this.previewTitle = 'Preview',
    this.previewDescription,
    this.previewLeading,
    this.settingsTitle = 'Settings',
    this.settingsDescription,
    this.settingsLeading,
    this.modalSettingsLabel = 'Open settings',
    this.modalSettingsIcon = const Icon(Icons.tune_outlined),
    this.splitAt = AdaptiveSize.medium,
    this.settingsDockedAt = AdaptiveSize.expanded,
    this.minimumSplitHeight = AdaptiveHeight.compact,
    this.minimumSettingsDockedHeight = AdaptiveHeight.medium,
    this.useContainerConstraints = true,
    this.considerOrientation = false,
    this.selectedSurface,
    this.initialSurface = AdaptiveComposerSurface.editor,
    this.onSelectedSurfaceChanged,
    this.spacing = 16,
    this.selectorSpacing = 16,
    this.editorFlex = 3,
    this.previewFlex = 3,
    this.settingsFlex = 2,
    this.editorPadding = const EdgeInsets.all(16),
    this.previewPadding = const EdgeInsets.all(16),
    this.settingsPadding = const EdgeInsets.all(16),
    this.modalHeightFactor = 0.72,
    this.showModalDragHandle = true,
    this.animateSize = true,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeInOutCubic,
  })  : assert(spacing >= 0, 'spacing must be zero or greater.'),
        assert(
          selectorSpacing >= 0,
          'selectorSpacing must be zero or greater.',
        ),
        assert(editorFlex > 0, 'editorFlex must be greater than zero.'),
        assert(previewFlex > 0, 'previewFlex must be greater than zero.'),
        assert(settingsFlex > 0, 'settingsFlex must be greater than zero.'),
        assert(
          modalHeightFactor > 0 && modalHeightFactor <= 1,
          'modalHeightFactor must be between 0 and 1.',
        );

  @override
  State<AdaptiveComposer> createState() => _AdaptiveComposerState();
}

class _AdaptiveComposerState extends State<AdaptiveComposer> {
  late AdaptiveComposerSurface _internalSurface = widget.initialSurface;

  bool get _isControlled => widget.selectedSurface != null;

  AdaptiveComposerSurface get _currentSurface =>
      widget.selectedSurface ?? _internalSurface;

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
        final editorPane = _ComposerPaneCard(
          title: widget.editorTitle,
          description: widget.editorDescription,
          leading: widget.editorLeading,
          padding: widget.editorPadding,
          boundedHeight: hasBoundedHeight,
          child: widget.editor,
        );
        final previewPane = _ComposerPaneCard(
          title: widget.previewTitle,
          description: widget.previewDescription,
          leading: widget.previewLeading,
          padding: widget.previewPadding,
          boundedHeight: hasBoundedHeight,
          child: widget.preview,
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
              AdaptiveComposerMode.compact => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.header != null) ...[
                      widget.header!,
                      SizedBox(height: widget.selectorSpacing),
                    ],
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SegmentedButton<AdaptiveComposerSurface>(
                        segments: [
                          ButtonSegment(
                            value: AdaptiveComposerSurface.editor,
                            label: Text(widget.editorTitle),
                            icon: widget.editorLeading is Icon
                                ? widget.editorLeading as Icon
                                : null,
                          ),
                          ButtonSegment(
                            value: AdaptiveComposerSurface.preview,
                            label: Text(widget.previewTitle),
                            icon: widget.previewLeading is Icon
                                ? widget.previewLeading as Icon
                                : null,
                          ),
                        ],
                        selected: {_currentSurface},
                        onSelectionChanged: (selection) {
                          if (selection.isEmpty) {
                            return;
                          }
                          _selectSurface(selection.first);
                        },
                      ),
                    ),
                    SizedBox(height: widget.selectorSpacing),
                    if (hasBoundedHeight)
                      Expanded(
                        child: _currentSurface == AdaptiveComposerSurface.editor
                            ? editorPane
                            : previewPane,
                      )
                    else if (_currentSurface == AdaptiveComposerSurface.editor)
                      editorPane
                    else
                      previewPane,
                    SizedBox(height: widget.spacing),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton.tonalIcon(
                        onPressed: () => _showSettingsSheet(context),
                        icon: widget.modalSettingsIcon,
                        label: Text(widget.modalSettingsLabel),
                      ),
                    ),
                  ],
                ),
              AdaptiveComposerMode.split => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.header != null) ...[
                      widget.header!,
                      SizedBox(height: widget.selectorSpacing),
                    ],
                    if (hasBoundedHeight)
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: widget.editorFlex,
                              child: editorPane,
                            ),
                            SizedBox(width: widget.spacing),
                            Expanded(
                              flex: widget.previewFlex,
                              child: previewPane,
                            ),
                          ],
                        ),
                      )
                    else
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: widget.editorFlex,
                            child: editorPane,
                          ),
                          SizedBox(width: widget.spacing),
                          Expanded(
                            flex: widget.previewFlex,
                            child: previewPane,
                          ),
                        ],
                      ),
                    SizedBox(height: widget.spacing),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton.tonalIcon(
                        onPressed: () => _showSettingsSheet(context),
                        icon: widget.modalSettingsIcon,
                        label: Text(widget.modalSettingsLabel),
                      ),
                    ),
                  ],
                ),
              AdaptiveComposerMode.fullyDocked => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.header != null) ...[
                      widget.header!,
                      SizedBox(height: widget.selectorSpacing),
                    ],
                    if (hasBoundedHeight)
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: widget.editorFlex,
                              child: editorPane,
                            ),
                            SizedBox(width: widget.spacing),
                            Expanded(
                              flex: widget.previewFlex,
                              child: previewPane,
                            ),
                            SizedBox(width: widget.spacing),
                            Expanded(
                              flex: widget.settingsFlex,
                              child: _ComposerPaneCard(
                                title: widget.settingsTitle,
                                description: widget.settingsDescription,
                                leading: widget.settingsLeading,
                                padding: widget.settingsPadding,
                                boundedHeight: true,
                                child: widget.settings,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: widget.editorFlex,
                            child: editorPane,
                          ),
                          SizedBox(width: widget.spacing),
                          Expanded(
                            flex: widget.previewFlex,
                            child: previewPane,
                          ),
                          SizedBox(width: widget.spacing),
                          Expanded(
                            flex: widget.settingsFlex,
                            child: _ComposerPaneCard(
                              title: widget.settingsTitle,
                              description: widget.settingsDescription,
                              leading: widget.settingsLeading,
                              padding: widget.settingsPadding,
                              boundedHeight: false,
                              child: widget.settings,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
            },
          ),
        );
      },
    );
  }

  AdaptiveComposerMode _modeForData(BreakPointData data) {
    final canSplit = data.adaptiveSize.index >= widget.splitAt.index &&
        data.adaptiveHeight.index >= widget.minimumSplitHeight.index;
    final canDockSettings = data.adaptiveSize.index >=
            widget.settingsDockedAt.index &&
        data.adaptiveHeight.index >= widget.minimumSettingsDockedHeight.index;

    if (canSplit && canDockSettings) {
      return AdaptiveComposerMode.fullyDocked;
    }
    if (canSplit) {
      return AdaptiveComposerMode.split;
    }
    return AdaptiveComposerMode.compact;
  }

  void _selectSurface(AdaptiveComposerSurface surface) {
    if (surface == _currentSurface) {
      return;
    }

    widget.onSelectedSurfaceChanged?.call(surface);
    if (_isControlled) {
      return;
    }

    setState(() {
      _internalSurface = surface;
    });
  }

  Future<void> _showSettingsSheet(BuildContext context) {
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
              child: _ComposerPaneSurface(
                title: widget.settingsTitle,
                description: widget.settingsDescription,
                leading: widget.settingsLeading,
                boundedHeight: true,
                child: widget.settings,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ComposerPaneCard extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? leading;
  final EdgeInsetsGeometry padding;
  final bool boundedHeight;
  final Widget child;

  const _ComposerPaneCard({
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
        child: _ComposerPaneSurface(
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

class _ComposerPaneSurface extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? leading;
  final bool boundedHeight;
  final Widget child;

  const _ComposerPaneSurface({
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
