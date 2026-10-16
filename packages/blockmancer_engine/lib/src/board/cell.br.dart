import 'package:freezed_annotation/freezed_annotation.dart';

part 'cell.br.freezed.dart';

/// A position on the board, or an offset inside a piece.
@freezed
abstract class Cell with _$Cell {
  const factory Cell({required int col, required int row}) = _Cell;

  const Cell._();

  Cell operator +(Cell offset) =>
      Cell(col: col + offset.col, row: row + offset.row);
}
