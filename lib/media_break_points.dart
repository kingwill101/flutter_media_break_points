/// A comprehensive library for responsive design in Flutter applications.
///
/// This library provides a set of tools to create responsive UIs that adapt
/// to different screen sizes and device types. It follows standard responsive
/// design patterns with breakpoints for extra small (xs), small (sm), medium (md),
/// large (lg), extra large (xl), and extra extra large (xxl) screen sizes.
///
/// The library consists of several components:
///
/// 1. Media Query utilities (`media_query.dart`):
///    - Functions to determine the current screen size breakpoint
///    - Extensions on BuildContext for easy breakpoint checking
///    - Utilities to apply different values based on screen size
///
/// 2. Adaptive widgets (`adaptive.dart`):
///    - Widgets that display different content based on screen size
///    - Support for animated transitions between layouts
///    - Utilities for creating responsive values
///
/// 3. Responsive Grid System (`grid.dart`):
///    - A flexible grid layout that adapts to different screen sizes
///    - Support for different column spans at different breakpoints
///
/// 4. Responsive Spacing (`spacing.dart`):
///    - Utilities for creating responsive paddings, margins, and gaps
///
/// 5. Responsive Typography (`typography.dart`):
///    - Utilities for creating text styles that adapt to different screen sizes
///
/// 6. Device Detection (`device.dart`):
///    - Utilities for detecting device types and capabilities
///
/// 7. Responsive Visibility (`visibility.dart`):
///    - Widgets for showing or hiding content based on screen size
///
/// 8. Responsive Layout Builder (`layout_builder.dart`):
///    - A flexible builder for creating different layouts at different breakpoints
///
/// 9. Configuration (`config.dart`):
///    - Utilities for customizing the library's behavior
///
/// Example usage:
///
/// // Check current breakpoint
/// if (context.isSmall) {
///   // Use mobile layout
/// } else if (context.isLarge) {
///   // Use desktop layout
/// }
///
/// // Apply different values based on screen size
/// final padding = valueFor<EdgeInsets>(
///   context,
///   xs: EdgeInsets.all(8),
///   md: EdgeInsets.all(16),
///   lg: EdgeInsets.all(24),
/// );
///
/// // Use responsive grid
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
///   ],
/// )
///
/// // Use responsive visibility
/// ResponsiveVisibility(
///   visibleWhen: {
///     Condition.largerThan(name: BreakPoint.sm): true,
///   },
///   replacement: MobileMenu(),
///   child: DesktopMenu(),
/// )
///
/// // Use responsive layout builder
/// ResponsiveLayoutBuilder(
///   xs: (context, _) => MobileLayout(),
///   md: (context, _) => TabletLayout(),
///   lg: (context, _) => DesktopLayout(),
/// )
///
library media_break_points;

export 'src/media_query.dart';
export 'src/adaptive.dart';
export 'src/grid.dart';
export 'src/spacing.dart';
export 'src/typography.dart';
export 'src/device.dart';
export 'src/visibility.dart';
export 'src/layout_builder.dart';
export 'src/config.dart';
