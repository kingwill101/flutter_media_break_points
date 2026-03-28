import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';

import 'shared.dart';

class _DemoRecord {
  final String name;
  final String role;
  final int throughput;

  const _DemoRecord({
    required this.name,
    required this.role,
    required this.throughput,
  });
}

const _records = [
  _DemoRecord(
    name: 'Ava',
    role: 'Designer',
    throughput: 12,
  ),
  _DemoRecord(
    name: 'Noah',
    role: 'Engineer',
    throughput: 9,
  ),
];

List<AdaptiveDataColumn<_DemoRecord>> _columns() {
  return [
    AdaptiveDataColumn<_DemoRecord>(
      label: 'Role',
      cellBuilder: (context, record) => Text(record.role),
    ),
    AdaptiveDataColumn<_DemoRecord>(
      label: 'Throughput',
      numeric: true,
      cellBuilder: (context, record) => Text('${record.throughput}'),
    ),
  ];
}

void main() {
  testWidgets('AdaptiveDataView shows cards on compact widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdaptiveDataView<_DemoRecord>(
            records: _records,
            columns: _columns(),
            compactTitleBuilder: (context, record) => Text(record.name),
          ),
        ),
      ),
    );

    expect(find.byType(Card), findsNWidgets(2));
    expect(find.byType(DataTable), findsNothing);
    expect(find.text('Ava'), findsOneWidget);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveDataView shows a table on larger widths',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdaptiveDataView<_DemoRecord>(
            records: _records,
            columns: _columns(),
            compactTitleBuilder: (context, record) => Text(record.name),
          ),
        ),
      ),
    );

    expect(find.byType(DataTable), findsOneWidget);
    expect(find.text('Role'), findsOneWidget);
    expect(find.byType(Card), findsNothing);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveDataView can use narrow container constraints',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.xxl.start);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 320,
              child: AdaptiveDataView<_DemoRecord>(
                records: _records,
                columns: _columns(),
                compactTitleBuilder: (context, record) => Text(record.name),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(Card), findsNWidgets(2));
    expect(find.byType(DataTable), findsNothing);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveDataView can demote on short heights',
      (WidgetTester tester) async {
    setPhysicalSize(tester, BreakPoint.xl.start, 420);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 220,
            child: AdaptiveDataView<_DemoRecord>(
              records: _records,
              columns: _columns(),
              compactTitleBuilder: (context, record) => Text(record.name),
              minimumTableHeight: AdaptiveHeight.medium,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(Card), findsNWidgets(2));
    expect(find.byType(DataTable), findsNothing);

    resetScreenSize(tester);
  });

  testWidgets('AdaptiveDataView notifies when a compact record is tapped',
      (WidgetTester tester) async {
    setScreenSize(tester, BreakPoint.sm.start);

    _DemoRecord? selected;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdaptiveDataView<_DemoRecord>(
            records: _records,
            columns: _columns(),
            compactTitleBuilder: (context, record) => Text(record.name),
            onRecordTap: (record) {
              selected = record;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Noah'));
    await tester.pumpAndSettle();

    expect(selected, same(_records[1]));

    resetScreenSize(tester);
  });
}
