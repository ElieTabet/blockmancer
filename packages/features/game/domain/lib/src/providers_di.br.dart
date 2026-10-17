import 'package:game_domain/src/contracts/best_scores.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_domain/shared_domain.dart';

part 'providers_di.br.g.dart';

// game_domain — inbound dependency-injection slots. Each throws until the
// composition layer overrides it.

@riverpod
BestScores bestScores(Ref ref) => throw UnimplementedError(
  'bestScoresProvider must be overridden by the composition layer',
);

/// The game's rules. Composition binds the engine; the game never imports it,
/// so its screens can only draw what the rules say. Here rather than in
/// presentation because the domain decides each mode's seed with them.
@riverpod
GameRules gameRules(Ref ref) => throw UnimplementedError(
  'gameRulesProvider must be overridden by the composition layer',
);
