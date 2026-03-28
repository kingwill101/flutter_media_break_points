import 'package:flutter/material.dart';

import 'media_query.dart';

/// Builder signature for container-aware responsive widgets.
typedef ResponsiveContainerWidgetBuilder = Widget Function(
  BuildContext context,
  BreakPointData data,
);

/// Builds responsive layouts using the width of the parent constraints.
///
/// This is useful when a widget lives inside a pane, card, or sidebar and
/// should adapt to the container width instead of the full screen width.
class ResponsiveContainerBuilder extends StatelessWidget {
  /// Called with breakpoint metadata derived from the parent constraints.
  final ResponsiveContainerWidgetBuilder builder;

  /// Whether landscape containers should bump to the next breakpoint.
  ///
  /// This defaults to `false` because container queries are usually based on
  /// raw available width.
  final bool considerOrientation;

  /// Creates a container-aware responsive builder.
  const ResponsiveContainerBuilder({
    super.key,
    required this.builder,
    this.considerOrientation = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mediaSize = MediaQuery.maybeOf(context)?.size ?? Size.zero;
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : mediaSize.width;
        final height = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : mediaSize.height;
        final data = breakPointDataForSize(
          Size(width, height),
          considerOrientation: considerOrientation,
        );
        return builder(context, data);
      },
    );
  }
}
