import 'package:home_presentation/src/providers_di.br.dart' as di;
import 'package:riverpod_annotation/riverpod_annotation.dart';

// home_presentation — public providers exposed by this layer.

/// Binds what the tab reads. It never names `push_notifications` — composition
/// points the slot at whatever owns the permission ask.
List<Override> bindProviders({
  required di.AskForNotificationsFun Function(Ref ref) askForNotifications,
}) => [di.askForNotificationsProvider.overrideWith(askForNotifications)];
