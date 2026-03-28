import 'package:flutter/material.dart';

import '../container_layout.dart';
import '../media_query.dart';

/// The active arrangement used by [AdaptiveConversationDesk].
enum AdaptiveConversationDeskMode {
  modalPanels,
  listDocked,
  fullyDocked,
}

/// A staged messaging workspace that coordinates a conversation list, a
/// central thread, and a supporting context panel from one adaptive model.
class AdaptiveConversationDesk<T> extends StatefulWidget {
  /// Conversations shown in the list.
  final List<T> conversations;

  /// Builds an individual conversation row.
  final Widget Function(
    BuildContext context,
    T conversation,
    bool selected,
    VoidCallback onTap,
  ) itemBuilder;

  /// Builds the active thread for the selected conversation.
  final Widget Function(BuildContext context, T conversation) threadBuilder;

  /// Builds the supporting context panel for the selected conversation.
  final Widget Function(BuildContext context, T conversation) contextBuilder;

  /// Optional header shown above the active thread.
  final Widget? header;

  /// Optional empty state shown when [conversations] is empty.
  final Widget? emptyState;

  /// Title shown above the conversation list.
  final String listTitle;

  /// Optional description shown below [listTitle].
  final String? listDescription;

  /// Optional leading widget shown beside [listTitle].
  final Widget? listLeading;

  /// Title shown above the context panel.
  final String contextTitle;

  /// Optional description shown below [contextTitle].
  final String? contextDescription;

  /// Optional leading widget shown beside [contextTitle].
  final Widget? contextLeading;

  /// Label used by the compact list trigger.
  final String modalListLabel;

  /// Icon used by the compact list trigger.
  final Widget modalListIcon;

  /// Label used by the compact context trigger.
  final String modalContextLabel;

  /// Icon used by the compact context trigger.
  final Widget modalContextIcon;

  /// Semantic size at which the conversation list should dock inline.
  final AdaptiveSize listDockedAt;

  /// Semantic size at which the context panel should dock inline.
  final AdaptiveSize contextDockedAt;

  /// Minimum height class required before the list can dock inline.
  final AdaptiveHeight minimumListDockedHeight;

  /// Minimum height class required before the context panel can dock inline.
  final AdaptiveHeight minimumContextDockedHeight;

  /// Whether to derive layout decisions from parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should influence container-based breakpoint selection.
  final bool considerOrientation;

  /// Optional controlled selected conversation index.
  final int? selectedIndex;

  /// Initial selected conversation index for uncontrolled usage.
  final int initialIndex;

  /// Called when the selected conversation changes.
  final ValueChanged<int>? onSelectedIndexChanged;

  /// Space between adjacent regions.
  final double spacing;

  /// Space between adjacent conversation rows.
  final double itemSpacing;

  /// Flex used by the docked list region.
  final int listFlex;

  /// Flex used by the thread region.
  final int threadFlex;

  /// Flex used by the docked context region.
  final int contextFlex;

  /// Padding applied inside the conversation list surface.
  final EdgeInsetsGeometry listPadding;

  /// Padding applied inside the thread surface.
  final EdgeInsetsGeometry threadPadding;

  /// Padding applied inside the context surface.
  final EdgeInsetsGeometry contextPadding;

  /// Height factor used by compact modal sheets.
  final double modalHeightFactor;

  /// Whether to show a drag handle in compact modal sheets.
  final bool showModalDragHandle;

  /// Whether to animate size changes when the mode changes.
  final bool animateSize;

  /// Duration used by [AnimatedSize] and [AnimatedSwitcher].
  final Duration animationDuration;

  /// Curve used by [AnimatedSize] and [AnimatedSwitcher].
  final Curve animationCurve;

  /// Creates an adaptive conversation desk.
  const AdaptiveConversationDesk({
    super.key,
    required this.conversations,
    required this.itemBuilder,
    required this.threadBuilder,
    required this.contextBuilder,
    required this.listTitle,
    required this.contextTitle,
    this.header,
    this.emptyState,
    this.listDescription,
    this.listLeading,
    this.contextDescription,
    this.contextLeading,
    this.modalListLabel = 'Open conversations',
    this.modalListIcon = const Icon(Icons.chat_bubble_outline),
    this.modalContextLabel = 'Open context',
    this.modalContextIcon = const Icon(Icons.info_outline),
    this.listDockedAt = AdaptiveSize.medium,
    this.contextDockedAt = AdaptiveSize.expanded,
    this.minimumListDockedHeight = AdaptiveHeight.compact,
    this.minimumContextDockedHeight = AdaptiveHeight.medium,
    this.useContainerConstraints = true,
    this.considerOrientation = false,
    this.selectedIndex,
    this.initialIndex = 0,
    this.onSelectedIndexChanged,
    this.spacing = 16,
    this.itemSpacing = 12,
    this.listFlex = 2,
    this.threadFlex = 4,
    this.contextFlex = 2,
    this.listPadding = const EdgeInsets.all(16),
    this.threadPadding = const EdgeInsets.all(16),
    this.contextPadding = const EdgeInsets.all(16),
    this.modalHeightFactor = 0.72,
    this.showModalDragHandle = true,
    this.animateSize = true,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeInOutCubic,
  })  : assert(spacing >= 0, 'spacing must be zero or greater.'),
        assert(itemSpacing >= 0, 'itemSpacing must be zero or greater.'),
        assert(listFlex > 0, 'listFlex must be greater than zero.'),
        assert(threadFlex > 0, 'threadFlex must be greater than zero.'),
        assert(contextFlex > 0, 'contextFlex must be greater than zero.'),
        assert(
          modalHeightFactor > 0 && modalHeightFactor <= 1,
          'modalHeightFactor must be between 0 and 1.',
        );

  @override
  State<AdaptiveConversationDesk<T>> createState() =>
      _AdaptiveConversationDeskState<T>();
}

class _AdaptiveConversationDeskState<T>
    extends State<AdaptiveConversationDesk<T>> {
  late int _internalIndex = widget.initialIndex;

  bool get _isControlled => widget.selectedIndex != null;

  int get _maxIndex {
    if (widget.conversations.isEmpty) {
      return 0;
    }
    return widget.conversations.length - 1;
  }

  int get _currentIndex {
    final rawIndex = widget.selectedIndex ?? _internalIndex;
    if (rawIndex < 0) {
      return 0;
    }
    if (rawIndex > _maxIndex) {
      return _maxIndex;
    }
    return rawIndex;
  }

  T get _currentConversation => widget.conversations[_currentIndex];

  @override
  void didUpdateWidget(covariant AdaptiveConversationDesk<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isControlled || widget.conversations.isEmpty) {
      return;
    }
    if (_internalIndex > _maxIndex) {
      _internalIndex = _maxIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.conversations.isEmpty) {
      return widget.emptyState ?? const SizedBox.shrink();
    }

    final child = widget.useContainerConstraints
        ? ResponsiveContainerBuilder(
            considerOrientation: widget.considerOrientation,
            builder: (context, data) => _buildForData(context, data),
          )
        : Builder(
            builder: (context) =>
                _buildForData(context, context.breakPointData),
          );

    if (!widget.animateSize) {
      return child;
    }

    return AnimatedSize(
      duration: widget.animationDuration,
      curve: widget.animationCurve,
      alignment: Alignment.topCenter,
      child: child,
    );
  }

  Widget _buildForData(BuildContext context, BreakPointData data) {
    final mode = _modeForData(data);

    return LayoutBuilder(
      builder: (context, constraints) {
        final hasBoundedHeight = constraints.maxHeight.isFinite;
        final threadSurface = _ConversationDeskThreadSurface(
          header: widget.header,
          boundedHeight: hasBoundedHeight,
          padding: widget.threadPadding,
          child: widget.threadBuilder(context, _currentConversation),
        );

        return AnimatedSwitcher(
          duration: widget.animationDuration,
          switchInCurve: widget.animationCurve,
          switchOutCurve: widget.animationCurve.flipped,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SizeTransition(
                sizeFactor: animation,
                axisAlignment: -1,
                child: child,
              ),
            );
          },
          child: KeyedSubtree(
            key: ValueKey(mode),
            child: switch (mode) {
              AdaptiveConversationDeskMode.modalPanels => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (hasBoundedHeight)
                      Expanded(child: threadSurface)
                    else
                      threadSurface,
                    SizedBox(height: widget.spacing),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.end,
                        children: [
                          FilledButton.tonalIcon(
                            onPressed: () => _showListSheet(context),
                            icon: widget.modalListIcon,
                            label: Text(widget.modalListLabel),
                          ),
                          FilledButton.tonalIcon(
                            onPressed: () => _showContextSheet(context),
                            icon: widget.modalContextIcon,
                            label: Text(widget.modalContextLabel),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              AdaptiveConversationDeskMode.listDocked => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: widget.listFlex,
                      child: _ConversationDeskPanelCard(
                        title: widget.listTitle,
                        description: widget.listDescription,
                        leading: widget.listLeading,
                        padding: widget.listPadding,
                        boundedHeight: hasBoundedHeight,
                        child: _ConversationDeskListSurface<T>(
                          conversations: widget.conversations,
                          currentIndex: _currentIndex,
                          itemSpacing: widget.itemSpacing,
                          boundedHeight: hasBoundedHeight,
                          itemBuilder: (context, conversation, selected) =>
                              widget.itemBuilder(
                            context,
                            conversation,
                            selected,
                            () => _selectConversation(
                              widget.conversations.indexOf(conversation),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: widget.spacing),
                    Expanded(
                      flex: widget.threadFlex,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (hasBoundedHeight)
                            Expanded(child: threadSurface)
                          else
                            threadSurface,
                          SizedBox(height: widget.spacing),
                          Align(
                            alignment: Alignment.centerRight,
                            child: FilledButton.tonalIcon(
                              onPressed: () => _showContextSheet(context),
                              icon: widget.modalContextIcon,
                              label: Text(widget.modalContextLabel),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              AdaptiveConversationDeskMode.fullyDocked => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: widget.listFlex,
                      child: _ConversationDeskPanelCard(
                        title: widget.listTitle,
                        description: widget.listDescription,
                        leading: widget.listLeading,
                        padding: widget.listPadding,
                        boundedHeight: hasBoundedHeight,
                        child: _ConversationDeskListSurface<T>(
                          conversations: widget.conversations,
                          currentIndex: _currentIndex,
                          itemSpacing: widget.itemSpacing,
                          boundedHeight: hasBoundedHeight,
                          itemBuilder: (context, conversation, selected) =>
                              widget.itemBuilder(
                            context,
                            conversation,
                            selected,
                            () => _selectConversation(
                              widget.conversations.indexOf(conversation),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: widget.spacing),
                    Expanded(
                      flex: widget.threadFlex,
                      child: threadSurface,
                    ),
                    SizedBox(width: widget.spacing),
                    Expanded(
                      flex: widget.contextFlex,
                      child: _ConversationDeskPanelCard(
                        title: widget.contextTitle,
                        description: widget.contextDescription,
                        leading: widget.contextLeading,
                        padding: widget.contextPadding,
                        boundedHeight: hasBoundedHeight,
                        child: widget.contextBuilder(
                          context,
                          _currentConversation,
                        ),
                      ),
                    ),
                  ],
                ),
            },
          ),
        );
      },
    );
  }

  AdaptiveConversationDeskMode _modeForData(BreakPointData data) {
    final canDockList = data.adaptiveSize.index >= widget.listDockedAt.index &&
        data.adaptiveHeight.index >= widget.minimumListDockedHeight.index;
    final canDockContext = data.adaptiveSize.index >=
            widget.contextDockedAt.index &&
        data.adaptiveHeight.index >= widget.minimumContextDockedHeight.index;

    if (canDockList && canDockContext) {
      return AdaptiveConversationDeskMode.fullyDocked;
    }
    if (canDockList) {
      return AdaptiveConversationDeskMode.listDocked;
    }
    return AdaptiveConversationDeskMode.modalPanels;
  }

  void _selectConversation(int index) {
    if (index < 0 || index > _maxIndex || index == _currentIndex) {
      return;
    }

    widget.onSelectedIndexChanged?.call(index);
    if (_isControlled) {
      return;
    }

    setState(() {
      _internalIndex = index;
    });
  }

  Future<void> _showListSheet(BuildContext context) {
    return _showPanelSheet(
      context: context,
      title: widget.listTitle,
      description: widget.listDescription,
      leading: widget.listLeading,
      child: _ConversationDeskListSurface<T>(
        conversations: widget.conversations,
        currentIndex: _currentIndex,
        itemSpacing: widget.itemSpacing,
        boundedHeight: true,
        itemBuilder: (context, conversation, selected) => widget.itemBuilder(
          context,
          conversation,
          selected,
          () {
            Navigator.of(context).pop();
            _selectConversation(widget.conversations.indexOf(conversation));
          },
        ),
      ),
    );
  }

  Future<void> _showContextSheet(BuildContext context) {
    return _showPanelSheet(
      context: context,
      title: widget.contextTitle,
      description: widget.contextDescription,
      leading: widget.contextLeading,
      child: widget.contextBuilder(context, _currentConversation),
    );
  }

  Future<void> _showPanelSheet({
    required BuildContext context,
    required String title,
    required Widget child,
    String? description,
    Widget? leading,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: widget.showModalDragHandle,
      builder: (sheetContext) {
        return FractionallySizedBox(
          heightFactor: widget.modalHeightFactor,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 8,
                bottom: 20 + MediaQuery.viewInsetsOf(sheetContext).bottom,
              ),
              child: _ConversationDeskPanelSurface(
                title: title,
                description: description,
                leading: leading,
                boundedHeight: true,
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ConversationDeskPanelCard extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? leading;
  final EdgeInsetsGeometry padding;
  final bool boundedHeight;
  final Widget child;

  const _ConversationDeskPanelCard({
    required this.title,
    required this.padding,
    required this.boundedHeight,
    required this.child,
    this.description,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding,
        child: _ConversationDeskPanelSurface(
          title: title,
          description: description,
          leading: leading,
          boundedHeight: boundedHeight,
          child: child,
        ),
      ),
    );
  }
}

class _ConversationDeskThreadSurface extends StatelessWidget {
  final Widget? header;
  final bool boundedHeight;
  final EdgeInsetsGeometry padding;
  final Widget child;

  const _ConversationDeskThreadSurface({
    required this.boundedHeight,
    required this.padding,
    required this.child,
    this.header,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: boundedHeight ? MainAxisSize.max : MainAxisSize.min,
          children: [
            if (header != null) ...[
              header!,
              const SizedBox(height: 16),
            ],
            if (boundedHeight) Expanded(child: child) else child,
          ],
        ),
      ),
    );
  }
}

class _ConversationDeskPanelSurface extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? leading;
  final bool boundedHeight;
  final Widget child;

  const _ConversationDeskPanelSurface({
    required this.title,
    required this.boundedHeight,
    required this.child,
    this.description,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: boundedHeight ? MainAxisSize.max : MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 4),
                    Text(description!),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (boundedHeight) Expanded(child: child) else child,
      ],
    );
  }
}

class _ConversationDeskListSurface<T> extends StatelessWidget {
  final List<T> conversations;
  final int currentIndex;
  final double itemSpacing;
  final bool boundedHeight;
  final Widget Function(
    BuildContext context,
    T conversation,
    bool selected,
  ) itemBuilder;

  const _ConversationDeskListSurface({
    required this.conversations,
    required this.currentIndex,
    required this.itemSpacing,
    required this.itemBuilder,
    this.boundedHeight = false,
  });

  @override
  Widget build(BuildContext context) {
    if (boundedHeight) {
      return ListView.separated(
        itemCount: conversations.length,
        itemBuilder: (context, index) => itemBuilder(
          context,
          conversations[index],
          index == currentIndex,
        ),
        separatorBuilder: (context, index) => SizedBox(height: itemSpacing),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < conversations.length; index++) ...[
          itemBuilder(context, conversations[index], index == currentIndex),
          if (index < conversations.length - 1) SizedBox(height: itemSpacing),
        ],
      ],
    );
  }
}
