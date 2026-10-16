---
name: flutter-animate
description: Build accessible, testable Flutter animations in this repo. Wires Semantics correctly, uses DSM tokens, and avoids common rebuild/jank pitfalls. Use when adding or modifying animated widgets, transitions, or motion-based UX.
---

# Flutter Animate

Motion in this codebase must be: **accessible** (Semantics wired correctly), **testable** (drivable from tests), **performant** (no parent-tree rebuilds), and **token-driven** (no magic numbers).

## When to use

- Adding any animation: implicit (`AnimatedFoo`), explicit (`AnimationController`), or transition (`PageRouteBuilder`, hero, shared-axis).
- Refactoring `setState`-driven animations.
- Reviewing animations against accessibility / performance criteria.

## Decision tree

```
Need motion?
├─ Single property, single target value, lifecycle = widget lifetime?
│    → Implicit (AnimatedContainer, AnimatedOpacity, AnimatedSwitcher)
├─ Multi-step / custom timing / needs to be controllable from tests?
│    → Explicit (AnimationController + AnimatedBuilder/ListenableBuilder)
├─ Cross-route transition?
│    → AutoRoute CustomRoute with PageTransitionsTheme or HeroController
└─ Periodic background motion (loading shimmer, pulse)?
     → TickerProviderStateMixin + controller.repeat()
```

## Rules

### 1. Durations and curves are tokens, not literals

AGENTS.md §"DSM Guidelines": *"Never use raw colors or hardcoded values."* That rule extends to motion. Use durations and curves from `packages/dsm/` (or add new tokens there if missing) — never inline `Duration(milliseconds: 250)` / `Curves.easeOut` in feature code.

```dart
// ❌
AnimatedContainer(duration: const Duration(milliseconds: 250), curve: Curves.easeOut, ...)

// ✅
AnimatedContainer(duration: DsmDurations.medium, curve: DsmCurves.standard, ...)
```

If the relevant token doesn't exist yet, **add it to DSM** — don't inline.

### 2. Wrap the animated subtree in `RepaintBoundary`

An `AnimationController` that ticks every frame will repaint everything in its subtree's layer. Without `RepaintBoundary`, that bubbles into siblings and parents.

**Rule of thumb:** put the boundary at the seam between something that repaints often and something expensive that doesn't — then confirm with DevTools' *Highlight repaints* (measure; don't guess).

```dart
RepaintBoundary(
  child: AnimatedBuilder(
    animation: _controller,
    builder: (_, _) => Transform.translate(offset: Offset(_offset.value, 0), child: child),
  ),
)
```

### 3. Don't rebuild the world

```dart
// ❌ Rebuilds the entire State on every tick
@override
Widget build(BuildContext context) {
  return Transform.scale(scale: _controller.value, child: child);
}

// ✅ Rebuilds only the Transform
@override
Widget build(BuildContext context) {
  return AnimatedBuilder(
    animation: _controller,
    builder: (_, child) => Transform.scale(scale: _controller.value, child: child),
    child: _expensiveChild,
  );
}
```

Pass static children via the `child:` parameter so they aren't rebuilt per frame.

### 4. Semantics survive the animation

If the visible content meaning changes, the `Semantics` node must reflect the *current* state — not the *target* state. Wrap the destination state, not the controller value:

```dart
AnimatedSwitcher(
  duration: DsmDurations.medium,
  child: isLoggedIn
      ? Semantics(label: appSemantics.loggedInAvatar, child: const _Avatar())
      : Semantics(label: appSemantics.loginButton, button: true, child: const _LoginCta()),
);
```

Use the per-package `semantics.dart` pattern from the `/semantics` skill — never raw `Semantics()` or hard-coded strings.

Focus order should never be disrupted by an animation — test with TalkBack/VoiceOver if the animation touches focusable content.

### 5. Time

For visual timing, `AnimationController` and `Ticker` are correct (driven by the SchedulerBinding's frame clock, not wall time). Do **not** reach for `DateTime.now()` or `Kronos.now()` inside the controller — they're for business-time logic. If you need wall-clock motion (e.g. countdown to an event start time), compute the *target* with `Kronos.now()` and feed the resulting `Duration` into the controller.

```dart
// ❌
final delta = DateTime.now().difference(eventStart);

// ✅
final delta = Kronos.now().difference(eventStart);
_controller.duration = delta.isNegative ? Duration.zero : delta;
```

### 6. Disposal

Every `AnimationController` must be disposed.

```dart
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
```

Lint catches the obvious cases; conditionally-created controllers slip through.

## Testing animations

Animations are testable with `WidgetTester.pump(duration)`. Use **`givenWidget`** (AGENTS.md §"Widget tests"):

```dart
givenWidget(
  'a fade-in banner',
  (_) => const Banner(message: 'Hello'),
).when(
  'half the entrance duration has elapsed',
  (tester, _) async {
    await tester.pump();
    await tester.pump(DsmDurations.medium ~/ 2);
  },
).then(
  'the banner is partially visible',
  (_, tester) {
    final opacity = tester.widget<FadeTransition>(find.byType(FadeTransition)).opacity.value;
    opacity.should.beGreaterThan(0.0);
    opacity.should.beLessThan(1.0);
  },
);
```
## Anti-patterns

| Don't | Do |
|---|---|
| `setState` from `controller.addListener` for every tick | `AnimatedBuilder` / `ListenableBuilder` |
| `Future.delayed(...).then(setState)` for sequencing | `AnimationController` with `TweenSequence` |
| `Opacity` on a moving widget | `FadeTransition` |
| `ClipRRect` on a moving widget | `ClipRect` with a static rect, or layered approach |
| Animate every frame even at rest | `controller.stop()` when idle |
| `Hero` on a tile that already changes between routes | Shared-element via `AutoRoute` transition + key |

## What this skill is NOT

- A guide to building bespoke physics (use `physics` Flutter package or stay declarative).
- A reason to add motion where product hasn't asked for it.
- Permission to inline durations/curves bypassing DSM.
