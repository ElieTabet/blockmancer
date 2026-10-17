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
    expect(feedback.sounds, [
      (sound: GameSound.place, speed: 1.0),
      (sound: GameSound.clear, speed: 1.0),
    ]);
    expect(feedback.haptics, ['light', 'medium']);
  });

  testWidgets('a third clear running plays the clear higher, '
      'and the combo lands with a heavy tap', (tester) async {
    // Given
    final game = container(tester);

    // When
    await play(tester, game, const [
      placed,
      cleared,
      scored,
    ], after: runIn(const .playing(), score: 81, streak: 3));

    // Then
    expect(feedback.sounds.last.sound, GameSound.clear);
    expect(feedback.sounds.last.speed, closeTo(1.16, 1e-9));
    expect(feedback.haptics, ['light', 'medium', 'heavy']);
  });

  testWidgets('a long streak stops raising the clear', (tester) async {
    // Given
    final game = container(tester);

    // When
    await play(tester, game, const [
      placed,
      cleared,
      scored,
    ], after: runIn(const .playing(), score: 81, streak: 20));

    // Then
    expect(feedback.sounds.last, (sound: GameSound.clear, speed: 1.6));
  });

  testWidgets('each joker that fires plays its sound, in the order it fired', (
    tester,
  ) async {
    // Given
    final game = container(tester);

    // When
    await play(tester, game, const [
      placed,
      cleared,
      GameEvent.jokerFired(delta: .multAdded(amount: 1), joker: .combo),
      GameEvent.jokerFired(delta: .chipsAdded(amount: 20), joker: .stonemason),
      scored,
    ]);

    // Then
    expect(feedback.soundsPlayed, [
      GameSound.place,
      GameSound.clear,
      GameSound.joker,
      GameSound.joker,
    ]);
  });

  testWidgets('a won round cheers with a heavy tap as its points land', (
    tester,
  ) async {
    // Given
    final game = container(tester);
    rules.next = (
      runIn(const .pickingJoker(offers: [.combo]), score: 260),
      const [
        placed,
        cleared,
        scored,
        GameEvent.roundWon(bonus: 0, roundIndex: 0, score: 260),
      ],
    );

    // When: the score is still counting
    game
        .read(gameProvider.notifier)
        .place(anchor: const Cell(col: 0, row: 0), trayIndex: 0);
    await tester.pump(const Duration(milliseconds: 1000));

    // Then
    expect(feedback.soundsPlayed, isNot(contains(GameSound.roundWon)));

    // When: the points land
    await tester.pump(const Duration(milliseconds: 200));

    // Then
    expect(feedback.soundsPlayed.last, GameSound.roundWon);
    expect(feedback.haptics.last, 'heavy');
    await tester.pump(const Duration(seconds: 2));
    expect(
      feedback.soundsPlayed.where((sound) => sound == GameSound.roundWon),
      hasLength(1),
    );
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
    rules.next = (
      runIn(const .roundLost(reason: .noRoom), score: 81),
      const [placed, cleared, scored, GameEvent.roundLost(reason: .noRoom)],
    );

    // When: the move is still playing
    game
        .read(gameProvider.notifier)
        .place(anchor: const Cell(col: 0, row: 0), trayIndex: 0);
    await tester.pump(const Duration(milliseconds: 500));

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
    expect(feedback.soundsPlayed, [GameSound.place, GameSound.clear]);
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
    expect(feedback.soundsPlayed, [GameSound.place, GameSound.clear]);
    expect(feedback.haptics, ['light', 'medium']);
  });

  testWidgets('a skip plays nothing of what it skipped but the round won', (
    tester,
  ) async {
    // Given: a winning clear with two jokers still to fire
    final game = container(tester);
    rules.next = (
      runIn(const .pickingJoker(offers: [.combo]), score: 260),
      const [
        placed,
        cleared,
        GameEvent.jokerFired(delta: .multAdded(amount: 1), joker: .combo),
        GameEvent.jokerFired(delta: .chipsAdded(amount: 20), joker: .twin),
        scored,
        GameEvent.roundWon(bonus: 0, roundIndex: 0, score: 260),
      ],
    );
    game
        .read(gameProvider.notifier)
        .place(anchor: const Cell(col: 0, row: 0), trayIndex: 0);
    await tester.pump(const Duration(milliseconds: 350));
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
}
