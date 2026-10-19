/// Which messages a reminder may draw from.
enum ReminderPool { comeback, general, streak }

/// A daily reminder's message. [id] names it in analytics and in a tap's
/// data, the same in every language, so it never changes once shipped.
enum ReminderMessage {
  beatYesterday('beat_yesterday', .general),
  blocksFalling('blocks_falling', .general),
  boardReady('board_ready', .general),
  boardReset('board_reset', .general),
  comboTime('combo_time', .general),
  comeback('comeback', .comeback),
  fiveMinutes('five_minutes', .general),
  jokersRestless('jokers_restless', .general),
  newDaily('new_daily', .general),
  streakCount('streak_count', .streak),
  streakFire('streak_fire', .streak);

  const ReminderMessage(this.id, this.pool);

  final String id;
  final ReminderPool pool;

  /// What a tap on it hands back, read by `ResolvePushDestinationBehavior`.
  Map<String, String> get data => {
    ReminderData.type: ReminderData.dailyReminder,
    ReminderData.message: id,
  };

  static ReminderMessage? fromId(String id) =>
      values.where((message) => message.id == id).firstOrNull;
}

/// The keys and value of a reminder's data.
abstract final class ReminderData {
  static const dailyReminder = 'daily_reminder';
  static const message = 'message';
  static const type = 'type';
}
