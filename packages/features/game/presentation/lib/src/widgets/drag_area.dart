import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_presentation/src/notifiers/drag_notifier.br.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/painting/board_geometry.dart';
import 'package:game_presentation/src/painting/piece_painter.dart';
import 'package:shared_domain/shared_domain.dart';

/// What a tray slot calls as the finger that grabbed it moves.
abstract interface class TrayDrag {
  void cancel(int pointer);

  void end(int pointer);

  void move(int pointer, Offset position);

  void start({
    required PointerDeviceKind kind,
    required int pointer,
    required Offset position,
    required int trayIndex,
  });
}

final class DragScope extends InheritedWidget {
  const DragScope({required this.drag, required super.child, super.key});

  final TrayDrag drag;

  static TrayDrag of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DragScope>()!.drag;

  @override
  bool updateShouldNotify(DragScope oldWidget) => oldWidget.drag != drag;
}

/// Carries a grabbed tray piece over the board.
///
/// The finger is tracked in a [ValueNotifier] that repaints the floating piece
/// directly — no rebuild, no provider — so the drag holds 60 fps. Riverpod only
/// hears about it when the cell under the piece changes.
final class DragArea extends ConsumerStatefulWidget {
  const DragArea({required this.boardKey, required this.child, super.key});

  final GlobalKey boardKey;
  final Widget child;

  @override
  ConsumerState<DragArea> createState() => _DragAreaState();
}

/// The floating piece: its centre in [DragArea] coordinates.
typedef _Floating = ({double cellSize, Offset centre, Shape shape});

class _DragAreaState extends ConsumerState<DragArea> implements TrayDrag {
  final _floating = ValueNotifier<_Floating?>(null);
  double _lift = 0;
  int? _pointer;
  Shape? _shape;

  /// How far above a touching finger the piece rides, so the finger doesn't
  /// hide where it lands. A mouse pointer hides nothing.
  static const _touchLift = 60.0;

  @override
  void dispose() {
    _floating.dispose();
    super.dispose();
  }

  // A finger that went down before the screen was removed keeps reporting to
  // the tray slot's Listener, so each callback checks the screen is still here.
  @override
  void cancel(int pointer) {
    if (!mounted || pointer != _pointer) return;

    _release();
    ref.read(dragProvider.notifier).cancel();
  }

  @override
  void end(int pointer) {
    if (!mounted || pointer != _pointer) return;

    _release();
    ref.read(dragProvider.notifier).drop();
  }

  @override
  void move(int pointer, Offset position) {
    if (mounted && pointer == _pointer) _moveTo(position);
  }

  @override
  void start({
    required PointerDeviceKind kind,
    required int pointer,
    required Offset position,
    required int trayIndex,
  }) {
    final run = ref.read(gameProvider).run;
    final shapeId = run.tray[trayIndex];

    if (_pointer != null || run.phase is! PlayingPhase || shapeId == null) {
      return;
    }

    _pointer = pointer;
    _shape = ref.read(gameRulesProvider).shape(shapeId);
    _lift = kind == .mouse ? 0 : _touchLift;
    ref.read(dragProvider.notifier).begin(trayIndex);
    _moveTo(position);
  }

  @override
  Widget build(BuildContext context) => DragScope(
    drag: this,
    child: Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(painter: _FloatingPiecePainter(_floating)),
          ),
        ),
      ],
    ),
  );

  void _moveTo(Offset position) {
    final shape = _shape;
    final board =
        widget.boardKey.currentContext?.findRenderObject() as RenderBox?;
    final area = context.findRenderObject() as RenderBox?;

    if (shape == null || board == null || area == null) return;

    final centre = position - Offset(0, _lift);
    final geometry = BoardGeometry(board.size.shortestSide);

    _floating.value = (
      cellSize: geometry.cellSize,
      centre: area.globalToLocal(centre),
      shape: shape,
    );
    ref
        .read(dragProvider.notifier)
        .hover(geometry.anchorFor(shape, board.globalToLocal(centre)));
  }

  void _release() {
    _pointer = null;
    _shape = null;
    _floating.value = null;
  }
}

final class _FloatingPiecePainter extends CustomPainter {
  _FloatingPiecePainter(this.floating) : super(repaint: floating);

  final ValueNotifier<_Floating?> floating;

  @override
  void paint(Canvas canvas, Size size) {
    final piece = floating.value;

    if (piece == null) return;

    final painter = PiecePainter(
      cellSize: piece.cellSize,
      gap: BoardGeometry.gap,
      shape: piece.shape,
    );
    final pieceSize = PiecePainter.sizeOf(
      piece.shape,
      cellSize: piece.cellSize,
      gap: BoardGeometry.gap,
    );

    canvas
      ..save()
      ..translate(
        piece.centre.dx - pieceSize.width / 2,
        piece.centre.dy - pieceSize.height / 2,
      );
    painter.paint(canvas, pieceSize);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_FloatingPiecePainter oldDelegate) =>
      oldDelegate.floating != floating;
}
