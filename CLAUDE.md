# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Blockmancer** — A block puzzle roguelite: place pieces, clear lines, and build joker combos that change how every run plays. Climb the world map, beat bosses, and compete in a daily run with the same pieces for everyone.

`blockmancer` is a Flutter cross-platform mobile application structured as a **Dart Pub Workspace monorepo** with Melos for script orchestration. It implements Clean Architecture with Riverpod (notifier-based presentation) and compile-time feature isolation — each feature is a standalone Dart package.

**Tech Stack:** Flutter ^3.44.0, Dart ^3.11.0, flutter_riverpod ^3.3.1, riverpod_annotation ^4.0.0, riverpod_generator ^4.0.1, freezed ^3.2.5, json_serializable ^6.8.0, build_runner ^2.13.1, auto_route ^11.1.0, auto_route_generator >=10.0.0 <10.5.0, mocktail ^1.0.4

## Workspace Structure

```
blockmancer/
├── app/                  # Thin runnable shell — depends only on the composition layer (imports NO feature package)
│   ├── lib/config/           # Env (dev/prod) + AppConfig — compile-time, app-owned
│   └── env/                  # dart-define-from-file configs: dev.json, prod.json
├── packages/
│   ├── blockmancer_engine/ # The game rules (BlockmancerEngine implements GameRules) — pure Dart, deterministic; injected, never imported by a feature
│   ├── shared_domain/    # Entities shared across features (the game's RunState/GameEvent/…) + contracts (GameRules) — pure Dart, no logic
│   ├── utilities/        # Horizontal infrastructure — no feature knowledge
│   │   ├── ads/              # AdMob and Google's consent form (UMP) behind `Consent` (gather, privacy options) and `RewardedAds` — the only place google_mobile_ads is known
│   │   ├── app_info/         # The app's version and the device it runs on (`readAppInfo()`, never throws) — the only place package_info_plus and device_info_plus are known
│   │   ├── external_links/   # Hands a link or text to the OS (browser, mail draft, share sheet) — the only place url_launcher and share_plus are known; Settings uses `composeEmail` and `shareText`
│   │   ├── leaderboards/     # Game Center and Play Games behind `Leaderboards` (`signIn`, `submit`, `show`) — the only place games_services is known; `NoLeaderboards` while a platform's ids are placeholders
│   │   ├── play_stats/       # The testers' numbers: `LocalPlayStats` implements shared_domain's `AnalyticsSink`, counting per day on the device, and exports a JSON summary
│   │   ├── purchases/        # The stores' in-app purchases behind `Purchases` (buy, restore, price, updates) — the only place in_app_purchase is known, so RevenueCat could replace it
│   │   ├── push/             # FCM + local notifications behind PushMessaging, and the daily reminder behind DailyReminder — the only place firebase_messaging, flutter_local_notifications, timezone and flutter_timezone are known
│   │   ├── remote_config/    # Values published from Firebase Remote Config, read as text behind `RemoteValues` — the only place firebase_remote_config is known
│   │   ├── sounds/           # The game's sound effects, decoded into memory up front behind GameSounds — the only place flutter_soloud is known
│   │   ├── telemetry/        # Firebase Analytics + Crashlytics behind one switch, and the game's events as Analytics events (`FirebaseAnalyticsSink`) — the only place either is known
│   │   ├── timber/           # Logging facade — static Timber over pluggable Tree sinks
│   │   └── webviews/{domain,presentation}/  # webviews_domain / webviews_presentation — the only place flutter_inappwebview is known; unused yet
│   ├── dsm/              # Design-system module
│   │   ├── design_system/    # Tokens (theme, colors incl. the game board's DSGameColor, spacing), buttons, text fields, icons, containers; bundled fonts (DM Sans, Fredoka) — `DSFont.useBundledFonts()` at boot, never downloaded
│   │   ├── assets/           # Bundled images + FlutterGen type-safe Assets accessor (webp bundled, PNG master under source/)
│   │   └── l10n/             # Localization packages
│   │       └── application/      # l10n_application — slang-generated translations (en, fr) + reactive context.t
│   ├── composition/      # Composition root — imports feature packages so the app doesn't
│   │   ├── app_router/       # app_router — app root router + concrete feature routing impls
│   │   └── app_providers/    # app_providers — aggregates cross-feature provider overrides
│   ├── plugins/          # Dev tooling packages
│   │   └── custom_lints/     # Native analyzer-plugin — alphabetical-ordering lints + quick-fixes (IDE-only)
│   └── features/         # Feature packages, split by layer
│       ├── app_update/{domain,data,presentation}/ # app_update_* — whether this version must or may be updated (Remote Config's minimum and latest versions, pub_semver), the banner closed per version on the device, and the blocking update screen
│       ├── game/{domain,data,presentation}/      # game_* — the run's mode, seed, best scores and saved run (domain), kept on the device with its clock (data), and the board, tray and joker picks, pushed over the shell (presentation); rules injected via GameRules
│       ├── home/presentation/                    # home_presentation — the first tab: the world map under today's Daily run, Practice and the Spellbook in the header (worlds, jokers, progression and bests read through slots)
│       ├── push_notifications/{domain,data,presentation}/ # push_notifications_* — the permission ask, token sync, where a tapped push leads, and the week of daily reminders: planned (domain), their log on the device (data), their words (presentation); no screens
│       ├── shop/{domain,data}/                  # shop_* — the Remove ads purchase: bought, restored, kept on the device and re-checked with the store at launch (no screens: Settings shows its rows through slots)
│       ├── settings/{domain,data,presentation}/  # settings_* — sound, haptics, reduce motion, language and the tutorial flag (domain), on the device (data), and the Settings screen, pushed over the shell from Home's gear (presentation); resetting progress goes through a slot
│       └── splash/presentation/                  # splash_presentation — app entry: the branded wait, then the hand-off
├── app/flutter_native_splash.yaml  # Native launch-screen config (brand colour) — `cd app && dart run flutter_native_splash:create`
└── pubspec.yaml          # Workspace root + Melos config (scripts live here under melos:)
```

## Common Commands

```bash
# Scaffold a new package — auto-discovered via the workspace globs (no manual registration).
# --type feature creates packages/features/<name>/{domain,data,presentation} (three <name>_<layer> packages);
# other types create a single flat package under packages/<name>.
melos run create -- --name <name> --type <feature|core|shared_domain|design_system>

# Bootstrap workspace, link local packages, then run code generation
melos run prepare

# Run code generation only — two steps: slang localization (CLI) then build_runner
# (freezed, json_serializable, auto_route, riverpod). Steps also runnable alone:
#   melos run generate-i18n           # slang CLI → strings.g.dart (packages depending on slang)
#   melos run generate-build-runner   # build_runner (packages depending on build_runner)
melos run generate

# Run tests across all packages in parallel — `dart test` for pure-Dart packages
# (blockmancer_engine), `flutter test` for the rest (scripts/test_package.sh)
melos run test

# Run the engine's suite compiled to JavaScript in Chrome (the PRNG must match the VM)
melos run test-engine-web

# Play 2,000 seeded runs for each reference build (the baselines `random` and `empty`, then each
# of the pairs) with the greedy balance bot, and print the share of runs clearing each round,
# the 50th and 80th percentile totals (nearest rank), the boss win rate (over every run, over the
# runs that cleared round 4, and over the runs that completed their pair), the jokers a run ends
# with on average, the share of runs that completed their pair and their P80 total. `--solo` adds
# a row per joker played alone (docs/balance/<date>.md holds each table, docs/balance-v0.md the
# first, docs/balance/2026-10-18-sprint5.md the Sprint 5 tuning and the ★3 thresholds). It plays
# `configFor(world, jokerPool: JokerId.values)` — every joker on offer — in Rubble unless
# `--world` names another world (gravity, fog, tide, mirror). Melos passes no arguments through, so for
# `--runs` / `--build` / `--world` run it from the package:
#   cd packages/blockmancer_engine && dart run tool/balance_bot.dart --runs 2000 --build patience,twin --world gravity
#   cd packages/blockmancer_engine && dart run tool/balance_bot.dart --runs 2000 --build random --solo
melos run balance-bot

# Run dart analyze across all packages
melos run analyze

# Regenerate the native launch screens after editing flutter_native_splash.yaml
# (re-set the iOS storyboard backgroundColor to the brand colour afterwards — see Splash & Launch Screen)
dart run flutter_native_splash:create

# Run the app with an environment (wraps --dart-define-from-file); only ENV is set
melos run flavor-dev            # dev — no telemetry
melos run flavor-prod           # production — telemetry on in release mode

# Run the app with no environment configured — a dev build
flutter run

# Release the iOS app against production (scripts/build_ios_release.sh):
# an obfuscated .ipa. Cleans first — the shipped artefact is built from nothing
# rather than from whatever debug runs left behind, which is the one place a
# clean is warranted. The clean takes the workspace's resolved packages with it,
# so the script runs `flutter pub get` from the root before building. Dart
# symbols go to build/debug-info/ios/<version> and are uploaded to Crashlytics
# like Android's; the dSYMs are uploaded separately, by the Runner target's
# "Upload Crashlytics symbols" build phase. Requires macOS + Xcode.
melos run build-ios

# Release the Android app against production (scripts/build_android_release.sh):
# an obfuscated .aab for the Play Console, cleaned first like build-ios. Dart
# symbols go to build/debug-info/android/<version> (outside app/, so the clean
# keeps them) and are uploaded to Crashlytics — keep each shipped version's.
# Needs app/android/key.properties (the upload key; without it Gradle signs
# with the debug key, which Play refuses).
melos run build-android

# Test builds of the same two (TestFlight, Play internal testing): TEST_TOOLS on
# (Settings' Share test stats and Test crash, Google's test ad units, Remote
# Config fetched every 5 minutes). The release scripts refuse to build while
# app/env/prod.json, the one file of every store, AdMob and leaderboard id
# (Dart's through dart-defines, the native ones read by Gradle and an Xcode
# build phase), still holds a PLACEHOLDER_ (scripts/check_release_ids.sh); a
# test build only warns.
melos run build-ios-test
melos run build-android-test

# Regenerate the Remote Config template and its key table from the code's
# defaults (docs/remote-config/; a test fails until this is re-run)
cd packages/composition/app_providers && dart run tool/remote_config_template.dart

# Build
flutter build apk    # Android APK
flutter build ios    # iOS (requires macOS + Xcode)
flutter build web    # Web
```

## Git Commit Convention

All commits must be prefixed with `claude:` and follow the conventional commit format:

```
claude: <type>(<scope>): <description>
```

Types: `feat`, `fix`, `chore`, `refactor`, `docs`, `test`, `style`, `perf`

Examples:
- `claude: feat(game): add the score banner`
- `claude: fix(engine): check the win before the tray refills`

## Architecture

- **Monorepo:** Dart Pub Workspace — each package has `resolution: workspace`; root `pubspec.yaml` discovers members via globs under `workspace:` (`app`, `packages/*`, `packages/dsm/*`, `packages/dsm/l10n/*`, `packages/composition/*`, `packages/plugins/*`, `packages/utilities/*`, `packages/utilities/**/*`, `packages/features/**/*`). New packages are picked up automatically — no manual registration. The two utilities globs coexist because most utilities are flat (`push`, `telemetry`) while a layer-split one (`webviews/{domain,presentation}`) sits a level deeper; `**/*` needs two segments, so it matches only the deeper ones and the flat glob's hit on the bare `webviews/` directory is ignored, exactly as `packages/dsm/*` already ignores `l10n/`.
- **Dependency overrides:** the root `pubspec.yaml` pins `analyzer: 10.2.0` (plus `dart_style: 3.1.7`, `riverpod_analyzer_utils: 1.0.0-dev.10`) via `dependency_overrides` so the `custom_lints` analyzer-plugin can coexist with `riverpod_generator`'s conservative `analyzer ^9.0.0` cap. Mirrors flutter-front.
- **Feature layering:** each feature is split into layer packages `<feature>_domain`, `<feature>_data`, `<feature>_presentation` under `packages/features/<feature>/`. Layer boundaries are enforced at compile time by each package's declared deps. Layers a feature doesn't need are simply absent — `home` has only `_presentation`.
- **Composition layer:** `packages/composition/` holds the composition root — `app_router` (app root router `AppRouter` aggregating feature routes, plus the concrete `<Feature>RoutingImpl` classes and `routingOverrides()`) and `app_providers` (`appOverrides()` aggregating the routing binds for the app's root container). The composition packages import the feature packages; the `app` depends only on composition, so it imports no feature package. Dependency direction: `app → composition → features`.
- **Package internals:** the public API of every package is its barrel `lib/<pkg>.dart`; all implementation lives under `lib/src/`. Each package carries `lib/src/package_name.dart` (`const packageName = '<pkg>';`). Providers follow [providers](.claude/rules/providers.md): `providers.br.dart` holds this package's own `@riverpod` providers **and** its `bindProviders(...)` helper, `providers_di.br.dart` holds inbound slots that throw until overridden, and `providers_internal.br.dart` holds layer-internal ones. Never both `providers.br.dart` and `providers.dart` in one package.
- **Melos v7+:** Scripts defined in `pubspec.yaml` under `melos:` key — no separate `melos.yaml` file
- **Workspace deps:** Intra-package dependencies declared as `package_name: any` — no `path:` overrides needed
- **Centralized versions:** the root `pubspec.yaml` is the single source of dependency versions, declared under Melos `command.bootstrap`. `dart run melos bootstrap` stamps each version into the packages (external deps carry the version; internal/workspace deps stay `any`). Never hand-manage a package-level version. See `.claude/rules/dependencies.md`.
- **Layers:** presentation → domain ← data (dependencies flow inward only; `<feature>_data` and `<feature>_presentation` depend on `<feature>_domain`; `<feature>_presentation` also depends on `design_system`)
- **State management:** Riverpod with `@riverpod` codegen — presentation notifiers are `@riverpod class <Name>Notifier extends _$<Name>Notifier`, one per screen under `notifiers/`
- **Code generation:** `@riverpod` (providers), auto_route (route classes), freezed (immutable models), json_serializable (DTOs) — all via build_runner. Generated files use `.g.dart` (riverpod) and `.gr.dart` (auto_route) suffixes. **slang localization is the exception** — generated by the `dart run slang` **CLI**, not build_runner (its build_runner integration writes in a post-process phase that runs *after* riverpod, so a same-package `@riverpod` provider could never see slang's types). `melos run generate` runs slang first (`generate-i18n`) then build_runner (`generate-build-runner`).
- **File naming:** Source files use `.br.dart` suffix (e.g. `game_notifier.br.dart`); generated files use `.br.g.dart` or `.br.gr.dart`
- **Linting:** `analysis_options.yaml` extends `package:flutter_lints/flutter.yaml` and registers the `packages/plugins/custom_lints` analyzer-plugin (alphabetical-ordering rules + quick-fixes). That native plugin runs in the **IDE / single-file analysis only** — `dart analyze <dir>` (`melos run analyze`, pr-check) does not load it, so it's editor assistance, not a CI gate; the `app` package opts out via a local `analysis_options.yaml` (the plugin crashes `dart analyze` there).
- **Android:** Namespace `com.elietabet.blockmancer` (same as the iOS bundle id and the Android applicationId — the ids the Firebase project knows the app by; the generator rewrites all three), Java 17 / Kotlin JVM 17 (`app/android/app/build.gradle.kts`)

## Presentation Layer Pattern

The `<feature>_presentation` package exposes only its barrel `lib/<feature>_presentation.dart`; everything else lives under `lib/src/`, split by responsibility — `routing/` (router + routing interface), `notifiers/` (presentation notifiers), and `widgets/` (screen UI):

```
packages/features/<feature>/presentation/lib/
├── <feature>_presentation.dart           # barrel — exports src/routing/<feature>_router.br.dart, src/routing/<feature>_routing.dart, src/providers.dart
└── src/
    ├── package_name.dart                  # const packageName = '<feature>_presentation'
    ├── providers.dart                  # bindRoutingProviders({required <Feature>Routing Function(Ref) ...}) → List<Override>
    ├── providers_di.br.dart               # @riverpod <feature>Routing slot — throws until the composition layer overrides it
    ├── providers_internal.br.dart         # layer-internal providers
    ├── routing/
    │   ├── <feature>_router.br.dart       # @AutoRouterConfig() abstract RootStackRouter (empty codegen anchor — routes composed by AppRouter, not here) + @RoutePage <Name>Page (wraps the screen) + enum <Feature>RoutePath (path segments)
    │   ├── <feature>_router.br.gr.dart    # Generated: route classes (e.g. GameRoute)
    │   └── <feature>_routing.dart         # abstract interface class <Feature>Routing — on<Action>Requested(BuildContext)
    ├── notifiers/
    │   ├── <name>_notifier.br.dart        # @riverpod <Name>Notifier — owns navigation; passes BuildContext to the routing interface
    │   └── <name>_notifier.br.g.dart      # Generated: <name>Provider (riverpod_generator strips the Notifier suffix)
    └── widgets/
        └── <name>_widget.dart             # ConsumerWidget — class <Name>Widget — the screen UI (no @RoutePage)
```

The `@RoutePage` page class lives in the **router** file and is a thin wrapper that returns the screen widget — the widget itself carries no routing annotation. Intra-package imports reference `package:<feature>_presentation/src/...`; external packages import only the barrel.

Example (`game`, in `packages/features/game/presentation/lib/src/`):
- `routing/game_router.br.dart` — `@AutoRouterConfig() abstract class GameRouter extends RootStackRouter {}` (an empty codegen anchor — auto_route generates the `GameRoute` from the `@RoutePage`; the actual route table is declared once by `AppRouter` in the composition layer, never per feature), **plus** `@RoutePage(name: 'GameRoute') final class GamePage extends StatelessWidget` whose `build` scopes the `GameLaunch` it was pushed with (`gameLaunchProvider`) over `const GameWidget()`, **plus** `enum GameRoutePath { game('/game') }` (absolute, because the game is pushed over the shell; a tab child's path is relative, as `home`'s is)
- `routing/game_routing.dart` — `GameRouting.onLeaveRequested(context)`, back to the menu; `app_router`'s `GameRoutingImpl` pops
- `notifiers/game_notifier.br.dart` — `@riverpod class GameNotifier extends _$GameNotifier`
- `widgets/game_widget.dart` — the screen UI

## Routing

There is no central navigation interface. Each feature owns its own routing contract; the composition layer (`app_router`) supplies the concrete implementation. Three pieces per feature:

1. **Routing interface** — `<feature>_presentation/lib/src/routing/<feature>_routing.dart`. Methods are named by behavioural action and take a `BuildContext` (the impl navigates relative to it — future-proofs for nested shell routers):

```dart
abstract interface class SplashRouting {
  void onInitialized(BuildContext context);
}
```

2. **DI slot** — `providers_di.br.dart` declares a `@riverpod` provider that throws until overridden; `providers.dart` exposes a `bindRoutingProviders(...)` helper returning the `Override`:

```dart
// providers_di.br.dart
@riverpod
SplashRouting splashRouting(Ref ref) =>
    throw UnimplementedError('overridden by the composition layer (app_router)');

// providers.dart
List<Override> bindRoutingProviders({required SplashRouting Function(Ref ref) splashRouting}) =>
    [splashRoutingProvider.overrideWith(splashRouting)];
```

3. **Implementation** — lives in `app_router`, navigates via `AutoRouter.of(context)` against the concrete route classes:

```dart
// packages/composition/app_router/lib/src/routing/splash_routing.dart
final class SplashRoutingImpl implements SplashRouting {
  const SplashRoutingImpl();
  @override
  void onInitialized(BuildContext context) {
    assert(context.mounted, 'onInitialized called with an unmounted context');
    AutoRouter.of(context).replaceAll([const TabShellRoute()]);
  }
}
```

`app_router` also owns the app root router `AppRouter` (`@AutoRouterConfig RootStackRouter implements AutoRouteGuard`, aggregating each feature's `AutoRoute` with its path from the feature's `<Feature>RoutePath` enum, e.g. `AutoRoute(path: SplashRoutePath.splash.path, page: SplashRoute.page, initial: true)`) and exposes `routingOverrides()` — which calls every feature's `bindRoutingProviders(...)` — alongside `featureBindingOverrides()`, the same aggregation for the non-routing slots (the game's rules, best scores and revive reward, the settings' store and progress reset, push, telemetry). `app_providers.appOverrides()` spreads both; the thin `app` applies it at startup:

```dart
// app/lib/application/application.dart — imports composition (+ design_system for the theme,
// l10n_application for localization), no feature package.
// boot():   LocaleSettings.useDeviceLocaleSync();   // resolve initial locale from the device
_container = ProviderContainer(overrides: appOverrides(collectsTelemetry: …, router: _appRouter));
// launch(): wrap once in slang's TranslationProvider (makes context.t reactive), then
//   MaterialApp.router applies the design system + locale:
//     theme: DSTheme.instance.lightTheme, darkTheme: DSTheme.instance.darkTheme, themeMode: .system,
//     locale: TranslationProvider.of(context).flutterLocale,
//     supportedLocales: AppLocaleUtils.supportedLocales,
//     localizationsDelegates: GlobalMaterialLocalizations.delegates, routerConfig: _appRouter.config()
```

**The notifier owns navigation** (Model A): the widget hands its `BuildContext` to a notifier method, which forwards it to the routing interface. The notifier never *uses* `BuildContext` for anything except passing it straight to the routing interface:

```dart
// splash_state_notifier.br.dart
Future<void> onReady(BuildContext context) async { ...; routing.onInitialized(context); }
// splash_widget.dart
WidgetsBinding.instance.addPostFrameCallback((_) => notifier.onReady(context));
```

## Localization

Localization is a standalone foundational package `l10n_application` (`packages/dsm/l10n/application/`), depended on by the `app` and by feature `*_presentation` packages (never by a feature's domain/data). It uses **slang** — type-safe, code-generated translations — chosen over the built-in `gen-l10n` for its codegen/type-safety fit (a deliberate divergence from flutter-front, which uses `.arb`).

- **Translation sources:** `lib/i18n/<locale>.i18n.json` — `en.i18n.json` (base) and `fr.i18n.json`. Add a key to every locale file; add a locale by adding a new `<locale>.i18n.json`.
- **Generation is via the slang CLI, not build_runner** (`dart run slang`, config in `slang.yaml` with `lazy: false`). Output is `lib/i18n/strings.g.dart` (+ per-locale parts), a **committed source file**. This is deliberate: slang's build_runner builder writes in a post-process phase that runs after riverpod, so a same-package `@riverpod` provider depending on slang's types could never resolve them in one pass. `melos run generate` runs `generate-i18n` (slang) before `generate-build-runner`. The package therefore declares only `slang` + `slang_flutter` (no build_runner / riverpod).
- **Reactive access via `context.t`:** the app is wrapped once in slang's `TranslationProvider` (an `InheritedWidget`); widgets then read strings with the generated `context.t` extension — `Text(context.t.game.title)` — and rebuild automatically when the locale changes. This is slang's native reactivity; there is **no** Riverpod provider wrapping translations.
- **Locale lifecycle:** the initial locale is resolved from the device in `boot()` via `LocaleSettings.useDeviceLocaleSync()`. `MaterialApp.router` sets `locale: TranslationProvider.of(context).flutterLocale`, `supportedLocales: AppLocaleUtils.supportedLocales`, and `localizationsDelegates: GlobalMaterialLocalizations.delegates` (from `flutter_localizations`). Switch at runtime with `LocaleSettings.setLocaleSync(AppLocale.fr)` — every `context.t` rebuilds. The player's choice is Settings' (see [Settings](#settings)): applied at boot by `applyStoredLanguage`, and on change by the Settings screen.
- **Central versions:** `slang` and `slang_flutter` live in the root `melos.command.bootstrap` like every other dependency.

## Game engine

`packages/blockmancer_engine` holds every game rule: pieces, scoring, jokers and the run state
machine. The rules are specified in `.claude/doc/BLOCKMANCER_BRIEF.md`. The UI animates the
engine's events and never recomputes a rule.

- **Injected, never imported.** The game's vocabulary (`RunState`, `RunPhase`, `RunConfig`,
  `Board`, `Cell`, `GameEvent`, `JokerId`, `PlacementPreview`, …) and the `GameRules` contract live
  in `shared_domain`. The engine's barrel exports only `BlockmancerEngine implements GameRules`;
  `game_domain` declares a throwing `gameRulesProvider` slot and `app_providers` binds it to
  `const BlockmancerEngine()`. Rule data and rule decisions stay behind the contract (`defaultConfig`,
  `shape(id)`, `partnerOf(id)`, `canRevive`, `liveRunTotal`), so no feature computes a rule and
  `shared_domain`'s entities only read their own fields.
- **Jokers and worlds.** 26 jokers in 13 pairs in `jokerCatalog` (hook and draw order; new ones
  are appended, so a pool without them draws exactly as before — Anchor and Avalanche, Gravity's,
  then the stars' Full House, On the Brink, Finisher and Hat Trick, then Fog's Lantern and Ember
  Tide's Sprinter and Momentum, and Mirror's Symmetry and Prism come last). Offers draw only from `RunConfig.jokerPool` minus owned, in catalog order whatever the
  pool's list order, and the pair bias only proposes a partner in the pool; `defaultConfig`'s pool
  is every joker, as the daily run's is. The map is rule data behind the contract too:
  `configFor(world, jokerPool:)`, `worldOrder`, `nextWorld`, `isPlayable` (every world today),
  `kindOf(id)` (what a joker does to a score, which the Spellbook frames it by),
  `unlocksOf(world)` and `startingJokers` (every joker neither a world nor the stars unlock: 12).
- **What a joker reads.** Each hook gets a `MoveContext`: the clear, the piece's size, the streak,
  Patience's bank, `occupiedAfterPlacing` (filled cells and stones once the piece has landed, before
  its lines clear: Full House and On the Brink), `trayEmptied` (the move played the tray's last
  piece: Finisher) and `trayClearMask`. `RunState.trayClearMask` has a bit per tray slot whose piece
  cleared, reset by every refill to `0` for a tray dealt in full and to `null` for a short one,
  which can never earn Hat Trick. A revive sets the tray in play, if any, to `null`; a tray dealt
  later counts like any other, whichever pieces it holds.
- **`shared_domain` is pure Dart** because the engine depends on it and must run on the plain VM
  and the web.
- **Pure Dart.** Its pubspec declares no Flutter, so a `package:flutter` import fails
  `melos run analyze` (`depend_on_referenced_packages` under `--fatal-infos`). The brief's
  `import_lint` isn't used because no version resolves against the pinned analyzer 10.2.0.
- **Deterministic.** No `DateTime.now()`, no `dart:math` `Random`, no I/O. Randomness is the
  engine's own mulberry32 over 32-bit arithmetic, so a seed gives the same run on the VM and on the
  web. Callers pass the date in for a daily seed: `game_domain` reads it from its injected `Clock`
  (`SystemClock` in `game_data`; never `DateTime.now()` elsewhere), keys the daily run by the UTC
  day and asks the rules for that day's seed (`DailyRunBehavior`, internal to `game_domain`).
- **Replayable.** A run is its seed and its moves: `GameRules.replay({config, moves, seed})` folds a
  list of `shared_domain`'s `RunMove`s (`pick`, `place`, `revive`, `end`) back into the final
  `RunState`, refusing any move the run couldn't have made. This is what a server will check a score
  with.
- **Joker texts read the config.** Every number a joker's description shows comes from the
  `RunConfig` it is shown for (`JokerTuning`, and `traySize` for Hat Trick): the run's own in a run,
  the rules' `defaultConfig` in the Spellbook and on the map. No l10n string holds a joker number.
- **Tunable.** Every number a designer would tune lives in the immutable `RunConfig`, whose values
  are `defaultConfig`: the rounds' targets, pieces and stones, chips per cleared cell, revives, offers,
  each joker's numbers (`JokerTuning`, which every joker hook is handed), `starThreshold`, the
  run total that earns a world's third star (10,500 in every world but Tide's 9,500: the bot's P80
  with its best pair over the runs that completed it, rounded down to 250, in
  docs/balance/2026-10-18-sprint7.md, which also holds each world's boss target, lower along the
  map's harder rules, and why every number moved), and `starUnlocks`, the jokers the
  stars held across worlds unlock (4★ Full House and On the Brink, 6★ Finisher and Hat Trick).
  No rule reads either of the last two; the run's end does. No
  rule hard-codes one, so editing `defaultConfig` changes the bot's table with no other edit: the
  rule tests read the test-only `briefConfig`, the brief's numbers, and the seeded goldens too. This
  is what Remote Config will feed.
- **Worlds.** `RunConfig.world` (`WorldId`) picks a `WorldRule` (`lib/src/worlds/`) that holds in the
  boss only. Its hooks: `onRoundSetup` (Rubble's stones, from `RoundSpec.stones`),
  `transformPlacement`, the cells a piece dropped on really fills (Gravity's fall; `transformAnchor`
  is its top-left), and `onTrayDealt`, run before each tray is dealt, told whether a move played
  the last one out (not for a round's first tray or a revive's), which may lose the round (no tray is dealt then, and the round stays lost).
  `canPlace`, `preview`, `place`, `fitsSomewhere` and the round's "no room" all go through
  `transformPlacement`, and `PiecePlaced` carries the landing cells; a `RunMove.place` keeps the
  drop point, so replay re-applies the rule. Two more hooks serve Fog: `onBoardSetup`, the board
  a round starts on once its stones are down (drawing from the stones stream), and
  `afterPlacement`, the board once a move has scored and cleared. `previewPlacement` is where
  the preview shows a piece going whether or not it fits (Mirror shows the mirrored cells, red
  where they collide).
- **Fog.** The boss starts with `RoundSpec.fog` fog cells (8) on empty cells from the stones
  stream, the first `fogStones` (3) hiding a stone (`FogPlaced`). A move is: place, score and
  clear, the jokers' removals beside the lines (Lantern, through `JokerEffect.extendClear`, which
  adds no chips), then every fog cell sharing a side with a cell of the placed piece lifts, to
  empty or to the stone it hid (`FogRevealed`). Ember adds `emberMult` (3) on a clear, or multiplies
  by `emberFactor` (2) instead when `ClearResult.obstaclesCleared` counts any: the stones and fog
  the move took off, in its lines or beside them. The bot's tie-break counts a
  fog cell that turned to stone as empty, so what fog hides never steers it.
- **Tide.** `TideRule.onTrayDealt`: before every tray a move empties in the boss, every cell moves
  up a row and a stone row enters at the bottom, empty in `RoundSpec.tideGaps` (2) columns drawn
  from the stones stream (`TideRose`); a line the rise completes clears at once, scoring nothing
  and leaving the streak as it was (`LinesCleared` with `source: .tide`); a filled cell, stone or
  fog pushed off the top loses the round (`LossReason.flooded`), and no tray is dealt. The tray a
  revive deals never rises, as the boss's first doesn't, so a revive can't flood again at once.
  Sprinter reads `MoveContext.firstOfTray` (the move played a tray's first piece, from
  `RunState.trayDealt`); Momentum reads `momentumStreak`, the trays in a row whose first piece
  cleared, set as each tray's first piece is played (0 for the rest of a tray whose first missed,
  and at every round's start). The game shows "Tide in N" (pieces left in the tray) during the
  boss, tints the top row while the next rise would flood it, and slides the board up a row as
  the tide rises (its other beats play with the cells where they stood before the rise, and a line
  the rise completed bursts once it has risen; under reduce motion it is simply there). A flood ends the boss early, so Tide's
  boss target is the map's lowest.
- **Mirror.** `MirrorRule.transformPlacement` lands each cell `(row, col)` of the piece on
  `(row, 7 - col)`, place and shape mirrored; `canPlace`, `preview` and `place` work on those
  landing cells. Symmetry (+mult) and Prism (+chips per cell whose mirror cell matches) read the
  board after the clear, filled cells and stones alike, never fog (any fog makes the board not
  symmetric). The game draws a line down the board's middle during the boss and, while dragging,
  outlines the cells under the finger (`DragPreview.held`) beside the shadow on the landing
  cells.
  Tests swap in a fake rule through `worldRuleLookup`.
- **Fog cells.** `CellState.fog(hidesStone:)` blocks a piece and counts as occupied, for lines
  and for Full House and On the Brink, like a stone. A cleared line takes its fog with it, and
  whatever it hid; a hidden stone isn't counted as cleared. What fog hides is the engine's alone:
  `preview`, the UI and the bot never read `hidesStone`.
- **Tutorial.** `GameRules.tutorialRun` is a fixed run already in play: no joker, a bottom row one
  cell short, a single in the tray, and a round that can't be won.
- **Balance bot.** `tool/balance_bot.dart` plays seeded runs with `lib/src/bot/`'s greedy policy
  (the best immediate score) across one isolate per core, every joker on offer. Its picks are a
  `BotBuild`: a pair, or a solo joker, takes its jokers whenever offered, else any offer, each as
  likely, drawn from the run's seed (never the first: the partner bias puts an owned joker's
  partner there three times in four); `random` always takes any offer; `empty` skips every pick, playing from an empty pool,
  which `startRun` starts straight into round 1. In Tide's boss its tie-break scans from the bottom
  row up and ranks a flooding move last, so it doesn't stack pieces where the rise floods them (it
  still never looks ahead to the rise). It depends only on
  the engine, and `lib/src/bot/` uses no `dart:io` or isolates, so it stays web-safe.
- **Tests** use `package:test` rather than `flutter_test`, and run on the VM (`melos run test`) and
  in Chrome (`melos run test-engine-web`).

## Saving and resuming

One run is saved on the device, so a killed app picks it up where it stood.

- **When:** `GameNotifier` saves after every action (placing, picking, reviving, ending), and
  `GameWidget`'s `AppLifecycleListener` saves on pause. A won or ended run clears the save instead
  (`game_domain`'s `SaveRunBehavior`), so it is never offered again. A new run is not saved until its
  first action: opening one by mistake and backing out leaves the saved run standing. Writes land in
  the order they were made, so a slow save can't land after the clear that followed it.
- **Where:** `game_data`'s `SharedPreferencesRunStore`, one JSON string under `run.saved`, written
  through json_serializable DTOs (`saved_run_dto.br.dart`) so `shared_domain`'s entities carry no
  wire format. The schema has `version: 11`; `migrate(json)` brings an older version up to date one
  step at a time, each step filling what that build played with (1 → 2 the chips per cell and
  joker numbers, 2 → 3 the Rubble world, 3 → 4 the 14-joker pool and the two new jokers' numbers, 4 → 5 the world's ★3 threshold, 5 → 6 nothing: world runs name their world, and no older save is one, 6 → 7 the stars' jokers' numbers and unlocks, and a tray that can't earn Hat Trick, 7 → 8 Avalanche's two rows and Full House's +1 mult, constants until then, 8 → 9 fog cells (codes -2, and -3 hiding a stone), the Fog and Tide bosses' counts (`RoundSpec.fog`, `fogStones`, `tideGaps`, 0 for an older save), the tray's `trayDealt` and `momentumStreak`, and the first numbers of Fog's, Tide's and Mirror's jokers; the saved pool is kept, so an old run never offers a new joker, 9 → 10 Ember's mult on every clear, 0 for an older save, 10 → 11 the Spellbook's mastery tiers, 1/5/15 as literals), and a
  save that can't be read (corrupt, unknown version, a joker this build lacks) is treated as no
  save.
- **Resume:** Home shows Continue run while `hasSavedRun` is true, and it pushes
  `GameRoute(launch: .resume)`. `GamePage` loads the save **once** (`loadSavedRun`), before the game
  starts, and scopes it in as `resumedRunProvider`. If the save can't be loaded it plays today's
  daily, which saves nothing until the player acts. Reading it from a provider instead would reload it after
  every move, because each save refreshes `hasSavedRun`, and the reload would restart the game.

## Progression and the profile

What a player has earned across runs is one `Progression` (`shared_domain`): per world
`{unlocked, bossBeaten, stars}`, the jokers runs may offer, `jokerStats` (per joker ever picked:
`timesPicked`, `runsWon`, `bestRunTotal`), `unannouncedJokers` (unlocked outside a run, waiting
for the map to announce them) and `tutorialDone`.

- **Where:** one JSON profile under `profile` (`game_data`'s `profile_dto.br.dart`), holding the
  bests and the progression; `SharedPreferencesBestScores` and `SharedPreferencesProgressionStore`
  both read and write it, each update a read and a write with no await between, so neither wipes
  the other.
- **Version 8.** A device without a profile is version 1: the `best.*` keys and
  `settings.tutorialSeen`. `migrateProfile` turns that into version 2 on first read (bests kept,
  `tutorialDone` from the flag, the starting progression) and removes the `best.*` keys; version 3
  adds a best per world (`bests.worlds`), empty for older profiles; version 4 adds the joker stats,
  empty for older profiles; version 5 grants the star unlocks a profile already holds the stars
  for (thresholds as literals: 4★ and 6★), into both `unlockedJokers` and `unannouncedJokers`; version 6
  renames the fourth world's entry from `speed`, dropped for Tide before it had rules, to `tide`
  (read as it was, the unknown name would throw the profile away); version 7 adds the boss cards
  seen (`bossCardsSeen`), counting as seen every world whose boss the profile has beaten;
  version 8 adds the jokers the Spellbook has shown (`spellbookSeen`), counting every joker
  already unlocked as seen. An unreadable profile starts fresh and is replaced by the next write.
- **Announced once.** Home's `UnlockAnnouncer` reads `unannouncedJokers` through the
  `progression` slot; when it holds jokers, it calls the `markJokersAnnounced` slot (bound to
  `game_domain`'s, which empties the set and refreshes the progression) before showing
  `JokersUnlockedSheet`, so the sheet shows on the next visit to the map and never again.
- **Starting state:** `game_domain`'s `startingProgression(rules)` (exposed as
  `initialProgressionProvider`): the first world unlocked and `rules.startingJokers` — worked out
  from the rules, so storage never knows them. Settings' reset progress puts it back
  (`ClearProgressBehavior`), alongside the bests and the saved run.
- **Three kinds of run.** `GameMode` is `daily`, `practice` or `world(world)`; a world run is
  pushed as `GameRoute(launch: .world, world: …)`, from its node on the world map. `RunStartForBehavior` (`runStartFor`) gives each its
  `RunConfig`: the **daily** is the first world with **every** joker, whatever the player has
  unlocked, so everyone plays the same run; **practice** is the first world and a **world run**
  its own world, both offering only `unlockedJokers` (in `JokerId` order — the rules draw in their
  own order anyway). A world launch naming a world the rules can't play yet plays the first world
  instead: the map never offers one, so this only keeps a stray launch from crashing in
  `configFor`. The daily's own start (`DailyRunBehavior`) isn't exported, so nothing outside
  `game_domain` can start it for any instant but the `Clock`'s. The tutorial still plays the
  rules' fixed run.
- **Loaded once.** `GamePage` reads the progression once before the game starts (every launch but
  the daily, which doesn't need it), like the saved run, and scopes it in as
  `launchProgressionProvider`; one it can't read plays with a new player's jokers. Play again
  starts from the latest progression the screen knows — each `ProgressionChange` carries the
  `progression` it left — so the jokers an unlock sheet just announced are in the next run's pool.
  A resumed run keeps the config it was saved with.
- **What a run earns.** At every run's end but the tutorial's, `GameNotifier` calls
  `recordProgression` (`RecordProgressionBehavior`, keepAlive, then refreshes
  `progressionProvider`). Every run counts in the stats of each joker it owned: its win and its
  total (the best counts with the boss beaten or not); a run abandoned before its end counts
  neither. Picks are counted as they are made instead (`recordPick`, called by
  `GameNotifier.pickJoker` outside the tutorial), the starting pick included, so an abandoned
  run's picks count. The rest is a world run's alone. The first win
  over the world's boss marks it beaten, adds `rules.unlocksOf(world)` to `unlockedJokers` and
  unlocks the next world **if the rules can play it** (`isPlayable`): a coming-soon world stays
  locked. When a later release gives that world rules, `game_domain` reads (and so writes) every
  progression through `EarnedWorldsStore`, which opens each playable world after a beaten boss:
  a player who beat Gravity while Fog was coming soon finds Fog open, with no celebration. A
  second win unlocks nothing. Stars: ★1 the boss beaten, ★2
  beaten with `revivesUsed == 0`, ★3 a run total of at least `config.starThreshold` — independent
  of the boss. Nothing is ever taken back (each star ORed into what was earned). Stars held
  across every world unlock `config.starUnlocks` (4★ Full House and On the Brink, 6★ Finisher and
  Hat Trick): each joker once, at the end of the first world run that finds its count reached —
  the run that crosses it, or for a player already past it, their next world run — and announced
  by the same sheet as a boss's jokers, after them when both come at once. It returns a
  `ProgressionChange` (`newStars`, `progression`, `stars`, `unlockedWorld`, `unlockedJokers`)
  kept as `GameUiState.progress`.
  **Daily and practice runs never touch the map, only the jokers' stats**: the daily is
  everyone's competition and practice is free play. `recordProgression` answers `null` for them.
- **The celebration.** The run's end waits for what it earned: the move that ends a run sets
  `GameUiState.progressPending`, and `PhaseOverlay` shows nothing until `recordProgression`
  answers — so the run end can't flash first, nor Play again discard the unlock. A write that
  fails also ends the wait (logged): the end then shows without stars. A run that unlocked
  something shows `UnlockSheet` first — "New world: …" (or "New jokers" when no world opened)
  and the unlocked jokers' cards (`JokerCard`, the offer card's look), flipping in one after
  another once the sheet is up (at once under reduce motion, skipped by a tap) — and its Continue
  (`closeUnlocks`) hands over to the run's end, so Play again stays the last thing on screen.
  `RunEndSheet` then shows the world's three stars (`RunStars`), each with its objective; the new
  ones in amber, popping in one after the other, still under reduce motion. A daily or practice
  end shows no stars.

### World map

Home is the map: today's Daily card on top (its UTC day, today's best, the streak, Play, and
Leaderboard), Continue when a run
is saved, then the worlds down a winding trail, the first at the top. Practice is the pill in the
header, beside the gear.

- **What it reads.** `game_domain`'s `worldSummaries` fills home's `worlds` slot: a
  `WorldSummary` (`shared_domain`) per world in `worldOrder`, with `playable`, its boss's target,
  its ★3 threshold, its unlocks and the `JokerTuning` that describes them (the rules'
  `defaultConfig`), read from the rules (0 for a world that isn't playable).
  `progressionProvider.future` fills `progression`, and `todaysDailyDate` (the UTC day the daily
  is keyed by) fills `dailyDate`.
- **A node** (`worldNodeProvider`, home): coming soon when not `playable`, locked until
  `unlocked`, done once `bossBeaten`, current otherwise. "You are here" sits over the furthest
  playable world open (`hereWorld`), and the trail is amber up to it.
- **Fresh on return.** `recordProgression` invalidates `progressionProvider` at a run's end, and
  Home's slot watches its future, so the map has changed by the time the run is left
  (`app_router`'s `world_map_test`).
- **The sheet.** Tapping any node opens its `WorldSheet` (`showWorldSheet`, a modal bottom sheet
  in the game's palette): status (Done / In progress / Locked / Coming soon), the boss rule in a
  sentence, the boss's target, the three star objectives with what is earned, and the jokers the
  boss unlocks as joker cards (named and described by home's own `joker_text.dart`, with the
  summary's tuning; "Unlocked" once `unlockedJokers` holds them). An open world gets Start run,
  or Replay for the missing star once its boss is beaten with a star still to earn; a locked one
  says "Beat the previous boss to unlock"; a coming-soon one shows only its name. The sheet pops
  `true` on play, and the node then calls `HomeNotifier.openWorld`, which pushes
  `GameRoute(launch: .world, world: …)`: the widget shows the sheet, as Settings' rows show
  their popups, because a notifier only hands its `BuildContext` to routing.
- **Smooth.** The trail is one `CustomPainter` behind a `RepaintBoundary`, repainted only when the
  player gets further; each node watches its own world. The pin's bob is the only per-frame work
  at rest, in its own layer, and it holds still under the phone's or Settings' reduce motion
  (home's `reduceMotionSetting` slot).
- **Celebrations, once per event.** `MapCelebrationDirector` (around the map) keeps the
  progression the map last settled on, in its state, which lives as long as Home: a cold start
  settles on what it reads. When the progression changes, `celebrationBetween` gives the stars
  earned and the world opened since, and `CelebrationPlan` lays them on one timeline — the stars
  one after another, each filling with a burst (`StarBurstPainter`), then the trail's leg drawing
  into the opened world (`TrailPainter.drawn`), then its badge popping from locked to open with
  the pin fading in (about 600 ms). It starts only once the map is on screen again
  (`TickerMode`, plus a beat for the covering route to leave), so a run's end plays it on return;
  until then the pieces taking part hold how they stood. Reduce motion settles at once, a tap on
  the map skips to the end (and opens nothing), and once settled nothing replays, whatever
  rebuilds. Only the trail and the nodes in the celebration animate, each in its own
  `AnimatedBuilder` under `MapCelebrationScope`. A locked or coming-soon node shakes lightly when
  tapped (not under reduce motion), and its sheet still opens.

### Boss cards and the end of the map

- **Boss cards.** The first time a world run reaches a world's boss (any world but the map's
  first, whose rule a new player meets with the tutorial's help), `GameNotifier` puts up that
  world's card (`GameUiState.bossCard`, a `PhaseOverlay` sheet): the rule in a sentence and a
  small loop of it at work (`BossRuleLoop`, still under reduce motion). "Got it" calls
  `game_domain`'s `markBossCardSeen`, which adds the world to `Progression.bossCardsSeen`, so the
  card never shows again (Reset progress shows them again). Every world's sheet replays its card:
  "How the boss plays" calls `HomeRouting.onBossCardRequested`, which `app_router` answers with
  game_presentation's exported `showBossCard`, so the card exists once.
- **The map's end.** `celebrationBetween` sets `completedGame` when the last boss standing falls;
  once the map's celebration has settled, and only with the map on screen, `MapCelebrationDirector`
  shows `WorldCompleteSheet`: every world's boss beaten, the nodes all lit behind it, and the stars
  held out of 15. Like the rest of the celebration, it shows once.
- **A whole campaign** is tested end to end (`app_providers`' `campaign_test`): a new player
  beats each world in order, and each world and each joker pair unlocks exactly once.

### Spellbook

The joker collection as collectible cards, opened from the book in Home's header:
`SpellbookRoute` (`home_presentation`, absolute `/spellbook`) slides up over the shell like
Settings, and its close button pops it (`HomeRouting.onSpellbookRequested` /
`onSpellbookCloseRequested`).

- **What it reads.** `game_domain`'s `jokerCollectionOf(rules)` fills home's `jokerCollection`
  slot: a `JokerCollection` (`shared_domain`) of the 13 `JokerPair`s with their `JokerUnlock`
  (`starting`, `boss(world)`, `stars(count)`), each joker's `JokerKind` (the rules' `kindOf`:
  additive mult, multiplicative mult, chips, flat bonus, board effect, draw weight), the mastery
  tiers (`RunConfig.mastery`: bronze 1, silver 5, gold 15 runs won with it, tunable in Remote
  Config) and the rules' `JokerTuning`. Unlocked jokers, `JokerStats` and `spellbookSeen` come
  from the `progression` slot.
- **The screen.** A header ("12 / 26 collected" over a bar, "Pairs mastered x / 13"), then one
  `JokerPairRow` per pair in a lazy `SliverList`: card, ★ link, card. The link glows once both
  partners are gold (`pairMastered`).
- **A card** (`SpellbookCard`) shows only its emblem, short name (`game.jokers.<id>.short`) and
  three `MasteryDots` (`masteryTierOf`, home's `joker_mastery.dart`), framed in its kind's
  colours from the design system's `DSJokerFrame` (tiers in `DSMasteryColor`). Gold cards shine
  (`GoldShine`; held still under reduce motion). Locked: a dark silhouette, "?" and a lock. A
  screen reader hears "name, kind, tier" (or "Locked joker. how to unlock").
- **Emblems** (`JokerEmblem`): `jokerGlyphs`, one map of a vector glyph per joker in its kind's
  colour, unless `assets/jokers/<id>.png` is bundled in the assets package (read from the asset
  manifest, `jokerArt`): dropping a file swaps it in, with no code change.
- **NEW.** `SpellbookNew` takes the jokers unlocked but not in `spellbookSeen` as the visit opens,
  keeps their badges for the visit, and calls the `markSpellbookSeen` slot (game_domain's
  `MarkSpellbookSeenBehavior`) at once, so the next visit shows none. A new player's starting
  jokers count as seen.
- **The sheet** (`JokerSheet`, tap a card): the large card, full name, kind chip, the effect with
  its numbers picked out (`HighlightedNumbers`, from the collection's `JokerTuning`), the tier and
  the wins to the next ("3 / 5 wins to silver"), the three stats, and the partner as a mini card
  that opens in the sheet's place. Locked: how to unlock it.

## Tutorial

A first launch plays a guided run before anything else. It is shown once, skippable at any step,
and replayable from Settings.

- **The flag:** `settings_domain`'s `AppSettings.tutorialSeen`. The splash reads it through its own
  `tutorialSeenProvider` slot, and the game keeps it through its `markTutorialSeenProvider` slot.
  `app_providers` binds them to `settings.tutorialSeenProvider.future` and
  `settingsProvider.notifier.markTutorialSeen`.
- **Routing:** `SplashStateNotifier` waits for the flag during the splash wait and decides itself:
  unseen calls `SplashRouting.onFirstLaunch`, which `replaceAll([TabShellRoute(), GameRoute(launch:
  .tutorial)])`, so back lands on Home. Seen calls `onInitialized`. A flag that can't be read goes
  Home. Settings' How to play row calls `onReplayTutorialRequested`, which pops Settings and
  pushes the tutorial.
- **The run:** `GameLaunch.tutorial` plays `GameRules.tutorialRun` (a fixed board, no joker), counted
  as practice. `GameUiState.isTutorial` keeps it from ever being saved or measured against a best.
- **The steps:** `TutorialNotifier` (`game_presentation`, null outside a tutorial) follows the game:
  `drag` until a piece is placed, `clear` until a line clears, then `score`. On `score`,
  `PlaybackNotifier.holdOnProduct()` stops the playback on `chips × mult` until a touch, which
  `skip()` turns into letting it go on. Once the points land, it hands over to a fresh practice run
  (`GameNotifier.playPractice`), whose real starting pick is `pick`. Taking a joker, or Skip at any
  step, marks the tutorial seen, and Skip goes straight to that practice run. `tutorialHintFor`
  picks the cells `BoardView`'s hint layer lights: a quiet spot for the drag that keeps the clearing
  piece, then the spot that clears. `TutorialCoach` sits under the header, so the hints and tray
  stay clear.

## The bottom edge

Pieces are dragged up from a tray near the bottom edge, which both platforms read as the swipe
home. Three things keep the drag in the game:

- **iOS:** `app/ios/Runner/GameViewController.swift` (the storyboard's root controller) defers the
  bottom edge's system gesture, so going home takes a second swipe. Flutter doesn't expose this.
- **Android:** `MainActivity` hides the navigation bar with transient-by-swipe behaviour on every
  window focus. A swipe from the edge then only reveals the bar.
- **Layout:** `GameWidget`'s `SafeArea` keeps at least `MediaQuery.systemGestureInsetsOf(context).bottom`
  below the tray, so a grab never starts inside the gesture zone.

## Sound and haptics

The game asks for a `GameSound` and never knows the audio engine: `game_presentation` declares
`playSoundProvider`, `soundOnSettingProvider` and `hapticsOnSettingProvider`, and `app_providers`
binds them to `GameSounds` (`sounds`) and Settings' switches.

- **When:** `GameFeedback` follows `PlaybackNotifier`'s beats, and the notes are the game's
  (`game_feedback.br.dart`'s scales). Placing plays `place`, its pitch nudged within ±5%, with a
  light haptic; clearing plays `clear` a step up the major pentatonic per level of the streak
  (held on its top note) with a medium one; a combo of 3 or more a heavy one. The count-up ticks
  up the same scale — one tick per 40 ms of the chips and mult beats at most, no more than the
  number counted, 12 a move at most, on a timer the notifier cancels on a skip, a new move and
  dispose — and `kaching` plays as the total lands. The jokers of one move climb a major chord in
  firing order, from the root again each move. A won round plays `roundWon` with a heavy haptic as
  its points land, the boss round `bossWin` instead; a lost round plays `roundLost` as the move
  plays out and its sheet comes up. `bossStart` plays when the boss round begins, read from the
  game rather than the playback because the pick that starts it may have no beats; when the same
  move wins the round before it, the sting waits until the move has played out. A skip plays
  nothing it skipped but that outcome. Reduce motion drops the placing and clearing beats, not
  their feedback, and its shorter count-up ticks fewer times.
- **Switches:** each sound and each haptic obeys its own Settings switch, read as it plays.
  Haptics are Flutter's `HapticFeedback`, so they need no package.
- **Taps:** every `DSPressable` calls the `DSPressFeedback` above it, which the app points at
  `playTapSound`. `GameSounds.enabled` follows Settings' sound switch (`initializeSounds` keeps it in step), so the sound package obeys the switch and composition only wires it.
- **Mixing:** `AppDelegate` sets the iOS audio session to `.ambient` at launch, so the player's music
  keeps playing and the silent switch mutes the game, and activates it on every return to the
  foreground — flutter_soloud leaves both to the app. Another app's audio interrupts ours while the
  game is in the background, and iOS doesn't always report the interruption's end; flutter_soloud
  then skips every start until an explicit one, so `GameSounds` calls `startAudioDevice` on each
  resume, or the game stays silent until relaunched. On Android it takes no audio focus, so other
  apps play on there too.
- **Boot:** `initializeSounds` loads every sound into memory, not awaited — the splash outlasts it.

## Splash & Launch Screen

App startup is two screens in one colour — the brand colour (`DSColor.primary`, the logo's ground) from the first pixel to the cross-fade into Home:

- **Native launch screen** — shown by the OS before Flutter boots. Generated by **flutter_native_splash** (an `app` dev-dependency) from `app/flutter_native_splash.yaml`; regenerate with `cd app && dart run flutter_native_splash:create`, where `android/` and `ios/` live. `image:` points at `../packages/dsm/assets/source/logo.png` — the **PNG master**, since the generator can't read webp; it scales that source ÷4, which is why the in-app logo is `1024 / 4` wide — the two match, so the hand-off shows no jump. **After every regeneration**, re-set `app/ios/Runner/Base.lproj/LaunchScreen.storyboard`'s root-view `backgroundColor` to the brand colour (`DSColor.primary` as red/green/blue floats, 0–1) — the generator writes it white, and the 1x-only `LaunchBackground` image it relies on can fail to render on Retina. It also rewrites `AndroidManifest.xml` (dropping `screenOrientation="portrait"`) and `Info.plist` — discard both diffs. **Android 12+** draws its own splash and crops the image to a circle, which cuts the logo's corner cubes, so `android_12:` points at a transparent `android12_splash_empty.png`: that splash is a plain colour and the in-app splash draws the whole logo on its first frame. (Omitting the image would show the launcher icon instead.) Android's `NormalTheme` window background is the brand colour too (`@color/window_background`), so nothing between the launch screen and Flutter's first frame can flash white. The app icon's masters (`icon.png`, `icon_foreground.png`) come from `logo.png` via `scripts/make_icon_masters.py`, which sizes the adaptive foreground so its farthest pixel stays inside Android's 66dp safe circle; then `cd app && dart run flutter_launcher_icons`.
- **In-app splash** — the `splash` feature (`packages/features/splash/`), a normal feature package: `SplashWidget` draws `Assets.images.logo` at full opacity over the same colour at `_logoWidth` (256pt — the ÷4 of the 1024px master, so it lands exactly where the OS drew it). Nothing fades in: the first frame is held (`deferFirstFrame`) until the logo is decoded, so the OS screen hands over to an identical one, and `SplashStateNotifier.onReady(context)` waits `_splashDuration` (1800 ms), and for the tutorial flag (see Tutorial), before calling `SplashRouting.onInitialized(context)` or `onFirstLaunch(context)`. The only launch work today is reading that flag; whatever comes (Remote Config) runs inside that wait, in the notifier, not in the widget. The widget only `read`s the notifier, so `onReady` holds it with `ref.keepAlive()` and listens to the flag's slot until the hand-off: otherwise both could auto-dispose during the wait, dropping the answer and making a post-await `ref` throw.
- **Route wiring** — `AppRouter` makes `SplashRoute` the `initial` route and declares the tab shell as a `CustomRoute` with `TransitionsBuilders.fadeIn`, so splash cross-fades into Home; `SplashRoutingImpl` (`app_router`) does the `replaceAll([const TabShellRoute()])`.

## Injection

There is no backend: the app makes no HTTP calls and has no account; the only sign-in is the
platform's game service, for the leaderboards. **No feature package may
depend on `firebase_analytics`, `firebase_crashlytics`, `firebase_messaging`,
`firebase_remote_config`, `google_mobile_ads`, `in_app_purchase`, `purchases`,
`flutter_inappwebview`, `flutter_local_notifications`, `flutter_soloud`, `flutter_timezone`,
`timezone`, `push`,
`sounds`, `telemetry`,
`remote_config`, `url_launcher`, `ads`, `app_info`, `package_info_plus`, `device_info_plus`,
`external_links`, `share_plus`, `play_stats`, `games_services`, `leaderboards` or
`blockmancer_engine` directly** — a
feature declares a contract and the composition layer injects the implementation, exactly as it does
for routing.

- **The slot lives where it is consumed.** `game_domain` declares `gameRulesProvider` (typed by
  `shared_domain`'s `GameRules`; it derives each mode's seed with it) and `bestScoresProvider`;
  `game_presentation`, which shows the revive's reward, declares `rewardedActionProvider`. Neither
  imports the engine, `game_data`'s shared_preferences or `ads`.
- **`app_providers`' `featureBindingOverrides()` is the only place both halves are known**, and it
  is pure wiring: it says which function fills which slot and nothing else. Any decision — combining
  results, mapping an error, choosing an outcome — belongs to the package that owns the meaning.
  `app_router` binds routing only.
- Every package's binding helper is named `bindProviders(...)`; callers import with a prefix
  (`game.bindProviders(...)`, `game_ui.bindProviders(...)`). Routing keeps its own `bindRoutingProviders(...)`.
- **Logging goes through `Timber`**, never a payload: no push token, no push `data`, no raw body
  reaches a log line. Failures log at `Timber.e`. Nothing is planted in release, so every call is a
  no-op there; `boot()` plants a `DebugTree` under `kDebugMode`.

**`app/lib/config`** — `Env { dev, prod }` and `AppConfig { env }`, built by
`AppConfig.fromEnvironment()` from `const String.fromEnvironment`, so the value resolves at compile
time with no wiring. Pass it with `--dart-define-from-file=env/<flavor>.json` (see the `flavor-*`
melos scripts). With no flag — including every `flutter test` run — it is a dev build. It is not a
package: the app is the only thing that reads it, and `boot()` turns it into the
`collectsTelemetry` value it passes to `appOverrides`.

## Ads

AdMob, behind `ads`' `RewardedAds` and `InterstitialAds` (`AdMobRewardedAds`,
`AdMobInterstitialAds`), each kept loaded: the first request waits for consent
(`Consent.adsAllowed`), the next one loads as soon as one is shown, and a failed load is retried
later and later (30 s doubling to 5 min). Only a release build that isn't a test build plays the
real units (`app/env/prod.json`, read in `app_providers`' `release_ids.dart`); every other build
plays Google's test units (`TestAdUnits`). `startAds` (boot) preloads both and counts the launch;
a run's start preloads again (`preloadAds`).

- **Rewarded revive.** `RewardedActionFun` answers an `AdResult` (`earned`, `closed`, `failed`);
  only `earned` revives. `ReviveButton` reads "Watch an ad to revive" with an ad icon, and watches
  `rewardedAdReady`: with none loaded it reads "No ad to revive with right now" and can't be
  tapped. With Remove ads there is no ad at all (see Remove ads).
- **Interstitial between runs** (`game_domain`'s `betweenRuns`): `GameNotifier.retry` and `leave`
  wait for it when the run on screen has ended (never mid-run, never in the tutorial). It shows when
  `interstitialDue` allows it: not in the device's first session (`firstSession`, counted at boot),
  not before `interstitial_min_completed_runs` completed runs, at most every
  `interstitial_every_n_run_ends` run ends and `interstitial_min_seconds` apart (Remote Config,
  `interstitialCapsOf`). What it needs is `Engagement` (completed runs, days opened, run ends
  since the last interstitial and when it showed), kept by `game_data`'s
  `SharedPreferencesEngagementStore` under `engagement`, every change in order
  (`EngagementBehavior`).
- **Analytics:** `trackAd` turns each result into `ad_shown(type)` (plus `ad_reward_earned` when
  earned) or `ad_failed(type, code)`. The testers' on-device log doesn't count ads.

## Remove ads

One non-consumable, `blockmancer.remove_ads` on both stores (`IAP_REMOVE_ADS` in
`app/env/prod.json`, passed to the shop as `removeAdsProductId`; $3.99, priced in the stores):
interstitials gone for good, and the revive granted with no video: the same revives per run as
everyone (the rules' `canRevive`), just no ad.

- **`shop_domain`'s `RemoveAdsNotifier`** (keepAlive) owns it: kept on the device
  (`shop_data`'s `SharedPreferencesEntitlementStore`, `purchases.removeAds`), so it holds offline,
  and confirmed by every purchase or restore the store reports, listened to from launch.
  `startPurchases` (boot) re-checks with the store (a restore that counts as none), so a reinstall
  gets it back. Nothing takes it back. Events: `purchase_started`, `purchase_completed`,
  `purchase_restored` (only a restore the player asked for), `purchase_failed(code)` (`canceled`,
  `unavailable`, or the store's code).
- **`purchases`** (`StorePurchases`) wraps `in_app_purchase` (StoreKit 2 on iOS) and acknowledges
  every purchase it hands over.
- **The game** reads it through `game_domain`'s `adsRemoved` slot: `betweenRuns` shows nothing,
  and `reviveNeedsAd` is false, so `GameNotifier.revive` revives at once without calling
  `rewardedAction`, and the lost sheet shows a plain "Revive" with no ad icon (assumed to need the
  ad until the entitlement is read). `trackRevive` logs `revive(source: ad | owned)`.
- **Settings:** `RemoveAdsRow` (the store's localized price at the row's end, never one of ours;
  "Ads removed" with a check, not tappable, once owned) and `RestorePurchasesRow` (says whether
  anything was found), through slots.

## Rating prompt

The OS's own prompt (`store_review`'s `InAppStoreReview`, over `in_app_review`), never a custom one
first. `RunEndSheet`'s `_ReviewMoment` waits for the sheet's entrance (`sheetEntrance`) and its new
stars' pop (`RunStars.celebration`), then calls `GameNotifier.celebrated()`: once per finished
run, never in the tutorial, only after a boss win or a newly earned star, it asks
`game_domain`'s `askForReview`, which asks when `reviewDue` allows it — at least 3 completed runs
over at least 2 different days (`Engagement`), no uncaught error this session (telemetry's
`SessionErrors`, watched at boot over whatever handlers are in place), not yet asked in this app
version, and `review_cooldown_days` (60, Remote Config) since the last ask. It records the ask
(`reviewAskedAt`, `reviewAskedVersion`) and logs `review_prompt_requested`; whether the OS shows
it is the OS's call. Settings' **Rate Blockmancer** (`RateRow`) opens the store page, always.

## Leaderboards

Game Center on iOS, Play Games on Android, behind `leaderboards`' `Leaderboards`
(`GamesServicesLeaderboards`, over `games_services`; never throws).

- **Two boards:** `blockmancer.daily_run` (Game Center: recurring, every day from 00:00 UTC; Play:
  a board of its own, opened on its daily view) and `blockmancer.best_run` (all time). Their ids
  are `release_ids.dart`'s `dailyLeaderboard` / `bestLeaderboard`, from `app/env/prod.json`.
- **Submitting:** at every run's end but the tutorial's, `GameNotifier` calls `game_domain`'s
  `submitRunScore`, which decides the boards: every run's total to the all-time board, a daily
  run's to the day's too, nothing for a total of 0. Its slots (`submitBestScore`,
  `submitDailyScore`) are bound to the one `Leaderboards` instance, each with its board.
- **Signing in:** `signInToLeaderboards` (app_providers) once the consent form is done, at
  launch's post-frame step; a submit or the board signs in again if needed. A refusal leaves the
  boards empty and never blocks play.
- **The button:** the daily card's **Leaderboard** (`LeaderboardButton`, its own pressable) calls
  home's `showDailyLeaderboard` slot.
- **Placeholders:** a platform whose ids are still `PLACEHOLDER_…` gets `NoLeaderboards`. Android
  reads `PLAY_GAMES_APP_ID` into the manifest's `com.google.android.gms.games.APP_ID` through a
  Gradle `resValue` (a string resource, so the numeric id isn't read as a number); iOS carries the
  Game Center entitlement in `Runner.entitlements`.

## Consent

Ads in the EEA and the UK need the player's consent first: Google's UMP form, behind `ads`'
`Consent` (`GoogleConsent`).

- **When:** every launch, once the first frame is up (the form is drawn over the app):
  `gatherConsent` (app_providers) calls `settings_domain`'s `ConsentNotifier.gather`, which asks
  UMP (form shown only when due), starts the ad SDK once ads may be requested, and sets Analytics'
  consent mode from the answer (`Telemetry.setAnalyticsConsent`: granted only when ads may be
  requested; the per-purpose detail is the TCF string UMP writes for the SDKs). The game never
  waits for it; ads do.
- **iOS tracking:** the IDFA explainer set up in AdMob shows Apple's ATT alert itself when the
  player continues; declining leaves ads non-personalised. No ATT package.
- **Settings:** `PrivacySection` — **Privacy choices** (reopens the form, then takes the new
  answer) only when UMP says the player must be able to change it (`privacyChoicesRequired`), then
  **Privacy policy** and **Legal notice** on `studio.elietabet.com` (`privacyPolicyUrl`,
  `legalNoticeUrl`; **Support**'s `supportUrl` sits under Help), opened through the `openUrl` slot.
- **Testing the EEA form:** a test build with `UMP_DEBUG_EEA=true` and `UMP_TEST_DEVICE_ID`
  (docs/console-setup.md, AdMob).
- **Native:** the AdMob app ids come from `app/env/prod.json` in every build: Gradle's
  `manifestPlaceholders` fills the manifest's `com.google.android.gms.ads.APPLICATION_ID`, and the
  Runner target's "Set AdMob app id" build phase writes `GADApplicationIdentifier` into the built
  Info.plist (failing the build when the id is missing); without one the ad SDK stops the app at
  launch. Info.plist lists the 50 SKAdNetwork ids of AdMob's page. `ADMOB_TEST_DEVICE_IDS` (comma
  separated) gets those phones AdMob's test ads even from a release build.

## Settings

The player's settings, kept on the device; there is no account to sync them to. Home's gear pushes
`SettingsRoute` over the shell (absolute `/settings`, like the game), and its back arrow pops.

- **What is kept:** `settings_domain`'s freezed `AppSettings` — `sound`, `haptics` (on by default),
  `reduceMotion` (off), `dailyReminder` (on), `language` (`AppLanguage.system` / `.en` / `.fr`)
  and `tutorialSeen`. `settings_data`'s `SharedPreferencesSettingsStore` writes one key per
  setting (`settings.sound`, `settings.haptics`, `settings.reduceMotion`, `settings.dailyReminder`,
  `settings.language`, `settings.tutorialSeen`), so a
  value missing or of the wrong type reads as its default rather than losing the rest.
- **One notifier:** `SettingsNotifier` (keepAlive, `settingsProvider`) loads once and is the only
  writer: each setter shows the change at once, then writes, in order; a failed write is logged and
  the change holds for the session. `markTutorialSeen` / `resetTutorial` are there for the tutorial.
- **Who reads it:** other features never import settings. They declare their own slot, and
  `app_providers` fills it from `settings_domain`'s leaves — `soundOn`, `hapticsOn`,
  `reduceMotionOn` (plain bools, a first launch's value while loading) and `tutorialSeen` /
  `appLanguage` (futures, so a launch can wait for the stored answer). See Tutorial for who reads
  `tutorialSeen`.
- **Reset progress:** the Settings row confirms with `DSPopup.showConfirm`, then `resetProgress`
  calls the `clearProgressProvider` slot and offers the tutorial again. `app_providers` binds that
  slot to `game_domain`'s own `clearProgressProvider`, which clears the profile's bests and the saved
  run and refreshes what Home shows of them — settings never learns what progress is.
- **Language:** `boot()` calls `applyStoredLanguage` (app_providers, delegating to
  `settings_presentation`, which maps `AppLanguage` to slang's `LocaleSettings`) right after
  telemetry and before push, whose channel is named in the language the app shows. System re-reads
  the phone's locale.
- **The screen** is iOS inset-grouped in the game's palette: sections under a small capitalised
  name, one card each (`SettingsSection`, `SettingsGroup`, rows split by hairlines), in order GAME
  (the four switches, Language's segmented control), PURCHASES, HELP (How to play, Support, Send
  feedback, Rate Blockmancer), PRIVACY & LEGAL, then Reset progress alone on a card in red, the
  TESTERS section in a test build only, and the footer. A row (`SettingsRow`, at least 52 high,
  title only) ends in a switch, the price, "›" for a screen of the app, or the leave-the-app icon
  for the store, mail and the web, whose screen-reader hint says so (`DSPressable.semanticHint`).
  Titles wrap rather than clip at large text sizes, in both languages (a test at 2× in each).
  Reset's confirmation spells out what is erased; its red button comes after Cancel, which leads.
- **Version and feedback:** the footer shows `settings_domain`'s `AppDetails` version as
  "Blockmancer 1.0.0", without the build (the feedback email carries it), and Send feedback runs `SendFeedbackBehavior`: a `mailto:support@elietabet.com` draft whose
  subject and labels stay in English (support reads them) with the version, build, device and OS
  prefilled. When no mail app opens, a popup shows the address. Both come through slots —
  `appDetails` (keepAlive, `app_info`'s `readAppInfo` mapped field by field) and `composeEmail`
  (`external_links`). `launchUrl` is called without `canLaunchUrl`, so neither iOS's
  `LSApplicationQueriesSchemes` nor Android's `<queries>` is needed.
- **Share test stats:** the TESTERS section's first row calls `SettingsStateNotifier.shareTestStats`.
  `settings_domain`'s `TestStatsSummaryBehavior` builds the summary — the `exportTestStats` slot's
  JSON (play_stats', see [Local stats](#local-stats)) with the app's version and build added,
  never its device or OS — and the notifier hands it to `settings_presentation`'s `shareText` slot
  (`external_links`, over share_plus) with the row's rect, which an iPad's popover points from:
  where a popover anchors is the screen's business, so the domain never sees a `Rect`. When the
  sheet doesn't open, a popup says so.

## Local stats

What players do, counted. The game reports it to `shared_domain`'s `AnalyticsSink`
(`log(AnalyticsEvent)`, never throwing or waiting); each sink maps the sealed `AnalyticsEvent`
cases to its own wire format. A release build binds telemetry's `FirebaseAnalyticsSink` (the same
snake_case names and parameters as below, a bool as 0 or 1); a **test build** (`TEST_TOOLS`) binds
`CompositeAnalyticsSink([FirebaseAnalyticsSink, LocalPlayStats])`, so the testers' on-device log
below keeps counting, and Settings shows Share test stats and Test crash. A release build deletes
whatever a test build counted on the phone at launch (`discardTestStatsOutsideTestBuilds`).

- **What is counted** (`game_domain`, through its `analyticsSink` slot): `runEventsOf` maps a move —
  `run_start(mode, world)` at a fresh run's starting pick (so a run opened by mistake counts
  nothing), `joker_pick(id, offered)`, `round_end(round, won, score)` when a round is won or a lost
  one given up (a revive plays it on) — `GameNotifier` logs `revive(source)` itself, through
  `trackRevive`, since only it knows whether an ad or Remove ads paid for it — and
  `runEndEventsOf` a run's end, once
  `recordProgression` answers: `run_end(total, won, stars_earned)` and `world_unlock(world)`.
  push_notifications logs `notification_opened(message_id)` when a daily reminder is tapped
  (Firebase only, like the ads' and purchases' events).
  `GameNotifier` calls `trackMove` from `_apply` and `trackRunEnd` from `_recordProgress`; the
  tutorial counts nothing.
- **Where:** `play_stats`' `LocalPlayStats` (one for the app's life, `app_providers`'
  `playStatsProvider`, its days from the game's `Clock`) keeps one JSON string under `playStats`:
  a schema `version`, a random install id (128 bits from `Random.secure()`) and, per local day,
  runs, runs won, revives, rounds reached (round-end count per round), picks and offers per joker
  and world unlocks. A counter missing from a day an earlier build wrote reads as 0, so the log
  grows without a migration. Writes, the export's included, run one after another in the order
  logged; a log that can't be read starts afresh. The install id lives in shared_preferences,
  which backups restore: when Firebase arrives, use its instance id instead.
- **The export:** `exportJson` waits for the writes, then gives `{schema, installId, exportedOn,
  daysPlayed, totals, days}` — no personal data.

## Push notifications

Pushes are FCM *notification* messages (title, body, string `data`) sent from the Firebase console;
there is no backend, so the token is never reported anywhere (`reportPushToken` is bound to a
no-op). Three packages share the client side, and only one knows Firebase:

- **`packages/utilities/push`** — `PushMessaging` over `firebase_messaging` and
  `flutter_local_notifications`: the token, the OS prompt, the Android channel (`announcements`,
  re-created every launch so its name follows the phone's language), Android's foreground display,
  and taps. A tap comes out as its `data` map and nothing more — the push that launched the app
  (`launchMessage`, FCM's or one the app drew itself) and every later one (`openedMessages`). iOS
  presents foreground pushes itself; adding Android's listener there would draw a second banner.
- **`packages/features/push_notifications`** — the decisions. `askForNotifications` requests
  permission and then reports the token whatever the answer (on a fresh iOS install answering the
  prompt is the first moment a token is readable). `pushTokenSync` (keepAlive) reports each
  refreshed token. `ResolvePushDestinationBehavior` reads where a tap leads. `PushDestination` has
  two cases, `.dailyRun(messageId)` (a daily reminder) and `.home()`: add a case per `data` key
  the server sends, resolve it there, and route it in `PushOpeningsNotifier` — anything
  unrecognised still opens the app. `push`'s `receivedMessages` (pushes arriving while the app is open) is
  available for a screen that should catch up on one; nothing listens to it yet.
- **Who calls what.** The permission is asked when a run ends (see Daily reminder), never
  at launch. `PushNotificationsRoutingImpl` (context-free: a tap arrives from the OS, not a widget)
  waits out the splash, then dismisses
  whatever is open and selects the push's tab — so back always lands on that tab. A push about one
  item pushes its page over the tab.
- **Boot.** `Firebase.initializeApp()` before the container — with no options, so each platform
  reads its native file — then `initializePushNotifications` (app_providers): messaging first, then
  the tap listener. It never throws: boot awaits it before `runApp`, so a failed setup (an icon the
  OS can't resolve, no Play services) would strand the app on its splash. The app launches without
  push that session, and the failure reaches Crashlytics as non-fatal through the `reportNonFatal`
  slot, bound to telemetry's `recordNonFatal`.
- **Firebase config is committed** — `app/ios/Runner/GoogleService-Info.plist` (in the Runner
  target's resources) and `app/android/app/google-services.json`, both for the app's bundle id in
  the app's Firebase project.
  They identify the project rather than authorize anything; restrict the API keys to the bundle id
  and package name in Google Cloud instead. The token is a push credential and is never logged;
  neither is a push's `data`, only its keys.

## Daily reminder and streak

- **The reminders:** a week of one-shot local notifications at 18:00 local time
  (`reminderTime`), each with its own message: `push`'s `DailyReminder` (`LocalDailyReminder`:
  `upcoming` gives each local day's 18:00 as an instant, `replace` cancels every reminder and
  `zonedSchedule`s the new ones, ids 100–107, inexact on Android,
  its own `daily_reminder` channel, created at high importance so Android drops a banner and
  re-created with every plan so its name follows the language, the tap's data as the payload),
  never a push.
- **Who decides:** push_notifications_domain's `DailyReminderNotifier` (keepAlive; its state is
  the plan). It plans only with Settings' **Daily reminder** on (`dailyReminderEnabled`) and a
  run of any kind (world, practice or daily; never the tutorial) played to its end
  (`hasCompletedRun`, game_domain's `Engagement.completedRuns`); otherwise it cancels. It plans
  again on every start and return to the app (`resumed`), on the switch, on a change of the app's
  language (`displayLanguage`, push_notifications_presentation's `displayLanguages`), and when
  any run ends: game_domain's `recordRunEnd` calls its `onRunFinished` slot, bound to
  `runFinished`, which asks for notifications (the OS prompts once) and plans, the ask
  failing or not. Plans run one after another, never interleaved. A player who never played a
  daily run has no streak, so gets the general messages.
- **The plan** (`PlanDailyRemindersBehavior`, pure): days 0–3 from this open every day, then days
  5 and 7, then nothing until the next open; none whose UTC day's daily run is played
  (`dailyStanding`, game_domain's `dailyStandingOf`); the first past day 3 is the comeback
  message, a projected streak of 2 or more draws a streak message (naming it), anything else a
  general one. Each is drawn with a `Random` seeded by its UTC day, never one of the last 3
  shown or planned before it (a pool with nothing left draws a general one). The previous plan's
  reminders whose time has passed count as shown; the plan and the last 3 are kept in
  push_notifications_data's `SharedPreferencesReminderLogStore` (`reminder.log`).
- **Messages:** `ReminderMessage` (11, in pools `streak`, `general`, `comeback`), each with a
  stable snake_case `id`; the words are `push.reminder.messages.<message>` (EN/FR, an emoji
  first), read by push_notifications_presentation's `reminderMessageTexts` in the language the
  plan is made in. A test keeps every title within 40 characters and every body within 110.
- **A tap** carries `{type: daily_reminder, message: <id>}`: `ResolvePushDestinationBehavior`
  makes it `PushDestination.dailyRun`, `PushOpeningsNotifier` logs `notification_opened(message_id)`
  (`trackNotificationOpened`) and calls `onDailyRunOpened`, which opens Home and calls home's
  `revealDailyCard`, scrolling it back to the daily card.
- **Started** by `startDailyReminder` (app_providers) after push's start: it listens to the
  notifier for the app's life and calls `resumed` on every return to the app.
- **Android:** `RECEIVE_BOOT_COMPLETED` and flutter_local_notifications' two receivers in the
  manifest, so they fire and survive a restart; no exact-alarm permission.
- **The streak:** game_domain's `dailyStreak` (`dailyStreakOf`): the UTC days in a row, today
  back, with a daily run played to its end (`BestScores.dailyDays`, the profile's daily bests, so
  no migration); today not played yet doesn't break it. The daily card's `DailyStreak` shows it
  from 1, through home's `dailyStreak` slot.

## Remote Config, updates and test builds

- **`TEST_TOOLS`** (`const bool.fromEnvironment`, `AppConfig.testTools`, default false) is set only
  by `build-ios-test` / `build-android-test`, and passed to `appOverrides(testTools:)`. It picks the
  analytics sink (see Local stats), shows Settings' testers' rows (`showsTestTools`, last on the
  screen so a release loses nothing but them) and fetches Remote Config every 5 minutes instead of
  12 hours. A debug run is not a test build unless run with `--dart-define=TEST_TOOLS=true`.
- **Remote Config** (`packages/utilities/remote_config`): `RemoteValues.valueOf(key)` is the text
  published for a key, or null; the package that reads a key parses it and ignores a bad value.
  `fetchRemoteConfig` starts the launch's fetch (kept as `remoteValuesFetched`) right after the
  container, not waited for.
- **What a run plays with:** `game_domain`'s `tuned(config, valueOf)` applies every published key
  (`runTuningKeys`: rounds, per-world bosses and ★3, revives, offers, every `JokerTuning` field)
  to the rules' config, a value outside its key's range or not a number keeping the default. It is
  applied where a run starts (`RunStartForBehavior`, `DailyRunBehavior`) and where the map and
  Spellbook read the numbers (`worldSummariesOf`, `jokerCollectionOf`), never by swapping the
  rules (`GameNotifier` watches them, and a swap would restart the run on screen); a run keeps
  the config it started with, so a fetch reaches the next one. The tutorial plays the rules' own.
- **The template:** `app_providers`' `remoteConfigKeys()` lists every key with its default (the
  run's, then `app_update`'s versions); `tool/remote_config_template.dart` writes
  `docs/remote-config/template.json` (to publish) and `keys.md` (the table), and a test fails when
  they drift from the code.
- **Updates** (`app_update`): `min_version_{ios,android}` and `latest_version_{ios,android}`,
  default `0.0.0`, against the app's version with pub_semver (anything malformed asks nothing).
  The splash waits for `updateRequired` (which waits up to 2 s for the launch's fetch) beside the
  tutorial flag; below the minimum, `SplashRouting.onUpdateRequired` replaces everything with
  `UpdateRequiredRoute` (no back, a store button). Below the latest, Home's `UpdateBanner` offers
  it until "Not now", kept per version on the device (`update.dismissedVersion`). The store links
  come from `app_providers`' `release_ids.dart`, the App Store id from `app/env/prod.json`.

## Telemetry

Firebase Analytics (the automatic events, and the game's own through `FirebaseAnalyticsSink`) and Crashlytics
(fatal Flutter and uncaught async errors only; Timber stays a no-op in release). Only a **release
build against production** sends; every other build sends nothing. There is no in-app consent
question yet — the privacy policy and App Store privacy details are what disclose it.

- **`packages/utilities/telemetry`** — `Telemetry` (`installCrashHandlers`, `setCollectionEnabled`)
  over both plugins, one switch for the two; turning it off also deletes the crash reports cached
  on the phone. `initializeTelemetry` installs the crash handlers only when collecting, and sets
  the switch on **every launch**, on or off: both SDKs persist it on the phone, so a dev or debug
  build installed over a release one would otherwise inherit its "on".
- **Non-fatal reports.** `recordNonFatal` is for a failure the app recovered from but someone
  should still see — today, push setup at launch. It is gated on `collectsTelemetry` itself, not
  only the SDK switch: Crashlytics keeps reports made while switched off and would send them once
  a release build turns it on.
- **Who decides.** The app computes `collectsTelemetry` (`kReleaseMode && env == prod`) and calls
  `initializeTelemetry` (app_providers) right after the container, so the handlers cover the rest
  of boot. The package only obeys.
- **Native defaults are off** — `FIREBASE_ANALYTICS_COLLECTION_ENABLED` /
  `FirebaseCrashlyticsCollectionEnabled` in `Info.plist`, the matching `meta-data` in the Android
  manifest — so nothing goes out before Dart has set the switch. Analytics itself still collects no
  advertising id (`google_analytics_adid_collection_enabled` false); AdMob does, as consent
  allows: Android declares `AD_ID`, and iOS asks the tracking question through UMP's IDFA
  explainer (`NSUserTrackingUsageDescription`). The `ACCESS_ADSERVICES_*`
  permissions Firebase Analytics merges into the Android manifest stay, since AdMob will use them. Don't retry `FIREBASE_ANALYTICS_WITHOUT_ADID`:
  firebase_analytics' `Package.swift` reads it, but Xcode doesn't pass environment variables to
  manifest evaluation (only the `swift` CLI does), so it never takes effect in a Flutter build.
- **Popups take turns.** Anything the app raises on its own goes through `RootPopups` in
  `app_router` (one per router), which waits for a screen a popup may sit on and shows one at a
  time. Nothing raises one today; a consent question, if one is added, belongs there.

## Webviews

`packages/utilities/webviews` is the only place `flutter_inappwebview` is known. It is **layer-split
like a feature** — `webviews_domain` / `webviews_presentation` under one directory — because the
declarative half is engine-agnostic and worth testing without a platform view, while only the widget
half touches the plugin. That split is why the workspace globs carry `packages/utilities/**/*`.

Nothing uses it yet. Unlike `push` and `telemetry`, a feature reaches this one **directly**: a `<feature>_presentation`
package declares `webviews_presentation` and builds a `Webview`, the same way it declares
`design_system`. There is nothing to inject — the widget is UI, not a capability whose implementation
composition has to choose. What the ban buys is that the engine stays swappable in one package.

**`webviews_domain`** — entities only, no providers, no engine:

- `WebViewConfiguration`, a sealed pair: `WebViewConfigurationFromUrl` (a `FutureOr<String>` url) and
  `WebViewConfigurationFromData` (inline HTML + optional `baseUrl`). Everything the webview does is
  configured here — navigation predicate, JS dialog handlers, `onCreateWindow`, `onPageFinished`,
  `onError`, and the platform-composition flags — never on the widget.
- `JavascriptBridge`, the Flutter↔page channel. The default constructor is fire-and-forget; the
  `.async` one lets `onParsed`/`onError` return a value that is delivered back to the page as the
  result of its `callHandler` call. An empty or `null` message on a nullable-payload bridge is a
  null parse, **not** a decode error — that is how a page signals "closed" with no payload.
- `WebviewController` + `WebviewCommand` / `FunctionWebviewCommand`, for driving the page from Dart.
  `RawJavascript` is the escape hatch: an argument emitted verbatim rather than quoted, for when the
  page expects a JS value and not a string literal. Every other argument is escaped, including the
  Unicode line separators that would otherwise terminate the statement.

**`webviews_presentation`** — the `Webview` widget, plus the small pieces it is assembled from:

- Fully driven by the configuration: it registers the JS bridges on creation and **unregisters them
  on dispose**, and forwards the predicates and dialog handlers.
- `resolveWebviewUiConfiguration` turns the configuration into what the engine starts with, and is a
  plain function rather than a provider. It is resolved **once, in `initState`** — resolving per
  build would re-await an asynchronous URL on every rebuild and flash the loading state each time. A
  URL the app already holds resolves synchronously, so the page mounts with no loading frame at all.
- `keepAlive`: pass a **long-lived** `WebviewKeepAlive` and the native webview — with its loaded page
  — survives the widget leaving the tree; re-mounting re-attaches instead of reloading. Because it
  then outlives the widget you **must** call `WebviewKeepAlive.dispose()` when the page is closed for
  good, or the native webview leaks.
- `scrollsWithHost`: **opt-in**, for a page embedded in a scrolling host that does not scroll
  internally. By default the webview installs an `EagerGestureRecognizer`, which claims every touch
  the instant it lands, so a drag started over the page is swallowed and the host does not move. With
  the flag on it claims **taps only**, so the drag loses the arena to the enclosing scrollable while
  taps still reach the page. A page that *does* scroll internally stops being able to — turn it on
  only where the host owns the scroll. Ignored when `interactive` is false, which claims nothing.
- `onContentHeightChanged`: **opt-in**, for a host that sizes its slot to what the page drew. Injects
  a measuring script and reports logical pixels on every reflow; omit it and no script is injected.
  It measures the **union of `document.body`'s children**, not `scrollHeight` — a page whose body
  fills the viewport reports back exactly the height it was given, so a host that over-reserved would
  measure its own guess and never shrink. Neither platform gives this for free: the plugin's
  `onContentSizeChanged` is iOS-only and Android's `getContentHeight` is a pull with no change
  signal, so a `ResizeObserver` (re-armed by a mutation observer, with a 200 ms backstop) is what
  reports the same number on both.
- **Untrusted TLS certificates are rejected by default.** Native WebViews do their own TLS
  validation, so no server-trust handler is installed unless composition feeds
  `bindProviders(untrustedCertificatesAllowed: …)`. Unlike every other DI slot in the workspace this
  one **does not throw** when unbound — rejecting is the correct answer, so an app that never binds
  it is safe. Nothing binds it today.
- Navigation is logged through `redactUrlForLog`, which keeps scheme/host/path and drops the query
  and fragment: a webview URL can carry credentials, and a verbatim log line would leak them.

Two things flutter-front has here are deliberately absent, because this app has neither the concepts nor
the packages behind them, and half-wiring them would be worse than their absence:

- **No URL computation.** flutter-front appends a single-use token, refresh token, platform, theme
  and `show_header` behind four DI slots, and carries a `WebViewConfigurationType` enum to choose
  between them. A configuration's URL is used verbatim here. Add the computation back as a
  `webviews_domain` behavior with its own slots when a real caller needs an authenticated page —
  not in composition, per [providers](.claude/rules/providers.md).
- **No `opensLinksExternally`.** `resolveNavigationPolicy` (main-frame only, so an embedded iframe is
  never judged by the page's allowlist) is the whole policy. `url_launcher` now exists behind
  `external_links`, so wiring this up is a matter of a slot rather than a dependency — but nothing
  asks for it yet, and a webview handing links out is a wider decision than a single link doing so.

## Adding New Features

New features are added under `packages/features/<feature>/`, split into layer packages (`<feature>_domain`, `<feature>_data`, `<feature>_presentation` — delete any the feature doesn't need), using:

```bash
melos run create -- --name <name> --type feature
```

The `game` feature (`packages/features/game/`) is the reference for a screen whose rules are injected; `splash` (`packages/features/splash/`) shows a screen whose only job is a routing hand-off, and `push_notifications` (`packages/features/push_notifications/`) shows domain + presentation layers with no screen at all. The scaffolding script lives at `scripts/create_package.sh`.

**A new tab** follows `home` (`packages/features/home/`): a `<feature>_presentation` with a relative `<Feature>RoutePath`, one `AutoRoute` child in `AppRouter._tabConfiguration`, and one entry in each of `TabShellPage._routes` and `_destinationsOf`. The bar appears by itself with the second tab.

## Claude agents and skills

`.claude/` ships with the app, so every app made from this template starts with the same crew:

- **`flutter-developer`** — implements a feature or a brief the way the workspace is built, and hands back green analyze and tests.
- **`architecture-reviewer`** — layering, DI slots, generated-file and dependency discipline. Run after any change under `packages/`, and before a commit.
- **`qa-reviewer`** — runs the suite and hunts for untested error paths against the API contract.
- **`security-reviewer`** — token storage, what reaches a log or a crash report, WebView hardening, push payloads.
- **`brief-verifier`** — walks a brief in `.claude/plans/` against the real code.
- **Skills:** `develop-feature` (the step-by-step for a new feature), `flutter-expert-engineering` (general discipline plus the backend contract), `flutter-debug`, `flutter-animate`.

