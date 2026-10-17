import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:settings_domain/src/contracts/settings_store.dart';

part 'providers_di.br.g.dart';

// settings_domain — inbound dependency-injection slots. Each throws until the
// composition layer overrides it.

/// Forgets everything the player has achieved. What that is belongs to the
/// game, which this package never imports.
typedef ClearProgressFun = Future<void> Function();

@riverpod
ClearProgressFun clearProgress(Ref ref) => throw UnimplementedError(
  'clearProgressProvider must be overridden by the composition layer',
);

@riverpod
SettingsStore settingsStore(Ref ref) => throw UnimplementedError(
  'settingsStoreProvider must be overridden by the composition layer',
);
