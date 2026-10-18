import 'dart:async';

import 'package:game_domain/src/behaviors/clear_progress_behavior.dart';
import 'package:game_domain/src/behaviors/earned_worlds_store.dart';
import 'package:game_domain/src/behaviors/daily_run_behavior.dart';
import 'package:game_domain/src/behaviors/mark_boss_card_seen_behavior.dart';
import 'package:game_domain/src/behaviors/mark_jokers_announced_behavior.dart';
import 'package:game_domain/src/behaviors/record_pick_behavior.dart';
import 'package:game_domain/src/behaviors/record_progression_behavior.dart';
import 'package:game_domain/src/behaviors/record_run_end_behavior.dart';
import 'package:game_domain/src/behaviors/run_start_for_behavior.dart';
import 'package:game_domain/src/behaviors/save_run_behavior.dart';
import 'package:game_domain/src/contracts/best_scores.dart';
import 'package:game_domain/src/contracts/clock.dart';
import 'package:game_domain/src/contracts/progression_store.dart';
import 'package:game_domain/src/contracts/run_store.dart';
import 'package:game_domain/src/entities/game_launch.dart';
import 'package:game_domain/src/entities/game_mode.br.dart';
import 'package:game_domain/src/entities/joker_collection_of.dart';
import 'package:game_domain/src/entities/progression_change.br.dart';
import 'package:game_domain/src/entities/run_end.dart';
import 'package:game_domain/src/entities/run_end_record.br.dart';
import 'package:game_domain/src/entities/run_events.dart';
import 'package:game_domain/src/entities/run_start.dart';
import 'package:game_domain/src/entities/run_tuning.dart';
import 'package:game_domain/src/entities/saved_run.br.dart';
import 'package:game_domain/src/entities/starting_progression.dart';
import 'package:game_domain/src/entities/world_summaries.dart';
import 'package:game_domain/src/providers_di.br.dart' as di;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_domain/shared_domain.dart';

part 'providers.br.g.dart';

// game_domain — public providers exposed by this layer.

typedef ClearProgressFun = Future<void> Function();

/// See [MarkBossCardSeenBehavior].
typedef MarkBossCardSeenFun = Future<void> Function(WorldId world);

/// See [MarkJokersAnnouncedBehavior].
typedef MarkJokersAnnouncedFun = Future<void> Function();

/// See [RecordPickBehavior].
typedef RecordPickFun = Future<void> Function(JokerId joker);

/// See [RecordProgressionBehavior].
typedef RecordProgressionFun =
    Future<ProgressionChange?> Function(GameMode mode, RunState run);

typedef RecordRunEndFun =
    Future<RunEndRecord> Function(GameMode mode, int total);

/// Counts what a move did, from the run before it and the transition it
/// made. See [runEventsOf].
typedef TrackMoveFun =
    void Function(GameMode mode, RunState before, Transition transition);

/// Counts a finished run, with what it earned. See [runEndEventsOf].
typedef TrackRunEndFun = void Function(RunState run, ProgressionChange? change);

/// See [RunStartForBehavior]. A function, so each launch reads the clock
/// afresh.
typedef RunStartForFun =
    RunStart Function(
      GameLaunch launch, {
      required Progression progression,
      WorldId? world,
    });

typedef LoadProgressionFun = Future<Progression> Function();

typedef LoadSavedRunFun = Future<SavedRun?> Function();

/// Keeps [run] as the one to resume, or forgets it once it is over.
typedef SaveRunFun = Future<void> Function(SavedRun run);

/// The best run total of [mode] on this device, or null before its first run.
@riverpod
Future<int?> bestScore(Ref ref, GameMode mode) =>
    ref.watch(di.bestScoresProvider).best(mode);

/// See [ClearProgressBehavior].
///
/// Kept alive because it refreshes the bests and the saved run after an await,
/// by when an auto-disposed provider's ref may be gone.
@Riverpod(keepAlive: true)
ClearProgressFun clearProgress(Ref ref) {
  final clear = ClearProgressBehavior(
    progression: ref.watch(di.progressionStoreProvider),
    scores: ref.watch(di.bestScoresProvider),
    startingProgression: ref.watch(initialProgressionProvider),
    store: ref.watch(di.runStoreProvider),
  );

  return () async {
    await clear();

    ref.invalidate(bestScoreProvider);
    ref.invalidate(hasSavedRunProvider);
    ref.invalidate(progressionProvider);
  };
}

/// What the player has earned across runs, as this device keeps it.
@riverpod
Future<Progression> progression(Ref ref) =>
    ref.watch(loadProgressionProvider)();

/// Every joker in pairs, with how each pair is unlocked.
@riverpod
JokerCollection jokerCollection(Ref ref) => jokerCollectionOf(
  ref.watch(di.gameRulesProvider),
  valueOf: ref.watch(di.remoteValueProvider),
);

/// See [MarkBossCardSeenBehavior].
///
/// Kept alive because it refreshes [progressionProvider] after an await, by
/// when an auto-disposed provider's ref may be gone.
@Riverpod(keepAlive: true)
MarkBossCardSeenFun markBossCardSeen(Ref ref) {
  final mark = MarkBossCardSeenBehavior(store: _progressionStore(ref));

  return (world) async {
    await mark(world);
    ref.invalidate(progressionProvider);
  };
}

/// See [MarkJokersAnnouncedBehavior].
///
/// Kept alive because it refreshes [progressionProvider] after an await, by
/// when an auto-disposed provider's ref may be gone.
@Riverpod(keepAlive: true)
MarkJokersAnnouncedFun markJokersAnnounced(Ref ref) {
  final mark = MarkJokersAnnouncedBehavior(store: _progressionStore(ref));

  return () async {
    await mark();
    ref.invalidate(progressionProvider);
  };
}

/// See [RecordPickBehavior].
///
/// Kept alive because it refreshes [progressionProvider] after an await, by
/// when an auto-disposed provider's ref may be gone.
@Riverpod(keepAlive: true)
RecordPickFun recordPick(Ref ref) {
  final record = RecordPickBehavior(store: _progressionStore(ref));

  return (joker) async {
    await record(joker);
    ref.invalidate(progressionProvider);
  };
}

/// See [RecordProgressionBehavior].
///
/// Kept alive because it refreshes [progressionProvider] after an await, by
/// when an auto-disposed provider's ref may be gone.
@Riverpod(keepAlive: true)
RecordProgressionFun recordProgression(Ref ref) {
  final record = RecordProgressionBehavior(
    rules: ref.watch(di.gameRulesProvider),
    store: _progressionStore(ref),
  );

  return (mode, run) async {
    final change = await record(mode, run);

    // Every run may have changed its jokers' stats, celebrated or not.
    ref.invalidate(progressionProvider);

    return change;
  };
}

/// Keeps a finished run's total if it beats its mode's best, and says so.
///
/// Kept alive because it refreshes [bestScoreProvider] after an await, by when
/// an auto-disposed provider's ref may be gone.
@Riverpod(keepAlive: true)
RecordRunEndFun recordRunEnd(Ref ref) {
  final record = RecordRunEndBehavior(scores: ref.watch(di.bestScoresProvider));

  return (mode, total) async {
    final result = await record(mode, total);

    if (result.isNewBest) ref.invalidate(bestScoreProvider(mode));

    return result;
  };
}

@riverpod
RunStartForFun runStartFor(Ref ref) => RunStartForBehavior(
  clock: ref.watch(di.clockProvider),
  rules: ref.watch(di.gameRulesProvider),
  valueOf: ref.watch(di.remoteValueProvider),
).call;

/// Whether a run is saved to resume.
@riverpod
Future<bool> hasSavedRun(Ref ref) async =>
    await ref.watch(loadSavedRunProvider)() != null;

/// What the player has earned across runs. Throws when the device's storage
/// can't be reached at all.
@riverpod
LoadProgressionFun loadProgression(Ref ref) => _progressionStore(ref).load;

/// The run saved on this device, or null when there is none to resume.
/// Throws when the device's storage can't be reached at all.
@riverpod
LoadSavedRunFun loadSavedRun(Ref ref) => ref.watch(di.runStoreProvider).load;

/// See [SaveRunBehavior].
///
/// Kept alive so one behavior orders every write, and because it refreshes
/// [hasSavedRunProvider] after an await, by when an auto-disposed provider's
/// ref may be gone.
@Riverpod(keepAlive: true)
SaveRunFun saveRun(Ref ref) {
  final save = SaveRunBehavior(store: ref.watch(di.runStoreProvider));

  return (saved) async {
    await save(saved);

    // Only whether there is a run to resume is read from it, and that only
    // changes when a run starts or ends.
    final known = ref.read(hasSavedRunProvider).value;

    if (known == null || known == hasEnded(saved.run)) {
      ref.invalidate(hasSavedRunProvider);
    }
  };
}

/// Today's daily best, renewed with [todaysDailyDateProvider].
@riverpod
Future<int?> todaysDailyBest(Ref ref) {
  final (config: _, :mode, seed: _) = DailyRunBehavior(
    rules: ref.watch(di.gameRulesProvider),
    valueOf: ref.watch(di.remoteValueProvider),
  )(ref.watch(todaysDailyDateProvider));

  return ref.watch(bestScoreProvider(mode).future);
}

/// The UTC day today's daily run is played on, at its midnight, renewed at the
/// next UTC midnight when that day is over.
@riverpod
DateTime todaysDailyDate(Ref ref) {
  final now = ref.watch(di.clockProvider).now().toUtc();
  final midnight = Timer(
    DateTime.utc(now.year, now.month, now.day + 1).difference(now),
    ref.invalidateSelf,
  );

  ref.onDispose(midnight.cancel);

  return DateTime.utc(now.year, now.month, now.day);
}

/// Every world of the map in the map's order: whether it can be played yet,
/// its boss's target, its third star's threshold and what beating it unlocks.
@riverpod
List<WorldSummary> worldSummaries(Ref ref) => worldSummariesOf(
  ref.watch(di.gameRulesProvider),
  valueOf: ref.watch(di.remoteValueProvider),
);

/// What a new profile starts from, worked out from the rules so the storage
/// never needs to know them.
@riverpod
Progression initialProgression(Ref ref) =>
    startingProgression(ref.watch(di.gameRulesProvider));

/// See [TrackMoveFun].
@riverpod
TrackMoveFun trackMove(Ref ref) {
  final sink = ref.watch(di.analyticsSinkProvider);

  return (mode, before, transition) =>
      runEventsOf(mode, before, transition).forEach(sink.log);
}

/// See [TrackRunEndFun].
@riverpod
TrackRunEndFun trackRunEnd(Ref ref) {
  final sink = ref.watch(di.analyticsSinkProvider);

  return (run, change) => runEndEventsOf(run, change).forEach(sink.log);
}

List<Override> bindProviders({
  required AnalyticsSink Function(Ref ref) analyticsSink,
  required BestScores Function(Ref ref) bestScores,
  required Clock Function(Ref ref) clock,
  required GameRules Function(Ref ref) gameRules,
  required ProgressionStore Function(Ref ref) progressionStore,
  required RemoteValueFun Function(Ref ref) remoteValue,
  required RunStore Function(Ref ref) runStore,
}) => [
  di.analyticsSinkProvider.overrideWith(analyticsSink),
  di.bestScoresProvider.overrideWith(bestScores),
  di.clockProvider.overrideWith(clock),
  di.gameRulesProvider.overrideWith(gameRules),
  di.progressionStoreProvider.overrideWith(progressionStore),
  di.remoteValueProvider.overrideWith(remoteValue),
  di.runStoreProvider.overrideWith(runStore),
];

/// The device's progression with the worlds it has earned open, for every
/// read and write but a reset's.
ProgressionStore _progressionStore(Ref ref) => EarnedWorldsStore(
  rules: ref.watch(di.gameRulesProvider),
  store: ref.watch(di.progressionStoreProvider),
);
