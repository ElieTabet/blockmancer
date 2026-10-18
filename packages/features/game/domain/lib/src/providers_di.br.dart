import 'package:game_domain/src/contracts/best_scores.dart';
import 'package:game_domain/src/contracts/clock.dart';
import 'package:game_domain/src/contracts/engagement_store.dart';
import 'package:game_domain/src/contracts/progression_store.dart';
import 'package:game_domain/src/contracts/run_store.dart';
import 'package:game_domain/src/entities/run_tuning.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_domain/shared_domain.dart';

part 'providers_di.br.g.dart';

// game_domain — inbound dependency-injection slots. Each throws until the
// composition layer overrides it.

/// Where what players do is counted: the testers' log today, Firebase
/// Analytics later.
/// Whether the player bought Remove ads: no interstitial, ever.
@riverpod
Future<bool> adsRemoved(Ref ref) => throw UnimplementedError(
  'adsRemovedProvider must be overridden by the composition layer',
);

/// This build's version (`1.0.0`): the rating prompt asks once per version.
@riverpod
Future<String> appVersion(Ref ref) => throw UnimplementedError(
  'appVersionProvider must be overridden by the composition layer',
);

@riverpod
AnalyticsSink analyticsSink(Ref ref) => throw UnimplementedError(
  'analyticsSinkProvider must be overridden by the composition layer',
);

@riverpod
BestScores bestScores(Ref ref) => throw UnimplementedError(
  'bestScoresProvider must be overridden by the composition layer',
);

@riverpod
Clock clock(Ref ref) => throw UnimplementedError(
  'clockProvider must be overridden by the composition layer',
);

/// The game's rules. Composition binds the engine; the game never imports it,
/// so its screens can only draw what the rules say. Here rather than in
/// presentation because the domain decides each mode's seed with them.
@riverpod
GameRules gameRules(Ref ref) => throw UnimplementedError(
  'gameRulesProvider must be overridden by the composition layer',
);

@riverpod
EngagementStore engagementStore(Ref ref) => throw UnimplementedError(
  'engagementStoreProvider must be overridden by the composition layer',
);

@riverpod
ProgressionStore progressionStore(Ref ref) => throw UnimplementedError(
  'progressionStoreProvider must be overridden by the composition layer',
);

/// What Remote Config publishes, read by key: the numbers a new run is
/// tuned with (see `tuned`).
@riverpod
RemoteValueFun remoteValue(Ref ref) => throw UnimplementedError(
  'remoteValueProvider must be overridden by the composition layer',
);

@riverpod
RunStore runStore(Ref ref) => throw UnimplementedError(
  'runStoreProvider must be overridden by the composition layer',
);

/// Shows the interstitial kept loaded, and says what came of it. Never throws.
typedef ShowAdFun = Future<AdResult> Function();

@riverpod
ShowAdFun showInterstitial(Ref ref) => throw UnimplementedError(
  'showInterstitialProvider must be overridden by the composition layer',
);

/// Asks the OS for its rating prompt, which it may or may not show.
typedef RequestReviewFun = Future<void> Function();

@riverpod
RequestReviewFun requestReview(Ref ref) => throw UnimplementedError(
  'requestReviewProvider must be overridden by the composition layer',
);

/// Whether this launch hit an uncaught error.
typedef SessionHadErrorFun = bool Function();

@riverpod
SessionHadErrorFun sessionHadError(Ref ref) => throw UnimplementedError(
  'sessionHadErrorProvider must be overridden by the composition layer',
);

/// Hands a run total to a leaderboard, which keeps the player's best. Never
/// throws, and never waits on a sign-in the player turned down.
typedef SubmitScoreFun = Future<void> Function(int score);

/// The all-time board: every run's total.
@riverpod
SubmitScoreFun submitBestScore(Ref ref) => throw UnimplementedError(
  'submitBestScoreProvider must be overridden by the composition layer',
);

/// The day's board, which the platform resets every day at 00:00 UTC.
@riverpod
SubmitScoreFun submitDailyScore(Ref ref) => throw UnimplementedError(
  'submitDailyScoreProvider must be overridden by the composition layer',
);
