import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers_di.br.g.dart';

// game_presentation — inbound dependency-injection slots. Each throws until
// the composition layer overrides it.

/// Shows the reward a revive costs; true once it has been earned. A reward
/// that couldn't be shown is false, never an error.
typedef RewardedActionFun = Future<bool> Function();

@riverpod
RewardedActionFun rewardedAction(Ref ref) => throw UnimplementedError(
  'rewardedActionProvider must be overridden by the composition layer',
);
