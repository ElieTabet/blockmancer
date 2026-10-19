import 'package:flutter_test/flutter_test.dart';
import 'package:push_notifications_domain/push_notifications_domain.dart';
import 'package:push_notifications_domain/src/behaviors/plan_daily_reminders_behavior.dart';

const _plan = PlanDailyRemindersBehavior();

/// 09:00 UTC on the day the app is opened; reminders go off at 17:00 UTC.
final _opened = DateTime.utc(2026, 10, 19, 9);

/// A week of reminder times from [opened]'s day, nothing played, no streak.
List<ReminderSlot> _week(
  DateTime opened, {
  Set<int> played = const {},
  int Function(int day)? streak,
}) => [
  for (var day = 0; day <= reminderDays; day++)
    (
      at: DateTime.utc(opened.year, opened.month, opened.day + day, 17),
      day: day,
      played: played.contains(day),
      streak: streak?.call(day) ?? 0,
    ),
];

List<int> _days(ReminderLog log, DateTime opened) => [
  for (final reminder in log.planned)
    reminder.at
        .difference(DateTime.utc(opened.year, opened.month, opened.day, 17))
        .inDays,
];

void main() {
  test('Given a player who never opens the app again, When the week is '
      'planned, Then reminders go out every day until the third, then every '
      'other day until the seventh, then stop', () {
    // When
    final log = _plan(
      log: const ReminderLog(),
      now: _opened,
      slots: _week(_opened),
    );

    // Then
    expect(_days(log, _opened), [0, 1, 2, 3, 5, 7]);
  });

  test('Given three days gone without opening the app, When the week is '
      'planned, Then the first reminder after them calls the player back, '
      'and no other does', () {
    // When
    final log = _plan(
      log: const ReminderLog(),
      now: _opened,
      slots: _week(_opened),
    );

    // Then
    expect(
      [for (final reminder in log.planned) reminder.message == .comeback],
      [false, false, false, false, true, false],
    );
  });

  test("Given today's daily run already played, When the week is planned, "
      'Then nothing goes out today', () {
    // When
    final log = _plan(
      log: const ReminderLog(),
      now: _opened,
      slots: _week(_opened, played: {0}),
    );

    // Then
    expect(_days(log, _opened), [1, 2, 3, 5, 7]);
  });

  test("Given today's reminder time already passed, When the week is "
      'planned, Then it starts tomorrow', () {
    // Given
    final evening = DateTime.utc(2026, 10, 19, 20);

    // When
    final log = _plan(
      log: const ReminderLog(),
      now: evening,
      slots: _week(evening),
    );

    // Then
    expect(_days(log, evening), [1, 2, 3, 5, 7]);
  });

  test('Given the app opened less than 2 hours before the reminder, When the '
      'week is planned, Then that day gets none', () {
    // Given: 1 hour 59 before today's reminder
    final lateAfternoon = DateTime.utc(2026, 10, 19, 15, 1);

    // When
    final log = _plan(
      log: const ReminderLog(),
      now: lateAfternoon,
      slots: _week(lateAfternoon),
    );

    // Then
    expect(_days(log, lateAfternoon), [1, 2, 3, 5, 7]);
  });

  test('Given the app opened 2 hours before the reminder, When the week is '
      'planned, Then that day still gets its reminder', () {
    // Given
    final afternoon = DateTime.utc(2026, 10, 19, 15);

    // When
    final log = _plan(
      log: const ReminderLog(),
      now: afternoon,
      slots: _week(afternoon),
    );

    // Then
    expect(_days(log, afternoon), [0, 1, 2, 3, 5, 7]);
  });

  test('Given a streak standing on some days only, When the week is planned, '
      'Then streak messages go out on those days alone, naming the streak', () {
    // Given: a 4-day streak today, broken from tomorrow on
    final slots = _week(_opened, streak: (day) => day == 0 ? 4 : 0);

    // When
    final log = _plan(log: const ReminderLog(), now: _opened, slots: slots);

    // Then
    expect(log.planned.first.message.pool, ReminderPool.streak);
    expect(log.planned.first.streak, 4);
    expect(
      log.planned.skip(1).map((reminder) => reminder.message.pool),
      everyElement(isNot(ReminderPool.streak)),
    );
  });

  test('Given a streak of one day, When the week is planned, Then no streak '
      'message goes out', () {
    // When
    final log = _plan(
      log: const ReminderLog(),
      now: _opened,
      slots: _week(_opened, streak: (day) => 1),
    );

    // Then
    expect(
      log.planned.map((reminder) => reminder.message.pool),
      everyElement(isNot(ReminderPool.streak)),
    );
  });

  test('Given the same day and the same history, When the week is planned '
      'twice, Then both plans are the same', () {
    expect(
      _plan(log: const ReminderLog(), now: _opened, slots: _week(_opened)),
      _plan(log: const ReminderLog(), now: _opened, slots: _week(_opened)),
    );
  });

  test('Given a plan made yesterday, When the app is opened today, Then what '
      'went off counts as shown and what was still ahead does not', () {
    // Given
    final yesterday = _opened.subtract(const Duration(days: 1));
    final before = _plan(
      log: const ReminderLog(recent: [.comboTime]),
      now: yesterday,
      slots: _week(yesterday),
    );

    // When
    final log = _plan(log: before, now: _opened, slots: _week(_opened));

    // Then
    expect(log.recent, [
      ReminderMessage.comboTime,
      before.planned.first.message,
    ]);
  });

  test('Given 30 days of a player who opens the app every morning and plays '
      'most days, When each day plans the week, Then no reminder repeats any '
      'of the 3 shown before it', () {
    var log = const ReminderLog();
    final shown = <ReminderMessage>[];
    var streak = 0;

    for (var day = 0; day < 30; day++) {
      final opened = _opened.add(Duration(days: day));
      // The open replans the week; what went off since counts as shown.
      final planned = _plan(
        log: log,
        now: opened,
        slots: _week(opened, streak: (ahead) => ahead == 0 ? streak : 0),
      );

      // Today's reminder goes off before the player plays, in the evening.
      shown.add(planned.planned.first.message);
      log = planned;

      final plays = day % 5 != 4;

      streak = plays ? streak + 1 : 0;
    }

    for (var index = 0; index < shown.length; index++) {
      final before = shown.sublist(index < 3 ? 0 : index - 3, index);

      expect(before, isNot(contains(shown[index])), reason: 'day $index');
    }

    expect(shown.where((message) => message.pool == .streak), isNotEmpty);
  });

  test('Given only two streak messages, When streak days follow one another, '
      'Then a general message takes the third rather than repeat one', () {
    // Given: the last two shown were both streak messages
    final log = _plan(
      log: const ReminderLog(recent: [.streakCount, .streakFire]),
      now: _opened,
      slots: _week(_opened, streak: (day) => day == 0 ? 5 : 0),
    );

    // Then
    expect(log.planned.first.message.pool, ReminderPool.general);
    expect(log.planned.first.streak, 0);
  });
}
