import 'package:blockmancer_engine/src/bot/bot_run.dart';
import 'package:blockmancer_engine/src/bot/greedy_policy.dart';
import 'package:blockmancer_engine/src/run/default_config.dart';
import 'package:blockmancer_engine/src/run/engine.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:test/test.dart';

import '../board_picture.dart';
import '../play_move.dart';

RunState _playing() {
  final start = startRun(config: defaultConfig, seed: 20261016);

  return pickJoker(
    start.copyWith(phase: const .pickingJoker(offers: [.twin])),
    id: .twin,
  ).$1;
}

void main() {
  group('picking a joker', () {
    final offering = startRun(
      config: defaultConfig,
      seed: 1,
    ).copyWith(phase: const .pickingJoker(offers: [.combo, .twin, .saver]));

    test('takes the first joker of its build on offer', () {
      expect(
        greedyMove(offering, build: const [.patience, .twin]),
        const RunMove.pick(id: .twin),
      );
    });

    test('takes the first offer when its build has none on offer', () {
      expect(
        greedyMove(offering, build: const [.quarry]),
        const RunMove.pick(id: .combo),
      );
    });
  });

  test('places the piece where it scores most: the clear', () {
    // Given: a single fits anywhere, but only one cell completes the row
    final state = _playing().copyWith(
      board: boardFrom(rowAlmostFull),
      tray: [0, null, null],
    );

    // When / Then
    expect(
      greedyMove(state, build: const []),
      const RunMove.place(anchor: topRight, trayIndex: 0),
    );
  });

  test('revives a lost round while it may, then ends the run', () {
    // Given
    final lost = _playing().copyWith(
      phase: const .roundLost(reason: .outOfPieces),
    );

    // When / Then
    expect(greedyMove(lost, build: const []), const RunMove.revive());
    expect(
      greedyMove(lost.copyWith(revivesUsed: 1), build: const []),
      const RunMove.end(),
    );
  });

  test('has nothing left to do once the run is over', () {
    expect(
      greedyMove(_playing().copyWith(phase: const .won()), build: const []),
      isNull,
    );
  });

  test('a bot run is the same every time for its seed and build', () {
    expect(
      playBotRun(7, build: const [.patience, .twin], config: defaultConfig),
      playBotRun(7, build: const [.patience, .twin], config: defaultConfig),
    );
  });

  test('a boss target three times higher makes the bot win less often', () {
    // Given
    final boss = defaultConfig.rounds.last;
    final harder = defaultConfig.copyWith(
      rounds: [
        ...defaultConfig.rounds.take(defaultConfig.rounds.length - 1),
        boss.copyWith(target: boss.target * 3),
      ],
    );

    double bossWinRate(RunConfig config) => summarize([
      for (var seed = 1; seed <= 40; seed++)
        playBotRun(seed, build: const [.patience, .twin], config: config),
    ], roundCount: config.rounds.length).bossWinRate;

    // When / Then
    expect(bossWinRate(harder), lessThan(bossWinRate(defaultConfig)));
  });

  test('doubling the chips per cell raises the bot\'s median total', () {
    // Given
    final richer = defaultConfig.copyWith(
      chipsPerCell: defaultConfig.chipsPerCell * 2,
    );

    int medianTotal(RunConfig config) => summarize([
      for (var seed = 1; seed <= 20; seed++)
        playBotRun(seed, build: const [], config: config),
    ], roundCount: config.rounds.length).medianTotal;

    // When / Then
    expect(medianTotal(richer), greaterThan(medianTotal(defaultConfig)));
  });

  group('summing up runs', () {
    const runs = <BotRun>[
      (roundsWon: 5, runTotal: 6000, won: true),
      (roundsWon: 3, runTotal: 2000, won: false),
      (roundsWon: 1, runTotal: 400, won: false),
      (roundsWon: 0, runTotal: 100, won: false),
    ];

    test('gives the share of runs that cleared each round', () {
      expect(summarize(runs, roundCount: 5).roundClearRates, [
        0.75,
        0.5,
        0.5,
        0.25,
        0.25,
      ]);
    });

    test('gives the median total and the boss win rate', () {
      final summary = summarize(runs, roundCount: 5);

      expect(summary.medianTotal, (400 + 2000) ~/ 2);
      expect(summary.bossWinRate, 0.25);
      expect(summary.runs, 4);
    });
  });
}
