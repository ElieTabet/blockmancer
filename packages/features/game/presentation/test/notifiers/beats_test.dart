import 'package:flutter_test/flutter_test.dart';
import 'package:game_presentation/src/notifiers/beat.br.dart';
import 'package:game_presentation/src/notifiers/beats.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_game_rules.dart';

void main() {
  final rules = FakeGameRules(start: runIn(const .playing()));

  // Shape 4 wears colour 4 in the fake rules.
  const placed = GameEvent.piecePlaced(
    anchor: Cell(col: 7, row: 0),
    cells: [Cell(col: 7, row: 0)],
    shapeId: 4,
    trayIndex: 0,
  );

  GameEvent score({int bonus = 0, int chips = 80, int mult = 1}) => .scoreAdded(
    bonusPoints: bonus,
    chips: chips,
    lineScore: chips * mult,
    mult: mult,
    piecePoints: 1,
    total: chips * mult + 1 + bonus,
  );

  /// The top row, full but for its last cell, which [placed] fills.
  final rowBefore = Board.empty().withCells({
    const Cell(col: 0, row: 0): const .stone(),
    for (var col = 1; col < 7; col++)
      Cell(col: col, row: 0): const .filled(colorIndex: 1),
  });

  final oneLine = GameEvent.linesCleared(
    cells: [for (var col = 0; col < 8; col++) Cell(col: col, row: 0)],
    cols: const [],
    rows: const [0],
  );

  List<Beat> beats(
    List<GameEvent> events, {
    RunState? after,
    RunState? before,
    bool reduceMotion = false,
  }) => beatsFor(
    after: after ?? runIn(const .playing(), score: 81),
    before: before ?? runIn(const .playing(), board: rowBefore),
    events: events,
    reduceMotion: reduceMotion,
    rules: rules,
  );

  test('a placement that clears nothing shows its points and squashes in', () {
    // Given / When
    final played = beats([placed, score(chips: 0, mult: 0)]);

    // Then
    expect(played, [
      const Beat.points(duration: Duration.zero, points: 1),
      const Beat.placing(
        cells: [Cell(col: 7, row: 0)],
        clearing: [],
        colorIndex: 4,
        duration: Duration(milliseconds: 120),
        shake: .none,
      ),
    ]);
  });

  test('a clear plays the piece, the burst, the chips, the mult, each joker as '
      'the engine applied it, the product, then the landing', () {
    // Given / When
    final played = beats([
      placed,
      oneLine,
      const GameEvent.jokerFired(delta: .multAdded(amount: 1), joker: .combo),
      const GameEvent.jokerFired(
        delta: .multMultiplied(factor: 3),
        joker: .twin,
      ),
      score(chips: 80, mult: 6),
    ]);

    // Then
    expect(played, [
      isA<PlacingBeat>(),
      isA<ClearingBeat>(),
      isA<CountingChipsBeat>().having((beat) => beat.chips, 'chips', 80),
      isA<CountingMultBeat>().having((beat) => beat.mult, 'mult', 6),
      isA<JokerPulseBeat>().having(
        (beat) => beat.joker,
        'joker',
        JokerId.combo,
      ),
      isA<JokerPulseBeat>().having((beat) => beat.joker, 'joker', JokerId.twin),
      isA<ProductBeat>().having((beat) => beat.lineScore, 'line score', 480),
      isA<LandingBeat>().having((beat) => beat.score, 'round score', 81),
    ]);
  });

  test('the cleared cells burst in the colour they had, the piece’s too', () {
    // Given / When
    final clearing = beats([
      placed,
      oneLine,
      score(),
    ]).whereType<ClearingBeat>().single;

    // Then
    expect(clearing.cells.first, (
      cell: const Cell(col: 0, row: 0),
      state: const CellState.stone(),
    ));
    expect(clearing.cells[1].state, const CellState.filled(colorIndex: 1));
    expect(clearing.cells.last, (
      cell: const Cell(col: 7, row: 0),
      state: const CellState.filled(colorIndex: 4),
    ));
  });

  test('a third clear in a row pops a combo', () {
    // Given / When
    final played = beats([
      placed,
      oneLine,
      score(),
    ], after: runIn(const .playing(), score: 81, streak: 3));

    // Then
    expect(
      played,
      contains(isA<ComboBeat>().having((beat) => beat.streak, 'streak', 3)),
    );
  });

  test('a second clear in a row pops no combo', () {
    // Given / When
    final played = beats([
      placed,
      oneLine,
      score(),
    ], after: runIn(const .playing(), score: 81, streak: 2));

    // Then
    expect(played.whereType<ComboBeat>(), isEmpty);
  });

  test('two lines at once shake the screen lightly', () {
    // Given / When
    final played = beats([
      placed,
      const GameEvent.linesCleared(cells: [], cols: [7], rows: [0]),
      score(),
    ]);

    // Then
    expect(played.whereType<ClearingBeat>().single.shake, Shake.light);
    expect(played.whereType<LandingBeat>().single.shake, Shake.none);
  });

  test('one line does not shake the screen', () {
    // Given / When
    final played = beats([placed, oneLine, score()]);

    // Then
    expect(played.whereType<ClearingBeat>().single.shake, Shake.none);
  });

  test('beating the boss shakes the screen hard as its score lands', () {
    // Given: round 2 is the boss in the test config
    final played = beats(
      [
        placed,
        oneLine,
        score(),
        const GameEvent.roundWon(bonus: 0, roundIndex: 1, score: 2100),
        const GameEvent.runWon(total: 2400),
      ],
      after: runIn(const .won(), roundIndex: 1, score: 2100),
      before: runIn(const .playing(), board: rowBefore, roundIndex: 1),
    );

    // Then
    expect(played.whereType<LandingBeat>().single.shake, Shake.strong);
  });

  test('a won round’s points land as its own, whatever round follows', () {
    // Given: every joker owned, so the next round started straight away
    final played = beats([
      placed,
      oneLine,
      score(),
      const GameEvent.roundWon(bonus: 0, roundIndex: 0, score: 260),
      const GameEvent.roundStarted(pieces: 22, roundIndex: 1, target: 2000),
    ], after: runIn(const .playing(), roundIndex: 1));

    // Then
    expect(played.whereType<LandingBeat>().single.score, 260);
  });

  test('with reduce motion on, nothing squashes, bursts or shakes, yet the '
      'same score lands in the same order', () {
    // Given
    final events = [
      placed,
      const GameEvent.linesCleared(cells: [], cols: [7], rows: [0]),
      const GameEvent.jokerFired(delta: .multAdded(amount: 1), joker: .combo),
      score(chips: 80, mult: 2),
      const GameEvent.roundWon(bonus: 0, roundIndex: 1, score: 2100),
    ];
    final after = runIn(const .won(), roundIndex: 1, score: 2100, streak: 3);
    final before = runIn(const .playing(), board: rowBefore, roundIndex: 1);

    // When
    final still = beats(
      events,
      after: after,
      before: before,
      reduceMotion: true,
    );

    // Then
    final lively = beats(events, after: after, before: before);
    expect(still, [
      isA<ComboBeat>(),
      isA<CountingChipsBeat>().having((beat) => beat.chips, 'chips', 80),
      isA<CountingMultBeat>().having((beat) => beat.mult, 'mult', 2),
      isA<JokerPulseBeat>(),
      isA<ProductBeat>().having((beat) => beat.lineScore, 'line score', 160),
      isA<LandingBeat>()
          .having((beat) => beat.score, 'round score', 2100)
          .having((beat) => beat.shake, 'shake', Shake.none),
    ]);
    expect(
      still.fold<Duration>(
        Duration.zero,
        (total, beat) => total + beat.duration,
      ),
      lessThan(
        lively.fold<Duration>(
          Duration.zero,
          (total, beat) => total + beat.duration,
        ),
      ),
    );
  });

  test('a won round’s bonus pulses once its score has landed', () {
    // Given / When
    final played = beats([
      placed,
      oneLine,
      const GameEvent.jokerFired(delta: .multAdded(amount: 1), joker: .combo),
      score(),
      const GameEvent.jokerFired(
        delta: .runPointsAdded(amount: 120),
        joker: .saver,
      ),
      const GameEvent.roundWon(bonus: 120, roundIndex: 0, score: 260),
    ]);

    // Then
    expect(played.skipWhile((beat) => beat is! ProductBeat), [
      isA<ProductBeat>(),
      isA<LandingBeat>(),
      isA<JokerPulseBeat>().having(
        (beat) => beat.joker,
        'joker',
        JokerId.saver,
      ),
    ]);
    expect(played.whereType<JokerPulseBeat>().map((beat) => beat.joker), [
      JokerId.combo,
      JokerId.saver,
    ]);
  });

  test(
    'a round that starts with a joker firing pulses it, and lands nothing',
    () {
      // Given / When
      final played = beats(const [
        GameEvent.roundStarted(pieces: 18, roundIndex: 1, target: 2000),
        GameEvent.jokerFired(delta: .piecesAdded(amount: 4), joker: .pockets),
      ]);

      // Then
      expect(played, [
        isA<JokerPulseBeat>().having(
          (beat) => beat.joker,
          'joker',
          JokerId.pockets,
        ),
      ]);
    },
  );

  test('a revive plays nothing back', () {
    // Given / When / Then
    expect(
      beats(const [
        GameEvent.revived(rows: [0, 1]),
        GameEvent.trayRefilled(tray: [0, 0, 0]),
      ]),
      isEmpty,
    );
  });

  test('ending the run plays nothing back', () {
    // Given / When / Then
    expect(beats(const [GameEvent.runOver(total: 900)]), isEmpty);
  });

  test('the round score counts up longer than its beat holds the screen', () {
    // Given / When
    final landing = beats([
      placed,
      oneLine,
      score(),
    ]).whereType<LandingBeat>().single;

    // Then
    expect(landing.countUp, greaterThan(landing.duration));
  });

  test('fog a placement lifts puffs away once the piece is down', () {
    // Given / When
    final played = beats([
      placed,
      score(chips: 0, mult: 0),
      const GameEvent.fogRevealed(
        becameStone: true,
        cell: Cell(col: 6, row: 0),
      ),
    ]);

    // Then
    expect(played.whereType<PlacingBeat>(), hasLength(1));
    expect(
      played.whereType<RevealingBeat>().single,
      const Beat.revealing(
        cells: [Cell(col: 6, row: 0)],
        duration: Duration(milliseconds: 260),
      ),
    );
    expect(played.indexWhere((beat) => beat is RevealingBeat), 2);
  });

  test('fog lifted by a clear puffs away after the burst', () {
    // Given / When
    final played = beats([
      placed,
      oneLine,
      score(),
      const GameEvent.fogRevealed(
        becameStone: false,
        cell: Cell(col: 7, row: 1),
      ),
    ]);

    // Then
    expect(
      played.indexWhere((beat) => beat is RevealingBeat),
      played.indexWhere((beat) => beat is ClearingBeat) + 1,
    );
  });

  test('with reduce motion on, lifted fog is simply gone', () {
    // Given / When
    final played = beats([
      placed,
      score(chips: 0, mult: 0),
      const GameEvent.fogRevealed(
        becameStone: false,
        cell: Cell(col: 6, row: 0),
      ),
    ], reduceMotion: true);

    // Then
    expect(played.whereType<RevealingBeat>(), isEmpty);
  });

  test('what Lantern takes beside the line bursts with it', () {
    // Given: a stone under the row
    final before = runIn(
      const .playing(),
      board: rowBefore.withCells({const Cell(col: 2, row: 1): const .stone()}),
    );

    // When
    final played = beats([
      placed,
      oneLine,
      const GameEvent.jokerFired(
        delta: .obstaclesRemoved(cells: [Cell(col: 2, row: 1)]),
        joker: .lantern,
      ),
      score(),
    ], before: before);

    // Then
    expect(played.whereType<ClearingBeat>().single.cells.last, (
      cell: const Cell(col: 2, row: 1),
      state: const CellState.stone(),
    ));
  });

  test('a tide that rose for the next tray lifts the board last', () {
    // Given / When
    final played = beats([
      placed,
      oneLine,
      score(),
      const GameEvent.tideRose(gapColumns: [2, 5]),
      const GameEvent.trayRefilled(tray: [0, 0, 0]),
    ]);

    // Then
    expect(
      played.last,
      const Beat.rising(duration: Duration(milliseconds: 250)),
    );
  });

  test('a line the tide completed bursts once the board has risen, as it '
      'stood, and never counts as the move\'s clear', () {
    // Given: column 3 held a stone in row 2 and filled cells below it; the
    // piece landed in row 1, and the tide's stone row completed it
    final before = runIn(
      const .playing(),
      board: Board.empty().withCells({
        const Cell(col: 3, row: 2): const .stone(),
        for (var row = 3; row < 8; row++)
          Cell(col: 3, row: row): const .filled(colorIndex: 2),
      }),
    );
    const landed = GameEvent.piecePlaced(
      anchor: Cell(col: 3, row: 1),
      cells: [Cell(col: 3, row: 1)],
      shapeId: 4,
      trayIndex: 0,
    );
    final tideLine = GameEvent.linesCleared(
      cells: [for (var row = 0; row < 8; row++) Cell(col: 3, row: row)],
      cols: const [3],
      rows: const [],
      source: .tide,
    );

    // When
    final played = beats([
      landed,
      score(chips: 0, mult: 0),
      const GameEvent.tideRose(gapColumns: [0, 5]),
      tideLine,
    ], before: before);

    // Then
    expect(played.whereType<CountingChipsBeat>(), isEmpty);
    expect(played[played.length - 2], isA<RisingBeat>());
    expect(
      played.last,
      Beat.clearing(
        cells: [
          (
            cell: const Cell(col: 3, row: 0),
            state: const .filled(colorIndex: 4),
          ),
          (cell: const Cell(col: 3, row: 1), state: const .stone()),
          for (var row = 2; row < 7; row++)
            (cell: Cell(col: 3, row: row), state: const .filled(colorIndex: 2)),
          (cell: const Cell(col: 3, row: 7), state: const .stone()),
        ],
        duration: const Duration(milliseconds: 350),
        shake: .none,
      ),
    );
  });

  test('with reduce motion on, the risen board is simply there', () {
    // Given / When
    final played = beats([
      placed,
      score(chips: 0, mult: 0),
      const GameEvent.tideRose(gapColumns: [2, 5]),
    ], reduceMotion: true);

    // Then
    expect(played.whereType<RisingBeat>(), isEmpty);
  });

  test('a move with no events plays nothing', () {
    // Given / When / Then
    expect(beats(const []), isEmpty);
  });
}
