import 'dart:async';

import 'package:app_providers/src/providers_internal.br.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Fetches what Remote Config publishes, not waited for: until it lands, and
/// on a launch with no network, the last values fetched (or the defaults)
/// play. A run reads them as it starts, so a fetch never changes one in
/// progress.
void fetchRemoteConfig(ProviderContainer container) =>
    unawaited(container.read(remoteValuesFetchedProvider.future));
