import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_presentation/src/notifiers/beat.br.dart';
import 'package:game_presentation/src/notifiers/playback_notifier.br.dart';
import 'package:game_presentation/src/providers_internal.br.dart';
import 'package:game_presentation/src/widgets/joker_text.dart';
import 'package:game_presentation/src/widgets/points_text.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

/// A move's score under the board. A clear's is counted up: the chips, then
/// the mult, the jokers that fired, then the product, which flies up into the
/// round score. A move that clears nothing shows its points for a moment.
/// Every number is the engine's, from the move's beats; this only counts up to
/// it.
final class ScoreCountUp extends ConsumerStatefulWidget {
  const ScoreCountUp({super.key});

  @override
  ConsumerState<ScoreCountUp> createState() => _ScoreCountUpState();
}

class _ScoreCountUpState extends ConsumerState<ScoreCountUp>
    with SingleTickerProviderStateMixin {
  var _bonus = 0;
  int? _chips;
  late final _controller = AnimationController(vsync: this)
    ..addStatusListener((status) {
      if (status.isCompleted && _points != null) {
        setState(() => _points = null);
      }
    });

  /// The beat whose animation is running.
  Beat? _counting;
  final _fired = <JokerPulseBeat>[];

  /// Two lines, reserved even when empty so the board never jumps.
  static const _height = 40.0;
  var _landed = false;

  /// How long a quiet move's points stay up.
  static const _linger = Duration(milliseconds: 900);
  int? _mult;

  /// A quiet move's points, while they show.
  int? _points;
  int? _product;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      playbackProvider.select((playback) => (playback.step, playback.beat)),
      (_, next) => _onBeat(next.$2),
    );

    final chips = _chips;
    final points = _points;
    final still = ref.watch(reduceMotionProvider);

    return SizedBox(
      height: _height,
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final progress = _controller.value;
            final counting = _counting;

            if (points != null) {
              return _PointsLines(
                fired: _fired,
                opacity: 1 - Curves.easeIn.transform(progress),
                points: points,
              );
            }

            if (chips == null) return const SizedBox.shrink();

            return _ScoreLines(
              bonus: _bonus,
              chips: counting is CountingChipsBeat
                  ? (chips * progress).round()
                  : chips,
              fired: _fired,
              landing: counting is LandingBeat ? progress : 0,
              mult: switch ((counting, _mult)) {
                (CountingMultBeat(), final int mult) =>
                  (mult * progress).round(),
                (_, final mult) => mult,
              },
              product: _product,
              productIn: counting is ProductBeat ? progress : 1,
              still: still,
            );
          },
        ),
      ),
    );
  }

  void _onBeat(Beat? beat) {
    switch (beat) {
      // A quiet move's points fade on their own, past the playback.
      case null when _points != null:
        return;
      case null:
        _controller.stop();
        setState(() => _chips = null);

        return;
      case PointsBeat(:final points):
        _chips = null;
        _fired.clear();
        _points = points;
        setState(() => _counting = beat);
        _controller
          ..duration = _linger
          ..forward(from: 0);

        return;
      case JokerPulseBeat() when _points != null:
        setState(() => _fired.add(beat));

        return;
      case CountingChipsBeat(:final chips):
        _bonus = 0;
        _chips = chips;
        _fired.clear();
        _landed = false;
        _mult = null;
        _points = null;
        _product = null;
      case CountingMultBeat(:final mult):
        _mult = mult;
      // A joker that fires once the score is in, such as a won round's bonus,
      // pulses in the joker bar alone.
      case JokerPulseBeat() when _chips != null && !_landed:
        _fired.add(beat);
      case ProductBeat(:final bonus, :final lineScore):
        _bonus = bonus;
        _product = lineScore;
      case LandingBeat() when _chips != null:
        _landed = true;
      default:
        return;
    }

    setState(() => _counting = beat);
    _controller
      ..duration = beat.duration
      ..forward(from: 0);
  }
}

final class _ScoreLines extends StatelessWidget {
  const _ScoreLines({
    required this.bonus,
    required this.chips,
    required this.fired,
    required this.landing,
    required this.mult,
    required this.product,
    required this.productIn,
    required this.still,
  });

  /// How far the product rises as it flies into the round score.
  static const _rise = 24.0;

  final int bonus;
  final int chips;
  final List<JokerPulseBeat> fired;

  /// 0 until the product lands, then 1 once it has flown.
  final double landing;
  final int? mult;
  final int? product;

  /// 0 as the product appears, 1 once it is in.
  final double productIn;
  final bool still;

  @override
  Widget build(BuildContext context) {
    final banner = context.t.game.banner;
    final product = this.product;
    final pop = still
        ? 1.0
        : 0.6 + 0.4 * Curves.easeOutBack.transform(productIn);

    return Opacity(
      opacity: 1 - landing,
      child: Transform.translate(
        offset: Offset(0, still ? 0 : -_rise * landing),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            FittedBox(
              fit: .scaleDown,
              child: Row(
                spacing: DSSpace.xsmall,
                children: [
                  _Headline(banner.chips(chips: pointsText(context, chips))),
                  if (mult case final mult?)
                    _Headline(banner.mult(mult: pointsText(context, mult))),
                  if (product != null) ...[
                    Opacity(
                      opacity: productIn,
                      child: Transform.scale(
                        scale: pop,
                        child: _Headline(
                          banner.product(total: pointsText(context, product)),
                        ),
                      ),
                    ),
                    if (bonus > 0)
                      _Headline(
                        banner.bonus(points: pointsText(context, bonus)),
                      ),
                  ],
                ],
              ),
            ),
            _FiredLine(fired),
          ],
        ),
      ),
    );
  }
}

final class _PointsLines extends StatelessWidget {
  const _PointsLines({
    required this.fired,
    required this.opacity,
    required this.points,
  });

  final List<JokerPulseBeat> fired;
  final double opacity;
  final int points;

  @override
  Widget build(BuildContext context) => Opacity(
    opacity: opacity,
    child: Column(
      mainAxisAlignment: .center,
      children: [
        _Headline(
          context.t.game.banner.placed(points: pointsText(context, points)),
        ),
        _FiredLine(fired),
      ],
    ),
  );
}

/// What each joker that fired did, in the order it fired.
final class _FiredLine extends StatelessWidget {
  const _FiredLine(this.fired);

  final List<JokerPulseBeat> fired;

  @override
  Widget build(BuildContext context) {
    if (fired.isEmpty) return const SizedBox.shrink();

    return Text(
      [
        for (final pulse in fired)
          context.t.game.banner.fired(
            effect: _effect(context, pulse.delta),
            joker: jokerName(context, pulse.joker),
          ),
      ].join(' · '),
      maxLines: 1,
      overflow: .ellipsis,
      style: const TextStyle(
        color: DSColor.accent,
        fontSize: 12,
        fontWeight: .w700,
      ),
    );
  }
}

final class _Headline extends StatelessWidget {
  const _Headline(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    maxLines: 1,
    style: DSFont.display(
      const TextStyle(color: DSColor.positive, fontSize: 16, fontWeight: .w600),
    ),
  );
}

String _effect(BuildContext context, JokerDelta delta) {
  final banner = context.t.game.banner;

  return switch (delta) {
    ChipsAdded(:final amount) => banner.chipsAdded(amount: amount),
    MultAdded(:final amount) => banner.multAdded(amount: amount),
    MultMultiplied(:final factor) => banner.multMultiplied(factor: factor),
    MultStored(:final total) => banner.multStored(total: total),
    PiecesAdded(:final amount) => banner.piecesAdded(amount: amount),
    PointsAdded(:final amount) => banner.pointsAdded(amount: amount),
    RunPointsAdded(:final amount) => banner.runPointsAdded(amount: amount),
    StoneDropped() => banner.stoneDropped,
    StonesAdded(:final amount) => banner.stonesAdded(amount: amount),
  };
}
