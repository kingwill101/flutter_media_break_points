import 'package:flutter/material.dart';
import 'media_query.dart';

enum BreakPoint {
  deafult,
  xs,
  sm,
  md,
  lg,
  xl,
  xxl,
}

BreakPoint contextToBreakPoint(BuildContext context) {
  if (context.isExtraSmall) return BreakPoint.xs;
  if (context.isSmall) return BreakPoint.sm;
  if (context.isMedium) return BreakPoint.md;
  if (context.isLarge) return BreakPoint.lg;
  if (context.isExtraLarge) return BreakPoint.xl;
  if (context.isExtraExtraLarge) return BreakPoint.xxl;

  return BreakPoint.deafult;
}

class AdaptiveSlot extends StatelessWidget {
  final WidgetBuilder builder;

  const AdaptiveSlot({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: builder,
    );
  }
}

class AdaptiveContainer extends StatefulWidget {
  final Map<BreakPoint, AdaptiveSlot> configs;

  const AdaptiveContainer({Key? key, this.configs = const {}})
      : super(key: key);

  @override
  _AdaptiveContainerState createState() => _AdaptiveContainerState();
}

class _AdaptiveContainerState extends State<AdaptiveContainer> {
  BreakPoint? _currentBreakpoint;
  bool hasConfig(BreakPoint breakPoint) =>
      widget.configs.containsKey(breakPoint);
  AdaptiveSlot config(BreakPoint breakPoint) =>
      widget.configs[breakPoint] != null
          ? widget.configs[breakPoint]!
          : AdaptiveSlot(builder: (_) => SizedBox.shrink());

  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder to rebuild the widget when the screen size changes
    return LayoutBuilder(
      builder: (context, constraints) {
        final bp = contextToBreakPoint(context);

        // Schedule a callback for the end of this frame to update the state
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_currentBreakpoint == null || bp != _currentBreakpoint) {
            setState(() {
              _currentBreakpoint = bp;
            });
          }
        });

        // Use AnimatedSwitcher to animate the transition between widgets
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: hasConfig(bp)
              ? config(bp)
              : widget.configs.containsKey(BreakPoint.deafult)
                  ? config(BreakPoint.deafult)
                  : SizedBox.shrink(),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(child: child, opacity: animation);
          },
        );
      },
    );
  }
}
