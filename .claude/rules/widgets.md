# Widgets: Class over Function

Prefer a **widget class** (`StatelessWidget` / `ConsumerWidget`) over a **helper that
returns a `Widget`** (`Widget _buildX(...)`).

This is **not** because a helper is slower by default — the widgets it returns get their
own `Element`s and reconcile normally, and a class the parent re-creates with fresh args
every `build` rebuilds just as much as a helper would. Prefer a class because it's the
natural shape for the things that actually matter:

- **It can own its state / provider subscription.** A `ConsumerWidget` that `watch`es its own
  providers (or a `StatefulWidget` that owns its state) confines that rebuild to itself. The
  same `ref.watch` / `setState` inside a helper rebuilds the **whole parent** — a helper has
  nowhere to put a subscription but the parent. This is the real rebuild win.
- **It can be `const`.** Flutter skips updating a subtree when handed the same instance as last
  frame, and a `const` widget is that same instance. A class makes a `const` call site natural.
  (What matters is instance identity, not class-vs-helper — a helper returning a `const` widget
  gets the same skip; value-equal args don't, a `StatelessWidget` is not memoized.)
- **It has its own `BuildContext`**, at its real spot in the tree — correct for `InheritedWidget`
  lookups (`Theme.of`, provider scopes). A helper borrows the parent's context.
- **It's visible in DevTools** as a named node in the widget tree and rebuild profiler; a helper
  is invisible, so you can't see or profile it.

## Rules

- **New UI fragment → a widget class**, especially if it holds state, watches a provider, can be
  `const`, or sits on a rebuild-heavy path (lists, animated subtrees). Keep widgets small, focused,
  atomic, and `const` when possible.
- Reserve the **`_build` prefix for test data builders**, not UI helpers.
