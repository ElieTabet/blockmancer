import 'package:shared_domain/src/entities/game/cell.br.dart';
import 'package:shared_domain/src/entities/game/joker_delta.br.dart';
import 'package:shared_domain/src/entities/game/joker_id.dart';
import 'package:shared_domain/src/entities/game/loss_reason.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_event.br.freezed.dart';

/// What a move did, in order. The UI animates these; it never recomputes a rule.
@freezed
sealed class GameEvent with _$GameEvent {
  /// Fog laid on [cells] as the round starts (Fog's boss).
  const factory GameEvent.fogPlaced({required List<Cell> cells}) = FogPlaced;

  /// A fog cell beside the piece just placed lifted: empty now, or a stone
  /// if it hid one.
  const factory GameEvent.fogRevealed({
    required bool becameStone,
    required Cell cell,
  }) = FogRevealed;

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

  /// A move's points, as the parts that add up to [total]: [piecePoints] (the
  /// piece's size), [lineScore] (`chips × mult`, 0 when nothing cleared) and
  /// [bonusPoints] (flat bonuses such as Clean Sweep's).
  const factory GameEvent.scoreAdded({
    required int bonusPoints,
    required int chips,
    required int lineScore,
    required int mult,
    required int piecePoints,
    required int total,
  }) = ScoreAdded;

  const factory GameEvent.stonePlaced({required Cell cell}) = StonePlaced;

  /// The whole tray after the draw; `null` is an empty slot.
  const factory GameEvent.trayRefilled({required List<int?> tray}) =
      TrayRefilled;
}
