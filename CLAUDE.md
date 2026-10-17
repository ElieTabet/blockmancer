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
│   │   ├── ads/              # Rewarded ads behind `RewardedAds.show()` — no network yet, so every reward is granted (phase 3 brings AdMob)
│   │   ├── external_links/   # Hands a link to the OS (browser, mail draft) — the only place url_launcher is known; unused yet
│   │   ├── push/             # FCM + local notifications behind PushMessaging — the only place firebase_messaging is known
│   │   ├── telemetry/        # Firebase Analytics + Crashlytics behind one switch — the only place either is known
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
│       ├── game/{domain,data,presentation}/      # game_* — the run's mode, seed, best scores and saved run (domain), kept on the device with its clock (data), and the board, tray and joker picks, pushed over the shell (presentation); rules injected via GameRules
│       ├── home/presentation/                    # home_presentation — the first tab: Daily run and Practice, each with its best (read through slots)
│       ├── push_notifications/{domain,presentation}/ # push_notifications_* — the permission ask, token sync, and where a tapped push leads (no screens)
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

# Play 2,000 seeded runs for each reference build with the greedy balance bot, and print
# the share of runs clearing each round, the median total and the boss win rate
# (docs/balance/<date>.md holds each table, docs/balance-v0.md the first). It plays
# `defaultConfig`. Melos passes no arguments through, so for
# `--runs` / `--build` run it from the package:
#   cd packages/blockmancer_engine && dart run tool/balance_bot.dart --runs 2000 --build patience,twin
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
- **Feature layering:** each feature is split into layer packages `<feature>_domain`, `<feature>_data`, `<feature>_presentation` under `packages/features/<feature>/`. Layer boundaries are enforced at compile time by each package's declared deps. Layers a feature doesn't need are simply absent — `push_notifications` has no `_data`.
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

`app_router` also owns the app root router `AppRouter` (`@AutoRouterConfig RootStackRouter implements AutoRouteGuard`, aggregating each feature's `AutoRoute` with its path from the feature's `<Feature>RoutePath` enum, e.g. `AutoRoute(path: SplashRoutePath.splash.path, page: SplashRoute.page, initial: true)`) and exposes `routingOverrides()` — which calls every feature's `bindRoutingProviders(...)` — alongside `featureBindingOverrides()`, the same aggregation for the non-routing slots (the game's rules, best scores and revive reward, push, telemetry). `app_providers.appOverrides()` spreads both; the thin `app` applies it at startup:

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
- **Locale lifecycle:** the initial locale is resolved from the device in `boot()` via `LocaleSettings.useDeviceLocaleSync()`. `MaterialApp.router` sets `locale: TranslationProvider.of(context).flutterLocale`, `supportedLocales: AppLocaleUtils.supportedLocales`, and `localizationsDelegates: GlobalMaterialLocalizations.delegates` (from `flutter_localizations`). Switch at runtime with `LocaleSettings.setLocaleSync(AppLocale.fr)` — every `context.t` rebuilds. (There is intentionally no locale-switcher UI or Riverpod locale controller yet; add one wired to a real caller when needed.)
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
- **`shared_domain` is pure Dart** because the engine depends on it and must run on the plain VM
  and the web.
- **Pure Dart.** Its pubspec declares no Flutter, so a `package:flutter` import fails
  `melos run analyze` (`depend_on_referenced_packages` under `--fatal-infos`). The brief's
  `import_lint` isn't used because no version resolves against the pinned analyzer 10.2.0.
- **Deterministic.** No `DateTime.now()`, no `dart:math` `Random`, no I/O. Randomness is the
  engine's own mulberry32 over 32-bit arithmetic, so a seed gives the same run on the VM and on the
  web. Callers pass the date in for a daily seed: `game_domain` reads it from its injected `Clock`
  (`SystemClock` in `game_data`; never `DateTime.now()` elsewhere), keys the daily run by the UTC
  day and asks the rules for that day's seed (`dailyRunOn`).
- **Replayable.** A run is its seed and its moves: `GameRules.replay({config, moves, seed})` folds a
  list of `shared_domain`'s `RunMove`s (`pick`, `place`, `revive`, `end`) back into the final
  `RunState`, refusing any move the run couldn't have made. This is what a server will check a score
  with.
- **Tunable.** Every number a designer would tune lives in the immutable `RunConfig`, whose values
  are `defaultConfig`: the rounds' targets, pieces and stones, chips per cleared cell, revives, offers,
  and each joker's numbers (`JokerTuning`, which every joker hook is handed). No rule
  hard-codes one, so editing `defaultConfig` changes the bot's table with no other edit. This is
  what Remote Config will feed.
- **Balance bot.** `tool/balance_bot.dart` plays seeded runs with `lib/src/bot/`'s greedy policy
  (the best immediate score, a fixed joker build) across one isolate per core. It depends only on
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
  wire format. The schema has `version: 2`; `migrate(json)` brings an older version up to date one
  step at a time (version 1 gains the chips per cell and joker numbers it was played with), and a
  save that can't be read (corrupt, unknown version, a joker this build lacks) is treated as no
  save.
- **Resume:** Home shows Continue run while `hasSavedRun` is true, and it pushes
  `GameRoute(launch: .resume)`. `GamePage` loads the save **once** (`loadSavedRun`), before the game
  starts, and scopes it in as `resumedRunProvider`. If the save can't be loaded it plays today's
  daily, which saves nothing until the player acts. Reading it from a provider instead would reload it after
  every move, because each save refreshes `hasSavedRun`, and the reload would restart the game.

## The bottom edge

Pieces are dragged up from a tray near the bottom edge, which both platforms read as the swipe
home. Three things keep the drag in the game:

- **iOS:** `app/ios/Runner/GameViewController.swift` (the storyboard's root controller) defers the
  bottom edge's system gesture, so going home takes a second swipe. Flutter doesn't expose this.
- **Android:** `MainActivity` hides the navigation bar with transient-by-swipe behaviour on every
  window focus. A swipe from the edge then only reveals the bar.
- **Layout:** `GameWidget`'s `SafeArea` keeps at least `MediaQuery.systemGestureInsetsOf(context).bottom`
  below the tray, so a grab never starts inside the gesture zone.

## Splash & Launch Screen

App startup is two screens in one colour — the brand colour (`DSColor.primary`, the logo's ground) from the first pixel to the cross-fade into Home:

- **Native launch screen** — shown by the OS before Flutter boots. Generated by **flutter_native_splash** (an `app` dev-dependency) from `app/flutter_native_splash.yaml`; regenerate with `cd app && dart run flutter_native_splash:create`, where `android/` and `ios/` live. `image:` points at `../packages/dsm/assets/source/logo.png` — the **PNG master**, since the generator can't read webp; it scales that source ÷4, which is why the in-app logo is `1024 / 4` wide — the two match, so the hand-off shows no jump. **After every regeneration**, re-set `app/ios/Runner/Base.lproj/LaunchScreen.storyboard`'s root-view `backgroundColor` to the brand colour (`DSColor.primary` as red/green/blue floats, 0–1) — the generator writes it white, and the 1x-only `LaunchBackground` image it relies on can fail to render on Retina. It also rewrites `AndroidManifest.xml` (dropping `screenOrientation="portrait"`) and `Info.plist` — discard both diffs. **Android 12+** draws its own splash and crops the image to a circle, which cuts the wide logo, so `android_12:` points at a transparent `android12_splash_empty.png`: that splash is a plain colour and the in-app splash draws the whole logo on its first frame. (Omitting the image would show the launcher icon instead.)
- **In-app splash** — the `splash` feature (`packages/features/splash/`), a normal feature package: `SplashWidget` draws `Assets.images.logo` at full opacity over the same colour at `_logoWidth` (256pt — the ÷4 of the 1024px master, so it lands exactly where the OS drew it). Nothing fades in: the first frame is held (`deferFirstFrame`) until the logo is decoded, so the OS screen hands over to an identical one, and `SplashStateNotifier.onReady(context)` waits `_splashDuration` (1800 ms) before calling `SplashRouting.onInitialized(context)`. There is no launch work today; whatever comes (Remote Config) runs inside that wait, in the notifier, not in the widget. The notifier resolves `splashRoutingProvider` **before** the await: the widget only `read`s the notifier, so the provider can auto-dispose during the wait and a post-await `ref` would throw.
- **Route wiring** — `AppRouter` makes `SplashRoute` the `initial` route and declares the tab shell as a `CustomRoute` with `TransitionsBuilders.fadeIn`, so splash cross-fades into Home; `SplashRoutingImpl` (`app_router`) does the `replaceAll([const TabShellRoute()])`.

## Injection

There is no backend: the app makes no HTTP calls and nothing signs in. **No feature package may
depend on `firebase_analytics`, `firebase_crashlytics`, `firebase_messaging`,
`flutter_inappwebview`, `push`, `telemetry`, `url_launcher`, `ads` or `blockmancer_engine` directly** — a
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
  one case, `.home()`, until the app has screens a push can be about: add a case per `data` key the
  server sends, resolve it there, and route it in `PushOpeningsNotifier` — anything unrecognised
  still opens the app. `push`'s `receivedMessages` (pushes arriving while the app is open) is
  available for a screen that should catch up on one; nothing listens to it yet.
- **Who calls what.** Nothing asks for permission yet: the old Home owned that moment and was
  replaced by the game, and the ask returns with the daily-run notifications (`askForNotifications` is ready for
  it). `PushNotificationsRoutingImpl` (context-free: a tap arrives from the OS, not a widget)
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

## Telemetry

Firebase Analytics (automatic events only — no screen views, no custom events) and Crashlytics
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
  manifest — so nothing goes out before Dart has set the switch. No advertising id: Android
  removes the `AD_ID` permission; iOS links the full Analytics SDK but never asks for tracking
  permission, so the OS hands it an all-zero IDFA. Don't retry `FIREBASE_ANALYTICS_WITHOUT_ADID`:
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

