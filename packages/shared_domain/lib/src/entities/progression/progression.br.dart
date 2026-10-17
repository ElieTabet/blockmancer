import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_domain/src/entities/game/joker_id.dart';
import 'package:shared_domain/src/entities/game/world_id.dart';
import 'package:shared_domain/src/entities/progression/joker_stats.br.dart';
import 'package:shared_domain/src/entities/progression/world_progress.br.dart';

part 'progression.br.freezed.dart';

/// What the player has earned across runs: the worlds open to them and what
/// each has awarded, the jokers runs may offer, how runs went with each joker,
/// and whether the tutorial is behind them.
@freezed
abstract class Progression with _$Progression {
  const factory Progression({
    /// Only the jokers ever picked.
    required Map<JokerId, JokerStats> jokerStats,
    required bool tutorialDone,

    /// Unlocked outside a run, when an older save was brought up to date, and
    /// not shown yet: the map announces them on the player's next visit.
    required Set<JokerId> unannouncedJokers,
    required Set<JokerId> unlockedJokers,
    required Map<WorldId, WorldProgress> worlds,
  }) = _Progression;
}
