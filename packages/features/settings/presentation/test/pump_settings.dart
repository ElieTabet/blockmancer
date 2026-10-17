import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:settings_domain/settings_domain.dart' as settings;
import 'package:settings_presentation/settings_presentation.dart';
import 'package:settings_presentation/src/widgets/settings_widget.dart';

import 'fake_feedback.dart';
import 'fake_settings_routing.dart';
import 'fake_settings_store.dart';

/// Mounts Settings over [store], on a phone. Each clearing of the progress is
/// recorded in [clearedProgress], and mail drafts open in [mailApp].
Future<FakeSettingsRouting> pumpSettings(
  WidgetTester tester, {
  List<String>? clearedProgress,
  FakeMailApp? mailApp,
  FakeSettingsStore? store,
}) async {
  final routing = FakeSettingsRouting();

  tester.view.physicalSize = const Size(390, 844) * 3;
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);

  // The locale is global, so a test that switches it must not leak it.
  addTearDown(() => LocaleSettings.setLocaleSync(.en));

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        ...settings.bindProviders(
          appDetails: (ref) async => testAppDetails,
          clearProgress: (ref) =>
              () async => clearedProgress?.add('cleared'),
          composeEmail: (ref) => (mailApp ?? FakeMailApp()).compose,
          settingsStore: (ref) => store ?? FakeSettingsStore(),
        ),
        ...bindRoutingProviders(settingsRouting: (ref) => routing),
      ],
      child: TranslationProvider(
        child: MaterialApp(
          theme: DSTheme.instance.darkTheme,
          home: const SettingsWidget(),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  return routing;
}
