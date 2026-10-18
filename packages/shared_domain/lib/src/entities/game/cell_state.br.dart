import 'package:freezed_annotation/freezed_annotation.dart';

part 'cell_state.br.freezed.dart';

@freezed
sealed class CellState with _$CellState {
  const factory CellState.empty() = EmptyCell;

  const factory CellState.filled({required int colorIndex}) = FilledCell;

  /// Blocks a piece and counts as occupied, like a stone. What it hides is
  /// the rules' alone: nothing a player or the bot sees may read
  /// [hidesStone].
  const factory CellState.fog({required bool hidesStone}) = FogCell;

  const factory CellState.stone() = StoneCell;
}
