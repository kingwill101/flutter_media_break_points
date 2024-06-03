import 'package:flutter/material.dart';
import 'media_query.dart';

enum BreakPoint {
  xs,
  sm,
  md,
  lg,
  xl,
  xxl,
}


typedef AdaptiveTransition = Widget Function(Widget, Animation<double>);

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
  final int animationDuration;
  final AdaptiveTransition? transitionBuilder;
  final bool enableAnimation;

  const AdaptiveContainer(
      {Key? key,
      this.configs = const {},
      this.animationDuration = 0,
      this.enableAnimation = false,
      this.transitionBuilder})
      : super(key: key);

  @override
  _AdaptiveContainerState createState() => _AdaptiveContainerState();
}

class _AdaptiveContainerState extends State<AdaptiveContainer> {
  bool hasConfig(BreakPoint breakPoint) =>
      widget.configs.containsKey(breakPoint);
  AdaptiveSlot config(BreakPoint breakPoint) =>
      widget.configs[breakPoint] != null
          ? widget.configs[breakPoint]!
          : AdaptiveSlot(
              builder: (_) =>  SizedBox.shrink());

  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder to rebuild the widget when the screen size changes
    return LayoutBuilder(
      builder: (context, constraints) {
        var child = hasConfig(context.breakPoint)
            ? config(context.breakPoint)
            : SizedBox.shrink();

        if (!widget.enableAnimation) {
          return child;
        }
        // Use AnimatedSwitcher to animate the transition between widgets
        return AnimatedSwitcher(
          duration: Duration(milliseconds: widget.animationDuration),
          child: child,
          transitionBuilder: (Widget child, Animation<double> animation) {
            if (widget.transitionBuilder != null) {
              return widget.transitionBuilder!(child, animation);
            }
            return FadeTransition(child: child, opacity: animation);
          },
        );
      },
    );
  }
}
