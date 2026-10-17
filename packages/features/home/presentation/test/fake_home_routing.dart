import 'package:flutter/widgets.dart';
import 'package:home_presentation/home_presentation.dart';

/// Records where Home asked to go.
final class FakeHomeRouting implements HomeRouting {
  final calls = <String>[];

  @override
  void onContinueRequested(BuildContext context) => calls.add('continue');

  @override
  void onDailyRequested(BuildContext context) => calls.add('daily');

  @override
  void onPracticeRequested(BuildContext context) => calls.add('practice');
}
