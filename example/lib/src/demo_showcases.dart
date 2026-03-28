part of '../main.dart';

class _AdaptiveSectionsShowcase extends StatelessWidget {
  const _AdaptiveSectionsShowcase();

  @override
  Widget build(BuildContext context) {
    final sections = [
      AdaptiveSection(
        label: 'Profile',
        icon: const Icon(Icons.person_outline),
        description: 'Identity and ownership settings.',
        child: const _SectionSurface(
          title: 'Profile settings',
          body:
              'Keep primary identity fields together while adaptive chrome handles navigation around them.',
          accent: Color(0xFFD9F0E4),
        ),
      ),
      AdaptiveSection(
        label: 'Notifications',
        icon: const Icon(Icons.notifications_outlined),
        description: 'Delivery rules and digest cadence.',
        child: const _SectionSurface(
          title: 'Notification rules',
          body:
              'Compact layouts keep section switching close to the content. Larger layouts leave the section list visible.',
          accent: Color(0xFFFCE7C8),
        ),
      ),
      AdaptiveSection(
        label: 'Appearance',
        icon: const Icon(Icons.palette_outlined),
        description: 'Theme, density, and preview defaults.',
        child: const _SectionSurface(
          title: 'Appearance presets',
          body:
              'A docked section list works well for dense settings pages where users jump between related groups.',
          accent: Color(0xFFDCEBFF),
        ),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveDebugOverlay(
          label: 'sections',
          child: SizedBox(
            height: 360,
            child: AdaptiveSections(
              navigationHeader: const _SectionNavigationHeader(),
              navigationFooter: const _SectionNavigationFooter(),
              minimumSidebarHeight: AdaptiveHeight.medium,
              sections: sections,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 340,
            child: ResponsiveDebugOverlay(
              label: 'nested-sections',
              useContainerConstraints: true,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: 360,
                    child: AdaptiveSections(
                      useContainerConstraints: true,
                      sections: sections,
                      compactNavigationPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdaptiveDataViewShowcase extends StatelessWidget {
  const _AdaptiveDataViewShowcase();

  @override
  Widget build(BuildContext context) {
    final columns = _workspaceRecordColumns();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveDebugOverlay(
          label: 'data-view',
          child: AdaptiveDataView<_WorkspaceRecord>(
            records: _defaultWorkspaceRecords,
            columns: columns,
            minimumTableHeight: AdaptiveHeight.medium,
            compactLeadingBuilder: (context, record) =>
                CircleAvatar(child: Text(record.name.substring(0, 1))),
            compactTitleBuilder: (context, record) => Text(
              record.name,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            compactSubtitleBuilder: (context, record) => Text(record.role),
            compactTrailingBuilder: (context, record) =>
                _WorkspaceStatusBadge(status: record.status),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 340,
            child: ResponsiveDebugOverlay(
              label: 'nested-data-view',
              useContainerConstraints: true,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: AdaptiveDataView<_WorkspaceRecord>(
                    records: _defaultWorkspaceRecords,
                    columns: columns,
                    useContainerConstraints: true,
                    compactTitleBuilder: (context, record) => Text(
                      record.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    compactSubtitleBuilder: (context, record) =>
                        Text(record.role),
                    compactTrailingBuilder: (context, record) =>
                        _WorkspaceStatusBadge(status: record.status),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdaptiveBoardShowcase extends StatelessWidget {
  const _AdaptiveBoardShowcase();

  @override
  Widget build(BuildContext context) {
    final lanes = _demoBoardLanes();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveDebugOverlay(
          label: 'board',
          child: SizedBox(
            height: 380,
            child: AdaptiveBoard(
              lanes: lanes,
              minimumBoardHeight: AdaptiveHeight.medium,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 340,
            child: ResponsiveDebugOverlay(
              label: 'nested-board',
              useContainerConstraints: true,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: 300,
                    child: AdaptiveBoard(
                      lanes: lanes,
                      useContainerConstraints: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdaptiveTimelineShowcase extends StatelessWidget {
  const _AdaptiveTimelineShowcase();

  @override
  Widget build(BuildContext context) {
    final entries = _demoTimelineEntries();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveDebugOverlay(
          label: 'timeline',
          child: SizedBox(
            height: 360,
            child: AdaptiveTimeline(
              entries: entries,
              minimumHorizontalHeight: AdaptiveHeight.medium,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 340,
            child: ResponsiveDebugOverlay(
              label: 'nested-timeline',
              useContainerConstraints: true,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: 300,
                    child: AdaptiveTimeline(
                      entries: entries,
                      useContainerConstraints: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdaptiveComparisonShowcase extends StatelessWidget {
  const _AdaptiveComparisonShowcase();

  @override
  Widget build(BuildContext context) {
    final items = _demoComparisonItems();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveDebugOverlay(
          label: 'comparison',
          child: SizedBox(
            height: 360,
            child: AdaptiveComparison(
              items: items,
              minimumColumnsHeight: AdaptiveHeight.medium,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 340,
            child: ResponsiveDebugOverlay(
              label: 'nested-comparison',
              useContainerConstraints: true,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: 300,
                    child: AdaptiveComparison(
                      items: items,
                      useContainerConstraints: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdaptiveDiffViewShowcase extends StatelessWidget {
  const _AdaptiveDiffViewShowcase();

  @override
  Widget build(BuildContext context) {
    final panes = _demoDiffPanes();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveDebugOverlay(
          label: 'diff',
          child: SizedBox(
            height: 380,
            child: AdaptiveDiffView(
              header: const _ResultBrowserHeader(
                title: 'Workspace shell review',
                body:
                    'Compare the current shell against the proposed review '
                    'pass without maintaining separate mobile and desktop '
                    'review screens.',
              ),
              primary: panes.$1,
              secondary: panes.$2,
              minimumSplitHeight: AdaptiveHeight.medium,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 360,
            child: ResponsiveDebugOverlay(
              label: 'nested-diff',
              useContainerConstraints: true,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: 320,
                    child: AdaptiveDiffView(
                      primary: panes.$1,
                      secondary: panes.$2,
                      useContainerConstraints: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdaptiveScheduleShowcase extends StatelessWidget {
  const _AdaptiveScheduleShowcase();

  @override
  Widget build(BuildContext context) {
    final days = _demoScheduleDays();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveDebugOverlay(
          label: 'schedule',
          child: SizedBox(
            height: 380,
            child: AdaptiveSchedule(
              days: days,
              minimumColumnsHeight: AdaptiveHeight.medium,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 340,
            child: ResponsiveDebugOverlay(
              label: 'nested-schedule',
              useContainerConstraints: true,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: 300,
                    child: AdaptiveSchedule(
                      days: days,
                      useContainerConstraints: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdaptiveCalendarShowcase extends StatelessWidget {
  const _AdaptiveCalendarShowcase();

  @override
  Widget build(BuildContext context) {
    final days = _demoCalendarDays();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveDebugOverlay(
          label: 'calendar',
          child: SizedBox(
            height: 400,
            child: AdaptiveCalendar(
              days: days,
              minimumGridHeight: AdaptiveHeight.medium,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 340,
            child: ResponsiveDebugOverlay(
              label: 'nested-calendar',
              useContainerConstraints: true,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: 320,
                    child: AdaptiveCalendar(
                      days: days,
                      useContainerConstraints: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdaptiveDeckShowcase extends StatelessWidget {
  const _AdaptiveDeckShowcase();

  @override
  Widget build(BuildContext context) {
    final items = _demoDeckItems();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveDebugOverlay(
          label: 'deck',
          child: SizedBox(
            height: 420,
            child: AdaptiveDeck(
              items: items,
              minimumGridHeight: AdaptiveHeight.medium,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 360,
            child: ResponsiveDebugOverlay(
              label: 'nested-deck',
              useContainerConstraints: true,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: 340,
                    child: AdaptiveDeck(
                      items: items,
                      useContainerConstraints: true,
                      compactHeight: 280,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdaptiveGalleryShowcase extends StatelessWidget {
  const _AdaptiveGalleryShowcase();

  @override
  Widget build(BuildContext context) {
    final items = _demoGalleryItems();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveDebugOverlay(
          label: 'gallery',
          child: SizedBox(
            height: 440,
            child: AdaptiveGallery(
              items: items,
              minimumSpotlightHeight: AdaptiveHeight.medium,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 360,
            child: ResponsiveDebugOverlay(
              label: 'nested-gallery',
              useContainerConstraints: true,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: 340,
                    child: AdaptiveGallery(
                      items: items,
                      useContainerConstraints: true,
                      compactHeight: 280,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdaptiveFilterLayoutShowcase extends StatelessWidget {
  const _AdaptiveFilterLayoutShowcase();

  @override
  Widget build(BuildContext context) {
    final activeFilters = _demoActiveFilters();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveDebugOverlay(
          label: 'filters',
          child: SizedBox(
            height: 460,
            child: AdaptiveFilterLayout(
              filtersTitle: 'Filter library',
              filtersDescription:
                  'Tune component type, density, and release status.',
              filtersLeading: const Icon(Icons.tune_outlined),
              activeFilters: activeFilters,
              resultsHeader: const _FilterResultsHeader(),
              results: const _FilterResultsList(),
              filters: const _FilterControls(),
              minimumDockedHeight: AdaptiveHeight.medium,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 360,
            child: ResponsiveDebugOverlay(
              label: 'nested-filters',
              useContainerConstraints: true,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: 360,
                    child: AdaptiveFilterLayout(
                      filtersTitle: 'Nested filters',
                      filtersDescription:
                          'Local constraints still keep browsing readable.',
                      filtersLeading: const Icon(Icons.filter_list_outlined),
                      useContainerConstraints: true,
                      activeFilters: activeFilters,
                      resultsHeader: const _FilterResultsHeader(
                        title: '12 local results',
                        body:
                            'This nested surface resolves from its own width, '
                            'not the full window.',
                      ),
                      results: const _FilterResultsList(compact: true),
                      filters: const _FilterControls(compact: true),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdaptiveResultBrowserShowcase extends StatelessWidget {
  const _AdaptiveResultBrowserShowcase();

  @override
  Widget build(BuildContext context) {
    final entries = _demoResultBrowserEntries();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveDebugOverlay(
          label: 'result-browser',
          child: SizedBox(
            height: 460,
            child: AdaptiveResultBrowser<_ResultBrowserEntry>(
              results: entries,
              header: const _ResultBrowserHeader(),
              minimumSplitHeight: AdaptiveHeight.medium,
              itemBuilder: (context, result, selected, onTap) {
                return _ResultBrowserTile(
                  entry: result,
                  selected: selected,
                  onTap: onTap,
                );
              },
              detailBuilder: (context, result) {
                return _ResultBrowserDetail(entry: result);
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 360,
            child: ResponsiveDebugOverlay(
              label: 'nested-result-browser',
              useContainerConstraints: true,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: 360,
                    child: AdaptiveResultBrowser<_ResultBrowserEntry>(
                      results: entries,
                      useContainerConstraints: true,
                      header: const _ResultBrowserHeader(
                        title: 'Nested result set',
                        body:
                            'Local constraints still keep the list primary '
                            'before promoting detail inline.',
                      ),
                      itemBuilder: (context, result, selected, onTap) {
                        return _ResultBrowserTile(
                          entry: result,
                          selected: selected,
                          compact: true,
                          onTap: onTap,
                        );
                      },
                      detailBuilder: (context, result) {
                        return _ResultBrowserDetail(
                          entry: result,
                          compact: true,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdaptiveExplorerShowcase extends StatelessWidget {
  const _AdaptiveExplorerShowcase();

  @override
  Widget build(BuildContext context) {
    final entries = _demoResultBrowserEntries();
    final activeFilters = _demoActiveFilters();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveDebugOverlay(
          label: 'explorer',
          child: SizedBox(
            height: 500,
            child: AdaptiveExplorer<_ResultBrowserEntry>(
              results: entries,
              filtersTitle: 'Explorer filters',
              filtersDescription:
                  'Focus the component library by status, type, and release.',
              filtersLeading: const Icon(Icons.tune_outlined),
              activeFilters: activeFilters,
              header: const _ResultBrowserHeader(
                title: 'Component explorer',
                body:
                    'This surface combines filters, results, and detail into '
                    'one adaptive workspace.',
              ),
              filters: const _FilterControls(),
              itemBuilder: (context, result, selected, onTap) {
                return _ResultBrowserTile(
                  entry: result,
                  selected: selected,
                  onTap: onTap,
                );
              },
              detailBuilder: (context, result) {
                return _ResultBrowserDetail(entry: result);
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 420,
            child: ResponsiveDebugOverlay(
              label: 'nested-explorer',
              useContainerConstraints: true,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: 380,
                    child: AdaptiveExplorer<_ResultBrowserEntry>(
                      results: entries,
                      filtersTitle: 'Nested explorer filters',
                      filtersDescription:
                          'This local surface resolves from its own width '
                          'before promoting to the three-panel mode.',
                      filtersLeading: const Icon(Icons.explore_outlined),
                      useContainerConstraints: true,
                      activeFilters: activeFilters,
                      header: const _ResultBrowserHeader(
                        title: 'Nested explorer',
                        body:
                            'The same explorer stays modal-first inside a '
                            'narrow card.',
                      ),
                      filters: const _FilterControls(compact: true),
                      itemBuilder: (context, result, selected, onTap) {
                        return _ResultBrowserTile(
                          entry: result,
                          selected: selected,
                          compact: true,
                          onTap: onTap,
                        );
                      },
                      detailBuilder: (context, result) {
                        return _ResultBrowserDetail(
                          entry: result,
                          compact: true,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdaptiveDocumentViewShowcase extends StatelessWidget {
  const _AdaptiveDocumentViewShowcase();

  @override
  Widget build(BuildContext context) {
    final sections = _demoDocumentSections();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveDebugOverlay(
          label: 'document',
          child: SizedBox(
            height: 500,
            child: AdaptiveDocumentView(
              header: const _ResultBrowserHeader(
                title: 'Adaptive package release notes',
                body:
                    'One document surface keeps the narrative readable on '
                    'compact layouts and docks the outline only when the '
                    'current surface has room.',
              ),
              outlineTitle: 'Release outline',
              outlineDescription:
                  'Jump between the key changes in this release pass.',
              outlineLeading: const Icon(Icons.article_outlined),
              sections: sections,
              minimumDockedHeight: AdaptiveHeight.medium,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 360,
            child: ResponsiveDebugOverlay(
              label: 'nested-document',
              useContainerConstraints: true,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: 380,
                    child: AdaptiveDocumentView(
                      header: const _ResultBrowserHeader(
                        title: 'Nested release notes',
                        body:
                            'Local constraints keep the outline modal until '
                            'the card itself is wide enough.',
                      ),
                      outlineTitle: 'Nested outline',
                      outlineLeading: const Icon(Icons.menu_book_outlined),
                      sections: sections,
                      useContainerConstraints: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdaptiveWorkbenchShowcase extends StatelessWidget {
  const _AdaptiveWorkbenchShowcase();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveDebugOverlay(
          label: 'workbench',
          child: SizedBox(
            height: 620,
            child: AdaptiveWorkbench(
              header: const _ResultBrowserHeader(
                title: 'Adaptive studio workbench',
                body:
                    'Promote the asset library at medium widths and the '
                    'inspector at expanded widths without replacing the '
                    'central canvas.',
              ),
              libraryTitle: 'Asset library',
              libraryDescription:
                  'Choose sections, cards, and workflow surfaces for the '
                  'current canvas.',
              libraryLeading: const Icon(Icons.inventory_2_outlined),
              library: const _WorkbenchLibraryPanel(),
              inspectorTitle: 'Selection inspector',
              inspectorDescription:
                  'Tune spacing, emphasis, and release state for the active '
                  'canvas block.',
              inspectorLeading: const Icon(Icons.tune_outlined),
              inspector: const _WorkbenchInspectorPanel(),
              canvas: const _WorkbenchCanvasPanel(),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 880),
            child: ResponsiveDebugOverlay(
              label: 'nested-workbench',
              useContainerConstraints: true,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: 500,
                    child: AdaptiveWorkbench(
                      header: const _ResultBrowserHeader(
                        title: 'Nested studio surface',
                        body:
                            'Local width promotes only the library here, so '
                            'the inspector stays modal until the card itself '
                            'has room.',
                      ),
                      libraryTitle: 'Nested library',
                      libraryLeading: const Icon(Icons.widgets_outlined),
                      library: const _WorkbenchLibraryPanel(compact: true),
                      inspectorTitle: 'Nested inspector',
                      inspectorLeading: const Icon(
                        Icons.settings_suggest_outlined,
                      ),
                      inspector: const _WorkbenchInspectorPanel(compact: true),
                      canvas: const _WorkbenchCanvasPanel(compact: true),
                      useContainerConstraints: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdaptiveReviewDeskShowcase extends StatelessWidget {
  const _AdaptiveReviewDeskShowcase();

  @override
  Widget build(BuildContext context) {
    final entries = _demoResultBrowserEntries();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveDebugOverlay(
          label: 'review-desk',
          child: SizedBox(
            height: 560,
            child: AdaptiveReviewDesk<_ResultBrowserEntry>(
              items: entries,
              queueTitle: 'Review queue',
              queueDescription:
                  'Pick the next adaptive surface waiting on approval.',
              queueLeading: const Icon(Icons.playlist_play_outlined),
              decisionTitle: 'Decision panel',
              decisionDescription:
                  'Capture review status, owner notes, and follow-up actions.',
              decisionLeading: const Icon(Icons.rule_outlined),
              header: const _ResultBrowserHeader(
                title: 'Release review desk',
                body:
                    'This workspace keeps the active review surface primary '
                    'while queue and decision controls dock progressively.',
              ),
              itemBuilder: (context, item, selected, onTap) {
                return _ResultBrowserTile(
                  entry: item,
                  selected: selected,
                  onTap: onTap,
                );
              },
              reviewBuilder: (context, item) {
                return _ReviewDeskReviewBody(entry: item);
              },
              decisionBuilder: (context, item) {
                return _ReviewDeskDecisionPanel(entry: item);
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 420,
            child: ResponsiveDebugOverlay(
              label: 'nested-review-desk',
              useContainerConstraints: true,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: 420,
                    child: AdaptiveReviewDesk<_ResultBrowserEntry>(
                      items: entries,
                      queueTitle: 'Nested queue',
                      queueLeading: const Icon(Icons.fact_check_outlined),
                      decisionTitle: 'Nested decision',
                      decisionLeading: const Icon(
                        Icons.settings_suggest_outlined,
                      ),
                      useContainerConstraints: true,
                      header: const _ResultBrowserHeader(
                        title: 'Nested review workspace',
                        body:
                            'Local constraints keep the decision panel modal '
                            'until the card itself can support three regions.',
                      ),
                      itemBuilder: (context, item, selected, onTap) {
                        return _ResultBrowserTile(
                          entry: item,
                          selected: selected,
                          compact: true,
                          onTap: onTap,
                        );
                      },
                      reviewBuilder: (context, item) {
                        return _ReviewDeskReviewBody(
                          entry: item,
                          compact: true,
                        );
                      },
                      decisionBuilder: (context, item) {
                        return _ReviewDeskDecisionPanel(
                          entry: item,
                          compact: true,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdaptiveConversationDeskShowcase extends StatelessWidget {
  const _AdaptiveConversationDeskShowcase();

  @override
  Widget build(BuildContext context) {
    final entries = _demoResultBrowserEntries();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveDebugOverlay(
          label: 'conversation-desk',
          child: SizedBox(
            height: 560,
            child: AdaptiveConversationDesk<_ResultBrowserEntry>(
              conversations: entries,
              listTitle: 'Conversations',
              listDescription:
                  'Recent support and collaboration threads waiting for a reply.',
              listLeading: const Icon(Icons.chat_bubble_outline),
              contextTitle: 'Participant context',
              contextDescription:
                  'Keep status, ownership, and follow-up context visible '
                  'without crowding the thread.',
              contextLeading: const Icon(Icons.info_outline),
              header: const _ResultBrowserHeader(
                title: 'Adaptive support inbox',
                body:
                    'This workspace keeps the active thread readable while '
                    'conversation list and context dock progressively.',
              ),
              itemBuilder: (context, entry, selected, onTap) {
                return _ResultBrowserTile(
                  entry: entry,
                  selected: selected,
                  onTap: onTap,
                );
              },
              threadBuilder: (context, entry) {
                return _ConversationDeskThread(entry: entry);
              },
              contextBuilder: (context, entry) {
                return _ConversationDeskContext(entry: entry);
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 420,
            child: ResponsiveDebugOverlay(
              label: 'nested-conversation-desk',
              useContainerConstraints: true,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: 420,
                    child: AdaptiveConversationDesk<_ResultBrowserEntry>(
                      conversations: entries,
                      listTitle: 'Nested conversations',
                      listLeading: const Icon(Icons.forum_outlined),
                      contextTitle: 'Nested context',
                      contextLeading: const Icon(
                        Icons.manage_accounts_outlined,
                      ),
                      useContainerConstraints: true,
                      header: const _ResultBrowserHeader(
                        title: 'Nested support inbox',
                        body:
                            'Local constraints keep the context panel modal '
                            'until the card itself is wide enough.',
                      ),
                      itemBuilder: (context, entry, selected, onTap) {
                        return _ResultBrowserTile(
                          entry: entry,
                          selected: selected,
                          compact: true,
                          onTap: onTap,
                        );
                      },
                      threadBuilder: (context, entry) {
                        return _ConversationDeskThread(
                          entry: entry,
                          compact: true,
                        );
                      },
                      contextBuilder: (context, entry) {
                        return _ConversationDeskContext(
                          entry: entry,
                          compact: true,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdaptiveComposerShowcase extends StatelessWidget {
  const _AdaptiveComposerShowcase();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveDebugOverlay(
          label: 'composer',
          child: SizedBox(
            height: 560,
            child: AdaptiveComposer(
              header: const _ResultBrowserHeader(
                title: 'Adaptive release note composer',
                body:
                    'This workspace keeps editing primary on compact layouts, '
                    'splits editor and preview at medium widths, and docks '
                    'settings only when the surface can support them.',
              ),
              editorTitle: 'Editor',
              editorDescription:
                  'Draft the release note copy and restructure sections.',
              editorLeading: const Icon(Icons.edit_note_outlined),
              previewTitle: 'Preview',
              previewDescription:
                  'See the formatted release note before it ships.',
              previewLeading: const Icon(Icons.visibility_outlined),
              settingsTitle: 'Settings',
              settingsDescription:
                  'Tune spacing, metadata, and publishing options.',
              settingsLeading: const Icon(Icons.tune_outlined),
              editor: const _ComposerEditorSurface(),
              preview: const _ComposerPreviewSurface(),
              settings: const _ComposerSettingsSurface(),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 420,
            child: ResponsiveDebugOverlay(
              label: 'nested-composer',
              useContainerConstraints: true,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: 420,
                    child: AdaptiveComposer(
                      useContainerConstraints: true,
                      header: const _ResultBrowserHeader(
                        title: 'Nested composer',
                        body:
                            'Local constraints keep this surface in compact '
                            'toggle mode until the card itself is wide enough '
                            'to support a split editor and preview.',
                      ),
                      editorLeading: const Icon(Icons.article_outlined),
                      previewLeading: const Icon(Icons.auto_awesome_outlined),
                      settingsLeading: const Icon(
                        Icons.settings_suggest_outlined,
                      ),
                      editor: const _ComposerEditorSurface(compact: true),
                      preview: const _ComposerPreviewSurface(compact: true),
                      settings: const _ComposerSettingsSurface(compact: true),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdaptivePresentationDeskShowcase extends StatelessWidget {
  const _AdaptivePresentationDeskShowcase();

  @override
  Widget build(BuildContext context) {
    final entries = _demoResultBrowserEntries();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveDebugOverlay(
          label: 'presentation-desk',
          child: SizedBox(
            height: 560,
            child: AdaptivePresentationDesk<_ResultBrowserEntry>(
              slides: entries,
              listTitle: 'Slides',
              listDescription:
                  'Jump between launch deck sections without losing the stage.',
              listLeading: const Icon(Icons.view_carousel_outlined),
              notesTitle: 'Speaker notes',
              notesDescription:
                  'Keep presenter context visible without crowding the stage.',
              notesLeading: const Icon(Icons.sticky_note_2_outlined),
              header: const _ResultBrowserHeader(
                title: 'Adaptive launch deck',
                body:
                    'This workspace keeps the active stage primary while '
                    'slide list and speaker notes dock progressively.',
              ),
              itemBuilder: (context, entry, selected, onTap) {
                return _ResultBrowserTile(
                  entry: entry,
                  selected: selected,
                  onTap: onTap,
                );
              },
              stageBuilder: (context, entry) {
                return _PresentationDeskStage(entry: entry);
              },
              notesBuilder: (context, entry) {
                return _PresentationDeskNotes(entry: entry);
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 420,
            child: ResponsiveDebugOverlay(
              label: 'nested-presentation-desk',
              useContainerConstraints: true,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: 420,
                    child: AdaptivePresentationDesk<_ResultBrowserEntry>(
                      slides: entries,
                      listTitle: 'Nested slides',
                      listLeading: const Icon(Icons.slideshow_outlined),
                      notesTitle: 'Nested notes',
                      notesLeading: const Icon(Icons.speaker_notes_outlined),
                      useContainerConstraints: true,
                      header: const _ResultBrowserHeader(
                        title: 'Nested presentation stage',
                        body:
                            'Local constraints keep speaker notes modal until '
                            'the card itself has room to dock them inline.',
                      ),
                      itemBuilder: (context, entry, selected, onTap) {
                        return _ResultBrowserTile(
                          entry: entry,
                          selected: selected,
                          compact: true,
                          onTap: onTap,
                        );
                      },
                      stageBuilder: (context, entry) {
                        return _PresentationDeskStage(
                          entry: entry,
                          compact: true,
                        );
                      },
                      notesBuilder: (context, entry) {
                        return _PresentationDeskNotes(
                          entry: entry,
                          compact: true,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdaptiveControlCenterShowcase extends StatelessWidget {
  const _AdaptiveControlCenterShowcase();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveDebugOverlay(
          label: 'control-center',
          child: SizedBox(
            height: 620,
            child: AdaptiveControlCenter(
              header: const _ResultBrowserHeader(
                title: 'Adaptive operations center',
                body:
                    'This workspace keeps the monitoring dashboard primary '
                    'on compact layouts, docks the service sidebar at medium '
                    'widths, adds insights at expanded widths, and only docks '
                    'the activity stream when there is enough height too.',
              ),
              sidebarTitle: 'Service lanes',
              sidebarDescription:
                  'Keep live ownership and rollout pressure visible.',
              sidebarLeading: const Icon(Icons.view_sidebar_outlined),
              sidebar: const _ControlCenterSidebarPanel(),
              insightsTitle: 'Incident insights',
              insightsDescription:
                  'Highlight what needs intervention before the stream gets noisy.',
              insightsLeading: const Icon(Icons.insights_outlined),
              insights: const _ControlCenterInsightsPanel(),
              activityTitle: 'Activity stream',
              activityDescription:
                  'Dock the live event feed only when the local surface can support it.',
              activityLeading: const Icon(Icons.history_outlined),
              activity: const _ControlCenterActivityPanel(),
              main: const _ControlCenterMainPanel(),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 560,
            child: ResponsiveDebugOverlay(
              label: 'nested-control-center',
              useContainerConstraints: true,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: 460,
                    child: AdaptiveControlCenter(
                      useContainerConstraints: true,
                      header: const _ResultBrowserHeader(
                        title: 'Nested command surface',
                        body:
                            'Local constraints keep insights and activity '
                            'modal until the card itself can support them.',
                      ),
                      sidebarTitle: 'Nested lanes',
                      sidebarLeading: const Icon(Icons.monitor_outlined),
                      sidebar: const _ControlCenterSidebarPanel(compact: true),
                      insightsTitle: 'Nested insights',
                      insightsLeading: const Icon(Icons.warning_amber_outlined),
                      insights: const _ControlCenterInsightsPanel(
                        compact: true,
                      ),
                      activityTitle: 'Nested activity',
                      activityLeading: const Icon(Icons.schedule_outlined),
                      activity: const _ControlCenterActivityPanel(
                        compact: true,
                      ),
                      main: const _ControlCenterMainPanel(compact: true),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdaptiveIncidentDeskShowcase extends StatelessWidget {
  const _AdaptiveIncidentDeskShowcase();

  @override
  Widget build(BuildContext context) {
    final entries = _demoResultBrowserEntries();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveDebugOverlay(
          label: 'incident-desk',
          child: SizedBox(
            height: 620,
            child: AdaptiveIncidentDesk<_ResultBrowserEntry>(
              incidents: entries,
              listTitle: 'Active incidents',
              listDescription:
                  'Keep live issues selectable without replacing the main surface.',
              listLeading: const Icon(Icons.warning_amber_outlined),
              contextTitle: 'Responder context',
              contextDescription:
                  'Show ownership, impact, and recovery posture for the selected incident.',
              contextLeading: const Icon(Icons.people_outline),
              timelineTitle: 'Incident timeline',
              timelineDescription:
                  'Dock the timeline only when the current surface has enough height.',
              timelineLeading: const Icon(Icons.timeline_outlined),
              header: const _ResultBrowserHeader(
                title: 'Adaptive incident response desk',
                body:
                    'This workspace keeps the active incident detail '
                    'primary while the list, responder context, and timeline '
                    'dock progressively from local width and height.',
              ),
              itemBuilder: (context, entry, selected, onTap) {
                return _ResultBrowserTile(
                  entry: entry,
                  selected: selected,
                  onTap: onTap,
                );
              },
              detailBuilder: (context, entry) {
                return _IncidentDeskDetailPanel(entry: entry);
              },
              contextBuilder: (context, entry) {
                return _IncidentDeskContextPanel(entry: entry);
              },
              timelineBuilder: (context, entry) {
                return _IncidentDeskTimelinePanel(entry: entry);
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 460,
            child: ResponsiveDebugOverlay(
              label: 'nested-incident-desk',
              useContainerConstraints: true,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: 460,
                    child: AdaptiveIncidentDesk<_ResultBrowserEntry>(
                      incidents: entries,
                      listTitle: 'Nested incidents',
                      listLeading: const Icon(Icons.report_problem_outlined),
                      contextTitle: 'Nested context',
                      contextLeading: const Icon(
                        Icons.manage_accounts_outlined,
                      ),
                      timelineTitle: 'Nested timeline',
                      timelineLeading: const Icon(Icons.history_toggle_off),
                      useContainerConstraints: true,
                      header: const _ResultBrowserHeader(
                        title: 'Nested incident review surface',
                        body:
                            'Local constraints keep the responder context '
                            'and timeline modal until the card itself can '
                            'support them.',
                      ),
                      itemBuilder: (context, entry, selected, onTap) {
                        return _ResultBrowserTile(
                          entry: entry,
                          selected: selected,
                          compact: true,
                          onTap: onTap,
                        );
                      },
                      detailBuilder: (context, entry) {
                        return _IncidentDeskDetailPanel(
                          entry: entry,
                          compact: true,
                        );
                      },
                      contextBuilder: (context, entry) {
                        return _IncidentDeskContextPanel(
                          entry: entry,
                          compact: true,
                        );
                      },
                      timelineBuilder: (context, entry) {
                        return _IncidentDeskTimelinePanel(
                          entry: entry,
                          compact: true,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdaptiveMetricsLabShowcase extends StatelessWidget {
  const _AdaptiveMetricsLabShowcase();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveDebugOverlay(
          label: 'metrics-lab',
          child: SizedBox(
            height: 620,
            child: AdaptiveMetricsLab<_MetricLabQuery>(
              queries: _metricLabQueries,
              queryTitle: 'Saved queries',
              queryDescription:
                  'Switch between active analytics questions without replacing the chart surface.',
              queryLeading: const Icon(Icons.query_stats_outlined),
              annotationsTitle: 'Annotations',
              annotationsDescription:
                  'Keep analyst notes and release markers visible beside the active chart.',
              annotationsLeading: const Icon(Icons.draw_outlined),
              historyTitle: 'Query history',
              historyDescription:
                  'Dock execution history only when the local surface has enough height.',
              historyLeading: const Icon(Icons.history_outlined),
              header: const _ResultBrowserHeader(
                title: 'Adaptive metrics lab',
                body:
                    'This workspace keeps the active metric focus primary '
                    'while queries, annotations, and history dock '
                    'progressively from local width and height.',
              ),
              itemBuilder: (context, query, selected, onTap) {
                return _MetricLabQueryTile(
                  query: query,
                  selected: selected,
                  onTap: onTap,
                );
              },
              focusBuilder: (context, query) {
                return _MetricLabFocusPanel(query: query);
              },
              annotationsBuilder: (context, query) {
                return _MetricLabAnnotationsPanel(query: query);
              },
              historyBuilder: (context, query) {
                return _MetricLabHistoryPanel(query: query);
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 460,
            child: ResponsiveDebugOverlay(
              label: 'nested-metrics-lab',
              useContainerConstraints: true,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: 460,
                    child: AdaptiveMetricsLab<_MetricLabQuery>(
                      queries: _metricLabQueries,
                      queryTitle: 'Nested queries',
                      queryLeading: const Icon(Icons.insights_outlined),
                      annotationsTitle: 'Nested notes',
                      annotationsLeading: const Icon(
                        Icons.mode_comment_outlined,
                      ),
                      historyTitle: 'Nested history',
                      historyLeading: const Icon(Icons.manage_history_outlined),
                      useContainerConstraints: true,
                      header: const _ResultBrowserHeader(
                        title: 'Nested analytics surface',
                        body:
                            'Local constraints keep annotations and history '
                            'modal until the card itself can support them.',
                      ),
                      itemBuilder: (context, query, selected, onTap) {
                        return _MetricLabQueryTile(
                          query: query,
                          selected: selected,
                          compact: true,
                          onTap: onTap,
                        );
                      },
                      focusBuilder: (context, query) {
                        return _MetricLabFocusPanel(
                          query: query,
                          compact: true,
                        );
                      },
                      annotationsBuilder: (context, query) {
                        return _MetricLabAnnotationsPanel(
                          query: query,
                          compact: true,
                        );
                      },
                      historyBuilder: (context, query) {
                        return _MetricLabHistoryPanel(
                          query: query,
                          compact: true,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdaptiveExperimentLabShowcase extends StatelessWidget {
  const _AdaptiveExperimentLabShowcase();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveDebugOverlay(
          label: 'experiment-lab',
          child: SizedBox(
            height: 620,
            child: AdaptiveExperimentLab<_ExperimentLabItem>(
              experiments: _experimentLabItems,
              experimentTitle: 'Active experiments',
              experimentDescription:
                  'Switch between rollout questions without replacing the main comparison surface.',
              experimentLeading: const Icon(Icons.science_outlined),
              evidenceTitle: 'Evidence',
              evidenceDescription:
                  'Keep supporting data and notes visible beside the active experiment.',
              evidenceLeading: const Icon(Icons.fact_check_outlined),
              decisionTitle: 'Decision log',
              decisionDescription:
                  'Dock decisions only when the local surface has enough height.',
              decisionLeading: const Icon(Icons.rule_outlined),
              header: const _ResultBrowserHeader(
                title: 'Adaptive experiment lab',
                body:
                    'This workspace keeps the active experiment focus '
                    'primary while experiment selection, evidence, and '
                    'decisions dock progressively from local width and height.',
              ),
              itemBuilder: (context, experiment, selected, onTap) {
                return _ExperimentLabItemTile(
                  item: experiment,
                  selected: selected,
                  onTap: onTap,
                );
              },
              focusBuilder: (context, experiment) {
                return _ExperimentLabFocusPanel(item: experiment);
              },
              evidenceBuilder: (context, experiment) {
                return _ExperimentLabEvidencePanel(item: experiment);
              },
              decisionBuilder: (context, experiment) {
                return _ExperimentLabDecisionPanel(item: experiment);
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 460,
            child: ResponsiveDebugOverlay(
              label: 'nested-experiment-lab',
              useContainerConstraints: true,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: 460,
                    child: AdaptiveExperimentLab<_ExperimentLabItem>(
                      experiments: _experimentLabItems,
                      experimentTitle: 'Nested experiments',
                      experimentLeading: const Icon(
                        Icons.auto_awesome_motion_outlined,
                      ),
                      evidenceTitle: 'Nested evidence',
                      evidenceLeading: const Icon(Icons.analytics_outlined),
                      decisionTitle: 'Nested decisions',
                      decisionLeading: const Icon(Icons.playlist_add_check),
                      useContainerConstraints: true,
                      header: const _ResultBrowserHeader(
                        title: 'Nested experiment surface',
                        body:
                            'Local constraints keep evidence and decisions '
                            'modal until the card itself can support them.',
                      ),
                      itemBuilder: (context, experiment, selected, onTap) {
                        return _ExperimentLabItemTile(
                          item: experiment,
                          selected: selected,
                          compact: true,
                          onTap: onTap,
                        );
                      },
                      focusBuilder: (context, experiment) {
                        return _ExperimentLabFocusPanel(
                          item: experiment,
                          compact: true,
                        );
                      },
                      evidenceBuilder: (context, experiment) {
                        return _ExperimentLabEvidencePanel(
                          item: experiment,
                          compact: true,
                        );
                      },
                      decisionBuilder: (context, experiment) {
                        return _ExperimentLabDecisionPanel(
                          item: experiment,
                          compact: true,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdaptivePlanningDeskShowcase extends StatelessWidget {
  const _AdaptivePlanningDeskShowcase();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveDebugOverlay(
          label: 'planning-desk',
          child: SizedBox(
            height: 620,
            child: AdaptivePlanningDesk<_PlanningDeskItem>(
              plans: _planningDeskItems,
              planTitle: 'Launch plans',
              planDescription:
                  'Switch between active planning tracks without leaving the main surface.',
              planLeading: const Icon(Icons.event_note_outlined),
              risksTitle: 'Key risks',
              risksDescription:
                  'Keep risk pressure visible beside the selected plan.',
              risksLeading: const Icon(Icons.warning_amber_outlined),
              milestonesTitle: 'Milestones',
              milestonesDescription:
                  'Dock milestones only when the local surface has enough height.',
              milestonesLeading: const Icon(Icons.flag_outlined),
              header: const _ResultBrowserHeader(
                title: 'Adaptive planning desk',
                body:
                    'This workspace keeps the active plan focus primary '
                    'while plan selection, risks, and milestones dock '
                    'progressively from local width and height.',
              ),
              itemBuilder: (context, plan, selected, onTap) {
                return _PlanningDeskItemTile(
                  item: plan,
                  selected: selected,
                  onTap: onTap,
                );
              },
              focusBuilder: (context, plan) {
                return _PlanningDeskFocusPanel(item: plan);
              },
              risksBuilder: (context, plan) {
                return _PlanningDeskRisksPanel(item: plan);
              },
              milestonesBuilder: (context, plan) {
                return _PlanningDeskMilestonesPanel(item: plan);
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 460,
            child: ResponsiveDebugOverlay(
              label: 'nested-planning-desk',
              useContainerConstraints: true,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: 460,
                    child: AdaptivePlanningDesk<_PlanningDeskItem>(
                      plans: _planningDeskItems,
                      planTitle: 'Nested plans',
                      planLeading: const Icon(Icons.route_outlined),
                      risksTitle: 'Nested risks',
                      risksLeading: const Icon(Icons.report_problem_outlined),
                      milestonesTitle: 'Nested milestones',
                      milestonesLeading: const Icon(Icons.checklist_outlined),
                      useContainerConstraints: true,
                      header: const _ResultBrowserHeader(
                        title: 'Nested planning surface',
                        body:
                            'Local constraints keep risks and milestones '
                            'modal until the card itself can support them.',
                      ),
                      itemBuilder: (context, plan, selected, onTap) {
                        return _PlanningDeskItemTile(
                          item: plan,
                          selected: selected,
                          compact: true,
                          onTap: onTap,
                        );
                      },
                      focusBuilder: (context, plan) {
                        return _PlanningDeskFocusPanel(
                          item: plan,
                          compact: true,
                        );
                      },
                      risksBuilder: (context, plan) {
                        return _PlanningDeskRisksPanel(
                          item: plan,
                          compact: true,
                        );
                      },
                      milestonesBuilder: (context, plan) {
                        return _PlanningDeskMilestonesPanel(
                          item: plan,
                          compact: true,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdaptiveReleaseLabShowcase extends StatelessWidget {
  const _AdaptiveReleaseLabShowcase();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveDebugOverlay(
          label: 'release-lab',
          child: SizedBox(
            height: 620,
            child: AdaptiveReleaseLab<_ReleaseLabItem>(
              releases: _releaseLabItems,
              releaseTitle: 'Active releases',
              releaseDescription:
                  'Switch between release tracks without leaving the readiness surface.',
              releaseLeading: const Icon(Icons.rocket_launch_outlined),
              blockersTitle: 'Launch blockers',
              blockersDescription:
                  'Keep blockers visible beside the selected release.',
              blockersLeading: const Icon(Icons.warning_amber_outlined),
              rolloutTitle: 'Rollout log',
              rolloutDescription:
                  'Dock rollout activity only when the local surface has enough height.',
              rolloutLeading: const Icon(Icons.history_outlined),
              header: const _ResultBrowserHeader(
                title: 'Adaptive release lab',
                body:
                    'This workspace keeps the active release readiness '
                    'surface primary while release selection, blockers, and '
                    'rollout activity dock progressively from local width and height.',
              ),
              itemBuilder: (context, release, selected, onTap) {
                return _ReleaseLabItemTile(
                  item: release,
                  selected: selected,
                  onTap: onTap,
                );
              },
              readinessBuilder: (context, release) {
                return _ReleaseLabReadinessPanel(item: release);
              },
              blockersBuilder: (context, release) {
                return _ReleaseLabBlockersPanel(item: release);
              },
              rolloutBuilder: (context, release) {
                return _ReleaseLabRolloutPanel(item: release);
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 460,
            child: ResponsiveDebugOverlay(
              label: 'nested-release-lab',
              useContainerConstraints: true,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: 460,
                    child: AdaptiveReleaseLab<_ReleaseLabItem>(
                      releases: _releaseLabItems,
                      releaseTitle: 'Nested releases',
                      releaseLeading: const Icon(Icons.local_shipping_outlined),
                      blockersTitle: 'Nested blockers',
                      blockersLeading: const Icon(Icons.error_outline),
                      rolloutTitle: 'Nested rollout',
                      rolloutLeading: const Icon(Icons.schedule_outlined),
                      useContainerConstraints: true,
                      header: const _ResultBrowserHeader(
                        title: 'Nested release surface',
                        body:
                            'Local constraints keep blockers and rollout '
                            'modal until the card itself can support them.',
                      ),
                      itemBuilder: (context, release, selected, onTap) {
                        return _ReleaseLabItemTile(
                          item: release,
                          selected: selected,
                          compact: true,
                          onTap: onTap,
                        );
                      },
                      readinessBuilder: (context, release) {
                        return _ReleaseLabReadinessPanel(
                          item: release,
                          compact: true,
                        );
                      },
                      blockersBuilder: (context, release) {
                        return _ReleaseLabBlockersPanel(
                          item: release,
                          compact: true,
                        );
                      },
                      rolloutBuilder: (context, release) {
                        return _ReleaseLabRolloutPanel(
                          item: release,
                          compact: true,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdaptiveApprovalDeskShowcase extends StatelessWidget {
  const _AdaptiveApprovalDeskShowcase();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveDebugOverlay(
          label: 'approval-desk',
          child: SizedBox(
            height: 620,
            child: AdaptiveApprovalDesk<_ApprovalDeskItem>(
              approvals: _approvalDeskItems,
              approvalTitle: 'Pending approvals',
              approvalDescription:
                  'Switch between signoff requests without leaving the active proposal surface.',
              approvalLeading: const Icon(Icons.approval_outlined),
              criteriaTitle: 'Approval criteria',
              criteriaDescription:
                  'Keep signoff criteria visible beside the selected request.',
              criteriaLeading: const Icon(Icons.fact_check_outlined),
              historyTitle: 'Decision history',
              historyDescription:
                  'Dock approval history only when the local surface has enough height.',
              historyLeading: const Icon(Icons.history_outlined),
              header: const _ResultBrowserHeader(
                title: 'Adaptive approval desk',
                body:
                    'This workspace keeps the active proposal primary '
                    'while approval selection, criteria, and decision '
                    'history dock progressively from local width and height.',
              ),
              itemBuilder: (context, approval, selected, onTap) {
                return _ApprovalDeskItemTile(
                  item: approval,
                  selected: selected,
                  onTap: onTap,
                );
              },
              proposalBuilder: (context, approval) {
                return _ApprovalDeskProposalPanel(item: approval);
              },
              criteriaBuilder: (context, approval) {
                return _ApprovalDeskCriteriaPanel(item: approval);
              },
              historyBuilder: (context, approval) {
                return _ApprovalDeskHistoryPanel(item: approval);
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 460,
            child: ResponsiveDebugOverlay(
              label: 'nested-approval-desk',
              useContainerConstraints: true,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: 460,
                    child: AdaptiveApprovalDesk<_ApprovalDeskItem>(
                      approvals: _approvalDeskItems,
                      approvalTitle: 'Nested approvals',
                      approvalLeading: const Icon(Icons.inventory_2_outlined),
                      criteriaTitle: 'Nested criteria',
                      criteriaLeading: const Icon(Icons.rule_outlined),
                      historyTitle: 'Nested history',
                      historyLeading: const Icon(Icons.history_outlined),
                      useContainerConstraints: true,
                      header: const _ResultBrowserHeader(
                        title: 'Nested approval surface',
                        body:
                            'Local constraints keep criteria and history '
                            'modal until the card itself can support them.',
                      ),
                      itemBuilder: (context, approval, selected, onTap) {
                        return _ApprovalDeskItemTile(
                          item: approval,
                          selected: selected,
                          compact: true,
                          onTap: onTap,
                        );
                      },
                      proposalBuilder: (context, approval) {
                        return _ApprovalDeskProposalPanel(
                          item: approval,
                          compact: true,
                        );
                      },
                      criteriaBuilder: (context, approval) {
                        return _ApprovalDeskCriteriaPanel(
                          item: approval,
                          compact: true,
                        );
                      },
                      historyBuilder: (context, approval) {
                        return _ApprovalDeskHistoryPanel(
                          item: approval,
                          compact: true,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdaptiveContainerShowcase extends StatelessWidget {
  const _AdaptiveContainerShowcase();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveDebugOverlay(
          label: 'screen-container',
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: AdaptiveContainer(
                enableAnimation: true,
                animationDuration: 250,
                animateOnAdaptiveSize: true,
                compact: const AdaptiveSlot(
                  builder: _buildCompactContainerSlot,
                ),
                medium: const AdaptiveSlot(builder: _buildMediumContainerSlot),
                expanded: const AdaptiveSlot(
                  builder: _buildExpandedContainerSlot,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 340,
            child: ResponsiveDebugOverlay(
              label: 'local-container',
              useContainerConstraints: true,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: AdaptiveContainer(
                    enableAnimation: true,
                    animationDuration: 250,
                    animateOnAdaptiveSize: true,
                    useContainerConstraints: true,
                    compact: const AdaptiveSlot(
                      builder: _buildCompactContainerSlot,
                    ),
                    expanded: const AdaptiveSlot(
                      builder: _buildExpandedContainerSlot,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WorkspaceShellContent extends StatelessWidget {
  final int selectedIndex;

  const _WorkspaceShellContent({required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return switch (selectedIndex) {
      0 => const _WorkspaceShellOverview(),
      1 => const _WorkspaceShellReviewQueue(),
      _ => const _WorkspaceShellSettings(),
    };
  }
}

class _SectionNavigationHeader extends StatelessWidget {
  const _SectionNavigationHeader();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Workspace areas', style: TextStyle(fontWeight: FontWeight.w700)),
        SizedBox(height: 6),
        Text('Switch between related settings without leaving the page.'),
      ],
    );
  }
}

class _SectionNavigationFooter extends StatelessWidget {
  const _SectionNavigationFooter();

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: () {},
      icon: const Icon(Icons.history_toggle_off_outlined),
      label: const Text('Review history'),
    );
  }
}

class _SectionSurface extends StatelessWidget {
  final String title;
  final String body;
  final Color accent;

  const _SectionSurface({
    required this.title,
    required this.body,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: accent,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Text(body, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                Chip(label: Text('Adaptive')),
                Chip(label: Text('Sectioned')),
                Chip(label: Text('Container-aware')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkspaceRecord {
  final String name;
  final String role;
  final String status;
  final int throughput;

  const _WorkspaceRecord({
    required this.name,
    required this.role,
    required this.status,
    required this.throughput,
  });
}

List<AdaptiveDataColumn<_WorkspaceRecord>> _workspaceRecordColumns() {
  return [
    AdaptiveDataColumn<_WorkspaceRecord>(
      label: 'Owner',
      cellBuilder: (context, record) => Text(record.name),
    ),
    AdaptiveDataColumn<_WorkspaceRecord>(
      label: 'Team',
      cellBuilder: (context, record) => Text(record.role),
    ),
    AdaptiveDataColumn<_WorkspaceRecord>(
      label: 'Status',
      cellBuilder: (context, record) =>
          _WorkspaceStatusBadge(status: record.status),
    ),
    AdaptiveDataColumn<_WorkspaceRecord>(
      label: 'Throughput',
      numeric: true,
      cellBuilder: (context, record) => Text('${record.throughput}'),
    ),
  ];
}

List<AdaptiveBoardLane> _demoBoardLanes() {
  return const [
    AdaptiveBoardLane(
      title: 'Queued',
      description: 'Ready for the next adaptive pass.',
      leading: Icon(Icons.schedule_outlined),
      trailing: _BoardLaneCount(count: 3),
      items: [
        _BoardTaskCard(
          title: 'Refine dashboard density',
          detail: 'Tighten spacing rules for short tablet surfaces.',
        ),
        _BoardTaskCard(
          title: 'Audit nested forms',
          detail: 'Confirm local width rules stay stable in dialogs.',
        ),
      ],
      footer: _BoardLaneFooter(label: 'Create task'),
    ),
    AdaptiveBoardLane(
      title: 'Building',
      description: 'In active implementation.',
      leading: Icon(Icons.construction_outlined),
      trailing: _BoardLaneCount(count: 2),
      items: [
        _BoardTaskCard(
          title: 'Workspace shell follow-up',
          detail: 'Align inspector density with compact navigation states.',
        ),
        _BoardTaskCard(
          title: 'Board interaction polish',
          detail: 'Tune lane width and short-height behavior.',
        ),
      ],
      footer: _BoardLaneFooter(label: 'Sync review'),
    ),
    AdaptiveBoardLane(
      title: 'Done',
      description: 'Shipped adaptive building blocks.',
      leading: Icon(Icons.check_circle_outline),
      trailing: _BoardLaneCount(count: 4),
      items: [
        _BoardTaskCard(
          title: 'Fluid values',
          detail: 'Interpolated spacing and typography landed.',
        ),
        _BoardTaskCard(
          title: 'Adaptive data view',
          detail: 'Cards and tables now share one responsive primitive.',
        ),
      ],
      footer: _BoardLaneFooter(label: 'View archive'),
    ),
  ];
}

List<AdaptiveTimelineEntry> _demoTimelineEntries() {
  return const [
    AdaptiveTimelineEntry(
      title: 'Prototype the adaptive core',
      label: 'Q1',
      description:
          'Validate semantic breakpoints, fluid values, and container-aware layout resolution.',
      leading: Icon(Icons.flag_outlined),
      trailing: _TimelineStageBadge(label: 'Foundation'),
      child: _TimelineMilestoneCard(
        title: 'Key result',
        detail:
            'One responsive model now powers cards, panes, forms, and dashboards.',
      ),
      footer: _TimelineFooterLink(label: 'Review milestone'),
    ),
    AdaptiveTimelineEntry(
      title: 'Systemize workflow surfaces',
      label: 'Q2',
      description:
          'Bring adaptive navigation, inspectors, and sectioned settings into one package story.',
      leading: Icon(Icons.auto_awesome_outlined),
      trailing: _TimelineStageBadge(label: 'Platform'),
      child: _TimelineMilestoneCard(
        title: 'Key result',
        detail:
            'Workspace shells and settings areas now share the same adaptive primitives.',
      ),
      footer: _TimelineFooterLink(label: 'Share roadmap'),
    ),
    AdaptiveTimelineEntry(
      title: 'Scale data-heavy layouts',
      label: 'Q3',
      description:
          'Promote records, lanes, and timelines into first-class adaptive workflow views.',
      leading: Icon(Icons.rocket_launch_outlined),
      trailing: _TimelineStageBadge(label: 'Scale'),
      child: _TimelineMilestoneCard(
        title: 'Key result',
        detail:
            'Tables, boards, and timelines all respect container width and short-height demotion rules.',
      ),
      footer: _TimelineFooterLink(label: 'Open release notes'),
    ),
  ];
}

List<AdaptiveComparisonItem> _demoComparisonItems() {
  return const [
    AdaptiveComparisonItem(
      label: 'Starter',
      description: 'Lean adaptive defaults for smaller teams.',
      leading: Icon(Icons.eco_outlined),
      trailing: _ComparisonPriceBadge(label: '\$29'),
      child: _ComparisonBody(
        title: 'Best for early rollout',
        bullets: [
          'Responsive values and spacing',
          'Container-aware cards and sections',
          'Compact-first settings surfaces',
        ],
      ),
      footer: _ComparisonFooterButton(label: 'Choose Starter'),
    ),
    AdaptiveComparisonItem(
      label: 'Growth',
      description: 'More workflow surfaces and inspector behavior.',
      leading: Icon(Icons.trending_up_outlined),
      trailing: _ComparisonPriceBadge(label: '\$79'),
      child: _ComparisonBody(
        title: 'Best for active teams',
        bullets: [
          'Adaptive workspace shell',
          'Inspector, board, and timeline primitives',
          'Height-aware demotion across chrome',
        ],
      ),
      footer: _ComparisonFooterButton(label: 'Choose Growth'),
    ),
    AdaptiveComparisonItem(
      label: 'Scale',
      description: 'The full set of comparison, board, and data-heavy layouts.',
      leading: Icon(Icons.auto_graph_outlined),
      trailing: _ComparisonPriceBadge(label: '\$149'),
      child: _ComparisonBody(
        title: 'Best for broad adoption',
        bullets: [
          'Adaptive data views and comparisons',
          'Workflow boards and roadmap timelines',
          'Container-driven nested surfaces',
        ],
      ),
      footer: _ComparisonFooterButton(label: 'Choose Scale'),
    ),
  ];
}

List<AdaptiveDocumentSection> _demoDocumentSections() {
  return const [
    AdaptiveDocumentSection(
      label: 'Overview',
      summary:
          'Explain the package shift from width helpers to a fuller adaptive layout system.',
      leading: Icon(Icons.description_outlined),
      trailing: _TimelineStageBadge(label: 'Intro'),
      child: _ComparisonBody(
        title: 'Why this release matters',
        bullets: [
          'The package now reads like a connected adaptive system',
          'Compound workflow surfaces share the same width and height rules',
          'Catalog demos and docs explain the model from one place',
        ],
      ),
    ),
    AdaptiveDocumentSection(
      label: 'Layout rules',
      summary:
          'Document the container-aware and height-aware decisions behind the primitives.',
      leading: Icon(Icons.rule_folder_outlined),
      trailing: _TimelineStageBadge(label: 'Rules'),
      child: _ComparisonBody(
        title: 'What to watch',
        bullets: [
          'Container constraints take precedence for nested cards and dialogs',
          'Short wide surfaces can demote chrome instead of forcing split views',
          'Animated transitions stay stable while layout modes change',
        ],
      ),
    ),
    AdaptiveDocumentSection(
      label: 'Verification',
      summary:
          'Capture the release checks that protect the growing catalog of widgets.',
      leading: Icon(Icons.fact_check_outlined),
      trailing: _TimelineStageBadge(label: 'Checks'),
      child: _ComparisonBody(
        title: 'Release checklist',
        bullets: [
          'Run analyzer across lib, tests, and the example catalog',
          'Keep widget coverage on each high-level primitive',
          'Use the catalog pages to catch transient overflow regressions',
        ],
      ),
    ),
  ];
}

class _WorkbenchLibraryPanel extends StatelessWidget {
  final bool compact;

  const _WorkbenchLibraryPanel({this.compact = false});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (final item in [
          ('Hero shell', 'Top-level scaffold and navigation'),
          ('Review queue', 'Cards, schedule, and diff blocks'),
          ('Release notes', 'Document and timeline sections'),
          ('Inspector slot', 'Docked or modal support surfaces'),
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFDCEBFF),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.$1,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(item.$2),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _ResultBrowserBadge(label: compact ? 'Local' : 'Core'),
                        _ResultBrowserBadge(label: 'Drag ready'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _WorkbenchCanvasPanel extends StatelessWidget {
  final bool compact;

  const _WorkbenchCanvasPanel({this.compact = false});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0B6E4F), Color(0xFF2F8A62)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  compact
                      ? 'Canvas stays readable in nested studio cards.'
                      : 'One canvas stays primary while support panels dock progressively.',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'This workbench keeps the composition area stable instead of '
                  'switching to unrelated mobile and desktop screens.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.92),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: const [
            _WorkbenchCanvasCard(
              title: 'Hero',
              detail: 'Adaptive shell overview and launch metrics.',
              color: Color(0xFFD9F0E4),
            ),
            _WorkbenchCanvasCard(
              title: 'Review',
              detail: 'Diff, timeline, and release-note surfaces.',
              color: Color(0xFFFCE7C8),
            ),
            _WorkbenchCanvasCard(
              title: 'Settings',
              detail: 'Sections, forms, and inspector-linked controls.',
              color: Color(0xFFF7DDF3),
            ),
          ],
        ),
      ],
    );
  }
}

class _WorkbenchCanvasCard extends StatelessWidget {
  final String title;
  final String detail;
  final Color color;

  const _WorkbenchCanvasCard({
    required this.title,
    required this.detail,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(detail),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkbenchInspectorPanel extends StatelessWidget {
  final bool compact;

  const _WorkbenchInspectorPanel({this.compact = false});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const _WorkbenchInspectorGroup(
          title: 'Layout density',
          values: ['Compact fallback', 'Medium workspace', 'Expanded chrome'],
        ),
        const SizedBox(height: 16),
        const _WorkbenchInspectorGroup(
          title: 'Selected block',
          values: ['Hero shell', 'Green surface', 'Docked summary card'],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _ResultBrowserBadge(label: compact ? 'Modal' : 'Docked'),
            const _ResultBrowserBadge(label: 'Container-aware'),
            const _ResultBrowserBadge(label: 'Height-aware'),
          ],
        ),
      ],
    );
  }
}

class _WorkbenchInspectorGroup extends StatelessWidget {
  final String title;
  final List<String> values;

  const _WorkbenchInspectorGroup({required this.title, required this.values});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F5F2),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            for (final value in values) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(Icons.check_circle_outline, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(value)),
                ],
              ),
              if (value != values.last) const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class _ReviewDeskReviewBody extends StatelessWidget {
  final _ResultBrowserEntry entry;
  final bool compact;

  const _ReviewDeskReviewBody({required this.entry, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                entry.accent.withValues(alpha: 0.92),
                entry.accent.withValues(alpha: 0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.62),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: SizedBox(
                    width: 52,
                    height: 52,
                    child: Icon(entry.icon),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.title,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(entry.detail),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _ComparisonBody(
          title: compact ? 'Compact review notes' : 'Review checklist',
          bullets: entry.bullets,
        ),
      ],
    );
  }
}

class _ReviewDeskDecisionPanel extends StatelessWidget {
  final _ResultBrowserEntry entry;
  final bool compact;

  const _ReviewDeskDecisionPanel({required this.entry, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _ResultBrowserBadge(label: entry.status),
            _ResultBrowserBadge(label: entry.category),
            _ResultBrowserBadge(label: compact ? 'Modal-first' : 'Docked'),
          ],
        ),
        const SizedBox(height: 16),
        const _WorkbenchInspectorGroup(
          title: 'Decision state',
          values: [
            'Approve when spacing and hierarchy stay stable',
            'Flag any overflow or clipped transition',
            'Route follow-up polish into the next pass',
          ],
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.check_circle_outline),
          label: const Text('Approve review'),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.flag_outlined),
          label: const Text('Request changes'),
        ),
      ],
    );
  }
}

class _ConversationDeskThread extends StatelessWidget {
  final _ResultBrowserEntry entry;
  final bool compact;

  const _ConversationDeskThread({required this.entry, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final messages = [
      'Could we ship the nested inspector update in this pass?',
      'Yes, but the short-height demotion still needs verification.',
      compact
          ? 'I will keep the thread primary in the nested card.'
          : 'I will keep the thread primary and leave context docked only on larger layouts.',
    ];

    return ListView(
      children: [
        for (var index = 0; index < messages.length; index++) ...[
          Align(
            alignment: index.isEven
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: index.isEven
                      ? const Color(0xFFDCEBFF)
                      : entry.accent.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Text(
                    messages[index],
                    style: index.isEven
                        ? null
                        : const TextStyle(color: Colors.black87),
                  ),
                ),
              ),
            ),
          ),
          if (index < messages.length - 1) const SizedBox(height: 12),
        ],
        const SizedBox(height: 16),
        _ComparisonBody(
          title: compact ? 'Compact thread state' : 'Thread summary',
          bullets: [
            'Current topic: ${entry.title}',
            'Status stays visible in the context panel or sheet',
            'Selection changes update thread and context together',
          ],
        ),
      ],
    );
  }
}

class _ConversationDeskContext extends StatelessWidget {
  final _ResultBrowserEntry entry;
  final bool compact;

  const _ConversationDeskContext({required this.entry, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _ResultBrowserBadge(label: entry.status),
            _ResultBrowserBadge(label: entry.category),
            _ResultBrowserBadge(label: compact ? 'Modal' : 'Docked'),
          ],
        ),
        const SizedBox(height: 16),
        const _WorkbenchInspectorGroup(
          title: 'Participant notes',
          values: [
            'Owner: Design systems team',
            'Priority: Follow-up within this release pass',
            'Next step: Confirm short-height transitions',
          ],
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.reply_outlined),
          label: const Text('Reply to thread'),
        ),
      ],
    );
  }
}

class _ComposerEditorSurface extends StatelessWidget {
  final bool compact;

  const _ComposerEditorSurface({this.compact = false});

  @override
  Widget build(BuildContext context) {
    final lines = compact
        ? const [
            '## Release summary',
            '',
            'Adaptive layouts now cover conversation, review, and builder flows.',
            '',
            '- Verify nested surfaces',
            '- Confirm height-aware demotion',
          ]
        : const [
            '## Release summary',
            '',
            'Adaptive layouts now cover conversation, review, builder, and '
                'long-form documentation flows from one package story.',
            '',
            '### Highlights',
            '- Progressive docking across workflow surfaces',
            '- Container-aware fallback for nested cards and dialogs',
            '- Height-aware demotion to prevent clipped chrome',
          ];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7F3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final line in lines) ...[
            Text(
              line,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontFamily: 'monospace'),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _ComposerPreviewSurface extends StatelessWidget {
  final bool compact;

  const _ComposerPreviewSurface({this.compact = false});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0B6E4F), Color(0xFF2F8A62)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  compact
                      ? 'Nested surfaces still preview cleanly.'
                      : 'The preview stays readable while settings dock progressively.',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'One composer can draft, preview, and configure content '
                  'without splitting into separate mobile and desktop screens.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.92),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const _ComparisonBody(
          title: 'Preview checklist',
          bullets: [
            'Heading hierarchy still reads clearly',
            'Spacing survives compact and split transitions',
            'Publishing metadata stays available in settings',
          ],
        ),
      ],
    );
  }
}

class _ComposerSettingsSurface extends StatelessWidget {
  final bool compact;

  const _ComposerSettingsSurface({this.compact = false});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _ResultBrowserBadge(label: compact ? 'Modal' : 'Docked'),
            const _ResultBrowserBadge(label: 'Publish ready'),
            const _ResultBrowserBadge(label: 'Height-aware'),
          ],
        ),
        const SizedBox(height: 16),
        const _WorkbenchInspectorGroup(
          title: 'Composer options',
          values: [
            'Status: Draft',
            'Audience: Release notes readers',
            'Visibility: Internal preview until approval',
          ],
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.publish_outlined),
          label: const Text('Publish draft'),
        ),
      ],
    );
  }
}

class _PresentationDeskStage extends StatelessWidget {
  final _ResultBrowserEntry entry;
  final bool compact;

  const _PresentationDeskStage({required this.entry, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                entry.accent.withValues(alpha: 0.94),
                entry.accent.withValues(alpha: 0.72),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  compact
                      ? entry.title
                      : '${entry.title} drives the adaptive package story.',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  entry.detail,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _ResultBrowserBadge(label: entry.category),
                    _ResultBrowserBadge(label: entry.status),
                    _ResultBrowserBadge(label: compact ? 'Stage' : 'Preview'),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _ComparisonBody(
          title: compact ? 'Slide summary' : 'Presenter takeaways',
          bullets: entry.bullets,
        ),
      ],
    );
  }
}

class _PresentationDeskNotes extends StatelessWidget {
  final _ResultBrowserEntry entry;
  final bool compact;

  const _PresentationDeskNotes({required this.entry, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const _WorkbenchInspectorGroup(
          title: 'Speaker notes',
          values: [
            'Open with the product story, not the implementation list',
            'Call out height-aware and container-aware behavior explicitly',
            'Use the catalog to show each primitive in isolation',
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _ResultBrowserBadge(label: entry.title),
            _ResultBrowserBadge(label: compact ? 'Modal' : 'Docked'),
            const _ResultBrowserBadge(label: 'Presenter'),
          ],
        ),
      ],
    );
  }
}

class _ControlCenterMainPanel extends StatelessWidget {
  final bool compact;

  const _ControlCenterMainPanel({this.compact = false});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0B6E4F), Color(0xFF2F8A62)],
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: EdgeInsets.all(compact ? 20 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  compact
                      ? 'System health is stable.'
                      : 'Container-aware monitoring keeps dense dashboards intentional.',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  compact
                      ? 'Escalations stay visible without forcing all support panels inline.'
                      : 'The main dashboard stays primary while supporting panels dock progressively from local width and height.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const [
                    _ResultBrowserBadge(label: '17 services healthy'),
                    _ResultBrowserBadge(label: '2 warnings'),
                    _ResultBrowserBadge(label: '1 active incident'),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: const [
            _ControlCenterMetricCard(
              title: 'Requests',
              value: '48.2k',
              detail: 'Trailing 30 minutes',
              accent: Color(0xFFD9F0E4),
            ),
            _ControlCenterMetricCard(
              title: 'Latency',
              value: '182ms',
              detail: 'P95 across edge regions',
              accent: Color(0xFFFCE7C8),
            ),
            _ControlCenterMetricCard(
              title: 'Rollouts',
              value: '3',
              detail: 'Progressing safely',
              accent: Color(0xFFDCEBFF),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const _ComparisonBody(
          title: 'What this layout is solving',
          bullets: [
            'Compact layouts keep the dashboard readable and move everything else behind clear triggers',
            'Expanded layouts leave service health and insights visible without compressing the charts',
            'Tall expanded layouts can dock the activity stream below the dashboard instead of forcing a separate route',
          ],
        ),
      ],
    );
  }
}

class _ControlCenterSidebarPanel extends StatelessWidget {
  final bool compact;

  const _ControlCenterSidebarPanel({this.compact = false});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        _ControlCenterLaneCard(
          title: 'Checkout API',
          detail: 'Latency elevated in us-east',
          accent: Color(0xFFFCE7C8),
          status: 'Investigating',
        ),
        SizedBox(height: 12),
        _ControlCenterLaneCard(
          title: 'Editor sync',
          detail: 'Healthy after rollout 14',
          accent: Color(0xFFD9F0E4),
          status: 'Stable',
        ),
        SizedBox(height: 12),
        _ControlCenterLaneCard(
          title: 'Search indexing',
          detail: 'Backfill running with low risk',
          accent: Color(0xFFDCEBFF),
          status: 'Queued',
        ),
      ],
    );
  }
}

class _ControlCenterInsightsPanel extends StatelessWidget {
  final bool compact;

  const _ControlCenterInsightsPanel({this.compact = false});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const _WorkbenchInspectorGroup(
          title: 'Priority incidents',
          values: [
            'Checkout API: P95 rose 22% after the canary ramp',
            'Editor sync: no new errors after the transport fallback',
            'Search indexing: backfill time is trending back toward baseline',
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            const _ResultBrowserBadge(label: '2 warnings'),
            _ResultBrowserBadge(label: compact ? 'Local mode' : 'Docked'),
            const _ResultBrowserBadge(label: 'Ops'),
          ],
        ),
        const SizedBox(height: 16),
        FilledButton.tonalIcon(
          onPressed: () {},
          icon: const Icon(Icons.auto_fix_high_outlined),
          label: const Text('Open mitigation plan'),
        ),
      ],
    );
  }
}

class _ControlCenterActivityPanel extends StatelessWidget {
  final bool compact;

  const _ControlCenterActivityPanel({this.compact = false});

  @override
  Widget build(BuildContext context) {
    final entries = compact
        ? const [
            ('09:18', 'Latency alert acknowledged'),
            ('09:24', 'Canary held at 30%'),
            ('09:31', 'Search backfill resumed'),
          ]
        : const [
            ('09:18', 'Latency alert acknowledged by platform on-call'),
            ('09:24', 'Checkout canary held at 30% while traces are sampled'),
            ('09:31', 'Search backfill resumed after queue pressure dropped'),
            ('09:42', 'Editor sync transport fallback confirmed healthy'),
          ];

    return ListView.separated(
      itemCount: entries.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final entry = entries[index];
        return DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TimelineStageBadge(label: entry.$1),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    entry.$2,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ControlCenterMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String detail;
  final Color accent;

  const _ControlCenterMetricCard({
    required this.title,
    required this.value,
    required this.detail,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 180, maxWidth: 220),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: accent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(detail),
            ],
          ),
        ),
      ),
    );
  }
}

class _ControlCenterLaneCard extends StatelessWidget {
  final String title;
  final String detail;
  final String status;
  final Color accent;

  const _ControlCenterLaneCard({
    required this.title,
    required this.detail,
    required this.status,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: accent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(detail),
            const SizedBox(height: 12),
            _ResultBrowserBadge(label: status),
          ],
        ),
      ),
    );
  }
}

class _IncidentDeskDetailPanel extends StatelessWidget {
  final _ResultBrowserEntry entry;
  final bool compact;

  const _IncidentDeskDetailPanel({required this.entry, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                entry.accent.withValues(alpha: 0.96),
                entry.accent.withValues(alpha: 0.74),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  compact
                      ? entry.title
                      : '${entry.title} needs coordinated response.',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  entry.detail,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _ResultBrowserBadge(label: entry.category),
                    _ResultBrowserBadge(label: entry.status),
                    _ResultBrowserBadge(
                      label: compact ? 'Active detail' : 'Incident detail',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _ComparisonBody(
          title: compact ? 'Active response' : 'Current response plan',
          bullets: entry.bullets,
        ),
      ],
    );
  }
}

class _IncidentDeskContextPanel extends StatelessWidget {
  final _ResultBrowserEntry entry;
  final bool compact;

  const _IncidentDeskContextPanel({required this.entry, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _WorkbenchInspectorGroup(
          title: 'Responder context',
          values: [
            'Owner: Platform incident rotation',
            'Impact: ${entry.summary}',
            compact
                ? 'Mode: modal support panel'
                : 'Mode: docked alongside active incident detail',
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _ResultBrowserBadge(label: entry.title),
            const _ResultBrowserBadge(label: 'Responders'),
            _ResultBrowserBadge(label: entry.status),
          ],
        ),
        const SizedBox(height: 16),
        FilledButton.tonalIcon(
          onPressed: () {},
          icon: const Icon(Icons.call_split_outlined),
          label: const Text('Open response plan'),
        ),
      ],
    );
  }
}

class _IncidentDeskTimelinePanel extends StatelessWidget {
  final _ResultBrowserEntry entry;
  final bool compact;

  const _IncidentDeskTimelinePanel({required this.entry, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final items = compact
        ? [
            ('09:12', 'Alert opened'),
            ('09:18', 'Owner assigned'),
            ('09:25', 'Mitigation applied'),
          ]
        : [
            ('09:12', '${entry.title} alert opened for ${entry.category}'),
            ('09:18', 'Platform on-call assigned and impact confirmed'),
            ('09:25', 'Mitigation applied while traces were sampled'),
            ('09:41', 'Verification sweep confirms recovery trend'),
          ];

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = items[index];
        return DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TimelineStageBadge(label: item.$1),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.$2,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MetricLabQueryTile extends StatelessWidget {
  final _MetricLabQuery query;
  final bool selected;
  final bool compact;
  final VoidCallback onTap;

  const _MetricLabQueryTile({
    required this.query,
    required this.selected,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? Theme.of(context).colorScheme.secondaryContainer
        : query.accent;

    return Material(
      color: color,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                query.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                query.summary,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ResultBrowserBadge(label: query.status),
                  _ResultBrowserBadge(
                    label: compact
                        ? query.value
                        : '${query.value} ${query.trend}',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricLabFocusPanel extends StatelessWidget {
  final _MetricLabQuery query;
  final bool compact;

  const _MetricLabFocusPanel({required this.query, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                query.accent.withValues(alpha: 0.98),
                query.accent.withValues(alpha: 0.76),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  compact ? query.title : '${query.title} stays primary.',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  query.summary,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _MetricLabStatCard(
                        label: 'Current',
                        value: query.value,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricLabStatCard(
                        label: 'Trend',
                        value: query.trend,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _ComparisonBody(
          title: compact ? 'Readout' : 'What the active query shows',
          bullets: query.notes,
        ),
      ],
    );
  }
}

class _MetricLabAnnotationsPanel extends StatelessWidget {
  final _MetricLabQuery query;
  final bool compact;

  const _MetricLabAnnotationsPanel({required this.query, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final items = compact
        ? const ['Experiment marker', 'Mitigation window', 'Release note']
        : const [
            'Experiment marker: payment-step copy test began at 08:30',
            'Mitigation window: worker rebalance applied at 09:12',
            'Release note: analyst comment pinned for the current regression band',
          ];

    return ListView(
      children: [
        _WorkbenchInspectorGroup(
          title: 'Analyst notes',
          values: [
            'Status: ${query.status}',
            'Current value: ${query.value}',
            compact ? 'Annotations in modal mode' : 'Annotations docked inline',
          ],
        ),
        const SizedBox(height: 16),
        for (final item in items) ...[
          DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(item),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _MetricLabHistoryPanel extends StatelessWidget {
  final _MetricLabQuery query;
  final bool compact;

  const _MetricLabHistoryPanel({required this.query, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final rows = compact
        ? const [
            ('08:15', 'Baseline'),
            ('09:00', 'Canary'),
            ('09:45', 'Mitigation'),
          ]
        : const [
            ('08:15', 'Baseline snapshot saved before rollout ramp'),
            ('09:00', 'Canary snapshot saved as regression surfaced'),
            ('09:45', 'Mitigation snapshot saved after manual intervention'),
            ('10:20', 'Recovery snapshot saved for the release summary'),
          ];

    return ListView.separated(
      itemCount: rows.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final row = rows[index];
        return DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TimelineStageBadge(label: row.$1),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(compact ? row.$2 : '${query.title}: ${row.$2}'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MetricLabStatCard extends StatelessWidget {
  final String label;
  final String value;

  const _MetricLabStatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExperimentLabItemTile extends StatelessWidget {
  final _ExperimentLabItem item;
  final bool selected;
  final bool compact;
  final VoidCallback onTap;

  const _ExperimentLabItemTile({
    required this.item,
    required this.selected,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? Theme.of(context).colorScheme.secondaryContainer
        : item.accent;

    return Material(
      color: color,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(item.summary),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ResultBrowserBadge(label: item.status),
                  _ResultBrowserBadge(
                    label: compact
                        ? item.primaryMetric
                        : '${item.primaryMetric} ${item.secondaryMetric}',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExperimentLabFocusPanel extends StatelessWidget {
  final _ExperimentLabItem item;
  final bool compact;

  const _ExperimentLabFocusPanel({required this.item, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                item.accent.withValues(alpha: 0.98),
                item.accent.withValues(alpha: 0.78),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  compact ? item.title : '${item.title} stays decision-ready.',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  item.summary,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _MetricLabStatCard(
                        label: 'Primary',
                        value: item.primaryMetric,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricLabStatCard(
                        label: 'Secondary',
                        value: item.secondaryMetric,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _ComparisonBody(
          title: compact ? 'Readout' : 'What the active experiment shows',
          bullets: item.evidence,
        ),
      ],
    );
  }
}

class _ExperimentLabEvidencePanel extends StatelessWidget {
  final _ExperimentLabItem item;
  final bool compact;

  const _ExperimentLabEvidencePanel({required this.item, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _WorkbenchInspectorGroup(
          title: 'Evidence summary',
          values: [
            'Status: ${item.status}',
            'Primary metric: ${item.primaryMetric}',
            compact ? 'Evidence in modal mode' : 'Evidence docked inline',
          ],
        ),
        const SizedBox(height: 16),
        for (final point in item.evidence) ...[
          DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(point),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _ExperimentLabDecisionPanel extends StatelessWidget {
  final _ExperimentLabItem item;
  final bool compact;

  const _ExperimentLabDecisionPanel({required this.item, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final rows = compact
        ? const [('Mon', 'Launch'), ('Tue', 'Review'), ('Wed', 'Decide')]
        : const [
            ('Mon', 'Launch experiment with guardrail monitoring'),
            ('Tue', 'Review metric lift and support feedback'),
            ('Wed', 'Decide whether to expand or stop the rollout'),
            ('Thu', 'Document the outcome for the release record'),
          ];

    return ListView.separated(
      itemCount: rows.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final row = rows[index];
        return DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TimelineStageBadge(label: row.$1),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(compact ? row.$2 : '${item.title}: ${row.$2}'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PlanningDeskItemTile extends StatelessWidget {
  final _PlanningDeskItem item;
  final bool selected;
  final bool compact;
  final VoidCallback onTap;

  const _PlanningDeskItemTile({
    required this.item,
    required this.selected,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? Theme.of(context).colorScheme.secondaryContainer
        : item.accent;

    return Material(
      color: color,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(item.summary),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ResultBrowserBadge(label: item.status),
                  _ResultBrowserBadge(
                    label: compact
                        ? item.horizon
                        : '${item.horizon} ${item.owner}',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanningDeskFocusPanel extends StatelessWidget {
  final _PlanningDeskItem item;
  final bool compact;

  const _PlanningDeskFocusPanel({required this.item, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                item.accent.withValues(alpha: 0.98),
                item.accent.withValues(alpha: 0.78),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  compact ? item.title : '${item.title} stays coordinated.',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  item.summary,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _MetricLabStatCard(
                        label: 'Horizon',
                        value: item.horizon,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricLabStatCard(
                        label: 'Owner',
                        value: item.owner,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _ComparisonBody(
          title: compact ? 'Checkpoints' : 'Current planning checkpoints',
          bullets: item.checkpoints,
        ),
      ],
    );
  }
}

class _PlanningDeskRisksPanel extends StatelessWidget {
  final _PlanningDeskItem item;
  final bool compact;

  const _PlanningDeskRisksPanel({required this.item, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _WorkbenchInspectorGroup(
          title: 'Risk summary',
          values: [
            'Status: ${item.status}',
            'Owner: ${item.owner}',
            compact ? 'Risks in modal mode' : 'Risks docked inline',
          ],
        ),
        const SizedBox(height: 16),
        for (final checkpoint in item.checkpoints.take(2)) ...[
          DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(checkpoint),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _PlanningDeskMilestonesPanel extends StatelessWidget {
  final _PlanningDeskItem item;
  final bool compact;

  const _PlanningDeskMilestonesPanel({
    required this.item,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final rows = compact
        ? const [('Week 1', 'Align'), ('Week 3', 'Build'), ('Week 6', 'Launch')]
        : const [
            ('Week 1', 'Align the plan with owners and dependencies'),
            ('Week 3', 'Complete implementation and review risk posture'),
            ('Week 5', 'Run verification and rollout readiness checks'),
            ('Week 6', 'Launch with support and release coordination'),
          ];

    return ListView.separated(
      itemCount: rows.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final row = rows[index];
        return DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TimelineStageBadge(label: row.$1),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(compact ? row.$2 : '${item.title}: ${row.$2}'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ReleaseLabItemTile extends StatelessWidget {
  final _ReleaseLabItem item;
  final bool selected;
  final bool compact;
  final VoidCallback onTap;

  const _ReleaseLabItemTile({
    required this.item,
    required this.selected,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? Theme.of(context).colorScheme.secondaryContainer
        : item.accent;

    return Material(
      color: color,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(item.summary),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ResultBrowserBadge(label: item.status),
                  _ResultBrowserBadge(
                    label: compact
                        ? item.readiness
                        : '${item.readiness} ${item.owner}',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReleaseLabReadinessPanel extends StatelessWidget {
  final _ReleaseLabItem item;
  final bool compact;

  const _ReleaseLabReadinessPanel({required this.item, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                item.accent.withValues(alpha: 0.98),
                item.accent.withValues(alpha: 0.78),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  compact ? item.title : '${item.title} stays launch-ready.',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  item.summary,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _MetricLabStatCard(
                        label: 'Readiness',
                        value: item.readiness,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricLabStatCard(
                        label: 'Owner',
                        value: item.owner,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _ComparisonBody(
          title: compact ? 'Readiness checks' : 'Current release checks',
          bullets: item.gates,
        ),
      ],
    );
  }
}

class _ReleaseLabBlockersPanel extends StatelessWidget {
  final _ReleaseLabItem item;
  final bool compact;

  const _ReleaseLabBlockersPanel({required this.item, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _WorkbenchInspectorGroup(
          title: 'Blocker summary',
          values: [
            'Status: ${item.status}',
            'Owner: ${item.owner}',
            compact ? 'Blockers in modal mode' : 'Blockers docked inline',
          ],
        ),
        const SizedBox(height: 16),
        for (final gate in item.gates.take(2)) ...[
          DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(gate),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _ReleaseLabRolloutPanel extends StatelessWidget {
  final _ReleaseLabItem item;
  final bool compact;

  const _ReleaseLabRolloutPanel({required this.item, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final rows = compact
        ? const [('T-3', 'Freeze'), ('T-1', 'Ready'), ('T+0', 'Launch')]
        : const [
            ('T-3', 'Freeze nonessential changes and confirm launch owners'),
            ('T-1', 'Run final analyzer and widget verification sweeps'),
            ('T+0', 'Launch gradually and watch blocker and support signals'),
            ('T+1', 'Capture follow-up actions for the changelog and support'),
          ];

    return ListView.separated(
      itemCount: rows.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final row = rows[index];
        return DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TimelineStageBadge(label: row.$1),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(compact ? row.$2 : '${item.title}: ${row.$2}'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ApprovalDeskItemTile extends StatelessWidget {
  final _ApprovalDeskItem item;
  final bool selected;
  final bool compact;
  final VoidCallback onTap;

  const _ApprovalDeskItemTile({
    required this.item,
    required this.selected,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? Theme.of(context).colorScheme.secondaryContainer
        : item.accent;

    return Material(
      color: color,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(item.summary),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ResultBrowserBadge(label: item.status),
                  _ResultBrowserBadge(
                    label: compact
                        ? item.stage
                        : '${item.stage} ${item.approver}',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ApprovalDeskProposalPanel extends StatelessWidget {
  final _ApprovalDeskItem item;
  final bool compact;

  const _ApprovalDeskProposalPanel({required this.item, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                item.accent.withValues(alpha: 0.98),
                item.accent.withValues(alpha: 0.78),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  compact ? item.title : '${item.title} is ready for signoff.',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  item.summary,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _MetricLabStatCard(
                        label: 'Stage',
                        value: item.stage,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricLabStatCard(
                        label: 'Approver',
                        value: item.approver,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _ComparisonBody(
          title: compact ? 'Approval focus' : 'What the approver should verify',
          bullets: item.criteria,
        ),
      ],
    );
  }
}

class _ApprovalDeskCriteriaPanel extends StatelessWidget {
  final _ApprovalDeskItem item;
  final bool compact;

  const _ApprovalDeskCriteriaPanel({required this.item, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _WorkbenchInspectorGroup(
          title: 'Criteria summary',
          values: [
            'Status: ${item.status}',
            'Stage: ${item.stage}',
            compact ? 'Criteria in modal mode' : 'Criteria docked inline',
          ],
        ),
        const SizedBox(height: 16),
        for (final criterion in item.criteria.take(2)) ...[
          DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(criterion),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _ApprovalDeskHistoryPanel extends StatelessWidget {
  final _ApprovalDeskItem item;
  final bool compact;

  const _ApprovalDeskHistoryPanel({required this.item, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final rows = compact
        ? const [
            ('Draft', 'Scoped'),
            ('Review', 'Checked'),
            ('Now', 'Awaiting signoff'),
          ]
        : [
            ('Draft', item.history[0]),
            ('Review', item.history[1]),
            ('Now', item.history[2]),
          ];

    return ListView.separated(
      itemCount: rows.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final row = rows[index];
        return DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TimelineStageBadge(label: row.$1),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(compact ? row.$2 : '${item.title}: ${row.$2}'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

(AdaptiveDiffPane, AdaptiveDiffPane) _demoDiffPanes() {
  return const (
    AdaptiveDiffPane(
      label: 'Current',
      description: 'The shipped workspace shell.',
      leading: Icon(Icons.check_circle_outline),
      trailing: _TimelineStageBadge(label: 'Live'),
      child: _ComparisonBody(
        title: 'What is already working',
        bullets: [
          'Adaptive scaffold handles bottom nav, rail, and drawer',
          'Inspector and priority layouts already compose cleanly',
          'The current shell is stable across nested containers',
        ],
      ),
      footer: _ComparisonFooterButton(label: 'Review current shell'),
    ),
    AdaptiveDiffPane(
      label: 'Proposed',
      description: 'The next review pass for denser workspaces.',
      leading: Icon(Icons.auto_fix_high_outlined),
      trailing: _TimelineStageBadge(label: 'Review'),
      child: _ComparisonBody(
        title: 'What changes in this pass',
        bullets: [
          'Compact reviews switch between panes instead of shrinking both',
          'Large layouts keep current and proposed states visible together',
          'Short-height thresholds still demote the split review safely',
        ],
      ),
      footer: _ComparisonFooterButton(label: 'Review proposed shell'),
    ),
  );
}

List<AdaptiveScheduleDay> _demoScheduleDays() {
  return const [
    AdaptiveScheduleDay(
      label: 'Monday',
      description: 'Prototype and review',
      leading: Icon(Icons.calendar_today_outlined),
      trailing: _ScheduleDayCount(count: 2),
      entries: [
        AdaptiveScheduleEntry(
          timeLabel: '09:00',
          title: 'Design review',
          description:
              'Walk through the adaptive shell catalog and note overflow risks.',
          trailing: _ScheduleStatusBadge(label: 'Review'),
        ),
        AdaptiveScheduleEntry(
          timeLabel: '13:30',
          title: 'Spacing audit',
          description:
              'Tune compact density for short-but-wide tablet surfaces.',
          trailing: _ScheduleStatusBadge(label: 'Active'),
        ),
      ],
      footer: _ScheduleFooterButton(label: 'Add Monday event'),
    ),
    AdaptiveScheduleDay(
      label: 'Tuesday',
      description: 'Implementation',
      leading: Icon(Icons.edit_calendar_outlined),
      trailing: _ScheduleDayCount(count: 2),
      entries: [
        AdaptiveScheduleEntry(
          timeLabel: '10:00',
          title: 'Board refinement',
          description:
              'Confirm day columns, lane scroll behavior, and nested container fallbacks.',
          trailing: _ScheduleStatusBadge(label: 'Building'),
        ),
        AdaptiveScheduleEntry(
          timeLabel: '15:00',
          title: 'Comparison polish',
          description:
              'Review compact selector behavior and wide-mode sizing thresholds.',
          trailing: _ScheduleStatusBadge(label: 'Queued'),
        ),
      ],
      footer: _ScheduleFooterButton(label: 'Add Tuesday event'),
    ),
    AdaptiveScheduleDay(
      label: 'Wednesday',
      description: 'Release pass',
      leading: Icon(Icons.event_available_outlined),
      trailing: _ScheduleDayCount(count: 1),
      entries: [
        AdaptiveScheduleEntry(
          timeLabel: '11:30',
          title: 'Verification sweep',
          description:
              'Run analyzer, the widget suite, and demo sanity checks before publish.',
          trailing: _ScheduleStatusBadge(label: 'Ready'),
        ),
      ],
      footer: _ScheduleFooterButton(label: 'Add Wednesday event'),
    ),
  ];
}

List<AdaptiveCalendarDay> _demoCalendarDays() {
  return const [
    AdaptiveCalendarDay(
      label: 'Mon 1',
      subtitle: 'Sprint kickoff',
      leading: Icon(Icons.wb_sunny_outlined),
      trailing: _CalendarDayBadge(label: '2'),
      entries: [
        _CalendarEventChip(label: 'Standup'),
        _CalendarEventChip(label: 'Design review'),
      ],
    ),
    AdaptiveCalendarDay(
      label: 'Tue 2',
      subtitle: 'Build day',
      leading: Icon(Icons.build_outlined),
      trailing: _CalendarDayBadge(label: '1'),
      entries: [_CalendarEventChip(label: 'Implementation')],
    ),
    AdaptiveCalendarDay(
      label: 'Wed 3',
      subtitle: 'Verification',
      leading: Icon(Icons.fact_check_outlined),
      trailing: _CalendarDayBadge(label: '3'),
      highlight: true,
      entries: [
        _CalendarEventChip(label: 'Analyzer'),
        _CalendarEventChip(label: 'Widget tests'),
        _CalendarEventChip(label: 'Demo pass'),
      ],
    ),
    AdaptiveCalendarDay(
      label: 'Thu 4',
      subtitle: 'Polish',
      leading: Icon(Icons.auto_fix_high_outlined),
      trailing: _CalendarDayBadge(label: '1'),
      entries: [_CalendarEventChip(label: 'Spacing tune')],
    ),
    AdaptiveCalendarDay(
      label: 'Fri 5',
      subtitle: 'Ship',
      leading: Icon(Icons.rocket_launch_outlined),
      trailing: _CalendarDayBadge(label: '2'),
      entries: [
        _CalendarEventChip(label: 'Release notes'),
        _CalendarEventChip(label: 'Publish'),
      ],
    ),
    AdaptiveCalendarDay(
      label: 'Sat 6',
      subtitle: 'Buffer',
      leading: Icon(Icons.weekend_outlined),
      trailing: _CalendarDayBadge(label: '0'),
      entries: [],
      emptyState: _CalendarEmptyState(label: 'No events'),
    ),
    AdaptiveCalendarDay(
      label: 'Sun 7',
      subtitle: 'Planning',
      leading: Icon(Icons.event_note_outlined),
      trailing: _CalendarDayBadge(label: '1'),
      entries: [_CalendarEventChip(label: 'Next sprint')],
    ),
  ];
}

List<AdaptiveDeckItem> _demoDeckItems() {
  return const [
    AdaptiveDeckItem(
      label: 'Foundation',
      description: 'Core responsive primitives.',
      leading: Icon(Icons.layers_outlined),
      trailing: _TimelineStageBadge(label: 'Core'),
      tooltip: 'Foundation deck card',
      child: _ComparisonBody(
        title: 'What ships here',
        bullets: [
          'Semantic width and height breakpoints',
          'Fluid spacing and typography helpers',
          'Container-aware value resolution',
        ],
      ),
      footer: _ComparisonFooterButton(label: 'Open foundations'),
    ),
    AdaptiveDeckItem(
      label: 'Workflow',
      description: 'Compound workspace surfaces.',
      leading: Icon(Icons.workspaces_outline),
      trailing: _TimelineStageBadge(label: 'Workflow'),
      tooltip: 'Workflow deck card',
      child: _ComparisonBody(
        title: 'What ships here',
        bullets: [
          'Adaptive scaffold, pane, and inspector',
          'Priority layouts, sections, and forms',
          'Height-aware chrome demotion rules',
        ],
      ),
      footer: _ComparisonFooterButton(label: 'Open workflows'),
    ),
    AdaptiveDeckItem(
      label: 'Launch',
      description: 'Verification and release surfaces.',
      leading: Icon(Icons.rocket_launch_outlined),
      trailing: _TimelineStageBadge(label: 'Launch'),
      tooltip: 'Launch deck card',
      child: _ComparisonBody(
        title: 'What ships here',
        bullets: [
          'Boards, schedules, and timelines',
          'Comparison, calendar, and data views',
          'Catalog demos and regression coverage',
        ],
      ),
      footer: _ComparisonFooterButton(label: 'Open launch plan'),
    ),
  ];
}

List<AdaptiveGalleryItem> _demoGalleryItems() {
  return const [
    AdaptiveGalleryItem(
      label: 'Workspace launch',
      description: 'Preview the shell and nested inspector surfaces.',
      leading: Icon(Icons.web_asset_outlined),
      trailing: _TimelineStageBadge(label: 'Preview'),
      thumbnail: _GalleryThumbnail(color: Color(0xFFD9F0E4), icon: Icons.web),
      tooltip: 'Workspace launch preview',
      preview: _GalleryPreviewSurface(
        title: 'One shell, many surfaces.',
        detail:
            'Navigation, inspector, and adaptive panes stay in sync while the '
            'container width changes.',
        colors: [Color(0xFF0B6E4F), Color(0xFF2F8A62)],
      ),
      child: _ComparisonBody(
        title: 'What to inspect',
        bullets: [
          'Adaptive scaffold demotion on short heights',
          'Inspector docking across nested panes',
          'Priority content staying visible first',
        ],
      ),
      footer: _ComparisonFooterButton(label: 'Open workspace preview'),
    ),
    AdaptiveGalleryItem(
      label: 'Review queue',
      description: 'Preview denser card stacks for active reviews.',
      leading: Icon(Icons.fact_check_outlined),
      trailing: _TimelineStageBadge(label: 'Flow'),
      thumbnail: _GalleryThumbnail(
        color: Color(0xFFDCEBFF),
        icon: Icons.checklist,
      ),
      tooltip: 'Review queue preview',
      preview: _GalleryPreviewSurface(
        title: 'Review states stay scannable.',
        detail:
            'Cards, tables, and timelines use one adaptive model instead of '
            'splitting into separate mobile and desktop screens.',
        colors: [Color(0xFF365C9A), Color(0xFF5B82C4)],
      ),
      child: _ComparisonBody(
        title: 'What to inspect',
        bullets: [
          'Adaptive data view switching between cards and tables',
          'Board and schedule surfaces sharing the same records',
          'Selector lists keeping context visible on wide layouts',
        ],
      ),
      footer: _ComparisonFooterButton(label: 'Open review preview'),
    ),
    AdaptiveGalleryItem(
      label: 'Release storyboard',
      description: 'Preview the final adaptive package narrative.',
      leading: Icon(Icons.rocket_launch_outlined),
      trailing: _TimelineStageBadge(label: 'Story'),
      thumbnail: _GalleryThumbnail(
        color: Color(0xFFFCE7C8),
        icon: Icons.rocket,
      ),
      tooltip: 'Release storyboard preview',
      preview: _GalleryPreviewSurface(
        title: 'The package now reads like a system.',
        detail:
            'Demos, docs, and high-level surfaces all describe the same '
            'adaptive layout model from different angles.',
        colors: [Color(0xFF9A5C18), Color(0xFFC9812A)],
      ),
      child: _ComparisonBody(
        title: 'What to inspect',
        bullets: [
          'Catalog pages for each major primitive',
          'Height-aware and container-aware fallbacks',
          'Tests catching transient overflow regressions',
        ],
      ),
      footer: _ComparisonFooterButton(label: 'Open release preview'),
    ),
  ];
}

List<Widget> _demoActiveFilters() {
  return const [
    _FilterPill(label: 'Mobile-ready'),
    _FilterPill(label: 'Live'),
    _FilterPill(label: 'Navigation'),
  ];
}

List<_ResultBrowserEntry> _demoResultBrowserEntries() {
  return const [
    _ResultBrowserEntry(
      title: 'Adaptive shell header',
      summary: 'Dense top app bar with width-aware action overflow.',
      category: 'Navigation',
      status: 'Live',
      detail:
          'The header keeps the primary route actions visible first and '
          'demotes secondary commands into overflow before the layout breaks.',
      bullets: [
        'Short-height navigation chrome demotion',
        'Priority-aware action overflow',
        'Container-safe nested shell behavior',
      ],
      accent: Color(0xFFD9F0E4),
      icon: Icons.web_asset_outlined,
    ),
    _ResultBrowserEntry(
      title: 'Inspector docking panel',
      summary: 'Supporting controls with inline and modal fallbacks.',
      category: 'Controls',
      status: 'Beta',
      detail:
          'The inspector layout keeps the canvas primary, docks inline from '
          'medium widths, and returns to modal behavior when height gets tight.',
      bullets: [
        'Inline inspector on larger surfaces',
        'Modal fallback on compact layouts',
        'Height-aware docking threshold',
      ],
      accent: Color(0xFFDCEBFF),
      icon: Icons.tune_outlined,
    ),
    _ResultBrowserEntry(
      title: 'Release timeline strip',
      summary: 'Milestone storytelling across narrow and wide canvases.',
      category: 'Planning',
      status: 'Draft',
      detail:
          'The timeline view preserves one milestone model while shifting from '
          'stacked cards to a horizontal roadmap as space becomes available.',
      bullets: [
        'Stacked milestone cards on compact widths',
        'Horizontal timeline on wider layouts',
        'Container-aware nested roadmap previews',
      ],
      accent: Color(0xFFFCE7C8),
      icon: Icons.timeline_outlined,
    ),
  ];
}

class _WorkspaceStatusBadge extends StatelessWidget {
  final String status;

  const _WorkspaceStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'Reviewing' => const Color(0xFFD9F0E4),
      'Building' => const Color(0xFFDCEBFF),
      _ => const Color(0xFFFCE7C8),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          status,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _BoardLaneCount extends StatelessWidget {
  final int count;

  const _BoardLaneCount({required this.count});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          '$count',
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _BoardTaskCard extends StatelessWidget {
  final String title;
  final String detail;

  const _BoardTaskCard({required this.title, required this.detail});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(detail),
          ],
        ),
      ),
    );
  }
}

class _BoardLaneFooter extends StatelessWidget {
  final String label;

  const _BoardLaneFooter({required this.label});

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: () {},
      icon: const Icon(Icons.add_circle_outline),
      label: Text(label),
    );
  }
}

class _TimelineStageBadge extends StatelessWidget {
  final String label;

  const _TimelineStageBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _TimelineMilestoneCard extends StatelessWidget {
  final String title;
  final String detail;

  const _TimelineMilestoneCard({required this.title, required this.detail});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(detail),
          ],
        ),
      ),
    );
  }
}

class _TimelineFooterLink extends StatelessWidget {
  final String label;

  const _TimelineFooterLink({required this.label});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.open_in_new_outlined),
      label: Text(label),
    );
  }
}

class _ComparisonPriceBadge extends StatelessWidget {
  final String label;

  const _ComparisonPriceBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _ComparisonBody extends StatelessWidget {
  final String title;
  final List<String> bullets;

  const _ComparisonBody({required this.title, required this.bullets});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        for (var index = 0; index < bullets.length; index++) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 3),
                child: Icon(Icons.check_circle_outline, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(bullets[index])),
            ],
          ),
          if (index < bullets.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _ComparisonFooterButton extends StatelessWidget {
  final String label;

  const _ComparisonFooterButton({required this.label});

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: () {},
      icon: const Icon(Icons.arrow_forward_outlined),
      label: Text(label),
    );
  }
}

class _ScheduleDayCount extends StatelessWidget {
  final int count;

  const _ScheduleDayCount({required this.count});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          '$count',
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _ScheduleStatusBadge extends StatelessWidget {
  final String label;

  const _ScheduleStatusBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    final color = switch (label) {
      'Review' => const Color(0xFFFCE7C8),
      'Active' => const Color(0xFFDCEBFF),
      'Building' => const Color(0xFFD9F0E4),
      'Ready' => const Color(0xFFE9DDFB),
      _ => const Color(0xFFF1F3F4),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _ScheduleFooterButton extends StatelessWidget {
  final String label;

  const _ScheduleFooterButton({required this.label});

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: () {},
      icon: const Icon(Icons.add_outlined),
      label: Text(label),
    );
  }
}

class _CalendarDayBadge extends StatelessWidget {
  final String label;

  const _CalendarDayBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _CalendarEventChip extends StatelessWidget {
  final String label;

  const _CalendarEventChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Text(label),
      ),
    );
  }
}

class _CalendarEmptyState extends StatelessWidget {
  final String label;

  const _CalendarEmptyState({required this.label});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(padding: const EdgeInsets.all(10), child: Text(label)),
    );
  }
}

class _FilterResultsHeader extends StatelessWidget {
  final String title;
  final String body;

  const _FilterResultsHeader({
    this.title = '89 matching components',
    this.body =
        'Results stay primary on compact layouts while active filters remain visible above the list.',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(body),
      ],
    );
  }
}

class _FilterResultsList extends StatelessWidget {
  final bool compact;

  const _FilterResultsList({this.compact = false});

  @override
  Widget build(BuildContext context) {
    final items = compact
        ? const [
            _FilterResultData(
              title: 'Adaptive shell header',
              detail: 'Dense top app bar with width-aware action overflow.',
              accent: Color(0xFFD9F0E4),
            ),
            _FilterResultData(
              title: 'Nested inspector card',
              detail: 'Docked controls with compact modal fallback.',
              accent: Color(0xFFDCEBFF),
            ),
          ]
        : const [
            _FilterResultData(
              title: 'Adaptive shell header',
              detail: 'Dense top app bar with width-aware action overflow.',
              accent: Color(0xFFD9F0E4),
            ),
            _FilterResultData(
              title: 'Workspace command rail',
              detail: 'Medium-width navigation that demotes on short heights.',
              accent: Color(0xFFFCE7C8),
            ),
            _FilterResultData(
              title: 'Nested inspector card',
              detail: 'Docked controls with compact modal fallback.',
              accent: Color(0xFFDCEBFF),
            ),
            _FilterResultData(
              title: 'Release timeline strip',
              detail: 'Timeline surface that stays readable in short tablets.',
              accent: Color(0xFFF7DDF3),
            ),
          ];

    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _FilterResultCard(data: items[index]);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 12),
    );
  }
}

class _FilterControls extends StatelessWidget {
  final bool compact;

  const _FilterControls({this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Surface type', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            FilterChip(
              selected: true,
              onSelected: _noopBool,
              label: Text('Navigation'),
            ),
            FilterChip(
              selected: true,
              onSelected: _noopBool,
              label: Text('Forms'),
            ),
            FilterChip(
              selected: false,
              onSelected: _noopBool,
              label: Text('Media'),
            ),
            FilterChip(
              selected: false,
              onSelected: _noopBool,
              label: Text('Dashboards'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text('Release status', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        SegmentedButton<String>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(value: 'live', label: Text('Live')),
            ButtonSegment(value: 'beta', label: Text('Beta')),
            ButtonSegment(value: 'draft', label: Text('Draft')),
          ],
          selected: const {'live'},
          onSelectionChanged: (selection) {},
        ),
        const SizedBox(height: 16),
        SwitchListTile.adaptive(
          value: true,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) {},
          title: const Text('Mobile-ready only'),
        ),
        SwitchListTile.adaptive(
          value: !compact,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) {},
          title: const Text('Include nested demos'),
        ),
      ],
    );
  }
}

class _FilterResultCard extends StatelessWidget {
  final _FilterResultData data;

  const _FilterResultCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: data.accent,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(data.detail),
          ],
        ),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;

  const _FilterPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(label), onDeleted: () {});
  }
}

class _FilterResultData {
  final String title;
  final String detail;
  final Color accent;

  const _FilterResultData({
    required this.title,
    required this.detail,
    required this.accent,
  });
}

class _ResultBrowserEntry {
  final String title;
  final String summary;
  final String category;
  final String status;
  final String detail;
  final List<String> bullets;
  final Color accent;
  final IconData icon;

  const _ResultBrowserEntry({
    required this.title,
    required this.summary,
    required this.category,
    required this.status,
    required this.detail,
    required this.bullets,
    required this.accent,
    required this.icon,
  });
}

class _ResultBrowserHeader extends StatelessWidget {
  final String title;
  final String body;

  const _ResultBrowserHeader({
    this.title = 'Component search results',
    this.body =
        'Browse the adaptive component library and keep details visible only '
        'when the current surface has room.',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(body),
      ],
    );
  }
}

class _ResultBrowserTile extends StatelessWidget {
  final _ResultBrowserEntry entry;
  final bool selected;
  final bool compact;
  final VoidCallback onTap;

  const _ResultBrowserTile({
    required this.entry,
    required this.selected,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? Theme.of(context).colorScheme.secondaryContainer
        : entry.accent;

    return Material(
      color: color,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SizedBox(width: 42, height: 42, child: Icon(entry.icon)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(entry.summary),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _ResultBrowserBadge(label: entry.category),
                        _ResultBrowserBadge(label: entry.status),
                        if (!compact)
                          _ResultBrowserBadge(
                            label: selected ? 'Selected' : 'Preview',
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultBrowserDetail extends StatelessWidget {
  final _ResultBrowserEntry entry;
  final bool compact;

  const _ResultBrowserDetail({required this.entry, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                entry.accent.withValues(alpha: 0.92),
                entry.accent.withValues(alpha: 0.68),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.62),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: SizedBox(
                    width: 52,
                    height: 52,
                    child: Icon(entry.icon),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.title,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(entry.detail),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _ComparisonBody(
          title: compact ? 'What matters here' : 'Why this result matters',
          bullets: entry.bullets,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _ResultBrowserBadge(label: entry.category),
            _ResultBrowserBadge(label: entry.status),
            _ResultBrowserBadge(label: compact ? 'Modal-first' : 'Split-ready'),
          ],
        ),
      ],
    );
  }
}

class _ResultBrowserBadge extends StatelessWidget {
  final String label;

  const _ResultBrowserBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

void _noopBool(bool value) {}

class _GalleryPreviewSurface extends StatelessWidget {
  final String title;
  final String detail;
  final List<Color> colors;

  const _GalleryPreviewSurface({
    required this.title,
    required this.detail,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(24),
      ),
      child: SizedBox(
        height: 180,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                detail,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.92),
                ),
              ),
              const Spacer(),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  Chip(label: Text('Adaptive')),
                  Chip(label: Text('Preview')),
                  Chip(label: Text('Container-aware')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GalleryThumbnail extends StatelessWidget {
  final Color color;
  final IconData icon;

  const _GalleryThumbnail({required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(width: 48, height: 48, child: Icon(icon)),
    );
  }
}

class _WorkspaceShellOverview extends StatelessWidget {
  const _WorkspaceShellOverview();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: AdaptiveContainer(
              useContainerConstraints: true,
              enableAnimation: true,
              compact: AdaptiveSlot(
                builder: (context) => const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _WorkspaceShellHeroCopy(),
                    SizedBox(height: 16),
                    _WorkspaceShellStatusCard(),
                  ],
                ),
              ),
              medium: AdaptiveSlot(
                builder: (context) => const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _WorkspaceShellHeroCopy()),
                    SizedBox(width: 16),
                    Expanded(flex: 2, child: _WorkspaceShellStatusCard()),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Workspace metrics',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'The shell body can still use the lower-level adaptive primitives '
          'inside one consistent navigation and inspector frame.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        AutoResponsiveGrid(
          minItemWidth: 220,
          columnSpacing: 16,
          rowSpacing: 16,
          children: [
            for (final metric in _defaultDashboardMetrics)
              _MetricCard(
                title: metric.title,
                value: metric.value,
                detail: metric.detail,
                color: metric.color,
              ),
          ],
        ),
      ],
    );
  }
}

class _WorkspaceShellReviewQueue extends StatelessWidget {
  const _WorkspaceShellReviewQueue();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ReviewQueueCard(
          title: 'Homepage audit',
          owner: 'Design systems',
          detail: 'Container widths verified across three embedded panes.',
          accent: Color(0xFFD9F0E4),
        ),
        const SizedBox(height: 12),
        const _ReviewQueueCard(
          title: 'Onboarding walkthrough',
          owner: 'Growth',
          detail: 'Adaptive forms now collapse to a stepper on compact space.',
          accent: Color(0xFFFCE7C8),
        ),
        const SizedBox(height: 12),
        const _ReviewQueueCard(
          title: 'Navigation shell',
          owner: 'Platform',
          detail:
              'Height-aware thresholds prevent wide but shallow layouts from overflowing.',
          accent: Color(0xFFDCEBFF),
        ),
      ],
    );
  }
}

class _WorkspaceShellSettings extends StatelessWidget {
  const _WorkspaceShellSettings();

  @override
  Widget build(BuildContext context) {
    return const Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SettingField(label: 'Workspace name'),
            SizedBox(height: 16),
            _SettingField(label: 'Default reviewer'),
            SizedBox(height: 16),
            _SettingField(label: 'Notification channel'),
          ],
        ),
      ),
    );
  }
}

class _WorkspaceShellHeroCopy extends StatelessWidget {
  const _WorkspaceShellHeroCopy();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ship workspace chrome once.',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Text(
          'AdaptiveWorkspaceShell keeps navigation, action overflow, and '
          'inspector behavior coordinated while inner content stays free to '
          'compose its own grids and panes.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

class _WorkspaceShellStatusCard extends StatelessWidget {
  const _WorkspaceShellStatusCard();

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surfaceContainerHighest;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shell summary',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 12),
            Text('Compact: bottom navigation and modal inspector'),
            SizedBox(height: 8),
            Text('Medium: rail navigation with modal or docked inspector'),
            SizedBox(height: 8),
            Text('Expanded: drawer navigation and docked supporting panel'),
          ],
        ),
      ),
    );
  }
}

class _WorkspaceShellInspector extends StatelessWidget {
  final int selectedIndex;

  const _WorkspaceShellInspector({required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    final stage = switch (selectedIndex) {
      0 => 'Overview',
      1 => 'Review',
      _ => 'Settings',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Focus area', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Chip(label: Text(stage)),
        const SizedBox(height: 16),
        Text('Pinned modules', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            Chip(label: Text('Navigation')),
            Chip(label: Text('Actions')),
            Chip(label: Text('Inspector')),
            Chip(label: Text('Container queries')),
          ],
        ),
        const SizedBox(height: 16),
        const _InspectorChecklistRow(
          title: 'Height-aware chrome thresholds',
          value: true,
        ),
        const SizedBox(height: 8),
        const _InspectorChecklistRow(
          title: 'Container-aware inner layouts',
          value: true,
        ),
      ],
    );
  }
}

class _ReviewQueueCard extends StatelessWidget {
  final String title;
  final String owner;
  final String detail;
  final Color accent;

  const _ReviewQueueCard({
    required this.title,
    required this.owner,
    required this.detail,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: accent,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(owner, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 12),
            Text(detail),
          ],
        ),
      ),
    );
  }
}

class _HeightAwareLayoutsShowcase extends StatelessWidget {
  const _HeightAwareLayoutsShowcase();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _HeightAwareDemoCard(label: 'short-panel', height: 220),
        SizedBox(height: 20),
        _HeightAwareDemoCard(label: 'tall-panel', height: 520),
      ],
    );
  }
}

class _HeightAwareDemoCard extends StatelessWidget {
  final String label;
  final double height;

  const _HeightAwareDemoCard({required this.label, required this.height});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: 560,
        height: height,
        child: ResponsiveDebugOverlay(
          label: label,
          useContainerConstraints: true,
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ResponsiveContainerBuilder(
                builder: (context, data) {
                  final title = const ResponsiveValue<String>(
                    heightCompact: 'Short viewport',
                    heightMedium: 'Balanced viewport',
                    heightExpanded: 'Tall viewport',
                  ).resolveForData(data)!;
                  final detail = const ResponsiveValue<String>(
                    heightCompact:
                        'Prioritize primary actions and compress supporting copy.',
                    heightMedium:
                        'There is room for richer context without changing width.',
                    heightExpanded:
                        'Vertical space can absorb longer summaries and denser '
                        'supporting content.',
                  ).resolveForData(data)!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      Text(detail),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Chip(
                            label: Text('height: ${data.adaptiveHeight.name}'),
                          ),
                          Chip(label: Text('width: ${data.adaptiveSize.name}')),
                        ],
                      ),
                      if (data.isHeightExpanded) ...[
                        const SizedBox(height: 16),
                        const Expanded(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Color(0xFFD9F0E4),
                              borderRadius: BorderRadius.all(
                                Radius.circular(24),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                'Expanded height can surface secondary guidance, '
                                'inspector hints, or inline documentation without '
                                'needing more horizontal space.',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AdaptiveClusterShowcase extends StatelessWidget {
  const _AdaptiveClusterShowcase();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveDebugOverlay(
          label: 'cluster',
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: AdaptiveCluster(
                expandedLayout: AdaptiveClusterLayout.row,
                children: const [
                  _ClusterCard(
                    title: 'Ship faster',
                    body: 'Compact mode stacks cards into a clear narrative.',
                    color: Color(0xFFD9F0E4),
                  ),
                  _ClusterCard(
                    title: 'Stay flexible',
                    body:
                        'Medium widths wrap cards without forcing exact spans.',
                    color: Color(0xFFFCE7C8),
                  ),
                  _ClusterCard(
                    title: 'Scale cleanly',
                    body: 'Expanded space can line cards up in a single band.',
                    color: Color(0xFFDCEBFF),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 330,
            child: ResponsiveDebugOverlay(
              label: 'nested-cluster',
              useContainerConstraints: true,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: AdaptiveCluster(
                    useContainerConstraints: true,
                    children: const [
                      _ClusterCard(
                        title: 'Nested pane',
                        body: 'Local width keeps the cluster stacked.',
                        color: Color(0xFFF7DDF3),
                      ),
                      _ClusterCard(
                        title: 'No extra logic',
                        body:
                            'The parent container, not the full screen, decides.',
                        color: Color(0xFFD9F0E4),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final List<_DashboardMetricData> _metrics = [
    ..._defaultDashboardMetrics,
  ];

  @override
  Widget build(BuildContext context) {
    final pagePadding = ResponsiveSpacing.fluidPadding(
      context,
      compact: const EdgeInsets.all(16),
      medium: const EdgeInsets.all(24),
      expanded: const EdgeInsets.all(32),
    );
    final headlineStyle = ResponsiveTextStyle.fluid(
      context,
      compact: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
      medium: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
      expanded: const TextStyle(fontSize: 44, fontWeight: FontWeight.w700),
    );

    return SingleChildScrollView(
      child: Padding(
        padding: pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ship one layout system, not three apps.',
              style: headlineStyle,
            ),
            ResponsiveSpacing.fluidGap(
              context,
              compact: 12,
              medium: 16,
              expanded: 20,
            ),
            Text(
              'BreakPoint: ${context.breakPoint.label}  '
              'AdaptiveSize: ${context.adaptiveSize.name}',
            ),
            ResponsiveSpacing.fluidGap(
              context,
              compact: 20,
              medium: 28,
              expanded: 32,
            ),
            const _AdaptiveHero(),
            ResponsiveSpacing.fluidGap(
              context,
              compact: 20,
              medium: 28,
              expanded: 32,
            ),
            Text('Auto Grid', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Cards derive their column count from the available width and '
              'can be reordered with a long press.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ResponsiveDebugOverlay(
              label: 'actions',
              useContainerConstraints: true,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: AdaptiveActionBar(
                    spacing: 12,
                    actions: const [
                      AdaptiveActionBarAction(
                        icon: Icon(Icons.add),
                        label: 'Create flow',
                        priority: 4,
                        variant: AdaptiveActionVariant.filled,
                        pinToPrimaryRow: true,
                      ),
                      AdaptiveActionBarAction(
                        icon: Icon(Icons.ios_share_outlined),
                        label: 'Share',
                        priority: 3,
                        variant: AdaptiveActionVariant.tonal,
                      ),
                      AdaptiveActionBarAction(
                        icon: Icon(Icons.copy_all_outlined),
                        label: 'Duplicate',
                        priority: 2,
                        variant: AdaptiveActionVariant.outlined,
                      ),
                      AdaptiveActionBarAction(
                        icon: Icon(Icons.archive_outlined),
                        label: 'Archive',
                        priority: 1,
                        variant: AdaptiveActionVariant.text,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ReorderableAutoResponsiveGrid(
              minItemWidth: context.responsive<double>(
                compact: 180,
                medium: 220,
                expanded: 260,
              )!,
              columnSpacing: 16,
              rowSpacing: 16,
              onReorder: _reorderMetrics,
              children: [
                for (final metric in _metrics)
                  _MetricCard(
                    key: ValueKey(metric.id),
                    title: metric.title,
                    value: metric.value,
                    detail: metric.detail,
                    color: metric.color,
                  ),
              ],
            ),
            ResponsiveSpacing.gap(
              context,
              compact: 20,
              medium: 28,
              expanded: 32,
            ),
            Text(
              'Container Query Section',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'This panel uses parent width, so it can stay tablet-like even '
              'inside a desktop shell.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: context.isExpanded ? 860 : double.infinity,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: AnimatedResponsiveLayoutBuilder(
                      useContainerConstraints: true,
                      animateOnAdaptiveSize: true,
                      xs: (context, _) => const _CompactInsights(),
                      md: (context, _) => const _SplitInsights(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _reorderMetrics(int oldIndex, int newIndex) {
    setState(() {
      final metric = _metrics.removeAt(oldIndex);
      _metrics.insert(newIndex, metric);
    });
  }
}

class WorkspacePage extends StatelessWidget {
  const WorkspacePage({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = context.responsive<EdgeInsets>(
      compact: const EdgeInsets.all(16),
      medium: const EdgeInsets.all(24),
      expanded: const EdgeInsets.all(32),
    )!;

    return SingleChildScrollView(
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Priority-aware composition',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Primary content stays visible while supporting context '
              'collapses or docks based on container width.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            ResponsiveDebugOverlay(
              label: 'workspace-pane',
              useContainerConstraints: true,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Padding(
                  padding: context.responsive<EdgeInsets>(
                    compact: const EdgeInsets.all(16),
                    medium: const EdgeInsets.all(20),
                    expanded: const EdgeInsets.all(24),
                  )!,
                  child: const AdaptivePriorityLayout(
                    supportingTitle: 'Workspace summary',
                    supportingDescription:
                        'Pinned modules, active reviews, and reusable layouts.',
                    supportingLeading: Icon(Icons.insights_outlined),
                    primary: _WorkspaceCopy(),
                    supporting: _WorkspaceSummary(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = context.responsive<EdgeInsets>(
      compact: const EdgeInsets.all(16),
      medium: const EdgeInsets.all(24),
      expanded: const EdgeInsets.all(32),
    )!;

    return SingleChildScrollView(
      child: Padding(
        padding: padding,
        child: ResponsiveDebugOverlay(
          label: 'settings-pane',
          useContainerConstraints: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Adaptive form layout',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Compact containers switch to a guided stepper. Larger '
                'containers keep grouped sections visible at once.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: context.isExpanded ? 980 : double.infinity,
                  child: ResponsiveDebugOverlay(
                    label: 'settings-form',
                    useContainerConstraints: true,
                    child: AdaptiveForm(
                      sections: [
                        AdaptiveFormSection(
                          title: 'Workspace',
                          description:
                              'Naming, routing, and ownership defaults.',
                          leading: Icon(Icons.tune_outlined),
                          children: [
                            _SettingField(label: 'Workspace name'),
                            _SettingField(label: 'Primary region'),
                          ],
                        ),
                        AdaptiveFormSection(
                          title: 'Governance',
                          description:
                              'Review ownership and publishing cadence.',
                          leading: Icon(Icons.shield_outlined),
                          children: [
                            _SettingField(label: 'Default owner'),
                            _SettingField(label: 'Review cadence'),
                          ],
                        ),
                        AdaptiveFormSection(
                          title: 'Notifications',
                          description:
                              'Route release activity to the right people.',
                          leading: Icon(Icons.notifications_outlined),
                          children: [
                            _SettingField(label: 'Release channel'),
                            _SettingField(label: 'Escalation contact'),
                          ],
                          footer: Align(
                            alignment: Alignment.centerLeft,
                            child: FilledButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.save_outlined),
                              label: const Text('Save changes'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionBarDemoCard extends StatelessWidget {
  final String label;

  const _ActionBarDemoCard({this.label = 'actions'});

  @override
  Widget build(BuildContext context) {
    return ResponsiveDebugOverlay(
      label: label,
      useContainerConstraints: true,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: AdaptiveActionBar(
            spacing: 12,
            actions: const [
              AdaptiveActionBarAction(
                icon: Icon(Icons.add),
                label: 'Create flow',
                priority: 4,
                variant: AdaptiveActionVariant.filled,
                pinToPrimaryRow: true,
              ),
              AdaptiveActionBarAction(
                icon: Icon(Icons.ios_share_outlined),
                label: 'Share',
                priority: 3,
                variant: AdaptiveActionVariant.tonal,
              ),
              AdaptiveActionBarAction(
                icon: Icon(Icons.copy_all_outlined),
                label: 'Duplicate',
                priority: 2,
                variant: AdaptiveActionVariant.outlined,
              ),
              AdaptiveActionBarAction(
                icon: Icon(Icons.archive_outlined),
                label: 'Archive',
                priority: 1,
                variant: AdaptiveActionVariant.text,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricGridShowcase extends StatefulWidget {
  final bool reorderable;

  const _MetricGridShowcase({required this.reorderable});

  @override
  State<_MetricGridShowcase> createState() => _MetricGridShowcaseState();
}

class _MetricGridShowcaseState extends State<_MetricGridShowcase> {
  late final List<_DashboardMetricData> _metrics = [
    ..._defaultDashboardMetrics,
  ];

  @override
  Widget build(BuildContext context) {
    final minItemWidth = context.responsive<double>(
      compact: 180,
      medium: 220,
      expanded: 260,
    )!;
    final metricCards = [
      for (final metric in _metrics)
        _MetricCard(
          key: ValueKey(metric.id),
          title: metric.title,
          value: metric.value,
          detail: metric.detail,
          color: metric.color,
        ),
    ];

    if (!widget.reorderable) {
      return AutoResponsiveGrid(
        minItemWidth: minItemWidth,
        columnSpacing: 16,
        rowSpacing: 16,
        children: metricCards,
      );
    }

    return ReorderableAutoResponsiveGrid(
      minItemWidth: minItemWidth,
      columnSpacing: 16,
      rowSpacing: 16,
      onReorder: (oldIndex, newIndex) {
        setState(() {
          final metric = _metrics.removeAt(oldIndex);
          _metrics.insert(newIndex, metric);
        });
      },
      children: metricCards,
    );
  }
}

class _WorkspaceSummaryCard extends StatelessWidget {
  const _WorkspaceSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: const _WorkspaceSummary(),
      ),
    );
  }
}

class _PriorityLayoutShowcase extends StatelessWidget {
  const _PriorityLayoutShowcase();

  @override
  Widget build(BuildContext context) {
    return ResponsiveDebugOverlay(
      label: 'workspace-pane',
      useContainerConstraints: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Padding(
          padding: context.responsive<EdgeInsets>(
            compact: const EdgeInsets.all(16),
            medium: const EdgeInsets.all(20),
            expanded: const EdgeInsets.all(24),
          )!,
          child: const AdaptivePriorityLayout(
            supportingTitle: 'Workspace summary',
            supportingDescription:
                'Pinned modules, active reviews, and reusable layouts.',
            supportingLeading: Icon(Icons.insights_outlined),
            primary: _WorkspaceCopy(),
            supporting: _WorkspaceSummary(),
          ),
        ),
      ),
    );
  }
}

class _AdaptiveFormShowcase extends StatelessWidget {
  const _AdaptiveFormShowcase();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: context.isExpanded ? 980 : double.infinity,
        child: ResponsiveDebugOverlay(
          label: 'settings-form',
          useContainerConstraints: true,
          child: AdaptiveForm(
            sections: [
              AdaptiveFormSection(
                title: 'Workspace',
                description: 'Naming, routing, and ownership defaults.',
                leading: const Icon(Icons.tune_outlined),
                children: const [
                  _SettingField(label: 'Workspace name'),
                  _SettingField(label: 'Primary region'),
                ],
              ),
              AdaptiveFormSection(
                title: 'Governance',
                description: 'Review ownership and publishing cadence.',
                leading: const Icon(Icons.shield_outlined),
                children: const [
                  _SettingField(label: 'Default owner'),
                  _SettingField(label: 'Review cadence'),
                ],
              ),
              AdaptiveFormSection(
                title: 'Notifications',
                description: 'Route release activity to the right people.',
                leading: const Icon(Icons.notifications_outlined),
                children: const [
                  _SettingField(label: 'Release channel'),
                  _SettingField(label: 'Escalation contact'),
                ],
                footer: Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.icon(
                    onPressed: null,
                    icon: Icon(Icons.save_outlined),
                    label: Text('Save changes'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdaptiveInspectorShowcase extends StatelessWidget {
  const _AdaptiveInspectorShowcase();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveDebugOverlay(
          label: 'inspector',
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: AdaptiveInspectorLayout(
                inspectorTitle: 'Layout inspector',
                inspectorDescription:
                    'Tune density and compare responsive states.',
                inspectorLeading: const Icon(Icons.tune_outlined),
                modalTriggerLabel: 'Open inspector',
                minimumDockedHeight: AdaptiveHeight.medium,
                primary: const _InspectorCanvas(),
                inspector: const _InspectorPanel(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 340,
            child: ResponsiveDebugOverlay(
              label: 'nested-inspector',
              useContainerConstraints: true,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: AdaptiveInspectorLayout(
                    useContainerConstraints: true,
                    inspectorTitle: 'Nested inspector',
                    inspectorDescription:
                        'The local card width decides whether this docks.',
                    inspectorLeading: const Icon(Icons.view_sidebar_outlined),
                    modalTriggerLabel: 'Open nested inspector',
                    minimumDockedHeight: AdaptiveHeight.medium,
                    primary: const _InspectorCanvas(
                      title: 'Nested workspace',
                      detail:
                          'This card stays compact even when the screen is wide.',
                    ),
                    inspector: const _InspectorPanel(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NavigationHeader extends StatelessWidget {
  const _NavigationHeader();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 120) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
            child: Tooltip(
              message: 'Adaptive Kit',
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(14),
                  child: Icon(Icons.dashboard_customize_outlined),
                ),
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Adaptive Kit',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 8),
                  Text('Breakpoints, semantic sizes, and pane-aware layouts.'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavigationFooter extends StatelessWidget {
  const _NavigationFooter();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 120) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
            child: Tooltip(
              message: 'Preview layout states',
              child: IconButton.filledTonal(
                onPressed: () {},
                icon: const Icon(Icons.visibility_outlined),
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(20),
          child: FilledButton.tonalIcon(
            onPressed: () {},
            icon: const Icon(Icons.visibility_outlined),
            label: const Text('Preview layout states'),
          ),
        );
      },
    );
  }
}

class _AdaptiveHero extends StatelessWidget {
  const _AdaptiveHero();

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainerBuilder(
      builder: (context, data) {
        final panelPadding = context.responsive<EdgeInsets>(
          compact: const EdgeInsets.all(16),
          medium: const EdgeInsets.all(20),
          expanded: const EdgeInsets.all(24),
        )!;

        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0B6E4F), Color(0xFF3B8C66)],
            ),
            borderRadius: BorderRadius.circular(32),
          ),
          child: Padding(
            padding: panelPadding,
            child: data.isCompact
                ? const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HeroCopy(),
                      SizedBox(height: 20),
                      _HeroStatusCard(),
                    ],
                  )
                : const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _HeroCopy()),
                      SizedBox(width: 20),
                      SizedBox(width: 260, child: _HeroStatusCard()),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy();

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Container queries make side panels feel intentional.',
            style: ResponsiveTextStyle.fluid(
              context,
              compact: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
              medium: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
              expanded: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'This hero swaps between a stacked and split composition based on '
            'its own width, not only the screen width.',
          ),
        ],
      ),
    );
  }
}

class _HeroStatusCard extends StatelessWidget {
  const _HeroStatusCard();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white24),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Layout summary',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12),
            Text('Compact: stacked content and bottom nav'),
            SizedBox(height: 8),
            Text('Medium: split panes with navigation rail'),
            SizedBox(height: 8),
            Text('Expanded: drawer-style shell and denser grids'),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String detail;
  final Color color;

  const _MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.detail,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const Icon(Icons.drag_indicator, size: 18),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(detail),
          ],
        ),
      ),
    );
  }
}
