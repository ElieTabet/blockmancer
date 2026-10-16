import 'package:blockmancer_app/config/env.dart';
import 'package:flutter/foundation.dart';

/// Build-time configuration. It lives in the app rather than in a package
/// because the app is the only thing that reads it: composition takes the base
/// URL as a value, so nothing below it depends on how configuration is shaped.
@immutable
final class AppConfig {
  final String apiBaseUrl;
  final Env env;

  /// `host:port` of an HTTP debugging proxy, or null for a direct connection.
  final String? httpProxy;

  /// The id Apple assigns once the app is listed — what the update screens
  /// point at on iOS. Null until then.
  final String? iosAppStoreId;

  const AppConfig({
    required this.apiBaseUrl,
    required this.env,
    this.httpProxy,
    this.iosAppStoreId,
  });

  /// `String.fromEnvironment` is a compile-time constant, so this needs no
  /// wiring to work in a built app — pass values with
  /// `--dart-define-from-file=env/<flavor>.json`.
  ///
  /// The defaults are the local MAMP API rather than empty strings: every
  /// `flutter test` run and any `flutter run` without the flag lands here, and
  /// an empty base URL fails confusingly deep inside Dio.
  factory AppConfig.fromEnvironment() => AppConfig(
    apiBaseUrl: const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://localhost:8888/api/mobile/v1',
    ),
    env: Env.fromValue(
      const String.fromEnvironment('ENV', defaultValue: 'dev'),
    ),
    httpProxy: resolveHttpProxy(
      allowed: const bool.fromEnvironment('ALLOW_SYSTEM_PROXY'),
      explicitProxy: const String.fromEnvironment('EXPLICIT_PROXY'),
    ),
    iosAppStoreId: switch (const String.fromEnvironment('IOS_APP_STORE_ID')) {
      '' => null,
      final id => id,
    },
  );

  /// Both defines are required, and the opt-in is checked first: a build that
  /// carries an address but was never opted in connects directly.
  ///
  /// There is no system-proxy fallback to resolve against, which is the whole
  /// reason this exists — Dart's `HttpClient` never reads the one the OS is
  /// configured with, so a proxy that isn't named here is invisible to Dio.
  @visibleForTesting
  static String? resolveHttpProxy({
    required bool allowed,
    required String explicitProxy,
  }) => allowed && explicitProxy.isNotEmpty ? explicitProxy : null;

  bool get isProduction => env == Env.prod;
}
