import 'package:game_domain/src/entities/run_tuning.dart';
import 'package:shared_domain/shared_domain.dart';

/// Every world of the map, in the map's order, as the rules have it and
/// Remote Config tunes it.
List<WorldSummary> worldSummariesOf(
  GameRules rules, {
  required RemoteValueFun valueOf,
}) => [
  for (final world in rules.worldOrder)
    _summaryOf(world, rules: rules, valueOf: valueOf),
];

WorldSummary _summaryOf(
  WorldId world, {
  required GameRules rules,
  required RemoteValueFun valueOf,
}) {
  final jokers = tuned(rules.defaultConfig, valueOf).jokers;

  // A world without its rules has no run to read its numbers from.
  if (!rules.isPlayable(world)) {
    return WorldSummary(
      bossTarget: 0,
      id: world,
      jokerTuning: jokers,
      playable: false,
      starThreshold: 0,
      unlocks: rules.unlocksOf(world),
    );
  }

  final config = tuned(rules.configFor(world, jokerPool: const []), valueOf);

  return WorldSummary(
    bossTarget: config.rounds.last.target,
    id: world,
    jokerTuning: jokers,
    playable: true,
    starThreshold: config.starThreshold,
    unlocks: rules.unlocksOf(world),
  );
}
