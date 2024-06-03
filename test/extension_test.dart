import 'package:flutter_test/flutter_test.dart';
import 'package:media_break_points/media_break_points.dart';

void main() {
  test('breakpoint equality', () {
    expect(BreakPoint.xs < BreakPoint.sm, true);
    expect(BreakPoint.sm < BreakPoint.md, true);
    expect(BreakPoint.lg < BreakPoint.xl, true);
    expect(BreakPoint.xl < BreakPoint.xxl, true);

    expect(BreakPoint.sm > BreakPoint.xs, true);
    expect(BreakPoint.md > BreakPoint.sm, true);
    expect(BreakPoint.xl > BreakPoint.lg, true);
    expect(BreakPoint.xxl > BreakPoint.xl, true);
  });
}
