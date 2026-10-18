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
  }) {
    final container = ProviderContainer(
      overrides: bindProviders(
        appVersion: (ref) async => '1.0.0',
        remoteValue: (ref) =>
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
}
