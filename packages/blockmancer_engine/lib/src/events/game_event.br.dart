import 'package:blockmancer_engine/src/jokers/joker_delta.br.dart';
import 'package:blockmancer_engine/src/jokers/joker_id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_event.br.freezed.dart';

/// What a move did, in order. The UI animates these; it never recomputes a rule.
@freezed
sealed class GameEvent with _$GameEvent {
  const factory GameEvent.jokerFired({
    required JokerDelta delta,
    required JokerId joker,
  }) = JokerFired;

  /// A move's points: `chips × mult` plus the piece size and flat bonuses.
  /// [chips] and [mult] are 0 on a move that cleared nothing.
  const factory GameEvent.scoreAdded({
    required int chips,
    required int mult,
    required int total,
  }) = ScoreAdded;
}
