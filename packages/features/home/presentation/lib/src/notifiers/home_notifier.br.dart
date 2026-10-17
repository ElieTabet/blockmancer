import 'package:flutter/widgets.dart';
import 'package:home_presentation/src/providers_di.br.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_domain/shared_domain.dart';

part 'home_notifier.br.g.dart';

/// Home's choices. Holds nothing: it forwards each to [HomeRouting].
@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  void build() {}

  void closeSpellbook(BuildContext context) =>
      ref.read(homeRoutingProvider).onSpellbookCloseRequested(context);

  void openContinue(BuildContext context) =>
      ref.read(homeRoutingProvider).onContinueRequested(context);

  void openDaily(BuildContext context) =>
      ref.read(homeRoutingProvider).onDailyRequested(context);

  void openPractice(BuildContext context) =>
      ref.read(homeRoutingProvider).onPracticeRequested(context);

  void openSettings(BuildContext context) =>
      ref.read(homeRoutingProvider).onSettingsRequested(context);

  void openSpellbook(BuildContext context) =>
      ref.read(homeRoutingProvider).onSpellbookRequested(context);

  void openWorld(BuildContext context, WorldId world) =>
      ref.read(homeRoutingProvider).onWorldRequested(context, world);
}
