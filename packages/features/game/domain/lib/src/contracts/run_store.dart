import 'package:game_domain/src/entities/saved_run.br.dart';

/// The one unfinished run kept on this device.
abstract interface class RunStore {
  Future<void> clear();

  /// Null when nothing is saved, or what is saved can no longer be read.
  /// Throws when the device's storage can't be reached at all.
  Future<SavedRun?> load();

  Future<void> save(SavedRun run);
}
