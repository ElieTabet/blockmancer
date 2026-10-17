import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_presentation/src/entities/tutorial_step.dart';
import 'package:game_presentation/src/notifiers/beat.br.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/notifiers/playback_notifier.br.dart';
import 'package:game_presentation/src/notifiers/tutorial_notifier.br.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_game_rules.dart';
import '../game_overrides.dart';

// testWidgets rather than test: the score's playback runs on timers, and the
// tester's clock is the one that can be moved on.
void main() {
  late FakeGameRules rules;
  late int timesMarkedSeen;

  const quietMove = <GameEvent>[
    GameEvent.piecePlaced(
      anchor: Cell(col: 0, row: 6),
      cells: [Cell(col: 0, row: 6), Cell(col: 1, row: 6)],
      shapeId: 1,
      trayIndex: 1,
    ),
    GameEvent.scoreAdded(
      bonusPoints: 0,
      chips: 0,
      lineScore: 0,
      mult: 0,
      piecePoints: 2,
      total: 2,
    ),
  ];

  const clearingMove = <GameEvent>[
    GameEvent.piecePlaced(
      anchor: Cell(col: 3, row: 7),
      cells: [Cell(col: 3, row: 7)],
      shapeId: 0,
      trayIndex: 0,
    ),
    GameEvent.linesCleared(cells: [], cols: [], rows: [7]),
    GameEvent.scoreAdded(
      bonusPoints: 0,
      chips: 80,
      lineScore: 80,
      mult: 1,
      piecePoints: 1,
      total: 81,
    ),
  ];

  ProviderContainer container({
    FakeBestScores? bestScores,
    GameLaunch launch = .tutorial,
    FakeRunStore? runStore,
  }) {
    final container = ProviderContainer(
      overrides: gameOverrides(
        rules,
        bestScores: bestScores,
        launch: launch,
        markTutorialSeen: () async => timesMarkedSeen++,
        runStore: runStore,
      ),
    );
    addTearDown(container.dispose);
    container
      ..listen(gameProvider, (_, _) {})
      ..listen(playbackProvider, (_, _) {})
      ..listen(tutorialProvider, (_, _) {});

    return container;
  }

  Future<void> placeAPiece(WidgetTester tester, ProviderContainer game) async {
    rules.next = (runIn(const .playing(), score: 2), quietMove);
    game
        .read(gameProvider.notifier)
        .place(anchor: const Cell(col: 0, row: 6), trayIndex: 1);
    await tester.pump(const Duration(seconds: 1));
  }

  Future<void> clearALine(WidgetTester tester, ProviderContainer game) async {
    rules.next = (runIn(const .playing(), score: 83), clearingMove);
    game
        .read(gameProvider.notifier)
        .place(anchor: const Cell(col: 3, row: 7), trayIndex: 0);
    await tester.pump(const Duration(seconds: 3));
  }

  Future<void> letTheScoreLand(
    WidgetTester tester,
    ProviderContainer game,
  ) async {
    game.read(playbackProvider.notifier).skip();
    await tester.pump(const Duration(seconds: 1));
  }

  /// A tutorial played up to [step].
  Future<ProviderContainer> tutorialAt(
    WidgetTester tester,
    TutorialStep step,
  ) async {
    final game = container();

    if (step == .drag) return game;

    await placeAPiece(tester, game);

    if (step == .clear) return game;

    await clearALine(tester, game);

    if (step == .score) return game;

    await letTheScoreLand(tester, game);

    return game;
  }

  setUp(() {
    rules = FakeGameRules(
      start: runIn(const .pickingJoker(offers: [.twin, .patience, .combo])),
    );
    timesMarkedSeen = 0;
  });

  test('a tutorial starts in play, with no starting pick', () {
    // Given / When
    final game = container();

    // Then
    expect(rules.calls, ['tutorialRun']);
    expect(game.read(gameProvider).run.phase, const RunPhase.playing());
    expect(game.read(gameProvider).run.jokers, isEmpty);
    expect(game.read(tutorialProvider), TutorialStep.drag);
  });

  test('any other run has no coach', () {
    // Given / When
    final game = container(launch: .practice);

    // Then
    expect(game.read(tutorialProvider), isNull);
  });

  testWidgets('placing a piece moves the coach on to clearing a line', (
    tester,
  ) async {
    // Given
    final game = container();

    // When
    await placeAPiece(tester, game);

    // Then
    expect(game.read(tutorialProvider), TutorialStep.clear);
  });

  testWidgets('clearing a line holds its score on chips × mult until a touch', (
    tester,
  ) async {
    // Given
    final game = await tutorialAt(tester, .clear);

    // When
    await clearALine(tester, game);

    // Then
    expect(game.read(tutorialProvider), TutorialStep.score);
    expect(game.read(playbackProvider).beat, isA<ProductBeat>());
    expect(game.read(playbackProvider).held, isTrue);
  });

  testWidgets(
    'once the score has landed, the real starting pick comes up with the coach',
    (tester) async {
      // Given
      final game = await tutorialAt(tester, .score);

      // When
      game.read(playbackProvider.notifier).skip();
      await tester.pump(const Duration(milliseconds: 100));

      // Then: the points are landing, the pick not up yet
      expect(game.read(playbackProvider).beat, isA<LandingBeat>());
      expect(game.read(tutorialProvider), TutorialStep.score);

      // When
      await tester.pump(const Duration(seconds: 1));

      // Then
      expect(game.read(tutorialProvider), TutorialStep.pick);
      expect(game.read(gameProvider).run, rules.start);
      expect(game.read(gameProvider).isTutorial, isFalse);
      expect(timesMarkedSeen, 0);
    },
  );

  testWidgets('picking the first joker ends the tutorial, kept as seen', (
    tester,
  ) async {
    // Given
    final game = await tutorialAt(tester, .pick);

    // When
    rules.next = (runIn(const .playing()), const []);
    game.read(gameProvider.notifier).pickJoker(.twin);
    await tester.pump(const Duration(seconds: 1));

    // Then
    expect(game.read(tutorialProvider), isNull);
    expect(timesMarkedSeen, 1);
  });

  for (final step in const <TutorialStep>[.drag, .clear, .score]) {
    testWidgets(
      'skipping while on ${step.name} starts a practice run, kept as seen',
      (tester) async {
        // Given
        final game = await tutorialAt(tester, step);

        // When
        game.read(tutorialProvider.notifier).skip();
        await tester.pump(const Duration(seconds: 1));

        // Then
        expect(game.read(tutorialProvider), isNull);
        expect(game.read(gameProvider).run, rules.start);
        expect(game.read(gameProvider).mode, const GameMode.practice());
        expect(game.read(gameProvider).isTutorial, isFalse);
        expect(game.read(playbackProvider).isPlaying, isFalse);
        expect(timesMarkedSeen, 1);
      },
    );
  }

  testWidgets('skipping on the pick leaves the pick up, kept as seen', (
    tester,
  ) async {
    // Given
    final game = await tutorialAt(tester, .pick);
    final runsStarted = rules.calls.length;

    // When
    game.read(tutorialProvider.notifier).skip();
    await tester.pump(const Duration(seconds: 1));

    // Then
    expect(game.read(tutorialProvider), isNull);
    expect(rules.calls, hasLength(runsStarted));
    expect(game.read(gameProvider).run, rules.start);
    expect(timesMarkedSeen, 1);
  });

  testWidgets('a tutorial run is never saved, and records no best', (
    tester,
  ) async {
    // Given
    final bestScores = FakeBestScores();
    final runStore = FakeRunStore();
    final game = container(bestScores: bestScores, runStore: runStore);
    await placeAPiece(tester, game);

    // When: put away, then ended
    game.read(gameProvider.notifier).persist();
    rules.next = (runIn(const .over()), const [GameEvent.runOver(total: 2)]);
    game.read(gameProvider.notifier).endRun();
    await tester.pump(const Duration(seconds: 1));

    // Then
    expect(runStore.saved, isNull);
    expect(bestScores.saved, isEmpty);
  });

  testWidgets('the practice run the tutorial hands over to is saved', (
    tester,
  ) async {
    // Given
    final runStore = FakeRunStore();
    final game = container(runStore: runStore);
    await placeAPiece(tester, game);
    await clearALine(tester, game);
    await letTheScoreLand(tester, game);

    // When
    rules.next = (runIn(const .playing()), const []);
    game.read(gameProvider.notifier).pickJoker(.twin);
    await tester.pump(const Duration(seconds: 1));

    // Then
    expect(runStore.saved?.mode, const GameMode.practice());
  });
}
