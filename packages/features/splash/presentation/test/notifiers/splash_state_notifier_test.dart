import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:splash_presentation/splash_presentation.dart';
import 'package:splash_presentation/src/notifiers/splash_state_notifier.br.dart';

final class _RecordingRouting implements SplashRouting {
  int handOffs = 0;

  @override
  void onInitialized(BuildContext context) => handOffs++;
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

  ProviderContainer container() {
    final container = ProviderContainer(
      overrides: bindRoutingProviders(splashRouting: (ref) => routing),
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
    expect(routing.handOffs, 0);

    await tester.pump(const Duration(milliseconds: 800));
    await ready;
    expect(routing.handOffs, 1);
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
    expect(routing.handOffs, 0);
  });
}
