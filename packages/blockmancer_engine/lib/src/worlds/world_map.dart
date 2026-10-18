import 'package:blockmancer_engine/src/jokers/joker_catalog.dart';
import 'package:blockmancer_engine/src/run/default_config.dart';
import 'package:shared_domain/shared_domain.dart';

const worldOrder = <WorldId>[.rubble, .gravity, .fog, .tide, .mirror];

/// Every joker neither a world nor the stars unlock, in [jokerCatalog] order.
final List<JokerId> startingJokers = [
  for (final joker in jokerCatalog)
    if (!worldOrder.any((world) => unlocksOf(world).contains(joker.id)) &&
        !defaultConfig.starUnlocks.any(
          (unlock) => unlock.jokers.contains(joker.id),
        ))
      joker.id,
];

RunConfig configFor(WorldId world, {required List<JokerId> jokerPool}) =>
    switch (world) {
      .fog => fogConfig.copyWith(jokerPool: jokerPool),
      .gravity => gravityConfig.copyWith(jokerPool: jokerPool),
      .rubble => defaultConfig.copyWith(jokerPool: jokerPool),
      .mirror ||
      .tide => throw ArgumentError.value(world, 'world', 'is not playable'),
    };

bool isPlayable(WorldId world) => switch (world) {
  .fog || .gravity || .rubble => true,
  .mirror || .tide => false,
};

WorldId? nextWorld(WorldId world) {
  final index = worldOrder.indexOf(world);

  return index + 1 < worldOrder.length ? worldOrder[index + 1] : null;
}

List<JokerId> unlocksOf(WorldId world) => switch (world) {
  .fog => const [.lantern, .ember],
  .gravity => const [.anchor, .avalanche],
  .rubble => const [.stonemason, .quarry],
  .mirror || .tide => const [],
};
