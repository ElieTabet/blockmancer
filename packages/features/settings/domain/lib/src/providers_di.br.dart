import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:settings_domain/src/contracts/settings_store.dart';
import 'package:settings_domain/src/entities/app_details.br.dart';

part 'providers_di.br.g.dart';

// settings_domain — inbound dependency-injection slots. Each throws until the
// composition layer overrides it.

/// Kept for the session: neither the build nor the phone changes while the app
/// runs.
@Riverpod(keepAlive: true)
Future<AppDetails> appDetails(Ref ref) => throw UnimplementedError(
  'appDetailsProvider must be overridden by the composition layer',
);

/// Forgets everything the player has achieved. What that is belongs to the
/// game, which this package never imports.
typedef ClearProgressFun = Future<void> Function();

@riverpod
ClearProgressFun clearProgress(Ref ref) => throw UnimplementedError(
  'clearProgressProvider must be overridden by the composition layer',
);

/// Opens a mail draft for [mailto], and answers whether one opened: false
/// when the phone has no mail app.
typedef ComposeEmailFun = Future<bool> Function(Uri mailto);

@riverpod
ComposeEmailFun composeEmail(Ref ref) => throw UnimplementedError(
  'composeEmailProvider must be overridden by the composition layer',
);

/// The testers' play stats, as the JSON summary they send.
typedef ExportTestStatsFun = Future<String> Function();

@riverpod
ExportTestStatsFun exportTestStats(Ref ref) => throw UnimplementedError(
  'exportTestStatsProvider must be overridden by the composition layer',
);

@riverpod
SettingsStore settingsStore(Ref ref) => throw UnimplementedError(
  'settingsStoreProvider must be overridden by the composition layer',
);
