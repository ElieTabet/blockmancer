import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_presentation/home_presentation.dart';
import 'package:home_presentation/src/notifiers/home_state_notifier.br.dart';

void main() {
  test('being shown asks for notifications', () async {
    var asks = 0;
    final container = ProviderContainer(
      overrides: bindProviders(
        askForNotifications: (ref) =>
            () async => asks++,
      ),
    );

    addTearDown(container.dispose);

    await container.read(homeStateProvider.notifier).onShown();

    expect(asks, 1);
  });
}
