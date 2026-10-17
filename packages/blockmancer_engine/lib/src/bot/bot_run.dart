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
  int p50Total,
  int p80Total,
  double? pairCompletionRate,
  List<double> roundClearRates,
  int runs,
});

/// [runs] summed up over a run of [roundCount] rounds: the share of runs
/// that cleared each round, the 50th and 80th percentile totals, how often
/// the boss fell, the jokers a run ended with on average, and the share of
/// runs that completed their pair (null for a baseline).
BotSummary summarize(List<BotRun> runs, {required int roundCount}) {
  final totals = [for (final run in runs) run.runTotal]..sort();
  final pairs = [for (final run in runs) ?run.pairCompleted];

  return (
    averageJokersOwned:
        runs.fold(0, (sum, run) => sum + run.jokersOwned) / runs.length,
    bossWinRate: runs.where((run) => run.won).length / runs.length,
    p50Total: _nearestRank(totals, percent: 50),
    p80Total: _nearestRank(totals, percent: 80),
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

/// The nearest-rank percentile: the lowest total that at least [percent]% of
/// [sorted] are at or under, so it is always a total some run made.
int _nearestRank(List<int> sorted, {required int percent}) =>
    sorted[(percent * sorted.length + 99) ~/ 100 - 1];
