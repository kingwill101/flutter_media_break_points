import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:media_break_points/media_break_points.dart';
import 'package:media_break_points/patterns.dart';
part 'src/demo_support.dart';
part 'src/demo_showcases.dart';

void main() {
  initMediaBreakPoints(const MediaBreakPointsConfig(considerOrientation: true));

  runApp(const AdaptiveDemoApp());
}

class AdaptiveDemoApp extends StatelessWidget {
  const AdaptiveDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Media Break Points Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B6E4F)),
      ),
      home: const DemoCatalogPage(),
    );
  }
}

const _defaultDashboardMetrics = [
  _DashboardMetricData(
    id: 'flows',
    title: 'Active flows',
    value: '18',
    detail: '+4 this week',
    color: Color(0xFFD9F0E4),
  ),
  _DashboardMetricData(
    id: 'completion',
    title: 'Completion rate',
    value: '93%',
    detail: 'Strong on tablet and desktop',
    color: Color(0xFFFCE7C8),
  ),
  _DashboardMetricData(
    id: 'layouts',
    title: 'Saved layouts',
    value: '42',
    detail: 'All variants share the same data model',
    color: Color(0xFFDCEBFF),
  ),
  _DashboardMetricData(
    id: 'experiments',
    title: 'Experiments',
    value: '7',
    detail: '2 container-driven views in progress',
    color: Color(0xFFF7DDF3),
  ),
];

const _defaultWorkspaceRecords = [
  _WorkspaceRecord(
    name: 'Ava Johnson',
    role: 'Design systems',
    status: 'Reviewing',
    throughput: 12,
  ),
  _WorkspaceRecord(
    name: 'Noah Clarke',
    role: 'Platform',
    status: 'Building',
    throughput: 9,
  ),
  _WorkspaceRecord(
    name: 'Mia Lopez',
    role: 'Growth',
    status: 'Queued',
    throughput: 7,
  ),
];

const _metricLabQueries = [
  _MetricLabQuery(
    title: 'Latency by region',
    summary: 'P95 latency across edge regions',
    status: 'Monitoring',
    value: '182ms',
    trend: '-12ms',
    accent: Color(0xFFDCEBFF),
    notes: [
      'us-east stabilized after the rollback window closed',
      'eu-west remains comfortably within baseline',
      'The chart is sensitive to short-lived cache misses',
    ],
  ),
  _MetricLabQuery(
    title: 'Checkout conversion',
    summary: 'Conversion through the new payment path',
    status: 'Investigating',
    value: '3.8%',
    trend: '-0.4%',
    accent: Color(0xFFFCE7C8),
    notes: [
      'Drop aligns with the experimental payment-step copy',
      'Mobile sessions recovered faster than desktop sessions',
      'Responder notes are attached to the rollout annotation band',
    ],
  ),
  _MetricLabQuery(
    title: 'Queue depth',
    summary: 'Pending jobs across ingestion workers',
    status: 'Healthy',
    value: '241',
    trend: '-18%',
    accent: Color(0xFFD9F0E4),
    notes: [
      'Backfill pressure is receding after worker rebalance',
      'One cluster is still catching up after maintenance',
      'History helps compare today against the last mitigation pass',
    ],
  ),
];

const _experimentLabItems = [
  _ExperimentLabItem(
    title: 'Checkout copy test',
    summary: 'Variant B shortens the payment step headline',
    status: 'Review',
    primaryMetric: '+0.4% conversion',
    secondaryMetric: '-3.1% hesitation',
    accent: Color(0xFFFCE7C8),
    evidence: [
      'Mobile conversion improved faster than desktop conversion',
      'The largest lift came from returning customers',
      'Support tickets did not increase during the experiment window',
    ],
  ),
  _ExperimentLabItem(
    title: 'Onboarding checklist',
    summary: 'Variant C reorders setup milestones by activation risk',
    status: 'Monitoring',
    primaryMetric: '+9% completion',
    secondaryMetric: '-14% setup time',
    accent: Color(0xFFDCEBFF),
    evidence: [
      'Completion lift held across small and medium teams',
      'Users spent less time searching for the next action',
      'There was no drop in downstream feature adoption',
    ],
  ),
  _ExperimentLabItem(
    title: 'Search zero-state',
    summary: 'Variant A promotes recent work before templates',
    status: 'Healthy',
    primaryMetric: '+11% first click',
    secondaryMetric: '+6% retained sessions',
    accent: Color(0xFFD9F0E4),
    evidence: [
      'Teams with larger project sets benefited the most',
      'Template engagement remained within expected variance',
      'Follow-up search depth fell after the first action',
    ],
  ),
];

const _planningDeskItems = [
  _PlanningDeskItem(
    title: 'Q3 platform launch',
    summary:
        'Coordinate rollout, enablement, and verification across product teams',
    status: 'Active',
    horizon: '6 weeks',
    owner: 'Platform PM',
    accent: Color(0xFFDCEBFF),
    checkpoints: [
      'Enablement docs must be approved before the canary begins',
      'Support runbooks should be complete by the beta milestone',
      'Verification coverage needs a final pass before general availability',
    ],
  ),
  _PlanningDeskItem(
    title: 'Analytics refresh',
    summary: 'Reshape dashboards and query flows around adaptive workspaces',
    status: 'Review',
    horizon: '4 weeks',
    owner: 'Design systems',
    accent: Color(0xFFFCE7C8),
    checkpoints: [
      'Query patterns need validation across compact and expanded surfaces',
      'Nested card behavior must be documented in the examples catalog',
      'The analyzer and widget suite should remain stable through refactors',
    ],
  ),
  _PlanningDeskItem(
    title: 'Workspace migration',
    summary: 'Move legacy layout screens to shared adaptive primitives',
    status: 'Queued',
    horizon: '8 weeks',
    owner: 'Core UI',
    accent: Color(0xFFD9F0E4),
    checkpoints: [
      'Shared navigation rules need signoff from the apps team',
      'Compact overflow regressions should be closed before migration begins',
      'Release checklists need to reference the new catalog pages',
    ],
  ),
];

const _releaseLabItems = [
  _ReleaseLabItem(
    title: 'Adaptive catalog 2.0',
    summary:
        'Coordinate final launch checks for the expanded workspace catalog',
    status: 'Readiness',
    readiness: '92%',
    owner: 'Release manager',
    accent: Color(0xFFDCEBFF),
    gates: [
      'Desktop overflow regressions must stay closed after demo updates',
      'Release notes need screenshots for the new workflow primitives',
      'Widget and analyzer passes must remain green before tagging',
    ],
  ),
  _ReleaseLabItem(
    title: 'Analytics workspace bundle',
    summary: 'Ship metrics and experiment surfaces as one documented release',
    status: 'Review',
    readiness: '81%',
    owner: 'Analytics lead',
    accent: Color(0xFFFCE7C8),
    gates: [
      'Examples need copy review for the new analytics catalog entries',
      'Nested container behavior should be documented in the README',
      'Upgrade guidance needs a short migration note for adopters',
    ],
  ),
  _ReleaseLabItem(
    title: 'Planning workspace rollout',
    summary:
        'Promote planning and release surfaces to the public package story',
    status: 'Queued',
    readiness: '68%',
    owner: 'Core UI',
    accent: Color(0xFFD9F0E4),
    gates: [
      'Launch checklist needs signoff from design systems and docs',
      'Risk copy should be tuned for consistency across planning demos',
      'A changelog summary should be ready before the version bump',
    ],
  ),
];

const _approvalDeskItems = [
  _ApprovalDeskItem(
    title: 'Workspace shell signoff',
    summary:
        'Approve the staged workspace shell before the next public package cut',
    status: 'Needs review',
    stage: 'Design + docs',
    approver: 'UI council',
    accent: Color(0xFFDCEBFF),
    criteria: [
      'Catalog pages must cover both full-width and nested container cases',
      'README guidance should explain when each staged workspace is appropriate',
      'The shell must remain free of transient overflow during mode changes',
    ],
    history: [
      'Design systems approved the navigation model yesterday',
      'Docs requested a shorter migration note for external adopters',
      'Final signoff is blocked on the release-readiness screenshots',
    ],
  ),
  _ApprovalDeskItem(
    title: 'Analytics workspace docs',
    summary: 'Approve the documentation pass for analytics and explorer labs',
    status: 'In review',
    stage: 'Docs review',
    approver: 'Developer education',
    accent: Color(0xFFFCE7C8),
    criteria: [
      'Analytics examples should stay distinct from planning and release flows',
      'Each adaptive lab needs a concise rationale in the README',
      'The example catalog copy should stay short enough to scan on mobile',
    ],
    history: [
      'The first copy pass was merged after terminology cleanup',
      'A second review requested stronger container-query explanations',
      'Legal confirmed the demo content is generic and safe to publish',
    ],
  ),
  _ApprovalDeskItem(
    title: 'Release checklist refresh',
    summary:
        'Approve the updated release checklist before tagging the next version',
    status: 'Queued',
    stage: 'Operations',
    approver: 'Release managers',
    accent: Color(0xFFD9F0E4),
    criteria: [
      'Approval flows must reference analyzer and widget verification steps',
      'The changelog note should mention new staged workspace primitives',
      'Versioning guidance should match the package maintenance workflow',
    ],
    history: [
      'The checklist owner added a final pre-tag verification section',
      'Release engineering requested a clearer rollback note',
      'Approval is waiting on the next dry-run release rehearsal',
    ],
  ),
];

class DemoCatalogPage extends StatelessWidget {
  const DemoCatalogPage({super.key});

  static final _entries = <_DemoEntry>[
    _DemoEntry(
      category: _DemoCategory.coreShellsAndSurfaces,
      title: 'Adaptive Scaffold',
      description: 'Run the full shell demo with bottom nav, rail, and drawer.',
      icon: Icons.dashboard_customize_outlined,
      builder: (_) => const AdaptiveScaffoldDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.coreShellsAndSurfaces,
      title: 'Workspace Shell',
      description:
          'Compose navigation, actions, and an inspector from one shell widget.',
      icon: Icons.web_asset_outlined,
      builder: (_) => const AdaptiveWorkspaceShellDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.corePrimitives,
      title: 'Adaptive Sections',
      description:
          'Use compact chips or a docked section sidebar for settings screens.',
      icon: Icons.segment_outlined,
      builder: (_) => const AdaptiveSectionsDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.coreShellsAndSurfaces,
      title: 'Adaptive Data View',
      description: 'Switch between compact record cards and a table layout.',
      icon: Icons.table_rows_outlined,
      builder: (_) => const AdaptiveDataViewDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.showcasePatterns,
      title: 'Adaptive Board',
      description:
          'Stack workflow lanes on compact space and spread them into a board on larger surfaces.',
      icon: Icons.view_kanban_outlined,
      builder: (_) => const AdaptiveBoardDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.showcasePatterns,
      title: 'Adaptive Timeline',
      description:
          'Move roadmap milestones between stacked cards and a horizontal timeline.',
      icon: Icons.timeline_outlined,
      builder: (_) => const AdaptiveTimelineDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.showcasePatterns,
      title: 'Adaptive Comparison',
      description:
          'Show one selected option on compact space and all options side by side on larger layouts.',
      icon: Icons.compare_arrows_outlined,
      builder: (_) => const AdaptiveComparisonDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.coreShellsAndSurfaces,
      title: 'Adaptive Diff View',
      description:
          'Review two fixed versions in compact toggle mode or side-by-side diff mode.',
      icon: Icons.compare_outlined,
      builder: (_) => const AdaptiveDiffViewDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.showcasePatterns,
      title: 'Adaptive Schedule',
      description:
          'Show a stacked agenda on compact space and day columns on larger layouts.',
      icon: Icons.calendar_view_day_outlined,
      builder: (_) => const AdaptiveScheduleDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.showcasePatterns,
      title: 'Adaptive Calendar',
      description:
          'Switch between a stacked agenda and a multi-column day grid.',
      icon: Icons.calendar_month_outlined,
      builder: (_) => const AdaptiveCalendarDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.showcasePatterns,
      title: 'Adaptive Deck',
      description:
          'Page through focused cards on compact space and fan them into a grid on larger layouts.',
      icon: Icons.view_carousel_outlined,
      builder: (_) => const AdaptiveDeckDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.showcasePatterns,
      title: 'Adaptive Gallery',
      description:
          'Move between a compact preview carousel and a larger spotlight layout.',
      icon: Icons.photo_library_outlined,
      builder: (_) => const AdaptiveGalleryDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.coreShellsAndSurfaces,
      title: 'Adaptive Filter Layout',
      description:
          'Keep results primary on compact layouts and dock filters inline on larger surfaces.',
      icon: Icons.filter_alt_outlined,
      builder: (_) => const AdaptiveFilterLayoutDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.coreShellsAndSurfaces,
      title: 'Adaptive Result Browser',
      description:
          'Open result details modally on compact layouts and dock them inline on larger surfaces.',
      icon: Icons.travel_explore_outlined,
      builder: (_) => const AdaptiveResultBrowserDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.showcasePatterns,
      title: 'Adaptive Explorer',
      description:
          'Combine filters, results, and detail panels into one adaptive browsing workspace.',
      icon: Icons.explore_outlined,
      builder: (_) => const AdaptiveExplorerDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.coreShellsAndSurfaces,
      title: 'Adaptive Document View',
      description:
          'Keep long-form content primary on compact layouts and dock its outline on larger surfaces.',
      icon: Icons.article_outlined,
      builder: (_) => const AdaptiveDocumentViewDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.showcasePatterns,
      title: 'Adaptive Workbench',
      description:
          'Stage a library, canvas, and inspector with progressive panel docking.',
      icon: Icons.design_services_outlined,
      builder: (_) => const AdaptiveWorkbenchDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.showcasePatterns,
      title: 'Adaptive Review Desk',
      description:
          'Stage a queue, review surface, and decision panel with progressive docking.',
      icon: Icons.rate_review_outlined,
      builder: (_) => const AdaptiveReviewDeskDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.showcasePatterns,
      title: 'Adaptive Conversation Desk',
      description:
          'Stage conversations, an active thread, and a context panel with progressive docking.',
      icon: Icons.forum_outlined,
      builder: (_) => const AdaptiveConversationDeskDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.showcasePatterns,
      title: 'Adaptive Composer',
      description:
          'Stage editor, preview, and settings surfaces with progressive docking.',
      icon: Icons.edit_note_outlined,
      builder: (_) => const AdaptiveComposerDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.showcasePatterns,
      title: 'Adaptive Presentation Desk',
      description:
          'Stage slides, a presentation stage, and speaker notes with progressive docking.',
      icon: Icons.slideshow_outlined,
      builder: (_) => const AdaptivePresentationDeskDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.showcasePatterns,
      title: 'Adaptive Control Center',
      description:
          'Stage a sidebar, dashboard, insights, and activity stream with progressive docking.',
      icon: Icons.monitor_heart_outlined,
      builder: (_) => const AdaptiveControlCenterDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.showcasePatterns,
      title: 'Adaptive Incident Desk',
      description:
          'Stage incidents, active detail, responder context, and timeline panels with progressive docking.',
      icon: Icons.crisis_alert_outlined,
      builder: (_) => const AdaptiveIncidentDeskDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.showcasePatterns,
      title: 'Adaptive Metrics Lab',
      description:
          'Stage saved queries, active chart focus, annotations, and query history with progressive docking.',
      icon: Icons.query_stats_outlined,
      builder: (_) => const AdaptiveMetricsLabDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.showcasePatterns,
      title: 'Adaptive Experiment Lab',
      description:
          'Stage experiments, active variant focus, evidence, and decision history with progressive docking.',
      icon: Icons.science_outlined,
      builder: (_) => const AdaptiveExperimentLabDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.showcasePatterns,
      title: 'Adaptive Planning Desk',
      description:
          'Stage plans, active focus, risks, and milestones with progressive docking.',
      icon: Icons.event_note_outlined,
      builder: (_) => const AdaptivePlanningDeskDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.showcasePatterns,
      title: 'Adaptive Release Lab',
      description:
          'Stage releases, readiness, blockers, and rollout logs with progressive docking.',
      icon: Icons.rocket_launch_outlined,
      builder: (_) => const AdaptiveReleaseLabDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.showcasePatterns,
      title: 'Adaptive Approval Desk',
      description:
          'Stage approvals, active proposals, criteria, and decision history with progressive docking.',
      icon: Icons.approval_outlined,
      builder: (_) => const AdaptiveApprovalDeskDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.coreEngine,
      title: 'Responsive Values',
      description: 'Semantic breakpoints, fluid spacing, and typography.',
      icon: Icons.space_dashboard_outlined,
      builder: (_) => const ResponsiveValuesDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.coreEngine,
      title: 'Height-aware Layouts',
      description:
          'Resolve adaptive rules from vertical space as well as width.',
      icon: Icons.height_outlined,
      builder: (_) => const HeightAwareLayoutsDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.coreEngine,
      title: 'Container Layouts',
      description: 'Parent-width aware layouts using container queries.',
      icon: Icons.crop_16_9_outlined,
      builder: (_) => const ContainerLayoutsDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.corePrimitives,
      title: 'Adaptive Container',
      description: 'Semantic slots and container-aware widget switching.',
      icon: Icons.view_agenda_outlined,
      builder: (_) => const AdaptiveContainerDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.coreEngine,
      title: 'Animated Layouts',
      description:
          'Breakpoint transitions driven by AnimatedResponsiveLayoutBuilder.',
      icon: Icons.animation_outlined,
      builder: (_) => const AnimatedLayoutsDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.corePrimitives,
      title: 'Adaptive Cluster',
      description: 'One child list that can stack, wrap, or line up inline.',
      icon: Icons.widgets_outlined,
      builder: (_) => const AdaptiveClusterDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.corePrimitives,
      title: 'Adaptive Action Bar',
      description: 'Priority-aware toolbars that overflow gracefully.',
      icon: Icons.more_horiz,
      builder: (_) => const AdaptiveActionBarDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.corePrimitives,
      title: 'Auto Grid',
      description: 'Column counts derived from the available width.',
      icon: Icons.grid_view_outlined,
      builder: (_) => const AutoGridDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.corePrimitives,
      title: 'Reorderable Grid',
      description: 'Adaptive dashboard cards with drag-and-drop reordering.',
      icon: Icons.view_quilt_outlined,
      builder: (_) => const ReorderableGridDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.corePrimitives,
      title: 'Adaptive Pane',
      description: 'Master-detail layouts that stack or split by size.',
      icon: Icons.splitscreen_outlined,
      builder: (_) => const AdaptivePaneDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.corePrimitives,
      title: 'Priority Layout',
      description: 'Primary-first layouts with collapsible supporting context.',
      icon: Icons.low_priority_outlined,
      builder: (_) => const AdaptivePriorityDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.corePrimitives,
      title: 'Adaptive Inspector',
      description: 'Dock a sidebar inline or open it as a modal inspector.',
      icon: Icons.tune_outlined,
      builder: (_) => const AdaptiveInspectorDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.corePrimitives,
      title: 'Adaptive Form',
      description:
          'Section cards on wide screens and a stepper on compact ones.',
      icon: Icons.rule_folder_outlined,
      builder: (_) => const AdaptiveFormDemoPage(),
    ),
    _DemoEntry(
      category: _DemoCategory.coreEngine,
      title: 'Debug Overlay',
      description: 'Inspect active breakpoint and container state live.',
      icon: Icons.bug_report_outlined,
      builder: (_) => const DebugOverlayDemoPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Media Break Points Demo')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Package feature catalog',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Core features are grouped first. Showcase patterns stay in the catalog, '
                'but they are examples of composition rather than the package’s main API story. '
                'Import showcase entries from package:media_break_points/patterns.dart.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              for (final category in _DemoCategory.values) ...[
                _DemoCategorySection(
                  category: category,
                  entries: [
                    for (final entry in _entries)
                      if (entry.category == category) entry,
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

enum _DemoCategory {
  coreEngine,
  corePrimitives,
  coreShellsAndSurfaces,
  showcasePatterns,
}

extension on _DemoCategory {
  String get title {
    return switch (this) {
      _DemoCategory.coreEngine => 'Core Engine',
      _DemoCategory.corePrimitives => 'Core Primitives',
      _DemoCategory.coreShellsAndSurfaces => 'Core Shells And Surfaces',
      _DemoCategory.showcasePatterns => 'Showcase Patterns',
    };
  }

  String get description {
    return switch (this) {
      _DemoCategory.coreEngine =>
        'Breakpoint data, responsive values, container queries, animation helpers, and debugging tools.',
      _DemoCategory.corePrimitives =>
        'Reusable spatial building blocks that introduce real layout behavior.',
      _DemoCategory.coreShellsAndSurfaces =>
        'The small set of high-value shells and content surfaces that form the main package story.',
      _DemoCategory.showcasePatterns =>
        'Possible product-shaped compositions built from the core primitives. Import them from package:media_break_points/patterns.dart.',
    };
  }

  bool get isCore => this != _DemoCategory.showcasePatterns;

  String get badgeLabel => isCore ? 'Core' : 'Showcase';
}

class _DemoEntry {
  final _DemoCategory category;
  final String title;
  final String description;
  final IconData icon;
  final WidgetBuilder builder;

  const _DemoEntry({
    required this.category,
    required this.title,
    required this.description,
    required this.icon,
    required this.builder,
  });
}

class _DemoCategorySection extends StatelessWidget {
  final _DemoCategory category;
  final List<_DemoEntry> entries;

  const _DemoCategorySection({required this.category, required this.entries});

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(category.title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          category.description,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),
        AutoResponsiveGrid(
          minItemWidth: 260,
          columnSpacing: 16,
          rowSpacing: 16,
          children: [for (final entry in entries) _DemoEntryCard(entry: entry)],
        ),
      ],
    );
  }
}

class _DemoEntryCard extends StatelessWidget {
  final _DemoEntry entry;

  const _DemoEntryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute<void>(builder: entry.builder));
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: entry.category.isCore
                      ? Theme.of(context).colorScheme.secondaryContainer
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: Text(
                    entry.category.badgeLabel,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Icon(entry.icon, size: 28),
              const SizedBox(height: 16),
              Text(entry.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(entry.description),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureDemoPage extends StatelessWidget {
  final String title;
  final String description;
  final Widget child;

  const _FeatureDemoPage({
    required this.title,
    required this.description,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(description, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 20),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class AdaptiveScaffoldDemoPage extends StatefulWidget {
  const AdaptiveScaffoldDemoPage({super.key});

  @override
  State<AdaptiveScaffoldDemoPage> createState() =>
      _AdaptiveScaffoldDemoPageState();
}

class _AdaptiveScaffoldDemoPageState extends State<AdaptiveScaffoldDemoPage> {
  static const _destinations = [
    AdaptiveScaffoldDestination(
      icon: Icon(Icons.dashboard_outlined),
      selectedIcon: Icon(Icons.dashboard),
      label: 'Dashboard',
    ),
    AdaptiveScaffoldDestination(
      icon: Icon(Icons.auto_awesome_mosaic_outlined),
      selectedIcon: Icon(Icons.auto_awesome_mosaic),
      label: 'Workspace',
    ),
    AdaptiveScaffoldDestination(
      icon: Icon(Icons.tune_outlined),
      selectedIcon: Icon(Icons.tune),
      label: 'Settings',
    ),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      animateTransitions: true,
      minimumRailHeight: AdaptiveHeight.medium,
      minimumDrawerHeight: AdaptiveHeight.medium,
      appBar: AppBar(title: Text(_pageTitle(_selectedIndex))),
      selectedIndex: _selectedIndex,
      onSelectedIndexChanged: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      destinations: _destinations,
      navigationHeader: const _NavigationHeader(),
      navigationFooter: const _NavigationFooter(),
      body: ResponsiveDebugOverlay(
        label: 'screen',
        child: IndexedStack(
          index: _selectedIndex,
          children: const [DashboardPage(), WorkspacePage(), SettingsPage()],
        ),
      ),
    );
  }

  String _pageTitle(int index) {
    return switch (index) {
      0 => 'Adaptive Dashboard',
      1 => 'Workspace Layouts',
      _ => 'Settings Form',
    };
  }
}

class AdaptiveWorkspaceShellDemoPage extends StatefulWidget {
  const AdaptiveWorkspaceShellDemoPage({super.key});

  @override
  State<AdaptiveWorkspaceShellDemoPage> createState() =>
      _AdaptiveWorkspaceShellDemoPageState();
}

class _AdaptiveWorkspaceShellDemoPageState
    extends State<AdaptiveWorkspaceShellDemoPage> {
  static const _destinations = [
    AdaptiveScaffoldDestination(
      icon: Icon(Icons.space_dashboard_outlined),
      selectedIcon: Icon(Icons.space_dashboard),
      label: 'Overview',
    ),
    AdaptiveScaffoldDestination(
      icon: Icon(Icons.fact_check_outlined),
      selectedIcon: Icon(Icons.fact_check),
      label: 'Review',
    ),
    AdaptiveScaffoldDestination(
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  static const _actions = [
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
      icon: Icon(Icons.person_add_alt_1_outlined),
      label: 'Invite',
      priority: 2,
      variant: AdaptiveActionVariant.outlined,
    ),
    AdaptiveActionBarAction(
      icon: Icon(Icons.file_download_outlined),
      label: 'Export',
      priority: 1,
      variant: AdaptiveActionVariant.text,
    ),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AdaptiveWorkspaceShell(
      title: _titleForIndex(_selectedIndex),
      description: _descriptionForIndex(_selectedIndex),
      appBarTitle: 'Adaptive Workspace Shell',
      destinations: _destinations,
      selectedIndex: _selectedIndex,
      onSelectedIndexChanged: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      navigationHeader: const _NavigationHeader(),
      navigationFooter: const _NavigationFooter(),
      actions: _actions,
      minimumRailHeight: AdaptiveHeight.medium,
      minimumDrawerHeight: AdaptiveHeight.medium,
      minimumInspectorDockedHeight: AdaptiveHeight.medium,
      inspectorTitle: 'Workspace inspector',
      inspectorDescription:
          'Track adaptive state, workflow pressure, and pinned modules.',
      inspectorLeading: const Icon(Icons.tune_outlined),
      content: ResponsiveDebugOverlay(
        label: 'workspace-shell',
        useContainerConstraints: true,
        child: _WorkspaceShellContent(selectedIndex: _selectedIndex),
      ),
      inspector: _WorkspaceShellInspector(selectedIndex: _selectedIndex),
    );
  }

  String _titleForIndex(int index) {
    return switch (index) {
      0 => 'Workspace overview',
      1 => 'Review queue',
      _ => 'Workspace settings',
    };
  }

  String _descriptionForIndex(int index) {
    return switch (index) {
      0 =>
        'One screen-level primitive coordinates navigation, action priority, '
            'and inspector behavior.',
      1 =>
        'Review mode keeps active tasks visible while supporting notes move '
            'inline or modal based on local space.',
      _ =>
        'Settings can share the same shell chrome without re-implementing '
            'navigation or inspector logic.',
    };
  }
}

class AdaptiveSectionsDemoPage extends StatelessWidget {
  const AdaptiveSectionsDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureDemoPage(
      title: 'Adaptive Sections',
      description:
          'Switch between compact section chips and a docked sidebar when '
          'settings or workspace subsections need to stay navigable.',
      child: _AdaptiveSectionsShowcase(),
    );
  }
}

class AdaptiveDataViewDemoPage extends StatelessWidget {
  const AdaptiveDataViewDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureDemoPage(
      title: 'Adaptive Data View',
      description:
          'Use cards for narrow spaces and promote the same records into a '
          'table when larger containers can support scanning.',
      child: _AdaptiveDataViewShowcase(),
    );
  }
}

class AdaptiveBoardDemoPage extends StatelessWidget {
  const AdaptiveBoardDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureDemoPage(
      title: 'Adaptive Board',
      description:
          'Use one board model that can stack vertically on compact space and '
          'spread into horizontal workflow lanes on larger containers.',
      child: _AdaptiveBoardShowcase(),
    );
  }
}

class AdaptiveTimelineDemoPage extends StatelessWidget {
  const AdaptiveTimelineDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureDemoPage(
      title: 'Adaptive Timeline',
      description:
          'Use one milestone model that can stack on compact space and spread '
          'into a horizontal roadmap on larger containers.',
      child: _AdaptiveTimelineShowcase(),
    );
  }
}

class AdaptiveComparisonDemoPage extends StatelessWidget {
  const AdaptiveComparisonDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureDemoPage(
      title: 'Adaptive Comparison',
      description:
          'Compare rollout tiers or product variants with one compact selector '
          'and a larger side-by-side mode.',
      child: _AdaptiveComparisonShowcase(),
    );
  }
}

class AdaptiveDiffViewDemoPage extends StatelessWidget {
  const AdaptiveDiffViewDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureDemoPage(
      title: 'Adaptive Diff View',
      description:
          'Use one fixed two-pane review surface that toggles between current '
          'and proposed states on compact layouts and shows both side by side '
          'on larger containers.',
      child: _AdaptiveDiffViewShowcase(),
    );
  }
}

class AdaptiveScheduleDemoPage extends StatelessWidget {
  const AdaptiveScheduleDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureDemoPage(
      title: 'Adaptive Schedule',
      description:
          'Use one day-grouped schedule model that can stack into an agenda or '
          'spread into side-by-side day columns.',
      child: _AdaptiveScheduleShowcase(),
    );
  }
}

class AdaptiveCalendarDemoPage extends StatelessWidget {
  const AdaptiveCalendarDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureDemoPage(
      title: 'Adaptive Calendar',
      description:
          'Use one day model that can show a stacked agenda on compact space '
          'or a multi-column day grid on larger containers.',
      child: _AdaptiveCalendarShowcase(),
    );
  }
}

class AdaptiveDeckDemoPage extends StatelessWidget {
  const AdaptiveDeckDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureDemoPage(
      title: 'Adaptive Deck',
      description:
          'Use one card model that can page through focused content on '
          'compact layouts and expand into a responsive deck grid on larger '
          'containers.',
      child: _AdaptiveDeckShowcase(),
    );
  }
}

class AdaptiveGalleryDemoPage extends StatelessWidget {
  const AdaptiveGalleryDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureDemoPage(
      title: 'Adaptive Gallery',
      description:
          'Use one preview-heavy model that can page through showcase cards '
          'on compact layouts and switch to a selected spotlight with a '
          'selector list on larger containers.',
      child: _AdaptiveGalleryShowcase(),
    );
  }
}

class AdaptiveFilterLayoutDemoPage extends StatelessWidget {
  const AdaptiveFilterLayoutDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureDemoPage(
      title: 'Adaptive Filter Layout',
      description:
          'Use one search-and-browse surface that keeps results visible on '
          'compact layouts and docks filters inline when wider containers can '
          'support side-by-side scanning.',
      child: _AdaptiveFilterLayoutShowcase(),
    );
  }
}

class AdaptiveResultBrowserDemoPage extends StatelessWidget {
  const AdaptiveResultBrowserDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureDemoPage(
      title: 'Adaptive Result Browser',
      description:
          'Use one result list that can open details in a modal sheet on '
          'compact layouts and dock them inline on larger containers.',
      child: _AdaptiveResultBrowserShowcase(),
    );
  }
}

class AdaptiveExplorerDemoPage extends StatelessWidget {
  const AdaptiveExplorerDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureDemoPage(
      title: 'Adaptive Explorer',
      description:
          'Use one compound browsing surface that keeps filters and details '
          'modal-first on compact layouts and docks all three regions inline '
          'on larger containers.',
      child: _AdaptiveExplorerShowcase(),
    );
  }
}

class AdaptiveDocumentViewDemoPage extends StatelessWidget {
  const AdaptiveDocumentViewDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureDemoPage(
      title: 'Adaptive Document View',
      description:
          'Use one long-form reading surface that keeps the document primary '
          'on compact layouts and docks a navigable outline on larger '
          'containers.',
      child: _AdaptiveDocumentViewShowcase(),
    );
  }
}

class AdaptiveWorkbenchDemoPage extends StatelessWidget {
  const AdaptiveWorkbenchDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureDemoPage(
      title: 'Adaptive Workbench',
      description:
          'Use one studio-style surface that keeps the canvas primary on '
          'compact layouts, docks the library at medium widths, and adds a '
          'docked inspector on expanded containers.',
      child: _AdaptiveWorkbenchShowcase(),
    );
  }
}

class AdaptiveReviewDeskDemoPage extends StatelessWidget {
  const AdaptiveReviewDeskDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureDemoPage(
      title: 'Adaptive Review Desk',
      description:
          'Use one review workspace that keeps the active review surface '
          'primary on compact layouts, docks the queue at medium widths, and '
          'adds a docked decision panel on expanded containers.',
      child: _AdaptiveReviewDeskShowcase(),
    );
  }
}

class AdaptiveConversationDeskDemoPage extends StatelessWidget {
  const AdaptiveConversationDeskDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureDemoPage(
      title: 'Adaptive Conversation Desk',
      description:
          'Use one messaging workspace that keeps the active thread primary '
          'on compact layouts, docks the conversation list at medium widths, '
          'and adds a docked context panel on expanded containers.',
      child: _AdaptiveConversationDeskShowcase(),
    );
  }
}

class AdaptiveComposerDemoPage extends StatelessWidget {
  const AdaptiveComposerDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureDemoPage(
      title: 'Adaptive Composer',
      description:
          'Use one composition workspace that keeps editing primary on compact '
          'layouts, splits editor and preview at medium widths, and docks '
          'settings on expanded containers.',
      child: _AdaptiveComposerShowcase(),
    );
  }
}

class AdaptivePresentationDeskDemoPage extends StatelessWidget {
  const AdaptivePresentationDeskDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureDemoPage(
      title: 'Adaptive Presentation Desk',
      description:
          'Use one presentation workspace that keeps the active stage primary '
          'on compact layouts, docks the slide list at medium widths, and '
          'adds speaker notes on expanded containers.',
      child: _AdaptivePresentationDeskShowcase(),
    );
  }
}

class AdaptiveControlCenterDemoPage extends StatelessWidget {
  const AdaptiveControlCenterDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureDemoPage(
      title: 'Adaptive Control Center',
      description:
          'Use one dense operations surface that keeps the dashboard primary '
          'on compact layouts, docks a service sidebar at medium widths, adds '
          'insights on expanded widths, and only docks activity on tall '
          'expanded containers.',
      child: _AdaptiveControlCenterShowcase(),
    );
  }
}

class AdaptiveIncidentDeskDemoPage extends StatelessWidget {
  const AdaptiveIncidentDeskDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureDemoPage(
      title: 'Adaptive Incident Desk',
      description:
          'Use one selected-item operations surface that keeps the active '
          'incident detail primary on compact layouts, docks the incident '
          'list at medium widths, adds responder context on expanded widths, '
          'and docks the timeline only when there is enough height too.',
      child: _AdaptiveIncidentDeskShowcase(),
    );
  }
}

class AdaptiveMetricsLabDemoPage extends StatelessWidget {
  const AdaptiveMetricsLabDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureDemoPage(
      title: 'Adaptive Metrics Lab',
      description:
          'Use one analytics surface that keeps the active chart primary on '
          'compact layouts, docks saved queries at medium widths, adds '
          'annotations on expanded widths, and docks query history only when '
          'there is enough height too.',
      child: _AdaptiveMetricsLabShowcase(),
    );
  }
}

class AdaptiveExperimentLabDemoPage extends StatelessWidget {
  const AdaptiveExperimentLabDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureDemoPage(
      title: 'Adaptive Experiment Lab',
      description:
          'Use one experimentation surface that keeps the active experiment '
          'focus primary on compact layouts, docks experiment selection at '
          'medium widths, adds evidence on expanded widths, and docks the '
          'decision log only when there is enough height too.',
      child: _AdaptiveExperimentLabShowcase(),
    );
  }
}

class AdaptivePlanningDeskDemoPage extends StatelessWidget {
  const AdaptivePlanningDeskDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureDemoPage(
      title: 'Adaptive Planning Desk',
      description:
          'Use one planning surface that keeps the active plan focus primary '
          'on compact layouts, docks plan selection at medium widths, adds '
          'risks on expanded widths, and docks milestones only when there is '
          'enough height too.',
      child: _AdaptivePlanningDeskShowcase(),
    );
  }
}

class AdaptiveReleaseLabDemoPage extends StatelessWidget {
  const AdaptiveReleaseLabDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureDemoPage(
      title: 'Adaptive Release Lab',
      description:
          'Use one release surface that keeps the active readiness view '
          'primary on compact layouts, docks release selection at medium '
          'widths, adds blockers on expanded widths, and docks rollout logs '
          'only when there is enough height too.',
      child: _AdaptiveReleaseLabShowcase(),
    );
  }
}

class AdaptiveApprovalDeskDemoPage extends StatelessWidget {
  const AdaptiveApprovalDeskDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureDemoPage(
      title: 'Adaptive Approval Desk',
      description:
          'Use one approval surface that keeps the active proposal primary '
          'on compact layouts, docks approval selection at medium widths, '
          'adds criteria on expanded widths, and docks decision history only '
          'when there is enough height too.',
      child: _AdaptiveApprovalDeskShowcase(),
    );
  }
}

class ResponsiveValuesDemoPage extends StatelessWidget {
  const ResponsiveValuesDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final headlineStyle = ResponsiveTextStyle.fluid(
      context,
      compact: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
      medium: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
      expanded: const TextStyle(fontSize: 44, fontWeight: FontWeight.w700),
    );

    return _FeatureDemoPage(
      title: 'Responsive Values',
      description:
          'Semantic responsive values and fluid typography resolve directly '
          'from the current breakpoint data.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ship one layout system, not three apps.', style: headlineStyle),
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
          const SizedBox(height: 20),
          const _AdaptiveHero(),
        ],
      ),
    );
  }
}

class HeightAwareLayoutsDemoPage extends StatelessWidget {
  const HeightAwareLayoutsDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureDemoPage(
      title: 'Height-aware Layouts',
      description:
          'These panels hold width steady and only change local height, so '
          'you can see vertical semantics drive density and copy.',
      child: _HeightAwareLayoutsShowcase(),
    );
  }
}

class ContainerLayoutsDemoPage extends StatelessWidget {
  const ContainerLayoutsDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _FeatureDemoPage(
      title: 'Container Layouts',
      description:
          'These surfaces respond to parent width instead of the full screen, '
          'so nested panes keep behaving intentionally.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 380,
              child: ResponsiveDebugOverlay(
                label: 'container',
                useContainerConstraints: true,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: const _AdaptiveHero(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ResponsiveContainerBuilder(
            builder: (context, data) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    data.isCompact
                        ? 'Compact container: stack and collapse supporting content.'
                        : 'Expanded container: split content and increase density.',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AnimatedLayoutsDemoPage extends StatelessWidget {
  const AnimatedLayoutsDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureDemoPage(
      title: 'Animated Layouts',
      description:
          'Drive one local width through several surfaces to inspect how the '
          'builder, semantic slots, and animated primitives morph between '
          'compact, medium, and expanded states.',
      child: _AnimatedLayoutsShowcase(),
    );
  }
}

enum _AnimatedDemoStage { compact, medium, expanded }

extension on _AnimatedDemoStage {
  String get label {
    return switch (this) {
      _AnimatedDemoStage.compact => 'Compact',
      _AnimatedDemoStage.medium => 'Medium',
      _AnimatedDemoStage.expanded => 'Expanded',
    };
  }

  double get width {
    return switch (this) {
      _AnimatedDemoStage.compact => 320,
      _AnimatedDemoStage.medium => 560,
      _AnimatedDemoStage.expanded => 840,
    };
  }

  String get caption {
    return switch (this) {
      _AnimatedDemoStage.compact => 'Stacked content and shorter line lengths.',
      _AnimatedDemoStage.medium =>
        'Split panes, denser summaries, and more lateral space.',
      _AnimatedDemoStage.expanded =>
        'Dashboard-style layouts with room for supporting context.',
    };
  }

  IconData get icon {
    return switch (this) {
      _AnimatedDemoStage.compact => Icons.smartphone_outlined,
      _AnimatedDemoStage.medium => Icons.tablet_mac_outlined,
      _AnimatedDemoStage.expanded => Icons.desktop_windows_outlined,
    };
  }
}

class _AnimatedLayoutsShowcase extends StatefulWidget {
  const _AnimatedLayoutsShowcase();

  @override
  State<_AnimatedLayoutsShowcase> createState() =>
      _AnimatedLayoutsShowcaseState();
}

class _AnimatedLayoutsShowcaseState extends State<_AnimatedLayoutsShowcase> {
  _AnimatedDemoStage _stage = _AnimatedDemoStage.compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Motion playground',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  'Animate one local width through the same container-aware '
                  'surfaces. Each example resolves from parent constraints, '
                  'so the transition is easy to inspect without resizing the '
                  'whole app window.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SegmentedButton<_AnimatedDemoStage>(
                    showSelectedIcon: false,
                    segments: [
                      for (final stage in _AnimatedDemoStage.values)
                        ButtonSegment<_AnimatedDemoStage>(
                          value: stage,
                          icon: Icon(stage.icon),
                          label: Text(stage.label),
                        ),
                    ],
                    selected: {_stage},
                    onSelectionChanged: (selection) {
                      setState(() {
                        _stage = selection.first;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Chip(
                      avatar: Icon(_stage.icon, size: 18),
                      label: Text('Target width ${_stage.width.toInt()} px'),
                    ),
                    Text(
                      _stage.caption,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        _AnimatedExampleSection(
          title: 'Breakpoint Morph',
          description:
              'Use AnimatedResponsiveLayoutBuilder when the breakpoint itself '
              'should drive a custom transition. This version fades and slides '
              'between stacked, split, and board-like compositions.',
          child: _AnimatedWidthStageSurface(
            stage: _stage,
            label: 'builder',
            minHeight: 240,
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: AnimatedResponsiveLayoutBuilder(
                  useContainerConstraints: true,
                  animateOnAdaptiveSize: true,
                  duration: const Duration(milliseconds: 320),
                  transitionBuilder: _slideFadeTransition,
                  xs: (context, _) => const _CompactInsights(),
                  md: (context, _) => const _SplitInsights(),
                  xl: (context, _) => const _ExpandedInsights(),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        _AnimatedExampleSection(
          title: 'Semantic Slot Motion',
          description:
              'AdaptiveContainer can animate between semantic slots, which is '
              'useful when the shape of the content changes more than the '
              'breakpoint labels do.',
          child: _AnimatedWidthStageSurface(
            stage: _stage,
            label: 'container',
            minHeight: 280,
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: AdaptiveContainer(
                  enableAnimation: true,
                  animationDuration: 320,
                  animateOnAdaptiveSize: true,
                  useContainerConstraints: true,
                  transitionBuilder: _scaleFadeTransition,
                  compact: const AdaptiveSlot(
                    builder: _buildCompactMotionContainer,
                  ),
                  medium: const AdaptiveSlot(
                    builder: _buildMediumMotionContainer,
                  ),
                  expanded: const AdaptiveSlot(
                    builder: _buildExpandedMotionContainer,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        _AnimatedExampleSection(
          title: 'Primitive Choreography',
          description:
              'Existing core primitives already animate. This card combines '
              'AdaptiveCluster and AdaptivePane so you can watch both the '
              'layout grouping and the supporting pane react together.',
          child: _AnimatedWidthStageSurface(
            stage: _stage,
            label: 'primitives',
            minHeight: 360,
            child: const _AnimatedPrimitivePreview(),
          ),
        ),
        const SizedBox(height: 20),
        _AnimatedExampleSection(
          title: 'Section Navigation Morph',
          description:
              'AdaptiveSections uses AnimatedSize and AnimatedSwitcher '
              'internally. Width changes move it between compact chips and a '
              'sidebar without rebuilding a separate settings screen.',
          child: _AnimatedWidthStageSurface(
            stage: _stage,
            label: 'sections',
            minHeight: 360,
            child: const _AnimatedSectionsPreview(),
          ),
        ),
      ],
    );
  }
}

class _AnimatedExampleSection extends StatelessWidget {
  final String title;
  final String description;
  final Widget child;

  const _AnimatedExampleSection({
    required this.title,
    required this.description,
    required this.child,
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
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(description, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 14),
        child,
      ],
    );
  }
}

class _AnimatedWidthStageSurface extends StatelessWidget {
  final _AnimatedDemoStage stage;
  final String label;
  final double minHeight;
  final Widget child;

  const _AnimatedWidthStageSurface({
    required this.stage,
    required this.label,
    required this.minHeight,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final targetWidth = math.min(stage.width, constraints.maxWidth);

        return Align(
          alignment: Alignment.centerLeft,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 360),
            curve: Curves.easeInOutCubicEmphasized,
            width: targetWidth,
            constraints: BoxConstraints(minHeight: minHeight),
            child: ResponsiveDebugOverlay(
              label: label,
              useContainerConstraints: true,
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class AdaptiveContainerDemoPage extends StatelessWidget {
  const AdaptiveContainerDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureDemoPage(
      title: 'Adaptive Container',
      description:
          'AdaptiveContainer now resolves semantic slots and local container '
          'breakpoints without requiring a custom builder.',
      child: _AdaptiveContainerShowcase(),
    );
  }
}

class AdaptiveClusterDemoPage extends StatelessWidget {
  const AdaptiveClusterDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureDemoPage(
      title: 'Adaptive Cluster',
      description:
          'Use one child list and let the cluster stack, wrap, or line up '
          'inline as the available width changes.',
      child: _AdaptiveClusterShowcase(),
    );
  }
}

class AdaptiveActionBarDemoPage extends StatelessWidget {
  const AdaptiveActionBarDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _FeatureDemoPage(
      title: 'Adaptive Action Bar',
      description:
          'Priority and pinning decide which actions stay inline as space '
          'tightens.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _ActionBarDemoCard(),
          SizedBox(height: 20),
          SizedBox(
            width: 280,
            child: _ActionBarDemoCard(label: 'narrow-actions'),
          ),
        ],
      ),
    );
  }
}

class AutoGridDemoPage extends StatelessWidget {
  const AutoGridDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _FeatureDemoPage(
      title: 'Auto Grid',
      description:
          'AutoResponsiveGrid computes column count from available width '
          'without explicit spans.',
      child: _MetricGridShowcase(reorderable: false),
    );
  }
}

class ReorderableGridDemoPage extends StatelessWidget {
  const ReorderableGridDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureDemoPage(
      title: 'Reorderable Grid',
      description:
          'Long-press and drag cards to change the dashboard order while the '
          'grid still adapts to width.',
      child: _MetricGridShowcase(reorderable: true),
    );
  }
}

class AdaptivePaneDemoPage extends StatelessWidget {
  const AdaptivePaneDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _FeatureDemoPage(
      title: 'Adaptive Pane',
      description:
          'AdaptivePane stacks on compact layouts and splits into a master-'
          'detail arrangement from medium widths.',
      child: Builder(
        builder: (context) {
          final demoHeight = context.responsive<double>(
            compact: 340,
            medium: 280,
            expanded: 280,
          )!;

          return SizedBox(
            height: demoHeight,
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: const AdaptivePane(
                  primary: _WorkspaceCopy(),
                  secondary: _WorkspaceSummaryCard(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AdaptivePriorityDemoPage extends StatelessWidget {
  const AdaptivePriorityDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureDemoPage(
      title: 'Adaptive Priority Layout',
      description:
          'Primary content stays visible while supporting context collapses '
          'into a disclosure on compact containers.',
      child: _PriorityLayoutShowcase(),
    );
  }
}

class AdaptiveFormDemoPage extends StatelessWidget {
  const AdaptiveFormDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureDemoPage(
      title: 'Adaptive Form',
      description:
          'Section cards on larger widths, guided stepper flow on compact '
          'containers.',
      child: _AdaptiveFormShowcase(),
    );
  }
}

class AdaptiveInspectorDemoPage extends StatelessWidget {
  const AdaptiveInspectorDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureDemoPage(
      title: 'Adaptive Inspector',
      description:
          'Use a docked inspector when there is room, and fall back to a '
          'modal panel on compact layouts.',
      child: _AdaptiveInspectorShowcase(),
    );
  }
}

class DebugOverlayDemoPage extends StatelessWidget {
  const DebugOverlayDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _FeatureDemoPage(
      title: 'Debug Overlay',
      description:
          'Inspect the active breakpoint and container state directly over the '
          'widgets you are tuning.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResponsiveDebugOverlay(
            label: 'screen',
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Screen overlay active: resize the app window to inspect '
                  'breakpoint and semantic size changes.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 320,
              child: ResponsiveDebugOverlay(
                label: 'card',
                useContainerConstraints: true,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'This overlay resolves from the card width, not the full screen.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
