import 'package:push_notifications_presentation/push_notifications_presentation.dart'
    as push_notifications_ui;
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// The one push step startup has to take, exposed here so the app shell can
/// take it without importing a feature — the same reason it imports none.
///
/// Called on every launch rather than once per install: re-sending the channel
/// strings is what re-localizes the entry in the phone's system settings after
/// its language changes.
Future<void> initializePushNotifications(
  ProviderContainer container, {
  required String channelDescription,
  required String channelName,
}) => container.read(push_notifications_ui.initializePushNotificationsProvider)(
  channelDescription: channelDescription,
  channelName: channelName,
);
