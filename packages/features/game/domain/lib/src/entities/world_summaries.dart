import 'package:shared_domain/shared_domain.dart';

/// Every world of the map, in the map's order, as the rules have it.
List<WorldSummary> worldSummariesOf(GameRules rules) => [
  for (final world in rules.worldOrder) _summaryOf(world, rules: rules),
];

WorldSummary _summaryOf(WorldId world, {required GameRules rules}) {
  // A world without its rules has no run to read its numbers from.
  if (!rules.isPlayable(world)) {
    return WorldSummary(
      bossTarget: 0,
      id: world,
      jokerTuning: rules.defaultConfig.jokers,
      playable: false,
      starThreshold: 0,
      unlocks: rules.unlocksOf(world),
    );
  }

  final config = rules.configFor(world, jokerPool: const []);

  return WorldSummary(
    bossTarget: config.rounds.last.target,
    id: world,
    jokerTuning: rules.defaultConfig.jokers,
    playable: true,
    starThreshold: config.starThreshold,
    unlocks: rules.unlocksOf(world),
  );
}
