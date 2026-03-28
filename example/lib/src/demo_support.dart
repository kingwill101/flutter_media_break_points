part of '../main.dart';

class _DashboardMetricData {
  final String id;
  final String title;
  final String value;
  final String detail;
  final Color color;

  const _DashboardMetricData({
    required this.id,
    required this.title,
    required this.value,
    required this.detail,
    required this.color,
  });
}

class _MetricLabQuery {
  final String title;
  final String summary;
  final String status;
  final String value;
  final String trend;
  final Color accent;
  final List<String> notes;

  const _MetricLabQuery({
    required this.title,
    required this.summary,
    required this.status,
    required this.value,
    required this.trend,
    required this.accent,
    required this.notes,
  });
}

class _ExperimentLabItem {
  final String title;
  final String summary;
  final String status;
  final String primaryMetric;
  final String secondaryMetric;
  final Color accent;
  final List<String> evidence;

  const _ExperimentLabItem({
    required this.title,
    required this.summary,
    required this.status,
    required this.primaryMetric,
    required this.secondaryMetric,
    required this.accent,
    required this.evidence,
  });
}

class _PlanningDeskItem {
  final String title;
  final String summary;
  final String status;
  final String horizon;
  final String owner;
  final Color accent;
  final List<String> checkpoints;

  const _PlanningDeskItem({
    required this.title,
    required this.summary,
    required this.status,
    required this.horizon,
    required this.owner,
    required this.accent,
    required this.checkpoints,
  });
}

class _ReleaseLabItem {
  final String title;
  final String summary;
  final String status;
  final String readiness;
  final String owner;
  final Color accent;
  final List<String> gates;

  const _ReleaseLabItem({
    required this.title,
    required this.summary,
    required this.status,
    required this.readiness,
    required this.owner,
    required this.accent,
    required this.gates,
  });
}

class _ApprovalDeskItem {
  final String title;
  final String summary;
  final String status;
  final String stage;
  final String approver;
  final Color accent;
  final List<String> criteria;
  final List<String> history;

  const _ApprovalDeskItem({
    required this.title,
    required this.summary,
    required this.status,
    required this.stage,
    required this.approver,
    required this.accent,
    required this.criteria,
    required this.history,
  });
}

class _CompactInsights extends StatelessWidget {
  const _CompactInsights();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Compact insight stack',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 16),
        _InsightChip(
          title: 'Review loop',
          body: 'Feedback arrives inline with the main content.',
        ),
        SizedBox(height: 12),
        _InsightChip(
          title: 'Navigation',
          body: 'Primary actions stay close to the thumb zone.',
        ),
      ],
    );
  }
}

class _SplitInsights extends StatelessWidget {
  const _SplitInsights();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _InsightChip(
            title: 'Review loop',
            body: 'A wider pane can hold notes and live previews together.',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _InsightChip(
            title: 'Navigation',
            body:
                'The shell handles wayfinding while the pane focuses on work.',
          ),
        ),
      ],
    );
  }
}

class _ExpandedInsights extends StatelessWidget {
  const _ExpandedInsights();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Expanded insight board',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Expanded(
              flex: 2,
              child: _InsightChip(
                title: 'Review loop',
                body:
                    'A wider surface can keep notes, previews, and the next '
                    'action visible at the same time.',
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                children: [
                  _InsightChip(
                    title: 'Navigation',
                    body:
                        'Supporting chrome can move further away while the '
                        'main work stays scannable.',
                  ),
                  SizedBox(height: 12),
                  _InsightChip(
                    title: 'Density',
                    body:
                        'Expanded layouts can turn extra width into summary '
                        'cards instead of dead space.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Widget _slideFadeTransition(Widget child, Animation<double> animation) {
  final curved = CurvedAnimation(
    parent: animation,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );

  return FadeTransition(
    opacity: curved,
    child: SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.06, 0.02),
        end: Offset.zero,
      ).animate(curved),
      child: child,
    ),
  );
}

Widget _scaleFadeTransition(Widget child, Animation<double> animation) {
  final curved = CurvedAnimation(
    parent: animation,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );

  return FadeTransition(
    opacity: curved,
    child: ScaleTransition(
      scale: Tween<double>(begin: 0.97, end: 1).animate(curved),
      child: child,
    ),
  );
}

Widget _buildCompactMotionContainer(BuildContext context) {
  return const DecoratedBox(
    decoration: BoxDecoration(
      color: Color(0xFFD9F0E4),
      borderRadius: BorderRadius.all(Radius.circular(24)),
    ),
    child: Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Compact slot',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 10),
          Text(
            'Lead with one message, keep the action close, and collapse the '
            'rest into lightweight summaries.',
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(label: Text('Focused')),
              Chip(label: Text('Stacked')),
              Chip(label: Text('Thumb-ready')),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildMediumMotionContainer(BuildContext context) {
  return DecoratedBox(
    decoration: BoxDecoration(
      color: const Color(0xFFDCEBFF),
      borderRadius: BorderRadius.circular(24),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Expanded(
            child: _MotionSummaryCard(
              title: 'Medium slot',
              body:
                  'Use the extra width for one supporting column without '
                  'turning the surface into a dashboard too early.',
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              children: [
                _MotionMetricStrip(label: 'Pinned modules', value: '12'),
                SizedBox(height: 12),
                _MotionMetricStrip(label: 'Review depth', value: '3 screens'),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildExpandedMotionContainer(BuildContext context) {
  return DecoratedBox(
    decoration: BoxDecoration(
      color: const Color(0xFFFCE7C8),
      borderRadius: BorderRadius.circular(24),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Expanded(
            flex: 2,
            child: _MotionSummaryCard(
              title: 'Expanded slot',
              body:
                  'Turn surplus width into context: a hero message, compact '
                  'metrics, and a secondary summary lane can all live in the '
                  'same animated surface.',
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              children: [
                _MotionMetricStrip(label: 'Cards in view', value: '6'),
                SizedBox(height: 12),
                _MotionMetricStrip(label: 'Summary lanes', value: '2'),
                SizedBox(height: 12),
                _MotionMetricStrip(label: 'Adaptive states', value: '3'),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _MotionSummaryCard extends StatelessWidget {
  final String title;
  final String body;

  const _MotionSummaryCard({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
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
            Text(body),
          ],
        ),
      ),
    );
  }
}

class _MotionMetricStrip extends StatelessWidget {
  final String label;
  final String value;

  const _MotionMetricStrip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
            ),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedPrimitivePreview extends StatelessWidget {
  const _AnimatedPrimitivePreview();

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AdaptiveCluster',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            AdaptiveCluster(
              useContainerConstraints: true,
              compactLayout: AdaptiveClusterLayout.column,
              mediumLayout: AdaptiveClusterLayout.wrap,
              expandedLayout: AdaptiveClusterLayout.row,
              children: const [
                _MotionToken(label: 'Action group', color: Color(0xFFD9F0E4)),
                _MotionToken(
                  label: 'Inspector summary',
                  color: Color(0xFFDCEBFF),
                ),
                _MotionToken(
                  label: 'Release checklist',
                  color: Color(0xFFFCE7C8),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'AdaptivePane',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            AdaptivePane(
              useContainerConstraints: true,
              minimumSplitHeight: AdaptiveHeight.medium,
              primary: const _MotionPaneCard(
                title: 'Primary surface',
                body:
                    'Keep the main task visible while the supporting pane '
                    'slides in only when there is room.',
                color: Color(0xFFDCEBFF),
              ),
              secondary: const _MotionPaneCard(
                title: 'Supporting context',
                body:
                    'Short wide surfaces can still stay stacked when height '
                    'would make a split feel cramped.',
                color: Color(0xFFF7DDF3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MotionToken extends StatelessWidget {
  final String label;
  final Color color;

  const _MotionToken({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _MotionPaneCard extends StatelessWidget {
  final String title;
  final String body;
  final Color color;

  const _MotionPaneCard({
    required this.title,
    required this.body,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Text(body),
          ],
        ),
      ),
    );
  }
}

class _AnimatedSectionsPreview extends StatefulWidget {
  const _AnimatedSectionsPreview();

  @override
  State<_AnimatedSectionsPreview> createState() =>
      _AnimatedSectionsPreviewState();
}

class _AnimatedSectionsPreviewState extends State<_AnimatedSectionsPreview> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: AdaptiveSections(
            useContainerConstraints: true,
            navigationHeader: Text(
              'Workspace areas',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            selectedIndex: _selectedIndex,
            onSelectedIndexChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            sections: const [
              AdaptiveSection(
                label: 'Overview',
                icon: Icon(Icons.dashboard_outlined),
                description: 'Narrative, metrics, and release health.',
                child: _AnimatedSectionBody(
                  title: 'Overview',
                  bullets: [
                    'Keep the shell story and the primary KPI close together.',
                    'Use compact summaries before widening into a sidebar.',
                  ],
                ),
              ),
              AdaptiveSection(
                label: 'Review',
                icon: Icon(Icons.fact_check_outlined),
                description: 'What still needs a human pass.',
                child: _AnimatedSectionBody(
                  title: 'Review',
                  bullets: [
                    'Dock navigation only when the section list stays scannable.',
                    'Animate content swaps so state changes feel connected.',
                  ],
                ),
              ),
              AdaptiveSection(
                label: 'Release',
                icon: Icon(Icons.rocket_launch_outlined),
                description: 'Readiness, blockers, and rollout windows.',
                child: _AnimatedSectionBody(
                  title: 'Release',
                  bullets: [
                    'Keep launch notes visible while the active section changes.',
                    'Use one settings surface instead of distinct mobile and desktop screens.',
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

class _AnimatedSectionBody extends StatelessWidget {
  final String title;
  final List<String> bullets;

  const _AnimatedSectionBody({required this.title, required this.bullets});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
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
            const SizedBox(height: 10),
            for (final bullet in bullets) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 7),
                    child: Icon(Icons.circle, size: 8),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(bullet)),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}

class _InsightChip extends StatelessWidget {
  final String title;
  final String body;

  const _InsightChip({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(body),
          ],
        ),
      ),
    );
  }
}

Widget _buildCompactContainerSlot(BuildContext context) {
  return const _ContainerSlotCard(
    title: 'Compact slot',
    body: 'Lead with one strong message and keep supporting context below.',
    accent: Color(0xFFD9F0E4),
  );
}

Widget _buildMediumContainerSlot(BuildContext context) {
  return const Row(
    children: [
      Expanded(
        child: _ContainerSlotCard(
          title: 'Medium slot',
          body: 'Tablet space can split summary and action surfaces.',
          accent: Color(0xFFFCE7C8),
        ),
      ),
      SizedBox(width: 16),
      Expanded(
        child: _ContainerSlotCard(
          title: 'Supporting slot',
          body:
              'Keep follow-up controls visible without overwhelming the page.',
          accent: Color(0xFFDCEBFF),
        ),
      ),
    ],
  );
}

Widget _buildExpandedContainerSlot(BuildContext context) {
  return const _ContainerSlotCard(
    title: 'Expanded slot',
    body:
        'Larger surfaces can promote denser summaries, wider copy, and more '
        'direct calls to action.',
    accent: Color(0xFFF7DDF3),
  );
}

class _ContainerSlotCard extends StatelessWidget {
  final String title;
  final String body;
  final Color accent;

  const _ContainerSlotCard({
    required this.title,
    required this.body,
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
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(body),
          ],
        ),
      ),
    );
  }
}

class _ClusterCard extends StatelessWidget {
  final String title;
  final String body;
  final Color color;

  const _ClusterCard({
    required this.title,
    required this.body,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: SizedBox(
        width: 220,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(body),
            ],
          ),
        ),
      ),
    );
  }
}

class _InspectorCanvas extends StatelessWidget {
  final String title;
  final String detail;

  const _InspectorCanvas({
    this.title = 'Editor canvas',
    this.detail =
        'Primary work stays visible while controls move to the right.',
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0B6E4F), Color(0xFF2F8A62)],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: SizedBox(
        height: 240,
        child: Padding(
          padding: const EdgeInsets.all(24),
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
              const SizedBox(height: 12),
              Text(
                detail,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.92),
                ),
              ),
              const Spacer(),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: const [
                  _InspectorMetricChip(label: '12 sections'),
                  _InspectorMetricChip(label: '3 breakpoints'),
                  _InspectorMetricChip(label: 'Live preview'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InspectorPanel extends StatelessWidget {
  const _InspectorPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Density', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        const LinearProgressIndicator(value: 0.58),
        const SizedBox(height: 16),
        Text('Visible modules', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            Chip(label: Text('Typography')),
            Chip(label: Text('Spacing')),
            Chip(label: Text('Navigation')),
            Chip(label: Text('Preview')),
          ],
        ),
        const SizedBox(height: 16),
        const _InspectorChecklistRow(title: 'Lock adaptive sizes', value: true),
        const SizedBox(height: 8),
        const _InspectorChecklistRow(
          title: 'Show local constraints',
          value: true,
        ),
      ],
    );
  }
}

class _InspectorMetricChip extends StatelessWidget {
  final String label;

  const _InspectorMetricChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

class _InspectorChecklistRow extends StatelessWidget {
  final String title;
  final bool value;

  const _InspectorChecklistRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          value ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 18,
          color: value
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline,
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(title)),
      ],
    );
  }
}

class _WorkspaceCopy extends StatelessWidget {
  const _WorkspaceCopy();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Container-driven workspace',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        const Text(
          'The summary card docks beside the content only when the local pane '
          'has enough room. This avoids wasting space in nested layouts.',
        ),
      ],
    );
  }
}

class _WorkspaceSummary extends StatelessWidget {
  const _WorkspaceSummary();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('3 active reviews'),
        SizedBox(height: 8),
        Text('12 reusable layouts'),
        SizedBox(height: 8),
        Text('2 modules pinned'),
      ],
    );
  }
}

class _SettingField extends StatelessWidget {
  final String label;

  const _SettingField({required this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
