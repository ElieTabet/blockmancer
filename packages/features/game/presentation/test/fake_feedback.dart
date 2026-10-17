import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_presentation/game_presentation.dart';

typedef PlayedSound = ({GameSound sound, double semitones, double variance});

/// Hears the sounds the game asks for and the haptics it sends the phone,
/// each in the order they came.
final class FakeFeedback {
  /// `light`, `medium` or `heavy`.
  final haptics = <String>[];
  final sounds = <PlayedSound>[];

  /// The sounds alone, without their pitch.
  List<GameSound> get soundsPlayed => [
    for (final played in sounds) played.sound,
  ];

  /// Takes the haptics on their way to the platform, which is where Flutter's
  /// `HapticFeedback` sends them.
  void hearHaptics(WidgetTester tester) {
    final messenger = tester.binding.defaultBinaryMessenger
      ..setMockMethodCallHandler(SystemChannels.platform, (call) async {
        if (call.method == 'HapticFeedback.vibrate') {
          haptics.add(switch (call.arguments) {
            'HapticFeedbackType.lightImpact' => 'light',
            'HapticFeedbackType.mediumImpact' => 'medium',
            'HapticFeedbackType.heavyImpact' => 'heavy',
            final other => '$other',
          });
        }

        return null;
      });

    addTearDown(
      () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
    );
  }

  /// How far above its own pitch each [sound] played, in semitones.
  List<double> semitonesOf(GameSound sound) => [
    for (final played in sounds)
      if (played.sound == sound) played.semitones,
  ];

  void play(GameSound sound, {double semitones = 0, double variance = 0}) =>
      sounds.add((sound: sound, semitones: semitones, variance: variance));
}
