import 'package:flutter/widgets.dart';
import 'package:home_presentation/src/providers_di.br.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_notifier.br.g.dart';

/// Home's choices. Holds nothing: it forwards each to [HomeRouting].
@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  void build() {}

  void openDaily(BuildContext context) =>
      ref.read(homeRoutingProvider).onDailyRequested(context);

  void openPractice(BuildContext context) =>
      ref.read(homeRoutingProvider).onPracticeRequested(context);
}
