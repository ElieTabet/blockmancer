import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_presentation/src/notifiers/beat.br.dart';
import 'package:game_presentation/src/notifiers/drag_notifier.br.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/notifiers/playback_notifier.br.dart';
import 'package:game_presentation/src/painting/board_effects_painter.dart';
import 'package:game_presentation/src/painting/board_painter.dart';
import 'package:game_presentation/src/painting/hint_painter.dart';
import 'package:game_presentation/src/painting/preview_painter.dart';
import 'package:game_presentation/src/providers_internal.br.dart';
import 'package:game_presentation/src/widgets/combo_pop.dart';
import 'package:shared_domain/shared_domain.dart';

/// The board, the move's effects, the tutorial's hint and the drag shadow over
/// it — separate layers, so a hover repaints the shadow alone, an effect its
/// own layer, and a move the board alone.
final class BoardView extends StatelessWidget {
  const BoardView({super.key});

  @override
  Widget build(BuildContext context) => const Stack(
    fit: .expand,
    children: [
      _BoardLayer(),
      _EffectsLayer(),
      _HintLayer(),
      _PreviewLayer(),
      ComboPop(),
    ],
  );
}

final class _BoardLayer extends ConsumerWidget {
  const _BoardLayer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.watch(gameProvider.select((state) => state.run.board));

    return RepaintBoundary(child: CustomPaint(painter: BoardPainter(board)));
  }
}

final class _EffectsLayer extends ConsumerStatefulWidget {
  const _EffectsLayer();

  @override
  ConsumerState<_EffectsLayer> createState() => _EffectsLayerState();
}

class _EffectsLayerState extends ConsumerState<_EffectsLayer>
    with SingleTickerProviderStateMixin {
  Beat? _beat;
  late final _controller = AnimationController(vsync: this);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      playbackProvider.select((playback) => (playback.step, playback.beat)),
      (_, next) => _draw(next.$2),
    );

    return RepaintBoundary(
      child: CustomPaint(
        painter: BoardEffectsPainter(beat: _beat, progress: _controller),
      ),
    );
  }

  void _draw(Beat? beat) {
    final drawn = beat is PlacingBeat || beat is ClearingBeat ? beat : null;

    if (drawn == null && _beat == null) return;

    setState(() => _beat = drawn);

    if (drawn != null) {
      _controller
        ..duration = drawn.duration
        ..forward(from: 0);
    }
  }
}

final class _HintLayer extends ConsumerStatefulWidget {
  const _HintLayer();

  @override
  ConsumerState<_HintLayer> createState() => _HintLayerState();
}

class _HintLayerState extends ConsumerState<_HintLayer>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: _pulse);
  static const _pulse = Duration(milliseconds: 1600);

  @override
  void initState() {
    super.initState();
    ref.listenManual(
      tutorialHintProvider,
      (_, cells) => _pulseTo(cells),
      fireImmediately: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RepaintBoundary(
    child: CustomPaint(
      painter: HintPainter(
        cells: ref.watch(tutorialHintProvider),
        pulse: _controller,
      ),
    ),
  );

  void _pulseTo(List<Cell> cells) {
    if (cells.isEmpty) return;

    if (ref.read(reduceMotionProvider)) {
      _controller.value = 1;
    } else {
      _controller.forward(from: 0);
    }
  }
}

final class _PreviewLayer extends ConsumerWidget {
  const _PreviewLayer();

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      CustomPaint(painter: PreviewPainter(ref.watch(dragProvider)));
}
