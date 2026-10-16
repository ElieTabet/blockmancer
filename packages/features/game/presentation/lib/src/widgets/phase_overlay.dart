import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/painting/game_palette.dart';
import 'package:game_presentation/src/widgets/joker_offer_sheet.dart';
import 'package:game_presentation/src/widgets/round_lost_sheet.dart';
import 'package:game_presentation/src/widgets/run_end_sheet.dart';
import 'package:shared_domain/shared_domain.dart';

enum _Sheet { end, lost, offers }

/// The sheet the run is waiting on, over a dimmed board — or nothing while
/// playing. Declarative rather than a modal route: the run's phase alone says
/// which sheet is up, so there is no route to keep in step with it.
final class PhaseOverlay extends ConsumerWidget {
  const PhaseOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sheet = ref.watch(
      gameProvider.select(
        (state) => switch (state.run.phase) {
          PickingJokerPhase() => _Sheet.offers,
          RoundLostPhase() => _Sheet.lost,
          WonPhase() || OverPhase() => _Sheet.end,
          PlayingPhase() => null,
        },
      ),
    );

    if (sheet == null) return const SizedBox.shrink();

    return ColoredBox(
      color: GamePalette.scrim,
      child: Align(
        alignment: .bottomCenter,
        child: _SheetFrame(
          child: switch (sheet) {
            .end => const RunEndSheet(),
            .lost => const RoundLostSheet(),
            .offers => const JokerOfferSheet(),
          },
        ),
      ),
    );
  }
}

final class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.child});

  static const _radius = Radius.circular(28);

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    decoration: const BoxDecoration(
      color: GamePalette.sheet,
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
