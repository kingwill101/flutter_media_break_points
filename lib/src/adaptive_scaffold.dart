import 'package:flutter/material.dart';

import 'media_query.dart';

/// Navigation destination used by [AdaptiveScaffold].
class AdaptiveScaffoldDestination {
  /// Icon shown when the destination is not selected.
  final Widget icon;

  /// Optional icon shown when the destination is selected.
  final Widget? selectedIcon;

  /// Text label for the destination.
  final String label;

  /// Optional tooltip shown for rail and drawer navigation.
  final String? tooltip;

  /// Creates a destination definition that can render across navigation types.
  const AdaptiveScaffoldDestination({
    required this.icon,
    required this.label,
    this.selectedIcon,
    this.tooltip,
  });
}

/// Active navigation shell used by [AdaptiveScaffold].
enum AdaptiveScaffoldMode {
  compact,
  medium,
  expanded,
}

/// A scaffold that switches navigation chrome across compact, medium,
/// and expanded layouts.
class AdaptiveScaffold extends StatelessWidget {
  /// Main content of the screen.
  final Widget body;

  /// Optional app bar shared across all layout sizes.
  final PreferredSizeWidget? appBar;

  /// Responsive destinations used for bottom nav, rail, and drawer modes.
  final List<AdaptiveScaffoldDestination> destinations;

  /// Currently selected destination index.
  final int selectedIndex;

  /// Called when a destination is selected.
  final ValueChanged<int>? onSelectedIndexChanged;

  /// Optional floating action button.
  final Widget? floatingActionButton;

  /// Floating action button location.
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Optional header shown above rail and drawer navigation.
  final Widget? navigationHeader;

  /// Optional footer shown below rail and drawer navigation.
  final Widget? navigationFooter;

  /// Width of the expanded drawer-style navigation.
  final double expandedNavigationWidth;

  /// Minimum width for the medium rail navigation.
  final double railMinWidth;

  /// Label behavior for the medium rail.
  final NavigationRailLabelType railLabelType;

  /// Minimum height class required before the medium rail is allowed.
  ///
  /// Below this threshold, medium-width layouts demote to compact navigation.
  final AdaptiveHeight minimumRailHeight;

  /// Minimum height class required before the expanded drawer is allowed.
  ///
  /// Below this threshold, expanded layouts demote to the medium rail first.
  final AdaptiveHeight minimumDrawerHeight;

  /// Optional scaffold background color.
  final Color? backgroundColor;

  /// Whether navigation changes should animate between scaffold modes.
  final bool animateTransitions;

  /// Duration of scaffold transition animations.
  final Duration transitionDuration;

  /// Curve used by scaffold transition animations.
  final Curve transitionCurve;

  /// Optional transition builder for the side navigation pane.
  final AnimatedSwitcherTransitionBuilder? navigationTransitionBuilder;

  /// Optional transition builder for the bottom navigation bar.
  final AnimatedSwitcherTransitionBuilder? bottomNavigationTransitionBuilder;

  /// Creates an adaptive scaffold.
  const AdaptiveScaffold({
    super.key,
    required this.body,
    required this.destinations,
    required this.selectedIndex,
    this.onSelectedIndexChanged,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.navigationHeader,
    this.navigationFooter,
    this.expandedNavigationWidth = 320,
    this.railMinWidth = 88,
    this.railLabelType = NavigationRailLabelType.all,
    this.minimumRailHeight = AdaptiveHeight.compact,
    this.minimumDrawerHeight = AdaptiveHeight.compact,
    this.backgroundColor,
    this.animateTransitions = false,
    this.transitionDuration = const Duration(milliseconds: 250),
    this.transitionCurve = Curves.easeInOutCubic,
    this.navigationTransitionBuilder,
    this.bottomNavigationTransitionBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (destinations.isEmpty) {
      return Scaffold(
        appBar: appBar,
        body: body,
        backgroundColor: backgroundColor,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
      );
    }

    final mode = _modeForData(context.breakPointData);
    final duration = animateTransitions ? transitionDuration : Duration.zero;
    final dividerColor = Theme.of(context).dividerColor;

    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      body: Row(
        children: [
          AnimatedContainer(
            duration: duration,
            curve: transitionCurve,
            width: _navigationWidthForMode(mode),
            child: ClipRect(
              child: AnimatedSwitcher(
                duration: duration,
                switchInCurve: transitionCurve,
                switchOutCurve: transitionCurve.flipped,
                transitionBuilder:
                    navigationTransitionBuilder ?? _defaultNavigationTransition,
                child: KeyedSubtree(
                  key: ValueKey('nav-${mode.name}'),
                  child: _navigationPaneForMode(context, mode),
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: duration,
            curve: transitionCurve,
            width: mode == AdaptiveScaffoldMode.compact ? 0 : 1,
            color: dividerColor,
          ),
          Expanded(child: body),
        ],
      ),
      bottomNavigationBar: AnimatedSwitcher(
        duration: duration,
        switchInCurve: transitionCurve,
        switchOutCurve: transitionCurve.flipped,
        transitionBuilder: bottomNavigationTransitionBuilder ??
            _defaultBottomNavigationTransition,
        child: mode == AdaptiveScaffoldMode.compact
            ? KeyedSubtree(
                key: const ValueKey('compact-bottom-nav'),
                child: _buildBottomNavigationBar(),
              )
            : const SizedBox.shrink(
                key: ValueKey('non-compact-bottom-nav'),
              ),
      ),
    );
  }

  AdaptiveScaffoldMode _modeForData(BreakPointData data) {
    var mode = switch (data.adaptiveSize) {
      AdaptiveSize.compact => AdaptiveScaffoldMode.compact,
      AdaptiveSize.medium => AdaptiveScaffoldMode.medium,
      AdaptiveSize.expanded => AdaptiveScaffoldMode.expanded,
    };

    if (mode == AdaptiveScaffoldMode.expanded &&
        data.adaptiveHeight.index < minimumDrawerHeight.index) {
      mode = AdaptiveScaffoldMode.medium;
    }

    if (mode == AdaptiveScaffoldMode.medium &&
        data.adaptiveHeight.index < minimumRailHeight.index) {
      mode = AdaptiveScaffoldMode.compact;
    }

    return mode;
  }

  double _navigationWidthForMode(AdaptiveScaffoldMode mode) {
    return switch (mode) {
      AdaptiveScaffoldMode.compact => 0,
      AdaptiveScaffoldMode.medium => railMinWidth,
      AdaptiveScaffoldMode.expanded => expandedNavigationWidth,
    };
  }

  Widget _navigationPaneForMode(
    BuildContext context,
    AdaptiveScaffoldMode mode,
  ) {
    return switch (mode) {
      AdaptiveScaffoldMode.compact => const SizedBox.shrink(),
      AdaptiveScaffoldMode.medium => _MediumNavigationPane(
          selectedIndex: selectedIndex,
          onSelectedIndexChanged: onSelectedIndexChanged,
          destinations: destinations,
          leading: navigationHeader,
          trailing: navigationFooter,
          railMinWidth: railMinWidth,
          railLabelType: railLabelType,
        ),
      AdaptiveScaffoldMode.expanded => _ExpandedNavigationPane(
          destinations: destinations,
          selectedIndex: selectedIndex,
          onSelectedIndexChanged: onSelectedIndexChanged,
          header: navigationHeader,
          footer: navigationFooter,
          railMinWidth: railMinWidth,
          railLabelType: railLabelType,
        ),
    };
  }

  Widget _buildBottomNavigationBar() {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onSelectedIndexChanged,
      destinations: [
        for (final destination in destinations)
          NavigationDestination(
            icon: destination.icon,
            selectedIcon: destination.selectedIcon ?? destination.icon,
            label: destination.label,
            tooltip: destination.tooltip,
          ),
      ],
    );
  }

  Widget _defaultNavigationTransition(
    Widget child,
    Animation<double> animation,
  ) {
    final offsetAnimation = Tween<Offset>(
      begin: const Offset(-0.08, 0),
      end: Offset.zero,
    ).animate(animation);
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: offsetAnimation,
        child: child,
      ),
    );
  }

  Widget _defaultBottomNavigationTransition(
    Widget child,
    Animation<double> animation,
  ) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        axisAlignment: -1,
        child: child,
      ),
    );
  }
}

class _MediumNavigationPane extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onSelectedIndexChanged;
  final List<AdaptiveScaffoldDestination> destinations;
  final Widget? leading;
  final Widget? trailing;
  final double railMinWidth;
  final NavigationRailLabelType railLabelType;

  const _MediumNavigationPane({
    required this.selectedIndex,
    required this.onSelectedIndexChanged,
    required this.destinations,
    required this.leading,
    required this.trailing,
    required this.railMinWidth,
    required this.railLabelType,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // During animated mode transitions the rail can briefly receive less
        // width than its own minimum. Hide it until there is enough room.
        if (constraints.maxWidth < railMinWidth) {
          return const SizedBox.shrink();
        }

        final useCollapsedRailChrome = constraints.maxHeight < 360;
        final useScrollableRail = constraints.maxHeight < 520;
        final resolvedLabelType = useCollapsedRailChrome
            ? NavigationRailLabelType.none
            : railLabelType;
        final resolvedLeading = useCollapsedRailChrome ? null : leading;
        final resolvedTrailing = useCollapsedRailChrome ? null : trailing;

        return SafeArea(
          child: NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onSelectedIndexChanged,
            minWidth: railMinWidth,
            labelType: resolvedLabelType,
            leading: resolvedLeading,
            trailing: resolvedTrailing,
            leadingAtTop: !useScrollableRail,
            trailingAtBottom: !useScrollableRail,
            scrollable: useScrollableRail,
            destinations: [
              for (final destination in destinations)
                NavigationRailDestination(
                  icon: destination.icon,
                  selectedIcon: destination.selectedIcon ?? destination.icon,
                  label: Text(destination.label),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ExpandedNavigationPane extends StatelessWidget {
  final List<AdaptiveScaffoldDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int>? onSelectedIndexChanged;
  final Widget? header;
  final Widget? footer;
  final double railMinWidth;
  final NavigationRailLabelType railLabelType;

  const _ExpandedNavigationPane({
    required this.destinations,
    required this.selectedIndex,
    this.onSelectedIndexChanged,
    this.header,
    this.footer,
    required this.railMinWidth,
    required this.railLabelType,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 200) {
          return _MediumNavigationPane(
            selectedIndex: selectedIndex,
            onSelectedIndexChanged: onSelectedIndexChanged,
            destinations: destinations,
            leading: header,
            trailing: footer,
            railMinWidth: railMinWidth,
            railLabelType: railLabelType,
          );
        }

        return Material(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (header != null) header!,
                Expanded(
                  child: NavigationDrawer(
                    selectedIndex: selectedIndex,
                    onDestinationSelected: onSelectedIndexChanged,
                    children: [
                      for (final destination in destinations)
                        NavigationDrawerDestination(
                          icon: destination.icon,
                          selectedIcon:
                              destination.selectedIcon ?? destination.icon,
                          label: Text(destination.label),
                        ),
                    ],
                  ),
                ),
                if (footer != null) footer!,
              ],
            ),
          ),
        );
      },
    );
  }
}
