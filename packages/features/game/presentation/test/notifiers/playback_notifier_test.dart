import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_presentation/src/notifiers/beat.br.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/notifiers/playback_notifier.br.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_game_rules.dart';
import '../game_overrides.dart';

// testWidgets rather than test: the playback runs on timers, and the tester's
// clock is the one that can be moved on.
void main() {
  late FakeGameRules rules;

  const clear = <GameEvent>[
    GameEvent.linesCleared(cells: [], cols: [], rows: [0]),
    GameEvent.jokerFired(delta: .multAdded(amount: 1), joker: .combo),
    GameEvent.jokerFired(delta: .chipsAdded(amount: 20), joker: .stonemason),
    GameEvent.scoreAdded(
      bonusPoints: 0,
      chips: 100,
      lineScore: 200,
      mult: 2,
      piecePoints: 1,
      total: 201,
    ),
  ];

  ProviderContainer container({bool reduceMotion = false}) {
    final container = ProviderContainer(
      overrides: gameOverrides(rules, reduceMotion: reduceMotion),
    );
    addTearDown(container.dispose);
    container
      ..listen(gameProvider, (_, _) {})
      ..listen(playbackProvider, (_, _) {});

    return container;
  }

  void place(ProviderContainer game) => game
      .read(gameProvider.notifier)
      .place(anchor: const Cell(col: 0, row: 0), trayIndex: 0);

  setUp(() {
    rules = FakeGameRules(start: runIn(const .playing(), score: 40))
      ..next = (runIn(const .playing(), score: 241), clear);
  });

  testWidgets('a clear plays its beats in order, each joker as it fired', (
    tester,
  ) async {
    // Given
    final game = container();
    final played = <Beat>[];
    game.listen(playbackProvider.select((playback) => playback.beat), (
      _,
      beat,
    ) {
      if (beat != null) played.add(beat);
    });

    // When
    place(game);
    await tester.pump(const Duration(seconds: 3));

    // Then
    expect(played, [
      isA<ClearingBeat>(),
      isA<CountingChipsBeat>(),
      isA<CountingMultBeat>(),
      isA<JokerPulseBeat>().having(
        (beat) => beat.joker,
        'joker',
        JokerId.combo,
      ),
      isA<JokerPulseBeat>().having(
        (beat) => beat.joker,
        'joker',
        JokerId.stonemason,
      ),
      isA<ProductBeat>(),
      isA<LandingBeat>(),
    ]);
    expect(game.read(playbackProvider).isPlaying, isFalse);
  });

  testWidgets('the round score holds until the points land in it', (
    tester,
  ) async {
    // Given
    final game = container();

    // When: the chips are counting
    place(game);
    await tester.pump(const Duration(milliseconds: 400));

    // Then
    expect(game.read(playbackProvider).heldScore, 40);

    // When: the points land
    await tester.pump(const Duration(milliseconds: 1100));

    // Then
    expect(game.read(playbackProvider).beat, isA<LandingBeat>());
    expect(game.read(playbackProvider).heldScore, 241);
    await tester.pump(const Duration(seconds: 1));
    expect(game.read(playbackProvider).heldScore, isNull);
  });

  testWidgets('a skip in the first 300 ms is ignored', (tester) async {
    // Given
    final game = container();
    place(game);
    await tester.pump(const Duration(milliseconds: 200));

    // When
    game.read(playbackProvider.notifier).skip();

    // Then
    expect(game.read(playbackProvider).isPlaying, isTrue);
    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('a skip after 300 ms jumps to the end', (tester) async {
    // Given
    final game = container();
    place(game);
    await tester.pump(const Duration(milliseconds: 350));

    // When
    game.read(playbackProvider.notifier).skip();

    // Then
    expect(game.read(playbackProvider).isPlaying, isFalse);
    expect(game.read(playbackProvider).heldScore, isNull);
  });

  testWidgets('with reduce motion on, the same score lands sooner', (
    tester,
  ) async {
    // Given
    final game = container(reduceMotion: true);

    // When
    place(game);
    await tester.pump(const Duration(milliseconds: 700));

    // Then
    expect(game.read(playbackProvider).isPlaying, isFalse);
    expect(game.read(gameProvider).run.score, 241);
  });

  testWidgets('playing again plays nothing back', (tester) async {
    // Given: a run with a move played
    final game = container();
    place(game);
    await tester.pump(const Duration(seconds: 3));

    // When
    game.read(gameProvider.notifier).retry();
    await tester.pump(const Duration(milliseconds: 1));

    // Then
    expect(game.read(playbackProvider).isPlaying, isFalse);
  });
}
