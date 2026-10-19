import 'package:push_notifications_domain/src/entities/reminder_log.br.dart';

/// Where the reminders' log is kept between launches.
abstract interface class ReminderLogStore {
  /// The log kept, or an empty one when there is none or it can't be read.
  Future<ReminderLog> load();

  Future<void> save(ReminderLog log);
}
