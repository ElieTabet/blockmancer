import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_presentation/src/notifiers/input_lock_notifier.br.dart';

/// Swallows every touch on [child] while the input is locked.
final class InputGate extends ConsumerWidget {
  const InputGate({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      AbsorbPointer(absorbing: ref.watch(inputLockProvider), child: child);
}
