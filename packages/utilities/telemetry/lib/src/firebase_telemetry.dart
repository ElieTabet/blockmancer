import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:telemetry/src/package_name.dart';
import 'package:telemetry/src/telemetry.dart';
import 'package:timber/timber.dart';

/// Firebase Analytics and Crashlytics behind [Telemetry], and the only place
/// the two plugins are imported.
///
/// Both start disabled from the native config (Info.plist, AndroidManifest),
/// so nothing is collected before [setCollectionEnabled] says otherwise.
final class FirebaseTelemetry implements Telemetry {
  final FirebaseAnalytics? _injectedAnalytics;
  final FirebaseCrashlytics? _injectedCrashlytics;

  /// Both optional so the composition layer can write `FirebaseTelemetry()`
  /// and stay free of the plugins; they are here for tests.
  FirebaseTelemetry({
    FirebaseAnalytics? analytics,
    FirebaseCrashlytics? crashlytics,
  }) : _injectedAnalytics = analytics,
       _injectedCrashlytics = crashlytics;

  /// Resolved on use, never in the constructor: the instances throw until
  /// `Firebase.initializeApp` has run, and constructing this is wiring.
  FirebaseAnalytics get _analytics =>
      _injectedAnalytics ?? FirebaseAnalytics.instance;

  FirebaseCrashlytics get _crashlytics =>
      _injectedCrashlytics ?? FirebaseCrashlytics.instance;

  @override
  void crash() => _crashlytics.crash();

  @override
  void installCrashHandlers() {
    final crashlytics = _crashlytics;

    FlutterError.onError = crashlytics.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stackTrace) {
      crashlytics.recordError(error, stackTrace, fatal: true);

      return true;
    };
  }

  @override
  Future<void> recordNonFatal(
    Object error,
    StackTrace stackTrace, {
    required String reason,
  }) async {
    try {
      await _crashlytics.recordError(error, stackTrace, reason: reason);
    } catch (recordError, recordStackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'Recording a non-fatal error failed',
        exception: recordError,
        stackTrace: recordStackTrace,
      );
    }
  }

  @override
  Future<void> setCollectionEnabled(bool enabled) async {
    try {
      await _analytics.setAnalyticsCollectionEnabled(enabled);
      await _crashlytics.setCrashlyticsCollectionEnabled(enabled);

      if (!enabled) await _crashlytics.deleteUnsentReports();
    } catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'Switching collection ${enabled ? 'on' : 'off'} failed',
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }
}
