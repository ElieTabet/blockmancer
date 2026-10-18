/// A local notification once a day at a local time, behind a contract that
/// names no plugin. Nothing here decides whether there should be one.
abstract interface class DailyReminder {
  /// Stops the reminder. Never throws.
  Future<void> cancel();

  /// Every day at [hour]:[minute] in the phone's time zone now, replacing any
  /// reminder scheduled before. Never throws.
  Future<void> schedule({
    required String body,
    required String channelDescription,
    required String channelName,
    required int hour,
    required int minute,
    required String title,
  });

  /// The phone's time zone (`Europe/Paris`), so a caller can tell when it
  /// changed. Never throws: an unreadable one reads as `UTC`.
  Future<String> timeZone();
}
