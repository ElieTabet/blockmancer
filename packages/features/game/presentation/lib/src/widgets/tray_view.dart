import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_presentation/src/notifiers/drag_notifier.br.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/painting/piece_painter.dart';
import 'package:game_presentation/src/providers_internal.br.dart';
import 'package:game_presentation/src/widgets/compact_screen.dart';
import 'package:game_presentation/src/widgets/drag_area.dart';

final class TrayView extends ConsumerWidget {
  const TrayView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slots = ref.watch(
      gameProvider.select((state) => state.run.tray.length),
    );

    return Row(
      spacing: DSSpace.small,
      children: [
        for (var index = 0; index < slots; index++)
          Expanded(child: TraySlot(index: index)),
      ],
    );
  }
}

/// One tray piece. Grabbing it starts the drag; it dims while dragged and when
/// it fits nowhere on the board.
final class TraySlot extends ConsumerWidget {
  const TraySlot({required this.index, super.key});

  static const _cellSize = 13.0;
  static const _dimmed = 0.35;
  static const _dragged = 0.2;
  static const _gap = 2.0;
  static const _compactHeight = 64.0;
  static const _height = 84.0;

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rules = ref.watch(gameRulesProvider);
    final shapeId = ref.watch(
      gameProvider.select((state) => state.run.tray[index]),
    );
    final fits = ref.watch(trayFitsProvider(index));
    final dragged = ref.watch(
      dragProvider.select((drag) => drag?.trayIndex == index),
    );
    final drag = DragScope.of(context);

    return Listener(
      onPointerCancel: (event) => drag.cancel(event.pointer),
      onPointerDown: (event) => drag.start(
        kind: event.kind,
        pointer: event.pointer,
        position: event.position,
        trayIndex: index,
      ),
      onPointerMove: (event) => drag.move(event.pointer, event.position),
      onPointerUp: (event) => drag.end(event.pointer),
      child: Container(
        height: isCompactScreen(context) ? _compactHeight : _height,
        decoration: BoxDecoration(
          color: DSColor.card,
          borderRadius: .circular(DSCornerRadius.large),
          border: .all(color: DSColor.cardBorder, width: 1.5),
        ),
        alignment: .center,
        child: shapeId == null
            ? null
            : CustomPaint(
                size: PiecePainter.sizeOf(
                  rules.shape(shapeId),
                  cellSize: _cellSize,
                  gap: _gap,
                ),
                painter: PiecePainter(
                  cellSize: _cellSize,
                  gap: _gap,
                  opacity: dragged ? _dragged : (fits ? 1 : _dimmed),
                  shape: rules.shape(shapeId),
                ),
              ),
      ),
    );
  }
}
