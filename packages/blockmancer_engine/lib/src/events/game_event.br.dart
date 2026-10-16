import 'package:blockmancer_engine/src/board/cell.br.dart';
import 'package:blockmancer_engine/src/jokers/joker_delta.br.dart';
import 'package:blockmancer_engine/src/jokers/joker_id.dart';
import 'package:blockmancer_engine/src/run/loss_reason.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_event.br.freezed.dart';

/// What a move did, in order. The UI animates these; it never recomputes a rule.
@freezed
sealed class GameEvent with _$GameEvent {
  const factory GameEvent.jokerFired({
    required JokerDelta delta,
    required JokerId joker,
  }) = JokerFired;

  const factory GameEvent.linesCleared({
    /// Distinct cells, row-major.
    required List<Cell> cells,
    required List<int> cols,
    required List<int> rows,
  }) = LinesCleared;

  const factory GameEvent.offersPresented({required List<JokerId> offers}) =
      OffersPresented;

  const factory GameEvent.piecePlaced({
    required Cell anchor,

    /// The board cells the piece filled.
    required List<Cell> cells,
    required int shapeId,
    required int trayIndex,
  }) = PiecePlaced;

  /// The fullest rows were emptied and pieces added.
  const factory GameEvent.revived({required List<int> rows}) = Revived;

  const factory GameEvent.roundLost({required LossReason reason}) = RoundLost;

  const factory GameEvent.roundStarted({
    required int pieces,
    required int roundIndex,
    required int target,
  }) = RoundStarted;

  /// [bonus] is what the round adds to the run total beyond its score.
  const factory GameEvent.roundWon({
    required int bonus,
    required int roundIndex,
    required int score,
  }) = RoundWon;

  const factory GameEvent.runOver({required int total}) = RunOver;

  const factory GameEvent.runWon({required int total}) = RunWon;

  /// A move's points: `chips × mult` plus the piece size and flat bonuses.
  /// [chips] and [mult] are 0 on a move that cleared nothing.
  const factory GameEvent.scoreAdded({
    required int chips,
    required int mult,
    required int total,
  }) = ScoreAdded;

  const factory GameEvent.stonePlaced({required Cell cell}) = StonePlaced;

  /// The whole tray after the draw; `null` is an empty slot.
  const factory GameEvent.trayRefilled({required List<int?> tray}) =
      TrayRefilled;
}
