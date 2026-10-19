import 'dart:convert';

import 'package:push_notifications_data/src/package_name.dart';
import 'package:push_notifications_domain/push_notifications_domain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timber/timber.dart';

/// [ReminderLogStore] as one JSON string on the device. A message this build
/// doesn't know (a later build's, after a downgrade) is dropped; a string that
/// can't be read is an empty log, which only forgets what was shown.
final class SharedPreferencesReminderLogStore implements ReminderLogStore {
  const SharedPreferencesReminderLogStore();

  static const _key = 'reminder.log';

  @override
  Future<ReminderLog> load() async {
    final raw = (await SharedPreferences.getInstance()).getString(_key);

    if (raw == null) return const ReminderLog();

    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;

      return ReminderLog(
        planned: [
          for (final entry in json['planned'] as List<dynamic>)
            ?_plannedOf(entry as Map<String, dynamic>),
        ],
        recent: [
          for (final id in json['recent'] as List<dynamic>)
            ?ReminderMessage.fromId(id as String),
        ],
      );
    } on Object catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage:
            "The reminders' log could not be read (${error.runtimeType}); "
            'starting afresh',
        stackTrace: stackTrace,
      );

      return const ReminderLog();
    }
  }

  @override
  Future<void> save(ReminderLog log) async =>
      (await SharedPreferences.getInstance()).setString(
        _key,
        jsonEncode({
          'planned': [
            for (final reminder in log.planned)
              {
                'at': reminder.at.toUtc().toIso8601String(),
                'message': reminder.message.id,
                'streak': reminder.streak,
              },
          ],
          'recent': [for (final message in log.recent) message.id],
        }),
      );

  static PlannedReminder? _plannedOf(Map<String, dynamic> json) {
    final message = ReminderMessage.fromId(json['message'] as String);

    if (message == null) return null;

    return PlannedReminder(
      at: DateTime.parse(json['at'] as String),
      message: message,
      streak: json['streak'] as int? ?? 0,
    );
  }
}
