import 'dart:async';

/// What the game screen is still doing with a move: playing it back, or
/// writing what it changed on the device. What would take the screen away
/// waits for [settled], so a move is never cut short nor its save left open.
final class GameActivity {
  Completer<void>? _idle;
  var _playing = false;
  final _writes = <Future<void>>{};

  /// Once nothing plays and no write is open. A write may land while the
  /// next move plays, so both are checked again until neither waits.
  Future<void> settled() async {
    while (true) {
      if (_playing) {
        await (_idle ??= Completer()).future;
        continue;
      }

      if (_writes.isEmpty) return;

      await Future.wait(_writes.toList());
    }
  }

  void startPlaying() => _playing = true;

  void stopPlaying() {
    final idle = _idle;

    _idle = null;
    _playing = false;
    idle?.complete();
  }

  /// [write] must never throw: the game's writes log their own failures.
  void track(Future<void> write) {
    _writes.add(write);
    unawaited(write.whenComplete(() => _writes.remove(write)));
  }
}
