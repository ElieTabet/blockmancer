# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Blockmancer** — A block puzzle roguelite: place pieces, clear lines, and build joker combos that change how every run plays. Climb the world map, beat bosses, and compete in a daily run with the same pieces for everyone.

`blockmancer` is a Flutter cross-platform mobile application structured as a **Dart Pub Workspace monorepo** with Melos for script orchestration. It implements Clean Architecture with Riverpod (notifier-based presentation) and compile-time feature isolation — each feature is a standalone Dart package.

**Tech Stack:** Flutter ^3.44.0, Dart ^3.11.0, flutter_riverpod ^3.3.1, riverpod_annotation ^4.0.0, riverpod_generator ^4.0.1, freezed ^3.2.5, json_serializable ^6.8.0, build_runner ^2.13.1, dio ^5.4.0, auto_route ^11.1.0, auto_route_generator >=10.0.0 <10.5.0, mocktail ^1.0.4

## Workspace Structure

```
blockmancer/
├── app/                  # Thin runnable shell — depends only on the composition layer (imports NO feature package)
│   ├── lib/config/           # Env (dev/prod) + AppConfig (apiBaseUrl) — compile-time, app-owned
│   └── env/                  # dart-define-from-file configs: dev.json, dev_android.json, prod.json
├── packages/
│   ├── blockmancer_engine/ # The game rules — pure Dart (no Flutter, no clock, no I/O), deterministic from a seed
│   ├── shared_domain/    # Entities shared across features (AuthError) — entities only, no logic
│   ├── utilities/        # Horizontal infrastructure — no feature knowledge
│   │   ├── connectivity/     # Whether the phone has a network — the only place connectivity_plus is known
│   │   ├── external_links/   # Hands a link to the OS (browser, mail draft) — the only place url_launcher is known
│   │   ├── network/          # HttpClient contract, NetworkError hierarchy, interceptor chain + Dio impl
│   │   ├── keychain/         # Generic secure key/value storage (Keychain / Keystore)
│   │   ├── push/             # FCM + local notifications behind PushMessaging — the only place firebase_messaging is known
│   │   ├── result/           # Result / AsyncResult / AsyncUnitResult (over result_dart)
│   │   ├── telemetry/        # Firebase Analytics + Crashlytics behind one switch — the only place either is known
│   │   ├── timber/           # Logging facade — static Timber over pluggable Tree sinks
│   │   └── webviews/{domain,presentation}/  # webviews_domain / webviews_presentation — the only place flutter_inappwebview is known
│   ├── dsm/              # Design-system module
│   │   ├── design_system/    # Tokens (theme, colors, spacing), buttons, text fields, icons, containers
│   │   ├── assets/           # Bundled images + FlutterGen type-safe Assets accessor (webp bundled, PNG master under source/)
│   │   └── l10n/             # Localization packages
│   │       └── application/      # l10n_application — slang-generated translations (en, fr) + reactive context.t
│   ├── composition/      # Composition root — imports feature packages so the app doesn't
│   │   ├── app_router/       # app_router — app root router + concrete feature routing impls
│   │   └── app_providers/    # app_providers — aggregates cross-feature provider overrides
│   ├── ui/               # Shared, state-aware UI — riverpod and l10n aware, so not design_system
│   │   └── screen_header/    # The band every main screen wears: title, organization line, session control
│   ├── plugins/          # Dev tooling packages
│   │   └── custom_lints/     # Native analyzer-plugin — alphabetical-ordering lints + quick-fixes (IDE-only)
│   └── features/         # Feature packages, split by layer
│       ├── app_settings/{domain,data}/           # app_settings_* — organization name + contact email from GET /settings, fetched by splash, cached in the keychain (no UI)
│       ├── app_status/{domain,data,presentation}/ # app_status_* — force update / optional update / maintenance, on launch and foreground
│       ├── auth/{domain,data}/                   # auth_domain / auth_data — login, token storage, token source (no UI)
│       ├── device/{domain,data}/                 # device_domain / device_data — this install's identity and telemetry (no UI)
│       ├── home/presentation/                    # home_presentation — the first tab: a placeholder for the app's main screen
│       ├── push_notifications/{domain,presentation}/ # push_notifications_* — the permission ask, token sync, and where a tapped push leads (no screens)
│       ├── splash/presentation/                  # splash_presentation — app entry + the cold-start contract
│       └── login/{domain,presentation}/          # login_domain / login_presentation (reference implementation)
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

# Run dart analyze across all packages
melos run analyze

# Regenerate the native launch screens after editing flutter_native_splash.yaml
# (re-set the iOS storyboard backgroundColor to the brand colour afterwards — see Splash & Launch Screen)
dart run flutter_native_splash:create

# Run the app against a configured environment (wraps --dart-define-from-file)
melos run flavor-dev            # local dev API — iOS simulator, macOS, host
melos run flavor-dev-android    # local dev API from an Android emulator (10.0.2.2, not localhost)
melos run flavor-prod           # production

# Run the app with no environment configured — AppConfig falls back to the local dev API
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
- `claude: feat(auth): add login screen`
- `claude: fix(api): handle null response`

## Architecture

- **Monorepo:** Dart Pub Workspace — each package has `resolution: workspace`; root `pubspec.yaml` discovers members via globs under `workspace:` (`app`, `packages/*`, `packages/dsm/*`, `packages/dsm/l10n/*`, `packages/composition/*`, `packages/plugins/*`, `packages/utilities/*`, `packages/utilities/**/*`, `packages/features/**/*`). New packages are picked up automatically — no manual registration. The two utilities globs coexist because most utilities are flat (`network`, `keychain`) while a layer-split one (`webviews/{domain,presentation}`) sits a level deeper; `**/*` needs two segments, so it matches only the deeper ones and the flat glob's hit on the bare `webviews/` directory is ignored, exactly as `packages/dsm/*` already ignores `l10n/`.
- **Dependency overrides:** the root `pubspec.yaml` pins `analyzer: 10.2.0` (plus `dart_style: 3.1.7`, `riverpod_analyzer_utils: 1.0.0-dev.10`) via `dependency_overrides` so the `custom_lints` analyzer-plugin can coexist with `riverpod_generator`'s conservative `analyzer ^9.0.0` cap. Mirrors flutter-front.
- **Feature layering:** each feature is split into layer packages `<feature>_domain`, `<feature>_data`, `<feature>_presentation` under `packages/features/<feature>/`. Layer boundaries are enforced at compile time by each package's declared deps. Layers a feature doesn't need are simply absent — `auth` has no `_presentation` (no UI), `login` has no `_data` (its data work is `auth`'s).
- **Composition layer:** `packages/composition/` holds the composition root — `app_router` (app root router `AppRouter` aggregating feature routes, plus the concrete `<Feature>RoutingImpl` classes and `routingOverrides()`) and `app_providers` (`appOverrides()` aggregating the routing binds for the app's root container). The composition packages import the feature packages; the `app` depends only on composition, so it imports no feature package. Dependency direction: `app → composition → features`.
- **Package internals:** the public API of every package is its barrel `lib/<pkg>.dart`; all implementation lives under `lib/src/`. Each package carries `lib/src/package_name.dart` (`const packageName = '<pkg>';`). Providers follow [providers](.claude/rules/providers.md): `providers.br.dart` holds this package's own `@riverpod` providers **and** its `bindProviders(...)` helper, `providers_di.br.dart` holds inbound slots that throw until overridden, and `providers_internal.br.dart` holds layer-internal ones. Never both `providers.br.dart` and `providers.dart` in one package.
- **Melos v7+:** Scripts defined in `pubspec.yaml` under `melos:` key — no separate `melos.yaml` file
- **Workspace deps:** Intra-package dependencies declared as `package_name: any` — no `path:` overrides needed
- **Centralized versions:** the root `pubspec.yaml` is the single source of dependency versions, declared under Melos `command.bootstrap`. `dart run melos bootstrap` stamps each version into the packages (external deps carry the version; internal/workspace deps stay `any`). Never hand-manage a package-level version. See `.claude/rules/dependencies.md`.
- **Layers:** presentation → domain ← data (dependencies flow inward only; `<feature>_data` and `<feature>_presentation` depend on `<feature>_domain`; `<feature>_presentation` also depends on `design_system`)
- **State management:** Riverpod with `@riverpod` codegen — presentation notifiers are `@riverpod class <Name>Notifier extends _$<Name>Notifier`, one per screen under `notifiers/`
- **Code generation:** `@riverpod` (providers), auto_route (route classes), freezed (immutable models), json_serializable (DTOs) — all via build_runner. Generated files use `.g.dart` (riverpod) and `.gr.dart` (auto_route) suffixes. **slang localization is the exception** — generated by the `dart run slang` **CLI**, not build_runner (its build_runner integration writes in a post-process phase that runs *after* riverpod, so a same-package `@riverpod` provider could never see slang's types). `melos run generate` runs slang first (`generate-i18n`) then build_runner (`generate-build-runner`).
- **File naming:** Source files use `.br.dart` suffix (e.g. `login_notifier.br.dart`); generated files use `.br.g.dart` or `.br.gr.dart`
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
    │   ├── <feature>_router.br.gr.dart    # Generated: route classes (e.g. LoginRoute)
    │   └── <feature>_routing.dart         # abstract interface class <Feature>Routing — on<Action>Requested(BuildContext)
    ├── notifiers/
    │   ├── <name>_notifier.br.dart        # @riverpod <Name>Notifier — owns navigation; passes BuildContext to the routing interface
    │   └── <name>_notifier.br.g.dart      # Generated: <name>Provider (riverpod_generator strips the Notifier suffix)
    └── widgets/
        └── <name>_widget.dart             # ConsumerWidget — class <Name>Widget — the screen UI (no @RoutePage)
```

The `@RoutePage` page class lives in the **router** file and is a thin wrapper that returns the screen widget — the widget itself carries no routing annotation. Intra-package imports reference `package:<feature>_presentation/src/...`; external packages import only the barrel.

Example (`login`, in `packages/features/login/presentation/lib/src/`):
- `routing/login_router.br.dart` — `@AutoRouterConfig() abstract class LoginRouter extends RootStackRouter {}` (an empty codegen anchor — auto_route generates the `LoginRoute` from the `@RoutePage`; the actual route table is declared once by `AppRouter` in the composition layer, never per feature), **plus** `@RoutePage(name: 'LoginRoute') final class LoginPage extends StatelessWidget` whose `build` returns `const LoginWidget()`, **plus** `enum LoginRoutePath { login('/login') }` (the route's path — root-level routes must start with `/`)
- `routing/login_routing.dart` — `abstract interface class LoginRouting {}` — no destinations yet; `splash` shows the shape with a method
- `notifiers/login_notifier.br.dart` — `@riverpod class LoginNotifier extends _$LoginNotifier`
- `widgets/login_widget.dart` — `final class LoginWidget extends ConsumerWidget` (screen UI)

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
    AutoRouter.of(context).replaceAll([const LoginRoute()]);
  }
}
```

`app_router` also owns the app root router `AppRouter` (`@AutoRouterConfig RootStackRouter implements AutoRouteGuard`, aggregating each feature's `AutoRoute` with its path from the feature's `<Feature>RoutePath` enum, e.g. `AutoRoute(path: SplashRoutePath.splash.path, page: SplashRoute.page, initial: true)`) and exposes `routingOverrides()` — which calls every feature's `bindRoutingProviders(...)` — alongside `featureBindingOverrides()`, the same aggregation for non-routing cross-feature contracts (empty until a feature exposes one). `app_providers.appOverrides()` spreads both; the thin `app` applies it at startup:

```dart
// app/lib/application/application.dart — imports composition (+ design_system for the theme,
// l10n_application for localization), no feature package.
// boot():   LocaleSettings.useDeviceLocaleSync();   // resolve initial locale from the device
_container = ProviderContainer(overrides: appOverrides());
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
- **Reactive access via `context.t`:** the app is wrapped once in slang's `TranslationProvider` (an `InheritedWidget`); widgets then read strings with the generated `context.t` extension — `Text(context.t.login.title)` — and rebuild automatically when the locale changes. This is slang's native reactivity; there is **no** Riverpod provider wrapping translations.
- **Locale lifecycle:** the initial locale is resolved from the device in `boot()` via `LocaleSettings.useDeviceLocaleSync()`. `MaterialApp.router` sets `locale: TranslationProvider.of(context).flutterLocale`, `supportedLocales: AppLocaleUtils.supportedLocales`, and `localizationsDelegates: GlobalMaterialLocalizations.delegates` (from `flutter_localizations`). Switch at runtime with `LocaleSettings.setLocaleSync(AppLocale.fr)` — every `context.t` rebuilds. (There is intentionally no locale-switcher UI or Riverpod locale controller yet; add one wired to a real caller when needed.)
- **Central versions:** `slang` and `slang_flutter` live in the root `melos.command.bootstrap` like every other dependency.

## Game engine

`packages/blockmancer_engine` holds every game rule: board, pieces, scoring, jokers and the run
state machine. The rules are specified in `.claude/doc/BLOCKMANCER_BRIEF.md`. The UI animates the
engine's events and never recomputes a rule.

- **Pure Dart.** Its pubspec declares no Flutter, so a `package:flutter` import fails
  `melos run analyze` (`depend_on_referenced_packages` under `--fatal-infos`). The brief's
  `import_lint` isn't used because no version resolves against the pinned analyzer 10.2.0.
- **Deterministic.** No `DateTime.now()`, no `dart:math` `Random`, no I/O. Randomness is the
  engine's own mulberry32 over 32-bit arithmetic, so a seed gives the same run on the VM and on the
  web. Callers pass the date in for a daily seed.
- **Tests** use `package:test` rather than `flutter_test`, and run on the VM (`melos run test`) and
  in Chrome (`melos run test-engine-web`).

## Splash & Launch Screen

App startup is two screens in one colour — the brand colour (`DSColor.primary`, the logo's ground) from the first pixel to the login cross-fade:

- **Native launch screen** — shown by the OS before Flutter boots. Generated by **flutter_native_splash** (an `app` dev-dependency) from `app/flutter_native_splash.yaml`; regenerate with `cd app && dart run flutter_native_splash:create`, where `android/` and `ios/` live. `image:` points at `../packages/dsm/assets/source/logo.png` — the **PNG master**, since the generator can't read webp; it scales that source ÷4, which is why the in-app logo is `1024 / 4` wide — the two match, so the hand-off shows no jump. **After every regeneration**, re-set `app/ios/Runner/Base.lproj/LaunchScreen.storyboard`'s root-view `backgroundColor` to the brand colour (`DSColor.primary` as red/green/blue floats, 0–1) — the generator writes it white, and the 1x-only `LaunchBackground` image it relies on can fail to render on Retina. It also rewrites `AndroidManifest.xml` (dropping `screenOrientation="portrait"`) and `Info.plist` — discard both diffs. **Android 12+** draws its own splash and crops the image to a circle, which cuts the wide logo, so `android_12:` points at a transparent `android12_splash_empty.png`: that splash is a plain colour and the in-app splash draws the whole logo on its first frame. (Omitting the image would show the launcher icon instead.)
- **In-app splash** — the `splash` feature (`packages/features/splash/`), a normal feature package: `SplashWidget` draws `Assets.images.logo` at full opacity over the same colour at `_logoWidth` (256pt — the ÷4 of the 1024px master, so it lands exactly where the OS drew it). Nothing fades in: the first frame is held (`deferFirstFrame`) until the logo is decoded, so the OS screen hands over to an identical one, and `SplashStateNotifier.onReady(context)` waits `_splashDuration` (1800 ms) before calling `SplashRouting.onInitialized(context)`. The fixed delay is a placeholder for real startup work (auth check, remote config) — replace it there, not in the widget. The notifier resolves `splashRoutingProvider` **before** the await: the widget only `read`s the notifier, so the provider can auto-dispose during the wait and a post-await `ref` would throw.
- **Route wiring** — `AppRouter` makes `SplashRoute` the `initial` route and declares `LoginRoute` as a `CustomRoute` with `TransitionsBuilders.fadeIn`, so splash cross-fades into login; `SplashRoutingImpl` (`app_router`) does the `replaceAll([const LoginRoute()])`.

## Network, Storage & Auth

Three horizontal packages sit outside the feature UI tree. **No feature package may depend on `dio`,
`firebase_analytics`, `firebase_crashlytics`, `firebase_messaging`, `flutter_inappwebview`,
`keychain`, `network`, `push`, `telemetry`, `url_launcher`, or `auth` directly** — a feature declares a contract and the composition layer injects the
implementation, exactly as it does for routing.

**`packages/utilities/network`** — transport-agnostic contract plus a Dio implementation:

- `HttpClient` (`get`/`post`/`put`/`patch`/`delete`, plus `downloadBytes` for the one endpoint that
  answers with `application/octet-stream` and carries its key/size in headers).
- A sealed `NetworkError` hierarchy. `data` carries the *decoded* body, so a caller can read the
  API's `{"error": "<code>"}` envelope without re-parsing. A 403 maps to `NetworkClientError`;
  `NetworkForbiddenError` means "this session cannot be refreshed" and is raised only by
  `AuthNetworkInterceptor`.
- A three-phase (`onRequest`/`onResponse`/`onError`) interceptor chain with an error-phase `retry`.
  `AuthNetworkInterceptor` uses it to attach the bearer token and, on a 401, decide between
  replaying, refreshing once, and ending the session — the branch order there is deliberate and
  covered by tests; don't shorten it.
- Two clients: `httpClientProvider` (authenticated) and `publicHttpClientProvider` (**no** auth
  interceptor). Identity-establishing calls — device registration, login, refresh — must use the
  public one. Sending a bearer token to `/auth/login` means a wrong password returns 401, which the
  interceptor reads as the session expiring, so a typo would clear stored tokens mid-login.

**`packages/utilities/keychain`** — deliberately generic secure key/value storage
(`getValue`/`setValue`/`deleteValue`), knowing nothing about tokens. Writes propagate on failure;
only callers decide whether a failure is tolerable. Mirrors flutter-front's own split: a package owns
secure storage, a feature owns what the stored value means.

**`packages/features/auth`** — `auth_domain` (the `AuthRepository` contract and the behaviors
callers actually reach — the repository is never exposed directly) and `auth_data`. It has no UI, so
there is no `auth_presentation`. The data layer follows the standard split: `AuthDataSource` owns the
wire format (endpoints, field names, `TokenPairDto.fromJson`), a mapper turns the DTO into the
entity, `KeychainAuthStore` owns the storage keys and encoding, and `AuthRepository` only
orchestrates them and maps transport failures onto `AuthError`.

**`packages/features/device`** — `device_domain` / `device_data`, also UI-less. It owns the whole
`devices/*` surface: `POST /devices/register`, `PUT /devices/me`, `DevicePlatform`, and the install's
uuid. `DeviceIdentity` is deliberately a separate contract from `DeviceRepository` — `auth` needs the
uuid so login can bind a session to a device, and routing that through the repository would close a
provider cycle, because the repository depends on auth to store the session registration mints.

**`TokenPair` lives in `shared_domain`**, for the same reason `AuthError` does: `device` mints one at
registration and `auth` stores it, and the two features may not import each other.

**`AuthError` lives in `shared_domain`**, not in `auth_domain`: `login` needs the same vocabulary to
render a failure, and per [cross-feature](.claude/rules/cross-feature.md) shared entities belong
there. That's what removes the duplicate error type and the translation layer that would otherwise
sit in composition.

`POST /devices/register` is the app's **launch handshake**, and it always answers with a token pair.
The optional `refreshToken` in the body decides whose: present a live one and the server rotates and
returns that session, owner-preserving, so a signed-in member stays a member; send nothing and it
mints a guest pair. **The client must present it** — omitting it demotes a member to guest on every
cold start, which is not something the server can protect against, because the token is what says
whose session it is.

`ensureRegistered()` (in `device`) therefore branches on the *access* token: still live, no call at
all; expired, handshake presenting the refresh token; nothing stored, handshake with none. All three
end with a usable token, and the device report follows in every case. Note the skip is there to avoid
a pointless call, **not** to protect the session — an earlier guard did that, and the reason it
existed is gone.

`refreshToken()` returns `null` until `/auth/refresh` is built, so any 401 is treated as a fully
expired session rather than being refreshed transparently.

### How a feature reaches any of this

It doesn't — it declares a contract and composition binds it, so features stay isolated:

- **The slot lives where it is consumed.** `login_presentation` declares `LoginFun`;
  `splash_presentation` declares `PrepareDeviceFun` and `HasValidSessionFun` and turns them into a
  the verdict itself. Neither imports `auth`, `device`, `network` or `keychain` — and neither
  names their vocabulary: splash's slots are a `Future<void>` and a `bool` precisely so no other
  feature's error type reaches it.
- **`auth` and `device` bind into each other**, one of two mutual pairs (the other is `device` and
  `push_notifications`). device asks auth to *store* the
  session registration mints; auth asks device *who this install is*. Both crossings are slots in
  `featureBindingOverrides()`; neither package imports the other.
- **`app_providers`' `featureBindingOverrides()` is the only place both halves are known**, and it
  is pure wiring: it says which function fills which slot and nothing else. Any decision — combining
  results, mapping an error, choosing an outcome — belongs to the package that owns the meaning.
  `app_router` binds routing only.
- Every package's binding helper is named `bindProviders(...)`; callers import with a prefix
  (`login_ui.bindProviders(...)`). Routing keeps its own `bindRoutingProviders(...)`.
- **A failure a caller must handle is a return value, not an exception.** `AuthRepository` returns
  `AsyncResult<TokenPair, AuthError>` / `AsyncUnitResult<AuthError>` from
  [result](packages/utilities/result); the notifier `fold`s it. Exceptions stay for the genuinely
  exceptional. Note `riverpod` exports an `AsyncResult` of its own — import it
  `hide AsyncResult` wherever both are in scope.
- **Data sources and repositories log through `Timber`**, never the payload: no password, no token,
  no email, no raw body reaches a log line. Failures log at `Timber.e`. Nothing is planted in
  release, so every call is a no-op there; `boot()` plants a `DebugTree` under `kDebugMode`.

**`app/lib/config`** — `Env { dev, prod }` and `AppConfig { apiBaseUrl, env }`, built by
`AppConfig.fromEnvironment()` from `const String.fromEnvironment`, so values resolve at compile time
with no wiring. Pass them with `--dart-define-from-file=env/<flavor>.json` (see the `flavor-*` melos
scripts). With no flag — including every `flutter test` run — it falls back to the local dev API
rather than an empty string, which would otherwise fail deep inside Dio.

This is **not** a package: the app is the only thing that reads it. `boot()` calls
`appOverrides(apiBaseUrl: AppConfig.fromEnvironment().apiBaseUrl)`, so composition takes the base URL
as a value and stays agnostic of how configuration is shaped — the same property `network` has. A
package would also have to be imported by `app_providers`, which the app depends on: a cycle.

`app/env/dev_android.json` exists because an Android emulator resolves `localhost` to itself; the
host is reachable at `10.0.2.2`. Cleartext `http://` on Android may additionally need a
`usesCleartextTraffic` / network-security-config change, which must not ship in a prod manifest.

## App status

`packages/features/app_status` answers *what this build may do*, from
`GET /mobile/v1/app-status?platform=ios|android&version=<x.y.z>` — `ok`, `optional_update`,
`force_update` or `maintenance`. The contract is the backend's (`openapi.yaml`, AppStatus):

- **When it is asked:** on every launch, **before** `/devices/register` — splash's `CheckAppStatusFun`
  slot, a bool so splash never learns the vocabulary — and on every return to the foreground
  (`AppStatusNotifier`'s `AppLifecycleListener`). One check at a time.
- **A failed check is `ok`.** No network, a 5xx, a timeout: the app carries on. An outage of this
  one endpoint must never brick it. That rule, and "an offer already
  turned down for this version is `ok`", live in `CheckAppStatusBehavior`.
- **Blocking covers everything.** `maintenance` and `force_update` `replaceAll` the root stack with
  their screen (`AppStatusRoutingImpl`, context-free like `SessionRoutingImpl`) — whatever is open —
  and swallow back. Lifting a block restarts at the splash — faded in over the block, not pushed (the
  splash is a fade `CustomRoute`) — because the launch work the block cut short is exactly what the
  splash runs.
- **Maintenance mid-session:** any call answering 503 `{"error":"maintenance"}` is reported by
  `network`'s `MaintenanceNetworkInterceptor` (on both clients) through the `networkMaintenance` slot,
  and shows the same screen. The error still travels on, so callers fail as before. The slot is a no-op
  when unbound. The server's `message` is plain text and rendered as text.
- **Optional update:** a `DSPopup` naming `latestVersion`, never over the splash or a blocking screen.
  "Later" (or dismissing) is remembered per version in the keychain; "Update" is not, so the next launch
  offers it again. Offered at most once per session.
- **Store links** come from the build: Android's package name (`PackageInfo`), and iOS's
  `IOS_APP_STORE_ID` dart-define (`AppConfig.iosAppStoreId`), set in `env/prod.json` and
  `env/dev.json` once Apple assigns one, giving `https://apps.apple.com/app/id<id>`. The update-required screen's
  "Update" is the offer's button and always shown; with no listing it does nothing, exactly as the
  offer's does.
- The check uses the **public** client: there may be no token yet, and a dead one must not turn the
  check into a session-expired hand-off.

## App settings

`packages/features/app_settings` (domain + data, no UI) owns what the organization sets for the app:
its name, its Contact us address and the sign-in screen's title and subtitle, from `GET /settings`.
The route wants a token — a guest's will do — so splash calls `refreshSettings` **after**
`prepareDevice`, inside the same 1800 ms wait; a failure never blocks the launch.

- `AppSettingsNotifier` (keepAlive) is seeded from the last answer, stored as JSON in the keychain,
  so an offline launch still names the organization. A failed fetch keeps what is showing.
- A blank name or sign-in line is `null` by the time it leaves the data layer, and `null`
  everywhere means "show nothing": no header subtitle, no title or subtitle line on sign-in. The contract gives the sign-in text no fallback, so the app
  ships none.
- Consumers never import it. `screen_header` declares a `String? organizationName` slot,
  `login_presentation` declares
  `loginTitle` / `loginSubtitle`, and composition points them at `app_settings_domain`'s
  projections. Each is watched by the leaf that draws it — the header's `OrganizationLine`, the
  login screen's title and subtitle — so the subscription never sits in the screen.

## Push notifications

The backend sends FCM *notification* messages (title, body, string `data`) and learns each install's
token from `PUT /devices/me {fcmToken}`. Three packages share the client side, and only one knows
Firebase:

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
- **Who calls what.** Home owns the *moment* to ask (`HomeStateNotifier.onShown`, the first screen
  a guest and a member share); `device` owns the *report* and starts the token
  sync only once registration lets a report authenticate — device and push_notifications bind into
  each other, a second mutual pair. `PushNotificationsRoutingImpl` (context-free, like
  `AppStatusRoutingImpl`) waits out the splash, login and the blocking screens, then dismisses
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
  the app's Firebase project, which must be the project the backend's service account belongs to.
  The template ships placeholders; the generator copies in the real files.
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
  time. Today that is the update offer (`AppStatusRouting.onUpdateOffered`); a consent question,
  if one is added, belongs there too.

## Webviews

`packages/utilities/webviews` is the only place `flutter_inappwebview` is known. It is **layer-split
like a feature** — `webviews_domain` / `webviews_presentation` under one directory — because the
declarative half is engine-agnostic and worth testing without a platform view, while only the widget
half touches the plugin. That split is why the workspace globs carry `packages/utilities/**/*`.

Unlike `network` and `keychain`, a feature reaches this one **directly**: a `<feature>_presentation`
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

The `login` feature (`packages/features/login/`) is the reference implementation; `splash` (`packages/features/splash/`) shows the same pattern for a screen whose only job is a routing hand-off, and `auth` (`packages/features/auth/`) shows a capability feature with no UI at all. The scaffolding script lives at `scripts/create_package.sh`.

**A new tab** follows `home` (`packages/features/home/`): a `<feature>_presentation` with a relative `<Feature>RoutePath`, one `AutoRoute` child in `AppRouter._tabConfiguration`, and one entry in each of `TabShellPage._routes` and `_destinationsOf`. The bar appears by itself with the second tab. Replace Home with the app's real main screen rather than keeping both: it is a placeholder, and its only behaviour worth keeping is the notification ask on first show.

## Claude agents and skills

`.claude/` ships with the app, so every app made from this template starts with the same crew:

- **`flutter-developer`** — implements a feature or a brief the way the workspace is built, and hands back green analyze and tests.
- **`architecture-reviewer`** — layering, DI slots, generated-file and dependency discipline. Run after any change under `packages/`, and before a commit.
- **`qa-reviewer`** — runs the suite and hunts for untested error paths against the API contract.
- **`security-reviewer`** — token storage, what reaches a log or a crash report, WebView hardening, push payloads.
- **`brief-verifier`** — walks a brief in `.claude/plans/` against the real code.
- **Skills:** `develop-feature` (the step-by-step for a new feature), `flutter-expert-engineering` (general discipline plus the backend contract), `flutter-debug`, `flutter-animate`.

