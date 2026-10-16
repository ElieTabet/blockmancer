import 'package:shared_domain/src/entities/game/cell.br.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'placement_preview.br.freezed.dart';

/// What dropping a tray piece at an anchor would do, for the drag shadow.
@freezed
abstract class PlacementPreview with _$PlacementPreview {
  const factory PlacementPreview({
    /// The piece's cells that land inside the board.
    required List<Cell> cells,

    /// Only when [fits].
    required List<int> clearingCols,
    required List<int> clearingRows,

    /// Piece cells over a filled cell or a stone.
    required List<Cell> colliding,
    required bool fits,
  }) = _PlacementPreview;

  static const none = PlacementPreview(
    cells: [],
    clearingCols: [],
    clearingRows: [],
    colliding: [],
    fits: false,
  );
}
