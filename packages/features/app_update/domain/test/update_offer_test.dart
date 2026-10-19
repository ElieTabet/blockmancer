import 'dart:async';

import 'package:app_update_domain/app_update_domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

final class _MemoryDismissals implements UpdateDismissals {
  String? dismissed;

  @override
  Future<void> dismiss(String version) async => dismissed = version;

  @override
  Future<String?> dismissedVersion() async => dismissed;
}

void main() {
  late _MemoryDismissals dismissals;

  ProviderContainer container({
    Map<String, String> published = const {},
    Future<void>? fetched,
    RemoteValueFun Function(Ref ref)? remoteValue,
  }) {
    final container = ProviderContainer(
      overrides: bindProviders(
        appVersion: (ref) async => '1.0.0',
        remoteValue:
            remoteValue ??
            (ref) =>
                (key) => published[key],
        remoteValuesFetched: (ref) => fetched ?? Future.value(),
        storePlatform: (ref) => .android,
        storeUrls: (ref) => (android: 'play', ios: 'appstore'),
        updateDismissals: (ref) => dismissals,
      ),
    );
    addTearDown(container.dispose);

    return container;
  }

  setUp(() => dismissals = _MemoryDismissals());

  test('Given a newer version published, When its banner is closed, Then it '
      'is not offered again, but the next version is', () async {
    // Given
    final offered = container(published: {'latest_version_android': '1.1.0'});
    expect(await offered.read(updateOfferProvider.future), '1.1.0');

    // When
    await offered.read(dismissUpdateOfferProvider)();

    // Then
    expect(await offered.read(updateOfferProvider.future), isNull);
    expect(
      await container(
        published: {'latest_version_android': '1.2.0'},
      ).read(updateOfferProvider.future),
      '1.2.0',
    );
  });

  test('Given a minimum above the app, Then an update is required and its '
      'store page is the platform\'s', () async {
    // Given
    final required = container(published: {'min_version_android': '2.0.0'});

    // Then
    expect(await required.read(updateRequiredProvider.future), isTrue);
    expect(required.read(storeUrlProvider), 'play');
  });

  test('Given a fetch that never lands, When the check runs, Then it decides '
      'within 2 seconds on the last values', () async {
    // Given
    final pending = container(
      fetched: Completer<void>().future,
      published: {'min_version_android': '2.0.0'},
    );

    // When / Then
    expect(await pending.read(updateRequiredProvider.future), isTrue);
  });

  group('values published while the app is open', () {
    late ProviderContainer live;

    setUp(() {
      live = container(
        remoteValue: (ref) {
          final published = ref.watch(_publishedProvider);

          return (key) => published[key];
        },
      );
      live
        ..listen(updateOfferProvider, (_, _) {})
        ..listen(updateRequiredProvider, (_, _) {});
    });

    void publish(String key, String version) =>
        live.read(_publishedProvider.notifier).publish(key, version);

    test('Given nothing published, When a newer version is, Then it is '
        'offered, and once the minimum is raised, required', () async {
      // Given
      expect(await live.read(updateOfferProvider.future), isNull);

      // When
      publish('latest_version_android', '1.1.0');

      // Then
      expect(await live.read(updateOfferProvider.future), '1.1.0');
      expect(await live.read(updateRequiredProvider.future), isFalse);

      publish('min_version_android', '1.0.1');
      expect(await live.read(updateRequiredProvider.future), isTrue);
    });

    test(
      'Given a version whose banner was closed, When something else is '
      'published, Then it stays closed, and a newer one is offered',
      () async {
        // Given
        publish('latest_version_android', '1.1.0');
        expect(await live.read(updateOfferProvider.future), '1.1.0');
        await live.read(dismissUpdateOfferProvider)();

        // When
        publish('round_1_target', '300');

        // Then
        expect(await live.read(updateOfferProvider.future), isNull);

        publish('latest_version_android', '1.2.0');
        expect(await live.read(updateOfferProvider.future), '1.2.0');
      },
    );
  });
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
