import 'package:push_notifications_presentation/src/routing/push_notifications_routing.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers_di.br.g.dart';

// push_notifications_presentation — inbound dependency-injection slots. Each
// throws until the composition layer overrides it.

/// Channel creation and foreground presentation, which `push` owns.
typedef InitializeMessagingFun =
    Future<void> Function({
      required String channelDescription,
      required String channelName,
    });

/// Tells the crash reporter about a failure push recovered from, so it is not
/// lost now that it no longer crashes anything.
typedef ReportNonFatalFun =
    Future<void> Function(
      Object error,
      StackTrace stackTrace, {
      required String reason,
    });

@riverpod
InitializeMessagingFun initializeMessaging(Ref ref) => throw UnimplementedError(
  'initializeMessagingProvider must be overridden by the composition layer',
);

@Riverpod(keepAlive: true)
PushNotificationsRouting pushNotificationsRouting(
  Ref ref,
) => throw UnimplementedError(
  'pushNotificationsRoutingProvider must be overridden by the composition layer (app_router)',
);

@riverpod
ReportNonFatalFun reportNonFatal(Ref ref) => throw UnimplementedError(
  'reportNonFatalProvider must be overridden by the composition layer',
);
