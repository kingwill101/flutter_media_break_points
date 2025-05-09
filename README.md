# Flutter Media Break Points

A comprehensive library for responsive design in Flutter applications. Easily adapt your UI, values, and layouts to different screen sizes using familiar breakpoints (xs, sm, md, lg, xl, xxl) inspired by the Bootstrap CSS framework.

[Bootstrap Breakpoints Reference](https://getbootstrap.com/docs/4.1/layout/overview/#responsive-breakpoints)

![Adaptive Container demo](example/adaptive_container.gif)

---

## Installation

Add to your `pubspec.yaml`:

```yaml
media_break_points: ^1.6.1
```

Import in your Dart code:

```dart
import 'package:media_break_points/media_break_points.dart';
```




---

## Quickstart

1. **(Optional) Configure breakpoints or orientation consideration:**

```dart
void main() {
  initMediaBreakPoints(
    MediaBreakPointsConfig(
      considerOrientation: true, // Bump breakpoint in landscape
      // customBreakpoints: { ... } // Optionally override defaults
    ),
  );
  runApp(MyApp());
}
```

2. **Use responsive utilities and widgets in your app:**

---

## Responsive Values with `valueFor`

Apply different values (padding, font size, etc.) for each breakpoint:

```dart
Container(
  padding: valueFor<EdgeInsets>(
    context,
    xs: EdgeInsets.all(8),
    md: EdgeInsets.all(16),
    lg: EdgeInsets.all(24),
    defaultValue: EdgeInsets.all(12),
  ),
  child: Text('Responsive padding'),
)
```

**How it works:**
- The value for the current breakpoint is chosen (e.g., `md` for medium screens).
- If no value is set for the current breakpoint, `defaultValue` is used.

---

## Context-Aware Values with `ValueBuilder`

For more complex or custom logic based on the context (e.g., device type, orientation, or multiple breakpoints), use `ValueBuilder` or the `context.value` extension:

```dart
// Using the function
final padding = ValueBuilder<EdgeInsets>(context, () {
  return context.isSmall ? EdgeInsets.all(8) : EdgeInsets.all(16);
});

// Using the extension (recommended)
final padding = context.value<EdgeInsets>(() {
  if (context.isLandscape && context.isMedium) {
    return EdgeInsets.symmetric(horizontal: 32, vertical: 8);
  }
  return context.isSmall ? EdgeInsets.all(8) : EdgeInsets.all(16);
});

Container(
  padding: padding,
  child: Text('Context-aware padding'),
)
```

**When to use:**
- Use `valueFor` for simple breakpoint-based values.
- Use `ValueBuilder`/`context.value` for custom logic that depends on more than just the breakpoint.

---

## Responsive Visibility

Show or hide widgets based on the current breakpoint:

```dart
ResponsiveVisibility(
  visibleXs: true, // Show on extra small screens
  visibleMd: true, // Show on medium screens
  child: Text('Visible on XS and MD'),
)
```

Or use conditions for more control:

```dart
ResponsiveVisibility(
  visibleWhen: {
    Condition.largerThan(BreakPoint.sm): true, // Show on md and up
  },
  replacement: Text('Mobile menu'),
  child: Text('Desktop menu'),
)
```

**How it works:**
- Only shows the child if the current breakpoint matches the visibility settings or conditions.
- Optionally provide a `replacement` widget when hidden.

---

## Adaptive Container

Build different widgets/layouts for each breakpoint:

```dart
AdaptiveContainer(
  configs: {
    BreakPoint.xs: AdaptiveSlot(builder: (context) => Text('XS')),
    BreakPoint.md: AdaptiveSlot(builder: (context) => Text('MD')),
    BreakPoint.lg: AdaptiveSlot(builder: (context) => Text('LG')),
  },
)
```

**How it works:**
- Only the widget for the current breakpoint is built and shown.

---

## Responsive Layout Builder

Build layouts using builder functions for each breakpoint:

```dart
ResponsiveLayoutBuilder(
  xs: (context, _) => MobileLayout(),
  md: (context, _) => TabletLayout(),
  lg: (context, _) => DesktopLayout(),
)
```

**How it works:**
- The builder for the current breakpoint is called.
- Useful for switching between entirely different layouts.

---

## Responsive Grid

Create grid layouts that adapt to screen size:

```dart
ResponsiveGrid(
  children: [
    ResponsiveGridItem(xs: 12, sm: 6, md: 4, child: Container(color: Colors.red)),
    ResponsiveGridItem(xs: 12, sm: 6, md: 4, child: Container(color: Colors.blue)),
    // ...
  ],
)
```

**How it works:**
- Each item can span a different number of columns per breakpoint.
- The grid automatically adapts to the current screen size.

---

## Responsive Spacing & Typography

```dart
// Responsive padding
padding: ResponsiveSpacing.padding(context, xs: EdgeInsets.all(8), md: EdgeInsets.all(16)),

// Responsive gap
children: [
  Text('A'),
  ResponsiveSpacing.gap(context, xs: 8, md: 16),
  Text('B'),
]

// Responsive text style
Text(
  'Hello',
  style: ResponsiveTextStyle.of(
    context,
    xs: TextStyle(fontSize: 16),
    md: TextStyle(fontSize: 20),
  ),
)
```

---

## More Examples

See the [`example/`](example/) directory for a full demo app and more advanced usage.

---

## License

MIT
