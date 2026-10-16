typedef _RequestPermission = Future<bool> Function();
typedef _SyncToken = Future<void> Function();

/// Asks for notifications, then reports whatever token FCM holds once the
/// answer is in.
///
/// The order is the point. On iOS the launch report usually goes out with no
/// token at all, and answering the prompt is the first moment one is reliably
/// there — see `SyncPushTokenBehavior`.
///
/// The token is reported whether or not permission was granted: a denied
/// install costs the server a send the OS drops, and starts receiving the day
/// its owner turns notifications on in Settings.
///
/// Nothing remembers having asked: the OS shows its prompt once and answers
/// silently from then on, so asking on every call is safe.
class AskForNotificationsBehavior {
  final _RequestPermission _requestPermission;
  final _SyncToken _syncToken;

  const AskForNotificationsBehavior({
    required Future<bool> Function() requestPermission,
    required Future<void> Function() syncToken,
  }) : _requestPermission = requestPermission,
       _syncToken = syncToken;

  Future<void> call() async {
    await _requestPermission();

    await _syncToken();
  }
}
