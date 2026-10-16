import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_presentation/src/notifiers/drag_notifier.br.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/painting/board_painter.dart';
import 'package:game_presentation/src/painting/preview_painter.dart';

/// The board with the drag shadow over it — two layers, so a hover repaints
/// the shadow alone and a move repaints the board alone.
final class BoardView extends StatelessWidget {
  const BoardView({super.key});

  @override
  Widget build(BuildContext context) =>
      const Stack(fit: .expand, children: [_BoardLayer(), _PreviewLayer()]);
}

final class _BoardLayer extends ConsumerWidget {
  const _BoardLayer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.watch(gameProvider.select((state) => state.run.board));

    return RepaintBoundary(child: CustomPaint(painter: BoardPainter(board)));
  }
}

final class _PreviewLayer extends ConsumerWidget {
  const _PreviewLayer();

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      CustomPaint(painter: PreviewPainter(ref.watch(dragProvider)));
}
