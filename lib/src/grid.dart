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
    required this.child,
  });

  /// Gets the number of columns this item should span based on the current breakpoint.
  int getSpan(BuildContext context) {
    return valueFor<int>(
      context,
      xs: xs,
      sm: sm,
      md: md,
      lg: lg,
      xl: xl,
      xxl: xxl,
      defaultValue: xs,
    )!;
  }
}
