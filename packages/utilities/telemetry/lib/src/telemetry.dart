/// Usage statistics and crash reports, behind a contract that mentions no
/// vendor.
abstract interface class Telemetry {
  /// Crashes the app on purpose, so a test build can check that crash reports
  /// arrive. Never offered in a release build.
  void crash();

  /// Google's consent mode for Analytics, from the player's consent: granted
  /// or denied for storage, ad data and personalisation at once. Never throws.
  Future<void> setAnalyticsConsent({required bool granted});

  /// Routes uncaught Flutter and async errors to the crash reporter. Reports
  /// are still sent only while collection is enabled.
  void installCrashHandlers();

  /// Both at once: there is one answer for usage statistics and crash reports.
  ///
  /// Never throws. Turning collection off also discards the crash reports
  /// cached on the phone, so nothing recorded before a "no" is sent later.
  Future<void> setCollectionEnabled(bool enabled);

  /// A failure the app recovered from but someone should still hear about —
  /// a crash report marked non-fatal. Never throws.
  Future<void> recordNonFatal(
    Object error,
    StackTrace stackTrace, {
    required String reason,
  });
}
