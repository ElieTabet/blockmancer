import 'dart:async';

import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:game_domain/game_domain.dart' as game;
import 'package:game_presentation/game_presentation.dart';
import 'package:game_presentation/src/providers_di.br.dart';

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

/// The game's slots, filled with fakes. The rewarded revive is granted unless
/// [rewardedAction] says otherwise.
List<Override> gameOverrides(
  FakeGameRules rules, {
  game.BestScores? bestScores,
  RewardedActionFun? rewardedAction,
}) => [
  ...game.bindProviders(
    bestScores: (ref) => bestScores ?? FakeBestScores(),
    gameRules: (ref) => rules,
  ),
  ...bindProviders(rewardedAction: (ref) => rewardedAction ?? () async => true),
  game.todaysDailyRunProvider.overrideWithValue((mode: testDay, seed: 1)),
];
