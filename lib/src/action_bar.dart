import 'package:flutter/material.dart';

/// Inline presentation style used by [AdaptiveActionBarAction].
enum AdaptiveActionVariant {
  filled,
  tonal,
  outlined,
  text,
  icon,
}

/// Action definition used by [AdaptiveActionBar].
class AdaptiveActionBarAction {
  /// Optional key for the inline action widget.
  final Key? key;

  /// Icon shown for the action.
  final Widget icon;

  /// Text label used inline and in the overflow menu.
  final String label;

  /// Callback invoked when the action is activated.
  final VoidCallback? onPressed;

  /// Higher priority actions stay visible longer.
  final int priority;

  /// Visual presentation used for the inline action.
  final AdaptiveActionVariant variant;

  /// Tooltip shown for icon-only actions and overflow entries.
  final String? tooltip;

  /// Whether this action should remain inline whenever possible.
  final bool pinToPrimaryRow;

  /// Creates an adaptive action definition.
  const AdaptiveActionBarAction({
    required this.icon,
    required this.label,
    this.onPressed,
    this.key,
    this.priority = 0,
    this.variant = AdaptiveActionVariant.tonal,
    this.tooltip,
    this.pinToPrimaryRow = false,
  });
}

/// A toolbar that keeps high-priority actions inline and moves the rest into
/// an overflow menu as space becomes constrained.
class AdaptiveActionBar extends StatelessWidget {
  /// Actions managed by the bar.
  final List<AdaptiveActionBarAction> actions;

  /// Spacing between visible inline actions.
  final double spacing;

  /// Alignment of the action row.
  final MainAxisAlignment alignment;

  /// Icon used for the overflow menu trigger.
  final Widget overflowIcon;

  /// Tooltip used for the overflow menu trigger.
  final String overflowTooltip;

  /// Whether the action bar should use parent constraints instead of screen
  /// width when resolving available width.
  final bool useContainerConstraints;

  /// Creates an adaptive action bar.
  const AdaptiveActionBar({
    super.key,
    required this.actions,
    this.spacing = 8,
    this.alignment = MainAxisAlignment.start,
    this.overflowIcon = const Icon(Icons.more_horiz),
    this.overflowTooltip = 'More actions',
    this.useContainerConstraints = true,
  });

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final mediaWidth = MediaQuery.maybeOf(context)?.size.width ?? 0;
        final availableWidth =
            useContainerConstraints && constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : mediaWidth;
        final layout = _resolveLayout(context, availableWidth);

        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: alignment,
          children: [
            Flexible(
              child: Wrap(
                spacing: spacing,
                runSpacing: spacing,
                alignment: _wrapAlignmentFor(alignment),
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  for (final entry in layout.visible)
                    _buildInlineAction(context, entry.action),
                  if (layout.overflow.isNotEmpty)
                    _buildOverflowButton(context, layout.overflow),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  _AdaptiveActionLayout _resolveLayout(
    BuildContext context,
    double availableWidth,
  ) {
    final indexed = [
      for (var index = 0; index < actions.length; index++)
        _IndexedAdaptiveAction(index: index, action: actions[index]),
    ];
    final visible = [...indexed];
    final overflow = <_IndexedAdaptiveAction>[];
    final overflowButtonWidth = _estimateOverflowButtonWidth();

    double visibleWidth() {
      if (visible.isEmpty) {
        return 0;
      }
      final widths = visible
          .map((entry) => _estimateActionWidth(context, entry.action))
          .fold<double>(0, (sum, width) => sum + width);
      final gaps = spacing * (visible.length - 1);
      return widths + gaps;
    }

    while (visible.isNotEmpty) {
      final hasOverflow = overflow.isNotEmpty;
      final requiredWidth =
          visibleWidth() + (hasOverflow ? spacing + overflowButtonWidth : 0);
      if (requiredWidth <= availableWidth) {
        break;
      }

      final removable = visible.where((entry) {
        return !entry.action.pinToPrimaryRow;
      }).toList();
      if (removable.isEmpty) {
        break;
      }

      removable.sort((a, b) {
        final byPriority = a.action.priority.compareTo(b.action.priority);
        if (byPriority != 0) {
          return byPriority;
        }
        return b.index.compareTo(a.index);
      });
      final toOverflow = removable.first;
      visible.remove(toOverflow);
      overflow.add(toOverflow);
    }

    visible.sort((a, b) => a.index.compareTo(b.index));
    overflow.sort((a, b) => a.index.compareTo(b.index));
    return _AdaptiveActionLayout(visible: visible, overflow: overflow);
  }

  Widget _buildInlineAction(
    BuildContext context,
    AdaptiveActionBarAction action,
  ) {
    return switch (action.variant) {
      AdaptiveActionVariant.filled => FilledButton.icon(
          key: action.key,
          onPressed: action.onPressed,
          icon: action.icon,
          label: Text(action.label),
        ),
      AdaptiveActionVariant.tonal => FilledButton.tonalIcon(
          key: action.key,
          onPressed: action.onPressed,
          icon: action.icon,
          label: Text(action.label),
        ),
      AdaptiveActionVariant.outlined => OutlinedButton.icon(
          key: action.key,
          onPressed: action.onPressed,
          icon: action.icon,
          label: Text(action.label),
        ),
      AdaptiveActionVariant.text => TextButton.icon(
          key: action.key,
          onPressed: action.onPressed,
          icon: action.icon,
          label: Text(action.label),
        ),
      AdaptiveActionVariant.icon => IconButton(
          key: action.key,
          onPressed: action.onPressed,
          icon: action.icon,
          tooltip: action.tooltip ?? action.label,
        ),
    };
  }

  Widget _buildOverflowButton(
    BuildContext context,
    List<_IndexedAdaptiveAction> overflow,
  ) {
    return PopupMenuButton<int>(
      tooltip: overflowTooltip,
      icon: overflowIcon,
      onSelected: (selectedIndex) {
        final action =
            overflow.firstWhere((entry) => entry.index == selectedIndex).action;
        action.onPressed?.call();
      },
      itemBuilder: (context) {
        return [
          for (final entry in overflow)
            PopupMenuItem<int>(
              value: entry.index,
              child: Row(
                children: [
                  entry.action.icon,
                  const SizedBox(width: 12),
                  Expanded(child: Text(entry.action.label)),
                ],
              ),
            ),
        ];
      },
    );
  }

  double _estimateActionWidth(
    BuildContext context,
    AdaptiveActionBarAction action,
  ) {
    if (action.variant == AdaptiveActionVariant.icon) {
      return kMinInteractiveDimension;
    }

    final textStyle =
        Theme.of(context).textTheme.labelLarge ?? const TextStyle(fontSize: 14);
    final textPainter = TextPainter(
      text: TextSpan(text: action.label, style: textStyle),
      textDirection: Directionality.of(context),
      maxLines: 1,
    )..layout();
    final textWidth = textPainter.width;

    return switch (action.variant) {
      AdaptiveActionVariant.filled ||
      AdaptiveActionVariant.tonal ||
      AdaptiveActionVariant.outlined ||
      AdaptiveActionVariant.text =>
        textWidth + 76,
      AdaptiveActionVariant.icon => kMinInteractiveDimension,
    };
  }

  double _estimateOverflowButtonWidth() {
    return kMinInteractiveDimension;
  }

  WrapAlignment _wrapAlignmentFor(MainAxisAlignment alignment) {
    return switch (alignment) {
      MainAxisAlignment.center => WrapAlignment.center,
      MainAxisAlignment.end => WrapAlignment.end,
      MainAxisAlignment.spaceBetween => WrapAlignment.spaceBetween,
      MainAxisAlignment.spaceAround => WrapAlignment.spaceAround,
      MainAxisAlignment.spaceEvenly => WrapAlignment.spaceEvenly,
      MainAxisAlignment.start => WrapAlignment.start,
    };
  }
}

class _IndexedAdaptiveAction {
  final int index;
  final AdaptiveActionBarAction action;

  const _IndexedAdaptiveAction({
    required this.index,
    required this.action,
  });
}

class _AdaptiveActionLayout {
  final List<_IndexedAdaptiveAction> visible;
  final List<_IndexedAdaptiveAction> overflow;

  const _AdaptiveActionLayout({
    required this.visible,
    required this.overflow,
  });
}
