import 'package:blockmancer_engine/src/bot/greedy_policy.dart';
import 'package:blockmancer_engine/src/run/default_config.dart';
import 'package:blockmancer_engine/src/run/engine.dart';
import 'package:blockmancer_engine/src/run/replay.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:test/test.dart';

import '../board_picture.dart';

const _seed = 20261016;

/// The boss of a run of [config], just started.
RunState _boss(RunConfig config) {
  final beforeBoss = startRun(
    config: config,
    seed: _seed,
  ).copyWith(phase: const .pickingJoker(offers: [.combo]), pickIndex: 4);

  return pickJoker(beforeBoss, id: .combo).$1;
}

/// The Gravity boss under way, on [board] with [tray].
RunState _gravityBoss({required Board board, List<int?> tray = const [0, 9]}) =>
    _boss(gravityConfig).copyWith(board: board, tray: [...tray]);

/// Shape ids: 0 single, 9 two-by-two square.
void main() {
  group('the Gravity boss', () {
    test('starts with no stones', () {
      // Given / When
      final boss = _boss(gravityConfig);

      // Then
      expect(boss.round.isBoss, isTrue);
      expect(boss.board.cells.whereType<StoneCell>(), isEmpty);
    });

    test('a piece dropped at the top falls to the bottom', () {
      // Given
      final state = _gravityBoss(board: Board.empty());

      // When
      final (next, events) = place(
        state,
        anchor: const Cell(col: 3, row: 0),
        trayIndex: 0,
      );

      // Then
      expect(events.whereType<PiecePlaced>().single.cells, const [
        Cell(col: 3, row: 7),
      ]);
      expect(next.board.at(const Cell(col: 3, row: 7)), isA<FilledCell>());
      expect(next.board.at(const Cell(col: 3, row: 0)), isA<EmptyCell>());
    });

    test('the preview shows where the piece lands, not where it is held', () {
      // Given: a ledge under the square's right column
      final state = _gravityBoss(
        board: boardFrom(['........', '........', '........', '...#....']),
      );

      // When
      final shown = preview(
        state,
        anchor: const Cell(col: 2, row: 0),
        trayIndex: 1,
      );
      final (_, events) = place(
        state,
        anchor: const Cell(col: 2, row: 0),
        trayIndex: 1,
      );

      // Then
      expect(shown.fits, isTrue);
      expect(shown.cells, events.whereType<PiecePlaced>().single.cells);
      expect(shown.cells, const [
        Cell(col: 2, row: 1),
        Cell(col: 3, row: 1),
        Cell(col: 2, row: 2),
        Cell(col: 3, row: 2),
      ]);
    });

    test('a line the piece completes where it lands is cleared', () {
      // Given: the bottom row lacks one cell
      final state = _gravityBoss(
        board: boardFrom([
          '........',
          '........',
          '........',
          '........',
          '........',
          '........',
          '........',
          '###.####',
        ]),
      );

      // When
      final shown = preview(
        state,
        anchor: const Cell(col: 3, row: 0),
        trayIndex: 0,
      );
      final (next, events) = place(
        state,
        anchor: const Cell(col: 3, row: 0),
        trayIndex: 0,
      );

      // Then
      expect(shown.clearingRows, [7]);
      expect(events.whereType<LinesCleared>().single.rows, [7]);
      expect(next.board.isEmpty, isTrue);
    });

    test('a column full to the top cannot take a piece', () {
      // Given
      final state = _gravityBoss(
        board: boardFrom([
          '..#.....',
          '..#.....',
          '..#.....',
          '..#.....',
          '..#.....',
          '..#.....',
          '..#.....',
          '..#.....',
        ]),
      );
      const top = Cell(col: 2, row: 0);

      // When
      final placeable = canPlace(state, anchor: top, trayIndex: 0);
      final shown = preview(state, anchor: top, trayIndex: 0);

      // Then
      expect(placeable, isFalse);
      expect(shown.fits, isFalse);
      expect(shown.colliding, const [top]);
      expect(
        () => place(state, anchor: top, trayIndex: 0),
        throwsArgumentError,
      );
    });

    test('a round with no drop point for any tray piece has no room', () {
      // Given: no two-by-two hole anywhere once the single is played
      final state = _gravityBoss(
        board: boardFrom([
          '.#.#.#.#',
          '#.#.#.#.',
          '.#.#.#.#',
          '#.#.#.#.',
          '.#.#.#.#',
          '#.#.#.#.',
          '.#.#.#.#',
          '#.#.#.#.',
        ]),
      ).copyWith(piecesLeft: 0);

      // When
      final squareFits = fitsSomewhere(state, trayIndex: 1);
      final (next, _) = place(
        state,
        anchor: const Cell(col: 0, row: 0),
        trayIndex: 0,
      );

      // Then
      expect(squareFits, isFalse);
      expect(next.phase, const RunPhase.roundLost(reason: .noRoom));
    });
  });

  test('before its boss, a Gravity run places a piece where it is held', () {
    // Given
    final start = startRun(config: gravityConfig, seed: _seed);
    final (round, _) = pickJoker(
      start.copyWith(phase: const .pickingJoker(offers: [.combo])),
      id: .combo,
    );
    final state = round.copyWith(board: Board.empty(), tray: [0, null, null]);

    // When
    final (next, events) = place(
      state,
      anchor: const Cell(col: 3, row: 0),
      trayIndex: 0,
    );

    // Then
    expect(state.round.isBoss, isFalse);
    expect(
      events.whereType<PiecePlaced>().single.anchor,
      const Cell(col: 3, row: 0),
    );
    expect(next.board.at(const Cell(col: 3, row: 0)), isA<FilledCell>());
  });

  test('the Rubble boss places a piece where it is held', () {
    // Given
    final state = _boss(
      defaultConfig,
    ).copyWith(board: Board.empty(), tray: [0, null, null]);

    // When
    final (next, _) = place(
      state,
      anchor: const Cell(col: 3, row: 0),
      trayIndex: 0,
    );

    // Then
    expect(next.board.at(const Cell(col: 3, row: 0)), isA<FilledCell>());
  });

  test('a Gravity run that reached its boss replays to the same end', () {
    // Given: the bot's run of seed 1, which falls in its boss
    const build = [JokerId.patience, JokerId.twin];
    var state = startRun(config: gravityConfig, seed: 1);
    final moves = <RunMove>[];
    var fell = false;

    for (
      var move = greedyMove(state, build: build);
      move != null;
      move = greedyMove(state, build: build)
    ) {
      final inBoss = state.phase is PlayingPhase && state.round.isBoss;
      final (next, events) = applyMove(state, move);

      if (inBoss && move is PlaceMove) {
        fell |= events.whereType<PiecePlaced>().single.anchor != move.anchor;
      }

      moves.add(move);
      state = next;
    }

    // When
    final replayed = replay(config: gravityConfig, moves: moves, seed: 1);

    // Then
    expect(fell, isTrue);
    expect(replayed, state);
  });
}
