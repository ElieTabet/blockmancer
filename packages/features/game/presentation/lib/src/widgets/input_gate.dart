import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_presentation/src/notifiers/playback_notifier.br.dart';

/// Swallows every touch on [child] for the first [skipAfter] of a move's
/// playback. After that a touch skips to the end and goes on to [child], so a
/// finger reaching for the next piece picks it up. A held playback swallows
/// the touch that lets it go on.
final class InputGate extends ConsumerWidget {
  const InputGate({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (playing, canSkip, held) = ref.watch(
      playbackProvider.select(
        (playback) => (playback.isPlaying, playback.canSkip, playback.held),
      ),
    );

    return Listener(
      behavior: .translucent,
      onPointerDown: playing && (canSkip || held)
          ? (_) => ref.read(playbackProvider.notifier).skip()
          : null,
      child: AbsorbPointer(
        absorbing: playing && (!canSkip || held),
        child: child,
      ),
    );
  }
}
