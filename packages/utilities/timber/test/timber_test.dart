import 'package:flutter_test/flutter_test.dart';
import 'package:timber/timber.dart';

class _RecordingTree implements Tree {
  final List<({LogLevel level, String tag, String message, Object? error})>
  entries = [];

  @override
  void log(
    LogLevel level, {
    required String tag,
    required String logMessage,
    Object? exception,
    StackTrace? stackTrace,
  }) => entries.add((
    level: level,
    tag: tag,
    message: logMessage,
    error: exception,
  ));
}

void main() {
  late _RecordingTree tree;

  setUp(() {
    tree = _RecordingTree();
    Timber.plant(tree);
    addTearDown(() => Timber.chop(tree));
  });

  test('each level reaches every planted tree', () async {
    Timber.t(tag: 'x', logMessage: 'trace');
    Timber.d(tag: 'x', logMessage: 'debug');
    Timber.i(tag: 'x', logMessage: 'info');
    Timber.w(tag: 'x', logMessage: 'warn');
    Timber.e(tag: 'x', logMessage: 'error');

    expect(tree.entries.map((e) => e.level), [
      LogLevel.trace,
      LogLevel.debug,
      LogLevel.info,
      LogLevel.warn,
      LogLevel.error,
    ]);
  });

  // With nothing planted every call is a no-op — that is what makes this safe
  // to call from library code without stubbing it in tests.
  test('logging with no tree planted does nothing', () {
    Timber.chop(tree);

    Timber.e(tag: 'x', logMessage: 'nobody listening');

    expect(tree.entries, isEmpty);
    expect(Timber.forest(), isEmpty);
  });

  group('unawait', () {
    test('drops the value and logs a failure instead of throwing', () async {
      Future<int>.error(
        StateError('boom'),
      ).unawait(tag: 'x', logMessage: 'background work failed');

      // Let the error microtask run.
      await Future<void>.delayed(Duration.zero);

      expect(tree.entries.single.level, LogLevel.error);
      expect(tree.entries.single.message, 'background work failed');
      expect(tree.entries.single.error, isA<StateError>());
    });

    test('a success logs nothing', () async {
      Future<int>.value(1).unawait(tag: 'x', logMessage: 'should not appear');

      await Future<void>.delayed(Duration.zero);

      expect(tree.entries, isEmpty);
    });
  });
}
