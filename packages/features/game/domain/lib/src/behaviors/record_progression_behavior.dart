import 'package:game_domain/src/contracts/progression_store.dart';
import 'package:game_domain/src/entities/game_mode.br.dart';
import 'package:game_domain/src/entities/progression_change.br.dart';
import 'package:shared_domain/shared_domain.dart';

/// Keeps what a finished world run earned: its world's stars, and on the first
/// win over its boss, the jokers the win unlocks and the next world — if the
/// rules can play it yet: a coming-soon world stays locked, so nothing ever
/// announces or opens a world without a run. Nothing is ever taken back, so a
/// worse run changes nothing.
///
/// Stars held across every world unlock the run config's `starUnlocks`: each
/// joker once, at the end of the first world run that finds the count reached.
/// That is the run that crosses it, or for a player already past it before
/// the unlock existed, their next world run.
///
/// Only world runs count: the daily is everyone's competition and practice is
/// free play, so neither touches the map. The third star is the run total
/// alone, boss beaten or not.
class RecordProgressionBehavior {
  static const _nothingEarned = WorldProgress(
    bossBeaten: false,
    stars: WorldStars(
      bossBeaten: false,
      noRevive: false,
      scoreThreshold: false,
    ),
    unlocked: false,
  );
  final GameRules _rules;
  final ProgressionStore _store;

  const RecordProgressionBehavior({
    required GameRules rules,
    required ProgressionStore store,
  }) : _rules = rules,
       _store = store;

  /// Null for a run that isn't a world's.
  Future<ProgressionChange?> call(GameMode mode, RunState run) async {
    if (mode is! WorldMode) return null;

    final world = mode.world;
    final before = await _store.load();
    final was = before.worlds[world] ?? _nothingEarned;
    final bossBeaten = run.phase is WonPhase;
    final stars = WorldStars(
      bossBeaten: was.stars.bossBeaten || bossBeaten,
      noRevive: was.stars.noRevive || (bossBeaten && run.revivesUsed == 0),
      scoreThreshold:
          was.stars.scoreThreshold || run.runTotal >= run.config.starThreshold,
    );

    final firstWin = bossBeaten && !was.bossBeaten;
    final next = firstWin ? _rules.nextWorld(world) : null;
    final unlockedWorld =
        next != null &&
            _rules.isPlayable(next) &&
            !(before.worlds[next]?.unlocked ?? false)
        ? next
        : null;
    final worlds = {
      ...before.worlds,
      world: was.copyWith(
        bossBeaten: was.bossBeaten || bossBeaten,
        stars: stars,
      ),
      ?unlockedWorld: (before.worlds[unlockedWorld] ?? _nothingEarned).copyWith(
        unlocked: true,
      ),
    };
    final starsHeld = worlds.values.fold(
      0,
      (held, progress) => held + _count(progress.stars),
    );
    final unlockedJokers = {
      if (firstWin) ..._rules.unlocksOf(world),
      for (final unlock in run.config.starUnlocks)
        if (starsHeld >= unlock.stars) ...unlock.jokers,
    }.where((joker) => !before.unlockedJokers.contains(joker)).toList();

    final after = before.copyWith(
      unlockedJokers: {...before.unlockedJokers, ...unlockedJokers},
      worlds: worlds,
    );

    if (after != before) await _store.save(after);

    return ProgressionChange(
      newStars: WorldStars(
        bossBeaten: stars.bossBeaten && !was.stars.bossBeaten,
        noRevive: stars.noRevive && !was.stars.noRevive,
        scoreThreshold: stars.scoreThreshold && !was.stars.scoreThreshold,
      ),
      progression: after,
      stars: stars,
      unlockedJokers: unlockedJokers,
      unlockedWorld: unlockedWorld,
    );
  }

  static int _count(WorldStars stars) => [
    stars.bossBeaten,
    stars.noRevive,
    stars.scoreThreshold,
  ].where((earned) => earned).length;
}
