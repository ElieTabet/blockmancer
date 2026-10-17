import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:settings_domain/settings_domain.dart';

/// A launch of the app over [store]. Progress clears into [onClearProgress].
ProviderContainer launchWith(
  SettingsStore store, {
  ClearProgressFun? onClearProgress,
}) {
  final container = ProviderContainer(
    overrides: bindProviders(
      clearProgress: (ref) => onClearProgress ?? () async {},
      settingsStore: (ref) => store,
    ),
  );
  addTearDown(container.dispose);

  return container;
}
