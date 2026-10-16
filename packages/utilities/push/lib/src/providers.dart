import 'package:push/src/providers_di.br.dart' as di;
import 'package:push/src/push_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// push — public providers exposed by this package.

/// Binds the messaging slot to a concrete implementation supplied by the
/// composition layer, so nothing below composition depends on Firebase.
List<Override> bindProviders({
  required PushMessaging Function(Ref ref) pushMessaging,
}) => [di.pushMessagingProvider.overrideWith(pushMessaging)];
