import 'package:telemetry/src/telemetry.dart';

/// Telemetry that sends nothing: for an app built without Firebase, and for
/// tests. The call sites stay the same either way.
final class NoopTelemetry implements Telemetry {
  const NoopTelemetry();

  @override
  void crash() {}

  @override
  void installCrashHandlers() {}

  @override
  Future<void> setAnalyticsConsent({required bool granted}) async {}

  @override
  Future<void> recordNonFatal(
    Object error,
    StackTrace stackTrace, {
    required String reason,
  }) async {}

  @override
  Future<void> setCollectionEnabled(bool enabled) async {}
}
