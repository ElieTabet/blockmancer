import 'package:blockmancer_engine/src/bot/bot_args.dart';
import 'package:blockmancer_engine/src/bot/greedy_policy.dart';
import 'package:blockmancer_engine/src/run/engine.dart';
import 'package:blockmancer_engine/src/run/replay.dart';
import 'package:shared_domain/shared_domain.dart';

/// How a bot run went: rounds won (the boss included), its total, the jokers
/// it ended with, and whether those held its build's pair (null for a
/// baseline).
typedef BotRun = ({
  int jokersOwned,
  bool? pairCompleted,
  int roundsWon,
  int runTotal,
  bool won,
});

/// Plays the run of [seed] under [config] to its end with [greedyMove]. An
/// `empty` build plays from an empty pool, so nothing is ever offered.
BotRun playBotRun(
  int seed, {
  required BotBuild build,
  required RunConfig config,
}) {
  final played = build.picks ? config : config.copyWith(jokerPool: const []);
  var state = startRun(config: played, seed: seed);
  var roundsWon = 0;

  for (
    var move = greedyMove(state, build: build.jokers);
    move != null;
    move = greedyMove(state, build: build.jokers)
  ) {
    final (next, events) = applyMove(state, move);
    state = next;
    roundsWon += events.whereType<RoundWon>().length;
  }

  return (
    jokersOwned: state.jokers.length,
    pairCompleted: build.completedBy(state.jokers),
    roundsWon: roundsWon,
    runTotal: state.runTotal,
    won: state.phase is WonPhase,
  );
}

/// What a batch of bot runs adds up to.
typedef BotSummary = ({
  double averageJokersOwned,
  double bossWinRate,
  double? bossWinRateOnceReached,
  double? bossWinRateWithPair,
  int p50Total,
  int p80Total,
  int? p80TotalWithPair,
  double? pairCompletionRate,
  List<double> roundClearRates,
  int runs,
});

/// [runs] summed up over a run of [roundCount] rounds: the share of runs
/// that cleared each round, the 50th and 80th percentile totals, how often
/// the boss fell (over every run, over the runs that reached it, and over
/// the runs that completed their build), the jokers a run ended with on
/// average, the share of runs that completed their build, and the 80th
/// percentile total of those. What concerns a build is null for a baseline,
/// as is a rate over no run.
BotSummary summarize(List<BotRun> runs, {required int roundCount}) {
  final totals = _sortedTotals(runs);
  final pairs = [for (final run in runs) ?run.pairCompleted];
  final withPair = [
    for (final run in runs)
      if (run.pairCompleted ?? false) run,
  ];

  return (
    averageJokersOwned:
        runs.fold(0, (sum, run) => sum + run.jokersOwned) / runs.length,
    bossWinRate: _winRate(runs)!,
    bossWinRateOnceReached: _winRate([
      for (final run in runs)
        if (run.roundsWon >= roundCount - 1) run,
    ]),
    bossWinRateWithPair: pairs.isEmpty ? null : _winRate(withPair),
    p50Total: _nearestRank(totals, percent: 50),
    p80Total: _nearestRank(totals, percent: 80),
    p80TotalWithPair: withPair.isEmpty
        ? null
        : _nearestRank(_sortedTotals(withPair), percent: 80),
    pairCompletionRate: pairs.isEmpty
        ? null
        : pairs.where((completed) => completed).length / pairs.length,
    roundClearRates: [
      for (var round = 1; round <= roundCount; round++)
        runs.where((run) => run.roundsWon >= round).length / runs.length,
    ],
    runs: runs.length,
  );
}

List<int> _sortedTotals(List<BotRun> runs) =>
    [for (final run in runs) run.runTotal]..sort();

double? _winRate(List<BotRun> runs) =>
    runs.isEmpty ? null : runs.where((run) => run.won).length / runs.length;

/// The nearest-rank percentile: the lowest total that at least [percent]% of
/// [sorted] are at or under, so it is always a total some run made.
int _nearestRank(List<int> sorted, {required int percent}) =>
    sorted[(percent * sorted.length + 99) ~/ 100 - 1];
