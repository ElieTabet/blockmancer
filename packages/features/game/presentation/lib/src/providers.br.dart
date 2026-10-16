import 'package:game_presentation/src/providers_di.br.dart' as di;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_domain/shared_domain.dart';

// game_presentation — public providers exposed by this layer.

List<Override> bindProviders({
  required GameRules Function(Ref ref) gameRules,
}) => [di.gameRulesProvider.overrideWith(gameRules)];
