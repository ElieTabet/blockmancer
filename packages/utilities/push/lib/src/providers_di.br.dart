import 'package:push/src/push_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers_di.br.g.dart';

// push — inbound dependency-injection slot. Throws until the composition layer
// (app_providers) supplies a concrete implementation.

/// `keepAlive` because the implementation owns a stream subscription: an
/// auto-disposed slot would hand out a fresh instance after every idle moment
/// and leak the foreground listener the previous one installed.
@Riverpod(keepAlive: true)
PushMessaging pushMessaging(Ref ref) => throw UnimplementedError(
  'pushMessagingProvider must be overridden by the composition layer (app_providers)',
);
