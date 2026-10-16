---
name: flutter-debug
description: Systematically debug Flutter bugs in this repo by reproducing first, writing a failing Givn regression test in user-focused BDD language (no class/method jargon), then fixing with a preventive guard at the dereference site (not a reactive try/catch). Use whenever the user reports a bug, mentions a crash, pastes a stack trace, mentions a Sentry error, asks to investigate a flaky test, or asks to fix unexpected behavior — even when they don't say "debug".
---

# Flutter Debug

Debugging is not "stare and fix". It is: **reproduce → fail a test → guard → confirm**.

This skill exists because three failure modes appear over and over when debugging this codebase:

1. **Skipping the failing-test step** because "I'm sure I know the cause".
2. **Phrasing the test in implementation language** (`'when didPush fires before setupInitialRoutes completes'`) instead of user language. The description is for the human reading the test output, not for you recalling the implementation.
3. **Patching with a reactive try/catch** instead of a preventive guard. A `try/catch StateError` over `.first` hides the real precondition; `if (list.isEmpty) return;` documents it.

If a fix you're about to propose violates any of those, stop and revise.

---

## When to use

- The user says "X is broken", "this crashes", "wrong value shown", or pastes a stack trace.
- A Sentry error needs triage (pair with `sentry:sentry-workflow`).
- A flaky test needs root-cause analysis.

Project conventions like "no `DateTime.now()`", "no `print`/`debugPrint`", "use `package:` for cross-package imports" are enforced by AGENTS.md — this skill doesn't restate them. It focuses on the three failure modes above.

---

## The discipline

### 1. Reproduce, don't speculate

Write down:
- **Inputs**: route, provider state, user actions, device/regulation/universe flavor.
- **Expected behavior**: what AGENTS.md, the spec, or product describes.
- **Actual behavior**: frame-accurate, log-accurate.

If you can't reproduce, **stop and ask**. Speculative fixes ship bugs.

### 2. Localize backward

| Symptom | Where to look |
|---|---|
| "Wrong text on screen" | Presentation: provider value → widget → localizations |
| "API returns 500" | Data: data source → repository |
| "Logic computes wrong result" | Domain: use case / behavior |
| "State doesn't update after action" | Riverpod: notifier `update`, listener disposal, async gaps |
| "Crash with stack trace" | Topmost frame in **our** code, not in `dart:` / `package:flutter` |

The async-gap class of bugs in Riverpod V3 is especially common — see the Riverpod recipes below.

### 3. Write the failing test FIRST — in user language

Use **Givn** (`package:givn/givn.dart`). The test must:
- Fail on the current code (run it and confirm the failure before continuing).
- Reproduce the bug deterministically (no flake, no time-dependence, no shared state).
- Read like a product specification.

The third point is where debugging tests routinely break. When the bug is technical — router internals, provider lifecycle, race conditions — there's a strong pull to describe the *mechanism* in `given / when / then`. AGENTS.md forbids it. Descriptions are for the human reading the test output, not for the model recalling the implementation.

#### BDD for technical bugs — bad vs good

The left column is what you'll naturally write while you're deep in the diagnosis. The right column is what belongs in the test.

| Bad (implementation language) | Good (product language) |
|---|---|
| `given('an observer attached to a router with empty stack')` | `given('a user on FR regulation opening the app from a deep link')` |
| `when('didPush fires before setupInitialRoutes completes')` | `when('the app navigates to the deep-linked screen during cold start')` |
| `then('stackData is empty and the observer throws StateError')` | `then('the app reaches the deep-linked screen without crashing')` |
| `given('a notifier in autoDispose mode without listeners')` | `given('a user who taps "Edit bet" on a bet the bookmaker has already settled')` |
| `when('the system calls setState after the await')` | `when('the user requests the edit')` |
| `then('the provider returns null because of disposal')` | `then('the edit is rejected with a clear message')` |
| `when('the system resolves which step to display as back-navigation target')` | `when('the user taps back from the address step')` |
| `given('a route pushed into a nested router whose ancestor has no pages yet')` | `given('a user opening the app for the first time')` |

**Rule of thumb**: read the three strings aloud. If they sound like a stack trace or a class diagram, rewrite them. If they sound like a sentence a non-engineer could narrate, ship them.

**Forbidden in descriptions**: class names (`RegisterLandingPage`), method names (`didPush`, `setupInitialRoutes`, `setCompleted`), Riverpod jargon (`autoDispose`, `keepAlive`, `notifier`), router jargon (`shell route`, `observer`), and the meta-subjects "the system", "the app", "the notifier", "a consumer".

#### Example: technical bug, user-language test

```dart
group('Editing a settled bet', () {
  given(
    'a user whose bookmaker has already settled the bet they want to edit',
    (context) {
      when(context.mockOf<MockBetRepository>().fetchBet(any))
          .thenAnswer((_) async => Bet.settled(/* ... */));
      return EditBetService(context.mockOf<MockBetRepository>());
    },
    mocks: [MockBetRepository()],
  ).when(
    'the user taps the edit bet button',
    (sut, _) => sut.edit(betId: 'b-1', newStake: 10),
  ).then(
    'the edit is rejected because the bet is already settled',
    (result, _) {
      result.should.beA<EditBetFailure>();
      (result as EditBetFailure).reason.should.be(EditBetReason.alreadySettled);
    },
  );
});
```

Run it until it fails for the **right** reason — not for a typo, not for a missing mock:

```bash
flutter test test/path/to/file_test.dart --plain-name 'a user whose bookmaker has already settled the bet'
```

### 4. Fix with a preventive guard, not a reactive try/catch

When the stack trace says `Bad state: No element`, `Null check operator used on a null value`, `RangeError`, or any other dereference-on-empty-or-null, the **wrong** instinct is to wrap the call in `try/catch`. That hides the real failure mode and leaves the dereference as a latent bug.

The **right** fix is a preventive guard at the dereference site, expressing the invariant the code missed.

| Stack trace symptom | Wrong fix | Right fix |
|---|---|---|
| `Bad state: No element` from `.first` / `.single` / `firstWhere` | `try { ... .first ... } catch (StateError) { ... }` | `if (list.isEmpty) return earlyValue;` before the dereference |
| `Null check operator used on a null value` | `try { x!.foo() }` | `if (x == null) return;` or `x?.foo()` |
| `RangeError` from `list[i]` | `try-catch` | `if (i >= list.length) return;` |
| Provider returns null at runtime | catch and ignore | walk back to the missing override or async gap; fix where the null originates |

**Why this matters**: the guard documents the precondition you discovered. The catch silently swallows it. Reviewers see what the precondition is. Other call sites learn what's safe. The catch tells nobody anything and re-introduces the same bug whenever the dereference is copy-pasted.

The only acceptable use of try/catch in a debugging fix is when the boundary is genuinely outside your control (a third-party stream that can throw arbitrary exceptions) — and even then, only when you can name **which** error class you expect and what fallback is correct.

**Smallest diff wins.** The right fix is usually 1–5 lines.

### 5. Confirm

```bash
# Targeted: the regression test
flutter test test/path/to/file_test.dart

# Broader: the package (regenerate if codegen sources changed)
mise run builder --scope <package>
flutter pub global run melos run test --scope=<package>

# Full PR gate
mise run prcheck
```

The test from step 3 must now pass. If it still fails, your fix is wrong or your test was wrong. Don't proceed.

### 6. Leave a breadcrumb if the bug was hard to reproduce

A Timber log at the guard site makes the next recurrence faster to diagnose:

```dart
Timber.e(tag: 'edit-bet', logMessage: 'Edit rejected: %s for bet %s', parameters: [reason.name, betId]);
```

Never log PII or secrets.

---

## Riverpod V3 debug recipes

- **State doesn't refresh**: check `keepAlive` and that a listener exists across the await.
- **Stale value after `invalidate`**: ensure the consumer is mounted at invalidate time.
- **Provider returns null at runtime**: a `_di.br.dart` stub wasn't overridden — verify the `bindProviders(...)` site.
- **Override not picked up**: dependency-scoped provider needs `dependencies: [...]` declared.
- **AutoDispose race during `await`**: the provider has no listener; the `await` lets the autoDispose scheduler collect it. After the await, `state = …` is a no-op or replays `build()`. Either keep a listener alive across the gap or move the side effect out of the autoDispose provider.
- **Kronos-driven rebuilds**: a provider calling `ref.watch(kronosProvider)` rebuilds on every NTP tick. Use `ref.read(kronosProvider)` if you only need the value once.

## AutoRoute debug recipes

- **Tab doesn't preserve state**: missing `AutoRouter.declarative` shell or wrong `routerKey`.
- **Deep link doesn't land**: check `pendingDeepLinkProvider` and the redirect chain in `AppShellRoute`.
- **Pop returns wrong screen**: stack ordering — inspect `RoutingController.stackData`.
- **Observer crashes on cold start**: `setupInitialRoutes()` defers one frame; `stackData` can be empty when the first `didPush` fires from a nested router. Guard `isEmpty` (or short-circuit on `stackData.isEmpty`) at the dereference — do **not** wrap the traversal in try/catch.

## Sentry triage

1. Map the breadcrumb timeline to user actions.
2. Identify the topmost stack frame in **our** code.
3. Write the Givn reproduction from the breadcrumb-derived inputs — in user language (§3).
4. Apply the preventive-guard rule from §4.
5. Pair with `sentry:sentry-workflow` for PR-level context.

---

## What this skill is NOT

- A bypass for code review or AGENTS.md rules.
- A reason to skip the failing-test step. "I'm sure I know the cause" is the most common debugging failure mode.
- A place to add `@visibleForTesting` widening of APIs — use DI instead.
- A defense of try/catch as a primary fix. If the diff is mostly a `try { ... } catch (...)`, you haven't found the precondition. Go back to step 4.
- A restatement of AGENTS.md project conventions (no `DateTime.now`, no `print`/`debugPrint`, layer dependencies, etc.). Those are enforced project-wide; this skill assumes them.
