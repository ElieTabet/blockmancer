import 'package:shared_domain/shared_domain.dart';

/// The player's progression, kept on this device.
abstract interface class ProgressionStore {
  /// The starting progression until something has been saved, or when what is
  /// saved can no longer be read.
  Future<Progression> load();

  Future<void> save(Progression progression);
}
