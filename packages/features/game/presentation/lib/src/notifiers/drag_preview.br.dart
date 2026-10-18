import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_domain/shared_domain.dart';

part 'drag_preview.br.freezed.dart';

/// A tray piece being dragged, and what dropping it where it hovers would do.
@freezed
abstract class DragPreview with _$DragPreview {
  const factory DragPreview({
    /// `null` while the piece is off the board.
    required Cell? anchor,
    required int colorIndex,
    required PlacementPreview preview,
    required int trayIndex,

    /// The cells under the finger, outlined when the piece lands elsewhere
    /// (Mirror's boss); empty otherwise.
    @Default([]) List<Cell> held,
  }) = _DragPreview;
}
