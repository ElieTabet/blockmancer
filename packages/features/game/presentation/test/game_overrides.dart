import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:game_domain/game_domain.dart' as game;
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
  Future<void> save(game.GameMode mode, int total) async => saved[mode] = total;
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
/// rewarded revive is granted unless [rewardedAction] says otherwise.
List<Override> gameOverrides(
  FakeGameRules rules, {
  game.BestScores? bestScores,
  game.GameLaunch launch = .daily,
  RewardedActionFun? rewardedAction,
  GameRouting? routing,
}) => [
  ...game.bindProviders(
    bestScores: (ref) => bestScores ?? FakeBestScores(),
    clock: (ref) => const FakeClock(),
    gameRules: (ref) => rules,
  ),
  ...bindProviders(rewardedAction: (ref) => rewardedAction ?? () async => true),
  ...bindRoutingProviders(gameRouting: (ref) => routing ?? FakeGameRouting()),
  gameLaunchProvider.overrideWithValue(launch),
];
