import 'dart:async';

import 'package:app_update_domain/app_update_domain.dart' as app_update;
import 'package:app_update_presentation/app_update_presentation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

final class _NoDismissals implements app_update.UpdateDismissals {
  @override
  Future<void> dismiss(String version) async {}

  @override
  Future<String?> dismissedVersion() async => null;
}

final class _FakeRouting implements AppUpdateRouting {
  var blocked = 0;

  @override
  void onUpdateRequired() => blocked++;
}

/// What Remote Config publishes, changed as the console would.
final class _Published extends Notifier<Map<String, String>> {
  @override
  Map<String, String> build() => const {};

  void publish(String key, String value) => state = {...state, key: value};
}

final _publishedProvider = NotifierProvider<_Published, Map<String, String>>(
  _Published.new,
);

void main() {
  late Completer<void> gameSettled;
  late _FakeRouting routing;
  late ProviderContainer container;

  void publish(String key, String value) =>
      container.read(_publishedProvider.notifier).publish(key, value);

  setUp(() {
    gameSettled = Completer<void>();
    routing = _FakeRouting();
    container = ProviderContainer(
      overrides: [
        ...app_update.bindProviders(
          appVersion: (ref) async => '1.0.0',
          remoteValue: (ref) {
            final published = ref.watch(_publishedProvider);

            return (key) => published[key];
          },
          remoteValuesFetched: (ref) => Future.value(),
          storePlatform: (ref) => .ios,
          storeUrls: (ref) => (android: 'play', ios: 'appstore'),
          updateDismissals: (ref) => _NoDismissals(),
        ),
        ...bindProviders(
          openUrl: (ref) =>
              (url) async => true,
          whenGameSettled: (ref) =>
              () => gameSettled.future,
        ),
        ...bindRoutingProviders(appUpdateRouting: (ref) => routing),
      ],
    );
    addTearDown(container.dispose);
    container.listen(updateGuardProvider, (_, _) {});
  });

  test(
    'Given the game busy with a move, When the minimum is raised above the '
    'app, Then the update screen waits for the move, and goes up once',
    () async {
      // Given
      await pumpEventQueue();

      // When
      publish('min_version_ios', '1.0.1');
      await pumpEventQueue();

      // Then
      expect(routing.blocked, 0);

      gameSettled.complete();
      await pumpEventQueue();
      expect(routing.blocked, 1);

      publish('min_version_ios', '1.0.2');
      await pumpEventQueue();
      expect(routing.blocked, 1);
    },
  );

  test('Given a newer version published, When the app still plays, Then no '
      'update screen goes up', () async {
    // Given
    gameSettled.complete();

    // When
    publish('latest_version_ios', '1.1.0');
    await pumpEventQueue();

    // Then
    expect(routing.blocked, 0);
  });
}
