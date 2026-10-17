import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_presentation/src/notifiers/game_feedback.br.dart';

/// Keeps the moves' sounds and haptics playing while the game is on screen.
/// Draws nothing.
final class FeedbackPlayer extends ConsumerWidget {
  const FeedbackPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(gameFeedbackProvider);

    return const SizedBox.shrink();
  }
}
