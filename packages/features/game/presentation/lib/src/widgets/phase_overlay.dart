import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/notifiers/playback_notifier.br.dart';
import 'package:game_presentation/src/widgets/joker_offer_sheet.dart';
import 'package:game_presentation/src/widgets/round_lost_sheet.dart';
import 'package:game_presentation/src/widgets/run_end_sheet.dart';
import 'package:game_presentation/src/widgets/unlock_sheet.dart';
import 'package:shared_domain/shared_domain.dart';

enum _Sheet { end, lost, offers, unlocks }

/// The sheet the run is waiting on, over a dimmed board — or nothing while
/// playing. Declarative rather than a modal route: the run's phase alone says
/// which sheet is up, so there is no route to keep in step with it.
///
/// A sheet waits for the move that led to it to play back, so the score lands
/// before the joker pick covers it. A finished run shows nothing until what it
/// earned is kept, then what it unlocked before its end: the end stays up once
/// the player has seen it, to play again from.
final class PhaseOverlay extends ConsumerWidget {
  const PhaseOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sheet = ref.watch(
      gameProvider.select(
        (state) => switch (state.run.phase) {
          PickingJokerPhase() => _Sheet.offers,
          RoundLostPhase() => _Sheet.lost,
          WonPhase() || OverPhase() when state.progressPending => null,
          WonPhase() || OverPhase()
              when (state.progress?.unlocksAnything ?? false) &&
                  !state.unlocksSeen =>
            _Sheet.unlocks,
          WonPhase() || OverPhase() => _Sheet.end,
          PlayingPhase() => null,
        },
      ),
    );

    final playing = ref.watch(
      playbackProvider.select((playback) => playback.isPlaying),
    );

    if (sheet == null || playing) return const SizedBox.shrink();

    return _SheetEntrance(
      key: ValueKey(sheet),
      child: ColoredBox(
        color: DSColor.scrim,
        child: Align(
          alignment: .bottomCenter,
          child: _SheetFrame(
            child: switch (sheet) {
              .end => const RunEndSheet(),
              .lost => const RoundLostSheet(),
              .offers => const JokerOfferSheet(),
              .unlocks => const UnlockSheet(),
            },
          ),
        ),
      ),
    );
  }
}

/// Fades a sheet in, deaf to touches until it is in: a tap meant for the board
/// an instant earlier would otherwise pick a joker or end the run.
final class _SheetEntrance extends StatefulWidget {
  const _SheetEntrance({required this.child, super.key});

  final Widget child;

  @override
  State<_SheetEntrance> createState() => _SheetEntranceState();
}

class _SheetEntranceState extends State<_SheetEntrance>
    with SingleTickerProviderStateMixin {
  var _arrived = false;
  late final _controller = AnimationController(vsync: this, duration: _fadeIn)
    ..addStatusListener((status) {
      if (status.isCompleted) setState(() => _arrived = true);
    })
    ..forward();
  static const _fadeIn = Duration(milliseconds: 300);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
    ignoring: !_arrived,
    child: FadeTransition(opacity: _controller, child: widget.child),
  );
}

final class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.child});

  static const _radius = Radius.circular(28);

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    decoration: const BoxDecoration(
      color: DSColor.sheet,
      borderRadius: .vertical(top: _radius),
    ),
    child: SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const .all(DSSpace.large),
        child: child,
      ),
    ),
  );
}

/// A sheet's title, in the display face.
final class SheetTitle extends StatelessWidget {
  const SheetTitle(this.text, {this.color = DSColor.accent, super.key});

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: DSFont.display(
      TextStyle(color: color, fontSize: 26, fontWeight: .w600),
    ),
  );
}
