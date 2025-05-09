import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';

void main() {
  test('breakpoint equality and comparison operators', () {
    // Test less than operator
    expect(BreakPoint.xs < BreakPoint.sm, true);
    expect(BreakPoint.sm < BreakPoint.md, true);
    expect(BreakPoint.md < BreakPoint.lg, true);
    expect(BreakPoint.lg < BreakPoint.xl, true);
    expect(BreakPoint.xl < BreakPoint.xxl, true);

    // Test greater than operator
    expect(BreakPoint.sm > BreakPoint.xs, true);
    expect(BreakPoint.md > BreakPoint.sm, true);
    expect(BreakPoint.lg > BreakPoint.md, true);
    expect(BreakPoint.xl > BreakPoint.lg, true);
    expect(BreakPoint.xxl > BreakPoint.xl, true);

    // Test less than or equal to operator
    expect(BreakPoint.xs <= BreakPoint.xs, true);
    expect(BreakPoint.xs <= BreakPoint.sm, true);
    expect(BreakPoint.sm <= BreakPoint.md, true);

    // Test greater than or equal to operator
    expect(BreakPoint.xxl >= BreakPoint.xxl, true);
    expect(BreakPoint.xxl >= BreakPoint.xl, true);
    expect(BreakPoint.xl >= BreakPoint.lg, true);
  });

  test('breakpoint label returns correct string representation', () {
    expect(BreakPoint.xs.label.contains('xs'), true);
    expect(BreakPoint.sm.label.contains('sm'), true);
    expect(BreakPoint.md.label.contains('md'), true);
    expect(BreakPoint.lg.label.contains('lg'), true);
    expect(BreakPoint.xl.label.contains('xl'), true);
    expect(BreakPoint.xxl.label.contains('xxl'), true);
  });

  test('breakpoint start and end values are accessible', () {
    // Check that start and end values are accessible
    expect(BreakPoint.xs.start, isA<double>());
    expect(BreakPoint.xs.end, isA<double>());
    expect(BreakPoint.sm.start, isA<double>());
    expect(BreakPoint.sm.end, isA<double>());

    // Check that start is less than end for all breakpoints except xxl
    expect(BreakPoint.xs.start < BreakPoint.xs.end, true);
    expect(BreakPoint.sm.start < BreakPoint.sm.end, true);
    expect(BreakPoint.md.start < BreakPoint.md.end, true);
    expect(BreakPoint.lg.start < BreakPoint.lg.end, true);
    expect(BreakPoint.xl.start < BreakPoint.xl.end, true);

    // xxl has no upper limit, so end is 0
    expect(BreakPoint.xxl.end, 0);
  });
}
