import 'package:game_domain/src/contracts/best_scores.dart';
import 'package:game_domain/src/contracts/clock.dart';
import 'package:game_domain/src/contracts/progression_store.dart';
import 'package:game_domain/src/contracts/run_store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_domain/shared_domain.dart';

part 'providers_di.br.g.dart';

// game_domain — inbound dependency-injection slots. Each throws until the
// composition layer overrides it.

/// Where what players do is counted: the testers' log today, Firebase
/// Analytics later.
@riverpod
AnalyticsSink analyticsSink(Ref ref) => throw UnimplementedError(
  'analyticsSinkProvider must be overridden by the composition layer',
);

@riverpod
BestScores bestScores(Ref ref) => throw UnimplementedError(
  'bestScoresProvider must be overridden by the composition layer',
);

@riverpod
Clock clock(Ref ref) => throw UnimplementedError(
  'clockProvider must be overridden by the composition layer',
);

/// The game's rules. Composition binds the engine; the game never imports it,
/// so its screens can only draw what the rules say. Here rather than in
/// presentation because the domain decides each mode's seed with them.
@riverpod
GameRules gameRules(Ref ref) => throw UnimplementedError(
  'gameRulesProvider must be overridden by the composition layer',
);

@riverpod
ProgressionStore progressionStore(Ref ref) => throw UnimplementedError(
  'progressionStoreProvider must be overridden by the composition layer',
);

@riverpod
RunStore runStore(Ref ref) => throw UnimplementedError(
  'runStoreProvider must be overridden by the composition layer',
);
