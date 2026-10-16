import 'package:home_presentation/src/providers_di.br.dart' as di;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_state_notifier.br.g.dart';

@riverpod
class HomeStateNotifier extends _$HomeStateNotifier {
  @override
  void build() {}

  /// Once the tab is on screen. Asking for notifications is not this screen's
  /// business, but the moment is: it is the first one a guest and a member
  /// have in common.
  Future<void> onShown() => ref.read(di.askForNotificationsProvider)();
}
