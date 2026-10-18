import 'package:blockmancer_engine/src/board/placement.br.dart';
import 'package:blockmancer_engine/src/random/mulberry32.dart';
import 'package:blockmancer_engine/src/worlds/world_rule.dart';
import 'package:shared_domain/shared_domain.dart';

/// In the boss, every tray a move empties is refilled after the tide rises:
/// each cell moves up a row and a row of stones enters at the bottom, empty in
/// [RoundSpec.tideGaps] columns drawn from the stones stream. A line the rise
/// completes clears at once, for nothing. Anything pushed off the top floods
/// the round.
final class TideRule extends WorldRule {
  const TideRule();

  @override
  bool get bossOnly => true;

  @override
  Transition onTrayDealt(Transition transition, {required bool afterMove}) {
    if (!afterMove) return transition;

    final (state, events) = transition;
    final board = state.board;
    final flooded = [
      for (var col = 0; col < Board.size; col++) Cell(col: col, row: 0),
    ].any((cell) => board.at(cell) is! EmptyCell);
    var rng = Mulberry32(state.stonesRngState);
    final columns = List.generate(Board.size, (col) => col);
    final gaps = <int>[];

    for (var gap = 0; gap < state.round.tideGaps && columns.isNotEmpty; gap++) {
      final (index, next) = rng.nextInt(columns.length);
      rng = next;
      gaps.add(columns.removeAt(index));
    }

    gaps.sort();

    final risen = Board(
      cells: [
        ...board.cells.skip(Board.size),
        for (var col = 0; col < Board.size; col++)
          gaps.contains(col)
              ? const CellState.empty()
              : const CellState.stone(),
      ],
    );
    // No move completed these lines, so none scores them or counts them in
    // its streak.
    final clear = resolveClears(risen);
    final rose = state.copyWith(board: clear.board, stonesRngState: rng.state);
    final roseEvents = [
      ...events,
      GameEvent.tideRose(gapColumns: gaps),
      if (clear.clearedAny)
        GameEvent.linesCleared(
          cells: clear.cells,
          cols: clear.cols,
          rows: clear.rows,
          source: .tide,
        ),
    ];

    if (!flooded) return (rose, roseEvents);

    return (
      rose.copyWith(phase: const .roundLost(reason: .flooded)),
      [...roseEvents, const GameEvent.roundLost(reason: .flooded)],
    );
  }
}
