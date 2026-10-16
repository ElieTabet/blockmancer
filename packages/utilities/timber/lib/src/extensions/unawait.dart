import 'dart:async';

import 'package:timber/src/timber.dart';

extension UnawaitedLog<T> on Future<T> {
  /// Runs a future fire-and-forget: the value is dropped, and a failure is
  /// logged rather than surfacing as an unhandled async error.
  ///
  /// The point is that "I am deliberately not awaiting this" and "I have
  /// decided what happens if it fails" become one visible decision, instead of
  /// a bare `unawaited()` that silently swallows.
  void unawait({
    required String logMessage,
    required String tag,
    LogLevel logLevel = LogLevel.error,
  }) => unawaited(
    then<void>(
      (_) {},
      onError: (Object error, StackTrace stackTrace) => Timber.log(
        logLevel,
        tag: tag,
        logMessage: logMessage,
        exception: error,
        stackTrace: stackTrace,
      ),
    ),
  );
}
