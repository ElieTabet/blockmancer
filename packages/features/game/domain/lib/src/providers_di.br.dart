import 'package:game_domain/src/contracts/best_scores.dart';
import 'package:game_domain/src/contracts/clock.dart';
import 'package:game_domain/src/contracts/run_store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_domain/shared_domain.dart';

part 'providers_di.br.g.dart';

// game_domain — inbound dependency-injection slots. Each throws until the
// composition layer overrides it.

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
RunStore runStore(Ref ref) => throw UnimplementedError(
  'runStoreProvider must be overridden by the composition layer',
);
