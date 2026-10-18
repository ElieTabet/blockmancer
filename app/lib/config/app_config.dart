import 'package:blockmancer_app/config/env.dart';
import 'package:flutter/foundation.dart';

/// Build-time configuration. It lives in the app rather than in a package
/// because the app is the only thing that reads it.
@immutable
final class AppConfig {
  final Env env;

  /// A test build (TestFlight, Play internal testing): the testers' tools
  /// show, and test ad units play. Set only by the test build scripts.
  final bool testTools;

  const AppConfig({required this.env, this.testTools = false});

  /// `String.fromEnvironment` is a compile-time constant, so this needs no
  /// wiring to work in a built app — pass values with
  /// `--dart-define-from-file=env/<flavor>.json`. With no flag, including every
  /// `flutter test` run, it is a dev build.
  factory AppConfig.fromEnvironment() => AppConfig(
    env: Env.fromValue(
      const String.fromEnvironment('ENV', defaultValue: 'dev'),
    ),
    testTools: const bool.fromEnvironment('TEST_TOOLS'),
  );

  bool get isProduction => env == Env.prod;
}
