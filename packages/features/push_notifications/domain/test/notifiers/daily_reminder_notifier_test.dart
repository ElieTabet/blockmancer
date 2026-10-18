import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_notifications_domain/push_notifications_domain.dart';

/// The phone as the reminder sees it: its settings switch, whether a daily
/// run was ever finished, its time zone, and what was asked of the OS.
final class _Phone {
  var askFails = false;
  final calls = <String>[];
  var enabled = true;
  var playedDaily = false;
  var zone = 'Europe/Paris';

  ProviderContainer container() {
    final container = ProviderContainer(
      overrides: [
        cancelDailyReminderProvider.overrideWith(
          (ref) =>
              () async => calls.add('cancel'),
        ),
        currentTimeZoneProvider.overrideWith(
          (ref) =>
              () async => zone,
        ),
        dailyReminderEnabledProvider.overrideWith((ref) async => enabled),
        hasPlayedDailyProvider.overrideWith(
          (ref) =>
              () async => playedDaily,
        ),
        readPushTokenProvider.overrideWith(
          (ref) =>
              () async => null,
        ),
        reportPushTokenProvider.overrideWith((ref) => (_) async {}),
        requestPushPermissionProvider.overrideWith(
          (ref) => () async {
            calls.add('ask');

            if (askFails) throw StateError('no messaging');

            return true;
          },
        ),
        scheduleDailyReminderProvider.overrideWith(
          (ref) =>
              ({required hour, required minute}) async =>
                  calls.add('schedule $hour:$minute in $zone'),
        ),
      ],
    );
    addTearDown(container.dispose);
    container.listen(dailyReminderProvider, (_, _) {});

    return container;
  }
}

void main() {
  test('Given a player who never finished a daily run, When the app starts, '
      'Then no reminder is scheduled', () async {
    // Given
    final phone = _Phone();

    // When
    final container = phone.container();
    await container.read(dailyReminderProvider.future);

    // Then
    expect(phone.calls, ['cancel']);
  });

  test(
    'Given a first daily run just finished, When the game says so, Then '
    'notifications are asked for and the reminder is set for 18:00',
    () async {
      // Given
      final phone = _Phone();
      final container = phone.container();
      await container.read(dailyReminderProvider.future);
      phone
        ..calls.clear()
        ..playedDaily = true;

      // When
      await container.read(dailyReminderProvider.notifier).dailyRunFinished();

      // Then
      expect(phone.calls, ['ask', 'schedule 18:0 in Europe/Paris']);
    },
  );

  test("Given push that couldn't start, When a first daily run finishes, "
      'Then the reminder is set all the same', () async {
    // Given
    final phone = _Phone()..askFails = true;
    final container = phone.container();
    await container.read(dailyReminderProvider.future);
    phone
      ..calls.clear()
      ..playedDaily = true;

    // When
    await container.read(dailyReminderProvider.notifier).dailyRunFinished();

    // Then
    expect(phone.calls, ['ask', 'schedule 18:0 in Europe/Paris']);
  });

  test('Given a player who played a daily run, When the app starts, Then the '
      'reminder is set without asking again', () async {
    // Given
    final phone = _Phone()..playedDaily = true;

    // When
    final container = phone.container();
    await container.read(dailyReminderProvider.future);

    // Then
    expect(phone.calls, ['schedule 18:0 in Europe/Paris']);
  });

  test('Given a scheduled reminder, When the switch is turned off, Then it is '
      'cancelled', () async {
    // Given
    final phone = _Phone()..playedDaily = true;
    final container = phone.container();
    await container.read(dailyReminderProvider.future);
    phone
      ..calls.clear()
      ..enabled = false;

    // When
    container.invalidate(dailyReminderEnabledProvider);
    await container.read(dailyReminderProvider.future);

    // Then
    expect(phone.calls, ['cancel']);
  });

  test('Given the switch off, When a daily run finishes, Then nothing is '
      'asked and nothing scheduled', () async {
    // Given
    final phone = _Phone()
      ..enabled = false
      ..playedDaily = true;
    final container = phone.container();
    await container.read(dailyReminderProvider.future);
    phone.calls.clear();

    // When
    await container.read(dailyReminderProvider.notifier).dailyRunFinished();

    // Then
    expect(phone.calls, isEmpty);
  });

  test('Given a reminder set in Paris, When the player comes back in New '
      'York, Then it is set again at 18:00 there', () async {
    // Given
    final phone = _Phone()..playedDaily = true;
    final container = phone.container();
    await container.read(dailyReminderProvider.future);
    phone
      ..calls.clear()
      ..zone = 'America/New_York';

    // When
    await container.read(dailyReminderProvider.notifier).resumed();

    // Then
    expect(phone.calls, ['schedule 18:0 in America/New_York']);
  });

  test('Given a reminder set in Paris, When the player comes back still in '
      'Paris, Then it is left as it is', () async {
    // Given
    final phone = _Phone()..playedDaily = true;
    final container = phone.container();
    await container.read(dailyReminderProvider.future);
    phone.calls.clear();

    // When
    await container.read(dailyReminderProvider.notifier).resumed();

    // Then
    expect(phone.calls, isEmpty);
  });
}
