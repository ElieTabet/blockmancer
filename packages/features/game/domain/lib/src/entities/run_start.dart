import 'package:game_domain/src/entities/game_mode.br.dart';
import 'package:shared_domain/shared_domain.dart';

/// A run to start: the mode it counts for, the numbers and jokers it is played
/// with, and the seed the rules play it on.
typedef RunStart = ({RunConfig config, GameMode mode, int seed});

/// The daily run of the UTC day [now] falls on, in the map's first world with
/// every joker, whatever the player has unlocked: everyone plays the same run.
/// Keyed by that day itself, not by the seed: the seed is the rules' to derive,
/// and may change without orphaning the saved bests.
RunStart dailyRunOn(DateTime now, {required GameRules rules}) {
  final day = now.toUtc();

  return (
    config: rules.configFor(rules.worldOrder.first, jokerPool: JokerId.values),
    mode: .daily(day: day.year * 10000 + day.month * 100 + day.day),
    seed: rules.dailySeed(day: day.day, month: day.month, year: day.year),
  );
}
