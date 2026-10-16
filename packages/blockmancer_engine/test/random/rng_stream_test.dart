import 'package:blockmancer_engine/blockmancer_engine.dart';
import 'package:test/test.dart';

// Golden values come from an independent Node port of the prototype's rand()
// plus the same seed derivation. They pin every seeded run: if one changes,
// every daily run changes with it.
void main() {
  const daily = 20261016;

  test('stream seeds derive the same way on every platform', () {
    // Given / When / Then
    expect(deriveSeed(daily, .pieces, 0), 2736651474);
    expect(deriveSeed(daily, .offers, 0), 614198587);
    expect(deriveSeed(daily, .stones, 4), 787966640);
  });

  test('the first 30 pieces of seed 20261016 are fixed', () {
    // Given
    var rng = streamFor(daily, .pieces, 0);
    final weights = List.filled(shapeCatalog.length, 1);
    final ids = <int>[];

    // When
    for (var i = 0; i < 30; i++) {
      final (id, next) = weightedIndex(rng, weights);
      ids.add(id);
      rng = next;
    }

    // Then
    expect(ids, [
      11, 14, 18, 13, 14, 3, 18, 13, 5, 6, 4, 16, 6, 1, 16, //
      9, 6, 15, 10, 18, 10, 12, 17, 8, 9, 18, 8, 5, 13, 3,
    ]);
  });

  test('each stream and each index gets its own seed', () {
    // Given / When
    final seeds = {
      for (final stream in RngStream.values)
        for (var index = 0; index < 5; index++)
          deriveSeed(daily, stream, index),
    };

    // Then
    expect(seeds, hasLength(RngStream.values.length * 5));
  });

  test('neighbouring run seeds give unrelated streams', () {
    // Given / When
    final today = deriveSeed(daily, .pieces, 0);
    final tomorrow = deriveSeed(daily + 1, .pieces, 0);

    // Then
    expect(today, isNot(tomorrow));
  });

  group('weightedIndex', () {
    test('a zero weight is never drawn', () {
      // Given
      var rng = const Mulberry32(3);

      // When / Then
      for (var i = 0; i < 500; i++) {
        final (index, next) = weightedIndex(rng, [1, 0, 1]);
        expect(index, isNot(1));
        rng = next;
      }
    });

    test('a weight of 3 comes up about three times as often', () {
      // Given
      var rng = const Mulberry32(11);
      final counts = [0, 0];

      // When
      for (var i = 0; i < 4000; i++) {
        final (index, next) = weightedIndex(rng, [1, 3]);
        counts[index]++;
        rng = next;
      }

      // Then
      expect(counts[1] / counts[0], closeTo(3, 0.3));
    });
  });

  test('the daily seed is the date as yyyymmdd', () {
    // Given / When / Then
    expect(dailySeed(day: 16, month: 10, year: 2026), daily);
    expect(dailySeed(day: 1, month: 2, year: 2027), 20270201);
  });
}
