---
name: develop-feature
description: Use when adding a new feature to this monorepo — scaffolding the domain/data/presentation layer packages and implementing the full pattern (freezed sealed errors + domain behaviors, freezed UI state, StateNotifier, routing interface + DI slot, l10n, and composition-layer wiring). Mirrors the `login` reference feature.
---

# Develop a New Feature

This skill reproduces the architecture used by the **`login`** reference feature
(`packages/features/login/`). Read that feature alongside this skill — it is the
canonical example; when in doubt, copy its shape exactly.

Always obey the repo rules while doing this — especially
[dependencies](../../rules/dependencies.md), [formatting](../../rules/formatting.md)
(never hand-manage commas/versions), [riverpodify-ui](../../rules/riverpodify-ui.md),
[widgets](../../rules/widgets.md), [cross-feature](../../rules/cross-feature.md),
[dart-dot-shorthands](../../rules/dart-dot-shorthands.md), and
[comments](../../rules/comments.md). Do **not** update docs (CLAUDE.md, etc.) unless
explicitly asked. Do **not** commit unless explicitly asked.

## Naming conventions (memorise these)

- `<feature>` = snake_case (e.g. `patient_booking`), `<Feature>` = PascalCase (`PatientBooking`), `<Screen>` = the screen name.
- Three layer packages: `<feature>_domain`, `<feature>_data`, `<feature>_presentation` under `packages/features/<feature>/`.
- Handwritten source that anchors codegen: `.br.dart`. Generated: `.br.g.dart` (riverpod), `.br.gr.dart` (auto_route), `.br.freezed.dart` (freezed).
- Presentation notifiers are **suffixed `StateNotifier`**: `class <Screen>StateNotifier extends _$<Screen>StateNotifier` → provider becomes `<screen>StateProvider` (riverpod strips the trailing `Notifier`).
- Public API of each package is its barrel `lib/<pkg>.dart`; everything else lives under `lib/src/`. Intra-package imports use `package:<pkg>/src/...`; external packages import only the barrel.

## Dependency direction

`app → composition (app_router / app_providers) → features`. A feature layer imports
only what its `pubspec.yaml` declares. **Never** import one feature from another —
coordinate through the composition layer (see [cross-feature](../../rules/cross-feature.md)).
`<feature>_presentation → <feature>_domain ← <feature>_data`; presentation also depends on
`design_system`, `l10n`, and (if it renders assets) `assets`.

---

## Step 1 — Scaffold the three packages

```bash
melos run create -- --name <feature> --type feature
```

This creates `packages/features/<feature>/{domain,data,presentation}` (three packages),
each with a barrel, `lib/src/package_name.dart`, and the provider trio
(`providers.dart`, `providers_di.br.dart`, `providers_internal.br.dart`). It is
auto-discovered by the workspace globs — no manual registration. Then fill in the layers
below.

## Step 2 — Domain (`<feature>_domain`)

Pure business rules. No Flutter, no l10n, no riverpod UI — errors are **semantic**
(sealed unions), and the presentation layer maps them to strings.

**a) One freezed sealed error union per field/concern** — `lib/src/entities/errors/<x>_validation_error.br.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part '<x>_validation_error.br.freezed.dart';

@freezed
sealed class <X>ValidationError with _$<X>ValidationError {
  const factory <X>ValidationError.empty() = Empty<X>ValidationError;
  const factory <X>ValidationError.tooLong() = TooLong<X>ValidationError;
  // one variant per distinct failure
}
```

**b) A behavior = a callable class** — `lib/src/behaviors/<verb>_<x>_behavior.dart`.
`const` constructor, injected deps as fields, a single `call(...)` returning the domain
result (an error union `?`, or a value). No side effects beyond computing the result.

```dart
import 'package:<feature>_domain/src/entities/errors/<x>_validation_error.br.dart';

/// Validates X. Returns null when valid.
class Validate<X>Behavior {
  const Validate<X>Behavior();

  final _maxLength = 255;

  <X>ValidationError? call(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return const <X>ValidationError.empty();
    if (v.length > _maxLength) return const <X>ValidationError.tooLong();
    return null;
  }
}
```

**c) Expose each behavior as a `…Fun` provider** — `lib/src/providers.dart`:

```dart
import 'package:<feature>_domain/src/behaviors/<verb>_<x>_behavior.dart';
import 'package:<feature>_domain/src/entities/errors/<x>_validation_error.br.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

typedef Validate<X>Fun = <X>ValidationError? Function(String? value);

@riverpod
Validate<X>Fun validate<X>(Ref ref) => const Validate<X>Behavior().call;
```

**d) Barrel** `lib/<feature>_domain.dart` exports the error unions + `src/providers.dart`.

## Step 3 — Presentation (`<feature>_presentation`)

Layout: `src/{states,routing,notifiers,widgets,entities}/` + the provider trio. Barrel
exports `src/routing/<feature>_router.br.dart`, `src/routing/<feature>_routing.dart`,
`src/providers.dart`.

**a) UI state** — a freezed sealed union `src/states/<screen>_ui_state.br.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part '<screen>_ui_state.br.freezed.dart';

@freezed
sealed class <Screen>UiState with _$<Screen>UiState {
  const factory <Screen>UiState.content({/* screen fields, optional */}) = <Screen>UiStateContent;
  const factory <Screen>UiState.loading() = <Screen>UiStateLoading;
  const factory <Screen>UiState.error() = <Screen>UiStateError;
}
```

**b) Routing interface** — `src/routing/<feature>_routing.dart`. Methods named by
behavioural intent, each taking a `BuildContext` (the impl navigates relative to it):

```dart
import 'package:flutter/widgets.dart';

abstract interface class <Feature>Routing {
  void on<Action>Requested(BuildContext context);
}
```

**c) DI slot (throws until composition overrides)** — `src/providers_di.br.dart`:

```dart
import 'package:<feature>_presentation/src/routing/<feature>_routing.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers_di.br.g.dart';

@riverpod
<Feature>Routing <feature>Routing(Ref ref) => throw UnimplementedError(
  '<feature>RoutingProvider must be overridden by the composition layer (app_router)',
);
```

**d) Bind helper** — `src/providers.dart`:

```dart
import 'package:<feature>_presentation/src/providers_di.br.dart';
import 'package:<feature>_presentation/src/routing/<feature>_routing.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

List<Override> bindRoutingProviders({
  required <Feature>Routing Function(Ref ref) <feature>Routing,
}) => [<feature>RoutingProvider.overrideWith(<feature>Routing)];
```

**e) Router anchor + page + path** — `src/routing/<feature>_router.br.dart`. The
`@AutoRouterConfig` class is an **empty codegen anchor** (the real route table is declared
by `AppRouter` in the composition layer). The `@RoutePage` wrapper returns the screen widget:

```dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:<feature>_presentation/src/widgets/<screen>_widget.dart';

part '<feature>_router.br.gr.dart';

enum <Feature>RoutePath {
  <screen>('/<screen>');   // root-level routes must start with '/'

  const <Feature>RoutePath(this.path);
  final String path;
}

@AutoRouterConfig()
abstract class <Feature>Router extends RootStackRouter {}

@RoutePage(name: '<Screen>Route')
final class <Screen>Page extends StatelessWidget {
  const <Screen>Page({super.key});

  @override
  Widget build(BuildContext context) => const <Screen>Widget();
}
```

**f) The notifier owns all logic** — `src/notifiers/<screen>_state_notifier.br.dart`.
The widget has NO logic; it hands its `BuildContext`/form key to the notifier, which
forwards `BuildContext` straight to the routing interface (Model A). Validation delegates
to the domain `…Fun` providers.

```dart
import 'package:flutter/widgets.dart';
import 'package:<feature>_domain/<feature>_domain.dart';
import 'package:<feature>_presentation/src/providers_di.br.dart';
import 'package:<feature>_presentation/src/routing/<feature>_routing.dart';
import 'package:<feature>_presentation/src/states/<screen>_ui_state.br.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '<screen>_state_notifier.br.g.dart';

@riverpod
class <Screen>StateNotifier extends _$<Screen>StateNotifier {
  <Feature>Routing get _routing => ref.read(<feature>RoutingProvider);

  @override
  <Screen>UiState build() => const <Screen>UiState.content();

  <X>ValidationError? validate<X>(String? value) =>
      ref.read(validate<X>Provider)(value);

  void on<X>Saved(String? value) {
    if (value == null) return;
    final current = state;
    if (current is <Screen>UiStateContent) {
      state = current.copyWith(<x>: value);
    }
  }

  Future<void> on<Action>Pressed({
    required GlobalKey<FormState> formKey,
    required BuildContext context,
  }) async {
    final form = formKey.currentState;
    if (form == null || !form.validate()) return;
    form.save();

    if (state is <Screen>UiStateLoading) return;
    state = const <Screen>UiState.loading();

    try {
      // TODO: real behavior wires in with the data layer / network.
      await Future<void>.delayed(const Duration(seconds: 1));
      if (!context.mounted) return;
      state = const <Screen>UiState.content();
      _routing.on<Action>Succeeded(context);
    } catch (_) {
      state = const <Screen>UiState.error();
    }
  }
}
```

**g) Map domain errors → l10n in the presentation layer** —
`src/entities/<x>_validation_error.dart` (an extension; domain stays l10n-free):

```dart
import 'package:flutter/widgets.dart';
import 'package:l10n/i18n/strings.g.dart';
import 'package:<feature>_domain/<feature>_domain.dart';

extension <X>ValidationErrorMessage on <X>ValidationError {
  String messageOf(BuildContext context) => switch (this) {
    Empty<X>ValidationError() => context.t.<feature>.<x>Required,
    TooLong<X>ValidationError() => context.t.<feature>.<x>TooLong,
  };
}
```

**h) The screen widget** — `src/widgets/<screen>_widget.dart`. A `ConsumerWidget` (or
`ConsumerStatefulWidget` if it owns a `Form`/controllers). Follow
[riverpodify-ui](../../rules/riverpodify-ui.md): push subscriptions to the leaf, `.select`
the narrowest projection, `const` call sites, read theme/l10n/formatters in the leaf via
`ref`/`context`.

- Read actions: `ref.read(<screen>StateProvider.notifier)`.
- Watch state narrowly: `ref.watch(<screen>StateProvider.select((s) => s is <Screen>UiStateLoading))`.
- Field validators: `validator: (v) => notifier.validate<X>(v)?.messageOf(context)`; `onSaved: notifier.on<X>Saved`.
- **Stable keys:** hold `GlobalKey<FormState>` / `GlobalKey<FormFieldState<String>>` as `final`/`static final` fields, never create them in `build` — a per-build key remounts the field and wipes uncontrolled input (e.g. on a theme switch). Pass them to DS fields via `fieldKey:`.
- Use `design_system` components (`DSBgContainer`, `DSTextField`, `DSPasswordField`, `DSPrimaryButton`, `DSLabelButton`, `DSVerticalSpace`/`DSHorizontalSpace`, `DSColor`, `DSSpace`) and `assets` (`Assets.images.x.image()` — use `.image()`, never `Image.asset(x.path)` from another package).

## Step 4 — Data (`<feature>_data`)

Leave the scaffolded `datasources/`, `mappers/`, `models/`, `repositories/` empty until a
real backend call is needed (the network layer is deferred). Implement inbound DI slots via
its `providers_di.br.dart` when it exists.

## Step 5 — Localization (`l10n`)

Add a `<feature>` namespace with every key the screen/validators use to **both**
`packages/dsm/l10n/lib/i18n/en.i18n.json` and `fr.i18n.json` (a key must exist in every
locale). Never import `l10n` from a feature's domain/data — only from `*_presentation`.

## Step 6 — Composition wiring (`app_router` / `app_providers`)

The composition layer imports the feature so the feature never imports another feature.

**a) Concrete routing impl** — `packages/composition/app_router/lib/src/routing/<feature>_routing.dart`:

```dart
import 'package:flutter/widgets.dart';
import 'package:<feature>_presentation/<feature>_presentation.dart' show <Feature>Routing;

final class <Feature>RoutingImpl implements <Feature>Routing {
  const <Feature>RoutingImpl();

  @override
  void on<Action>Requested(BuildContext context) {
    assert(context.mounted, 'on<Action>Requested called with an unmounted context');
    AutoRouter.of(context).replaceAll([const <Target>Route()]);   // navigate against concrete routes
  }
}
```

**b) Register the override** — add to `routingOverrides()` in
`packages/composition/app_router/lib/src/providers.dart`:

```dart
...<feature>.bindRoutingProviders(<feature>Routing: (ref) => const <Feature>RoutingImpl()),
```

(`app_providers.appOverrides()` already spreads `routingOverrides()` — no change needed there.)

**c) Add the route** to `AppRouter.routes` in `packages/composition/app_router/lib/src/app_router.dart`:

```dart
AutoRoute(path: <Feature>RoutePath.<screen>.path, page: <Screen>Route.page),
```

**d) Declare the dep** — add `<feature>_presentation: any` to `app_router/pubspec.yaml`.

## Step 7 — Generate & verify

New external deps go in the **root** `melos.command.bootstrap` (version-less `any` in the
package) — see [dependencies](../../rules/dependencies.md). Then:

```bash
dart run melos bootstrap          # if pubspec deps changed
melos run generate                # slang (generate-i18n) then build_runner (freezed/riverpod/auto_route)
melos run analyze                 # dart analyze --fatal-infos — must be clean
melos run test                    # all packages green
```

Iterate until `analyze` and `test` are green. Add tests under each package's `test/`
(see the next section).

## Tests (Given / When / Then)

Every test body is structured in three commented phases — **`// Given`** (arrange), **`// When`**
(the single action under test), **`// Then`** (assert). Mirror the `lib/` folder layout under
`test/` (e.g. `test/behaviors/…`, `test/notifiers/…`). `mocktail` is available; hand-written
recording fakes are fine for narrow interfaces like routing.

**Domain — behavior tests** (pure, no Flutter). Instantiate the `const` behavior and assert
against the freezed error union (freezed generates `==`, so compare by value). Cover each
failure variant plus the valid case and the boundaries. Example:

```dart
test('256 characters is too long', () {
  // Given a username one character over the max length
  final username = 'a' * 256;

  // When it is validated
  final result = validate(username);

  // Then a too-long error is returned
  expect(result, const UsernameValidationError.tooLong());
});
```

**Presentation — notifier tests.** Build a `ProviderContainer` with the throwing routing slot
overridden by a recording fake (`loginRoutingProvider.overrideWithValue(fake)`), `addTearDown`
its dispose. Synchronous behaviour (initial state, validation delegation, `onSaved`) tests
directly off the container; anything needing a `BuildContext`/`Form` (navigation, submit) is a
`testWidgets` test using `UncontrolledProviderScope(container: …)`.

Three gotchas that will bite:
- **`TextFormField` needs a `Material`/`Scaffold` ancestor** — wrap the harness `Form` in a `Scaffold`, or the build assertion cascades into confusing failures.
- **`@riverpod` providers are auto-dispose** — with no watcher the provider disposes mid-async and `state = …` throws on a disposed `Ref` (in the app the watching widget keeps it alive). Hold it open in the test: `container.listen(<screen>StateProvider, (_, _) {});`.
- **Fake latency** — advance the notifier's `Future.delayed` with `await tester.pump(const Duration(seconds: 1))`, then `await` the returned future before asserting the post-delay state.

## Definition of done

- [ ] Three layer packages scaffolded; dependency direction respected (no feature→feature import).
- [ ] Domain: freezed sealed error union(s) + callable behavior(s) + `…Fun` providers; no Flutter/l10n/riverpod-UI.
- [ ] Presentation: freezed UI state; StateNotifier owns all logic; routing interface + throwing DI slot + `bindRoutingProviders`; router anchor + `@RoutePage` + `RoutePath` enum; domain→l10n error extension; leaf-subscribed `const` widgets with stable form keys.
- [ ] l10n keys added to en + fr.
- [ ] Composition: `<Feature>RoutingImpl`, registered in `routingOverrides()`, route added to `AppRouter`, dep declared.
- [ ] Tests (Given/When/Then): behavior tests per domain behavior (all variants + boundaries) and notifier tests (state, validation, save, navigation, submit).
- [ ] `melos run generate` drift-free; `melos run analyze` and `melos run test` green.
