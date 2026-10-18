import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:push_notifications_domain/push_notifications_domain.dart'
    as push_notifications;
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Sets the daily reminder as the player's choices stand, and keeps it so:
/// listened to for the app's life, so the Settings switch takes effect at
/// once, and checked on every return to the app for a change of time zone.
/// After push's start, which readies the notifications plugin.
void startDailyReminder(ProviderContainer container) {
  container.listen(push_notifications.dailyReminderProvider, (_, _) {});

  // Lives as long as the app: the binding holds it.
  AppLifecycleListener(
    onResume: () => unawaited(
      container
          .read(push_notifications.dailyReminderProvider.notifier)
          .resumed(),
    ),
  );
}
