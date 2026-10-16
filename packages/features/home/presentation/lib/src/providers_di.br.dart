import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers_di.br.g.dart';

// home_presentation — inbound dependency-injection slots. Each throws until
// the composition layer overrides it.

typedef AskForNotificationsFun = Future<void> Function();

/// Asks for notification permission and reports the token, whatever the
/// answer. Home only says when.
@riverpod
AskForNotificationsFun askForNotifications(Ref ref) => throw UnimplementedError(
  'askForNotificationsProvider must be overridden by the composition layer',
);
