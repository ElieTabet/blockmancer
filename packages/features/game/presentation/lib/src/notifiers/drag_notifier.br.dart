import 'package:game_domain/game_domain.dart';
import 'package:game_presentation/src/notifiers/drag_preview.br.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_domain/shared_domain.dart';

part 'drag_notifier.br.g.dart';

/// The drag shadow. Updated only when the hovered cell changes, not on every
/// pointer move: the finger itself is tracked outside Riverpod.
@riverpod
class DragNotifier extends _$DragNotifier {
  @override
  DragPreview? build() => null;

  void begin(int trayIndex) {
    final shapeId = ref.read(gameProvider).run.tray[trayIndex];

    if (shapeId == null) return;

    state = DragPreview(
      anchor: null,
      colorIndex: ref.read(gameRulesProvider).shape(shapeId).colorIndex,
      preview: .none,
      trayIndex: trayIndex,
    );
  }

  /// Drops the piece where it hovers, if it fits there.
  void drop() {
    final drag = state;
    state = null;

    if (drag == null || drag.anchor == null || !drag.preview.fits) return;

    ref
        .read(gameProvider.notifier)
        .place(anchor: drag.anchor!, trayIndex: drag.trayIndex);
  }

  void cancel() => state = null;

  void hover(Cell? anchor) {
    final drag = state;

    if (drag == null || drag.anchor == anchor) return;

    state = drag.copyWith(
      anchor: anchor,
      preview: anchor == null
          ? .none
          : ref
                .read(gameRulesProvider)
                .preview(
                  ref.read(gameProvider).run,
                  anchor: anchor,
                  trayIndex: drag.trayIndex,
                ),
    );
  }
}
