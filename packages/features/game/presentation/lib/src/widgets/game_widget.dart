import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_presentation/src/widgets/board_view.dart';
import 'package:game_presentation/src/widgets/drag_area.dart';
import 'package:game_presentation/src/widgets/game_header.dart';
import 'package:game_presentation/src/widgets/joker_chips.dart';
import 'package:game_presentation/src/widgets/phase_overlay.dart';
import 'package:game_presentation/src/widgets/round_card.dart';
import 'package:game_presentation/src/widgets/tray_view.dart';

/// The game screen: the round, the jokers, the board and the tray, with the
/// sheet the run waits on laid over them.
///
/// Stateful only to own the board's key, which the drag needs to turn a finger
/// position into a cell.
final class GameWidget extends StatefulWidget {
  const GameWidget({super.key});

  @override
  State<GameWidget> createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget> {
  final _boardKey = GlobalKey();

  @override
  Widget build(BuildContext context) => AnnotatedRegion(
    value: SystemUiOverlayStyle.light,
    child: Scaffold(
      backgroundColor: DSColor.primary,
      body: Stack(
        children: [
          DragArea(
            boardKey: _boardKey,
            child: SafeArea(
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
                    const Align(alignment: .centerLeft, child: JokerChips()),
                    Expanded(
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: BoardView(key: _boardKey),
                        ),
                      ),
                    ),
                    const TrayView(),
                  ],
                ),
              ),
            ),
          ),
          const Positioned.fill(child: PhaseOverlay()),
        ],
      ),
    ),
  );
}
