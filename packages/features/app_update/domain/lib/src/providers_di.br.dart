import 'package:app_update_domain/src/behaviors/update_check_behavior.dart';
import 'package:app_update_domain/src/contracts/update_dismissals.dart';
import 'package:app_update_domain/src/entities/store_platform.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers_di.br.g.dart';

// app_update_domain — inbound dependency-injection slots. Each throws until
// the composition layer overrides it.

/// This build's version, as the stores know it (`1.0.0`).
@riverpod
Future<String> appVersion(Ref ref) => throw UnimplementedError(
  'appVersionProvider must be overridden by the composition layer',
);

@riverpod
RemoteValueFun remoteValue(Ref ref) => throw UnimplementedError(
  'remoteValueProvider must be overridden by the composition layer',
);

/// Completes once the launch's Remote Config fetch has landed or given up.
@riverpod
Future<void> remoteValuesFetched(Ref ref) => throw UnimplementedError(
  'remoteValuesFetchedProvider must be overridden by the composition layer',
);

@riverpod
StorePlatform storePlatform(Ref ref) => throw UnimplementedError(
  'storePlatformProvider must be overridden by the composition layer',
);

/// Each store's page for the app.
@riverpod
({String android, String ios}) storeUrls(Ref ref) => throw UnimplementedError(
  'storeUrlsProvider must be overridden by the composition layer',
);

@riverpod
UpdateDismissals updateDismissals(Ref ref) => throw UnimplementedError(
  'updateDismissalsProvider must be overridden by the composition layer',
);
