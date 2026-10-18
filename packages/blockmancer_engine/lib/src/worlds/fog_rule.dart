import 'package:blockmancer_engine/src/board/placement.br.dart';
import 'package:blockmancer_engine/src/random/mulberry32.dart';
import 'package:blockmancer_engine/src/worlds/world_rule.dart';
import 'package:shared_domain/shared_domain.dart';

/// The boss starts with [RoundSpec.fog] fog cells, the first
/// [RoundSpec.fogStones] laid hiding a stone. Each piece lifts the fog beside
/// it once the move has scored and cleared: a fog cell sharing a side with
/// one of the piece's cells turns empty, or to the stone it hid.
final class FogRule extends WorldRule {
  const FogRule();

  @override
  bool get bossOnly => true;

  @override
  (Board, Mulberry32, List<GameEvent>) onBoardSetup(
    Board board,
    RoundSpec round,
    Mulberry32 stonesRng,
  ) {
    var fogged = board;
    var rng = stonesRng;
    final laid = <Cell>[];

    for (var fog = 0; fog < round.fog; fog++) {
      final cells = stoneCells(fogged);

      if (cells.isEmpty) break;

      final (index, next) = rng.nextInt(cells.length);
      rng = next;
      laid.add(cells[index]);
      fogged = fogged.withCells({
        cells[index]: CellState.fog(hidesStone: fog < round.fogStones),
      });
    }

    return (
      fogged,
      rng,
      [if (laid.isNotEmpty) GameEvent.fogPlaced(cells: laid)],
    );
  }

  @override
  (Board, List<GameEvent>) afterPlacement({
    required Board board,
    required List<Cell> placed,
  }) {
    final beside = {
      for (final cell in placed)
        for (final neighbour in orthogonalNeighbours(cell))
          if (board.contains(neighbour) && board.at(neighbour) is FogCell)
            neighbour,
    }.toList()..sort((a, b) => a.row != b.row ? a.row - b.row : a.col - b.col);

    if (beside.isEmpty) return (board, const []);

    final revealed = {
      for (final cell in beside)
        cell: switch (board.at(cell)) {
          FogCell(hidesStone: true) => const CellState.stone(),
          _ => const CellState.empty(),
        },
    };

    return (
      board.withCells(revealed),
      [
        for (final MapEntry(key: cell, :value) in revealed.entries)
          GameEvent.fogRevealed(becameStone: value is StoneCell, cell: cell),
      ],
    );
  }
}
