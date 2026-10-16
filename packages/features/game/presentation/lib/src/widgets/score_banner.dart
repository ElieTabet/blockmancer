import 'dart:async';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/widgets/joker_text.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

/// What the last placement scored: `chips × mult = total` on a clear, and the
/// jokers that fired. Every number is read from the move's events — the banner
/// formats, it never computes.
({String detail, String headline})? scoreBannerText(
  BuildContext context,
  List<GameEvent> events,
) {
  final score = events.whereType<ScoreAdded>().firstOrNull;

  if (score == null) return null;

  final banner = context.t.game.banner;

  final headline = [
    if (score.lineScore > 0)
      banner.clear(chips: score.chips, mult: score.mult, total: score.lineScore)
    else
      banner.placed(points: score.piecePoints),
    if (score.bonusPoints > 0) banner.bonus(points: score.bonusPoints),
  ].join(' · ');

  final detail = [
    for (final fired in events.whereType<JokerFired>())
      banner.fired(
        effect: _effect(context, fired.delta),
        joker: jokerText(context, fired.joker).name,
      ),
  ].join(' · ');

  return (detail: detail, headline: headline);
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

/// Shows each placement's score for a moment, then fades.
final class ScoreBanner extends ConsumerStatefulWidget {
  const ScoreBanner({super.key});

  @override
  ConsumerState<ScoreBanner> createState() => _ScoreBannerState();
}

class _ScoreBannerState extends ConsumerState<ScoreBanner> {
  Timer? _fade;

  /// Two lines, reserved even when empty so the board never jumps.
  static const _height = 40.0;
  static const _shown = Duration(milliseconds: 2500);
  var _visible = false;

  @override
  void dispose() {
    _fade?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      gameProvider.select((state) => state.moveCount),
      (_, _) => _show(),
    );

    final events = ref.watch(gameProvider.select((state) => state.lastEvents));
    final text = scoreBannerText(context, events);

    return SizedBox(
      height: _height,
      child: AnimatedOpacity(
        opacity: _visible && text != null ? 1 : 0,
        duration: const Duration(milliseconds: 250),
        child: text == null
            ? const SizedBox.shrink()
            : Column(
                mainAxisAlignment: .center,
                children: [
                  Text(
                    text.headline,
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: DSFont.display(
                      const TextStyle(
                        color: DSColor.positive,
                        fontSize: 16,
                        fontWeight: .w600,
                      ),
                    ),
                  ),
                  if (text.detail.isNotEmpty)
                    Text(
                      text.detail,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: const TextStyle(
                        color: DSColor.accent,
                        fontSize: 12,
                        fontWeight: .w700,
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  void _show() {
    _fade?.cancel();
    setState(() => _visible = true);
    _fade = Timer(_shown, () {
      if (mounted) setState(() => _visible = false);
    });
  }
}
