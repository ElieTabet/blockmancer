import 'package:push_notifications_domain/push_notifications_domain.dart';
import 'package:push_notifications_presentation/src/providers_di.br.dart' as di;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'push_openings_notifier.br.g.dart';

/// Opens what each tapped push is about, for as long as the app runs.
///
/// `keepAlive`, and started once at boot: a tap can arrive at any moment, and
/// the push that launched the app is read exactly once. It watches rather than
/// reads, so the slots behind the stream live as long as it does — taps are
/// only listened for after the launch push is known, a platform round trip
/// later.
@Riverpod(keepAlive: true)
class PushOpeningsNotifier extends _$PushOpeningsNotifier {
  @override
  void build() {
    final subscription = ref.watch(pushDestinationsProvider)().listen(_open);

    ref.onDispose(subscription.cancel);
  }

  void _open(PushDestination destination) {
    final routing = ref.read(di.pushNotificationsRoutingProvider);

    switch (destination) {
      case HomePushDestination():
        routing.onHomeOpened();
    }
  }
}
