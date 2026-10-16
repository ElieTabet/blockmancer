import 'package:blockmancer_engine/blockmancer_engine.dart';
import 'package:test/test.dart';

import '../board_picture.dart';
import '../play_move.dart';

const _seed = 20261016;
const _config = RunConfig();

/// A run in its first round, having started with [joker].
RunState _playing({JokerId joker = .twin}) {
  final start = startRun(config: _config, seed: _seed);
  final (state, _) = pickJoker(
    start.copyWith(phase: .pickingJoker(offers: [joker])),
    joker,
  );

  return state;
}

/// Shape ids: 0 single, 9 two-by-two square, 16 three-by-three.
void main() {
  group('starting a run', () {
    test('offers three different jokers and nothing is owned yet', () {
      // Given / When
      final state = startRun(config: _config, seed: _seed);

      // Then
      final offers = (state.phase as PickingJokerPhase).offers;
      expect(offers.toSet(), hasLength(3));
      expect(state.jokers, isEmpty);
    });

    test('the same seed offers the same jokers', () {
      // Given / When
      final first = startRun(config: _config, seed: _seed);
      final again = startRun(config: _config, seed: _seed);

      // Then
      expect(again, first);
    });

    test('picking the starting joker starts round 1 with a full tray', () {
      // Given
      final start = startRun(
        config: _config,
        seed: _seed,
      ).copyWith(phase: const .pickingJoker(offers: [.combo, .twin, .saver]));

      // When
      final (state, events) = pickJoker(start, .twin);

      // Then
      expect(state.phase, const RunPhase.playing());
      expect(state.jokers, [JokerId.twin]);
      expect(state.roundIndex, 0);
      expect(state.tray.whereType<int>(), hasLength(3));
      expect(state.piecesLeft, 14 - 3);
      expect(
        events.first,
        const GameEvent.roundStarted(pieces: 14, roundIndex: 0, target: 250),
      );
      expect(events.last, isA<TrayRefilled>());
    });

    test('a joker that is not on offer cannot be picked', () {
      // Given
      final start = startRun(config: _config, seed: _seed);

      // When / Then
      expect(
        () => pickJoker(
          start.copyWith(phase: const .pickingJoker(offers: [.twin])),
          .combo,
        ),
        throwsArgumentError,
      );
    });

    test('no joker can be picked while playing', () {
      // Given
      final state = _playing();

      // When / Then
      expect(() => pickJoker(state, .combo), throwsStateError);
    });

    test('starting with Stonemason drops 2 stones on the board', () {
      // Given / When
      final state = _playing(joker: .stonemason);

      // Then
      expect(state.board.cells.whereType<StoneCell>(), hasLength(2));
    });

    test('starting with Deep Pockets gives the round 4 more pieces', () {
      // Given / When
      final state = _playing(joker: .pockets);

      // Then
      expect(state.piecesRemaining, 18);
    });

    test(
      'the starting joker does not change the round’s pieces unless it weighs them',
      () {
        // Given / When
        final withTwin = _playing();
        final withCombo = _playing(joker: .combo);

        // Then
        expect(withCombo.tray, withTwin.tray);
      },
    );
  });

  group('placing', () {
    test('a piece that does not fit is refused', () {
      // Given
      final state = _playing().copyWith(
        board: boardFrom(['#.......']),
        tray: [0, null, null],
      );

      // When / Then
      expect(canPlace(state, 0, topLeft), isFalse);
      expect(
        () => place(state, anchor: topLeft, trayIndex: 0),
        throwsArgumentError,
      );
    });

    test('an empty tray slot cannot be placed', () {
      // Given
      final state = _playing().copyWith(tray: [0, null, null]);

      // When / Then
      expect(canPlace(state, 1, topLeft), isFalse);
      expect(canPlace(state, 3, topLeft), isFalse);
    });

    test('a placed piece leaves its tray slot empty and scores its size', () {
      // Given
      final state = _playing().copyWith(tray: [9, 0, 0]);

      // When
      final (next, events) = place(state, anchor: topLeft, trayIndex: 0);

      // Then
      expect(next.tray, [null, 0, 0]);
      expect(next.score, 4);
      expect(next.board.at(topLeft), isA<FilledCell>());
      expect(events.first, isA<PiecePlaced>());
      expect(
        events,
        contains(const GameEvent.scoreAdded(chips: 0, mult: 0, total: 4)),
      );
    });

    test('the last tray piece played draws the next three', () {
      // Given
      final state = _playing().copyWith(piecesLeft: 5, tray: [null, null, 0]);

      // When
      final (next, events) = place(state, anchor: topLeft, trayIndex: 2);

      // Then
      expect(next.tray.whereType<int>(), hasLength(3));
      expect(next.piecesLeft, 2);
      expect(events.whereType<TrayRefilled>(), hasLength(1));
    });

    test('fewer than three pieces left draws only those', () {
      // Given
      final state = _playing().copyWith(piecesLeft: 2, tray: [null, null, 0]);

      // When
      final (next, _) = place(state, anchor: topLeft, trayIndex: 2);

      // Then
      expect(next.tray.whereType<int>(), hasLength(2));
      expect(next.tray.last, isNull);
      expect(next.piecesLeft, 0);
    });

    test('a clear reports its lines, then its score', () {
      // Given
      final state = _playing().copyWith(
        board: boardFrom(rowAlmostFull),
        tray: [0, 0, 0],
      );

      // When
      final (_, events) = place(state, anchor: topRight, trayIndex: 0);

      // Then
      expect(events[1], isA<LinesCleared>());
      expect(
        events[2],
        const GameEvent.scoreAdded(chips: 80, mult: 1, total: 81),
      );
    });
  });

  group('winning a round', () {
    test('reaching the target banks the score and offers jokers not owned', () {
      // Given
      final state = _playing().copyWith(
        board: boardFrom(rowAlmostFull),
        score: 200,
        tray: [0, 0, 0],
      );

      // When
      final (next, events) = place(state, anchor: topRight, trayIndex: 0);

      // Then
      final offers = (next.phase as PickingJokerPhase).offers;
      expect(offers, hasLength(3));
      expect(offers, isNot(contains(JokerId.twin)));
      expect(next.runTotal, 281);
      expect(
        events,
        contains(const GameEvent.roundWon(bonus: 0, roundIndex: 0, score: 281)),
      );
      expect(events.last, OffersPresented(offers: offers));
    });

    test('the next pick starts round 2 with its own target and pieces', () {
      // Given
      final state = _playing().copyWith(
        board: boardFrom(rowAlmostFull),
        score: 200,
        tray: [0, 0, 0],
      );
      final (won, _) = place(state, anchor: topRight, trayIndex: 0);
      final offer = (won.phase as PickingJokerPhase).offers.first;

      // When
      final (next, events) = pickJoker(won, offer);

      // Then
      expect(next.roundIndex, 1);
      expect(next.score, 0);
      expect(next.board.isEmpty, isTrue);
      expect(next.piecesRemaining, 16);
      expect(next.runTotal, 281);
      expect(
        events.first,
        const GameEvent.roundStarted(pieces: 16, roundIndex: 1, target: 500),
      );
    });

    test('Saver turns the pieces left into run points', () {
      // Given: 2 tray pieces and 5 undrawn are left after the move
      final state = _playing(joker: .saver).copyWith(
        board: boardFrom(rowAlmostFull),
        piecesLeft: 5,
        score: 200,
        tray: [0, 0, 0],
      );

      // When
      final (next, events) = place(state, anchor: topRight, trayIndex: 0);

      // Then
      expect(next.runTotal, 281 + 7 * 40);
      expect(
        events,
        contains(
          const GameEvent.jokerFired(
            delta: .runPointsAdded(amount: 280),
            joker: .saver,
          ),
        ),
      );
    });

    test('beating the boss wins the run', () {
      // Given
      final state = _playing().copyWith(
        board: boardFrom(rowAlmostFull),
        roundIndex: 4,
        runTotal: 3000,
        score: 1950,
        tray: [0, 0, 0],
      );

      // When
      final (next, events) = place(state, anchor: topRight, trayIndex: 0);

      // Then
      expect(next.phase, const RunPhase.won());
      expect(next.runTotal, 3000 + 2031);
      expect(events.last, const GameEvent.runWon(total: 5031));
    });

    test('the boss round starts with 6 stones', () {
      // Given
      final beforeBoss = _playing().copyWith(
        phase: const .pickingJoker(offers: [.combo]),
        pickIndex: 4,
      );

      // When
      final (boss, _) = pickJoker(beforeBoss, .combo);

      // Then
      expect(boss.round.isBoss, isTrue);
      expect(boss.board.cells.whereType<StoneCell>(), hasLength(6));
    });
  });

  group('losing a round', () {
    test('playing the last piece short of the target is out of pieces', () {
      // Given
      final state = _playing().copyWith(piecesLeft: 0, tray: [0, null, null]);

      // When
      final (next, events) = place(state, anchor: topLeft, trayIndex: 0);

      // Then
      expect(next.phase, const RunPhase.roundLost(reason: .outOfPieces));
      expect(events.last, const GameEvent.roundLost(reason: .outOfPieces));
    });

    test('a tray whose pieces fit nowhere is no room', () {
      // Given: isolated holes, two per row and per column, so filling one
      // completes no line and the square fits nowhere
      final state = _playing().copyWith(
        board: boardFrom([
          '.#.#####',
          '#.#.####',
          '##.#.###',
          '###.#.##',
          '####.#.#',
          '#####.#.',
          '.#####.#',
          '#.#####.',
        ]),
        tray: [0, 9, null],
      );

      // When
      final (next, _) = place(state, anchor: topLeft, trayIndex: 0);

      // Then
      expect(next.phase, const RunPhase.roundLost(reason: .noRoom));
    });
  });

  group('reviving', () {
    RunState lost() {
      final (state, _) = place(
        _playing().copyWith(
          board: boardFrom(['#.#.#.#.', '##.##.##', '...#....']),
          piecesLeft: 0,
          tray: [0, null, null],
        ),
        anchor: const Cell(col: 7, row: 7),
        trayIndex: 0,
      );

      return state;
    }

    test('empties the two fullest rows and adds three pieces', () {
      // Given
      final state = lost();

      // When
      final (next, events) = revive(state);

      // Then
      expect(next.phase, const RunPhase.playing());
      expect(
        next.board,
        boardFrom([
          '........',
          '........',
          '...#....',
          '........',
          '........',
          '........',
          '........',
          '.......#',
        ]),
      );
      expect(next.tray.whereType<int>(), hasLength(3));
      expect(next.revivesUsed, 1);
      expect(events.first, const GameEvent.revived(rows: [0, 1]));
    });

    test('is allowed once per run', () {
      // Given
      final (revived, _) = revive(lost());

      // When
      final lostAgain = revived.copyWith(
        phase: const .roundLost(reason: .outOfPieces),
      );

      // Then
      expect(lostAgain.canRevive, isFalse);
      expect(() => revive(lostAgain), throwsStateError);
    });

    test('a board still stuck afterwards loses again', () {
      // Given: every row full but one gap, so clearing two rows leaves the rest stuck for a 3×3
      final state = _playing().copyWith(
        board: boardFrom(List.filled(8, '#######.')),
        phase: const .roundLost(reason: .noRoom),
        piecesLeft: 0,
        tray: [16, null, null],
      );

      // When
      final (next, events) = revive(state);

      // Then: two empty rows can't hold a 3×3
      expect(next.phase, const RunPhase.roundLost(reason: .noRoom));
      expect(events.last, const GameEvent.roundLost(reason: .noRoom));
    });

    test('cannot happen while playing', () {
      // Given / When / Then
      expect(() => revive(_playing()), throwsStateError);
    });
  });

  group('ending the run', () {
    test('banks the lost round’s score', () {
      // Given
      final state = _playing().copyWith(
        phase: const .roundLost(reason: .outOfPieces),
        runTotal: 700,
        score: 120,
      );

      // When
      final (next, events) = endRun(state);

      // Then
      expect(next.phase, const RunPhase.over());
      expect(next.runTotal, 820);
      expect(events, [const GameEvent.runOver(total: 820)]);
    });

    test('cannot happen mid-round', () {
      // Given / When / Then
      expect(() => endRun(_playing()), throwsStateError);
    });
  });

  group('previewing a placement', () {
    test('a fitting piece lists its cells and the lines it would clear', () {
      // Given
      final state = _playing().copyWith(
        board: boardFrom(rowAlmostFull),
        tray: [0, 0, 0],
      );

      // When
      final result = preview(state, 0, topRight);

      // Then
      expect(result.fits, isTrue);
      expect(result.cells, [topRight]);
      expect(result.clearingRows, [0]);
      expect(result.colliding, isEmpty);
    });

    test('a colliding piece names the cells it overlaps', () {
      // Given
      final state = _playing().copyWith(
        board: boardFrom(['#.......']),
        tray: [9, 0, 0],
      );

      // When
      final result = preview(state, 0, topLeft);

      // Then
      expect(result.fits, isFalse);
      expect(result.colliding, [topLeft]);
      expect(result.clearingRows, isEmpty);
    });

    test('a piece hanging off the board lists only the cells on it', () {
      // Given
      final state = _playing().copyWith(tray: [9, 0, 0]);

      // When
      final result = preview(state, 0, const Cell(col: 7, row: 7));

      // Then
      expect(result.fits, isFalse);
      expect(result.cells, [const Cell(col: 7, row: 7)]);
    });

    test('an empty tray slot previews nothing', () {
      // Given
      final state = _playing().copyWith(tray: [null, 0, 0]);

      // When / Then
      expect(preview(state, 0, topLeft), PlacementPreview.none);
    });
  });

  group('offers', () {
    test('never include a joker already owned', () {
      // Given
      const owned = [JokerId.twin, JokerId.combo, JokerId.saver, JokerId.tiny];

      // When / Then
      for (var seed = 0; seed < 200; seed++) {
        final offers = offersFor(
          config: _config,
          owned: owned,
          pickIndex: 4,
          seed: seed,
        );
        expect(offers.toSet().intersection(owned.toSet()), isEmpty);
        expect(offers.toSet(), hasLength(3));
      }
    });

    test(
      'favour the partner of an owned joker about 3 times in 4, plus chance',
      () {
        // Given: the bias alone is 0.75; the random fill adds 0.25 × 3/13
        var partnerOffered = 0;
        const seeds = 4000;

        // When
        for (var seed = 0; seed < seeds; seed++) {
          final offers = offersFor(
            config: _config,
            owned: const [.twin],
            pickIndex: 1,
            seed: seed,
          );

          if (offers.contains(JokerId.patience)) partnerOffered++;
        }

        // Then
        expect(partnerOffered / seeds, closeTo(0.75 + 0.25 * 3 / 13, 0.03));
      },
    );

    test('the same seed and pick always offer the same jokers', () {
      // Given / When
      final first = offersFor(
        config: _config,
        owned: const [.twin],
        pickIndex: 2,
        seed: _seed,
      );
      final again = offersFor(
        config: _config,
        owned: const [.twin],
        pickIndex: 2,
        seed: _seed,
      );

      // Then
      expect(again, first);
    });
  });
}
