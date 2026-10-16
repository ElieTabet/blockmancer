import 'package:blockmancer_engine/src/board/cell.br.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'joker_delta.br.freezed.dart';

/// What a joker changed when it fired — what the score banner names.
@freezed
sealed class JokerDelta with _$JokerDelta {
  const factory JokerDelta.chipsAdded({required int amount}) = ChipsAdded;

  const factory JokerDelta.multAdded({required int amount}) = MultAdded;

  const factory JokerDelta.multMultiplied({required int factor}) =
      MultMultiplied;

  /// Patience's bank after this move.
  const factory JokerDelta.multStored({required int total}) = MultStored;

  const factory JokerDelta.piecesAdded({required int amount}) = PiecesAdded;

  /// Flat points added to the move, outside chips × mult.
  const factory JokerDelta.pointsAdded({required int amount}) = PointsAdded;

  /// Points added to the run total rather than the round score.
  const factory JokerDelta.runPointsAdded({required int amount}) =
      RunPointsAdded;

  const factory JokerDelta.stoneDropped({required Cell cell}) = StoneDropped;

  const factory JokerDelta.stonesAdded({required int amount}) = StonesAdded;
}
