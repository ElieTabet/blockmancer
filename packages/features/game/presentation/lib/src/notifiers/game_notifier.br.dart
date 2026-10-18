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
  /// The boss cards shown on this screen, beyond those its progression had
  /// seen.
  final _bossCardsShown = <WorldId>{};

  /// What the next run's jokers are drawn from: the screen's progression,
  /// until a run here earns more.
  Progression? _progression;
  var _reviving = false;

  /// Set while a finished run waits on its between-runs ad, so a second tap
  /// on Play again or leave doesn't ask twice.
  var _movingOn = false;

  /// The finished run whose end has already had its say about a rating.
  RunState? _reviewedRun;

  @override
  GameUiState build() {
    ref.watch(gameRulesProvider);
    final launch = ref.watch(gameLaunchProvider);
    final resumed = launch == .resume ? ref.watch(resumedRunProvider) : null;

    if (resumed != null) {
      ref.read(preloadAdsProvider)();

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

    ref.read(preloadAdsProvider)();

    return _fresh(start);
  }

  /// The run's end has finished celebrating on screen: after a boss win or a
  /// newly earned star, the rating prompt may be asked for, once per run,
  /// never in the tutorial (the domain decides the rest).
  Future<void> celebrated() async {
    final run = state.run;
    final newStars = state.progress?.newStars;
    final bossBeaten = run.phase is WonPhase;
    final newStar =
        newStars != null &&
        (newStars.bossBeaten || newStars.noRevive || newStars.scoreThreshold);

    if (state.isTutorial || identical(_reviewedRun, run)) return;

    _reviewedRun = run;

    if (!bossBeaten && !newStar) return;

    try {
      await ref.read(askForReviewProvider)(
        bossBeaten: bossBeaten,
        newStar: newStar,
      );
    } on Object catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'Asking for a rating failed',
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Puts the boss card away, for good: the player has read it.
  void closeBossCard() {
    final world = state.bossCard;

    if (world == null) return;

    _bossCardsShown.add(world);
    state = state.copyWith(bossCard: null);
    unawaited(_markBossCardSeen(world));
  }

  /// Moves on from what the run unlocked to how it ended.
  void closeUnlocks() => state = state.copyWith(unlocksSeen: true);

  void endRun() => _apply(_rules.endRun(state.run));

  void pickJoker(JokerId id) {
    _apply(_rules.pickJoker(state.run, id: id));

    if (!state.isTutorial) unawaited(_recordPick(id));
  }

  /// Ignores a drop that doesn't fit; the drag shadow has already said so.
  void place({required Cell anchor, required int trayIndex}) {
    if (!_rules.canPlace(state.run, anchor: anchor, trayIndex: trayIndex)) {
      return;
    }

    _apply(_rules.place(state.run, anchor: anchor, trayIndex: trayIndex));
  }

  /// Leaves the screen; from a finished run, after its between-runs ad when
  /// one is due.
  Future<void> leave(BuildContext context) async {
    if (!await _afterBetweenRuns()) return;

    if (!context.mounted) return;

    ref.read(gameRoutingProvider).onLeaveRequested(context);
  }

  /// Saves the run as it stands, for when the app is about to be put away.
  void persist() {
    if (state.isTutorial) return;

    unawaited(_save(SavedRun(mode: state.mode, run: state.run)));
  }

  /// Leaves the tutorial for a practice run, from its starting pick.
  void playPractice() => state = _fresh(_startFor(.practice));

  /// Plays the same mode again from its first pick: the same daily run, even
  /// past midnight, or a new practice or world run, offering what the runs
  /// played here unlocked. From a finished run, after its between-runs ad
  /// when one is due.
  Future<void> retry() async {
    if (!await _afterBetweenRuns() || !ref.mounted) return;

    state = _fresh(switch (state.mode) {
      DailyMode() => (
        config: state.run.config,
        mode: state.mode,
        seed: state.run.seed,
      ),
      PracticeMode() => _startFor(.practice),
      WorldMode(:final world) => _startFor(.world, world: world),
    });
  }

  /// Revives once the reward it costs has been earned. A second tap while the
  /// reward is showing is ignored.
  Future<void> revive() async {
    if (_reviving || !_rules.canRevive(state.run)) return;

    _reviving = true;
    final rewardedAction = ref.read(rewardedActionProvider);

    try {
      final result = await rewardedAction();

      if (!ref.mounted) return;

      ref.read(trackAdProvider)(.rewarded, result);

      // The run may have been ended while the reward showed.
      if (result is! AdEarned || !_rules.canRevive(state.run)) return;

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

  /// Waits out the between-runs ad of a run that has ended (never in the
  /// tutorial, nor mid-run); false while one is already being waited on.
  Future<bool> _afterBetweenRuns() async {
    if (state.isTutorial || !hasEnded(state.run)) return true;

    if (_movingOn) return false;

    _movingOn = true;

    try {
      await ref.read(betweenRunsProvider)();
    } on Object catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'The between-runs ad failed; moving on',
        exception: error,
        stackTrace: stackTrace,
      );
    } finally {
      _movingOn = false;
    }

    return true;
  }

  void _apply(Transition transition) {
    final (run, events) = transition;
    final before = state.run;
    final ended = !hasEnded(before) && hasEnded(run);

    state = state.copyWith(
      bossCard: _bossCardFor(run, events) ?? state.bossCard,
      lastEvents: events,
      moveCount: state.moveCount + 1,
      progressPending: ended && !state.isTutorial,
      run: run,
    );

    if (state.isTutorial) return;

    ref.read(trackMoveProvider)(state.mode, before, transition);

    if (ended) {
      unawaited(_recordEnd(run));
      unawaited(_countRunEnd());
      unawaited(_recordProgress(run));
      unawaited(_submitScore(run));
    }

    unawaited(_save(SavedRun(mode: state.mode, run: run)));
  }

  /// The world whose boss card [events] call for: a world run's boss just
  /// started, in any world but the map's first, its card never shown.
  WorldId? _bossCardFor(RunState run, List<GameEvent> events) {
    if (state.isTutorial || state.mode is! WorldMode) return null;

    final world = run.config.world;
    final bossStarted = events.whereType<RoundStarted>().any(
      (started) => run.config.rounds[started.roundIndex].isBoss,
    );
    final seen = {
      ...?(_progression ?? ref.read(launchProgressionProvider))?.bossCardsSeen,
      ..._bossCardsShown,
    };

    return bossStarted &&
            world != _rules.worldOrder.first &&
            !seen.contains(world)
        ? world
        : null;
  }

  Future<void> _markBossCardSeen(WorldId world) async {
    final markBossCardSeen = ref.read(markBossCardSeenProvider);

    try {
      await markBossCardSeen(world);
    } on Object catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'Remembering a boss card failed; it may show again',
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _countRunEnd() async {
    final countRunEnd = ref.read(countRunEndProvider);

    try {
      await countRunEnd();
    } on Object catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'Counting the run end failed',
        exception: error,
        stackTrace: stackTrace,
      );
    }
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

  Future<void> _recordPick(JokerId id) async {
    final recordPick = ref.read(recordPickProvider);

    try {
      await recordPick(id);
    } on Object catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'Recording a pick failed; it goes uncounted',
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Counts the run's end once what it earned is known, kept or not.
  Future<void> _recordProgress(RunState run) async {
    final recordProgression = ref.read(recordProgressionProvider);
    final trackRunEnd = ref.read(trackRunEndProvider);
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

    trackRunEnd(run, progress);

    if (!ref.mounted) return;

    _progression = progress?.progression ?? _progression;

    // Not if the player has already started again.
    if (!identical(state.run, run)) return;

    state = state.copyWith(progress: progress, progressPending: false);
  }

  Future<void> _submitScore(RunState run) async {
    final submitRunScore = ref.read(submitRunScoreProvider);

    try {
      await submitRunScore(state.mode, run.runTotal);
    } on Object catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'Submitting the run to the leaderboards failed',
        exception: error,
        stackTrace: stackTrace,
      );
    }
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
