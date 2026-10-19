import 'dart:ui';

import 'package:game_presentation/src/providers_di.br.dart' as di;
import 'package:game_presentation/src/providers_internal.br.dart';
import 'package:game_presentation/src/routing/game_routing.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.br.g.dart';

// game_presentation — public providers exposed by this layer.

typedef WhenGameSettledFun = Future<void> Function();

/// Completes once the game has finished with its last move: played back, and
/// its run, progression and run-end count written. At once with no game on
/// screen.
@Riverpod(keepAlive: true)
WhenGameSettledFun whenGameSettled(Ref ref) =>
    ref.watch(gameActivityProvider).settled;

List<Override> bindProviders({
  required bool Function(Ref ref) hapticsOnSetting,
  required di.MarkTutorialSeenFun Function(Ref ref) markTutorialSeen,
  required di.PlaySoundFun Function(Ref ref) playSound,
  required VoidCallback Function(Ref ref) preloadAds,
  required bool Function(Ref ref) reduceMotionSetting,
  required di.RewardedActionFun Function(Ref ref) rewardedAction,
  required Stream<bool> Function(Ref ref) rewardedAdReady,
  required bool Function(Ref ref) soundOnSetting,
}) => [
  di.hapticsOnSettingProvider.overrideWith(hapticsOnSetting),
  di.markTutorialSeenProvider.overrideWith(markTutorialSeen),
  di.playSoundProvider.overrideWith(playSound),
  di.preloadAdsProvider.overrideWith(preloadAds),
  di.reduceMotionSettingProvider.overrideWith(reduceMotionSetting),
  di.rewardedActionProvider.overrideWith(rewardedAction),
  di.rewardedAdReadyProvider.overrideWith(rewardedAdReady),
  di.soundOnSettingProvider.overrideWith(soundOnSetting),
];

List<Override> bindRoutingProviders({
  required GameRouting Function(Ref ref) gameRouting,
}) => [di.gameRoutingProvider.overrideWith(gameRouting)];
