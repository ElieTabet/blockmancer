import 'package:home_presentation/src/providers_di.br.dart' as di;
import 'package:home_presentation/src/routing/home_routing.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_domain/shared_domain.dart';

// home_presentation — public providers exposed by this layer.

List<Override> bindProviders({
  required Future<int?> Function(Ref ref) dailyBest,
  required DateTime Function(Ref ref) dailyDate,
  required Future<int> Function(Ref ref) dailyStreak,
  required di.DismissUpdateOfferFun Function(Ref ref) dismissUpdateOffer,
  required Future<bool> Function(Ref ref) hasSavedRun,
  required JokerCollection Function(Ref ref) jokerCollection,
  required di.MarkJokersAnnouncedFun Function(Ref ref) markJokersAnnounced,
  required di.MarkSpellbookSeenFun Function(Ref ref) markSpellbookSeen,
  required di.OpenStoreListingFun Function(Ref ref) openStoreListing,
  required Future<int?> Function(Ref ref) practiceBest,
  required Future<Progression> Function(Ref ref) progression,
  required bool Function(Ref ref) reduceMotionSetting,
  required di.ShowDailyLeaderboardFun Function(Ref ref) showDailyLeaderboard,
  required Future<String?> Function(Ref ref) updateOffer,
  required List<WorldSummary> Function(Ref ref) worlds,
}) => [
  di.dailyBestProvider.overrideWith(dailyBest),
  di.dailyDateProvider.overrideWith(dailyDate),
  di.dailyStreakProvider.overrideWith(dailyStreak),
  di.dismissUpdateOfferProvider.overrideWith(dismissUpdateOffer),
  di.hasSavedRunProvider.overrideWith(hasSavedRun),
  di.jokerCollectionProvider.overrideWith(jokerCollection),
  di.markJokersAnnouncedProvider.overrideWith(markJokersAnnounced),
  di.markSpellbookSeenProvider.overrideWith(markSpellbookSeen),
  di.openStoreListingProvider.overrideWith(openStoreListing),
  di.practiceBestProvider.overrideWith(practiceBest),
  di.progressionProvider.overrideWith(progression),
  di.reduceMotionSettingProvider.overrideWith(reduceMotionSetting),
  di.showDailyLeaderboardProvider.overrideWith(showDailyLeaderboard),
  di.updateOfferProvider.overrideWith(updateOffer),
  di.worldsProvider.overrideWith(worlds),
];

List<Override> bindRoutingProviders({
  required HomeRouting Function(Ref ref) homeRouting,
}) => [di.homeRoutingProvider.overrideWith(homeRouting)];
