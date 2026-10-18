import 'dart:async';

import 'package:app_update_domain/src/behaviors/update_check_behavior.dart';
import 'package:app_update_domain/src/contracts/update_dismissals.dart';
import 'package:app_update_domain/src/entities/store_platform.dart';
import 'package:app_update_domain/src/entities/update_need.br.dart';
import 'package:app_update_domain/src/providers_di.br.dart' as di;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.br.g.dart';

// app_update_domain — public providers exposed by this layer.

typedef DismissUpdateOfferFun = Future<void> Function();

/// How long the update check waits for the launch's fetch: past it, the last
/// values fetched decide, so a slow network never holds the splash.
const _fetchWait = Duration(seconds: 2);

/// What this version has to do, once the launch's fetch has landed (or
/// [_fetchWait] has passed).
@riverpod
Future<UpdateNeed> updateNeed(Ref ref) async {
  // Everything read before the wait: nothing may touch the ref after it.
  final appVersion = ref.watch(di.appVersionProvider.future);
  final fetched = ref.watch(di.remoteValuesFetchedProvider.future);
  final platform = ref.watch(di.storePlatformProvider);
  final valueOf = ref.watch(di.remoteValueProvider);

  await fetched.timeout(_fetchWait, onTimeout: () {});

  return updateNeedOf(
    appVersion: await appVersion,
    platform: platform,
    valueOf: valueOf,
  );
}

/// Whether this version no longer plays.
@riverpod
Future<bool> updateRequired(Ref ref) async =>
    await ref.watch(updateNeedProvider.future) is UpdateRequired;

/// The newer version to offer, or null when there is none or its banner was
/// already closed.
@riverpod
Future<String?> updateOffer(Ref ref) async {
  final dismissals = ref.watch(di.updateDismissalsProvider);
  final need = await ref.watch(updateNeedProvider.future);

  if (need is! UpdateOffered) return null;

  return await dismissals.dismissedVersion() == need.latest
      ? null
      : need.latest;
}

/// Closes the banner for the version it offers, for good.
///
/// Kept alive because it refreshes [updateOfferProvider] after an await, by
/// when an auto-disposed provider's ref may be gone.
@Riverpod(keepAlive: true)
DismissUpdateOfferFun dismissUpdateOffer(Ref ref) => () async {
  final latest = await ref.read(updateOfferProvider.future);

  if (latest == null) return;

  await ref.read(di.updateDismissalsProvider).dismiss(latest);
  ref.invalidate(updateOfferProvider);
};

/// This build's store page.
@riverpod
String storeUrl(Ref ref) {
  final urls = ref.watch(di.storeUrlsProvider);

  return switch (ref.watch(di.storePlatformProvider)) {
    .android => urls.android,
    .ios => urls.ios,
  };
}

List<Override> bindProviders({
  required Future<String> Function(Ref ref) appVersion,
  required RemoteValueFun Function(Ref ref) remoteValue,
  required Future<void> Function(Ref ref) remoteValuesFetched,
  required StorePlatform Function(Ref ref) storePlatform,
  required ({String android, String ios}) Function(Ref ref) storeUrls,
  required UpdateDismissals Function(Ref ref) updateDismissals,
}) => [
  di.appVersionProvider.overrideWith(appVersion),
  di.remoteValueProvider.overrideWith(remoteValue),
  di.remoteValuesFetchedProvider.overrideWith(remoteValuesFetched),
  di.storePlatformProvider.overrideWith(storePlatform),
  di.storeUrlsProvider.overrideWith(storeUrls),
  di.updateDismissalsProvider.overrideWith(updateDismissals),
];
