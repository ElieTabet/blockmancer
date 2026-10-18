import 'package:blockmancer_engine/src/board/placement.br.dart';
import 'package:blockmancer_engine/src/jokers/joker_catalog.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';
import 'package:blockmancer_engine/src/random/mulberry32.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:test/test.dart';

import '../board_picture.dart';
import '../play_move.dart';
import '../tuned_config.dart';

// Each joker under tunedConfig, where every number is off its default. Chips
// are 20 per cleared cell. Shapes: 0 single, 2 vertical domino, 4 vertical
// three, 10 horizontal four, 17 horizontal five.
void main() {
  const baseSetup = RoundSetup(pieces: 14, stones: 0);
  const fourGap = Cell(col: 4, row: 0);
  const fiveGap = Cell(col: 3, row: 0);

  test('a cleared cell scores the configured chips', () {
    // Given / When
    final score = playMove(
      rowAlmostFull,
      at: topRight,
      config: tunedConfig,
      shape: 0,
    );

    // Then
    expect(score.chips, 8 * 20);
    expect(score.points, 1 + 160);
  });

  group('Stonemason', () {
    test('adds its configured chips per stone cleared', () {
      // Given / When
      final score = playMove(
        ['##S##S#.'],
        at: topRight,
        config: tunedConfig,
        jokers: const [.stonemason],
        shape: 0,
      );

      // Then
      expect(score.chips, 160 + 2 * 80);
      expect(
        score.fired.single,
        const JokerFired(delta: .chipsAdded(amount: 160), joker: .stonemason),
      );
    });

    test('drops its configured number of extra stones', () {
      // Given / When
      final setup = roundSetup(
        baseSetup,
        effectsOf(const [.stonemason]),
        tunedJokers,
      );

      // Then
      expect(setup.stones, 7);
    });
  });

  test('Combo King adds its configured mult per earlier clear', () {
    // Given / When
    final score = playMove(
      rowAlmostFull,
      at: topRight,
      config: tunedConfig,
      jokers: const [.combo],
      previousStreak: 2,
      shape: 0,
    );

    // Then
    expect(score.mult, 1 + 2 * 10);
  });

  test('Patience banks its configured mult on a move that clears nothing', () {
    // Given / When
    final score = playMove(
      const [],
      at: topLeft,
      config: tunedConfig,
      jokers: const [.patience],
      shape: 0,
    );

    // Then
    expect(score.storedMult, 16);
    expect(
      score.fired.single,
      const JokerFired(delta: .multStored(total: 16), joker: .patience),
    );
  });

  group('Precision', () {
    test('adds its configured mult for a piece at its size limit', () {
      // Given / When
      final score = playMove(
        ['####....'],
        at: fourGap,
        config: tunedConfig,
        jokers: const [.precision],
        shape: 10,
      );

      // Then
      expect(score.mult, 1 + 18);
    });

    test('stays quiet for a piece one cell over its size limit', () {
      // Given / When
      final score = playMove(
        ['###.....'],
        at: fiveGap,
        config: tunedConfig,
        jokers: const [.precision],
        shape: 17,
      );

      // Then
      expect(score.mult, 1);
      expect(score.fired, isEmpty);
    });
  });

  test('Collector adds its configured mult for every two jokers owned', () {
    // Given / When
    final score = playMove(
      rowAlmostFull,
      at: topRight,
      config: tunedConfig,
      jokers: const [.collector, .column],
      shape: 0,
    );

    // Then: Column Hunter owned but quiet, no column cleared
    expect(score.mult, 1 + 1 * 8);
  });

  group('Twin Lines', () {
    test('multiplies by its configured factor at its line count', () {
      // Given / When
      final score = playMove(
        ['#######.', '#######.', '#######.'],
        at: topRight,
        config: tunedConfig,
        jokers: const [.twin],
        shape: 4,
      );

      // Then
      expect(score.mult, 3 * 13);
    });

    test('stays quiet one line short of its line count', () {
      // Given / When
      final score = playMove(
        ['#######.', '#######.'],
        at: topRight,
        config: tunedConfig,
        jokers: const [.twin],
        shape: 2,
      );

      // Then
      expect(score.mult, 2);
      expect(score.fired, isEmpty);
    });
  });

  test('Column Hunter multiplies by its configured factor', () {
    // Given / When
    final score = playMove(
      columnAlmostFull,
      at: topLeft,
      config: tunedConfig,
      jokers: const [.column],
      shape: 0,
    );

    // Then
    expect(score.mult, 11);
  });

  group('Heavyweight', () {
    test('multiplies by its configured factor for a piece at its size', () {
      // Given / When
      final score = playMove(
        ['###.....'],
        at: fiveGap,
        config: tunedConfig,
        jokers: const [.heavy],
        shape: 17,
      );

      // Then
      expect(score.mult, 12);
    });

    test('stays quiet for a piece one cell under its size', () {
      // Given / When
      final score = playMove(
        ['####....'],
        at: fourGap,
        config: tunedConfig,
        jokers: const [.heavy],
        shape: 10,
      );

      // Then
      expect(score.mult, 1);
      expect(score.fired, isEmpty);
    });
  });

  test('Clean Sweep adds its configured points for an empty board', () {
    // Given / When
    final score = playMove(
      rowAlmostFull,
      at: topRight,
      config: tunedConfig,
      jokers: const [.sweep],
      shape: 0,
    );

    // Then
    expect(score.bonusPoints, 900);
    expect(score.points, 1 + 160 + 900);
  });

  group('Quarry', () {
    test('turns its configured number of different cells to stone', () {
      // Given / When
      final score = playMove(
        rowAlmostFull,
        at: topRight,
        config: tunedConfig,
        jokers: const [.quarry],
        shape: 0,
      );

      // Then
      expect(score.stonesDropped, hasLength(2));
      expect(score.stonesDropped.toSet(), hasLength(2));
      expect(score.board.cells.whereType<StoneCell>(), hasLength(2));
    });

    test('drops the same cells every time for the same stones stream', () {
      // Given
      List<Cell> dropped() => playMove(
        rowAlmostFull,
        at: topRight,
        config: tunedConfig,
        jokers: const [.quarry],
        shape: 0,
      ).stonesDropped;

      // When / Then
      expect(dropped(), dropped());
    });

    test('stops once the board has no empty cell left', () {
      // Given: three stones to drop, a single empty cell
      final board = boardFrom([...List.filled(7, '########'), '#######.']);
      final move = MoveContext(
        clear: resolveClears(boardFrom(['########'])),
        jokerCount: 1,
        pieceSize: 1,
        storedMult: 0,
        streak: 1,
        trayClearMask: null,
        trayEmptied: false,
        traySize: 3,
        tuning: tunedJokers.copyWith(quarryStonesPerClear: 3),
      );

      // When
      final after = jokerEffect(.quarry).afterMove(
        AfterMove(board: board, stonesRng: const Mulberry32(1), storedMult: 0),
        move,
      );

      // Then
      expect(after.stonesDropped, [const Cell(col: 7, row: 7)]);
      expect(after.board.emptyCells, isEmpty);
    });
  });

  test('Big Box weighs only pieces of its size by its factor', () {
    // Given / When: only the 9-cell square reaches its size, not the fives
    final weights = pieceWeights(effectsOf(const [.bigbox]), tunedJokers);

    // Then
    expect(weights, [...List.filled(16, 1), 15, 1, 1]);
  });

  test('Tiny Tools weighs only pieces within its size by its factor', () {
    // Given / When: the single is within its size, the dominoes are not
    final weights = pieceWeights(effectsOf(const [.tiny]), tunedJokers);

    // Then
    expect(weights, [14, ...List.filled(18, 1)]);
  });

  test('Deep Pockets adds its configured pieces to every round', () {
    // Given / When
    final setup = roundSetup(
      baseSetup,
      effectsOf(const [.pockets]),
      tunedJokers,
    );

    // Then
    expect(setup.pieces, 14 + 17);
  });

  group('Anchor', () {
    test('adds its configured mult when the bottom row clears', () {
      // Given / When
      final score = playMove(
        atBottom(['#######.']),
        at: bottomRight,
        config: tunedConfig,
        jokers: const [.anchor],
        shape: 0,
      );

      // Then
      expect(score.mult, 1 + 19);
    });

    test('stays quiet when another row clears', () {
      // Given / When
      final score = playMove(
        rowAlmostFull,
        at: topRight,
        config: tunedConfig,
        jokers: const [.anchor],
        shape: 0,
      );

      // Then
      expect(score.fired, isEmpty);
    });
  });

  test('Avalanche adds its configured chips per cell left in its configured '
      'bottom rows', () {
    // Given / When: rows 2 and 6 keep 4 cells once row 7 clears, both within
    // the bottom 6
    final score = playMove(
      atBottom([
        '#.......',
        '........',
        '........',
        '........',
        '###.....',
        '#######.',
      ]),
      at: bottomRight,
      config: tunedConfig,
      jokers: const [.avalanche],
      shape: 0,
    );

    // Then
    expect(score.chips, 160 + 4 * 21);
  });

  test('Full House adds its configured mult per its configured occupied '
      'cells', () {
    // Given / When: 8 in row 0 make 2 blocks of 3 cells, 24 mult each
    final score = playMove(
      rowAlmostFull,
      at: topRight,
      config: tunedConfig,
      jokers: const [.fullhouse],
      shape: 0,
    );

    // Then
    expect(score.mult, 1 + 2 * 24);
  });

  test('Ember adds its configured mult, then multiplies by its configured '
      'factor', () {
    // Given / When
    final score = playMove(
      ['###S###.'],
      at: topRight,
      config: tunedConfig,
      jokers: const [.ember],
      shape: 0,
    );

    // Then
    expect(score.mult, (1 + 25) * 26);
  });

  test('Sprinter adds its configured mult', () {
    // Given / When
    final score = playMove(
      rowAlmostFull,
      at: topRight,
      config: tunedConfig,
      firstOfTray: true,
      jokers: const [.sprinter],
      shape: 0,
    );

    // Then
    expect(score.mult, 1 + 29);
  });

  test('Momentum adds its configured mult per tray of its streak', () {
    // Given / When
    final score = playMove(
      rowAlmostFull,
      at: topRight,
      config: tunedConfig,
      jokers: const [.momentum],
      momentumStreak: 3,
      shape: 0,
    );

    // Then
    expect(score.mult, 1 + 3 * 27);
  });

  test('Symmetry adds its configured mult and Prism its configured chips', () {
    // Given / When
    final score = playMove(
      ['#######.', '##....##'],
      at: topRight,
      config: tunedConfig,
      jokers: const [.symmetry, .prism],
      shape: 0,
    );

    // Then
    expect(score.mult, 1 + 31);
    expect(score.chips, 8 * 20 + 4 * 28);
  });

  group('On the Brink', () {
    test('multiplies by its factor at its configured occupied cells', () {
      // Given / When: 8 in row 0, 7 in row 1 and 5 in row 2 make 20
      final score = playMove(
        ['#######.', '#######.', '#####...'],
        at: topRight,
        config: tunedConfig,
        jokers: const [.brink],
        shape: 0,
      );

      // Then
      expect(score.mult, 22);
    });

    test('stays quiet one cell short of its occupied cells', () {
      // Given / When
      final score = playMove(
        ['#######.', '#######.', '####....'],
        at: topRight,
        config: tunedConfig,
        jokers: const [.brink],
        shape: 0,
      );

      // Then
      expect(score.mult, 1);
    });
  });

  test('Finisher multiplies by its configured factor', () {
    // Given / When
    final score = playMove(
      rowAlmostFull,
      at: topRight,
      config: tunedConfig,
      jokers: const [.finisher],
      shape: 0,
      trayEmptied: true,
    );

    // Then
    expect(score.mult, 23);
  });

  test('Hat Trick adds its configured points', () {
    // Given / When
    final score = playMove(
      rowAlmostFull,
      at: topRight,
      config: tunedConfig,
      jokers: const [.hattrick],
      shape: 0,
      trayClearMask: 0x7,
      trayEmptied: true,
    );

    // Then
    expect(score.bonusPoints, 950);
  });

  test('Saver gives its configured run points per unused piece', () {
    // Given / When
    final bonus = roundBonus(
      effectsOf(const [.saver]),
      const RoundWonContext(tuning: tunedJokers, unusedPieces: 3),
    );

    // Then
    expect(bonus.runPoints, 3 * 70);
  });
}
