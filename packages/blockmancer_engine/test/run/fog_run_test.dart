import 'package:blockmancer_engine/src/bot/greedy_policy.dart';
import 'package:blockmancer_engine/src/run/default_config.dart';
import 'package:blockmancer_engine/src/run/engine.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:test/test.dart';

import '../board_picture.dart';

const _seed = 20261016;

/// The pick that starts the boss of a run of [config].
Transition _bossStart(RunConfig config) {
  final beforeBoss = startRun(
    config: config,
    seed: _seed,
  ).copyWith(phase: const .pickingJoker(offers: [.combo]), pickIndex: 4);

  return pickJoker(beforeBoss, id: .combo);
}

/// The Fog boss under way, on [board], owning [jokers], with a single in hand.
RunState _fogBoss(Board board, {List<JokerId> jokers = const [.combo]}) =>
    _bossStart(
      fogConfig,
    ).$1.copyWith(board: board, jokers: jokers, tray: [0, null, null]);

int _count(Board board, bool Function(CellState cell) test) =>
    board.cells.where(test).length;

void main() {
  group('the Fog boss', () {
    test('starts with 8 fog cells, 3 of them hiding a stone, and no stone', () {
      // Given / When
      final (boss, events) = _bossStart(fogConfig);

      // Then
      expect(_count(boss.board, (cell) => cell is FogCell), 8);
      expect(
        _count(boss.board, (cell) => cell is FogCell && cell.hidesStone),
        3,
      );
      expect(_count(boss.board, (cell) => cell is StoneCell), 0);
      expect(events.whereType<FogPlaced>().single.cells, hasLength(8));
    });

    test('lays the same fog for the same seed', () {
      expect(_bossStart(fogConfig).$1.board, _bossStart(fogConfig).$1.board);
    });

    test('is the only round with fog', () {
      // Given / When
      final start = startRun(config: fogConfig, seed: _seed);
      final (round1, _) = pickJoker(
        start.copyWith(phase: const .pickingJoker(offers: [.combo])),
        id: .combo,
      );

      // Then
      expect(_count(round1.board, (cell) => cell is FogCell), 0);
    });

    test('a piece placed beside fog lifts it to an empty cell', () {
      // Given
      final state = _fogBoss(boardFrom(['F.......']));

      // When
      final (next, events) = place(
        state,
        anchor: const Cell(col: 1, row: 0),
        trayIndex: 0,
      );

      // Then
      expect(next.board.at(const Cell(col: 0, row: 0)), isA<EmptyCell>());
      expect(
        events.whereType<FogRevealed>().single,
        const GameEvent.fogRevealed(
          becameStone: false,
          cell: Cell(col: 0, row: 0),
        ),
      );
    });

    test('fog that hid a stone lifts to that stone', () {
      // Given
      final state = _fogBoss(boardFrom(['........', 'H.......']));

      // When
      final (next, events) = place(
        state,
        anchor: const Cell(col: 0, row: 0),
        trayIndex: 0,
      );

      // Then
      expect(next.board.at(const Cell(col: 0, row: 1)), isA<StoneCell>());
      expect(events.whereType<FogRevealed>().single.becameStone, isTrue);
    });

    test('fog touching the piece only by a corner stays', () {
      // Given
      final state = _fogBoss(boardFrom(['F.......']));

      // When
      final (next, events) = place(
        state,
        anchor: const Cell(col: 1, row: 1),
        trayIndex: 0,
      );

      // Then
      expect(next.board.at(const Cell(col: 0, row: 0)), isA<FogCell>());
      expect(events.whereType<FogRevealed>(), isEmpty);
    });

    test('fog in the line a piece clears goes with the line, whatever it hid, '
        'before anything is lifted', () {
      // Given: hidden stone beside the drop, in the row it completes
      final state = _fogBoss(boardFrom(['######H.']));

      // When
      final (next, events) = place(
        state,
        anchor: const Cell(col: 7, row: 0),
        trayIndex: 0,
      );

      // Then
      expect(next.board.at(const Cell(col: 6, row: 0)), isA<EmptyCell>());
      expect(events.whereType<FogRevealed>(), isEmpty);
    });

    test('a move places, scores and clears, Lantern takes what is beside the '
        'line, then the fog lifts', () {
      // Given: a vertical domino completing row 0, a hidden stone beside the
      // row and one beside the domino's foot, out of Lantern's reach
      final state = _fogBoss(
        boardFrom(['#######.', '......H.', '.......H']),
        jokers: const [.lantern],
      ).copyWith(tray: [2, null, null]);

      // When
      final (next, events) = place(
        state,
        anchor: const Cell(col: 7, row: 0),
        trayIndex: 0,
      );

      // Then: Lantern took the one beside the row, hidden stone and all, and
      // only then did the other lift, to its stone
      expect(next.board.at(const Cell(col: 6, row: 1)), isA<EmptyCell>());
      expect(next.board.at(const Cell(col: 7, row: 2)), isA<StoneCell>());
      expect(events.map((event) => event.runtimeType), [
        PiecePlaced,
        LinesCleared,
        JokerFired,
        ScoreAdded,
        FogRevealed,
        TrayRefilled,
      ]);
      expect(
        events.whereType<JokerFired>().single.delta,
        const JokerDelta.obstaclesRemoved(cells: [Cell(col: 6, row: 1)]),
      );
    });
  });

  test('the bot moves the same whether fog hides a stone or not', () {
    // Given: a single in hand, every drop worth the same, one fog cell
    final hiding = _fogBoss(
      boardFrom([
        '........',
        '........',
        '........',
        '........',
        '........',
        '.....H..',
      ]),
    );
    final bare = _fogBoss(
      boardFrom([
        '........',
        '........',
        '........',
        '........',
        '........',
        '.....F..',
      ]),
    );

    // When
    final fromHiding = greedyMove(hiding, build: const []);
    final fromBare = greedyMove(bare, build: const []);

    // Then: both lift the fog, the first drop beside it
    expect(fromHiding, fromBare);
    expect(
      fromBare,
      const RunMove.place(anchor: Cell(col: 5, row: 4), trayIndex: 0),
    );
  });
}
