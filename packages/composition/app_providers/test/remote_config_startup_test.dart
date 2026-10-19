import 'dart:async';

import 'package:app_providers/app_providers.dart';
import 'package:app_providers/src/providers_internal.br.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remote_config/remote_config.dart';

import 'fake_remote_values.dart';

void main() {
  ProviderContainer containerWith(RemoteValues values) {
    final container = ProviderContainer(
      overrides: [remoteValuesProvider.overrideWithValue(values)],
    );
    addTearDown(container.dispose);

    return container;
  }

  testWidgets('Given the app starting, When the launch fetch settles, Then '
      'it listens live, once', (tester) async {
    // Given
    final values = FakeRemoteValues()..fetchGate = Completer<void>();
    final container = containerWith(values);

    // When
    fetchRemoteConfig(container);
    await tester.pump();

    // Then
    expect(values.fetches, 1);
    expect(values.listens, 0);

    values.fetchGate!.complete();
    await tester.pump();
    expect(values.listens, 1);
  });

  testWidgets('Given the app started, When it comes back from the '
      'background, Then it fetches again', (tester) async {
    // Given
    final values = FakeRemoteValues();
    final container = containerWith(values);
    fetchRemoteConfig(container);
    await tester.pump();

    // When
    for (final state in [
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
      AppLifecycleState.paused,
      AppLifecycleState.hidden,
      AppLifecycleState.inactive,
      AppLifecycleState.resumed,
    ]) {
      tester.binding.handleAppLifecycleStateChanged(state);
    }
    await tester.pump();

    // Then
    expect(values.fetches, 2);
  });

  test('Given the app started, When a value is published, Then what '
      'reads the values is handed new ones', () async {
    // Given
    final values = FakeRemoteValues();
    final container = containerWith(values);
    fetchRemoteConfig(container);
    await pumpEventQueue();
    final before = container.read(liveRemoteValueProvider);
    final revision = container.read(remoteValuesRevisionProvider);

    // When
    values.publish('min_version_ios', '1.0.1');
    await pumpEventQueue();

    // Then
    final after = container.read(liveRemoteValueProvider);
    expect(container.read(remoteValuesRevisionProvider), revision + 1);
    expect(identical(after, before), isFalse);
    expect(after('min_version_ios'), '1.0.1');
  });
}
