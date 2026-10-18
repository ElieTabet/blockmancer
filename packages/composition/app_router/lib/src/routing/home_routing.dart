import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:game_presentation/game_presentation.dart'
    show GameRoute, showBossCard;
import 'package:home_presentation/home_presentation.dart'
    show HomeRouting, SpellbookRoute;
import 'package:settings_presentation/settings_presentation.dart'
    show SettingsRoute;
import 'package:shared_domain/shared_domain.dart' show WorldId;

/// Home's choices each push a screen over the shell: a run, the Spellbook or
/// Settings; a world's boss card shows over the screen.
final class HomeRoutingImpl implements HomeRouting {
  const HomeRoutingImpl();

  @override
  void onBossCardRequested(BuildContext context, WorldId world) =>
      showBossCard(context, world: world);

  @override
  void onContinueRequested(BuildContext context) =>
      AutoRouter.of(context).push(GameRoute(launch: .resume));

  @override
  void onDailyRequested(BuildContext context) =>
      AutoRouter.of(context).push(GameRoute(launch: .daily));

  @override
  void onPracticeRequested(BuildContext context) =>
      AutoRouter.of(context).push(GameRoute(launch: .practice));

  @override
  void onSettingsRequested(BuildContext context) =>
      AutoRouter.of(context).push(const SettingsRoute());

  @override
  void onSpellbookCloseRequested(BuildContext context) =>
      AutoRouter.of(context).maybePop();

  @override
  void onSpellbookRequested(BuildContext context) =>
      AutoRouter.of(context).push(const SpellbookRoute());

  @override
  void onWorldRequested(BuildContext context, WorldId world) =>
      AutoRouter.of(context).push(GameRoute(launch: .world, world: world));
}
