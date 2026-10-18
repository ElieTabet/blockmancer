import 'package:game_domain/src/contracts/progression_store.dart';
import 'package:shared_domain/shared_domain.dart';

/// [ProgressionStore] read with every world it has earned open: the world
/// after a beaten boss, once the rules can play it. A boss beaten while the
/// next world was coming soon opened nothing, so this is what opens it when a
/// release gives it rules; the next write keeps it.
final class EarnedWorldsStore implements ProgressionStore {
  const EarnedWorldsStore({
    required GameRules rules,
    required ProgressionStore store,
  }) : _rules = rules,
       _store = store;

  final GameRules _rules;
  final ProgressionStore _store;

  @override
  Future<Progression> load() async =>
      withEarnedWorlds(await _store.load(), _rules);

  @override
  Future<void> save(Progression progression) => _store.save(progression);
}

/// [progression] with every playable world after a beaten boss open; the
/// same instance when none was closed.
Progression withEarnedWorlds(Progression progression, GameRules rules) {
  final earned = [
    for (final world in rules.worldOrder)
      if (progression.worlds[world]?.bossBeaten ?? false)
        if (rules.nextWorld(world) case final next?)
          if (rules.isPlayable(next) &&
              !(progression.worlds[next]?.unlocked ?? false))
            next,
  ];

  if (earned.isEmpty) return progression;

  return progression.copyWith(
    worlds: {
      ...progression.worlds,
      for (final world in earned)
        world: (progression.worlds[world] ?? _nothingEarned).copyWith(
          unlocked: true,
        ),
    },
  );
}

const _nothingEarned = WorldProgress(
  bossBeaten: false,
  stars: WorldStars(bossBeaten: false, noRevive: false, scoreThreshold: false),
  unlocked: false,
);
