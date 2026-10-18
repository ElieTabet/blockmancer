// The composition wiring itself: appOverrides() must satisfy every DI slot the
// app reads at runtime. The app smoke test doesn't cover this — a missing bind
// would otherwise only surface on the first real request.
//
// The DI slots aren't exported from their packages' barrels (they're bound, not
// read, by consumers), so this reaches into src/ the way the feature tests do.

import 'dart:math';

import 'package:app_providers/app_providers.dart';
import 'package:app_providers/src/providers_internal.br.dart';
import 'package:app_router/app_router.dart';
import 'package:blockmancer_engine/blockmancer_engine.dart';
import 'package:external_links/external_links.dart' as external_links;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_data/game_data.dart';
import 'package:game_domain/game_domain.dart' as game;
import 'package:game_presentation/game_presentation.dart' as game_ui;
import 'package:game_presentation/src/providers_di.br.dart' as game_ui_di;
import 'package:home_presentation/src/providers_di.br.dart' as home_di;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:play_stats/play_stats.dart';
import 'package:push/push.dart';
import 'package:push/src/providers_di.br.dart' as push_di;
import 'package:remote_config/remote_config.dart';
import 'package:push_notifications_domain/push_notifications_domain.dart'
    as push_notifications;
import 'package:push_notifications_presentation/src/providers_di.br.dart'
    as push_notifications_di;
import 'package:settings_data/settings_data.dart';
import 'package:settings_domain/settings_domain.dart' as settings;
import 'package:settings_presentation/src/providers_di.br.dart'
    as settings_ui_di;
import 'package:shared_domain/shared_domain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sounds/sounds.dart';
import 'package:splash_presentation/splash_presentation.dart' as splash_ui;
import 'package:telemetry/telemetry.dart';

import 'engine_game.dart';
import 'fake_clock.dart';
import 'fake_random.dart';
import 'fake_sound_engine.dart';

void main() {
  ProviderContainer buildContainer({bool testTools = false}) {
    final container = ProviderContainer(
      overrides: appOverrides(
        collectsTelemetry: false,
        router: AppRouter(),
        testTools: testTools,
      ),
    );
    addTearDown(container.dispose);

    return container;
  }

  test('the game reaches the engine and its storage only through slots', () {
    final container = buildContainer();

    expect(container.read(game.gameRulesProvider), isA<BlockmancerEngine>());
    expect(
      container.read(game.bestScoresProvider),
      isA<SharedPreferencesBestScores>(),
    );
    expect(container.read(game.clockProvider), isA<SystemClock>());
    expect(
      container.read(game.progressionStoreProvider),
      isA<SharedPreferencesProgressionStore>(),
    );
    expect(
      container.read(game.runStoreProvider),
      isA<SharedPreferencesRunStore>(),
    );
  });

  test('a release build counts in Firebase only, hides the testers\' rows and '
      'fetches Remote Config twice a day', () {
    final container = buildContainer();

    expect(
      container.read(game.analyticsSinkProvider),
      isA<FirebaseAnalyticsSink>(),
    );
    expect(container.read(settings_ui_di.showsTestToolsProvider), isFalse);
    expect(container.read(remoteValuesProvider), isA<FirebaseRemoteValues>());
  });

  test('a test build counts in Firebase and on the device, and shows the '
      'testers\' rows', () {
    final container = buildContainer(testTools: true);

    expect(
      container.read(game.analyticsSinkProvider),
      isA<CompositeAnalyticsSink>(),
    );
    expect(container.read(settings_ui_di.showsTestToolsProvider), isTrue);
  });

  test('a release build deletes the stats a test build counted on the phone, '
      'a test build keeps them', () async {
    // Given
    SharedPreferences.setMockInitialValues({'playStats': '{"version":1}'});

    // When
    await discardTestStatsOutsideTestBuilds(buildContainer(testTools: true));
    final keptByTestBuild = (await SharedPreferences.getInstance()).getString(
      'playStats',
    );
    await discardTestStatsOutsideTestBuilds(buildContainer());

    // Then
    expect(keptByTestBuild, isNotNull);
    expect(
      (await SharedPreferences.getInstance()).getString('playStats'),
      isNull,
    );
  });

  // The day is the game's to decide and the seed the engine's: this is the one
  // place both are real.
  test(
    'two players on the same UTC day, wherever they are, play the same run',
    () {
      // Given: 10:00 in New York and 01:00 the next morning in Tokyo
      const engine = BlockmancerEngine();
      game.RunStart dailyAt(String instant) {
        final container = engineGame(clock: FakeClock(DateTime.parse(instant)));

        return container.read(game.runStartForProvider)(
          .daily,
          progression: container.read(game.initialProgressionProvider),
        );
      }

      final newYork = dailyAt('2026-10-16T10:00:00-05:00');
      final tokyo = dailyAt('2026-10-17T01:00:00+09:00');

      // When: each takes the first joker offered
      RunState firstRound(int seed) {
        final start = engine.startRun(config: engine.defaultConfig, seed: seed);
        final offers = (start.phase as PickingJokerPhase).offers;

        return engine.pickJoker(start, id: offers.first).$1;
      }

      // Then: the same pieces, from the same seed
      expect(tokyo, newYork);
      expect(firstRound(tokyo.seed), firstRound(newYork.seed));
    },
  );

  // Settings keeps its own choices, and resets the game's progress through a
  // slot: the game's own clearing is what fills it.
  test(
    "settings reach their storage and the game's progress through slots",
    () {
      final container = buildContainer();

      expect(
        container.read(settings.settingsStoreProvider),
        isA<SharedPreferencesSettingsStore>(),
      );
      expect(
        container.read(settings.clearProgressProvider),
        same(container.read(game.clearProgressProvider)),
      );
    },
  );

  // Settings shows the build and writes to support through slots: only
  // app_info knows the version and only external_links the mail app.
  test(
    'Settings reads the build from app_info and mails through external_links',
    () async {
      // Given: a release build, on a phone whose details can't be read here
      TestWidgetsFlutterBinding.ensureInitialized();
      PackageInfo.setMockInitialValues(
        appName: 'Blockmancer',
        buildNumber: '2',
        buildSignature: '',
        packageName: 'com.elietabet.blockmancer',
        version: '1.0.0',
      );
      final container = buildContainer();

      // When
      final details = await container.read(settings.appDetailsProvider.future);

      // Then
      expect(
        details,
        const settings.AppDetails(
          build: '2',
          device: 'unknown',
          os: 'unknown',
          version: '1.0.0',
        ),
      );
      expect(
        container.read(settings.composeEmailProvider),
        external_links.composeEmail,
      );
    },
  );

  // Settings keeps whether the tutorial was seen: the splash reads it to open
  // the tutorial, and the game keeps it once the tutorial is done.
  test(
    'the tutorial shows on a first launch, and not once it is done',
    () async {
      // Given: a first launch
      final container = buildContainer();
      expect(
        await container.read(splash_ui.tutorialSeenProvider.future),
        isFalse,
      );

      // When: the game's tutorial is done
      await container.read(game_ui_di.markTutorialSeenProvider)();

      // Then
      expect(
        await container.read(splash_ui.tutorialSeenProvider.future),
        isTrue,
      );
    },
  );

  // The game obeys the app's reduce-motion switch without knowing Settings.
  test("the game keeps still when Settings' reduce motion is on", () {
    // Given
    final container = ProviderContainer(
      overrides: [
        ...appOverrides(
          collectsTelemetry: false,
          router: AppRouter(),
          testTools: false,
        ),
        settings.reduceMotionOnProvider.overrideWithValue(true),
      ],
    );
    addTearDown(container.dispose);

    // When / Then
    expect(container.read(game_ui_di.reduceMotionSettingProvider), isTrue);
  });

  // Home draws the map from the game's rules and progression, and keeps its
  // pin still with Settings' reduce motion, knowing neither package.
  test("Home's map reads the game's worlds and progression, and Settings' "
      'reduce motion', () async {
    // Given: a new player's progression, and reduce motion on
    final progression = game.startingProgression(const BlockmancerEngine());
    final container = ProviderContainer(
      overrides: [
        ...appOverrides(
          collectsTelemetry: false,
          router: AppRouter(),
          testTools: false,
        ),
        game.progressionProvider.overrideWith((ref) async => progression),
        settings.reduceMotionOnProvider.overrideWithValue(true),
      ],
    );
    addTearDown(container.dispose);

    // When
    final worlds = container.read(home_di.worldsProvider);
    final shown = await container.read(home_di.progressionProvider.future);

    // Then
    expect(worlds, container.read(game.worldSummariesProvider));
    expect(worlds.map((world) => world.id), [
      WorldId.rubble,
      WorldId.gravity,
      WorldId.fog,
      WorldId.tide,
      WorldId.mirror,
    ]);
    expect(worlds.where((world) => world.playable).map((world) => world.id), [
      WorldId.rubble,
      WorldId.gravity,
      WorldId.fog,
      WorldId.tide,
      WorldId.mirror,
    ]);
    expect(shown, progression);
    expect(
      container.read(home_di.dailyDateProvider),
      container.read(game.todaysDailyDateProvider),
    );
    expect(container.read(home_di.reduceMotionSettingProvider), isTrue);
    expect(
      container.read(home_di.jokerCollectionProvider),
      container.read(game.jokerCollectionProvider),
    );
    expect(
      container.read(home_di.markJokersAnnouncedProvider),
      same(container.read(game.markJokersAnnouncedProvider)),
    );
  });

  // The Spellbook's pairs are the engine's: every joker once, its partner
  // beside it, in the order a player unlocks them.
  test('the joker collection holds every joker in its pair', () {
    // Given / When
    final collection = buildContainer().read(game.jokerCollectionProvider);

    // Then
    const engine = BlockmancerEngine();
    expect(collection.pairs, hasLength(JokerId.values.length ~/ 2));
    expect(
      collection.pairs.expand((pair) => [pair.first, pair.second]).toSet(),
      JokerId.values.toSet(),
    );
    for (final pair in collection.pairs) {
      expect(engine.partnerOf(pair.first), pair.second);
    }
    expect(
      [for (final pair in collection.pairs.skip(6)) pair.unlock],
      const [
        JokerUnlock.boss(world: .rubble),
        JokerUnlock.boss(world: .gravity),
        JokerUnlock.boss(world: .fog),
        JokerUnlock.boss(world: .tide),
        JokerUnlock.boss(world: .mirror),
        JokerUnlock.stars(count: 4),
        JokerUnlock.stars(count: 6),
      ],
    );
    expect(collection.pairs.take(6).map((pair) => pair.unlock).toSet(), {
      const JokerUnlock.starting(),
    });
  });

  // The game obeys the app's sound and haptics switches without knowing
  // Settings.
  test(
    "the game goes quiet and still when Settings' sound and haptics are off",
    () {
      // Given
      final container = ProviderContainer(
        overrides: [
          ...appOverrides(
            collectsTelemetry: false,
            router: AppRouter(),
            testTools: false,
          ),
          settings.hapticsOnProvider.overrideWithValue(false),
          settings.soundOnProvider.overrideWithValue(false),
        ],
      );
      addTearDown(container.dispose);

      // When / Then
      expect(container.read(game_ui_di.hapticsOnSettingProvider), isFalse);
      expect(container.read(game_ui_di.soundOnSettingProvider), isFalse);
    },
  );

  group('sounds', () {
    late FakeSoundEngine engine;

    Future<ProviderContainer> buildLoadedContainer({
      Random? random,
      bool soundOn = true,
    }) async {
      final container = ProviderContainer(
        overrides: [
          ...appOverrides(
            collectsTelemetry: false,
            router: AppRouter(),
            testTools: false,
          ),
          gameSoundsProvider.overrideWithValue(
            GameSounds(engine: engine, random: random),
          ),
          settings.soundOnProvider.overrideWithValue(soundOn),
        ],
      );
      addTearDown(container.dispose);
      await initializeSounds(container);

      return container;
    }

    setUp(() => engine = FakeSoundEngine());

    test(
      "each of the game's sounds plays its own file, at its pitch",
      () async {
        // Given
        final container = await buildLoadedContainer();
        final playSound = container.read(game_ui_di.playSoundProvider);

        // When: each an octave up
        for (final sound in game_ui.GameSound.values) {
          playSound(sound, semitones: 12);
        }

        // Then
        expect(engine.played, [
          for (final sound in [
            Sound.bossStart,
            Sound.bossWin,
            Sound.cheer,
            Sound.clear,
            Sound.joker,
            Sound.kaching,
            Sound.place,
            Sound.roundLost,
            Sound.roundWon,
            Sound.tick,
          ])
            (assetKey: sound.assetKey, speed: 2.0),
        ]);
      },
    );

    test("a game sound's variance reaches the sound's pitch", () async {
      // Given: a random draw at the top of its range
      final container = await buildLoadedContainer(random: const FakeRandom(1));

      // When
      container.read(game_ui_di.playSoundProvider)(
        game_ui.GameSound.place,
        variance: 0.05,
      );

      // Then
      expect(engine.played.single.speed, closeTo(1.05, 1e-9));
    });

    test('a tap plays the tap sound', () async {
      // Given
      final container = await buildLoadedContainer();

      // When
      playTapSound(container);

      // Then
      expect(engine.played, [(assetKey: Sound.tap.assetKey, speed: 1.0)]);
    });

    test("a tap is silent while Settings' sound is off", () async {
      // Given
      final container = await buildLoadedContainer(soundOn: false);

      // When
      playTapSound(container);

      // Then
      expect(engine.played, isEmpty);
    });
  });

  // The testers' numbers: a test build counts into play_stats without the
  // game knowing it, and Settings shares them through external_links without
  // knowing it.
  test("a test build counts into the device's play stats too, and Settings "
      'shares them', () {
    final container = buildContainer(testTools: true);

    expect(container.read(playStatsProvider), isA<LocalPlayStats>());
    expect(
      container.read(settings_ui_di.shareTextProvider),
      external_links.shareText,
    );
    expect(container.read(settings.exportTestStatsProvider), isNotNull);
  });

  test('a revive costs nothing until there is an ad network', () async {
    expect(
      await buildContainer().read(game_ui_di.rewardedActionProvider)(),
      isTrue,
    );
  });

  // Push crosses three packages and never lets any but `push` name Firebase:
  // push_notifications decides and the router opens what a tap is about.
  // These binds are the whole join.
  test('the push slots are bound across push, its feature and the rest', () {
    final container = buildContainer();

    expect(
      container.read(push_di.pushMessagingProvider),
      isA<FirebasePushMessaging>(),
    );
    // Read from one container, which is what proves the device ↔
    // push_notifications pair is not circular.
    expect(
      container.read(push_notifications.askForNotificationsProvider),
      isA<push_notifications.AskForNotificationsFun>(),
    );
    expect(
      container.read(push_notifications.pushDestinationsProvider),
      isA<push_notifications.PushDestinationsFun>(),
    );
    expect(
      container.read(push_notifications.reportPushTokenProvider),
      isA<push_notifications.ReportPushTokenFun>(),
    );
    expect(
      container.read(push_notifications_di.initializeMessagingProvider),
      isA<push_notifications_di.InitializeMessagingFun>(),
    );
    expect(
      container.read(push_notifications_di.reportNonFatalProvider),
      isA<push_notifications_di.ReportNonFatalFun>(),
    );
    expect(
      container.read(push_notifications_di.pushNotificationsRoutingProvider),
      isA<PushNotificationsRoutingImpl>(),
    );
  });

  // Only `telemetry` names the analytics and crash plugins, and the app alone
  // says whether this build collects.
  test('the telemetry slots are bound', () {
    final container = buildContainer();

    expect(container.read(telemetryProvider), isA<FirebaseTelemetry>());
    expect(container.read(collectsTelemetryProvider), false);
  });
}
