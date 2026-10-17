import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/widgets/board_view.dart';
import 'package:game_presentation/src/widgets/drag_area.dart';
import 'package:game_presentation/src/widgets/game_header.dart';
import 'package:game_presentation/src/widgets/input_gate.dart';
import 'package:game_presentation/src/widgets/joker_chips.dart';
import 'package:game_presentation/src/widgets/phase_overlay.dart';
import 'package:game_presentation/src/widgets/round_card.dart';
import 'package:game_presentation/src/widgets/score_banner.dart';
import 'package:game_presentation/src/widgets/tray_view.dart';

/// The game screen: the round, the jokers, the board and the tray, with the
/// sheet the run waits on laid over them.
///
/// Stateful to own the board's key, which the drag needs to turn a finger
/// position into a cell, and to save the run when the app is put away.
final class GameWidget extends ConsumerStatefulWidget {
  const GameWidget({super.key});

  @override
  ConsumerState<GameWidget> createState() => _GameWidgetState();
}

class _GameWidgetState extends ConsumerState<GameWidget> {
  final _boardKey = GlobalKey();
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onPause: () => ref.read(gameProvider.notifier).persist(),
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnnotatedRegion(
    value: SystemUiOverlayStyle.light,
    child: Scaffold(
      backgroundColor: DSColor.primary,
      body: InputGate(
        child: Stack(
          children: [
            DragArea(
              boardKey: _boardKey,
              // A drag that starts in the bottom gesture zone is a swipe home
              // to Android, so the tray stays above it.
              child: SafeArea(
                minimum: .only(
                  bottom: MediaQuery.systemGestureInsetsOf(context).bottom,
                ),
                child: Padding(
                  padding: const .symmetric(
                    horizontal: DSSpace.medium,
                    vertical: DSSpace.small,
                  ),
                  child: Column(
                    spacing: DSSpace.small,
                    children: [
                      const GameHeader(),
                      const RoundCard(),
                      const JokerChips(),
                      Expanded(
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: BoardView(key: _boardKey),
                          ),
                        ),
                      ),
                      const ScoreBanner(),
                      const TrayView(),
                    ],
                  ),
                ),
              ),
            ),
            const Positioned.fill(child: PhaseOverlay()),
            // Over the sheets' scrim, so the menu is never out of reach.
            const Positioned(
              left: 0,
              top: 0,
              child: SafeArea(
                child: Padding(
                  padding: .symmetric(
                    horizontal: DSSpace.medium,
                    vertical: DSSpace.small,
                  ),
                  child: LeaveButton(),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
