/// 32-bit integer multiply, wrapping like JavaScript's `Math.imul`.
///
/// Multiplied as 16-bit halves so no intermediate exceeds 2^53: on the web an
/// `int` is a double, and a full 32×32 product would silently lose bits there.
int imul32(int a, int b) {
  final aHigh = (a >>> 16) & 0xFFFF;
  final aLow = a & 0xFFFF;
  final bHigh = (b >>> 16) & 0xFFFF;
  final bLow = b & 0xFFFF;
  final cross = ((aHigh * bLow + aLow * bHigh) & 0xFFFF) << 16;

  return (aLow * bLow + cross) & 0xFFFFFFFF;
}

/// The mulberry32 generator, as an immutable state: each draw returns the
/// value and the generator to draw the next one from.
final class Mulberry32 {
  const Mulberry32(int seed) : state = seed & 0xFFFFFFFF;

  final int state;

  /// A double in [0, 1).
  (double, Mulberry32) next() {
    final state = (this.state + 0x6D2B79F5) & 0xFFFFFFFF;
    var t = imul32(state ^ (state >>> 15), state | 1);
    t = (t ^ (t + imul32(t ^ (t >>> 7), t | 61))) & 0xFFFFFFFF;
    final value = (t ^ (t >>> 14)) & 0xFFFFFFFF;

    return (value / 4294967296, Mulberry32(state));
  }

  /// An int in [0, max).
  (int, Mulberry32) nextInt(int max) {
    final (value, next) = this.next();

    return ((value * max).floor(), next);
  }

  @override
  bool operator ==(Object other) => other is Mulberry32 && other.state == state;

  @override
  int get hashCode => state.hashCode;
}
