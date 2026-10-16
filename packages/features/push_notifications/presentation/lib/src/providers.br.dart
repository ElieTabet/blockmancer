import 'package:push_notifications_presentation/src/notifiers/push_openings_notifier.br.dart';
import 'package:push_notifications_presentation/src/package_name.dart';
import 'package:push_notifications_presentation/src/providers_di.br.dart' as di;
import 'package:push_notifications_presentation/src/routing/push_notifications_routing.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timber/timber.dart';

part 'providers.br.g.dart';

// push_notifications_presentation — public providers exposed by this layer.

typedef InitializePushNotificationsFun =
    Future<void> Function({
      required String channelDescription,
      required String channelName,
    });

/// The one push step boot takes, once per launch.
///
/// Messaging first, then the taps: Android's taps on what the app drew itself
/// are only reported once `push` has initialized the plugin that drew them.
///
/// Never throws. Boot awaits this before `runApp`, so a failure here — an icon
/// the OS can't resolve, no Play services — would leave the app on its splash
/// for good. The app launches without push that session instead, and the
/// failure goes to the crash reporter as non-fatal.
@Riverpod(keepAlive: true)
InitializePushNotificationsFun initializePushNotifications(Ref ref) =>
    ({required channelDescription, required channelName}) async {
      try {
        await ref.read(di.initializeMessagingProvider)(
          channelDescription: channelDescription,
          channelName: channelName,
        );
      } catch (error, stackTrace) {
        Timber.e(
          tag: packageName,
          logMessage: 'Setting up messaging failed; launching without it',
          exception: error,
          stackTrace: stackTrace,
        );

        await ref.read(di.reportNonFatalProvider)(
          error,
          stackTrace,
          reason: 'push setup failed at launch',
        );
      }

      ref.read(pushOpeningsProvider);
    };

List<Override> bindRoutingProviders({
  required PushNotificationsRouting Function(Ref ref) pushNotificationsRouting,
}) => [
  di.pushNotificationsRoutingProvider.overrideWith(pushNotificationsRouting),
];

List<Override> bindProviders({
  required di.InitializeMessagingFun Function(Ref ref) initializeMessaging,
  required di.ReportNonFatalFun Function(Ref ref) reportNonFatal,
}) => [
  di.initializeMessagingProvider.overrideWith(initializeMessaging),
  di.reportNonFatalProvider.overrideWith(reportNonFatal),
];
