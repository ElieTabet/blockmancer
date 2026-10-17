import 'package:home_presentation/src/providers_di.br.dart' as di;
import 'package:home_presentation/src/routing/home_routing.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_domain/shared_domain.dart';

// home_presentation — public providers exposed by this layer.

List<Override> bindProviders({
  required Future<int?> Function(Ref ref) dailyBest,
  required DateTime Function(Ref ref) dailyDate,
  required Future<bool> Function(Ref ref) hasSavedRun,
  required JokerCollection Function(Ref ref) jokerCollection,
  required di.MarkJokersAnnouncedFun Function(Ref ref) markJokersAnnounced,
  required Future<int?> Function(Ref ref) practiceBest,
  required Future<Progression> Function(Ref ref) progression,
  required bool Function(Ref ref) reduceMotionSetting,
  required List<WorldSummary> Function(Ref ref) worlds,
}) => [
  di.dailyBestProvider.overrideWith(dailyBest),
  di.dailyDateProvider.overrideWith(dailyDate),
  di.hasSavedRunProvider.overrideWith(hasSavedRun),
  di.jokerCollectionProvider.overrideWith(jokerCollection),
  di.markJokersAnnouncedProvider.overrideWith(markJokersAnnounced),
  di.practiceBestProvider.overrideWith(practiceBest),
  di.progressionProvider.overrideWith(progression),
  di.reduceMotionSettingProvider.overrideWith(reduceMotionSetting),
  di.worldsProvider.overrideWith(worlds),
];

List<Override> bindRoutingProviders({
  required HomeRouting Function(Ref ref) homeRouting,
}) => [di.homeRoutingProvider.overrideWith(homeRouting)];
