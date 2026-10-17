import 'dart:math' as math;

import 'package:design_system/design_system.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/rendering.dart';
import 'package:game_presentation/src/notifiers/beat.br.dart';
import 'package:game_presentation/src/painting/board_geometry.dart';
import 'package:game_presentation/src/painting/board_painter.dart';
import 'package:shared_domain/shared_domain.dart';

/// What a beat draws over the board, on its own layer so the board itself
/// never repaints for it: the placed piece squashing into its cells, or the
/// cleared cells flashing white and bursting into particles of their colour.
final class BoardEffectsPainter extends CustomPainter {
  BoardEffectsPainter({required this.beat, required this.progress})
    : super(repaint: progress);

  static const _cellRadius = Radius.circular(6);

  /// The flash's share of a clear; the burst takes the rest.
  static const _flash = 0.4;
  final _paint = Paint();
  static const _particles = 8;

  /// How much bigger than its cell a placed piece starts.
  static const _squash = 0.18;
  final Beat? beat;
  final Animation<double> progress;

  @override
  void paint(Canvas canvas, Size size) {
    final geometry = BoardGeometry(size.shortestSide);

    canvas.clipRect(Offset.zero & size);

    switch (beat) {
      case PlacingBeat(:final cells, :final clearing, :final colorIndex):
        for (final (:cell, :state) in clearing) {
          _cell(canvas, geometry.cellRect(cell), cellColor(state));
        }

        final scale =
            1 + _squash * (1 - Curves.easeOutBack.transform(progress.value));

        for (final cell in cells) {
          final rect = geometry.cellRect(cell);

          // The board under it already shows the piece, at full size.
          _cell(canvas, rect, DSGameColor.emptyCell);
          _cell(
            canvas,
            Rect.fromCenter(
              center: rect.center,
              width: rect.width * scale,
              height: rect.height * scale,
            ),
            DSGameColor.pieces[colorIndex],
          );
        }
      case ClearingBeat(:final cells) when progress.value < _flash:
        final flash = Curves.easeOut.transform(progress.value / _flash);

        for (final (:cell, :state) in cells) {
          _cell(
            canvas,
            geometry.cellRect(cell),
            Color.lerp(cellColor(state), DSColor.white, flash)!,
          );
        }
      case ClearingBeat(:final cells):
        final burst = (progress.value - _flash) / (1 - _flash);

        for (final (:cell, :state) in cells) {
          _burst(canvas, geometry, cell, cellColor(state), burst);
        }
      default:
        return;
    }
  }

  @override
  bool shouldRepaint(BoardEffectsPainter oldDelegate) =>
      oldDelegate.beat != beat || oldDelegate.progress != progress;

  void _burst(
    Canvas canvas,
    BoardGeometry geometry,
    Cell cell,
    Color color,
    double burst,
  ) {
    final centre = geometry.cellRect(cell).center;
    final travel = Curves.easeOut.transform(burst) * geometry.pitch;
    final radius = geometry.cellSize * 0.14 * (1 - burst);

    _paint.color = color.withValues(alpha: 1 - burst);

    for (var particle = 0; particle < _particles; particle++) {
      final angle =
          (particle + _scatter(cell, particle, 1)) * 2 * math.pi / _particles;
      final distance = travel * (0.5 + 0.5 * _scatter(cell, particle, 2));

      canvas.drawCircle(
        centre + Offset(math.cos(angle), math.sin(angle)) * distance,
        radius,
        _paint,
      );
    }
  }

  void _cell(Canvas canvas, Rect rect, Color color) {
    _paint.color = color;
    canvas.drawRRect(RRect.fromRectAndRadius(rect, _cellRadius), _paint);
  }

  /// A fixed value in [0, 1) per cell and particle: the burst looks scattered
  /// yet plays the same every time, with no random source.
  static double _scatter(Cell cell, int particle, int salt) {
    final hash =
        (cell.row * 73856093) ^
        (cell.col * 19349663) ^
        (particle * 83492791) ^
        (salt * 2654435761);

    return (hash & 0xffff) / 0x10000;
  }
}
