import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_presentation/src/notifiers/beat.br.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/notifiers/playback_notifier.br.dart';
import 'package:game_presentation/src/notifiers/tutorial_hint.dart';
import 'package:game_presentation/src/notifiers/tutorial_notifier.br.dart';
import 'package:game_presentation/src/providers_di.br.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_domain/shared_domain.dart';

part 'providers_internal.br.g.dart';

/// The round score as the card shows it, against the round's target, and how
/// long it counts up to it.
typedef RoundScoreShown = ({Duration countUp, int score, int target});

/// The platform's reduce-motion setting. Scoped by `GameWidget` from its
/// `MediaQuery`, which only a widget can read.
@Riverpod(dependencies: [])
bool animationsDisabled(Ref ref) => throw UnimplementedError(
  'animationsDisabledProvider is scoped by GameWidget',
);

/// What this game screen was opened to play. Scoped by `GamePage`, which each
/// route push builds afresh, so every visit plays its own run.
@Riverpod(dependencies: [])
GameLaunch gameLaunch(Ref ref) =>
    throw UnimplementedError('gameLaunchProvider is scoped by GamePage');

/// Whether the game keeps still: no squash, no burst, no shake.
@Riverpod(dependencies: [animationsDisabled])
bool reduceMotion(Ref ref) =>
    ref.watch(animationsDisabledProvider) ||
    ref.watch(reduceMotionSettingProvider);

/// The saved run this screen resumes, loaded by `GamePage` before the game
/// starts; null for any other launch.
@Riverpod(dependencies: [])
SavedRun? resumedRun(Ref ref) => null;

/// The run's round score, held at what it was before a move until the move's
/// points land in it.
@Riverpod(dependencies: [GameNotifier, PlaybackNotifier])
RoundScoreShown roundScoreShown(Ref ref) {
  final (held, countUp) = ref.watch(
    playbackProvider.select(
      (playback) => (
        playback.heldScore,
        switch (playback.beat) {
          LandingBeat(:final countUp) => countUp,
          _ => Duration.zero,
        },
      ),
    ),
  );
  final (score, target) = ref.watch(
    gameProvider.select((state) => (state.run.score, state.run.round.target)),
  );

  return (countUp: countUp, score: held ?? score, target: target);
}

/// The run as the run total and the streak show it: the run before a move
/// until the move's points land, so neither runs ahead of the count-up.
@Riverpod(dependencies: [GameNotifier, PlaybackNotifier])
RunState shownRun(Ref ref) =>
    ref.watch(playbackProvider.select((playback) => playback.heldRun)) ??
    ref.watch(gameProvider.select((state) => state.run));

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

/// The cells the tutorial's coach points at; see [tutorialHintFor].
@Riverpod(dependencies: [GameNotifier, TutorialNotifier])
List<Cell> tutorialHint(Ref ref) {
  final step = ref.watch(tutorialProvider);

  if (step == null) return const [];

  return tutorialHintFor(
    ref.watch(gameProvider.select((state) => state.run)),
    rules: ref.watch(gameRulesProvider),
    step: step,
  );
}
