import 'package:game_domain/src/behaviors/record_run_end_behavior.dart';
import 'package:game_domain/src/contracts/best_scores.dart';
import 'package:game_domain/src/entities/game_mode.br.dart';
import 'package:game_domain/src/entities/run_end_record.br.dart';
import 'package:game_domain/src/providers_di.br.dart' as di;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_domain/shared_domain.dart';

part 'providers.br.g.dart';

// game_domain — public providers exposed by this layer.

typedef RecordRunEndFun =
    Future<RunEndRecord> Function(GameMode mode, int total);

/// A run to start: the mode it counts for, and the seed the rules play it on.
typedef RunStart = ({GameMode mode, int seed});

/// Keeps a finished run's total if it beats its mode's best, and says so.
@riverpod
RecordRunEndFun recordRunEnd(Ref ref) =>
    RecordRunEndBehavior(scores: ref.watch(di.bestScoresProvider)).call;

/// Today's daily run. Keyed by the UTC day itself, not by the seed: the seed
/// is the rules' to derive, and may change without orphaning the saved bests.
@riverpod
RunStart todaysDailyRun(Ref ref) {
  final today = DateTime.now().toUtc();

  return (
    mode: .daily(day: today.year * 10000 + today.month * 100 + today.day),
    seed: ref
        .watch(di.gameRulesProvider)
        .dailySeed(day: today.day, month: today.month, year: today.year),
  );
}

List<Override> bindProviders({
  required BestScores Function(Ref ref) bestScores,
  required GameRules Function(Ref ref) gameRules,
}) => [
  di.bestScoresProvider.overrideWith(bestScores),
  di.gameRulesProvider.overrideWith(gameRules),
];
