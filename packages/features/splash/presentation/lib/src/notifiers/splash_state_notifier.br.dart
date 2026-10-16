import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:splash_presentation/src/providers_di.br.dart' as di;

part 'splash_state_notifier.br.g.dart';

// The branded splash lingers at least this long, so cold-start work that
// finishes sooner doesn't produce a flash.
const _splashDuration = Duration(milliseconds: 1800);

@riverpod
class SplashStateNotifier extends _$SplashStateNotifier {
  @override
  void build() {}

  /// The app's cold start: ask whether this build may launch, kick off the
  /// once-per-launch work, hold the branded splash for its minimum, then hand
  /// off to whichever screen the session calls for.
  ///
  /// What the device work *is*, what order its parts run in, and what a failure
  /// means are all the device feature's business. Splash only says when.
  Future<void> onReady(BuildContext context) async {
    final checkAppStatus = ref.read(di.checkAppStatusProvider);
    final prepareDevice = ref.read(di.prepareDeviceProvider);
    final refreshSettings = ref.read(di.refreshSettingsProvider);
    final routing = ref.read(di.splashRoutingProvider);
    final authenticated = ref.read(di.isAuthenticatedProvider.future);

    // The check comes before the device registers, and the settings after it —
    // their route wants the token. Nothing that throws here is a reason not to
    // launch.
    Future<bool> launch() async {
      if (!await checkAppStatus().catchError((Object _) => true)) return false;

      await prepareDevice().catchError((Object _) {});
      await refreshSettings().catchError((Object _) {});

      return true;
    }

    final (mayLaunch, _) = await (
      launch(),
      Future<void>.delayed(_splashDuration),
    ).wait;

    if (!mayLaunch) return;

    // Resolved before the mounted check, so the answer is not read from a
    // context that may have gone away between the two.
    final isAuthenticated = await authenticated;

    if (!context.mounted) return;

    if (isAuthenticated) {
      routing.onSessionValid(context);
    } else {
      routing.onSessionMissing(context);
    }
  }
}
