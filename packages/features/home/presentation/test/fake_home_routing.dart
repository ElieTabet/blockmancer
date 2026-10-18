import 'package:flutter/widgets.dart';
import 'package:home_presentation/home_presentation.dart';
import 'package:shared_domain/shared_domain.dart';

/// Records where Home asked to go.
final class FakeHomeRouting implements HomeRouting {
  final calls = <String>[];

  @override
  void onBossCardRequested(BuildContext context, WorldId world) =>
      calls.add('bossCard:${world.name}');

  @override
  void onContinueRequested(BuildContext context) => calls.add('continue');

  @override
  void onDailyRequested(BuildContext context) => calls.add('daily');

  @override
  void onPracticeRequested(BuildContext context) => calls.add('practice');

  @override
  void onSettingsRequested(BuildContext context) => calls.add('settings');

  @override
  void onSpellbookCloseRequested(BuildContext context) =>
      calls.add('spellbook:close');

  @override
  void onSpellbookRequested(BuildContext context) => calls.add('spellbook');

  @override
  void onWorldRequested(BuildContext context, WorldId world) =>
      calls.add('world:${world.name}');
}
