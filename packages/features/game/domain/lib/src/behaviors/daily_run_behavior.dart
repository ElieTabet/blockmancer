import 'package:game_domain/src/entities/run_tuning.dart';
import 'package:game_domain/src/entities/run_start.dart';
import 'package:shared_domain/shared_domain.dart';

/// The daily run of the UTC day an instant falls on, in the map's first world
/// with every joker, whatever the player has unlocked: everyone plays the same
/// run. Keyed by that day itself, not by the seed: the seed is the rules' to
/// derive, and may change without orphaning the saved bests.
///
/// Not exported: callers pass the clock's instant, so nothing outside this
/// package can start another day's run.
class DailyRunBehavior {
  final GameRules _rules;
  final RemoteValueFun _valueOf;

  const DailyRunBehavior({
    required GameRules rules,
    required RemoteValueFun valueOf,
  }) : _rules = rules,
       _valueOf = valueOf;

  RunStart call(DateTime now) {
    final day = now.toUtc();

    return (
      config: tuned(
        _rules.configFor(_rules.worldOrder.first, jokerPool: JokerId.values),
        _valueOf,
      ),
      mode: .daily(day: day.year * 10000 + day.month * 100 + day.day),
      seed: _rules.dailySeed(day: day.day, month: day.month, year: day.year),
    );
  }
}
