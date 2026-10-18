import 'dart:async';

import 'package:blockmancer_app/config/app_config.dart';
import 'package:app_providers/app_providers.dart';
import 'package:app_router/app_router.dart';
import 'package:design_system/design_system.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:timber/timber.dart';

class Application {
  late final ProviderContainer _container;
  final AppRouter _appRouter = AppRouter();

  Future<void> boot(List<String> args) async {
    WidgetsFlutterBinding.ensureInitialized(); // Ensure the binding is initialized

    // The only place output is chosen. Nothing is planted in release, so every
    // Timber call across the workspace becomes a no-op there.
    if (kDebugMode) Timber.plant(const DebugTree());

    LocaleSettings.useDeviceLocaleSync(); // Resolve the initial locale from the device
    DSFont.useBundledFonts();

    final config = AppConfig.fromEnvironment();

    // Before the container: nothing that reaches messaging may run earlier.
    // No options — each platform reads its own committed config file
    // (GoogleService-Info.plist, google-services.json).
    await Firebase.initializeApp();

    _container = ProviderContainer(
      overrides: appOverrides(
        // Only a release build against production sends usage and crash
        // data, so the dashboards show real use and nothing else.
        collectsTelemetry: kReleaseMode && config.env == .prod,
        router: _appRouter,
        testTools: config.testTools,
      ),
    );

    // First after the container, so the crash handlers cover the rest of boot.
    await initializeTelemetry(_container);

    // Not waited for: the splash outlasts the load, and a sound asked for
    // before it is ready is skipped rather than late.
    unawaited(initializeSounds(_container));
    fetchRemoteConfig(_container);
    unawaited(discardTestStatsOutsideTestBuilds(_container));

    // Before push, whose channel is named in the language the app shows.
    await applyStoredLanguage(_container);

    await initializePushNotifications(
      _container,
      channelDescription: t.push.channelDescription,
      channelName: t.push.channelName,
    );
  }

  void launch() {
    runApp(
      UncontrolledProviderScope(
        container: _container,
        child: TranslationProvider(
          child: Builder(
            // Splash and the game carry no AppBar, so nothing under them annotates
            // the status bar. This covers those; a screen that does have one
            // pushes its own annotation deeper and wins — the same value, by way
            // of DSTheme's appBarTheme.
            builder: (context) => AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: DSPressFeedback(
                onPress: () => playTapSound(_container),
                child: MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  theme: DSTheme.instance.lightTheme,
                  darkTheme: DSTheme.instance.darkTheme,
                  // Dark whatever the phone is set to. Every surface in this app is
                  // charcoal or the brand colour by design, so following the system
                  // setting would only ever produce a light scheme resolving
                  // against dark artwork. The light theme is kept, and is what a light mode
                  // would switch back on.
                  themeMode: .dark,
                  locale: TranslationProvider.of(context).flutterLocale,
                  supportedLocales: AppLocaleUtils.supportedLocales,
                  localizationsDelegates: GlobalMaterialLocalizations.delegates,
                  routerConfig: _appRouter.config(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    // Once the first frame is up: the consent form is drawn over the app.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => unawaited(gatherConsent(_container)),
    );
  }
}
