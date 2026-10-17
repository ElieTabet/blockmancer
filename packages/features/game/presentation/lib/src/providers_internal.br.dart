import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers_internal.br.g.dart';

/// What this game screen was opened to play. Scoped by `GamePage`, which each
/// route push builds afresh, so every visit plays its own run.
@Riverpod(dependencies: [])
GameLaunch gameLaunch(Ref ref) =>
    throw UnimplementedError('gameLaunchProvider is scoped by GamePage');

/// The saved run this screen resumes, loaded by `GamePage` before the game
/// starts; null for any other launch.
@Riverpod(dependencies: [])
SavedRun? resumedRun(Ref ref) => null;

/// Whether the tray piece at [index] fits anywhere — cached, so the board scan
/// runs once per change of the board or the tray, not in a widget's selector.
@Riverpod(dependencies: [GameNotifier])
bool trayFits(Ref ref, int index) {
  ref.watch(
    gameProvider.select(
      (state) => (state.run.board, state.run.phase, state.run.tray[index]),
    ),
  );

  return ref
      .watch(gameRulesProvider)
      .fitsSomewhere(ref.read(gameProvider).run, trayIndex: index);
}
