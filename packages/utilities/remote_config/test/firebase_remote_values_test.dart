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
}
