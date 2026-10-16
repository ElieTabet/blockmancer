import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_domain/shared_domain.dart';

part 'providers_di.br.g.dart';

// game_presentation — inbound dependency-injection slots. Each throws until
// the composition layer overrides it.

/// The game's rules. Composition binds the engine; this package never imports
/// it, so the screen can only draw what the rules say.
@riverpod
GameRules gameRules(Ref ref) => throw UnimplementedError(
  'gameRulesProvider must be overridden by the composition layer',
);
