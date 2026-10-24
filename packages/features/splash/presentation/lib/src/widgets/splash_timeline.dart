import 'package:flutter/widgets.dart';

/// The launch's choreography, in the milliseconds the approved POC gives,
/// read by each part of the scene from [SplashClock].
///
/// Four clocks: the intro (the entrance, up to the exit), the burst's (from
/// the pop, so its cubes land whatever the splash does), an idle loop for as
/// long as launch work holds the splash once the intro has settled, and the
/// exit.
abstract final class SplashTimeline {
  /// The burst's own clock, from the pop: the cubes' flight (up to 60 ms
  /// late, a second long) and the sparkles' twinkles.
  static const burst = Duration(milliseconds: 1100);

  /// When the intro sets the burst off, in ms: the pop.
  static const burstAt = 470.0;
  static const exit = Duration(milliseconds: 250);

  /// Under reduce motion: the logo and wordmark fade out, nothing more.
  static const exitStill = Duration(milliseconds: 300);

  /// One idle cycle at the rays' intro speed ([raysTurn] over their turning
  /// time), so they keep turning at the same pace while held.
  static const idle = Duration(milliseconds: 2764);

  /// The rays turn this much each idle cycle: ten of their 22.5° steps, so
  /// a new cycle starting from 0 shows no jump.
  static const idleRaysTurn = 225.0;
  static const intro = Duration(milliseconds: 1300);

  /// Under reduce motion, the whole intro: the wordmark fading in.
  static const introStill = Duration(milliseconds: 200);

  /// The size the logo is drawn at: what the native launch screen draws
  /// (flutter_native_splash scales the 1024px master ÷4), so the hand-off is
  /// invisible. If the master is ever re-exported at another size, this has
  /// to follow.
  static const logo = 1024 / 4;

  /// How far the rays turn from their start to the exit, in degrees.
  static const raysTurn = 70.0;

  /// Where [ms] of the intro falls, 0 to 1.
  static double at(double ms) => ms / intro.inMilliseconds;

  /// [from] to [to] ms of the intro, as a curve over the whole intro.
  static Interval span(double from, double to, {Curve curve = Curves.linear}) =>
      Interval(at(from), at(to), curve: curve);
}

/// How the launch moves: not yet known (the first frames, the native
/// screen's), the whole sequence, or reduce motion's fades.
enum SplashMotion { waiting, full, still }

/// The scene's clocks, so each part can be a `const` widget listening to
/// just the one it draws from.
final class SplashClock extends InheritedWidget {
  const SplashClock({
    required this.burst,
    required this.exit,
    required this.idle,
    required this.intro,
    required this.motion,
    required super.child,
    super.key,
  });

  final Animation<double> burst;
  final Animation<double> exit;
  final Animation<double> idle;
  final Animation<double> intro;
  final SplashMotion motion;

  static SplashClock of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SplashClock>()!;

  @override
  bool updateShouldNotify(SplashClock oldWidget) =>
      motion != oldWidget.motion ||
      burst != oldWidget.burst ||
      exit != oldWidget.exit ||
      idle != oldWidget.idle ||
      intro != oldWidget.intro;
}
