import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'media_query.dart';

/// Overlays the active responsive state on top of a widget subtree.
class ResponsiveDebugOverlay extends StatelessWidget {
  /// Child widget under inspection.
  final Widget child;

  /// Optional label shown at the top of the overlay.
  final String? label;

  /// Whether to derive the debug state from the parent constraints.
  final bool useContainerConstraints;

  /// Whether container-based inspection should consider orientation.
  final bool considerOrientation;

  /// Whether to hide the overlay in release mode.
  final bool showOnlyInDebugMode;

  /// Alignment of the overlay chip inside the stack.
  final Alignment alignment;

  /// Space around the overlay chip.
  final EdgeInsetsGeometry margin;

  /// Internal padding of the overlay chip.
  final EdgeInsetsGeometry padding;

  /// Background color of the overlay chip.
  final Color? backgroundColor;

  /// Text style used by the overlay chip.
  final TextStyle? textStyle;

  /// Border radius of the overlay chip.
  final BorderRadiusGeometry borderRadius;

  /// Whether to show the raw width and height.
  final bool showSize;

  /// Whether to show the orientation.
  final bool showOrientation;

  /// Creates a responsive debug overlay.
  const ResponsiveDebugOverlay({
    super.key,
    required this.child,
    this.label,
    this.useContainerConstraints = false,
    this.considerOrientation = false,
    this.showOnlyInDebugMode = true,
    this.alignment = Alignment.topRight,
    this.margin = const EdgeInsets.all(12),
    this.padding = const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 10,
    ),
    this.backgroundColor,
    this.textStyle,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.showSize = true,
    this.showOrientation = true,
  });

  @override
  Widget build(BuildContext context) {
    if (showOnlyInDebugMode && kReleaseMode) {
      return child;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final data = useContainerConstraints
            ? _dataForConstraints(context, constraints)
            : context.breakPointData;
        final availableHeight = constraints.maxHeight.isFinite
            ? (constraints.maxHeight - 24).clamp(0.0, double.infinity)
            : double.infinity;
        final lines = <String>[
          if (label != null) label!,
          'breakpoint: ${data.breakPoint.name}',
          'adaptive: ${data.adaptiveSize.name}',
          if (showSize)
            'size: ${data.width.toStringAsFixed(0)} x '
                '${data.height.toStringAsFixed(0)}',
          if (showOrientation) 'orientation: ${data.orientation.name}',
        ];

        return Stack(
          children: [
            child,
            Positioned.fill(
              child: IgnorePointer(
                child: SafeArea(
                  child: Align(
                    alignment: alignment,
                    child: Container(
                      margin: margin,
                      decoration: BoxDecoration(
                        color: backgroundColor ??
                            Colors.black.withValues(alpha: 0.78),
                        borderRadius: borderRadius,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: availableHeight,
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: padding,
                            child: DefaultTextStyle(
                              style: textStyle ??
                                  const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    height: 1.35,
                                  ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (final line in lines) Text(line),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  BreakPointData _dataForConstraints(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    final mediaSize = MediaQuery.maybeOf(context)?.size ?? Size.zero;
    final width =
        constraints.maxWidth.isFinite ? constraints.maxWidth : mediaSize.width;
    final height = constraints.maxHeight.isFinite
        ? constraints.maxHeight
        : mediaSize.height;
    return breakPointDataForSize(
      Size(width, height),
      considerOrientation: considerOrientation,
    );
  }
}
