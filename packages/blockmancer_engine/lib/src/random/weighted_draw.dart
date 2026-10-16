import 'package:blockmancer_engine/src/random/mulberry32.dart';

/// Picks an index with probability proportional to its weight, as the
/// reference prototype does: one draw scaled by the total, walked down.
(int, Mulberry32) weightedIndex(Mulberry32 rng, List<int> weights) {
  final (value, next) = rng.next();
  var remaining = value * weights.fold(0, (sum, weight) => sum + weight);

  for (final (index, weight) in weights.indexed) {
    remaining -= weight;

    if (remaining < 0) return (index, next);
  }

  return (weights.length - 1, next);
}
