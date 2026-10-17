import 'package:game_domain/src/behaviors/daily_run_behavior.dart';
import 'package:game_domain/src/contracts/clock.dart';
import 'package:game_domain/src/entities/game_launch.dart';
import 'package:game_domain/src/entities/run_start.dart';
import 'package:shared_domain/shared_domain.dart';

/// The run a [GameLaunch] asks for, as of now: today's daily run, or a
/// practice or world run on a fresh seed. A resume normally starts nothing —
/// it loads the saved run — so it only gets here when the save was lost, and
/// starts today's daily instead. The tutorial plays the rules' own fixed run,
/// and counts as the practice it hands over to.
///
/// Practice plays the map's first world, and a world run the world it names
/// (the first when it names none, or names one the rules can't play yet: the
/// map never offers one, so a launch naming it plays on rather than failing).
/// Both offer only the jokers [Progression] has unlocked; the daily offers
/// them all.
class RunStartForBehavior {
  final Clock _clock;
  final GameRules _rules;

  const RunStartForBehavior({required Clock clock, required GameRules rules})
    : _clock = clock,
      _rules = rules;

  RunStart call(
    GameLaunch launch, {
    required Progression progression,
    WorldId? world,
  }) {
    final played = world != null && _rules.isPlayable(world)
        ? world
        : _rules.worldOrder.first;

    return switch (launch) {
      .daily || .resume => DailyRunBehavior(rules: _rules)(_clock.now()),
      .practice || .tutorial => (
        config: _unlockedConfig(_rules.worldOrder.first, progression),
        mode: const .practice(),
        seed: _freshSeed(),
      ),
      .world => (
        config: _unlockedConfig(played, progression),
        mode: .world(world: played),
        seed: _freshSeed(),
      ),
    };
  }

  // Any 32 bits will do: practice and world runs are not meant to be replayed.
  int _freshSeed() => _clock.now().microsecondsSinceEpoch & 0xFFFFFFFF;

  RunConfig _unlockedConfig(WorldId world, Progression progression) =>
      _rules.configFor(
        world,
        jokerPool: [
          for (final joker in JokerId.values)
            if (progression.unlockedJokers.contains(joker)) joker,
        ],
      );
}
