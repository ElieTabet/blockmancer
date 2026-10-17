import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_domain/src/entities/game/joker_id.dart';
import 'package:shared_domain/src/entities/game/world_id.dart';
import 'package:shared_domain/src/entities/progression/world_progress.br.dart';

part 'progression.br.freezed.dart';

/// What the player has earned across runs: the worlds open to them and what
/// each has awarded, the jokers runs may offer, and whether the tutorial is
/// behind them.
@freezed
abstract class Progression with _$Progression {
  const factory Progression({
    required bool tutorialDone,
    required Set<JokerId> unlockedJokers,
    required Map<WorldId, WorldProgress> worlds,
  }) = _Progression;
}
