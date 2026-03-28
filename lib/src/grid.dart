import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'media_query.dart';

/// A responsive grid layout that adapts to different screen sizes.
///
/// This widget creates a grid with a specified number of columns that
/// adjusts based on the current breakpoint.
///
/// Example:
///
/// ResponsiveGrid(
///   children: [
///     ResponsiveGridItem(
///       xs: 12, // Full width on extra small screens
///       sm: 6,  // Half width on small screens
///       md: 4,  // One-third width on medium screens
///       child: Container(color: Colors.red),
///     ),
///     ResponsiveGridItem(
///       xs: 12,
///       sm: 6,
///       md: 4,
///       child: Container(color: Colors.blue),
///     ),
///     // More items...
///   ],
/// )
///
class ResponsiveGrid extends StatelessWidget {
  /// The number of columns in the grid.
  final int columns;

  /// The spacing between columns.
  final double columnSpacing;

  /// The spacing between rows.
  final double rowSpacing;

  /// The child widgets to display in the grid.
  final List<ResponsiveGridItem> children;

  /// Creates a responsive grid.
  ///
  /// The [columns] parameter defaults to 12, which is a common grid size
  /// in responsive design systems.
  const ResponsiveGrid({
    Key? key,
    this.columns = 12,
    this.columnSpacing = 16.0,
    this.rowSpacing = 16.0,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final itemWidth = (width - (columnSpacing * (columns - 1))) / columns;

        final rows = <List<Widget>>[];
        List<Widget> currentRow = [];
        int currentRowWidth = 0;

        for (final child in children) {
          // Determine how many columns this item should span
          final span = child.getSpan(context);

          // If adding this item would exceed the row width, start a new row
          if (currentRowWidth + span > columns) {
            rows.add(List.from(currentRow));
            currentRow = [];
            currentRowWidth = 0;
          }

          // Add the item to the current row
          currentRow.add(
            SizedBox(
              width: itemWidth * span + columnSpacing * (span - 1),
              child: child.child,
            ),
          );
          currentRowWidth += span;

          // If we've filled the row, start a new one
          if (currentRowWidth == columns) {
            rows.add(List.from(currentRow));
            currentRow = [];
            currentRowWidth = 0;
          }
        }

        // Add any remaining items
        if (currentRow.isNotEmpty) {
          rows.add(currentRow);
        }

        // Build the grid
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < rows.length; i++)
              Padding(
                padding: EdgeInsets.only(
                    bottom: i < rows.length - 1 ? rowSpacing : 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int j = 0; j < rows[i].length; j++)
                      Padding(
                        padding: EdgeInsets.only(
                            right: j < rows[i].length - 1 ? columnSpacing : 0),
                        child: rows[i][j],
                      ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

/// An item in a [ResponsiveGrid] that can span different numbers of columns
/// based on the current breakpoint.
class ResponsiveGridItem {
  /// The number of columns this item should span on extra small screens.
  final int xs;

  /// The number of columns this item should span on small screens.
  final int? sm;

  /// The number of columns this item should span on medium screens.
  final int? md;

  /// The number of columns this item should span on large screens.
  final int? lg;

  /// The number of columns this item should span on extra large screens.
  final int? xl;

  /// The number of columns this item should span on extra extra large screens.
  final int? xxl;

  /// The number of columns this item should span on compact layouts.
  final int? compact;

  /// The number of columns this item should span on medium layouts.
  final int? medium;

  /// The number of columns this item should span on expanded layouts.
  final int? expanded;

  /// The widget to display in this grid item.
  final Widget child;

  /// Creates a responsive grid item.
  ///
  /// The [xs] parameter is required and specifies the number of columns
  /// this item should span on extra small screens. Other parameters are
  /// optional and will default to the value of the next smaller breakpoint
  /// if not specified.
  const ResponsiveGridItem({
    required this.xs,
    this.sm,
    this.md,
    this.lg,
    this.xl,
    this.xxl,
    this.compact,
    this.medium,
    this.expanded,
    required this.child,
  });

  /// Gets the number of columns this item should span based on the current breakpoint.
  int getSpan(BuildContext context) {
    return ResponsiveValue<int>(
      xs: xs,
      sm: sm,
      md: md,
      lg: lg,
      xl: xl,
      xxl: xxl,
      compact: compact,
      medium: medium,
      expanded: expanded,
      defaultValue: xs,
      resolveMode: ResponsiveResolveMode.cascadeDown,
    ).resolve(context)!;
  }
}

/// A responsive grid that automatically derives the number of columns from the
/// available width.
class AutoResponsiveGrid extends StatelessWidget {
  /// Minimum width each item should try to maintain.
  final double minItemWidth;

  /// Minimum number of columns to show.
  final int minColumns;

  /// Optional maximum number of columns to show.
  final int? maxColumns;

  /// Horizontal spacing between items.
  final double columnSpacing;

  /// Vertical spacing between items.
  final double rowSpacing;

  /// Widgets displayed in the grid.
  final List<Widget> children;

  /// Creates an auto-fitting responsive grid.
  const AutoResponsiveGrid({
    super.key,
    required this.minItemWidth,
    required this.children,
    this.minColumns = 1,
    this.maxColumns,
    this.columnSpacing = 16,
    this.rowSpacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final metrics = _autoGridMetricsFor(
          context,
          constraints,
          minItemWidth: minItemWidth,
          minColumns: minColumns,
          maxColumns: maxColumns,
          spacing: columnSpacing,
          itemCount: children.length,
        );

        return Wrap(
          spacing: columnSpacing,
          runSpacing: rowSpacing,
          children: [
            for (final child in children)
              SizedBox(
                width: metrics.itemWidth,
                child: child,
              ),
          ],
        );
      },
    );
  }
}

/// Reorder callback used by [ReorderableAutoResponsiveGrid].
///
/// The `newIndex` is the final index of the moved child after reordering.
typedef ResponsiveGridReorderCallback = void Function(
  int oldIndex,
  int newIndex,
);

/// An auto-fitting responsive grid that supports drag-and-drop reordering.
///
/// Each child must have a non-null, unique [Key].
class ReorderableAutoResponsiveGrid extends StatefulWidget {
  /// Minimum width each item should try to maintain.
  final double minItemWidth;

  /// Minimum number of columns to show.
  final int minColumns;

  /// Optional maximum number of columns to show.
  final int? maxColumns;

  /// Horizontal spacing between items.
  final double columnSpacing;

  /// Vertical spacing between items.
  final double rowSpacing;

  /// Widgets displayed in the grid.
  ///
  /// Every child must provide a stable key so it can move without losing state.
  final List<Widget> children;

  /// Called when a child is dropped into a new position.
  final ResponsiveGridReorderCallback onReorder;

  /// Whether reordering is enabled.
  final bool enabled;

  /// Opacity applied to the in-grid placeholder while an item is dragged.
  final double draggingChildOpacity;

  /// Delay before a drag starts.
  final Duration dragStartDelay;

  /// Duration used for drop target highlight transitions.
  final Duration animationDuration;

  /// Creates a reorderable responsive grid.
  const ReorderableAutoResponsiveGrid({
    super.key,
    required this.minItemWidth,
    required this.children,
    required this.onReorder,
    this.minColumns = 1,
    this.maxColumns,
    this.columnSpacing = 16,
    this.rowSpacing = 16,
    this.enabled = true,
    this.draggingChildOpacity = 0.22,
    this.dragStartDelay = kLongPressTimeout,
    this.animationDuration = const Duration(milliseconds: 180),
  }) : assert(
          draggingChildOpacity >= 0 && draggingChildOpacity <= 1,
          'draggingChildOpacity must be between 0 and 1.',
        );

  @override
  State<ReorderableAutoResponsiveGrid> createState() =>
      _ReorderableAutoResponsiveGridState();
}

class _ReorderableAutoResponsiveGridState
    extends State<ReorderableAutoResponsiveGrid> {
  int? _draggingIndex;
  int? _insertionSlot;

  @override
  Widget build(BuildContext context) {
    assert(
      widget.children.every((child) => child.key != null),
      'ReorderableAutoResponsiveGrid children must all have keys.',
    );
    assert(
      widget.children.map((child) => child.key).toSet().length ==
          widget.children.length,
      'ReorderableAutoResponsiveGrid child keys must be unique.',
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final metrics = _autoGridMetricsFor(
          context,
          constraints,
          minItemWidth: widget.minItemWidth,
          minColumns: widget.minColumns,
          maxColumns: widget.maxColumns,
          spacing: widget.columnSpacing,
          itemCount: widget.children.length,
        );
        final entries = [
          for (var index = 0; index < widget.children.length; index++)
            _IndexedGridChild(
              index: index,
              child: widget.children[index],
            ),
        ];
        final displayedEntries = _projectedEntries(entries);

        return Wrap(
          spacing: widget.columnSpacing,
          runSpacing: widget.rowSpacing,
          children: [
            for (final entry in displayedEntries)
              SizedBox(
                width: metrics.itemWidth,
                child: _buildDragTarget(
                  context,
                  entry,
                  metrics.itemWidth,
                  metrics.columnCount,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildDragTarget(
    BuildContext context,
    _IndexedGridChild entry,
    double itemWidth,
    int columnCount,
  ) {
    final theme = Theme.of(context);
    final targetKey = GlobalKey();
    final isTargeted = _draggingIndex != null &&
        _insertionSlot != null &&
        _targetHighlightsEntry(
          entry.index,
          _draggingIndex!,
          _insertionSlot!,
        );

    return DragTarget<int>(
      key: targetKey,
      onWillAcceptWithDetails: (details) {
        return widget.enabled && details.data != entry.index;
      },
      onMove: (details) {
        _updateInsertionSlot(
          draggingIndex: details.data,
          targetIndex: entry.index,
          globalOffset: details.offset,
          targetContext: targetKey.currentContext,
          columnCount: columnCount,
        );
      },
      onAcceptWithDetails: (details) {
        _updateInsertionSlot(
          draggingIndex: details.data,
          targetIndex: entry.index,
          globalOffset: details.offset,
          targetContext: targetKey.currentContext,
          columnCount: columnCount,
        );
      },
      builder: (context, candidateData, rejectedData) {
        return AnimatedContainer(
          duration: widget.animationDuration,
          curve: Curves.easeInOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: isTargeted
                ? Border.all(
                    color: theme.colorScheme.primary,
                    width: 2,
                  )
                : null,
          ),
          child: _buildDraggable(entry, itemWidth),
        );
      },
    );
  }

  Widget _buildDraggable(_IndexedGridChild entry, double itemWidth) {
    final feedback = _GridDragFeedback(
      width: itemWidth,
      child: entry.child,
    );
    final childWhenDragging = IgnorePointer(
      child: Opacity(
        opacity: widget.draggingChildOpacity,
        child: entry.child,
      ),
    );
    void startDrag() {
      setState(() {
        _draggingIndex = entry.index;
        _insertionSlot = entry.index;
      });
    }

    if (widget.dragStartDelay == Duration.zero) {
      return Draggable<int>(
        data: entry.index,
        maxSimultaneousDrags: widget.enabled ? 1 : 0,
        feedback: feedback,
        onDragStarted: startDrag,
        onDraggableCanceled: (_, __) => _resetDragState(),
        onDragEnd: (_) => _finishDrag(),
        onDragCompleted: () {},
        childWhenDragging: childWhenDragging,
        child: entry.child,
      );
    }

    return LongPressDraggable<int>(
      data: entry.index,
      delay: widget.dragStartDelay,
      maxSimultaneousDrags: widget.enabled ? 1 : 0,
      feedback: feedback,
      onDragStarted: startDrag,
      onDraggableCanceled: (_, __) => _resetDragState(),
      onDragEnd: (_) => _finishDrag(),
      onDragCompleted: () {},
      childWhenDragging: childWhenDragging,
      child: entry.child,
    );
  }

  void _updateInsertionSlot({
    required int draggingIndex,
    required int targetIndex,
    required Offset globalOffset,
    required BuildContext? targetContext,
    required int columnCount,
  }) {
    final renderBox = targetContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return;
    }
    final localOffset = renderBox.globalToLocal(globalOffset);
    final insertAfter = columnCount == 1
        ? localOffset.dy > renderBox.size.height / 2
        : localOffset.dx > renderBox.size.width / 2;
    final nextSlot = insertAfter ? targetIndex + 1 : targetIndex;

    if (_draggingIndex == draggingIndex && _insertionSlot == nextSlot) {
      return;
    }

    setState(() {
      _draggingIndex = draggingIndex;
      _insertionSlot = nextSlot;
    });
  }

  void _finishDrag() {
    final draggingIndex = _draggingIndex;
    if (draggingIndex == null) {
      _resetDragState();
      return;
    }
    final insertionSlot = _insertionSlot;
    if (insertionSlot == null) {
      _resetDragState();
      return;
    }

    final newIndex = _finalIndexFor(
      draggingIndex,
      insertionSlot,
      widget.children.length,
    );
    _resetDragState();

    if (newIndex == draggingIndex) {
      return;
    }

    widget.onReorder(draggingIndex, newIndex);
  }

  List<_IndexedGridChild> _projectedEntries(List<_IndexedGridChild> entries) {
    final draggingIndex = _draggingIndex;
    final insertionSlot = _insertionSlot;
    if (draggingIndex == null || insertionSlot == null) {
      return entries;
    }

    final currentIndex =
        entries.indexWhere((entry) => entry.index == draggingIndex);
    if (currentIndex == -1) {
      return entries;
    }

    final projected = [...entries];
    final draggedChild = projected.removeAt(currentIndex);
    projected.insert(
      _finalIndexFor(draggingIndex, insertionSlot, entries.length),
      draggedChild,
    );
    return projected;
  }

  bool _targetHighlightsEntry(
    int targetIndex,
    int draggingIndex,
    int insertionSlot,
  ) {
    final finalIndex = _finalIndexFor(
      draggingIndex,
      insertionSlot,
      widget.children.length,
    );
    return finalIndex == targetIndex;
  }

  int _finalIndexFor(int oldIndex, int insertionSlot, int itemCount) {
    if (itemCount <= 1) {
      return 0;
    }
    final adjustedIndex =
        oldIndex < insertionSlot ? insertionSlot - 1 : insertionSlot;
    return adjustedIndex.clamp(0, itemCount - 1);
  }

  void _resetDragState() {
    if (!mounted || (_draggingIndex == null && _insertionSlot == null)) {
      return;
    }
    setState(() {
      _draggingIndex = null;
      _insertionSlot = null;
    });
  }
}

class _GridDragFeedback extends StatelessWidget {
  final double width;
  final Widget child;

  const _GridDragFeedback({
    required this.width,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Opacity(
        opacity: 0.96,
        child: ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: width),
          child: child,
        ),
      ),
    );
  }
}

class _AutoGridMetrics {
  final double itemWidth;
  final int columnCount;

  const _AutoGridMetrics({
    required this.itemWidth,
    required this.columnCount,
  });
}

class _IndexedGridChild {
  final int index;
  final Widget child;

  const _IndexedGridChild({
    required this.index,
    required this.child,
  });
}

_AutoGridMetrics _autoGridMetricsFor(
  BuildContext context,
  BoxConstraints constraints, {
  required double minItemWidth,
  required int minColumns,
  required int? maxColumns,
  required double spacing,
  required int itemCount,
}) {
  final mediaWidth = MediaQuery.maybeOf(context)?.size.width ?? 0;
  final availableWidth =
      constraints.maxWidth.isFinite ? constraints.maxWidth : mediaWidth;
  final computedColumns =
      ((availableWidth + spacing) / (minItemWidth + spacing)).floor();
  final fallbackMaxColumns = itemCount <= 0 ? minColumns : itemCount;
  final maxAllowedColumns = maxColumns ?? fallbackMaxColumns;
  final columnCount = computedColumns.clamp(
    minColumns,
    maxAllowedColumns < minColumns ? minColumns : maxAllowedColumns,
  );
  final itemWidth = columnCount == 0
      ? availableWidth
      : (availableWidth - (spacing * (columnCount - 1))) / columnCount;
  return _AutoGridMetrics(
    itemWidth: itemWidth,
    columnCount: columnCount,
  );
}
