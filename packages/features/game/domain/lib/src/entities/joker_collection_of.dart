import 'package:shared_domain/shared_domain.dart';

/// Every joker in pairs, from the rules alone: a new player's first, in the
/// rules' order, then each world's boss's in the map's order, then the stars'
/// from fewest to most.
JokerCollection jokerCollectionOf(GameRules rules) {
  final placed = <JokerId>{};
  final pairs = <JokerPair>[];

  void pairUp(Iterable<JokerId> jokers, JokerUnlock unlock) {
    for (final joker in jokers) {
      if (placed.contains(joker)) continue;

      final partner = rules.partnerOf(joker);
      placed.addAll([joker, partner]);
      pairs.add(JokerPair(first: joker, second: partner, unlock: unlock));
    }
  }

  pairUp(rules.startingJokers, const .starting());

  for (final world in rules.worldOrder) {
    pairUp(rules.unlocksOf(world), .boss(world: world));
  }

  final starUnlocks = [...rules.defaultConfig.starUnlocks]
    ..sort((a, b) => a.stars - b.stars);

  for (final unlock in starUnlocks) {
    pairUp(unlock.jokers, .stars(count: unlock.stars));
  }

  return JokerCollection(pairs: pairs, tuning: rules.defaultConfig.jokers);
}
