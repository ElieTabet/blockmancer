import 'package:blockmancer_engine/src/jokers/joker_catalog.dart';
import 'package:blockmancer_engine/src/pieces/shape_catalog.dart';
import 'package:blockmancer_engine/src/random/mulberry32.dart';
import 'package:blockmancer_engine/src/random/weighted_draw.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:test/test.dart';

const _draws = 10000;
const _seed = 20261016;

/// How many of [_draws] pieces drawn with [jokers] owned satisfy [test].
int _count(List<JokerId> jokers, bool Function(Shape shape) test) {
  final weights = pieceWeights(effectsOf(jokers));
  var rng = const Mulberry32(_seed);
  var count = 0;

  for (var draw = 0; draw < _draws; draw++) {
    final (id, next) = weightedIndex(rng, weights);
    rng = next;

    if (test(shapeCatalog[id])) count++;
  }

  return count;
}

/// The odds of a draw landing in the group: its count against the rest.
///
/// A tripled weight triples these odds, not the raw share, which the rest of
/// the catalog dilutes (3 of 19 shapes go from 16% to 36%, not to 48%).
double _odds(int count) => count / (_draws - count);

bool _large(Shape shape) => shape.size >= 5;

bool _small(Shape shape) => shape.size <= 2;

void main() {
  for (final (name, joker, group) in [
    ('Big Box', JokerId.bigbox, _large),
    ('Tiny Tools', JokerId.tiny, _small),
  ]) {
    test('$name triples how often its pieces are drawn', () {
      // Given
      final without = _count(const [], group);

      // When
      final withJoker = _count([joker], group);

      // Then
      expect(_odds(withJoker) / _odds(without), inInclusiveRange(2.6, 3.4));
    });
  }
}
