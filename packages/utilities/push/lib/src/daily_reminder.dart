/// One reminder: when it goes off, what it says, and the data a tap on it
/// hands back (`PushMessaging.launchMessage` / `openedMessages`).
typedef ReminderNotification = ({
  DateTime at,
  String body,
  Map<String, String> data,
  String title,
});

/// Local notifications at given instants, behind a contract that names no
/// plugin. Nothing here decides which there should be.
abstract interface class DailyReminder {
  /// Stops every reminder. Never throws.
  Future<void> cancel();

  /// [reminders] (at most [maxReminders]), each once, replacing every
  /// reminder scheduled before. Never throws.
  Future<void> replace(
    List<ReminderNotification> reminders, {
    required String channelDescription,
    required String channelName,
  });

  /// The phone's time zone (`Europe/Paris`). Never throws: an unreadable one
  /// reads as `UTC`.
  Future<String> timeZone();

  /// The instant of [hour]:[minute] in the phone's time zone on today and on
  /// each of the [days] days after, today's first, whether passed or not.
  Future<List<DateTime>> upcoming({
    required int days,
    required int hour,
    required int minute,
  });

  /// iOS keeps 64 pending notifications per app; a week of reminders is far
  /// below, and the ids reserved for them stop here.
  static const maxReminders = 8;
}
