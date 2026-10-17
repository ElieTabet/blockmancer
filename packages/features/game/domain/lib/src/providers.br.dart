import 'dart:async';

import 'package:game_domain/src/behaviors/record_run_end_behavior.dart';
import 'package:game_domain/src/behaviors/save_run_behavior.dart';
import 'package:game_domain/src/contracts/best_scores.dart';
import 'package:game_domain/src/contracts/clock.dart';
import 'package:game_domain/src/contracts/run_store.dart';
import 'package:game_domain/src/entities/game_launch.dart';
import 'package:game_domain/src/entities/game_mode.br.dart';
import 'package:game_domain/src/entities/run_end.dart';
import 'package:game_domain/src/entities/run_end_record.br.dart';
import 'package:game_domain/src/entities/saved_run.br.dart';
import 'package:game_domain/src/providers_di.br.dart' as di;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_domain/shared_domain.dart';

part 'providers.br.g.dart';

// game_domain — public providers exposed by this layer.

typedef RecordRunEndFun =
    Future<RunEndRecord> Function(GameMode mode, int total);

/// A run to start: the mode it counts for, and the seed the rules play it on.
typedef RunStart = ({GameMode mode, int seed});

/// The run [GameLaunch] asks for, as of now: today's daily run, or a practice
/// run on a fresh seed. A function, so each launch reads the clock afresh.
/// A resume normally starts nothing — it loads the saved run — so it only gets
/// here when the save was lost, and starts today's daily instead.
typedef RunStartForFun = RunStart Function(GameLaunch launch);

typedef LoadSavedRunFun = Future<SavedRun?> Function();

/// Keeps [run] as the one to resume, or forgets it once it is over.
typedef SaveRunFun = Future<void> Function(SavedRun run);

/// The best run total of [mode] on this device, or null before its first run.
@riverpod
Future<int?> bestScore(Ref ref, GameMode mode) =>
    ref.watch(di.bestScoresProvider).best(mode);

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
RunStartForFun runStartFor(Ref ref) {
  final clock = ref.watch(di.clockProvider);
  final rules = ref.watch(di.gameRulesProvider);

  return (launch) => switch (launch) {
    .daily || .resume => dailyRunOn(clock.now(), rules: rules),
    // Any 32 bits will do: practice runs are not meant to be replayed.
    .practice => (
      mode: const .practice(),
      seed: clock.now().microsecondsSinceEpoch & 0xFFFFFFFF,
    ),
  };
}

/// Whether a run is saved to resume.
@riverpod
Future<bool> hasSavedRun(Ref ref) async =>
    await ref.watch(loadSavedRunProvider)() != null;

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

/// Today's daily best, renewed at the next UTC midnight when the day it was
/// read for is over.
@riverpod
Future<int?> todaysDailyBest(Ref ref) {
  final now = ref.watch(di.clockProvider).now().toUtc();
  final (:mode, seed: _) = dailyRunOn(
    now,
    rules: ref.watch(di.gameRulesProvider),
  );
  final midnight = Timer(
    DateTime.utc(now.year, now.month, now.day + 1).difference(now),
    ref.invalidateSelf,
  );

  ref.onDispose(midnight.cancel);

  return ref.watch(bestScoreProvider(mode).future);
}

/// The daily run of the UTC day [now] falls on. Keyed by that day itself, not
/// by the seed: the seed is the rules' to derive, and may change without
/// orphaning the saved bests.
RunStart dailyRunOn(DateTime now, {required GameRules rules}) {
  final day = now.toUtc();

  return (
    mode: .daily(day: day.year * 10000 + day.month * 100 + day.day),
    seed: rules.dailySeed(day: day.day, month: day.month, year: day.year),
  );
}

List<Override> bindProviders({
  required BestScores Function(Ref ref) bestScores,
  required Clock Function(Ref ref) clock,
  required GameRules Function(Ref ref) gameRules,
  required RunStore Function(Ref ref) runStore,
}) => [
  di.bestScoresProvider.overrideWith(bestScores),
  di.clockProvider.overrideWith(clock),
  di.gameRulesProvider.overrideWith(gameRules),
  di.runStoreProvider.overrideWith(runStore),
];
