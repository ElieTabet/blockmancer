import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_domain/src/behaviors/save_run_behavior.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fakes.dart';

/// A store whose saves wait for [slowSave] while clears land at once.
final class _UnevenStore extends FakeRunStore {
  final slowSave = Completer<void>();

  @override
  Future<void> save(SavedRun run) async {
    await slowSave.future;
    await super.save(run);
  }
}

void main() {
  test('a slow save never lands after the clear that followed it', () async {
    // Given
    final store = _UnevenStore();
    final save = SaveRunBehavior(store: store);

    // When: the last move is saved, then the run ends before that save lands
    final lastMove = save(savedIn(const .playing()));
    final ended = save(savedIn(const RunPhase.over()));
    store.slowSave.complete();
    await Future.wait([lastMove, ended]);

    // Then
    expect(store.saved, isNull);
  });

  test('a failed write does not hold up the next one', () async {
    // Given
    final store = _FailingOnceStore();
    final save = SaveRunBehavior(store: store);

    // When
    final failed = save(savedIn(const .playing()));
    final next = save(savedIn(const .playing()));

    // Then
    await expectLater(failed, throwsStateError);
    await next;
    expect(store.saved, savedIn(const .playing()));
  });
}

final class _FailingOnceStore extends FakeRunStore {
  var _failed = false;

  @override
  Future<void> save(SavedRun run) async {
    if (!_failed) {
      _failed = true;
      throw StateError('disk full');
    }

    await super.save(run);
  }
}
