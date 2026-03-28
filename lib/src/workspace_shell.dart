import 'package:flutter/material.dart';

import 'action_bar.dart';
import 'adaptive_scaffold.dart';
import 'inspector_layout.dart';
import 'media_query.dart';

/// A higher-level adaptive shell for workspace-style screens.
///
/// This composes [AdaptiveScaffold], [AdaptiveActionBar], and
/// [AdaptiveInspectorLayout] so apps can express workspace navigation, content,
/// actions, and inspector behavior from one widget.
class AdaptiveWorkspaceShell extends StatelessWidget {
  /// Main workspace title shown in the body header.
  final String title;

  /// Optional supporting description shown below [title].
  final String? description;

  /// Primary workspace content.
  final Widget content;

  /// Optional inspector content.
  final Widget? inspector;

  /// Title used by the optional inspector surface.
  final String? inspectorTitle;

  /// Optional inspector description.
  final String? inspectorDescription;

  /// Optional leading widget for the inspector surface.
  final Widget? inspectorLeading;

  /// Optional top-level action bar content.
  final List<AdaptiveActionBarAction> actions;

  /// Optional navigation destinations for the shell.
  final List<AdaptiveScaffoldDestination> destinations;

  /// Currently selected navigation destination index.
  final int selectedIndex;

  /// Called when a navigation destination is selected.
  final ValueChanged<int>? onSelectedIndexChanged;

  /// Optional header shown above rail and drawer navigation.
  final Widget? navigationHeader;

  /// Optional footer shown below rail and drawer navigation.
  final Widget? navigationFooter;

  /// Optional app bar used by the outer scaffold.
  final PreferredSizeWidget? appBar;

  /// Optional title used when [appBar] is not provided.
  final String? appBarTitle;

  /// Optional floating action button.
  final Widget? floatingActionButton;

  /// Floating action button location.
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Optional shell background color.
  final Color? backgroundColor;

  /// Custom padding around the body content.
  final EdgeInsetsGeometry? contentPadding;

  /// Gap between body sections.
  final double sectionSpacing;

  /// Whether the body should be wrapped in a [SingleChildScrollView].
  final bool scrollBody;

  /// Alignment used for the header and body column.
  final CrossAxisAlignment crossAxisAlignment;

  /// Alignment used by the action bar row.
  final MainAxisAlignment actionsAlignment;

  /// Spacing used by the action bar.
  final double actionSpacing;

  /// Label used by the compact inspector trigger.
  final String modalInspectorLabel;

  /// Icon used by the compact inspector trigger.
  final Widget modalInspectorIcon;

  /// Adaptive size at which the inspector should dock.
  final AdaptiveSize inspectorDockedAt;

  /// Minimum height class required before the inspector can dock.
  final AdaptiveHeight minimumInspectorDockedHeight;

  /// Minimum height class required before the rail is allowed.
  final AdaptiveHeight minimumRailHeight;

  /// Minimum height class required before the drawer is allowed.
  final AdaptiveHeight minimumDrawerHeight;

  /// Whether scaffold transitions should animate.
  final bool animateScaffoldTransitions;

  /// Duration used by scaffold transition animations.
  final Duration scaffoldTransitionDuration;

  /// Curve used by scaffold transition animations.
  final Curve scaffoldTransitionCurve;

  /// Width of the expanded drawer navigation.
  final double expandedNavigationWidth;

  /// Minimum width of the rail navigation.
  final double railMinWidth;

  /// Label behavior used by the rail.
  final NavigationRailLabelType railLabelType;

  /// Whether nested layout decisions should use parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should affect container-based breakpoint selection.
  final bool considerOrientation;

  /// Creates an adaptive workspace shell.
  const AdaptiveWorkspaceShell({
    super.key,
    required this.title,
    required this.content,
    this.description,
    this.inspector,
    this.inspectorTitle,
    this.inspectorDescription,
    this.inspectorLeading,
    this.actions = const [],
    this.destinations = const [],
    this.selectedIndex = 0,
    this.onSelectedIndexChanged,
    this.navigationHeader,
    this.navigationFooter,
    this.appBar,
    this.appBarTitle,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.backgroundColor,
    this.contentPadding,
    this.sectionSpacing = 20,
    this.scrollBody = true,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.actionsAlignment = MainAxisAlignment.start,
    this.actionSpacing = 12,
    this.modalInspectorLabel = 'Open inspector',
    this.modalInspectorIcon = const Icon(Icons.tune_outlined),
    this.inspectorDockedAt = AdaptiveSize.medium,
    this.minimumInspectorDockedHeight = AdaptiveHeight.compact,
    this.minimumRailHeight = AdaptiveHeight.compact,
    this.minimumDrawerHeight = AdaptiveHeight.compact,
    this.animateScaffoldTransitions = true,
    this.scaffoldTransitionDuration = const Duration(milliseconds: 250),
    this.scaffoldTransitionCurve = Curves.easeInOutCubic,
    this.expandedNavigationWidth = 320,
    this.railMinWidth = 88,
    this.railLabelType = NavigationRailLabelType.all,
    this.useContainerConstraints = true,
    this.considerOrientation = false,
  }) : assert(
          inspector == null || inspectorTitle != null,
          'inspectorTitle must be provided when inspector is set.',
        );

  @override
  Widget build(BuildContext context) {
    final resolvedPadding = contentPadding ??
        context.responsive<EdgeInsets>(
          compact: const EdgeInsets.all(16),
          medium: const EdgeInsets.all(24),
          expanded: const EdgeInsets.all(32),
          heightCompact: const EdgeInsets.all(16),
          heightExpanded: const EdgeInsets.all(32),
        )!;

    final body = scrollBody
        ? SingleChildScrollView(
            child: Padding(
              padding: resolvedPadding,
              child: _bodyContent(context),
            ),
          )
        : Padding(
            padding: resolvedPadding,
            child: _bodyContent(context),
          );

    final resolvedAppBar = appBar ??
        ((appBarTitle != null || destinations.isNotEmpty)
            ? AppBar(
                title: Text(appBarTitle ?? title),
              )
            : null);

    return AdaptiveScaffold(
      appBar: resolvedAppBar,
      body: body,
      destinations: destinations,
      selectedIndex: selectedIndex,
      onSelectedIndexChanged: onSelectedIndexChanged,
      navigationHeader: navigationHeader,
      navigationFooter: navigationFooter,
      expandedNavigationWidth: expandedNavigationWidth,
      railMinWidth: railMinWidth,
      railLabelType: railLabelType,
      minimumRailHeight: minimumRailHeight,
      minimumDrawerHeight: minimumDrawerHeight,
      backgroundColor: backgroundColor,
      animateTransitions: animateScaffoldTransitions,
      transitionDuration: scaffoldTransitionDuration,
      transitionCurve: scaffoldTransitionCurve,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }

  Widget _bodyContent(BuildContext context) {
    final children = <Widget>[
      Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      if (description != null) ...[
        const SizedBox(height: 8),
        Text(
          description!,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
      if (actions.isNotEmpty) ...[
        SizedBox(height: sectionSpacing),
        AdaptiveActionBar(
          actions: actions,
          alignment: actionsAlignment,
          spacing: actionSpacing,
          useContainerConstraints: true,
        ),
      ],
      SizedBox(height: sectionSpacing),
      _workspaceSurface(),
    ];

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );
  }

  Widget _workspaceSurface() {
    if (inspector == null) {
      return content;
    }

    return AdaptiveInspectorLayout(
      primary: content,
      inspector: inspector!,
      inspectorTitle: inspectorTitle!,
      inspectorDescription: inspectorDescription,
      inspectorLeading: inspectorLeading,
      modalTriggerLabel: modalInspectorLabel,
      modalTriggerIcon: modalInspectorIcon,
      dockedAt: inspectorDockedAt,
      minimumDockedHeight: minimumInspectorDockedHeight,
      useContainerConstraints: useContainerConstraints,
      considerOrientation: considerOrientation,
    );
  }
}
