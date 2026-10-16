typedef _ReadToken = Future<String?> Function();
typedef _Report = Future<void> Function(String token);

/// Reads whatever token FCM holds right now and reports it.
///
/// The launch report often goes out without one — on iOS `getToken()` has
/// nothing to answer with until APNs has replied, which on a fresh install is
/// after the splash. `onTokenRefresh` does not cover that case either: it fires
/// when a token is *minted*, not when an already-minted one becomes readable.
/// So the first moment a token is reliably there is once the permission prompt
/// has been answered, and that is when [AskForNotificationsBehavior] runs this.
class SyncPushTokenBehavior {
  final _ReadToken _readPushToken;
  final _Report _report;

  const SyncPushTokenBehavior({
    required Future<String?> Function() readPushToken,
    required Future<void> Function(String token) report,
  }) : _readPushToken = readPushToken,
       _report = report;

  Future<void> call() async {
    final token = await _readPushToken();

    // Nothing to say. A report with no token would be a second identical
    // launch report, and the server would replace nothing.
    if (token == null) return;

    await _report(token);
  }
}
