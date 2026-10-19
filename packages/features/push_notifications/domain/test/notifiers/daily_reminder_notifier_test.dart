import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_notifications_domain/push_notifications_domain.dart';

/// 09:00 UTC; the reminders go off at 17:00 UTC, today's included.
final _now = DateTime.utc(2026, 10, 19, 9);

final class _MemoryLogStore implements ReminderLogStore {
  var log = const ReminderLog();

  @override
  Future<ReminderLog> load() async => log;

  @override
  Future<void> save(ReminderLog log) async => this.log = log;
}

/// The phone as the reminders see it: its settings switch, the runs played,
/// the app's language, and what was asked of the OS.
final class _Phone {
  var askFails = false;
  final calls = <String>[];
  var enabled = true;
  final languages = StreamController<String>()..add('en');
  final logStore = _MemoryLogStore();

  /// Days from today whose daily run is played; null when none ever was.
  Set<int>? played;

  /// A world or practice run played to its end.
  var playedOtherRun = false;
  final replaced = <List<ReminderNotification>>[];

  ProviderContainer container() {
    final container = ProviderContainer(
      overrides: [
        cancelDailyReminderProvider.overrideWith(
          (ref) =>
              () async => calls.add('cancel'),
        ),
        dailyReminderEnabledProvider.overrideWith((ref) async => enabled),
        dailyStandingProvider.overrideWith(
          (ref) => (day) async {
            final ahead = day.difference(DateTime.utc(2026, 10, 19, 17)).inDays;

            return (played: played?.contains(ahead) ?? false, streak: 0);
          },
        ),
        displayLanguageProvider.overrideWith((ref) => languages.stream),
        hasCompletedRunProvider.overrideWith(
          (ref) =>
              () async => played != null || playedOtherRun,
        ),
        nowProvider.overrideWith(
          (ref) =>
              () => _now,
        ),
        readPushTokenProvider.overrideWith(
          (ref) =>
              () async => null,
        ),
        reminderLogStoreProvider.overrideWithValue(logStore),
        reminderTextsProvider.overrideWith(
          (ref) =>
              (message, {required language, required streak}) =>
                  (body: '', title: '$language ${message.id}'),
        ),
        reminderTimesProvider.overrideWith(
          (ref) =>
              ({required days, required hour, required minute}) async => [
                for (var day = 0; day <= days; day++)
                  DateTime.utc(2026, 10, 19 + day, 17),
              ],
        ),
        replaceRemindersProvider.overrideWith(
          (ref) => (reminders) async {
            calls.add('replace ${reminders.length}');
            replaced.add(reminders);
          },
        ),
        reportPushTokenProvider.overrideWith((ref) => (_) async {}),
        requestPushPermissionProvider.overrideWith(
          (ref) => () async {
            calls.add('ask');

            if (askFails) throw StateError('no messaging');

            return true;
          },
        ),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(languages.close);
    container.listen(dailyReminderProvider, (_, _) {});

    return container;
  }
}

void main() {
  test('Given a player who never finished a run, When the app starts, Then no '
      'reminder is planned', () async {
    // Given
    final phone = _Phone();

    // When
    final container = phone.container();
    await container.read(dailyReminderProvider.future);

    // Then
    expect(phone.calls, ['cancel']);
  });

  test('Given a player who only ever finished world runs, When the app '
      'starts, Then the week is planned with general messages and the comeback '
      'one', () async {
    // Given
    final phone = _Phone()..playedOtherRun = true;

    // When
    final container = phone.container();
    final planned = await container.read(dailyReminderProvider.future);

    // Then
    expect(phone.calls, ['replace 6']);
    expect(planned.map((reminder) => reminder.message.pool), <ReminderPool>[
      .general,
      .general,
      .general,
      .general,
      .comeback,
      .general,
    ]);
  });

  test('Given a first world run just finished, When the game says so, Then '
      'notifications are asked for and the week is planned', () async {
    // Given
    final phone = _Phone();
    final container = phone.container();
    await container.read(dailyReminderProvider.future);
    phone
      ..calls.clear()
      ..playedOtherRun = true;

    // When
    await container.read(dailyReminderProvider.notifier).runFinished();

    // Then
    expect(phone.calls, ['ask', 'replace 6']);
  });

  test("Given today's daily run just finished, a first, When the game says "
      'so, Then notifications are asked for and the week is planned without '
      'today', () async {
    // Given
    final phone = _Phone();
    final container = phone.container();
    await container.read(dailyReminderProvider.future);
    phone
      ..calls.clear()
      ..played = {0};

    // When
    await container.read(dailyReminderProvider.notifier).runFinished();

    // Then
    expect(phone.calls, ['ask', 'replace 5']);
    expect(phone.replaced.last.first.at, DateTime.utc(2026, 10, 20, 17));
  });

  test("Given push that couldn't start, When a first daily run finishes, "
      'Then the week is planned all the same', () async {
    // Given
    final phone = _Phone()..askFails = true;
    final container = phone.container();
    await container.read(dailyReminderProvider.future);
    phone
      ..calls.clear()
      ..played = {0};

    // When
    await container.read(dailyReminderProvider.notifier).runFinished();

    // Then
    expect(phone.calls, ['ask', 'replace 5']);
  });

  test('Given a player who played a daily run before today, When the app '
      'starts, Then the week is planned from today, each reminder with its '
      'message and what a tap on it carries', () async {
    // Given
    final phone = _Phone()..played = {-1};

    // When
    final container = phone.container();
    final planned = await container.read(dailyReminderProvider.future);

    // Then
    expect(phone.calls, ['replace 6']);
    expect(phone.replaced.single.first.title, 'en ${planned.first.message.id}');
    expect(phone.replaced.single.first.data, {
      'type': 'daily_reminder',
      'message': planned.first.message.id,
    });
  });

  test('Given planned reminders, When the switch is turned off, Then they are '
      'cancelled', () async {
    // Given
    final phone = _Phone()..played = {-1};
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
      'asked and nothing planned', () async {
    // Given
    final phone = _Phone()
      ..enabled = false
      ..played = {0};
    final container = phone.container();
    await container.read(dailyReminderProvider.future);
    phone.calls.clear();

    // When
    await container.read(dailyReminderProvider.notifier).runFinished();

    // Then
    expect(phone.calls, isEmpty);
  });

  test('Given planned reminders, When the player comes back to the app, Then '
      'the week is planned again from now', () async {
    // Given
    final phone = _Phone()..played = {-1};
    final container = phone.container();
    await container.read(dailyReminderProvider.future);
    phone.calls.clear();

    // When
    await container.read(dailyReminderProvider.notifier).resumed();
    await container.read(dailyReminderProvider.notifier).resumed();

    // Then
    expect(phone.calls, ['replace 6', 'replace 6']);
  });

  test('Given reminders planned in English, When the app switches to French, '
      'Then they are planned again in French', () async {
    // Given
    final phone = _Phone()..played = {-1};
    final container = phone.container();
    await container.read(dailyReminderProvider.future);

    // When
    phone.languages.add('fr');
    await pumpEventQueue();
    await container.read(dailyReminderProvider.future);

    // Then
    expect(phone.replaced, hasLength(2));
    expect(
      phone.replaced.last.map((reminder) => reminder.title),
      everyElement(startsWith('fr ')),
    );
  });
}
