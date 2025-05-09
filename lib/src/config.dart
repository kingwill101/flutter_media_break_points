import 'package:media_break_points/media_break_points.dart' show screenSize;
import 'package:media_break_points/src/adaptive.dart' show BreakPoint;
import 'package:media_break_points/src/media_query.dart' show setConsiderOrientation;

/// Configuration options for customizing the media breakpoints.
class MediaBreakPointsConfig {
  /// Custom breakpoint ranges that override the default values.
  ///
  /// If provided, these values will replace the default breakpoint ranges.
  final Map<BreakPoint, (double, double)>? customBreakpoints;
  
  /// Whether to use device orientation when determining breakpoints.
  ///
  /// When true, the library will consider both width and orientation
  /// when determining the appropriate breakpoint.
  final bool considerOrientation;
  
  /// Creates a configuration for media breakpoints.
  const MediaBreakPointsConfig({
    this.customBreakpoints,
    this.considerOrientation = false,
  });
  
  /// Initializes the library with this configuration.
  void apply() {
    if (customBreakpoints != null) {
      screenSize = customBreakpoints!;
    }
    setConsiderOrientation(considerOrientation);
  }
}

/// Initialize the library with custom configuration.
///
/// Call this method early in your app's initialization to customize
/// the breakpoint behavior.
///
/// Example:
/// 
/// void main() {
///   initMediaBreakPoints(
///     MediaBreakPointsConfig(
///       customBreakpoints: {
///         BreakPoint.xs: (0, 480),
///         BreakPoint.sm: (481, 768),
///         // ...
///       },
///       considerOrientation: true,
///     ),
///   );
///   runApp(MyApp());
/// }
/// 
void initMediaBreakPoints(MediaBreakPointsConfig config) {
  config.apply();
}