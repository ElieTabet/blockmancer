import 'package:blockmancer_engine/src/jokers/joker_catalog.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';
import 'package:blockmancer_engine/src/random/mulberry32.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:test/test.dart';

import '../brief_config.dart';
import '../play_move.dart';

final _tuning = briefConfig.jokers;

// Each joker alone, then with its partner. Shapes: 0 single, 1 horizontal
// domino, 3 horizontal three, 10 horizontal four.
void main() {
  const baseSetup = RoundSetup(pieces: 14, stones: 0);

  List<int> weightsOf(List<JokerId> jokers) =>
      pieceWeights(effectsOf(jokers), briefConfig.jokers);

  group('Stonemason', () {
    test('adds 50 chips per stone cleared', () {
      // Given / When
      final score = playMove(
        ['##S##S#.'],
        at: topRight,
        jokers: const [.stonemason],
        shape: 0,
      );

      // Then
      expect(score.chips, 80 + 100);
      expect(score.points, 1 + 180);
      expect(
        score.fired.single,
        const JokerFired(delta: .chipsAdded(amount: 100), joker: .stonemason),
      );
    });

    test('stays quiet when no stone is cleared', () {
      // Given / When
      final score = playMove(
        rowAlmostFull,
        at: topRight,
        jokers: const [.stonemason],
        shape: 0,
      );

      // Then
      expect(score.fired, isEmpty);
    });

    test('drops 2 more stones at the start of a round', () {
      // Given / When
      final setup = roundSetup(
        baseSetup,
        effectsOf(const [.stonemason]),
        _tuning,
      );

      // Then
      expect(setup.stones, 2);
    });

    test(
      'with Quarry, its stones are cleared for chips and Quarry drops a new one',
      () {
        // Given / When
        final score = playMove(
          ['##S##S#.'],
          at: topRight,
          jokers: const [.quarry, .stonemason],
          shape: 0,
        );

        // Then
        expect(score.points, 1 + 180);
        expect(score.stonesDropped, hasLength(1));
        expect(score.board.cells.whereType<StoneCell>(), hasLength(1));
        expect(score.fired.map((fired) => fired.joker), [
          JokerId.stonemason,
          JokerId.quarry,
        ]);
      },
    );
  });

  group('Combo King', () {
    test('adds streak − 1 mult on a third clear in a row', () {
      // Given / When
      final score = playMove(
        rowAlmostFull,
        at: topRight,
        jokers: const [.combo],
        previousStreak: 2,
        shape: 0,
      );

      // Then
      expect(score.mult, 3);
      expect(score.points, 1 + 240);
    });

    test('does nothing on the first clear of a streak', () {
      // Given / When
      final score = playMove(
        rowAlmostFull,
        at: topRight,
        jokers: const [.combo],
        shape: 0,
      );

      // Then
      expect(score.mult, 1);
      expect(score.fired, isEmpty);
    });

    test('with Collector, both add their mult', () {
      // Given / When
      final score = playMove(
        rowAlmostFull,
        at: topRight,
        jokers: const [.collector, .combo],
        previousStreak: 2,
        shape: 0,
      );

      // Then: 1 line + 2 streak + 1 for the two jokers owned
      expect(score.mult, 4);
      expect(score.points, 1 + 320);
    });
  });

  group('Patience', () {
    test('stores 2 mult on each move that clears nothing', () {
      // Given
      final first = playMove(
        const [],
        at: topLeft,
        jokers: const [.patience],
        shape: 0,
      );

      // When
      final second = playMove(
        const [],
        at: topLeft,
        jokers: const [.patience],
        shape: 0,
        storedMult: first.storedMult,
      );

      // Then
      expect(first.storedMult, 2);
      expect(second.storedMult, 4);
      expect(
        second.fired.single,
        const JokerFired(delta: .multStored(total: 4), joker: .patience),
      );
    });

    test('spends what it stored on the next clear, then starts over', () {
      // Given / When
      final score = playMove(
        rowAlmostFull,
        at: topRight,
        jokers: const [.patience],
        shape: 0,
        storedMult: 4,
      );

      // Then
      expect(score.mult, 1 + 4);
      expect(score.points, 1 + 400);
      expect(score.storedMult, 0);
    });

    test('with Twin Lines, the stored mult is tripled too', () {
      // Given / When
      final score = playMove(
        crossAlmostFull,
        at: topLeft,
        jokers: const [.patience, .twin],
        shape: 0,
        storedMult: 4,
      );

      // Then: (2 lines + 4 stored) × 3
      expect(score.mult, 18);
      expect(score.points, 1 + 150 * 18);
    });
  });

  group('Precision', () {
    test('adds 6 mult when a single completes a line', () {
      // Given / When
      final score = playMove(
        rowAlmostFull,
        at: topRight,
        jokers: const [.precision],
        shape: 0,
      );

      // Then
      expect(score.mult, 7);
      expect(score.points, 1 + 560);
    });

    test('adds 6 mult when a domino completes a line', () {
      // Given / When
      final score = playMove(
        ['######..'],
        at: const Cell(col: 6, row: 0),
        jokers: const [.precision],
        shape: 1,
      );

      // Then
      expect(score.points, 2 + 560);
    });

    test('ignores a three-cell piece', () {
      // Given / When
      final score = playMove(
        ['#####...'],
        at: const Cell(col: 5, row: 0),
        jokers: const [.precision],
        shape: 3,
      );

      // Then
      expect(score.mult, 1);
    });

    test(
      'with Tiny Tools, small pieces come more often and still score the bonus',
      () {
        // Given
        final jokers = const [JokerId.precision, JokerId.tiny];

        // When
        final score = playMove(
          rowAlmostFull,
          at: topRight,
          jokers: jokers,
          shape: 0,
        );
        final weights = weightsOf(jokers);

        // Then
        expect(score.mult, 7);
        expect(weights.take(3), [3, 3, 3]);
        expect(weights.skip(3).toSet(), {1});
      },
    );
  });

  group('Collector', () {
    test('adds nothing on its own: it counts jokers in twos', () {
      // Given / When
      final score = playMove(
        rowAlmostFull,
        at: topRight,
        jokers: const [.collector],
        shape: 0,
      );

      // Then
      expect(score.mult, 1);
      expect(score.points, 1 + 80);
      expect(score.fired, isEmpty);
    });

    test('adds 1 mult for every two jokers owned, itself included', () {
      // Given / When
      final three = playMove(
        rowAlmostFull,
        at: topRight,
        jokers: const [.collector, .saver, .tiny],
        shape: 0,
      );
      final four = playMove(
        rowAlmostFull,
        at: topRight,
        jokers: const [.collector, .saver, .tiny, .bigbox],
        shape: 0,
      );

      // Then: three jokers make one pair, four make two
      expect(three.mult, 2);
      expect(four.mult, 3);
    });

    test('with Combo King, counts both jokers as one pair', () {
      // Given / When
      final score = playMove(
        rowAlmostFull,
        at: topRight,
        jokers: const [.combo, .collector],
        shape: 0,
      );

      // Then: no streak yet, so only Collector's +1
      expect(score.mult, 2);
    });
  });

  group('Twin Lines', () {
    test('triples the mult when 2 lines clear at once', () {
      // Given / When
      final score = playMove(
        crossAlmostFull,
        at: topLeft,
        jokers: const [.twin],
        shape: 0,
      );

      // Then
      expect(score.mult, 6);
      expect(score.points, 1 + 900);
    });

    test('does nothing on a single line', () {
      // Given / When
      final score = playMove(
        rowAlmostFull,
        at: topRight,
        jokers: const [.twin],
        shape: 0,
      );

      // Then
      expect(score.mult, 1);
    });

    test('with Patience, a clear with nothing stored is only tripled', () {
      // Given / When
      final score = playMove(
        crossAlmostFull,
        at: topLeft,
        jokers: const [.twin, .patience],
        shape: 0,
      );

      // Then
      expect(score.mult, 6);
      expect(score.storedMult, 0);
    });
  });

  group('Column Hunter', () {
    test('doubles the mult when a column clears', () {
      // Given / When
      final score = playMove(
        columnAlmostFull,
        at: topLeft,
        jokers: const [.column],
        shape: 0,
      );

      // Then
      expect(score.mult, 2);
      expect(score.points, 1 + 160);
    });

    test('ignores a row', () {
      // Given / When
      final score = playMove(
        rowAlmostFull,
        at: topRight,
        jokers: const [.column],
        shape: 0,
      );

      // Then
      expect(score.mult, 1);
    });

    test('with Clean Sweep, a column that empties the board earns both', () {
      // Given / When
      final score = playMove(
        columnAlmostFull,
        at: topLeft,
        jokers: const [.column, .sweep],
        shape: 0,
      );

      // Then
      expect(score.points, 1 + 160 + 500);
    });
  });

  group('Heavyweight', () {
    test('doubles the mult when a four-cell piece completes a line', () {
      // Given / When
      final score = playMove(
        ['####....'],
        at: const Cell(col: 4, row: 0),
        jokers: const [.heavy],
        shape: 10,
      );

      // Then
      expect(score.mult, 2);
      expect(score.points, 4 + 160);
    });

    test('ignores a single', () {
      // Given / When
      final score = playMove(
        rowAlmostFull,
        at: topRight,
        jokers: const [.heavy],
        shape: 0,
      );

      // Then
      expect(score.mult, 1);
    });

    test('with Big Box, big pieces come more often and still double', () {
      // Given
      final jokers = const [JokerId.bigbox, JokerId.heavy];

      // When
      final score = playMove(
        ['####....'],
        at: const Cell(col: 4, row: 0),
        jokers: jokers,
        shape: 10,
      );
      final weights = weightsOf(jokers);

      // Then
      expect(score.mult, 2);
      expect(weights.skip(16), [3, 3, 3]);
      expect(weights.take(16).toSet(), {1});
    });

    test('ignores a three-cell piece', () {
      // Given / When
      final score = playMove(
        ['#####...'],
        at: const Cell(col: 5, row: 0),
        jokers: const [.heavy],
        shape: 3,
      );

      // Then
      expect(score.mult, 1);
    });
  });

  group('Clean Sweep', () {
    test('adds 500 points when a clear empties the board', () {
      // Given / When
      final score = playMove(
        rowAlmostFull,
        at: topRight,
        jokers: const [.sweep],
        shape: 0,
      );

      // Then
      expect(score.points, 1 + 80 + 500);
    });

    test('does nothing when the clear leaves cells behind', () {
      // Given / When
      final score = playMove(
        ['#######.', '#.......'],
        at: topRight,
        jokers: const [.sweep],
        shape: 0,
      );

      // Then
      expect(score.points, 1 + 80);
    });

    test(
      'with Column Hunter, a row that empties the board earns only the sweep',
      () {
        // Given / When
        final score = playMove(
          rowAlmostFull,
          at: topRight,
          jokers: const [.sweep, .column],
          shape: 0,
        );

        // Then
        expect(score.points, 1 + 80 + 500);
      },
    );

    test('does nothing when a stone is left on the board', () {
      // Given / When
      final score = playMove(
        ['#######.', '...S....'],
        at: topRight,
        jokers: const [.sweep],
        shape: 0,
      );

      // Then
      expect(score.bonusPoints, 0);
    });
  });

  group('Quarry', () {
    test('turns one empty cell to stone after a clear', () {
      // Given / When
      final score = playMove(
        rowAlmostFull,
        at: topRight,
        jokers: const [.quarry],
        shape: 0,
      );

      // Then
      final stone = score.stonesDropped.single;
      expect(score.board.at(stone), const CellState.stone());
      expect(score.stonesRng, isNot(const Mulberry32(1)));
    });

    test('drops nothing after a move that clears nothing', () {
      // Given / When
      final score = playMove(
        const [],
        at: topLeft,
        jokers: const [.quarry],
        shape: 0,
      );

      // Then
      expect(score.stonesDropped, isEmpty);
      expect(score.stonesRng, const Mulberry32(1));
    });

    test('runs after Clean Sweep, so the sweep still counts', () {
      // Given / When
      final score = playMove(
        rowAlmostFull,
        at: topRight,
        jokers: const [.quarry, .sweep],
        shape: 0,
      );

      // Then
      expect(score.points, 1 + 80 + 500);
      expect(score.board.cells.whereType<StoneCell>(), hasLength(1));
    });

    test('with Stonemason, starts the round with 2 extra stones', () {
      // Given / When
      final setup = roundSetup(
        baseSetup,
        effectsOf(const [.quarry, .stonemason]),
        _tuning,
      );

      // Then
      expect(setup.stones, 2);
    });

    test('never drops its stone into the last gap of a line', () {
      // Given: once row 0 clears, row 1 is one cell short of full
      // When
      final score = playMove(
        ['#######.', '#######.'],
        at: topRight,
        jokers: const [.quarry],
        shape: 0,
      );

      // Then
      expect(score.stonesDropped.single, isNot(const Cell(col: 7, row: 1)));
      expect(score.board.fullRows, isEmpty);
      expect(score.board.fullCols, isEmpty);
    });
  });

  group('Big Box', () {
    test('draws pieces of 5+ cells 3 times as often', () {
      // Given / When
      final weights = weightsOf(const [.bigbox]);

      // Then
      expect(weights, [...List.filled(16, 1), 3, 3, 3]);
    });

    test('with Heavyweight, the weights are unchanged', () {
      // Given / When / Then
      expect(weightsOf(const [.bigbox, .heavy]), weightsOf(const [.bigbox]));
    });
  });

  group('Tiny Tools', () {
    test('draws pieces of 1–2 cells 3 times as often', () {
      // Given / When
      final weights = weightsOf(const [.tiny]);

      // Then
      expect(weights, [3, 3, 3, ...List.filled(16, 1)]);
    });

    test('with Precision, the weights are unchanged', () {
      // Given / When / Then
      expect(weightsOf(const [.tiny, .precision]), weightsOf(const [.tiny]));
    });
  });

  group('Deep Pockets', () {
    test('adds 4 pieces to every round', () {
      // Given / When
      final setup = roundSetup(baseSetup, effectsOf(const [.pockets]), _tuning);

      // Then
      expect(setup.pieces, 18);
      expect(
        setup.fired.single,
        const JokerFired(delta: .piecesAdded(amount: 4), joker: .pockets),
      );
    });

    test('with Saver, the extra pieces become run points if unused', () {
      // Given
      final jokers = effectsOf(const [.pockets, .saver]);

      // When
      final setup = roundSetup(baseSetup, jokers, _tuning);
      final bonus = roundBonus(
        jokers,
        RoundWonContext(tuning: _tuning, unusedPieces: 4),
      );

      // Then
      expect(setup.pieces, 18);
      expect(bonus.runPoints, 160);
    });
  });

  group('Saver', () {
    test('gives 40 run points per unused piece when a round is won', () {
      // Given / When
      final bonus = roundBonus(
        effectsOf(const [.saver]),
        RoundWonContext(tuning: _tuning, unusedPieces: 5),
      );

      // Then
      expect(bonus.runPoints, 200);
      expect(
        bonus.fired.single,
        const JokerFired(delta: .runPointsAdded(amount: 200), joker: .saver),
      );
    });

    test('gives nothing when every piece was used', () {
      // Given / When
      final bonus = roundBonus(
        effectsOf(const [.saver]),
        RoundWonContext(tuning: _tuning, unusedPieces: 0),
      );

      // Then
      expect(bonus.runPoints, 0);
      expect(bonus.fired, isEmpty);
    });

    test('with Deep Pockets, still counts only the pieces left', () {
      // Given / When
      final bonus = roundBonus(
        effectsOf(const [.saver, .pockets]),
        RoundWonContext(tuning: _tuning, unusedPieces: 1),
      );

      // Then
      expect(bonus.runPoints, 40);
    });
  });

  group('Anchor', () {
    test('adds 4 mult when the move clears the bottom row', () {
      // Given / When
      final score = playMove(
        atBottom(['#######.']),
        at: bottomRight,
        jokers: const [.anchor],
        shape: 0,
      );

      // Then
      expect(score.mult, 1 + 4);
      expect(score.points, 1 + 80 * 5);
      expect(
        score.fired.single,
        const JokerFired(delta: .multAdded(amount: 4), joker: .anchor),
      );
    });

    test('stays quiet when the move clears another row', () {
      // Given / When
      final score = playMove(
        rowAlmostFull,
        at: topRight,
        jokers: const [.anchor],
        shape: 0,
      );

      // Then
      expect(score.mult, 1);
      expect(score.fired, isEmpty);
    });

    test('stays quiet when a column clears through the bottom row', () {
      // Given / When
      final score = playMove(
        columnAlmostFull,
        at: topLeft,
        jokers: const [.anchor],
        shape: 0,
      );

      // Then
      expect(score.fired, isEmpty);
    });

    test('with Avalanche, both fire on a bottom clear, Anchor first', () {
      // Given / When: 4 cells stay in row 6 once row 7 clears
      final score = playMove(
        atBottom(['####....', '#######.']),
        at: bottomRight,
        jokers: const [.avalanche, .anchor],
        shape: 0,
      );

      // Then
      expect(score.chips, 80 + 4 * 25);
      expect(score.mult, 1 + 4);
      expect(score.points, 1 + 180 * 5);
      expect(score.fired, const [
        JokerFired(delta: .multAdded(amount: 4), joker: .anchor),
        JokerFired(delta: .chipsAdded(amount: 100), joker: .avalanche),
      ]);
    });
  });

  group('Avalanche', () {
    test('adds 25 chips per filled cell left in the two bottom rows', () {
      // Given / When: row 6 keeps 3 cells once row 7 clears
      final score = playMove(
        atBottom(['###.....', '#######.']),
        at: bottomRight,
        jokers: const [.avalanche],
        shape: 0,
      );

      // Then
      expect(score.chips, 80 + 3 * 25);
      expect(score.points, 1 + 155);
      expect(
        score.fired.single,
        const JokerFired(delta: .chipsAdded(amount: 75), joker: .avalanche),
      );
    });

    test('counts neither the rows above nor stones', () {
      // Given / When: row 5 is out of reach, row 6 holds 2 cells and a stone
      final score = playMove(
        atBottom(['####....', '##S.....', '#######.']),
        at: bottomRight,
        jokers: const [.avalanche],
        shape: 0,
      );

      // Then
      expect(score.chips, 80 + 2 * 25);
    });

    test('counts after the clear, so emptied rows earn nothing', () {
      // Given / When: a vertical domino clears rows 6 and 7
      final score = playMove(
        atBottom(['#######.', '#######.']),
        at: const Cell(col: 7, row: 6),
        jokers: const [.avalanche],
        shape: 2,
      );

      // Then
      expect(score.chips, 160);
      expect(score.fired, isEmpty);
    });

    test('does nothing on a move that clears nothing', () {
      // Given / When
      final score = playMove(
        atBottom(['###.....', '###.....']),
        at: bottomRight,
        jokers: const [.avalanche],
        shape: 0,
      );

      // Then
      expect(score.chips, 0);
      expect(score.fired, isEmpty);
    });

    test('with Anchor, a clear above the bottom row earns only its chips', () {
      // Given / When: row 0 clears, row 7 keeps 2 cells
      final score = playMove(
        ['#######.', ...List.filled(6, '........'), '##......'],
        at: topRight,
        jokers: const [.anchor, .avalanche],
        shape: 0,
      );

      // Then
      expect(score.chips, 80 + 2 * 25);
      expect(score.mult, 1);
      expect(score.fired.map((fired) => fired.joker), [JokerId.avalanche]);
    });
  });

  group('Full House', () {
    test('adds 1 mult per 6 occupied cells, counted before the clear', () {
      // Given / When: 7 + the single in row 0, and 5 in row 1, make 13
      final score = playMove(
        ['#######.', '#####...'],
        at: topRight,
        jokers: const [.fullhouse],
        shape: 0,
      );

      // Then
      expect(score.mult, 1 + 2);
      expect(score.points, 1 + 80 * 3);
      expect(
        score.fired.single,
        const JokerFired(delta: .multAdded(amount: 2), joker: .fullhouse),
      );
    });

    test('counts stones as occupied cells', () {
      // Given / When: row 1 holds 3 filled cells and 2 stones
      final score = playMove(
        ['#######.', '###SS...'],
        at: topRight,
        jokers: const [.fullhouse],
        shape: 0,
      );

      // Then
      expect(score.mult, 1 + 2);
    });

    test('does nothing on a move that clears nothing', () {
      // Given / When
      final score = playMove(
        ['######..', '#####...'],
        at: topRight,
        jokers: const [.fullhouse],
        shape: 0,
      );

      // Then
      expect(score.mult, 0);
      expect(score.fired, isEmpty);
    });

    test('with On the Brink, a crowded board adds first, then doubles', () {
      // Given / When: 8 in row 0 and 7 in each of rows 1 to 5 make 43
      final score = playMove(
        ['#######.', ...List.filled(5, '#######.')],
        at: topRight,
        jokers: const [.brink, .fullhouse],
        shape: 0,
      );

      // Then
      expect(score.mult, (1 + 7) * 2);
      expect(score.points, 1 + 80 * 16);
      expect(score.fired, const [
        JokerFired(delta: .multAdded(amount: 7), joker: .fullhouse),
        JokerFired(delta: .multMultiplied(factor: 2), joker: .brink),
      ]);
    });
  });

  group('On the Brink', () {
    // 8 in row 0 once the single lands, 7 in each of rows 1 to 4, and row 5.
    List<String> crowded(String row5) => [
      '#######.',
      ...List.filled(4, '#######.'),
      row5,
    ];

    test('doubles the mult at 40 occupied cells, counted before the clear', () {
      // Given / When
      final score = playMove(
        crowded('####....'),
        at: topRight,
        jokers: const [.brink],
        shape: 0,
      );

      // Then
      expect(score.mult, 2);
      expect(score.points, 1 + 160);
      expect(
        score.fired.single,
        const JokerFired(delta: .multMultiplied(factor: 2), joker: .brink),
      );
    });

    test('stays quiet one cell short, at 39', () {
      // Given / When
      final score = playMove(
        crowded('###.....'),
        at: topRight,
        jokers: const [.brink],
        shape: 0,
      );

      // Then
      expect(score.mult, 1);
      expect(score.fired, isEmpty);
    });

    test('counts stones as occupied cells', () {
      // Given / When
      final score = playMove(
        crowded('SS##....'),
        at: topRight,
        jokers: const [.brink],
        shape: 0,
      );

      // Then
      expect(score.mult, 2);
    });

    test('fires nothing on a crowded board when the move clears nothing', () {
      // Given / When: 41 occupied once the single lands, no line full
      final score = playMove(
        ['######..', ...List.filled(5, '#######.')],
        at: const Cell(col: 6, row: 0),
        jokers: const [.brink, .fullhouse],
        shape: 0,
      );

      // Then
      expect(score.mult, 0);
      expect(score.fired, isEmpty);
    });

    test('with Full House, a sparse board earns only Full House', () {
      // Given / When: 8 in row 0 make 1 mult, far short of 40
      final score = playMove(
        rowAlmostFull,
        at: topRight,
        jokers: const [.brink, .fullhouse],
        shape: 0,
      );

      // Then
      expect(score.mult, 1 + 1);
      expect(score.fired.map((fired) => fired.joker), [JokerId.fullhouse]);
    });
  });

  group('Finisher', () {
    test('doubles the mult when the move plays the last piece in the tray', () {
      // Given / When
      final score = playMove(
        rowAlmostFull,
        at: topRight,
        jokers: const [.finisher],
        shape: 0,
        trayEmptied: true,
      );

      // Then
      expect(score.mult, 2);
      expect(score.points, 1 + 160);
      expect(
        score.fired.single,
        const JokerFired(delta: .multMultiplied(factor: 2), joker: .finisher),
      );
    });

    test('stays quiet while pieces are left in the tray', () {
      // Given / When
      final score = playMove(
        rowAlmostFull,
        at: topRight,
        jokers: const [.finisher],
        shape: 0,
      );

      // Then
      expect(score.mult, 1);
      expect(score.fired, isEmpty);
    });

    test('fires nothing when the last piece clears nothing', () {
      // Given / When
      final score = playMove(
        ['######..'],
        at: topRight,
        jokers: const [.finisher],
        shape: 0,
        trayEmptied: true,
      );

      // Then
      expect(score.mult, 0);
      expect(score.points, 1);
      expect(score.fired, isEmpty);
    });

    test('with Hat Trick, a tray cleared by every piece doubles and pays', () {
      // Given / When
      final score = playMove(
        rowAlmostFull,
        at: topRight,
        jokers: const [.finisher, .hattrick],
        shape: 0,
        trayClearMask: 0x7,
        trayEmptied: true,
      );

      // Then
      expect(score.points, 1 + 160 + 300);
      expect(score.fired, const [
        JokerFired(delta: .multMultiplied(factor: 2), joker: .finisher),
        JokerFired(delta: .pointsAdded(amount: 300), joker: .hattrick),
      ]);
    });
  });

  group('Hat Trick', () {
    test('adds 300 points when every piece of a full tray cleared', () {
      // Given / When
      final score = playMove(
        rowAlmostFull,
        at: topRight,
        jokers: const [.hattrick],
        shape: 0,
        trayClearMask: 0x7,
        trayEmptied: true,
      );

      // Then
      expect(score.bonusPoints, 300);
      expect(score.points, 1 + 80 + 300);
    });

    test('stays quiet when one piece of the tray cleared nothing', () {
      // Given / When
      final score = playMove(
        rowAlmostFull,
        at: topRight,
        jokers: const [.hattrick],
        shape: 0,
        trayClearMask: 0x5,
        trayEmptied: true,
      );

      // Then
      expect(score.fired, isEmpty);
    });

    test('stays quiet for a tray that cannot earn it', () {
      // Given / When: no mask, as for a short or a revive's tray
      final score = playMove(
        rowAlmostFull,
        at: topRight,
        jokers: const [.hattrick],
        shape: 0,
        trayEmptied: true,
      );

      // Then
      expect(score.fired, isEmpty);
    });

    test('with Finisher, a tray that missed a clear still gets the double', () {
      // Given / When
      final score = playMove(
        rowAlmostFull,
        at: topRight,
        jokers: const [.finisher, .hattrick],
        shape: 0,
        trayClearMask: 0x3,
        trayEmptied: true,
      );

      // Then
      expect(score.points, 1 + 160);
      expect(score.fired.map((fired) => fired.joker), [JokerId.finisher]);
    });
  });

  group('catalog', () {
    test('holds every joker exactly once', () {
      // Given / When
      final ids = jokerCatalog.map((joker) => joker.id);

      // Then
      expect(ids.toSet(), JokerId.values.toSet());
      expect(ids, hasLength(JokerId.values.length));
    });

    test('pairs every joker with a partner that pairs back', () {
      // Given / When / Then
      for (final joker in jokerCatalog) {
        expect(jokerEffect(joker.partner).partner, joker.id);
      }
    });
  });
}
