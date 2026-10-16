import 'dart:developer' as developer;

import 'package:timber/src/timber.dart';

/// Writes to the IDE/console via `dart:developer`. Intended for debug builds —
/// plant it in `boot()` behind a `kDebugMode` check.
final class DebugTree implements Tree {
  final LogLevel minimumLevel;

  const DebugTree({this.minimumLevel = LogLevel.debug});

  @override
  void log(
    LogLevel level, {
    required String tag,
    required String logMessage,
    Object? exception,
    StackTrace? stackTrace,
  }) {
    if (level.index < minimumLevel.index) return;

    developer.log(
      logMessage,
      name: '${level.value} $tag',
      error: exception,
      stackTrace: stackTrace,
    );
  }
}
