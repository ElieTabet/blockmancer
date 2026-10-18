import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:splash_presentation/src/package_name.dart';
import 'package:splash_presentation/src/providers_di.br.dart' as di;
import 'package:timber/timber.dart';

part 'splash_state_notifier.br.g.dart';

// The branded splash lingers at least this long, so the hand-off is never a
// flash. Launch work (the update check's Remote Config fetch) runs inside
// this wait.
const _splashDuration = Duration(milliseconds: 1800);

@riverpod
class SplashStateNotifier extends _$SplashStateNotifier {
  @override
  void build() {}

  /// Holds the splash for its minimum, then hands off: to the update screen
  /// when this version no longer plays, to the tutorial on a first launch, to
  /// Home otherwise.
  Future<void> onReady(BuildContext context) async {
    // Held through the wait: the widget only reads this notifier, so it would
    // be disposed during the delay, and the answer it waits for dropped with
    // it before it arrives.
    final keepAlive = ref.keepAlive();
    final tutorialSeen = ref.listen(di.tutorialSeenProvider.future, (_, _) {});
    final updateRequired = ref.listen(
      di.updateRequiredProvider.future,
      (_, _) {},
    );

    try {
      final (_, seen, blocked) = await (
        Future<void>.delayed(_splashDuration),
        _seenOrHome(tutorialSeen.read()),
        _requiredOrPlay(updateRequired.read()),
      ).wait;

      if (!context.mounted) return;

      final routing = ref.read(di.splashRoutingProvider);

      if (blocked) {
        routing.onUpdateRequired(context);
      } else if (seen) {
        routing.onInitialized(context);
      } else {
        routing.onFirstLaunch(context);
      }
    } finally {
      tutorialSeen.close();
      updateRequired.close();
      keepAlive.close();
    }
  }

  /// Playing when the check can't answer: a broken check must never lock a
  /// player out.
  Future<bool> _requiredOrPlay(Future<bool> updateRequired) async {
    try {
      return await updateRequired;
    } on Object catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'Whether an update is required is unknown; playing on',
        exception: error,
        stackTrace: stackTrace,
      );

      return false;
    }
  }

  /// Home when the answer can't be read: a launch that never ends is worse
  /// than a tutorial missed.
  Future<bool> _seenOrHome(Future<bool> tutorialSeen) async {
    try {
      return await tutorialSeen;
    } on Object catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'Whether the tutorial was seen is unknown; going Home',
        exception: error,
        stackTrace: stackTrace,
      );

      return true;
    }
  }
}
