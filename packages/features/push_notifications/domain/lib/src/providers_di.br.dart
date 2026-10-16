import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers_di.br.g.dart';

// push_notifications_domain — inbound dependency-injection slots. The messaging
// comes from `push`, the report from `device`; each throws until the
// composition layer overrides it.

/// The data of the notification that launched the app, or null.
typedef LaunchMessageFun = Future<Map<String, String>?> Function();

/// The data of each notification tapped while the app runs.
typedef OpenedMessagesFun = Stream<Map<String, String>> Function();

/// Every token FCM mints after the first.
typedef PushTokenChangesFun = Stream<String> Function();

/// The registration token FCM holds right now, or null when there is none yet.
typedef ReadPushTokenFun = Future<String?> Function();

/// Hands a token to whatever tells the server about this install. Never fails
/// at the call site: a report that did not land is the reporter's to log.
typedef ReportPushTokenFun = Future<void> Function(String token);

/// The OS prompt, or its standing answer once there is one.
typedef RequestPushPermissionFun = Future<bool> Function();

@riverpod
LaunchMessageFun launchMessage(Ref ref) => throw UnimplementedError(
  'launchMessageProvider must be overridden by the composition layer',
);

@riverpod
OpenedMessagesFun openedMessages(Ref ref) => throw UnimplementedError(
  'openedMessagesProvider must be overridden by the composition layer',
);

@riverpod
PushTokenChangesFun pushTokenChanges(Ref ref) => throw UnimplementedError(
  'pushTokenChangesProvider must be overridden by the composition layer',
);

@riverpod
ReadPushTokenFun readPushToken(Ref ref) => throw UnimplementedError(
  'readPushTokenProvider must be overridden by the composition layer',
);

@riverpod
ReportPushTokenFun reportPushToken(Ref ref) => throw UnimplementedError(
  'reportPushTokenProvider must be overridden by the composition layer',
);

@riverpod
RequestPushPermissionFun requestPushPermission(
  Ref ref,
) => throw UnimplementedError(
  'requestPushPermissionProvider must be overridden by the composition layer',
);
