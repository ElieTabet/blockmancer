import 'package:freezed_annotation/freezed_annotation.dart';

part 'cell_state.br.freezed.dart';

@freezed
sealed class CellState with _$CellState {
  const factory CellState.empty() = EmptyCell;

  const factory CellState.filled({required int colorIndex}) = FilledCell;

  const factory CellState.stone() = StoneCell;
}
