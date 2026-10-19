import 'dart:math';

import 'package:push_notifications_domain/src/entities/reminder_log.br.dart';
import 'package:push_notifications_domain/src/entities/reminder_message.dart';

/// A time the reminder could go off: [day] days from today (0), and how the
/// daily run stands on the UTC day it fires on, were nothing played until
/// then.
typedef ReminderSlot = ({DateTime at, int day, bool played, int streak});

/// The days after today a plan reaches: a week ahead.
const reminderDays = 7;

/// The week's reminders, planned on every app open, so the days are counted
/// from the latest one:
///
/// - every day until the third, then every other day until the seventh, then
///   none until the app is opened again;
/// - none on a UTC day whose daily run is already played;
/// - the first reminder past the third day calls the player back; a streak of
///   2 or more draws a streak message, any other day a general one;
/// - each message drawn at random, seeded with its UTC day, never one of the
///   last 3 shown or planned before it. A pool with nothing left (two streak
///   messages, one comeback) draws a general one instead.
///
/// What the last plan held and has gone off by `now` counts as shown; what it
/// held after was cancelled unseen.
class PlanDailyRemindersBehavior {
  const PlanDailyRemindersBehavior();

  static const _everyDayUntil = 3;
  static const _minStreak = 2;
  static const _remembered = 3;

  ReminderLog call({
    required ReminderLog log,
    required DateTime now,
    required List<ReminderSlot> slots,
  }) {
    final recent = _latest([
      ...log.recent,
      for (final reminder in log.planned)
        if (!reminder.at.isAfter(now)) reminder.message,
    ]);
    final drawn = [...recent];
    final planned = <PlannedReminder>[];
    var comebackDue = true;

    for (final slot in slots) {
      if (!slot.at.isAfter(now) || !_remindsOn(slot.day) || slot.played) {
        continue;
      }

      final ReminderPool pool;

      if (comebackDue && slot.day > _everyDayUntil) {
        pool = .comeback;
        comebackDue = false;
      } else {
        pool = slot.streak >= _minStreak ? .streak : .general;
      }

      final message = _draw(
        avoiding: _latest(drawn),
        pool: pool,
        seed: _dayKey(slot.at.toUtc()),
      );

      drawn.add(message);
      planned.add(
        PlannedReminder(
          at: slot.at,
          message: message,
          streak: message.pool == .streak ? slot.streak : 0,
        ),
      );
    }

    return ReminderLog(planned: planned, recent: recent);
  }

  static int _dayKey(DateTime day) =>
      day.year * 10000 + day.month * 100 + day.day;

  static ReminderMessage _draw({
    required List<ReminderMessage> avoiding,
    required ReminderPool pool,
    required int seed,
  }) {
    List<ReminderMessage> from(ReminderPool pool) => [
      for (final message in ReminderMessage.values)
        if (message.pool == pool && !avoiding.contains(message)) message,
    ];

    final candidates = switch (from(pool)) {
      [] => from(.general),
      final candidates => candidates,
    };

    return candidates[Random(seed).nextInt(candidates.length)];
  }

  static List<ReminderMessage> _latest(List<ReminderMessage> messages) =>
      messages.length > _remembered
      ? messages.sublist(messages.length - _remembered)
      : messages;

  static bool _remindsOn(int day) =>
      day <= _everyDayUntil ||
      (day <= reminderDays && (day - _everyDayUntil).isEven);
}
