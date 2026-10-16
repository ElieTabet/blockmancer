import 'package:blockmancer_engine/src/jokers/joker_catalog.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';
import 'package:blockmancer_engine/src/random/mulberry32.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:test/test.dart';

import '../play_move.dart';

// Each joker alone, then with its partner. Shapes: 0 single, 1 horizontal
// domino, 3 horizontal three, 10 horizontal four.
void main() {
  const baseSetup = RoundSetup(pieces: 14, stones: 0);

  List<int> weightsOf(List<JokerId> jokers) => pieceWeights(effectsOf(jokers));

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
      final setup = roundSetup(baseSetup, effectsOf(const [.stonemason]));

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

      // Then: 1 line + 2 streak + 2 jokers owned
      expect(score.mult, 5);
      expect(score.points, 1 + 400);
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
    test('adds 1 mult per joker owned, itself included', () {
      // Given / When
      final score = playMove(
        rowAlmostFull,
        at: topRight,
        jokers: const [.collector],
        shape: 0,
      );

      // Then
      expect(score.mult, 2);
      expect(score.points, 1 + 160);
    });

    test('with Combo King, counts both jokers', () {
      // Given / When
      final score = playMove(
        rowAlmostFull,
        at: topRight,
        jokers: const [.combo, .collector],
        shape: 0,
      );

      // Then: no streak yet, so only Collector's +2
      expect(score.mult, 3);
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
      final setup = roundSetup(baseSetup, effectsOf(const [.pockets]));

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
      final setup = roundSetup(baseSetup, jokers);
      final bonus = roundBonus(jokers, const RoundWonContext(unusedPieces: 4));

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
        const RoundWonContext(unusedPieces: 5),
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
        const RoundWonContext(unusedPieces: 0),
      );

      // Then
      expect(bonus.runPoints, 0);
      expect(bonus.fired, isEmpty);
    });

    test('with Deep Pockets, still counts only the pieces left', () {
      // Given / When
      final bonus = roundBonus(
        effectsOf(const [.saver, .pockets]),
        const RoundWonContext(unusedPieces: 1),
      );

      // Then
      expect(bonus.runPoints, 40);
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
