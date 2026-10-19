import 'dart:async';

import 'package:app_providers/src/providers_internal.br.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Fetches what Remote Config publishes, not waited for: until it lands, and
/// on a launch with no network, the last values fetched (or the defaults)
/// play. Then keeps them current: live while the app is open, and fetched
/// again on every return. A run reads them as it starts, so a change never
/// reaches one in progress.
void fetchRemoteConfig(ProviderContainer container) {
  // Counting from before the launch's fetch, so its change isn't missed.
  container.read(remoteValuesRevisionProvider);
  unawaited(container.read(remoteValuesFetchedProvider.future));
  container.read(remoteValuesKeptCurrentProvider);
}
