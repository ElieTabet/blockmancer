import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:telemetry/telemetry.dart';

final class _RecordingTelemetry implements Telemetry {
  final List<String> calls = [];

  @override
  void crash() => calls.add('crash');

  @override
  void installCrashHandlers() => calls.add('handlers');

  @override
  Future<void> setAnalyticsConsent({required bool granted}) async =>
      calls.add('consent: $granted');

  @override
  Future<void> recordNonFatal(
    Object error,
    StackTrace stackTrace, {
    required String reason,
  }) async => calls.add('non-fatal: $reason');

  @override
  Future<void> setCollectionEnabled(bool enabled) async =>
      calls.add('enabled: $enabled');
}

void main() {
  late _RecordingTelemetry telemetry;

  setUp(() => telemetry = _RecordingTelemetry());

  ProviderContainer containerFor({required bool collects}) {
    final container = ProviderContainer(
      overrides: bindProviders(
        collectsTelemetry: (ref) => collects,
        telemetry: (ref) => telemetry,
      ),
    );
    addTearDown(container.dispose);

    return container;
  }

  Future<List<String>> launch({required bool collects}) async {
    await containerFor(collects: collects).read(initializeTelemetryProvider)();

    return telemetry.calls;
  }

  Future<List<String>> recordNonFatal({required bool collects}) async {
    await containerFor(collects: collects).read(recordNonFatalProvider)(
      StateError('boom'),
      .empty,
      reason: 'push',
    );

    return telemetry.calls;
  }

  test(
    'Given a build that collects, When launched, '
    'Then the crash handlers go in before collection is switched on',
    () async {
      expect(await launch(collects: true), ['handlers', 'enabled: true']);
    },
  );

  // Switched off explicitly rather than left alone: the SDKs persist the
  // switch, so a release build's "on" would otherwise carry over.
  test('Given a build that does not collect, When launched, '
      'Then no handlers go in and collection is switched off', () async {
    expect(await launch(collects: false), ['enabled: false']);
  });

  test('Given a build that collects, When a non-fatal error is recorded, '
      'Then it reaches the reporter', () async {
    expect(await recordNonFatal(collects: true), ['non-fatal: push']);
  });

  // Crashlytics keeps reports made while switched off, so they are never made.
  test(
    'Given a build that does not collect, When a non-fatal error is recorded, '
    'Then nothing is reported',
    () async {
      expect(await recordNonFatal(collects: false), isEmpty);
    },
  );
}
