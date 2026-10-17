import 'package:game_domain/src/contracts/run_store.dart';
import 'package:game_domain/src/entities/run_end.dart';
import 'package:game_domain/src/entities/saved_run.br.dart';

/// Keeps a run in play as the one to resume, and forgets one that has ended,
/// so it is never offered again.
///
/// Writes land in the order they were asked for, whatever each one costs the
/// store: a slow save landing after the clear that followed it would bring a
/// finished run back.
class SaveRunBehavior {
  Future<void> _last = Future.value();
  final RunStore _store;

  SaveRunBehavior({required RunStore store}) : _store = store;

  Future<void> call(SavedRun saved) {
    final write = _last.then(
      (_) => hasEnded(saved.run) ? _store.clear() : _store.save(saved),
    );

    // One failed write mustn't block the ones queued behind it.
    _last = write.then((_) {}, onError: (Object _) {});

    return write;
  }
}
