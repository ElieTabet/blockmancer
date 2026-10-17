import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_presentation/src/notifiers/game_ui_state.br.dart';
import 'package:game_presentation/src/package_name.dart';
import 'package:game_presentation/src/providers_di.br.dart';
import 'package:game_presentation/src/providers_internal.br.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:timber/timber.dart';

part 'game_notifier.br.g.dart';

/// The run on screen. Every rule is [GameRules]': this only forwards the
/// player's actions and keeps what each one did.
///
/// What it plays is saved after every action, so a killed app resumes it —
/// all but the tutorial, which is played once and left.
@Riverpod(
  dependencies: [gameLaunch, launchProgression, launchedWorld, resumedRun],
)
class GameNotifier extends _$GameNotifier {
  /// What the next run's jokers are drawn from: the screen's progression,
  /// until a run here earns more.
  Progression? _progression;
  var _reviving = false;

  @override
  GameUiState build() {
    ref.watch(gameRulesProvider);
    final launch = ref.watch(gameLaunchProvider);
    final resumed = launch == .resume ? ref.watch(resumedRunProvider) : null;

    if (resumed != null) {
      return GameUiState(
        lastEvents: const [],
        mode: resumed.mode,
        moveCount: 0,
        run: resumed.run,
      );
    }

    // Nothing to resume means the save was lost: today's run instead.
    final start = _startFor(launch, world: ref.watch(launchedWorldProvider));

    if (launch == .tutorial) {
      return GameUiState(
        isTutorial: true,
        lastEvents: const [],
        mode: start.mode,
        moveCount: 0,
        run: _rules.tutorialRun(config: _rules.defaultConfig),
      );
    }

    return _fresh(start);
  }

  /// Moves on from what the run unlocked to how it ended.
  void closeUnlocks() => state = state.copyWith(unlocksSeen: true);

  void endRun() => _apply(_rules.endRun(state.run));

  void pickJoker(JokerId id) => _apply(_rules.pickJoker(state.run, id: id));

  /// Ignores a drop that doesn't fit; the drag shadow has already said so.
  void place({required Cell anchor, required int trayIndex}) {
    if (!_rules.canPlace(state.run, anchor: anchor, trayIndex: trayIndex)) {
      return;
    }

    _apply(_rules.place(state.run, anchor: anchor, trayIndex: trayIndex));
  }

  void leave(BuildContext context) =>
      ref.read(gameRoutingProvider).onLeaveRequested(context);

  /// Saves the run as it stands, for when the app is about to be put away.
  void persist() {
    if (state.isTutorial) return;

    unawaited(_save(SavedRun(mode: state.mode, run: state.run)));
  }

  /// Leaves the tutorial for a practice run, from its starting pick.
  void playPractice() => state = _fresh(_startFor(.practice));

  /// Plays the same mode again from its first pick: the same daily run, even
  /// past midnight, or a new practice or world run, offering what the runs
  /// played here unlocked.
  void retry() => state = _fresh(switch (state.mode) {
    DailyMode() => (
      config: state.run.config,
      mode: state.mode,
      seed: state.run.seed,
    ),
    PracticeMode() => _startFor(.practice),
    WorldMode(:final world) => _startFor(.world, world: world),
  });

  /// Revives once the reward it costs has been earned. A second tap while the
  /// reward is showing is ignored.
  Future<void> revive() async {
    if (_reviving || !_rules.canRevive(state.run)) return;

    _reviving = true;
    final rewardedAction = ref.read(rewardedActionProvider);

    try {
      final granted = await rewardedAction();

      // The run may have been ended while the reward showed.
      if (!ref.mounted || !granted || !_rules.canRevive(state.run)) return;

      _apply(_rules.revive(state.run));
    } on Object catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'The revive reward failed; the round stays lost',
        exception: error,
        stackTrace: stackTrace,
      );
    } finally {
      _reviving = false;
    }
  }

  GameRules get _rules => ref.read(gameRulesProvider);

  void _apply(Transition transition) {
    final (run, events) = transition;
    final ended = !hasEnded(state.run) && hasEnded(run);

    state = state.copyWith(
      lastEvents: events,
      moveCount: state.moveCount + 1,
      progressPending: ended && !state.isTutorial,
      run: run,
    );

    if (state.isTutorial) return;

    if (ended) {
      unawaited(_recordEnd(run));
      unawaited(_recordProgress(run));
    }

    unawaited(_save(SavedRun(mode: state.mode, run: run)));
  }

  Future<void> _recordEnd(RunState run) async {
    final recordRunEnd = ref.read(recordRunEndProvider);

    try {
      final record = await recordRunEnd(state.mode, run.runTotal);

      // Not if the player has already started again.
      if (!ref.mounted || !identical(state.run, run)) return;

      state = state.copyWith(record: record);
    } on Object catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'Recording the run end failed; no best is shown',
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _recordProgress(RunState run) async {
    final recordProgression = ref.read(recordProgressionProvider);
    ProgressionChange? progress;

    try {
      progress = await recordProgression(state.mode, run);
    } on Object catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'Recording the progression failed; nothing earned is shown',
        exception: error,
        stackTrace: stackTrace,
      );
    }

    if (!ref.mounted) return;

    _progression = progress?.progression ?? _progression;

    // Not if the player has already started again.
    if (!identical(state.run, run)) return;

    state = state.copyWith(progress: progress, progressPending: false);
  }

  /// A new run. Not saved until its first action: opening a run by mistake
  /// and backing out leaves the saved one standing.
  GameUiState _fresh(RunStart start) {
    final (:config, :mode, :seed) = start;

    return GameUiState(
      lastEvents: const [],
      mode: mode,
      moveCount: 0,
      run: _rules.startRun(config: config, seed: seed),
    );
  }

  RunStart _startFor(GameLaunch launch, {WorldId? world}) {
    final runStartFor = ref.read(runStartForProvider);

    return runStartFor(
      launch,
      progression: _progression ?? ref.read(launchProgressionProvider),
      world: world,
    );
  }

  Future<void> _save(SavedRun saved) async {
    final saveRun = ref.read(saveRunProvider);

    try {
      await saveRun(saved);
    } on Object catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'Saving the run failed; it will not resume',
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }
}
