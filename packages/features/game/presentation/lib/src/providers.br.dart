import 'package:game_presentation/src/providers_di.br.dart' as di;
import 'package:game_presentation/src/routing/game_routing.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// game_presentation — public providers exposed by this layer.

List<Override> bindProviders({
  required bool Function(Ref ref) hapticsOnSetting,
  required di.PlaySoundFun Function(Ref ref) playSound,
  required bool Function(Ref ref) reduceMotionSetting,
  required di.RewardedActionFun Function(Ref ref) rewardedAction,
  required bool Function(Ref ref) soundOnSetting,
}) => [
  di.hapticsOnSettingProvider.overrideWith(hapticsOnSetting),
  di.playSoundProvider.overrideWith(playSound),
  di.reduceMotionSettingProvider.overrideWith(reduceMotionSetting),
  di.rewardedActionProvider.overrideWith(rewardedAction),
  di.soundOnSettingProvider.overrideWith(soundOnSetting),
];

List<Override> bindRoutingProviders({
  required GameRouting Function(Ref ref) gameRouting,
}) => [di.gameRoutingProvider.overrideWith(gameRouting)];
