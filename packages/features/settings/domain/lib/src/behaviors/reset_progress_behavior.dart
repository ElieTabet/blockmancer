import 'package:settings_domain/src/providers_di.br.dart';

/// Starts the player over: their progress cleared, and the tutorial offered
/// again.
class ResetProgressBehavior {
  final ClearProgressFun _clearProgress;
  final Future<void> Function() _resetTutorial;

  const ResetProgressBehavior({
    required ClearProgressFun clearProgress,
    required Future<void> Function() resetTutorial,
  }) : _clearProgress = clearProgress,
       _resetTutorial = resetTutorial;

  Future<void> call() async {
    await _clearProgress();
    await _resetTutorial();
  }
}
