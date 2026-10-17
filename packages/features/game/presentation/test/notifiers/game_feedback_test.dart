import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_presentation/game_presentation.dart';
import 'package:game_presentation/src/notifiers/game_feedback.br.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/notifiers/playback_notifier.br.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_feedback.dart';
import '../fake_game_rules.dart';
import '../game_overrides.dart';

// testWidgets rather than test: the playback runs on timers, and the tester's
// clock is the one that can be moved on.
void main() {
  late FakeFeedback feedback;
  late FakeGameRules rules;

  const placed = GameEvent.piecePlaced(
    anchor: Cell(col: 0, row: 0),
    cells: [Cell(col: 0, row: 0)],
    shapeId: 0,
    trayIndex: 0,
  );
  const cleared = GameEvent.linesCleared(cells: [], cols: [], rows: [0]);
  const scored = GameEvent.scoreAdded(
    bonusPoints: 0,
    chips: 80,
    lineScore: 80,
    mult: 1,
    piecePoints: 1,
    total: 81,
  );
  const quietlyScored = GameEvent.scoreAdded(
    bonusPoints: 0,
    chips: 0,
    lineScore: 0,
    mult: 0,
    piecePoints: 1,
    total: 1,
  );

  const pentatonic = <double>[0, 2, 4, 7, 9, 12, 14, 16, 19, 21, 24];

  /// A clear's score, counted up from [chips] and [mult].
  GameEvent scoredWith({required int chips, required int mult}) =>
      GameEvent.scoreAdded(
        bonusPoints: 0,
        chips: chips,
        lineScore: chips * mult,
        mult: mult,
        piecePoints: 1,
        total: chips * mult + 1,
      );

  ProviderContainer container(
    WidgetTester tester, {
    bool hapticsOn = true,
    bool reduceMotion = false,
    bool soundOn = true,
  }) {
    feedback.hearHaptics(tester);

    final container = ProviderContainer(
      overrides: gameOverrides(
        rules,
        hapticsOn: hapticsOn,
        playSound: feedback.play,
        reduceMotion: reduceMotion,
        soundOn: soundOn,
      ),
    );
    addTearDown(container.dispose);
    container
      ..listen(gameProvider, (_, _) {})
      ..listen(gameFeedbackProvider, (_, _) {});

    return container;
  }

  /// Plays a move that answers [events] with [after], all the way through.
  Future<void> play(
    WidgetTester tester,
    ProviderContainer game,
    List<GameEvent> events, {
    RunState? after,
  }) async {
    rules.next = (after ?? runIn(const .playing(), score: 81), events);
    game
        .read(gameProvider.notifier)
        .place(anchor: const Cell(col: 0, row: 0), trayIndex: 0);
    await tester.pump(const Duration(seconds: 3));
  }

  /// Picks a joker that answers [events] with [after], all the way through.
  Future<void> pick(
    WidgetTester tester,
    ProviderContainer game,
    List<GameEvent> events, {
    required RunState after,
  }) async {
    rules.next = (after, events);
    game.read(gameProvider.notifier).pickJoker(.combo);
    await tester.pump(const Duration(seconds: 3));
  }

  /// Starts a move that answers [events] with [after], and plays it until
  /// [elapsed].
  Future<void> playFor(
    WidgetTester tester,
    ProviderContainer game,
    List<GameEvent> events, {
    required RunState after,
    required Duration elapsed,
  }) async {
    rules.next = (after, events);
    game
        .read(gameProvider.notifier)
        .place(anchor: const Cell(col: 0, row: 0), trayIndex: 0);
    await tester.pump(elapsed);
  }

  setUp(() {
    feedback = FakeFeedback();
    rules = FakeGameRules(start: runIn(const .playing()));
  });

  testWidgets('a piece set down clicks into place with a light tap', (
    tester,
  ) async {
    // Given
    final game = container(tester);

    // When
    await play(tester, game, const [placed, quietlyScored]);

    // Then
    expect(feedback.soundsPlayed, [GameSound.place]);
    expect(feedback.haptics, ['light']);
  });

  testWidgets('each piece set down strays up to 5% from its pitch', (
    tester,
  ) async {
    // Given
    final game = container(tester);

    // When
    await play(tester, game, const [placed, quietlyScored]);

    // Then
    expect(feedback.sounds, [
      (sound: GameSound.place, semitones: 0.0, variance: 0.05),
    ]);
  });

  testWidgets('a first clear plays the clear at its own pitch, '
      'with a medium tap', (tester) async {
    // Given
    final game = container(tester);

    // When
    await play(tester, game, const [
      placed,
      cleared,
      scored,
    ], after: runIn(const .playing(), score: 81, streak: 1));

    // Then
    expect(feedback.semitonesOf(GameSound.clear), [0.0]);
    expect(feedback.haptics, ['light', 'medium']);
  });

  testWidgets('each clear of a streak plays a step higher on the pentatonic '
      'scale, and a long streak stays on its top note', (tester) async {
    // Given
    final game = container(tester);

    // When: twelve clears running
    for (var streak = 1; streak <= 12; streak++) {
      await play(tester, game, const [
        placed,
        cleared,
        scored,
      ], after: runIn(const .playing(), score: 81, streak: streak));
    }

    // Then
    expect(feedback.semitonesOf(GameSound.clear), [...pentatonic, 24.0]);
  });

  testWidgets('a third clear running lands its combo with a heavy tap', (
    tester,
  ) async {
    // Given
    final game = container(tester);

    // When
    await play(tester, game, const [
      placed,
      cleared,
      scored,
    ], after: runIn(const .playing(), score: 81, streak: 3));

    // Then
    expect(feedback.haptics, ['light', 'medium', 'heavy']);
  });

  testWidgets('the score counts up in ticks climbing the pentatonic scale, '
      'then ka-chings as the total lands', (tester) async {
    // Given
    final game = container(tester);

    // When: 80 chips, then a mult of 4
    await play(tester, game, [placed, cleared, scoredWith(chips: 80, mult: 4)]);

    // Then
    expect(feedback.soundsPlayed, [
      GameSound.place,
      GameSound.clear,
      for (var tick = 0; tick < 10; tick++) GameSound.tick,
      GameSound.kaching,
    ]);
    expect(feedback.semitonesOf(GameSound.tick), pentatonic.take(10));
  });

  testWidgets('a big count-up never ticks more than 12 times', (tester) async {
    // Given
    final game = container(tester);

    // When
    await play(tester, game, [
      placed,
      cleared,
      scoredWith(chips: 900, mult: 60),
    ]);

    // Then
    final ticks = feedback.semitonesOf(GameSound.tick);

    expect(ticks, hasLength(lessThanOrEqualTo(12)));
    expect(ticks, orderedEquals([...ticks]..sort()));
  });

  testWidgets('a small mult ticks no more than it counts', (tester) async {
    // Given
    final game = container(tester);

    // When: 80 chips, then a mult of 1
    await play(tester, game, const [placed, cleared, scored]);

    // Then: six ticks for the chips, one for the mult
    expect(feedback.semitonesOf(GameSound.tick), hasLength(7));
  });

  testWidgets('with reduce motion on, the count-up still ticks, fewer and '
      'spaced out rather than in a burst', (tester) async {
    // Given
    final game = container(tester, reduceMotion: true);

    // When: the count-up has just started
    await playFor(
      tester,
      game,
      [placed, cleared, scoredWith(chips: 80, mult: 4)],
      after: runIn(const .playing(), score: 321),
      elapsed: const Duration(milliseconds: 40),
    );

    // Then
    expect(feedback.semitonesOf(GameSound.tick), [0.0]);

    // When: it has played out
    await tester.pump(const Duration(seconds: 3));

    // Then
    expect(feedback.semitonesOf(GameSound.tick), pentatonic.take(4));
    expect(feedback.soundsPlayed.last, GameSound.kaching);
  });

  testWidgets('the jokers of one move climb a major chord in the order they '
      'fired, and the next move starts again from its root', (tester) async {
    // Given
    final game = container(tester);

    // When: three jokers fire, then one on the next move
    await play(tester, game, const [
      placed,
      cleared,
      GameEvent.jokerFired(delta: .multAdded(amount: 1), joker: .combo),
      GameEvent.jokerFired(delta: .chipsAdded(amount: 20), joker: .stonemason),
      GameEvent.jokerFired(delta: .multMultiplied(factor: 3), joker: .twin),
      scored,
    ]);
    await play(tester, game, const [
      placed,
      cleared,
      GameEvent.jokerFired(delta: .multAdded(amount: 1), joker: .combo),
      scored,
    ]);

    // Then: C, E, G, then C again
    expect(feedback.semitonesOf(GameSound.joker), [0.0, 4.0, 7.0, 0.0]);
  });

  testWidgets('a joker that fires once the points are in carries on the '
      "move's chord", (tester) async {
    // Given
    final game = container(tester);

    // When: Saver's round bonus fires after the landing
    await play(tester, game, const [
      placed,
      cleared,
      GameEvent.jokerFired(delta: .multAdded(amount: 1), joker: .combo),
      scored,
      GameEvent.jokerFired(delta: .runPointsAdded(amount: 40), joker: .saver),
      GameEvent.roundWon(bonus: 40, roundIndex: 0, score: 260),
    ], after: runIn(const .pickingJoker(offers: [.combo]), score: 260));

    // Then
    expect(feedback.semitonesOf(GameSound.joker), [0.0, 4.0]);
  });

  testWidgets('picking a joker that starts the boss round plays the boss '
      'sting once, even when the pick has nothing else to play', (
    tester,
  ) async {
    // Given
    rules = FakeGameRules(start: runIn(const .pickingJoker(offers: [.combo])));
    final game = container(tester);

    // When
    await pick(tester, game, const [
      GameEvent.roundStarted(pieces: 22, roundIndex: 1, target: 2000),
    ], after: runIn(const .playing(), roundIndex: 1));

    // Then
    expect(feedback.soundsPlayed, [GameSound.bossStart]);
  });

  testWidgets('picking a joker that starts the boss round and fires plays '
      'the boss sting once, with the joker', (tester) async {
    // Given
    rules = FakeGameRules(start: runIn(const .pickingJoker(offers: [.combo])));
    final game = container(tester);

    // When: Pockets adds its pieces as the boss round starts
    await pick(tester, game, const [
      GameEvent.roundStarted(pieces: 26, roundIndex: 1, target: 2000),
      GameEvent.jokerFired(delta: .piecesAdded(amount: 4), joker: .pockets),
    ], after: runIn(const .playing(), roundIndex: 1));

    // Then
    expect(
      feedback.soundsPlayed,
      unorderedEquals([GameSound.bossStart, GameSound.joker]),
    );
  });

  testWidgets('a round that is not the boss starts without a sting', (
    tester,
  ) async {
    // Given
    rules = FakeGameRules(start: runIn(const .pickingJoker(offers: [.combo])));
    final game = container(tester);

    // When
    await pick(tester, game, const [
      GameEvent.roundStarted(pieces: 14, roundIndex: 0, target: 250),
    ], after: runIn(const .playing()));

    // Then
    expect(feedback.soundsPlayed, isEmpty);
  });

  testWidgets('a move that wins a round and starts the boss round straight '
      'away plays the boss sting after the round jingle', (tester) async {
    // Given
    final game = container(tester);

    // When: no joker is left to offer
    await play(tester, game, const [
      placed,
      cleared,
      scored,
      GameEvent.roundWon(bonus: 0, roundIndex: 0, score: 260),
      GameEvent.roundStarted(pieces: 22, roundIndex: 1, target: 2000),
    ], after: runIn(const .playing(), roundIndex: 1));

    // Then
    expect(feedback.soundsPlayed.reversed.take(2), [
      GameSound.bossStart,
      GameSound.roundWon,
    ]);
    expect(
      feedback.soundsPlayed.where((sound) => sound == GameSound.bossStart),
      hasLength(1),
    );
  });

  testWidgets('a won round cheers with a heavy tap as its points land', (
    tester,
  ) async {
    // Given
    final game = container(tester);

    // When: the score is still counting
    await playFor(
      tester,
      game,
      const [
        placed,
        cleared,
        scored,
        GameEvent.roundWon(bonus: 0, roundIndex: 0, score: 260),
      ],
      after: runIn(const .pickingJoker(offers: [.combo]), score: 260),
      elapsed: const Duration(milliseconds: 1000),
    );

    // Then
    expect(feedback.soundsPlayed, isNot(contains(GameSound.roundWon)));

    // When: the points land
    await tester.pump(const Duration(milliseconds: 200));

    // Then
    expect(feedback.soundsPlayed.reversed.take(2), [
      GameSound.roundWon,
      GameSound.kaching,
    ]);
    expect(feedback.haptics.last, 'heavy');
    await tester.pump(const Duration(seconds: 2));
    expect(
      feedback.soundsPlayed.where((sound) => sound == GameSound.roundWon),
      hasLength(1),
    );
  });

  testWidgets('beating the boss plays the boss fanfare and the announcer '
      'with a heavy tap, not the round jingle', (tester) async {
    // Given
    rules = FakeGameRules(start: runIn(const .playing(), roundIndex: 1));
    final game = container(tester);

    // When
    await play(tester, game, const [
      placed,
      cleared,
      scored,
      GameEvent.roundWon(bonus: 0, roundIndex: 1, score: 2100),
      GameEvent.runWon(total: 2360),
    ], after: runIn(const .won(), roundIndex: 1, score: 2100));

    // Then
    expect(feedback.soundsPlayed.last, GameSound.bossWin);
    expect(feedback.soundsPlayed, contains(GameSound.cheer));
    expect(feedback.soundsPlayed, isNot(contains(GameSound.roundWon)));
    expect(feedback.haptics.last, 'heavy');
  });

  testWidgets('a round won without a clear cheers once the piece is down', (
    tester,
  ) async {
    // Given
    final game = container(tester);

    // When
    await play(tester, game, const [
      placed,
      quietlyScored,
      GameEvent.roundWon(bonus: 0, roundIndex: 0, score: 250),
    ], after: runIn(const .pickingJoker(offers: [.combo]), score: 250));

    // Then
    expect(feedback.soundsPlayed, [GameSound.place, GameSound.roundWon]);
  });

  testWidgets('a lost round sounds as the move ends and the sheet comes up', (
    tester,
  ) async {
    // Given
    final game = container(tester);

    // When: the move is still playing
    await playFor(
      tester,
      game,
      const [placed, cleared, scored, GameEvent.roundLost(reason: .noRoom)],
      after: runIn(const .roundLost(reason: .noRoom), score: 81),
      elapsed: const Duration(milliseconds: 500),
    );

    // Then
    expect(feedback.soundsPlayed, isNot(contains(GameSound.roundLost)));

    // When: it has played out
    await tester.pump(const Duration(seconds: 2));

    // Then
    expect(game.read(playbackProvider).isPlaying, isFalse);
    expect(feedback.soundsPlayed.last, GameSound.roundLost);
  });

  testWidgets('with sound off, the haptics still play', (tester) async {
    // Given
    final game = container(tester, soundOn: false);

    // When
    await play(tester, game, const [
      placed,
      cleared,
      scored,
    ], after: runIn(const .playing(), score: 81, streak: 1));

    // Then
    expect(feedback.sounds, isEmpty);
    expect(feedback.haptics, ['light', 'medium']);
  });

  testWidgets('with haptics off, the sounds still play', (tester) async {
    // Given
    final game = container(tester, hapticsOn: false);

    // When
    await play(tester, game, const [
      placed,
      cleared,
      scored,
    ], after: runIn(const .playing(), score: 81, streak: 1));

    // Then
    expect(
      feedback.soundsPlayed,
      containsAllInOrder([
        GameSound.place,
        GameSound.clear,
        GameSound.tick,
        GameSound.kaching,
      ]),
    );
    expect(feedback.haptics, isEmpty);
  });

  testWidgets('with reduce motion on, the board keeps still '
      'but the place and the clear still sound', (tester) async {
    // Given
    final game = container(tester, reduceMotion: true);

    // When
    await play(tester, game, const [
      placed,
      cleared,
      scored,
    ], after: runIn(const .playing(), score: 81, streak: 1));

    // Then
    expect(feedback.soundsPlayed.take(2), [GameSound.place, GameSound.clear]);
    expect(feedback.haptics, ['light', 'medium']);
  });

  testWidgets('a skip plays nothing of what it skipped but the round won', (
    tester,
  ) async {
    // Given: a winning clear with two jokers still to fire
    final game = container(tester);
    await playFor(
      tester,
      game,
      const [
        placed,
        cleared,
        GameEvent.jokerFired(delta: .multAdded(amount: 1), joker: .combo),
        GameEvent.jokerFired(delta: .chipsAdded(amount: 20), joker: .twin),
        scored,
        GameEvent.roundWon(bonus: 0, roundIndex: 0, score: 260),
      ],
      after: runIn(const .pickingJoker(offers: [.combo]), score: 260),
      elapsed: const Duration(milliseconds: 350),
    );
    expect(feedback.soundsPlayed, [GameSound.place, GameSound.clear]);

    // When
    game.read(playbackProvider.notifier).skip();
    await tester.pump(const Duration(seconds: 3));

    // Then
    expect(feedback.soundsPlayed, [
      GameSound.place,
      GameSound.clear,
      GameSound.roundWon,
    ]);
  });

  testWidgets('a skip in the middle of the count-up stops its ticks, '
      'but the round won still cheers', (tester) async {
    // Given: the count-up has ticked a few times
    final game = container(tester);
    await playFor(
      tester,
      game,
      const [
        placed,
        cleared,
        scored,
        GameEvent.roundWon(bonus: 0, roundIndex: 0, score: 260),
      ],
      after: runIn(const .pickingJoker(offers: [.combo]), score: 260),
      elapsed: const Duration(milliseconds: 560),
    );
    final ticked = feedback.semitonesOf(GameSound.tick).length;
    expect(ticked, greaterThan(0));

    // When
    game.read(playbackProvider.notifier).skip();
    await tester.pump(const Duration(seconds: 3));

    // Then
    expect(feedback.semitonesOf(GameSound.tick), hasLength(ticked));
    expect(feedback.soundsPlayed, isNot(contains(GameSound.kaching)));
    expect(feedback.soundsPlayed.last, GameSound.roundWon);
  });

  testWidgets('a skip that beats the boss still plays the boss fanfare', (
    tester,
  ) async {
    // Given: the count-up has started
    rules = FakeGameRules(start: runIn(const .playing(), roundIndex: 1));
    final game = container(tester);
    await playFor(
      tester,
      game,
      const [
        placed,
        cleared,
        scored,
        GameEvent.roundWon(bonus: 0, roundIndex: 1, score: 2100),
        GameEvent.runWon(total: 2360),
      ],
      after: runIn(const .won(), roundIndex: 1, score: 2100),
      elapsed: const Duration(milliseconds: 560),
    );

    // When
    game.read(playbackProvider.notifier).skip();
    await tester.pump(const Duration(seconds: 3));

    // Then
    expect(feedback.soundsPlayed.last, GameSound.bossWin);
  });

  testWidgets('leaving the game in the middle of the count-up leaves no tick '
      'behind', (tester) async {
    // Given: the count-up has ticked a few times
    final game = container(tester);
    await playFor(
      tester,
      game,
      const [placed, cleared, scored],
      after: runIn(const .playing(), score: 81),
      elapsed: const Duration(milliseconds: 560),
    );
    final played = feedback.sounds.length;

    // When
    game.dispose();
    await tester.pump(const Duration(seconds: 3));

    // Then: and no timer is left pending, which the tester checks on its own
    expect(feedback.sounds, hasLength(played));
  });
}
