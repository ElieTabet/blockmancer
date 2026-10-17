import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:game_domain/game_domain.dart' as game;
import 'package:shared_domain/shared_domain.dart' show Progression, WorldId;
import 'package:game_presentation/game_presentation.dart';
import 'package:game_presentation/src/providers_di.br.dart';
import 'package:game_presentation/src/providers_internal.br.dart';

import 'fake_game_rules.dart';

/// The day every test's daily run is played on.
const testDay = game.GameMode.daily(day: 20261017);

/// Best scores kept in memory, per mode. Reads wait for [gate] when one is
/// set, and throw once [broken].
final class FakeBestScores implements game.BestScores {
  var broken = false;
  Completer<void>? gate;
  final saved = <game.GameMode, int>{};

  @override
  Future<int?> best(game.GameMode mode) async {
    await gate?.future;

    if (broken) throw StateError('storage unavailable');

    return saved[mode];
  }

  @override
  Future<void> clearAll() async => saved.clear();

  @override
  Future<void> save(game.GameMode mode, int total) async => saved[mode] = total;
}

/// The saved run kept in memory.
final class FakeRunStore implements game.RunStore {
  game.SavedRun? saved;

  @override
  Future<void> clear() async => saved = null;

  @override
  Future<game.SavedRun?> load() async => saved;

  @override
  Future<void> save(game.SavedRun run) async => saved = run;
}

/// A clock stopped at noon on [testDay], UTC.
final class FakeClock implements game.Clock {
  const FakeClock();

  @override
  DateTime now() => DateTime.utc(2026, 10, 17, 12);
}

/// Records where the game asked to go.
final class FakeGameRouting implements GameRouting {
  final calls = <String>[];

  @override
  void onLeaveRequested(BuildContext context) => calls.add('leave');
}

/// The game's slots, filled with fakes, for a game opened for [launch]. The
/// rewarded revive is granted unless [rewardedAction] says otherwise, the
/// settings leave reduce motion off unless [reduceMotion] turns it on and
/// sound and haptics on unless [soundOn] or [hapticsOn] turn them off, sounds
/// go nowhere unless [playSound] takes them, and the tutorial is kept as seen
/// nowhere unless [markTutorialSeen] keeps it. The screen is opened with
/// [progression], a new player's unless given, which [progressionStore] keeps.
List<Override> gameOverrides(
  FakeGameRules rules, {
  game.BestScores? bestScores,
  bool hapticsOn = true,
  game.GameLaunch launch = .daily,
  MarkTutorialSeenFun? markTutorialSeen,
  PlaySoundFun? playSound,
  Progression? progression,
  game.ProgressionStore? progressionStore,
  bool reduceMotion = false,
  RewardedActionFun? rewardedAction,
  game.SavedRun? resumed,
  GameRouting? routing,
  game.RunStore? runStore,
  bool soundOn = true,
  WorldId? world,
}) => [
  ...game.bindProviders(
    bestScores: (ref) => bestScores ?? FakeBestScores(),
    clock: (ref) => const FakeClock(),
    gameRules: (ref) => rules,
    progressionStore: (ref) =>
        progressionStore ??
        FakeProgressionStore(game.startingProgression(rules)),
    runStore: (ref) => runStore ?? FakeRunStore(),
  ),
  ...bindProviders(
    hapticsOnSetting: (ref) => hapticsOn,
    markTutorialSeen: (ref) => markTutorialSeen ?? () async {},
    playSound: (ref) => playSound ?? (sound, {semitones = 0, variance = 0}) {},
    reduceMotionSetting: (ref) => reduceMotion,
    rewardedAction: (ref) => rewardedAction ?? () async => true,
    soundOnSetting: (ref) => soundOn,
  ),
  ...bindRoutingProviders(gameRouting: (ref) => routing ?? FakeGameRouting()),
  animationsDisabledProvider.overrideWithValue(false),
  gameLaunchProvider.overrideWithValue(launch),
  if (progression != null)
    launchProgressionProvider.overrideWithValue(progression),
  launchedWorldProvider.overrideWithValue(world),
  resumedRunProvider.overrideWithValue(resumed),
];

/// The progression kept in memory, from [saved]. Writes wait for [gate] when
/// one is set, and throw once [broken].
final class FakeProgressionStore implements game.ProgressionStore {
  FakeProgressionStore(this.saved);

  var broken = false;
  Completer<void>? gate;
  Progression saved;

  @override
  Future<Progression> load() async => saved;

  @override
  Future<void> save(Progression progression) async {
    await gate?.future;

    if (broken) throw StateError('storage unavailable');

    saved = progression;
  }
}
