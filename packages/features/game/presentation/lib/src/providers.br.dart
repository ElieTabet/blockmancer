import 'package:game_presentation/src/providers_di.br.dart' as di;
import 'package:riverpod_annotation/riverpod_annotation.dart';

// game_presentation — public providers exposed by this layer.

List<Override> bindProviders({
  required di.RewardedActionFun Function(Ref ref) rewardedAction,
}) => [di.rewardedActionProvider.overrideWith(rewardedAction)];
