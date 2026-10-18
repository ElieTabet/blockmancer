import 'package:game_domain/src/entities/engagement.br.dart';

/// [Engagement], kept on this device.
abstract interface class EngagementStore {
  /// A fresh [Engagement] until something has been saved, or when what is
  /// saved can no longer be read.
  Future<Engagement> load();

  Future<void> save(Engagement engagement);
}
