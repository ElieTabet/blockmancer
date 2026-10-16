import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:splash_presentation/src/providers_di.br.dart' as di;

part 'splash_state_notifier.br.g.dart';

// The branded splash lingers at least this long, so the hand-off is never a
// flash. Launch work (Remote Config, later) runs inside this wait.
const _splashDuration = Duration(milliseconds: 1800);

@riverpod
class SplashStateNotifier extends _$SplashStateNotifier {
  @override
  void build() {}

  /// Holds the splash for its minimum, then hands off.
  Future<void> onReady(BuildContext context) async {
    // Resolved before the wait: the widget only reads this notifier, so it can
    // be disposed during the delay, and a ref used after it would throw.
    final routing = ref.read(di.splashRoutingProvider);

    await Future<void>.delayed(_splashDuration);

    if (!context.mounted) return;

    routing.onInitialized(context);
  }
}
