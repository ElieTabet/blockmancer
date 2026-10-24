import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:splash_presentation/src/package_name.dart';
import 'package:splash_presentation/src/providers_di.br.dart' as di;
import 'package:timber/timber.dart';

part 'splash_state_notifier.br.g.dart';

/// Where the launch's animation stands, for the screen to play its exit.
enum SplashStage {
  /// The logo's entrance, then its hold while launch work runs.
  intro,

  /// Everything the launch waits for is in: the exit plays, and the next
  /// screen fades in over it.
  leaving,
}

/// The soonest the exit starts: when the logo's entrance has settled. Launch
/// work (the update check's Remote Config fetch) runs inside this wait.
const splashExitStart = Duration(milliseconds: 1300);

/// The soonest the next screen fades in, a little into the exit. Later only
/// when the launch's answers come later, and then at once.
const splashHandOff = Duration(milliseconds: 1480);

@riverpod
class SplashStateNotifier extends _$SplashStateNotifier {
  @override
  SplashStage build() => .intro;

  /// Holds the splash until its answers are in and its entrance has played,
  /// signals the exit, then hands off: to the update screen when this version
  /// no longer plays, to the tutorial on a first launch, to Home otherwise.
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

    // Started together, so the hand-off is never later than the answers.
    final handOff = Future<void>.delayed(splashHandOff);

    try {
      final (_, seen, blocked) = await (
        Future<void>.delayed(splashExitStart),
        _seenOrHome(tutorialSeen.read()),
        _requiredOrPlay(updateRequired.read()),
      ).wait;

      if (!context.mounted) return;

      state = .leaving;
      await handOff;

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
