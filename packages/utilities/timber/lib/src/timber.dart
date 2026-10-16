/// A logging facade: callers log through [Timber], and where the output goes is
/// decided once, at startup, by whichever [Tree]s are planted.
///
/// With no tree planted every call is a no-op, which is exactly what tests and
/// release builds want — nothing to stub, nothing to silence.
final class Timber {
  static final Timber _instance = Timber._();

  final List<Tree> _trees = [];

  Timber._();

  static void plant(Tree tree) => _instance._trees.add(tree);

  static void chop(Tree tree) => _instance._trees.remove(tree);

  static List<Tree> forest() => List.unmodifiable(_instance._trees);

  static void log(
    LogLevel level, {
    required String tag,
    required String logMessage,
    Object? exception,
    StackTrace? stackTrace,
  }) {
    for (final tree in _instance._trees) {
      tree.log(
        level,
        tag: tag,
        logMessage: logMessage,
        exception: exception,
        stackTrace: stackTrace,
      );
    }
  }

  static void t({
    required String tag,
    required String logMessage,
    Object? exception,
    StackTrace? stackTrace,
  }) => log(
    LogLevel.trace,
    tag: tag,
    logMessage: logMessage,
    exception: exception,
    stackTrace: stackTrace,
  );

  static void d({
    required String tag,
    required String logMessage,
    Object? exception,
    StackTrace? stackTrace,
  }) => log(
    LogLevel.debug,
    tag: tag,
    logMessage: logMessage,
    exception: exception,
    stackTrace: stackTrace,
  );

  static void i({
    required String tag,
    required String logMessage,
    Object? exception,
    StackTrace? stackTrace,
  }) => log(
    LogLevel.info,
    tag: tag,
    logMessage: logMessage,
    exception: exception,
    stackTrace: stackTrace,
  );

  static void w({
    required String tag,
    required String logMessage,
    Object? exception,
    StackTrace? stackTrace,
  }) => log(
    LogLevel.warn,
    tag: tag,
    logMessage: logMessage,
    exception: exception,
    stackTrace: stackTrace,
  );

  static void e({
    required String tag,
    required String logMessage,
    Object? exception,
    StackTrace? stackTrace,
  }) => log(
    LogLevel.error,
    tag: tag,
    logMessage: logMessage,
    exception: exception,
    stackTrace: stackTrace,
  );
}

enum LogLevel {
  debug('DEBUG'),
  error('ERROR'),
  info('INFO'),
  trace('TRACE'),
  warn('WARN');

  const LogLevel(this.value);

  final String value;
}

/// A log sink. Implement this to send output somewhere — the console, a file, a
/// crash reporter — without any caller changing.
abstract interface class Tree {
  void log(
    LogLevel level, {
    required String tag,
    required String logMessage,
    Object? exception,
    StackTrace? stackTrace,
  });
}
