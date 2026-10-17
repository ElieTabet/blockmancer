import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:splash_presentation/splash_presentation.dart';
import 'package:splash_presentation/src/notifiers/splash_state_notifier.br.dart';

final class _RecordingRouting implements SplashRouting {
  final handOffs = <String>[];

  @override
  void onFirstLaunch(BuildContext context) => handOffs.add('tutorial');

  @override
  void onInitialized(BuildContext context) => handOffs.add('home');
}

void main() {
  late _RecordingRouting routing;

  setUp(() => routing = _RecordingRouting());

  Future<BuildContext> pumpContext(WidgetTester tester) async {
    late BuildContext context;
    await tester.pumpWidget(
      Builder(
        builder: (built) {
          context = built;

          return const SizedBox();
        },
      ),
    );

    return context;
  }

  ProviderContainer container({Future<bool> Function()? tutorialSeen}) {
    final container = ProviderContainer(
      overrides: [
        ...bindProviders(
          tutorialSeen: (ref) => tutorialSeen?.call() ?? Future.value(true),
        ),
        ...bindRoutingProviders(splashRouting: (ref) => routing),
      ],
    );
    addTearDown(container.dispose);

    return container;
  }

  testWidgets('the splash holds for its minimum, then hands off once', (
    tester,
  ) async {
    // Given
    final context = await pumpContext(tester);
    final splash = container().read(splashStateProvider.notifier);

    // When
    final ready = splash.onReady(context);
    await tester.pump(const Duration(milliseconds: 1000));

    // Then
    expect(routing.handOffs, isEmpty);

    await tester.pump(const Duration(milliseconds: 800));
    await ready;
    expect(routing.handOffs, ['home']);
  });

  testWidgets('a first launch hands off to the tutorial', (tester) async {
    // Given
    final context = await pumpContext(tester);
    final splash = container(
      tutorialSeen: () async => false,
    ).read(splashStateProvider.notifier);

    // When
    final ready = splash.onReady(context);
    await tester.pump(const Duration(milliseconds: 1800));
    await ready;

    // Then
    expect(routing.handOffs, ['tutorial']);
  });

  testWidgets('a second launch goes Home', (tester) async {
    // Given
    final context = await pumpContext(tester);
    final splash = container(
      tutorialSeen: () async => true,
    ).read(splashStateProvider.notifier);

    // When
    final ready = splash.onReady(context);
    await tester.pump(const Duration(milliseconds: 1800));
    await ready;

    // Then
    expect(routing.handOffs, ['home']);
  });

  testWidgets('the splash waits for the answer, however long it takes', (
    tester,
  ) async {
    // Given
    final context = await pumpContext(tester);
    final answer = Completer<bool>();
    final ready = container(
      tutorialSeen: () => answer.future,
    ).read(splashStateProvider.notifier).onReady(context);

    // When
    await tester.pump(const Duration(seconds: 3));

    // Then
    expect(routing.handOffs, isEmpty);

    answer.complete(false);
    await tester.pump(const Duration(milliseconds: 1));
    await ready;
    expect(routing.handOffs, ['tutorial']);
  });

  testWidgets('an answer that can’t be read goes Home', (tester) async {
    // Given
    final context = await pumpContext(tester);
    final splash = container(
      tutorialSeen: () async => throw StateError('storage unavailable'),
    ).read(splashStateProvider.notifier);

    // When
    final ready = splash.onReady(context);
    await tester.pump(const Duration(milliseconds: 1800));
    await ready;

    // Then
    expect(routing.handOffs, ['home']);
  });

  testWidgets('a splash closed during its wait hands off nowhere', (
    tester,
  ) async {
    // Given
    final context = await pumpContext(tester);
    final ready = container()
        .read(splashStateProvider.notifier)
        .onReady(context);

    // When
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 2));
    await ready;

    // Then
    expect(routing.handOffs, isEmpty);
  });
}
