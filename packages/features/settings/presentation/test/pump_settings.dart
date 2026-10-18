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
/// recorded in [clearedProgress], mail drafts open in [mailApp], and the test
/// stats are shared into [shareSheet]. A [testBuild] shows the testers' rows;
/// a test crash is recorded in [crashes]. The store prices Remove ads at
/// [removeAdsPrice], already in the player's currency. Text is drawn at
/// [textScale].
Future<FakeSettingsRouting> pumpSettings(
  WidgetTester tester, {
  List<String>? clearedProgress,
  settings.ConsentAnswer consent = (
    canRequestAds: true,
    privacyOptionsRequired: false,
  ),
  List<String>? crashes,
  List<String>? links,
  bool ownsRemoveAds = false,
  List<String>? purchases,
  String? removeAdsPrice = '3,99 €',
  bool restoreFinds = false,
  bool storeOpens = true,
  FakeMailApp? mailApp,
  FakeShareSheet? shareSheet,
  FakeSettingsStore? store,
  bool testBuild = true,
  double textScale = 1,
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
          exportTestStats: (ref) =>
              () async => '{"installId":"ab12","schema":1}',
          gatherConsent: (ref) =>
              () async => consent,
          openUrl: (ref) => (url) async {
            links?.add(url);

            return true;
          },
          setAnalyticsConsent: (ref) => ({required granted}) async {},
          settingsStore: (ref) => store ?? FakeSettingsStore(),
          showPrivacyOptions: (ref) =>
              () async => links?.add('privacy options'),
        ),
        ...bindProviders(
          buyRemoveAds: (ref) => () async {
            purchases?.add('buy');

            return storeOpens;
          },
          crashForTest: (ref) =>
              () => crashes?.add('crash'),
          rateApp: (ref) =>
              () async => links?.add('store page'),
          removeAdsOwned: (ref) => ownsRemoveAds,
          removeAdsPrice: (ref) async => removeAdsPrice,
          restorePurchases: (ref) => () async {
            purchases?.add('restore');

            return restoreFinds;
          },
          shareText: (ref) => (shareSheet ?? FakeShareSheet()).share,
          showsTestTools: (ref) => testBuild,
        ),
        ...bindRoutingProviders(settingsRouting: (ref) => routing),
      ],
      child: TranslationProvider(
        child: MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          ),
          theme: DSTheme.instance.darkTheme,
          home: const SettingsWidget(),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  // Asked at launch, as the app does.
  await ProviderScope.containerOf(
    tester.element(find.byType(SettingsWidget)),
  ).read(settings.consentProvider.notifier).gather();
  await tester.pumpAndSettle();

  return routing;
}
