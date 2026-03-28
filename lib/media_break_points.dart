/// A responsive design toolkit for Flutter applications.
///
/// The package is organized around a small core:
///
/// - Core engine: breakpoint data, semantic width and height classes,
///   responsive values, fluid interpolation, container-aware builders,
///   spacing, typography, visibility, and debug overlays.
/// - Core primitives: reusable spatial behaviors such as panes, inspectors,
///   sections, action bars, forms, clusters, and responsive grids.
/// - Core shells and surfaces: the small set of higher-level APIs that form
///   the main package story, such as [AdaptiveScaffold],
///   [AdaptiveWorkspaceShell], [AdaptiveDataView], [AdaptiveFilterLayout],
///   [AdaptiveResultBrowser], [AdaptiveDocumentView], and [AdaptiveDiffView].
/// Showcase patterns are intentionally split into
/// `package:media_break_points/patterns.dart` so the core package surface stays
/// focused on layout primitives and reusable adaptive shells.
///
/// Typical adoption flow:
///
/// 1. Start with [BreakPointData], [ResponsiveValue], and
///    [ResponsiveContainerBuilder].
/// 2. Compose with primitives such as [AdaptivePane], [AdaptiveSections],
///    [AdaptiveInspectorLayout], and [AutoResponsiveGrid].
/// 3. Add shells and surfaces such as [AdaptiveScaffold],
///    [AdaptiveWorkspaceShell], or [AdaptiveResultBrowser] where they fit.
///
/// Example usage:
///
/// ```dart
/// final gap = context.responsive<double>(
///   compact: 12,
///   medium: 20,
///   expanded: 28,
/// );
///
/// ResponsiveContainerBuilder(
///   builder: (context, data) {
///     if (data.isCompact) {
///       return const CompactPane();
///     }
///
///     return const SplitPane();
///   },
/// );
/// ```
library media_break_points;

// Core engine.
export 'src/media_query.dart';
export 'src/fluid.dart';
export 'src/adaptive.dart';
export 'src/cluster.dart';
export 'src/grid.dart';
export 'src/spacing.dart';
export 'src/typography.dart';
export 'src/device.dart';
export 'src/visibility.dart';
export 'src/layout_builder.dart';
export 'src/container_layout.dart';
export 'src/debug.dart';
export 'src/config.dart';

// Core primitives.
export 'src/action_bar.dart';
export 'src/adaptive_form.dart';
export 'src/priority_layout.dart';
export 'src/inspector_layout.dart';
export 'src/pane.dart';
export 'src/sections.dart';

// Core shells and surfaces.
export 'src/adaptive_scaffold.dart';
export 'src/workspace_shell.dart';
export 'src/data_view.dart';
export 'src/filter_layout.dart';
export 'src/result_browser.dart';
export 'src/document_view.dart';
export 'src/diff_view.dart';
