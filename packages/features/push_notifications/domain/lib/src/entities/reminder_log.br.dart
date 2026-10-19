import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:push_notifications_domain/src/entities/reminder_message.dart';

part 'reminder_log.br.freezed.dart';

/// One reminder of a plan: when it goes off, its message, and the streak it
/// names (streak messages only).
@freezed
abstract class PlannedReminder with _$PlannedReminder {
  const factory PlannedReminder({
    required DateTime at,
    required ReminderMessage message,
    @Default(0) int streak,
  }) = _PlannedReminder;
}

/// What the reminders last planned, and the messages shown before that plan,
/// latest last: the next plan avoids repeating them.
@freezed
abstract class ReminderLog with _$ReminderLog {
  const factory ReminderLog({
    @Default(<PlannedReminder>[]) List<PlannedReminder> planned,
    @Default(<ReminderMessage>[]) List<ReminderMessage> recent,
  }) = _ReminderLog;
}
