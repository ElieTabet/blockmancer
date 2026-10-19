import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:remote_config/remote_config.dart';

class _MockRemoteConfig extends Mock implements FirebaseRemoteConfig {}

class _FakeSettings extends Fake implements RemoteConfigSettings {}

RemoteConfigValue _value(String text, ValueSource source) =>
    RemoteConfigValue(text.codeUnits, source);

/// [body] in time only the test moves, finishing whatever it left queued: no
/// test waits on a real timer, so none depends on how busy the machine is.
void _inFakeTime(void Function(FakeAsync async) body) => fakeAsync((async) {
  body(async);
  async.flushMicrotasks();
  expect(async.pendingTimers, isEmpty);
});

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
      'the fetch interval was set first', () {
    _inFakeTime((async) {
      // Given
      when(
        () => remoteConfig.setConfigSettings(any()),
      ).thenAnswer((_) async {});
      when(
        () => remoteConfig.fetchAndActivate(),
      ).thenThrow(Exception('offline'));

      // When
      Object? failure;
      values.fetchAndActivate().catchError((Object error) => failure = error);
      async.flushMicrotasks();

      // Then
      expect(failure, isNull);

      final settings =
          verify(
                () => remoteConfig.setConfigSettings(captureAny()),
              ).captured.single
              as RemoteConfigSettings;
      expect(settings.minimumFetchInterval, const Duration(hours: 12));
    });
  });

  group('changes', () {
    late Completer<bool> activation;
    late int changes;
    late Completer<bool> fetch;
    late StreamController<RemoteConfigUpdate> updates;

    /// The SDK stubbed with answers the test hands out itself, and the
    /// values' changes counted, all inside the fake time [body] runs in.
    void inFakeTime(void Function(FakeAsync async) body) => _inFakeTime((
      async,
    ) {
      activation = Completer<bool>();
      changes = 0;
      fetch = Completer<bool>();
      updates = StreamController<RemoteConfigUpdate>.broadcast();

      values.changes.listen((_) => changes++);
      when(
        () => remoteConfig.onConfigUpdated,
      ).thenAnswer((_) => updates.stream);
      when(() => remoteConfig.activate()).thenAnswer((_) => activation.future);
      when(
        () => remoteConfig.fetchAndActivate(),
      ).thenAnswer((_) => fetch.future);
      when(
        () => remoteConfig.setConfigSettings(any()),
      ).thenAnswer((_) async {});

      body(async);

      unawaited(updates.close());
    });

    test('Given a fetch under way, When it lands, Then the values have '
        'changed, and not before', () {
      inFakeTime((async) {
        // Given
        unawaited(values.fetchAndActivate());
        async.flushMicrotasks();
        expect(changes, 0);

        // When
        fetch.complete(true);
        async.flushMicrotasks();

        // Then
        expect(changes, 1);
      });
    });

    test('Given no network, When the values are fetched, Then nothing has '
        'changed', () {
      inFakeTime((async) {
        // Given
        unawaited(values.fetchAndActivate());

        // When
        fetch.completeError(Exception('offline'));
        async.flushMicrotasks();

        // Then
        expect(changes, 0);
      });
    });

    test('Given the app listening for updates, When one is published, Then it '
        'is activated before the values have changed', () {
      inFakeTime((async) {
        // Given
        values.listenForUpdates();

        // When
        updates.add(RemoteConfigUpdate({'min_version_ios'}));
        async.flushMicrotasks();

        // Then: asked to activate, and nothing changed until it has
        verify(() => remoteConfig.activate()).called(1);
        expect(changes, 0);

        activation.complete(true);
        async.flushMicrotasks();

        expect(changes, 1);
      });
    });

    test('Given the update stream failing, When a later update is published, '
        'Then it still changes the values', () {
      inFakeTime((async) {
        // Given
        activation.complete(true);
        values.listenForUpdates();
        updates.addError(Exception('connection dropped'));
        async.flushMicrotasks();

        // When
        updates.add(RemoteConfigUpdate({'min_version_ios'}));
        async.flushMicrotasks();

        // Then
        expect(changes, 1);
      });
    });

    test('Given an update that fails to activate, When it is published, Then '
        'nothing has changed', () {
      inFakeTime((async) {
        // Given
        values.listenForUpdates();

        // When
        updates.add(RemoteConfigUpdate({'min_version_ios'}));
        activation.completeError(Exception('no app'));
        async.flushMicrotasks();

        // Then
        expect(changes, 0);
      });
    });

    test('Given the app already listening, When it is asked to listen again, '
        'Then it subscribes once', () {
      inFakeTime((async) {
        // Given
        activation.complete(true);
        values.listenForUpdates();

        // When
        values.listenForUpdates();
        updates.add(RemoteConfigUpdate({'min_version_ios'}));
        async.flushMicrotasks();

        // Then
        expect(changes, 1);
      });
    });
  });

  test('Given no Remote Config, When anything happens, Then the values never '
      'change', () {
    _inFakeTime((async) {
      // Given
      const none = NoRemoteValues();
      var changes = 0;
      none.changes.listen((_) => changes++);

      // When
      none.listenForUpdates();
      unawaited(none.fetchAndActivate());
      async.flushMicrotasks();

      // Then
      expect(changes, 0);
    });
  });
}
