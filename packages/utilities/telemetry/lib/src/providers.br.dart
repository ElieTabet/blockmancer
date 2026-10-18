import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telemetry/src/providers_di.br.dart' as di;
import 'package:telemetry/src/session_errors.dart';
import 'package:telemetry/src/telemetry.dart';

part 'providers.br.g.dart';

// telemetry — public providers exposed by this package.

typedef InitializeTelemetryFun = Future<void> Function();

typedef SessionHadErrorFun = bool Function();

typedef RecordNonFatalFun =
    Future<void> Function(
      Object error,
      StackTrace stackTrace, {
      required String reason,
    });

/// Once per launch, as early as the container allows: the crash handlers, the
/// session's error watch over them, then the switch.
///
/// The handlers go in only when collecting — anywhere else they would replace
/// Flutter's own error reporting with a reporter that never reports. The switch
/// is set on every launch, either way: the SDKs persist it on the phone, so a
/// debug build installed over a release one would otherwise inherit its "on".
@riverpod
InitializeTelemetryFun initializeTelemetry(Ref ref) {
  final collects = ref.watch(di.collectsTelemetryProvider);
  final errors = ref.watch(sessionErrorsProvider);
  final telemetry = ref.watch(di.telemetryProvider);

  return () async {
    if (collects) telemetry.installCrashHandlers();

    errors.watch();

    await telemetry.setCollectionEnabled(collects);
  };
}

/// One for the app's life: whether this launch hit an uncaught error.
@Riverpod(keepAlive: true)
SessionErrors sessionErrors(Ref ref) => SessionErrors();

/// Whether this launch hit an uncaught error, asked when it matters.
@riverpod
SessionHadErrorFun sessionHadError(Ref ref) {
  final errors = ref.watch(sessionErrorsProvider);

  return () => errors.seen;
}

/// Reports a failure the app survived, in builds that collect and nowhere else.
///
/// Gated here as well as by the SDK's switch: with collection off, Crashlytics
/// keeps reports on the phone rather than dropping them, and a release build
/// installed over this one would send them.
@riverpod
RecordNonFatalFun recordNonFatal(Ref ref) {
  final collects = ref.watch(di.collectsTelemetryProvider);
  final telemetry = ref.watch(di.telemetryProvider);

  return (error, stackTrace, {required reason}) async {
    if (!collects) return;

    await telemetry.recordNonFatal(error, stackTrace, reason: reason);
  };
}

/// Binds whether this build collects, and the implementation that obeys —
/// both supplied by the composition layer, so nothing below it depends on
/// Firebase or on how a build is configured.
List<Override> bindProviders({
  required bool Function(Ref ref) collectsTelemetry,
  required Telemetry Function(Ref ref) telemetry,
}) => [
  di.collectsTelemetryProvider.overrideWith(collectsTelemetry),
  di.telemetryProvider.overrideWith(telemetry),
];
