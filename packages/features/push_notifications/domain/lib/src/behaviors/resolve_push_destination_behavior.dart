import 'package:push_notifications_domain/src/entities/push_destination.br.dart';

/// Where a push leads, read from its `data`.
///
/// Every push opens Home until the app teaches this its own keys. When it does,
/// say what a push is about by which key it carries, and send anything this
/// build does not recognise to Home too: a push from a newer server should
/// still open the app.
class ResolvePushDestinationBehavior {
  const ResolvePushDestinationBehavior();

  PushDestination call(Map<String, String> data) => const .home();
}
