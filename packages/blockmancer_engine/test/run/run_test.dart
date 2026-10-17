import 'package:blockmancer_engine/src/run/default_config.dart';
import 'package:blockmancer_engine/src/run/engine.dart';
import 'package:blockmancer_engine/src/run/offers.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:test/test.dart';

import '../board_picture.dart';
import '../play_move.dart';

const _seed = 20261016;
const _config = defaultConfig;

/// A run in its first round, having started with [joker].
RunState _playing({JokerId joker = .twin}) {
  final start = startRun(config: _config, seed: _seed);
  final (state, _) = pickJoker(
    start.copyWith(phase: .pickingJoker(offers: [joker])),
    id: joker,
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
      final (state, events) = pickJoker(start, id: .twin);

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

    test('with no joker in the pool, round 1 starts with no pick', () {
      // Given / When
      final state = startRun(
        config: _config.copyWith(jokerPool: const []),
        seed: _seed,
      );

      // Then
      expect(state.phase, const RunPhase.playing());
      expect(state.jokers, isEmpty);
      expect(state.roundIndex, 0);
      expect(state.tray.whereType<int>(), hasLength(3));
      expect(state.piecesLeft, 14 - 3);
    });

    test('a joker that is not on offer cannot be picked', () {
      // Given
      final start = startRun(config: _config, seed: _seed);

      // When / Then
      expect(
        () => pickJoker(
          start.copyWith(phase: const .pickingJoker(offers: [.twin])),
          id: .combo,
        ),
        throwsArgumentError,
      );
    });

    test('no joker can be picked while playing', () {
      // Given
      final state = _playing();

      // When / Then
      expect(() => pickJoker(state, id: .combo), throwsStateError);
    });

    test('starting with Stonemason drops 2 stones on the board', () {
      // Given / When
      final state = _playing(joker: .stonemason);

      // Then
      expect(state.board.cells.whereType<StoneCell>(), hasLength(2));
    });

    test('Stonemason’s stones leave the pieces drawn untouched', () {
      // Given / When
      final withStonemason = _playing(joker: .stonemason);
      final without = _playing();

      // Then
      expect(withStonemason.board, isNot(without.board));
      expect(withStonemason.tray, without.tray);
      expect(withStonemason.piecesRngState, without.piecesRngState);
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
      expect(canPlace(state, anchor: topLeft, trayIndex: 0), isFalse);
      expect(
        () => place(state, anchor: topLeft, trayIndex: 0),
        throwsArgumentError,
      );
    });

    test('an empty tray slot cannot be placed', () {
      // Given
      final state = _playing().copyWith(tray: [0, null, null]);

      // When / Then
      expect(canPlace(state, anchor: topLeft, trayIndex: 1), isFalse);
      expect(canPlace(state, anchor: topLeft, trayIndex: 3), isFalse);
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
        contains(
          const GameEvent.scoreAdded(
            bonusPoints: 0,
            chips: 0,
            lineScore: 0,
            mult: 0,
            piecePoints: 4,
            total: 4,
          ),
        ),
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
        const GameEvent.scoreAdded(
          bonusPoints: 0,
          chips: 80,
          lineScore: 80,
          mult: 1,
          piecePoints: 1,
          total: 81,
        ),
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
      final (next, events) = pickJoker(won, id: offer);

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
      expect(next.score, 281);
      expect(next.runTotal, 281 + 7 * 40);
      expect(
        events,
        contains(
          const GameEvent.roundWon(bonus: 280, roundIndex: 0, score: 281),
        ),
      );
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
      final (boss, _) = pickJoker(beforeBoss, id: .combo);

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
      expect(canRevive(lostAgain), isFalse);
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
      final result = preview(state, anchor: topRight, trayIndex: 0);

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
      final result = preview(state, anchor: topLeft, trayIndex: 0);

      // Then
      expect(result.fits, isFalse);
      expect(result.colliding, [topLeft]);
      expect(result.clearingRows, isEmpty);
    });

    test('a piece hanging off the board lists only the cells on it', () {
      // Given
      final state = _playing().copyWith(tray: [9, 0, 0]);

      // When
      final result = preview(
        state,
        anchor: const Cell(col: 7, row: 7),
        trayIndex: 0,
      );

      // Then
      expect(result.fits, isFalse);
      expect(result.cells, [const Cell(col: 7, row: 7)]);
    });

    test('an empty tray slot previews nothing', () {
      // Given
      final state = _playing().copyWith(tray: [null, 0, 0]);

      // When / Then
      expect(
        preview(state, anchor: topLeft, trayIndex: 0),
        PlacementPreview.none,
      );
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
        // Given: the bias alone is 0.75; the random fill adds 0.25 × 3/15
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
        expect(partnerOffered / seeds, closeTo(0.75 + 0.25 * 3 / 15, 0.03));
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

  group('the joker pool', () {
    const starting = [
      JokerId.bigbox,
      JokerId.collector,
      JokerId.column,
      JokerId.combo,
      JokerId.heavy,
      JokerId.patience,
      JokerId.pockets,
      JokerId.precision,
      JokerId.saver,
      JokerId.sweep,
      JokerId.tiny,
      JokerId.twin,
    ];

    /// Every offer of the run of [seed] under [config], taking the first
    /// offer at each pick.
    List<JokerId> offeredOver(RunConfig config, {required int seed}) {
      final owned = <JokerId>[];
      final offered = <JokerId>[];

      for (var pick = 0; pick < config.rounds.length; pick++) {
        final offers = offersFor(
          config: config,
          owned: owned,
          pickIndex: pick,
          seed: seed,
        );
        offered.addAll(offers);
        owned.add(offers.first);
      }

      return offered;
    }

    test('a joker outside the pool is never offered, at any pick', () {
      // Given
      final config = _config.copyWith(jokerPool: starting);

      // When / Then
      for (var seed = 0; seed < 500; seed++) {
        expect(
          offeredOver(config, seed: seed).toSet().difference(starting.toSet()),
          isEmpty,
        );
      }
    });

    test(
      'the partner of an owned joker is not proposed from outside the pool',
      () {
        // Given: Stonemason owned, Quarry locked
        final config = _config.copyWith(jokerPool: [...starting, .stonemason]);

        // When / Then
        for (var seed = 0; seed < 500; seed++) {
          final offers = offersFor(
            config: config,
            owned: const [.stonemason],
            pickIndex: 1,
            seed: seed,
          );
          expect(offers, isNot(contains(JokerId.quarry)));
          expect(offers.toSet(), hasLength(3));
        }
      },
    );

    test('a pool of every joker offers Anchor and Avalanche too', () {
      // Given / When
      final offered = {
        for (var seed = 0; seed < 100; seed++)
          ...offeredOver(_config, seed: seed),
      };

      // Then
      expect(offered, containsAll(const [JokerId.anchor, JokerId.avalanche]));
    });

    test('the order of the pool never changes what is offered', () {
      // Given
      final forwards = _config.copyWith(jokerPool: starting);
      final backwards = _config.copyWith(jokerPool: starting.reversed.toList());

      // When / Then
      for (var seed = 0; seed < 100; seed++) {
        expect(
          offeredOver(backwards, seed: seed),
          offeredOver(forwards, seed: seed),
        );
      }
    });

    test('a pool smaller than the offer count offers what it has', () {
      // Given
      final config = _config.copyWith(jokerPool: const [.twin, .patience]);

      // When
      final offers = offersFor(
        config: config,
        owned: const [],
        pickIndex: 0,
        seed: _seed,
      );

      // Then
      expect(offers.toSet(), {JokerId.twin, JokerId.patience});
    });
  });

  group('joker state carried from move to move', () {
    test('Patience stores over two quiet moves and spends it on the clear', () {
      // Given
      var (state, _) = (
        _playing(joker: .patience).copyWith(
          board: boardFrom(rowAlmostFull),
          piecesLeft: 5,
          tray: [0, 0, 0],
        ),
        const <GameEvent>[],
      );

      // When
      (state, _) = place(
        state,
        anchor: const Cell(col: 3, row: 3),
        trayIndex: 0,
      );
      (state, _) = place(
        state,
        anchor: const Cell(col: 4, row: 4),
        trayIndex: 1,
      );
      final stored = state.storedMult;
      final (spent, events) = place(state, anchor: topRight, trayIndex: 2);

      // Then
      expect(stored, 4);
      expect(events.whereType<ScoreAdded>().single.mult, 1 + 4);
      expect(spent.storedMult, 0);
    });

    test('Quarry draws a fresh stone after each clear', () {
      // Given
      final state = _playing(joker: .quarry).copyWith(
        board: boardFrom(['#######.', '#######.']),
        piecesLeft: 5,
        tray: [0, 0, 0],
      );

      // When
      final (first, firstEvents) = place(state, anchor: topRight, trayIndex: 0);
      final (second, secondEvents) = place(
        first,
        anchor: const Cell(col: 7, row: 1),
        trayIndex: 1,
      );

      // Then
      expect(firstEvents.whereType<StonePlaced>(), hasLength(1));
      expect(secondEvents.whereType<StonePlaced>(), hasLength(1));
      expect(first.stonesRngState, isNot(state.stonesRngState));
      expect(second.stonesRngState, isNot(first.stonesRngState));
    });

    test('Quarry’s stones leave the pieces drawn untouched', () {
      // Given: the same round with and without Quarry, three clears in a row
      RunState round(JokerId joker) => _playing(joker: joker).copyWith(
        board: boardFrom(['#######.', '#######.', '#######.']),
        piecesLeft: 9,
        tray: [0, 0, 0],
      );

      // When: each clear drops a stone, then the empty tray draws three more
      RunState playThree(RunState state) {
        for (var row = 0; row < 3; row++) {
          (state, _) = place(
            state,
            anchor: Cell(col: 7, row: row),
            trayIndex: row,
          );
        }

        return state;
      }

      final withQuarry = playThree(round(.quarry));
      final without = playThree(round(.twin));

      // Then
      expect(withQuarry.board, isNot(without.board));
      expect(withQuarry.tray, without.tray);
      expect(withQuarry.piecesRngState, without.piecesRngState);
    });

    test('Stonemason scores the stones a move clears', () {
      // Given
      final state = _playing(
        joker: .stonemason,
      ).copyWith(board: boardFrom(['##S##S#.']), tray: [0, 0, 0]);

      // When
      final (_, events) = place(state, anchor: topRight, trayIndex: 0);

      // Then
      expect(events.whereType<ScoreAdded>().single.chips, 80 + 100);
    });
  });

  group("Finisher's last piece", () {
    test('a short final tray of one piece earns it when that piece clears', () {
      // Given: the round's last piece, alone in its tray
      final state = _playing(joker: .finisher).copyWith(
        board: boardFrom(['#######.']),
        piecesLeft: 0,
        tray: [null, 0, null],
        trayClearMask: null,
      );

      // When
      final (_, events) = place(
        state,
        anchor: const Cell(col: 7, row: 0),
        trayIndex: 1,
      );

      // Then
      expect(
        events,
        contains(
          const GameEvent.jokerFired(
            delta: .multMultiplied(factor: 2),
            joker: .finisher,
          ),
        ),
      );
      expect(
        events.whereType<ScoreAdded>().single,
        const GameEvent.scoreAdded(
          bonusPoints: 0,
          chips: 80,
          lineScore: 160,
          mult: 2,
          piecePoints: 1,
          total: 161,
        ),
      );
    });

    test('a piece played with others left in the tray earns nothing', () {
      // Given: two pieces in hand
      final state = _playing(joker: .finisher).copyWith(
        board: boardFrom(['#######.']),
        piecesLeft: 0,
        tray: [0, 0, null],
      );

      // When
      final (_, events) = place(
        state,
        anchor: const Cell(col: 7, row: 0),
        trayIndex: 0,
      );

      // Then
      expect(events.whereType<JokerFired>(), isEmpty);
    });
  });

  group("Hat Trick's tray", () {
    /// A round of [_playing] with Hat Trick, three singles in a tray dealt in
    /// full, and rows 0 to 2 one cell short of clearing.
    RunState threeToClear() => _playing(joker: .hattrick).copyWith(
      board: boardFrom(List.filled(3, '#######.')),
      piecesLeft: 5,
      tray: [0, 0, 0],
    );

    Transition playAll(RunState state, List<Cell> anchors) {
      var transition = (state, const <GameEvent>[]);

      for (final (trayIndex, anchor) in anchors.indexed) {
        transition = place(transition.$1, anchor: anchor, trayIndex: trayIndex);
      }

      return transition;
    }

    test('a full tray starts with nothing cleared yet', () {
      // Given / When
      final state = _playing(joker: .hattrick);

      // Then
      expect(state.trayClearMask, 0);
    });

    test('three pieces of one tray that each clear earn 300 on the third', () {
      // Given
      final state = threeToClear();

      // When
      final (next, events) = playAll(state, const [
        Cell(col: 7, row: 0),
        Cell(col: 7, row: 1),
        Cell(col: 7, row: 2),
      ]);

      // Then
      expect(
        events,
        contains(
          const GameEvent.jokerFired(
            delta: .pointsAdded(amount: 300),
            joker: .hattrick,
          ),
        ),
      );
      expect(next.score, 3 * 81 + 300);
    });

    test('a piece that clears nothing costs the tray its Hat Trick', () {
      // Given
      final state = threeToClear();

      // When: the second single lands where nothing clears
      final (_, events) = playAll(state, const [
        Cell(col: 7, row: 0),
        Cell(col: 0, row: 5),
        Cell(col: 7, row: 2),
      ]);

      // Then
      expect(events.whereType<JokerFired>(), isEmpty);
    });

    test('the next tray dealt in full starts over', () {
      // Given: a tray whose first piece cleared, down to its last piece
      final state = threeToClear().copyWith(
        tray: [null, null, 0],
        trayClearMask: 0x1,
      );

      // When
      final (next, events) = place(
        state,
        anchor: const Cell(col: 7, row: 2),
        trayIndex: 2,
      );

      // Then
      expect(events.whereType<JokerFired>(), isEmpty);
      expect(next.tray.whereType<int>(), hasLength(3));
      expect(next.trayClearMask, 0);
    });

    test('a short final tray can never earn it', () {
      // Given: two pieces left to deal
      final state = _playing(
        joker: .hattrick,
      ).copyWith(piecesLeft: 2, tray: [null, null, 0]);

      // When
      final (next, _) = place(state, anchor: topLeft, trayIndex: 2);

      // Then
      expect(next.tray.whereType<int>(), hasLength(2));
      expect(next.trayClearMask, isNull);
    });

    test('a short tray whose pieces all clear earns nothing', () {
      // Given: a tray dealt with two singles
      final state = threeToClear().copyWith(
        piecesLeft: 0,
        tray: [0, 0, null],
        trayClearMask: null,
      );

      // When
      final (_, events) = playAll(state, const [
        Cell(col: 7, row: 0),
        Cell(col: 7, row: 1),
      ]);

      // Then
      expect(events.whereType<JokerFired>(), isEmpty);
    });

    test("a full tray dealt by a revive counts, though it is the revive's "
        'pieces', () {
      // Given: out of pieces, the tray played out
      final state = _playing(joker: .hattrick).copyWith(
        board: boardFrom(['#.#.#.#.']),
        phase: const .roundLost(reason: .outOfPieces),
        piecesLeft: 0,
        tray: [null, null, null],
        trayClearMask: 0x7,
      );

      // When
      final (next, _) = revive(state);

      // Then
      expect(next.tray.whereType<int>(), hasLength(3));
      expect(next.trayClearMask, 0);
    });

    /// No room for the 2×2 left in hand with [piecesLeft] to deal; a revive
    /// empties rows 0 and 1, where it then fits without clearing anything.
    RunState stuckWithSquare({required int piecesLeft}) =>
        _playing(joker: .hattrick).copyWith(
          board: boardFrom([
            ...List.filled(3, '#######.'),
            '........',
            ...List.filled(4, '#.#.#.#.'),
          ]),
          phase: const .roundLost(reason: .noRoom),
          piecesLeft: piecesLeft,
          tray: [null, null, 9],
          trayClearMask: 0x3,
        );

    test('a revive makes the tray in play unable to earn it', () {
      // Given: no room for the last piece of a tray whose first two cleared
      final state = stuckWithSquare(piecesLeft: 3);

      // When
      final (next, _) = revive(state);

      // Then
      expect(next.tray, [null, null, 9]);
      expect(next.trayClearMask, isNull);
    });

    test('a revived tray stays out of it even when its last piece clears', () {
      // Given: revived, the 2×2 now fitting where it completes rows 0 and 1
      final (revived, _) = revive(stuckWithSquare(piecesLeft: 0));
      final state = revived.copyWith(
        board: revived.board.withCells({
          for (var col = 2; col < Board.size; col++) ...{
            Cell(col: col, row: 0): const .filled(colorIndex: 0),
            Cell(col: col, row: 1): const .filled(colorIndex: 0),
          },
        }),
      );

      // When
      final (_, events) = place(state, anchor: topLeft, trayIndex: 2);

      // Then
      expect(events.whereType<LinesCleared>(), hasLength(1));
      expect(events.whereType<JokerFired>(), isEmpty);
    });

    test("the next full tray after a revive counts, though it holds the "
        "revive's pieces", () {
      // Given: revived with none of the round's own pieces left to deal
      final (revived, _) = revive(stuckWithSquare(piecesLeft: 0));

      // When: the last piece in hand is played, and the revive's 3 are dealt
      final (next, _) = place(revived, anchor: topLeft, trayIndex: 2);

      // Then
      expect(next.tray.whereType<int>(), hasLength(3));
      expect(next.trayClearMask, 0);
    });
  });

  group('the winning move', () {
    test('Deep Pockets’ extra pieces become Saver points when left unused', () {
      // Given: a round of 18 pieces, 3 dealt; Saver joins the build
      final state = _playing(joker: .pockets).copyWith(
        board: boardFrom(rowAlmostFull),
        jokers: const [.pockets, .saver],
        score: 200,
        tray: [0, 0, 0],
      );

      // When: the first piece wins, leaving 15 undrawn and 2 in the tray
      final (next, _) = place(state, anchor: topRight, trayIndex: 0);

      // Then
      expect(next.runTotal, 281 + 17 * 40);
    });

    test('wins rather than running out of pieces when it is the last one', () {
      // Given
      final state = _playing().copyWith(
        board: boardFrom(rowAlmostFull),
        piecesLeft: 0,
        score: 200,
        tray: [0, null, null],
      );

      // When
      final (next, _) = place(state, anchor: topRight, trayIndex: 0);

      // Then
      expect(next.phase, isA<PickingJokerPhase>());
    });

    test('wins even when the rest of the tray fits nowhere', () {
      // Given: after the clear only isolated holes are left for the 3×3
      final state = _playing().copyWith(
        board: boardFrom([
          '#######.',
          '#.#.####',
          '##.#.###',
          '###.#.##',
          '####.#.#',
          '#####.#.',
          '.#####.#',
          '#.#####.',
        ]),
        score: 200,
        tray: [0, 16, null],
      );

      // When
      final (next, events) = place(state, anchor: topRight, trayIndex: 0);

      // Then
      expect(next.phase, isA<PickingJokerPhase>());
      expect(events.whereType<RoundLost>(), isEmpty);
    });

    test('deals no new tray for a round that is over', () {
      // Given
      final state = _playing().copyWith(
        board: boardFrom(rowAlmostFull),
        piecesLeft: 5,
        score: 200,
        tray: [null, null, 0],
      );

      // When
      final (_, events) = place(state, anchor: topRight, trayIndex: 2);

      // Then
      expect(events.whereType<TrayRefilled>(), isEmpty);
    });

    test('starts the next round directly when no joker is left to offer', () {
      // Given
      final state = _playing().copyWith(
        board: boardFrom(rowAlmostFull),
        jokers: JokerId.values,
        score: 200,
        tray: [0, 0, 0],
      );

      // When
      final (next, events) = place(state, anchor: topRight, trayIndex: 0);

      // Then
      expect(next.phase, const RunPhase.playing());
      expect(next.roundIndex, 1);
      expect(events.whereType<OffersPresented>(), isEmpty);
      expect(events.whereType<RoundStarted>().single.roundIndex, 1);
    });
  });

  group('reviving, edge cases', () {
    test('two rows tied on occupancy clear the upper one first', () {
      // Given
      final state = _playing().copyWith(
        board: boardFrom(['#.......', '........', '.#......', '..#.....']),
        phase: const .roundLost(reason: .noRoom),
        tray: [0, null, null],
      );

      // When
      final (_, events) = revive(state);

      // Then
      expect(events.first, const GameEvent.revived(rows: [0, 2]));
    });

    test('a no-room loss keeps its tray and banks the three pieces', () {
      // Given
      final state = _playing().copyWith(
        phase: const .roundLost(reason: .noRoom),
        piecesLeft: 0,
        tray: [0, null, null],
      );

      // When
      final (next, events) = revive(state);

      // Then
      expect(next.tray, [0, null, null]);
      expect(next.piecesLeft, 3);
      expect(events.whereType<TrayRefilled>(), isEmpty);
    });

    test('a revive spent in round 1 is gone in round 2', () {
      // Given
      final (revived, _) = revive(
        _playing().copyWith(
          phase: const .roundLost(reason: .noRoom),
          tray: [0, null, null],
        ),
      );
      final (roundTwo, _) = pickJoker(
        revived.copyWith(phase: const .pickingJoker(offers: [.combo])),
        id: .combo,
      );

      // When
      final lost = roundTwo.copyWith(
        phase: const .roundLost(reason: .outOfPieces),
      );

      // Then
      expect(roundTwo.roundIndex, 1);
      expect(canRevive(lost), isFalse);
    });
  });

  group('outside the playing phase', () {
    RunState picking() => _playing().copyWith(
      phase: const .pickingJoker(offers: [.combo]),
      tray: [0, 0, 0],
    );

    test('no piece can be placed or previewed', () {
      // Given
      final state = picking();

      // When / Then
      expect(canPlace(state, anchor: topLeft, trayIndex: 0), isFalse);
      expect(fitsSomewhere(state, trayIndex: 0), isFalse);
      expect(
        preview(state, anchor: topLeft, trayIndex: 0),
        PlacementPreview.none,
      );
      expect(
        () => place(state, anchor: topLeft, trayIndex: 0),
        throwsArgumentError,
      );
    });

    test('a lost or won round takes no piece either', () {
      // Given
      final lost = _playing().copyWith(
        phase: const .roundLost(reason: .noRoom),
        tray: [0, 0, 0],
      );
      final won = lost.copyWith(phase: const .won());

      // When / Then
      expect(
        () => place(lost, anchor: topLeft, trayIndex: 0),
        throwsArgumentError,
      );
      expect(
        () => place(won, anchor: topLeft, trayIndex: 0),
        throwsArgumentError,
      );
    });

    test('nothing can be revived while picking a joker', () {
      // Given / When / Then
      expect(() => revive(picking()), throwsStateError);
    });
  });

  group('the live run total', () {
    test('adds the round in play to what is banked', () {
      // Given
      final state = _playing().copyWith(runTotal: 700, score: 120);

      // When / Then
      expect(liveRunTotal(state), 820);
      expect(
        liveRunTotal(state.copyWith(phase: const .roundLost(reason: .noRoom))),
        820,
      );
    });

    test('counts a won round once, since winning banked it', () {
      // Given
      final state = _playing().copyWith(
        phase: const .pickingJoker(offers: [.combo]),
        runTotal: 820,
        score: 120,
      );

      // When / Then
      expect(liveRunTotal(state), 820);
      expect(liveRunTotal(state.copyWith(phase: const .over())), 820);
    });
  });
}
