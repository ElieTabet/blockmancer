import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:remote_config/remote_config.dart';

class _MockRemoteConfig extends Mock implements FirebaseRemoteConfig {}

class _FakeSettings extends Fake implements RemoteConfigSettings {}

RemoteConfigValue _value(String text, ValueSource source) =>
    RemoteConfigValue(text.codeUnits, source);

void main() {
  late _MockRemoteConfig remoteConfig;
  late FirebaseRemoteValues values;

  setUpAll(() => registerFallbackValue(_FakeSettings()));

  setUp(() {
    remoteConfig = _MockRemoteConfig();
    values = FirebaseRemoteValues(
      minimumFetchInterval: const Duration(hours: 12),
      remoteConfig: remoteConfig,
    );
  });

  test('Given a value published for a key, When it is read, Then it comes back '
      'as published', () {
    // Given
    when(
      () => remoteConfig.getValue('round_3_target'),
    ).thenReturn(_value('900', .valueRemote));

    // When / Then
    expect(values.valueOf('round_3_target'), '900');
  });

  test('Given no value published for a key, When it is read, Then it is null, '
      'whatever the SDK holds by default', () {
    // Given
    when(
      () => remoteConfig.getValue('round_3_target'),
    ).thenReturn(_value('', .valueStatic));

    // When / Then
    expect(values.valueOf('round_3_target'), isNull);
  });

  test('Given the SDK failing, When a value is read, Then it is null', () {
    // Given
    when(() => remoteConfig.getValue(any())).thenThrow(Exception('no app'));

    // When / Then
    expect(values.valueOf('round_3_target'), isNull);
  });

  test('Given no network, When the values are fetched, Then nothing throws and '
      'the fetch interval was set first', () async {
    // Given
    when(() => remoteConfig.setConfigSettings(any())).thenAnswer((_) async {});
    when(() => remoteConfig.fetchAndActivate()).thenThrow(Exception('offline'));

    // When
    await values.fetchAndActivate();

    // Then
    final settings =
        verify(
              () => remoteConfig.setConfigSettings(captureAny()),
            ).captured.single
            as RemoteConfigSettings;
    expect(settings.minimumFetchInterval, const Duration(hours: 12));
  });

  group('changes', () {
    late StreamController<RemoteConfigUpdate> updates;
    late int changes;

    setUp(() {
      updates = StreamController<RemoteConfigUpdate>.broadcast();
      changes = 0;
      values.changes.listen((_) => changes++);
      when(
        () => remoteConfig.onConfigUpdated,
      ).thenAnswer((_) => updates.stream);
      when(() => remoteConfig.activate()).thenAnswer((_) async => true);
      when(
        () => remoteConfig.setConfigSettings(any()),
      ).thenAnswer((_) async {});
    });

    tearDown(() => updates.close());

    test('Given a fetch that lands, When it completes, Then the values have '
        'changed', () async {
      // Given
      when(() => remoteConfig.fetchAndActivate()).thenAnswer((_) async => true);

      // When
      await values.fetchAndActivate();
      await pumpEventQueue();

      // Then
      expect(changes, 1);
    });

    test('Given no network, When the values are fetched, Then nothing has '
        'changed', () async {
      // Given
      when(
        () => remoteConfig.fetchAndActivate(),
      ).thenThrow(Exception('offline'));

      // When
      await values.fetchAndActivate();
      await pumpEventQueue();

      // Then
      expect(changes, 0);
    });

    test('Given the app listening for updates, When one is published, Then it '
        'is activated before the values have changed', () async {
      // Given
      values.listenForUpdates();

      // When
      updates.add(RemoteConfigUpdate({'min_version_ios'}));
      await pumpEventQueue();

      // Then
      verify(() => remoteConfig.activate()).called(1);
      expect(changes, 1);
    });

    test('Given the update stream failing, When a later update is published, '
        'Then it still changes the values', () async {
      // Given
      values.listenForUpdates();
      updates.addError(Exception('connection dropped'));
      await pumpEventQueue();

      // When
      updates.add(RemoteConfigUpdate({'min_version_ios'}));
      await pumpEventQueue();

      // Then
      expect(changes, 1);
    });

    test('Given an update that fails to activate, When it is published, Then '
        'nothing has changed', () async {
      // Given
      when(() => remoteConfig.activate()).thenThrow(Exception('no app'));
      values.listenForUpdates();

      // When
      updates.add(RemoteConfigUpdate({'min_version_ios'}));
      await pumpEventQueue();

      // Then
      expect(changes, 0);
    });

    test('Given the app already listening, When it is asked to listen again, '
        'Then it subscribes once', () async {
      // Given
      values.listenForUpdates();

      // When
      values.listenForUpdates();
      updates.add(RemoteConfigUpdate({'min_version_ios'}));
      await pumpEventQueue();

      // Then
      expect(changes, 1);
    });
  });

  test('Given no Remote Config, When anything happens, Then the values never '
      'change', () async {
    // Given
    const none = NoRemoteValues();
    var changes = 0;
    none.changes.listen((_) => changes++);

    // When
    none.listenForUpdates();
    await none.fetchAndActivate();
    await pumpEventQueue();

    // Then
    expect(changes, 0);
  });
}
