import 'package:home_presentation/src/routing/home_routing.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_domain/shared_domain.dart';

part 'providers_di.br.g.dart';

// home_presentation — inbound dependency-injection slots. Each throws until
// the composition layer overrides it.

/// Today's daily best on this device, or null before today's first run.
@riverpod
Future<int?> dailyBest(Ref ref) => throw UnimplementedError(
  'dailyBestProvider must be overridden by the composition layer',
);

/// The UTC day today's daily run is played on, at its midnight.
@riverpod
DateTime dailyDate(Ref ref) => throw UnimplementedError(
  'dailyDateProvider must be overridden by the composition layer',
);

/// Whether a run is saved to pick up again.
@riverpod
Future<bool> hasSavedRun(Ref ref) => throw UnimplementedError(
  'hasSavedRunProvider must be overridden by the composition layer',
);

@riverpod
HomeRouting homeRouting(Ref ref) => throw UnimplementedError(
  'homeRoutingProvider must be overridden by the composition layer (app_router)',
);

/// Every joker in pairs, with how each pair is unlocked: the rules', so it
/// never changes while the app runs.
@riverpod
JokerCollection jokerCollection(Ref ref) => throw UnimplementedError(
  'jokerCollectionProvider must be overridden by the composition layer',
);

typedef MarkJokersAnnouncedFun = Future<void> Function();

/// Forgets the jokers [Progression.unannouncedJokers] holds, once the map has
/// announced them.
@riverpod
MarkJokersAnnouncedFun markJokersAnnounced(Ref ref) => throw UnimplementedError(
  'markJokersAnnouncedProvider must be overridden by the composition layer',
);

/// The practice best on this device, or null before a first practice run.
@riverpod
Future<int?> practiceBest(Ref ref) => throw UnimplementedError(
  'practiceBestProvider must be overridden by the composition layer',
);

/// What the player has earned across runs. Refreshed when a run earns
/// something, so the map is up to date when the run is left.
@riverpod
Future<Progression> progression(Ref ref) => throw UnimplementedError(
  'progressionProvider must be overridden by the composition layer',
);

/// Whether the player turned reduce motion on in the app's settings. The
/// platform's own setting is read by the widget that moves.
@riverpod
bool reduceMotionSetting(Ref ref) => throw UnimplementedError(
  'reduceMotionSettingProvider must be overridden by the composition layer',
);

/// Every world of the map, in the map's order.
@riverpod
List<WorldSummary> worlds(Ref ref) => throw UnimplementedError(
  'worldsProvider must be overridden by the composition layer',
);

/// Closes the update banner for the version it offers, for good.
typedef DismissUpdateOfferFun = Future<void> Function();

@riverpod
DismissUpdateOfferFun dismissUpdateOffer(Ref ref) => throw UnimplementedError(
  'dismissUpdateOfferProvider must be overridden by the composition layer',
);

/// Opens the app's page in its store, and answers whether it opened.
typedef OpenStoreListingFun = Future<bool> Function();

@riverpod
OpenStoreListingFun openStoreListing(Ref ref) => throw UnimplementedError(
  'openStoreListingProvider must be overridden by the composition layer',
);

/// The newer version to offer, or null when there is none or its banner was
/// closed.
@riverpod
Future<String?> updateOffer(Ref ref) => throw UnimplementedError(
  'updateOfferProvider must be overridden by the composition layer',
);
