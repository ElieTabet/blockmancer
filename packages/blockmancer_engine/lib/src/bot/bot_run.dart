import 'package:blockmancer_engine/src/bot/greedy_policy.dart';
import 'package:blockmancer_engine/src/run/engine.dart';
import 'package:blockmancer_engine/src/run/replay.dart';
import 'package:shared_domain/shared_domain.dart';

/// How a bot run went: rounds won (the boss included), and its total.
typedef BotRun = ({int roundsWon, int runTotal, bool won});

/// Plays the run of [seed] under [config] to its end with [greedyMove].
BotRun playBotRun(
  int seed, {
  required List<JokerId> build,
  required RunConfig config,
}) {
  var state = startRun(config: config, seed: seed);
  var roundsWon = 0;

  for (
    var move = greedyMove(state, build: build);
    move != null;
    move = greedyMove(state, build: build)
  ) {
    final (next, events) = applyMove(state, move);
    state = next;
    roundsWon += events.whereType<RoundWon>().length;
  }

  return (
    roundsWon: roundsWon,
    runTotal: state.runTotal,
    won: state.phase is WonPhase,
  );
}

/// What a batch of bot runs adds up to.
typedef BotSummary = ({
  double bossWinRate,
  int p50Total,
  int p80Total,
  List<double> roundClearRates,
  int runs,
});

/// [runs] summed up over a run of [roundCount] rounds: the share of runs
/// that cleared each round, the 50th and 80th percentile totals, and how often
/// the boss fell.
BotSummary summarize(List<BotRun> runs, {required int roundCount}) {
  final totals = [for (final run in runs) run.runTotal]..sort();

  return (
    bossWinRate: runs.where((run) => run.won).length / runs.length,
    p50Total: _nearestRank(totals, percent: 50),
    p80Total: _nearestRank(totals, percent: 80),
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
