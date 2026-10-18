import 'package:blockmancer_engine/src/bot/greedy_policy.dart';
import 'package:blockmancer_engine/src/run/default_config.dart';
import 'package:blockmancer_engine/src/run/engine.dart';
import 'package:blockmancer_engine/src/run/replay.dart';
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

/// The Tide boss with a single left of a tray dealt in full, on [board].
RunState _lastOfTray(Board board) => _bossStart(
  tideConfig,
).$1.copyWith(board: board, tray: [0, null, null], trayDealt: 3);

/// [_lastOfTray]'s single played at [at].
Transition _playLast(Board board, {Cell at = const Cell(col: 0, row: 0)}) =>
    place(_lastOfTray(board), anchor: at, trayIndex: 0);

void main() {
  group('the Tide boss', () {
    test('deals its first tray without rising', () {
      // Given / When
      final (boss, events) = _bossStart(tideConfig);

      // Then
      expect(events.whereType<TideRose>(), isEmpty);
      expect(boss.board.isEmpty, isTrue);
      expect(boss.trayDealt, 3);
    });

    test('rises a row before the next tray: everything moves up', () {
      // Given: a filled cell in row 5
      final board = boardFrom([
        '........',
        '........',
        '........',
        '........',
        '........',
        '...#....',
      ]);

      // When: the last single lands in row 3
      final (next, events) = _playLast(board, at: const Cell(col: 6, row: 3));

      // Then
      expect(events.whereType<TideRose>(), hasLength(1));
      expect(next.board.at(const Cell(col: 3, row: 4)), isA<FilledCell>());
      expect(next.board.at(const Cell(col: 6, row: 2)), isA<FilledCell>());
      expect(next.board.at(const Cell(col: 3, row: 5)), isA<EmptyCell>());
      expect(events.last, isA<TrayRefilled>());
    });

    test('pushes in a bottom row of 6 stones, its 2 gaps drawn from the stones '
        'stream', () {
      // Given / When
      final (next, events) = _playLast(Board.empty());

      // Then
      final gaps = events.whereType<TideRose>().single.gapColumns;
      final bottom = [
        for (var col = 0; col < Board.size; col++)
          next.board.at(Cell(col: col, row: 7)),
      ];
      expect(gaps, hasLength(2));
      expect(bottom.whereType<StoneCell>(), hasLength(6));
      for (final col in gaps) {
        expect(bottom[col], isA<EmptyCell>());
      }
      expect(
        next.stonesRngState,
        isNot(_lastOfTray(Board.empty()).stonesRngState),
      );
      expect(_playLast(Board.empty()).$1.board, next.board);
    });

    test(
      'floods when the rise pushes anything off the top: no tray is dealt',
      () {
        for (final top in const ['.......#', '.......S', '.......F']) {
          // Given / When: the single lands clear of the top row
          final (next, events) = _playLast(
            boardFrom([top]),
            at: const Cell(col: 0, row: 4),
          );

          // Then
          expect(
            next.phase,
            const RunPhase.roundLost(reason: .flooded),
            reason: top,
          );
          expect(events.last, const GameEvent.roundLost(reason: .flooded));
          expect(events.whereType<TrayRefilled>(), isEmpty);
        }
      },
    );

    test('a risen row clears like any line once its gaps are filled, stones '
        'and all', () {
      // Given: the bottom row as a rise left it, one gap still open
      final state = _bossStart(tideConfig).$1.copyWith(
        board: boardFrom([
          '........',
          '........',
          '........',
          '........',
          '........',
          '........',
          '........',
          'SSS.SSSS',
        ]),
        tray: [0, 0, null],
        trayDealt: 3,
      );

      // When
      final (next, events) = place(
        state,
        anchor: const Cell(col: 3, row: 7),
        trayIndex: 0,
      );

      // Then
      expect(events.whereType<LinesCleared>().single.rows, [7]);
      expect(next.board.isEmpty, isTrue);
    });

    test('rises again for the tray a revive deals', () {
      // Given: out of pieces, with the revive still to spend
      final lost = _bossStart(tideConfig).$1.copyWith(
        phase: const .roundLost(reason: .outOfPieces),
        piecesLeft: 0,
        tray: [null, null, null],
      );

      // When
      final (next, events) = revive(lost);

      // Then
      expect(events.whereType<TideRose>(), hasLength(1));
      expect(next.phase, const RunPhase.playing());
      expect(
        next.board.at(const Cell(col: 0, row: 7)),
        isNot(isA<FilledCell>()),
      );
    });

    test('clears a column the rise completes at once: it scores nothing and '
        'leaves the clear streak as it was', () {
      // Given: columns 0 to 2 filled from row 1 down, more than the tide's 2
      // gaps can spare, column 7 a cell short, and a streak of 2
      final board = boardFrom([
        '.......#',
        for (var row = 1; row < Board.size - 1; row++) '###....#',
        '###.....',
      ]);
      final last = _lastOfTray(board).copyWith(streak: 2);

      // When: the last single completes column 7
      final (next, events) = place(
        last,
        anchor: const Cell(col: 7, row: 7),
        trayIndex: 0,
      );

      // Then
      final rose = events.whereType<TideRose>().single;
      final completed = [
        for (final col in const [0, 1, 2])
          if (!rose.gapColumns.contains(col)) col,
      ];
      final [byMove, cleared] = events.whereType<LinesCleared>().toList();
      final scored = events.whereType<ScoreAdded>().single;
      expect(byMove.cols, [7]);
      expect(cleared.source, ClearSource.tide);
      expect(cleared.cols, completed);
      expect(cleared.rows, isEmpty);
      expect(events.indexOf(cleared), events.indexOf(rose) + 1);
      for (final col in completed) {
        for (var row = 0; row < Board.size; row++) {
          expect(next.board.at(Cell(col: col, row: row)), isA<EmptyCell>());
        }
      }
      expect(next.score, last.score + scored.total);
      expect(next.streak, 3);
    });

    test('a run whose boss rose replays from its seed and moves to the same '
        'end', () {
      // Given: the bot's run of the first seed whose boss rose
      for (var seed = 1; seed <= 40; seed++) {
        var state = startRun(config: tideConfig, seed: seed);
        final moves = <RunMove>[];
        var rose = false;

        for (
          var move = greedyMove(state, build: const []);
          move != null;
          move = greedyMove(state, build: const [])
        ) {
          final (next, events) = applyMove(state, move);
          moves.add(move);
          rose = rose || events.any((event) => event is TideRose);
          state = next;
        }

        if (!rose) continue;

        // When
        final replayed = replay(config: tideConfig, moves: moves, seed: seed);

        // Then
        expect(replayed, state);

        return;
      }

      fail('no bot run reached a rise in 40 seeds');
    });
  });
}
