import 'package:flutter_test/flutter_test.dart';
import 'package:push_notifications_data/push_notifications_data.dart';
import 'package:push_notifications_domain/push_notifications_domain.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test(
    'Given nothing kept, Then no reminder was ever planned or shown',
    () async {
      expect(
        await const SharedPreferencesReminderLogStore().load(),
        const ReminderLog(),
      );
    },
  );

  test('Given a plan kept, When the app relaunches, Then it reads back the '
      'same', () async {
    // Given
    final log = ReminderLog(
      planned: [
        PlannedReminder(
          at: DateTime.utc(2026, 10, 19, 16),
          message: .streakCount,
          streak: 4,
        ),
        PlannedReminder(
          at: DateTime.utc(2026, 10, 20, 16),
          message: .comboTime,
        ),
      ],
      recent: const [.boardReady, .newDaily],
    );

    // When
    await const SharedPreferencesReminderLogStore().save(log);

    // Then
    expect(await const SharedPreferencesReminderLogStore().load(), log);
  });

  test('Given a message a later build added, When the log is read, Then that '
      'message is dropped and the rest kept', () async {
    // Given
    SharedPreferences.setMockInitialValues({
      'reminder.log':
          '{"planned":[{"at":"2026-10-19T16:00:00.000Z","message":"later",'
          '"streak":0}],"recent":["later","combo_time"]}',
    });

    // When / Then
    expect(
      await const SharedPreferencesReminderLogStore().load(),
      const ReminderLog(recent: [.comboTime]),
    );
  });

  test(
    'Given a kept log that can no longer be read, Then it starts afresh',
    () async {
      // Given
      SharedPreferences.setMockInitialValues({'reminder.log': '{"planned":'});

      // When / Then
      expect(
        await const SharedPreferencesReminderLogStore().load(),
        const ReminderLog(),
      );
    },
  );
}
