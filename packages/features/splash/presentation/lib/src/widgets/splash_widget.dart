import 'dart:async';

import 'package:assets/assets.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splash_presentation/src/notifiers/splash_state_notifier.br.dart';
import 'package:splash_presentation/src/providers_di.br.dart';
import 'package:splash_presentation/src/widgets/splash_effects.dart';
import 'package:splash_presentation/src/widgets/splash_logo.dart';
import 'package:splash_presentation/src/widgets/splash_particles.dart';
import 'package:splash_presentation/src/widgets/splash_timeline.dart';
import 'package:splash_presentation/src/widgets/splash_wordmark.dart';

/// The launch: the native screen's logo comes alive, "BLOCKMANCER" drops in
/// under it, and once the launch's answers are in, everything leaves as the
/// next screen fades in. See [SplashTimeline] for the choreography; when to
/// leave is [SplashStateNotifier]'s.
final class SplashWidget extends ConsumerStatefulWidget {
  const SplashWidget({super.key});

  @override
  ConsumerState<SplashWidget> createState() => _SplashWidgetState();
}

class _SplashWidgetState extends ConsumerState<SplashWidget>
    with TickerProviderStateMixin {
  late final _burst = AnimationController(
    duration: SplashTimeline.burst,
    vsync: this,
  );
  var _burstStarted = false;
  late final _exit = AnimationController(
    duration: SplashTimeline.exit,
    vsync: this,
  );
  late final _idle = AnimationController(
    duration: SplashTimeline.idle,
    vsync: this,
  );
  late final _intro =
      AnimationController(duration: SplashTimeline.intro, vsync: this)
        ..addListener(_setOffBurst)
        ..addStatusListener(_onIntroStatus);
  var _leaving = false;
  var _motion = SplashMotion.waiting;
  var _preloaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(splashStateProvider.notifier).onReady(context);
    });
    unawaited(_start());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_preloaded) return;

    _preloaded = true;
    // The OS keeps its launch screen up until Flutter's first frame, so holding
    // that frame until the logo is decoded, and the wordmark's font loaded,
    // means neither ever blinks in. A no-op once the first frame is out, e.g.
    // when a lifted block returns here.
    final binding = WidgetsBinding.instance..deferFirstFrame();
    unawaited(
      Future.wait([
        precacheImage(Assets.images.logo.provider(), context),
        DSFont.preloadDisplayBold(),
      ]).whenComplete(binding.allowFirstFrame),
    );
  }

  @override
  void dispose() {
    _burst.dispose();
    _exit.dispose();
    _idle.dispose();
    _intro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(splashStateProvider, (_, stage) {
      if (stage == .leaving) _leave();
    });

    return Scaffold(
      // Same colour and logo as the native launch screen, so the hand-off from
      // the OS screen to this one is invisible.
      backgroundColor: DSColor.primary,
      body: SplashClock(
        burst: _burst,
        exit: _exit,
        idle: _idle,
        intro: _intro,
        motion: _motion,
        child: const Stack(
          fit: .expand,
          children: [
            SplashShake(
              child: Center(
                child: SizedBox.square(
                  dimension: SplashTimeline.logo,
                  child: Stack(
                    clipBehavior: .none,
                    children: [
                      SplashGlow(),
                      SplashRays(),
                      SplashRings(),
                      SplashLogo(),
                      SplashParticles(),
                      SplashWordmark(),
                    ],
                  ),
                ),
              ),
            ),
            SplashFlash(),
          ],
        ),
      ),
    );
  }

  /// The exit, once there is something to leave from: straight away under
  /// reduce motion, after the entrance has settled otherwise.
  void _leave() {
    _leaving = true;

    if (_motion != .full || _intro.isCompleted) unawaited(_exit.forward());
  }

  void _onIntroStatus(AnimationStatus status) {
    if (status != .completed || _motion != .full) return;

    if (_leaving) {
      unawaited(_exit.forward());
    } else {
      // Held for the launch's answers: the rays keep turning, the glow
      // breathes.
      unawaited(_idle.repeat());
    }
  }

  void _setOffBurst() {
    if (_burstStarted ||
        _motion != .full ||
        _intro.value < SplashTimeline.at(SplashTimeline.burstAt)) {
      return;
    }

    _burstStarted = true;
    unawaited(_burst.forward());
  }

  /// Once the stored reduce motion answer is in: the whole sequence, or the
  /// fades alone.
  Future<void> _start() async {
    // Held while it is read: a bare read could drop the answer before it
    // comes.
    final setting = ref.listenManual(
      reduceMotionSettingProvider.future,
      (_, _) {},
    );
    var still = true;

    try {
      still = await setting.read();
    } on Object {
      // Motion kept down when the answer can't be read: the safe default.
    } finally {
      setting.close();
    }

    if (!mounted) return;

    still = still || MediaQuery.disableAnimationsOf(context);
    _exit.duration = still ? SplashTimeline.exitStill : SplashTimeline.exit;
    _intro.duration = still ? SplashTimeline.introStill : SplashTimeline.intro;
    setState(() => _motion = still ? .still : .full);

    if (_leaving) {
      _leave();
    } else {
      unawaited(_intro.forward());
    }
  }
}
