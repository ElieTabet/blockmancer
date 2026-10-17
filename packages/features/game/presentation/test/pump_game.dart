import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_presentation/game_presentation.dart';
import 'package:game_presentation/src/providers_di.br.dart';
import 'package:game_presentation/src/widgets/game_widget.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

import 'fake_game_rules.dart';
import 'game_overrides.dart';

/// Mounts the game screen on a phone of [size] logical pixels, its rules
/// scripted by the returned fake, and lets any sheet it opens on arrive. [disableAnimations] is the platform's reduce
/// motion; [reduceMotion] the app's own setting. [playSound] hears the sounds,
/// and [markTutorialSeen] the tutorial being kept as seen.
Future<FakeGameRules> pumpGame(
  WidgetTester tester,
  RunState start, {
  BestScores? bestScores,
  bool disableAnimations = false,
  GameLaunch launch = .daily,
  MarkTutorialSeenFun? markTutorialSeen,
  PlaySoundFun? playSound,
  bool reduceMotion = false,
  RewardedActionFun? rewardedAction,
  GameRouting? routing,
  RunStore? runStore,
  Size size = const Size(390, 844),
}) async {
  if (disableAnimations) {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
  }

  tester.view.physicalSize = size * 3;
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);

  final rules = FakeGameRules(start: start);

  await tester.pumpWidget(
    ProviderScope(
      overrides: gameOverrides(
        rules,
        bestScores: bestScores,
        launch: launch,
        markTutorialSeen: markTutorialSeen,
        playSound: playSound,
        reduceMotion: reduceMotion,
        rewardedAction: rewardedAction,
        routing: routing,
        runStore: runStore,
      ),
      child: TranslationProvider(
        child: MaterialApp(
          theme: DSTheme.instance.darkTheme,
          home: const GameWidget(),
        ),
      ),
    ),
  );
  await tester.pump();
  // A sheet the run opens on takes touches once it has faded in.
  await tester.pump(const Duration(milliseconds: 350));
  await tester.pump();

  return rules;
}
