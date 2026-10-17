import 'package:game_presentation/src/entities/tutorial_step.dart';
import 'package:shared_domain/shared_domain.dart';

typedef _Placement = ({PlacementPreview preview, int trayIndex});

/// The cells the coach points at on [step]: for the drag, a spot a piece fits
/// that clears nothing, by a piece other than the one that could clear, so the
/// clear is still there for the next step; for the clear, a spot where a piece
/// completes a line. Empty when there is none, and on the other steps.
///
/// Spots are tried from the bottom row up, nearest the tray and clear of the
/// coach, which sits over the top of the screen.
List<Cell> tutorialHintFor(
  RunState run, {
  required GameRules rules,
  required TutorialStep step,
}) {
  if (step != .clear && step != .drag) return const [];

  final placements = _placementsIn(run, rules: rules);
  final clearing = placements.where(_clears).firstOrNull;

  if (step == .clear) return clearing?.preview.cells ?? const [];

  final quiet = placements.where((placement) => !_clears(placement));
  final hint =
      quiet
          .where((placement) => placement.trayIndex != clearing?.trayIndex)
          .firstOrNull ??
      quiet.firstOrNull;

  return hint?.preview.cells ?? const [];
}

bool _clears(_Placement placement) =>
    placement.preview.clearingRows.isNotEmpty ||
    placement.preview.clearingCols.isNotEmpty;

Iterable<_Placement> _placementsIn(
  RunState run, {
  required GameRules rules,
}) sync* {
  for (var trayIndex = 0; trayIndex < run.tray.length; trayIndex++) {
    if (run.tray[trayIndex] == null) continue;

    for (var row = Board.size - 1; row >= 0; row--) {
      for (var col = 0; col < Board.size; col++) {
        final anchor = Cell(col: col, row: row);

        if (!rules.canPlace(run, anchor: anchor, trayIndex: trayIndex)) {
          continue;
        }

        yield (
          preview: rules.preview(run, anchor: anchor, trayIndex: trayIndex),
          trayIndex: trayIndex,
        );
      }
    }
  }
}
