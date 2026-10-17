import 'package:blockmancer_engine/src/bot/bot_args.dart';
import 'package:blockmancer_engine/src/bot/bot_run.dart';
import 'package:blockmancer_engine/src/bot/greedy_policy.dart';
import 'package:blockmancer_engine/src/run/default_config.dart';
import 'package:blockmancer_engine/src/run/engine.dart';
import 'package:blockmancer_engine/src/run/offers.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:test/test.dart';

import '../board_picture.dart';
import '../play_move.dart';

final _patienceTwin = BotBuild.parse('patience,twin');

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

    test('with none of its build on offer, takes the same offer every time '
        'for the same run', () {
      expect(
        greedyMove(offering, build: const [.quarry]),
        greedyMove(offering, build: const [.quarry]),
      );
    });

    test('with none of its build on offer, takes any of the offers, each '
        'about as often', () {
      // Given / When
      final picks = <JokerId, int>{};

      for (var seed = 1; seed <= 300; seed++) {
        final move = greedyMove(
          offering.copyWith(seed: seed),
          build: const [.quarry],
        );
        final id = (move! as PickMove).id;
        picks[id] = (picks[id] ?? 0) + 1;
      }

      // Then
      expect(
        picks.keys,
        unorderedEquals(const [JokerId.combo, JokerId.twin, JokerId.saver]),
      );
      expect(picks.values, everyElement(inInclusiveRange(70, 130)));
    });

    test('once Deep Pockets is owned, takes Saver about one time in three '
        'it is offered, not every time the pair bias offers it first', () {
      // Given
      var offered = 0;
      var taken = 0;

      // When
      for (var seed = 1; seed <= 300; seed++) {
        final offers = offersFor(
          config: defaultConfig,
          owned: const [.pockets],
          pickIndex: 1,
          seed: seed,
        );
        final state = startRun(config: defaultConfig, seed: seed).copyWith(
          jokers: const [.pockets],
          phase: .pickingJoker(offers: offers),
          pickIndex: 1,
        );

        if (!offers.contains(JokerId.saver)) continue;

        offered++;

        if (greedyMove(state, build: const [.pockets]) ==
            const RunMove.pick(id: .saver)) {
          taken++;
        }
      }

      // Then
      expect(taken / offered, inInclusiveRange(0.25, 0.42));
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
      playBotRun(7, build: _patienceTwin, config: defaultConfig),
      playBotRun(7, build: _patienceTwin, config: defaultConfig),
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
        playBotRun(seed, build: _patienceTwin, config: config),
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
        playBotRun(seed, build: BotBuild.parse('random'), config: config),
    ], roundCount: config.rounds.length).p50Total;

    // When / Then
    expect(medianTotal(richer), greaterThan(medianTotal(defaultConfig)));
  });

  for (final name in const ['fullhouse,brink', 'finisher,hattrick']) {
    test('the bot plays the $name build through its rounds', () {
      // Given / When
      final summary = summarize([
        for (var seed = 1; seed <= 20; seed++)
          playBotRun(seed, build: BotBuild.parse(name), config: defaultConfig),
      ], roundCount: defaultConfig.rounds.length);

      // Then
      expect(summary.roundClearRates.first, greaterThan(0.5));
      expect(summary.roundClearRates.last, greaterThan(0));
    });
  }

  group('the baselines', () {
    test('random owns a joker for every round it reached, with no pair', () {
      // Given / When
      final run = playBotRun(
        7,
        build: BotBuild.parse('random'),
        config: defaultConfig,
      );

      // Then: the starting pick, then one after each round won but the boss
      expect(
        run.jokersOwned,
        1 + run.roundsWon.clamp(0, defaultConfig.rounds.length - 1),
      );
      expect(run.pairCompleted, isNull);
    });

    test('empty plays every run with no joker', () {
      // Given / When
      final runs = [
        for (var seed = 1; seed <= 10; seed++)
          playBotRun(
            seed,
            build: BotBuild.parse('empty'),
            config: defaultConfig,
          ),
      ];

      // Then
      expect(runs.map((run) => run.jokersOwned), everyElement(0));
      expect(runs.where((run) => run.roundsWon > 0).length, greaterThan(5));
    });
  });

  test('a pair build ends a run owning both its jokers when it got to pick '
      'them', () {
    // Given / When
    final runs = [
      for (var seed = 1; seed <= 20; seed++)
        playBotRun(seed, build: _patienceTwin, config: defaultConfig),
    ];

    // Then
    expect(runs.where((run) => run.pairCompleted!), isNotEmpty);
  });

  test('a bot run in Gravity reaches its boss', () {
    // Given / When
    final run = playBotRun(2, build: _patienceTwin, config: gravityConfig);

    // Then
    expect(
      run.roundsWon,
      greaterThanOrEqualTo(gravityConfig.rounds.length - 1),
    );
  });

  group('summing up runs', () {
    const runs = <BotRun>[
      (
        jokersOwned: 5,
        pairCompleted: true,
        roundsWon: 5,
        runTotal: 6000,
        won: true,
      ),
      (
        jokersOwned: 4,
        pairCompleted: true,
        roundsWon: 3,
        runTotal: 2000,
        won: false,
      ),
      (
        jokersOwned: 2,
        pairCompleted: false,
        roundsWon: 1,
        runTotal: 400,
        won: false,
      ),
      (
        jokersOwned: 1,
        pairCompleted: false,
        roundsWon: 0,
        runTotal: 100,
        won: false,
      ),
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

    test('gives the boss win rate over every run', () {
      final summary = summarize(runs, roundCount: 5);

      expect(summary.bossWinRate, 0.25);
      expect(summary.runs, 4);
    });

    test('gives the jokers a run ended with on average, and the share of runs '
        'that completed their pair', () {
      final summary = summarize(runs, roundCount: 5);

      expect(summary.averageJokersOwned, 3);
      expect(summary.pairCompletionRate, 0.5);
    });

    test('gives the boss win rate over the runs that cleared round 4', () {
      // Given: one run reached the boss and beat it
      final summary = summarize(runs, roundCount: 5);

      // Then
      expect(summary.bossWinRateOnceReached, 1);
    });

    test('gives the boss win rate and the P80 total over the runs that '
        'completed their pair', () {
      // Given: two runs completed the pair, totals 6,000 (won) and 2,000
      final summary = summarize(runs, roundCount: 5);

      // Then
      expect(summary.bossWinRateWithPair, 0.5);
      expect(summary.p80TotalWithPair, 6000);
    });

    test('a baseline has no pair to complete', () {
      // Given
      const baseline = <BotRun>[
        (
          jokersOwned: 3,
          pairCompleted: null,
          roundsWon: 2,
          runTotal: 900,
          won: false,
        ),
      ];

      // When
      final summary = summarize(baseline, roundCount: 5);

      // Then
      expect(summary.pairCompletionRate, isNull);
      expect(summary.bossWinRateWithPair, isNull);
      expect(summary.p80TotalWithPair, isNull);
      expect(summary.bossWinRateOnceReached, isNull);
    });

    test('gives the 50th and 80th percentile totals by nearest rank', () {
      // Given: ten totals out of order, 100 to 1,000
      final ten = <BotRun>[
        for (final total in [700, 200, 1000, 500, 100, 900, 300, 800, 400, 600])
          (
            jokersOwned: 0,
            pairCompleted: null,
            roundsWon: 0,
            runTotal: total,
            won: false,
          ),
      ];

      // When
      final summary = summarize(ten, roundCount: 5);

      // Then: the 5th and 8th lowest, ranks ceil(0.5 × 10) and ceil(0.8 × 10)
      expect(summary.p50Total, 500);
      expect(summary.p80Total, 800);
    });

    test('of four totals, P50 is the lower middle and P80 the highest', () {
      // Given / When: ranks ceil(0.5 × 4) = 2 and ceil(0.8 × 4) = 4
      final summary = summarize(runs, roundCount: 5);

      // Then
      expect(summary.p50Total, 400);
      expect(summary.p80Total, 6000);
    });
  });
}
