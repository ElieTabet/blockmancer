import 'dart:async';

import 'package:push_notifications_domain/src/behaviors/resolve_push_destination_behavior.dart';
import 'package:push_notifications_domain/src/entities/push_destination.br.dart';

typedef _LaunchMessage = Future<Map<String, String>?> Function();
typedef _OpenedMessages = Stream<Map<String, String>> Function();

/// Every tapped push, as where it leads: the one that launched the app first,
/// then each one tapped while it runs.
class WatchPushDestinationsBehavior {
  final _LaunchMessage _launchMessage;
  final _OpenedMessages _openedMessages;

  const WatchPushDestinationsBehavior({
    required Future<Map<String, String>?> Function() launchMessage,
    required Stream<Map<String, String>> Function() openedMessages,
  }) : _launchMessage = launchMessage,
       _openedMessages = openedMessages;

  /// Not an `async*` generator: one waiting in `await for` on a quiet stream
  /// never finishes cancelling, and its owner's dispose would hang on it.
  Stream<PushDestination> call() => Stream.multi((controller) {
    StreamSubscription<Map<String, String>>? opened;
    var isCancelled = false;

    void open(Map<String, String> data) =>
        controller.add(const ResolvePushDestinationBehavior()(data));

    controller.onCancel = () {
      isCancelled = true;

      return opened?.cancel();
    };

    // Taps are listened for only once the launch is known, so the push that
    // launched the app is always the first to open.
    unawaited(
      _launchMessage().then((launch) {
        if (isCancelled) return;

        if (launch != null) open(launch);

        opened = _openedMessages().listen(open);
      }),
    );
  });
}
