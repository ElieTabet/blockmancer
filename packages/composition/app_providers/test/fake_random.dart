import 'dart:math';

/// Draws [value] every time.
final class FakeRandom implements Random {
  final double value;

  const FakeRandom(this.value);

  @override
  bool nextBool() => value >= 0.5;

  @override
  double nextDouble() => value;

  @override
  int nextInt(int max) => (value * max).floor().clamp(0, max - 1);
}
